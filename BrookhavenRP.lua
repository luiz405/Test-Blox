local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local gameMode = nil
local noclipConn, flyConn, flyBody, flyGyro
local NoclipOn = false
local FlyOn = false
local InvisOn = false
local EspOn = false
local ESPObjects = {}
local espColor = Color3.new(1, 0, 0)
local EspUpdateConn = nil
local implacavelConn = nil
local intangivelConn = nil
local Camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "HubSelector"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local function Notify(txt)
    pcall(function() StarterGui:SetCore("SendNotification", { Title = "Hub", Text = txt, Duration = 3 }) end)
end

local function GetChar()
    return LP.Character or LP.CharacterAdded:Wait()
end
local function GetHRP()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ============================================================
-- CLEANUP
-- ============================================================
local function Cleanup()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBody then flyBody:Destroy(); flyBody = nil end
    if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    if EspUpdateConn then EspUpdateConn:Disconnect(); EspUpdateConn = nil end
    if implacavelConn then implacavelConn:Disconnect(); implacavelConn = nil end
    if intangivelConn then intangivelConn:Disconnect(); intangivelConn = nil end
    for _, obj in pairs(ESPObjects) do
        for _, d in pairs(obj) do pcall(function() d:Remove() end) end
    end
    ESPObjects = {}
    NoclipOn = false; FlyOn = false; InvisOn = false; EspOn = false
end

-- ============================================================
-- DRAWING ESP
-- ============================================================
local function ClearESP()
    for _, obj in pairs(ESPObjects) do
        for _, d in pairs(obj) do pcall(function() d:Remove() end) end
    end
    ESPObjects = {}
end

local function UpdateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            if not ESPObjects[plr] then
                local b = Drawing.new("Quad")
                b.Thickness = 1.5; b.Color = espColor; b.Filled = false; b.Visible = false
                local n = Drawing.new("Text")
                n.Size = 14; n.Color = Color3.new(1, 1, 1); n.Center = true; n.Outline = true; n.OutlineColor = Color3.new(0, 0, 0); n.Visible = false
                ESPObjects[plr] = { box = b, name = n }
            end
            local obj = ESPObjects[plr]
            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if char and root and hum and hum.Health > 0 then
                local head = char:FindFirstChild("Head")
                local leg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftFoot")
                local topP = head and (head.Position + Vector3.new(0, 0.5, 0)) or root.Position + Vector3.new(0, 2, 0)
                local botP = leg and (leg.Position - Vector3.new(0, 0.5, 0)) or (root.Position - Vector3.new(0, 3, 0))
                local t2d, tOn = Camera:WorldToScreenPoint(topP)
                local b2d, bOn = Camera:WorldToScreenPoint(botP)
                if tOn and bOn then
                    local h = math.abs(t2d.Y - b2d.Y)
                    local w = h * 0.6
                    local tl = Vector2.new(t2d.X - w/2, t2d.Y)
                    local tr = Vector2.new(t2d.X + w/2, t2d.Y)
                    local bl = Vector2.new(b2d.X - w/2, b2d.Y)
                    local br = Vector2.new(b2d.X + w/2, b2d.Y)
                    obj.box.Points = { tl, tr, br, bl }; obj.box.Visible = true
                    obj.name.Position = tl - Vector2.new(0, 16); obj.name.Text = plr.Name; obj.name.Visible = true
                else
                    obj.box.Visible = false; obj.name.Visible = false
                end
            else
                obj.box.Visible = false; obj.name.Visible = false
            end
        end
    end
end

-- ============================================================
-- UI BUILDER
-- ============================================================
local function MakeMenu(title, color)
    Cleanup()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 380)
    frame.Position = UDim2.new(0.5, -160, 0.5, -190)
    frame.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke"); s.Color = color; s.Thickness = 1.5; s.Transparency = 0.3; s.Parent = frame

    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1, 0, 0, 34)
    hdr.BackgroundColor3 = Color3.fromRGB(10, 10, 18); hdr.BorderSizePixel = 0; hdr.Parent = frame
    Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 8)
    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -50, 1, 0); ttl.Position = UDim2.new(0, 10, 0, 0)
    ttl.BackgroundTransparency = 1; ttl.Text = title; ttl.TextColor3 = color
    ttl.TextSize = 14; ttl.Font = Enum.Font.GothamBold; ttl.TextXAlignment = Enum.TextXAlignment.Left; ttl.Parent = hdr
    local xb = Instance.new("TextButton")
    xb.Size = UDim2.new(0, 22, 0, 22); xb.Position = UDim2.new(1, -28, 0, 6)
    xb.BackgroundColor3 = Color3.fromRGB(180, 40, 40); xb.Text = "X"; xb.TextColor3 = Color3.new(1, 1, 1)
    xb.TextSize = 11; xb.Font = Enum.Font.GothamBold; xb.Parent = hdr
    Instance.new("UICorner", xb).CornerRadius = UDim.new(0, 5)
    xb.MouseButton1Click:Connect(function() frame.Visible = false end)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -12, 1, -48)
    content.Position = UDim2.new(0, 6, 0, 40)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = color
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Parent = frame
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local lay = Instance.new("UIListLayout", content); lay.Padding = UDim.new(0, 4)
    local pad = Instance.new("UIPadding", content)
    pad.PaddingTop = UDim.new(0, 5); pad.PaddingLeft = UDim.new(0, 6); pad.PaddingRight = UDim.new(0, 6)

    local ft = Instance.new("TextLabel")
    ft.Size = UDim2.new(1, 0, 0, 12); ft.Position = UDim2.new(0, 0, 1, -14)
    ft.BackgroundTransparency = 1;     ft.Text = "F1 = Abrir/Fechar | F2 = Liberar mouse"
    ft.TextColor3 = Color3.fromRGB(60, 60, 90); ft.TextSize = 9; ft.Font = Enum.Font.Gotham; ft.Parent = frame

    local function sec(txt)
        local s = Instance.new("TextLabel")
        s.Size = UDim2.new(1, 0, 0, 18)
        s.BackgroundTransparency = 1; s.Text = "  " .. txt; s.TextColor3 = color
        s.TextSize = 11; s.Font = Enum.Font.GothamBold; s.TextXAlignment = Enum.TextXAlignment.Left; s.Parent = content
    end
    local function tog(txt, cb)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 28)
        f.BackgroundColor3 = Color3.fromRGB(22, 22, 36); f.BorderSizePixel = 0; f.Parent = content
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -44, 1, 0); l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.fromRGB(200, 200, 220)
        l.TextSize = 12; l.Font = Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
        local tg = Instance.new("TextButton")
        tg.Size = UDim2.new(0, 34, 0, 16); tg.Position = UDim2.new(1, -40, 0.5, -8)
        tg.BackgroundColor3 = Color3.fromRGB(50, 50, 70); tg.Text = ""; tg.Parent = f
        Instance.new("UICorner", tg).CornerRadius = UDim.new(0, 8)
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 12, 0, 12); dot.Position = UDim2.new(0, 2, 0.5, -6)
        dot.BackgroundColor3 = Color3.fromRGB(160, 160, 180); dot.Parent = tg
        Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 6)
        local on = false
        tg.MouseButton1Click:Connect(function()
            on = not on
            if on then
                tg.BackgroundColor3 = color
                dot:TweenPosition(UDim2.new(1, -14, 0.5, -6), "Out", "Quad", 0.12, true)
                dot.BackgroundColor3 = Color3.new(1, 1, 1)
            else
                tg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                dot:TweenPosition(UDim2.new(0, 2, 0.5, -6), "Out", "Quad", 0.12, true)
                dot.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
            end
            cb(on)
        end)
    end
    local function btn(txt, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 26)
        b.BackgroundColor3 = color; b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1)
        b.TextSize = 12; b.Font = Enum.Font.GothamBold; b.Parent = content
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        b.MouseButton1Click:Connect(cb)
    end
    return frame, content, sec, tog, btn
end

local Mouse = LP:GetMouse()
local ClickTPOn = false
local GrudadoOn = false
local PaintParts = {}

local function RaycastFromMouse()
    local unitRay = Mouse.UnitRay
    local origin = unitRay.Origin
    local direction = unitRay.Direction * 1000
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LP.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local result = workspace:Raycast(origin, direction, params)
    return result
end

local function TeleportToClick()
    local result = RaycastFromMouse()
    if result and result.Position then
        local hrp = GetHRP()
        if hrp then
            hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
            Notify("Teleportado!")
        end
    end
end

local function PaintChar(color, all)
    local ch = GetChar()
    if not ch then return end
    for _, p in pairs(ch:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Color = color
            if all then
                p.Material = Enum.Material.SmoothPlastic
            end
        end
    end
    Notify(all and "Pintado inteiro!" or "Partes pintadas!")
end

local function PaintSinglePart(color)
    local ch = GetChar()
    if not ch then return end
    local parts = {}
    for _, p in pairs(ch:GetDescendants()) do
        if p:IsA("BasePart") then
            table.insert(parts, p)
        end
    end
    if #parts == 0 then return end
    if not PaintParts.index then PaintParts.index = 1 end
    local target = parts[PaintParts.index]
    if target then
        target.Color = color
        target.Material = Enum.Material.SmoothPlastic
        Notify("Pintou: " .. target.Name)
    end
    PaintParts.index = PaintParts.index + 1
    if PaintParts.index > #parts then PaintParts.index = 1 end
end

local function GetSceneryColor()
    local result = RaycastFromMouse()
    if result and result.Instance then
        local part = result.Instance
        if part:IsA("BasePart") and part.Color then
            local c = part.Color
            Notify("Cor: " .. math.floor(c.R*255) .. "," .. math.floor(c.G*255) .. "," .. math.floor(c.B*255))
            setclipboard(math.floor(c.R*255) .. "," .. math.floor(c.G*255) .. "," .. math.floor(c.B*255))
            return c
        elseif part:IsA("Terrain") then
            local mat = workspace:GetMaterialColor(part.Material, result.Position)
            Notify("Terreno: cor copiada")
            return mat
        end
    end
    Notify("Nada encontrado")
    return nil
end

-- ============================================================
-- MACACAMELON MODE
-- ============================================================
local function LoadMacacamelon()
    Cleanup()
    local frame, content, sec, tog, btn = MakeMenu("Macacamelon Hub", Color3.fromRGB(0, 200, 80))

    local conns = {}
    local function addConn(c) table.insert(conns, c) return c end

    local f1conn
    f1conn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.F1 then frame.Visible = not frame.Visible end
    end)
    table.insert(conns, f1conn)

    local clickTPConn, clickSelectConn, gpConn, eyeDropConn
    local clickTPOn, clickSelectOn = false, false
    local selectedTarget = nil
    local insideConn = nil
    local followConn = nil
    local followCycling = false
    local followTarget = nil
    local followTimer = 0
    local bodyTPOn, bodyTPConn, bodyTarget = false, nil, nil
    local cabecaConn, cabecaAlvo = nil, nil
    local implacavelOn, intangivelOn = false, false
    local cc = Color3.fromRGB

    sec("ESP (Drawing)")
    tog("ESP (Caixa + Nome)", function(v)
        EspOn = v
        if not v then ClearESP() end
        if v then
            if EspUpdateConn then EspUpdateConn:Disconnect() end
            EspUpdateConn = RunService.RenderStepped:Connect(function()
                if EspOn then UpdateESP() end
            end)
        end
        Notify(v and "ESP ON" or "ESP OFF")
    end)
    btn("Cor - Vermelho", function() espColor = Color3.new(1, 0, 0); Notify("Cor = Vermelho") end)
    btn("Cor - Verde", function() espColor = Color3.new(0, 1, 0); Notify("Cor = Verde") end)
    btn("Cor - Azul", function() espColor = Color3.new(0, 0.5, 1); Notify("Cor = Azul") end)

    sec("DENTRO DO JOGADOR")
    tog("Click p/ TP DENTRO do perto", function(v)
        clickTPOn = v
        if clickTPConn then clickTPConn:Disconnect(); clickTPConn = nil end
        if v then
            clickTPConn = addConn(Mouse.Button1Down:Connect(function()
                if not clickTPOn then return end
                local closest, closestDist = nil, math.huge
                local myPos = GetHRP() and GetHRP().Position
                if not myPos then return end
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local r = plr.Character:FindFirstChild("HumanoidRootPart")
                        if r then
                            local d = (r.Position - myPos).Magnitude
                            if d < closestDist then closestDist = d; closest = r end
                        end
                    end
                end
                if closest and closestDist < 100 then
                    local myHRP = GetHRP()
                    if myHRP then
                        myHRP.CFrame = closest.CFrame
                        Notify("Dentro de " .. closest.Parent.Name)
                    end
                end
            end))
            Notify("Click TP DENTRO ON")
        else Notify("Click TP OFF") end
    end)

    tog("Clicar p/ selecionar alvo", function(v)
        clickSelectOn = v
        if clickSelectConn then clickSelectConn:Disconnect(); clickSelectConn = nil end
        if v then
            clickSelectConn = addConn(Mouse.Button1Down:Connect(function()
                if not clickSelectOn then return end
                local closest, closestDist = nil, math.huge
                local myPos = GetHRP() and GetHRP().Position
                if not myPos then return end
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local r = plr.Character:FindFirstChild("HumanoidRootPart")
                        if r then
                            local d = (r.Position - myPos).Magnitude
                            if d < closestDist then closestDist = d; closest = r end
                        end
                    end
                end
                if closest and closestDist < 100 then
                    selectedTarget = closest
                    Notify("Alvo: " .. selectedTarget.Parent.Name)
                end
            end))
            Notify("Click select ON")
        else selectedTarget = nil; Notify("Select OFF") end
    end)

    btn("Seguir DENTRO do selecionado", function()
        if not selectedTarget then Notify("Selecione um alvo primeiro!"); return end
        if insideConn then insideConn:Disconnect(); insideConn = nil end
        insideConn = addConn(RunService.RenderStepped:Connect(function()
            if not selectedTarget or not selectedTarget.Parent then
                Notify("Alvo perdido")
                if insideConn then insideConn:Disconnect(); insideConn = nil end
                return
            end
            local myHRP = GetHRP()
            if myHRP and selectedTarget then myHRP.CFrame = selectedTarget.CFrame end
        end))
        Notify("Dentro de " .. selectedTarget.Parent.Name)
    end)

    btn("Parar de seguir dentro", function()
        if insideConn then insideConn:Disconnect(); insideConn = nil end
        Notify("Parou")
    end)

    tog("Seguir DENTRO do perto (auto)", function(v)
        if followConn then followConn:Disconnect(); followConn = nil end
        followTarget = nil
        if v then
            followConn = addConn(RunService.RenderStepped:Connect(function()
                if not v then return end
                local closest, closestDist = nil, math.huge
                local myPos = GetHRP() and GetHRP().Position
                if not myPos then return end
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local r = plr.Character:FindFirstChild("HumanoidRootPart")
                        if r then
                            local d = (r.Position - myPos).Magnitude
                            if d < closestDist then closestDist = d; closest = r end
                        end
                    end
                end
                if closest then
                    followTarget = closest
                    local myHRP = GetHRP()
                    if myHRP and followTarget then myHRP.CFrame = followTarget.CFrame end
                end
            end))
            Notify("Seguindo DENTRO")
        else Notify("Parou") end
    end)

    local cycleInterval = 3

    tog("Dentro (troca de 3 em 3s)", function(v)
        followCycling = v
        followTimer = 0
        cycleInterval = 3
        if v then
            if followConn then followConn:Disconnect(); followConn = nil end
            followConn = addConn(RunService.RenderStepped:Connect(function()
                if not followCycling then return end
                followTimer = followTimer + task.wait()
                if followTimer < cycleInterval then
                    if not followTarget then return end
                    local myHRP = GetHRP()
                    if myHRP and followTarget then myHRP.CFrame = followTarget.CFrame end
                    return
                end
                followTimer = 0
                local targets = {}
                local myPos = GetHRP() and GetHRP().Position
                if not myPos then return end
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local r = plr.Character:FindFirstChild("HumanoidRootPart")
                        if r then table.insert(targets, {hrp = r, dist = (r.Position - myPos).Magnitude}) end
                    end
                end
                table.sort(targets, function(a, b) return a.dist < b.dist end)
                if #targets >= 2 then
                    for i = 1, #targets do
                        if targets[i].hrp ~= followTarget then
                            followTarget = targets[i].hrp
                            Notify("Novo alvo: " .. followTarget.Parent.Name)
                            break
                        end
                    end
                else
                    if #targets == 1 then followTarget = targets[1].hrp end
                end
                if followTarget then
                    local myHRP = GetHRP()
                    if myHRP then myHRP.CFrame = followTarget.CFrame end
                end
            end))
            Notify("Dentro - troca 3s")
        else Notify("Parou") end
    end)

    tog("Dentro (troca de 2 em 2s)", function(v)
        followCycling = v
        followTimer = 0
        cycleInterval = 2
        if v then
            if followConn then followConn:Disconnect(); followConn = nil end
            followConn = addConn(RunService.RenderStepped:Connect(function()
                if not followCycling then return end
                followTimer = followTimer + task.wait()
                if followTimer < cycleInterval then
                    if not followTarget then return end
                    local myHRP = GetHRP()
                    if myHRP and followTarget then myHRP.CFrame = followTarget.CFrame end
                    return
                end
                followTimer = 0
                local targets = {}
                local myPos = GetHRP() and GetHRP().Position
                if not myPos then return end
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local r = plr.Character:FindFirstChild("HumanoidRootPart")
                        if r then table.insert(targets, {hrp = r, dist = (r.Position - myPos).Magnitude}) end
                    end
                end
                table.sort(targets, function(a, b) return a.dist < b.dist end)
                if #targets >= 2 then
                    for i = 1, #targets do
                        if targets[i].hrp ~= followTarget then
                            followTarget = targets[i].hrp
                            Notify("Novo alvo: " .. followTarget.Parent.Name)
                            break
                        end
                    end
                else
                    if #targets == 1 then followTarget = targets[1].hrp end
                end
                if followTarget then
                    local myHRP = GetHRP()
                    if myHRP then myHRP.CFrame = followTarget.CFrame end
                end
            end))
            Notify("Dentro - troca 2s")
        else Notify("Parou") end
    end)

    btn("Seguir Aleatorio DENTRO", function()
        if followConn then followConn:Disconnect(); followConn = nil end
        local players = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(players, plr)
            end
        end
        if #players == 0 then Notify("Nenhum jogador"); return end
        local target = players[math.random(1, #players)]
        local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
        followTarget = tHRP
        local randTimer = 0
        followConn = addConn(RunService.RenderStepped:Connect(function()
            randTimer = randTimer + task.wait()
            if randTimer >= 3 then
                randTimer = 0
                local av = {}
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        table.insert(av, plr)
                    end
                end
                if #av > 0 then
                    local newT = av[math.random(1, #av)]
                    followTarget = newT.Character:FindFirstChild("HumanoidRootPart")
                    Notify("Aleatorio: " .. newT.Name)
                end
            end
            local myHRP = GetHRP()
            if myHRP and followTarget then myHRP.CFrame = followTarget.CFrame end
        end))
        Notify("Aleatorio DENTRO: " .. target.Name)
    end)

    sec("BODY TP (1s)")
    btn("Selecionar perto (alvo body TP)", function()
        local closest, closestDist = nil, math.huge
        local myPos = GetHRP() and GetHRP().Position
        if not myPos then return end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local r = plr.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    local d = (r.Position - myPos).Magnitude
                    if d < closestDist then closestDist = d; closest = plr end
                end
            end
        end
        if closest then bodyTarget = closest; Notify("Body TP alvo: " .. closest.Name)
        else Notify("Nenhum perto") end
    end)

    tog("Body TP (1s partes aleatorias)", function(v)
        bodyTPOn = v
        if bodyTPConn then bodyTPConn:Disconnect(); bodyTPConn = nil end
        if v then
            if not bodyTarget then Notify("Selecione alvo primeiro!"); bodyTPOn = false; return end
            bodyTPConn = addConn(RunService.RenderStepped:Connect(function()
                if not bodyTPOn or not bodyTarget or not bodyTarget.Character then
                    if bodyTPOn then Notify("Alvo perdido") end
                    return
                end
                local myHRP = GetHRP()
                if not myHRP then return end
                local parts = {}
                for _, p in pairs(bodyTarget.Character:GetDescendants()) do
                    if p:IsA("BasePart") then table.insert(parts, p) end
                end
                if #parts > 0 then myHRP.CFrame = parts[math.random(1, #parts)].CFrame end
                task.wait(1)
            end))
            Notify("Body TP ON - 1s")
        else Notify("Body TP OFF") end
    end)

    sec("CABECA (click)")
    btn("Selecionar perto (cabeÃ§a)", function()
        local closest, closestDist = nil, math.huge
        local myPos = GetHRP() and GetHRP().Position
        if not myPos then return end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local r = plr.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    local d = (r.Position - myPos).Magnitude
                    if d < closestDist then closestDist = d; closest = plr end
                end
            end
        end
        if closest then cabecaAlvo = closest; Notify("Alvo: " .. closest.Name)
        else Notify("Nenhum perto") end
    end)

    tog("Seguir na CABECA do alvo", function(v)
        if cabecaConn then cabecaConn:Disconnect(); cabecaConn = nil end
        if v then
            if not cabecaAlvo then Notify("Selecione alvo!"); return end
            cabecaConn = addConn(RunService.RenderStepped:Connect(function()
                if not v or not cabecaAlvo or not cabecaAlvo.Character then
                    if v then Notify("Alvo perdido") end
                    return
                end
                local head = cabecaAlvo.Character:FindFirstChild("Head")
                local myHRP = GetHRP()
                if myHRP and head then myHRP.CFrame = CFrame.new(head.Position + Vector3.new(0, 0.5, 0)) end
            end))
            Notify("Na CABECA de " .. cabecaAlvo.Name)
        else Notify("Parou") end
    end)

    sec("MODO IMPLACAVEL")
    tog("Intangivel (leva dano zero)", function(v)
        intangivelOn = v
        if intangivelConn then intangivelConn:Disconnect(); intangivelConn = nil end
        if v then
            intangivelConn = addConn(RunService.Heartbeat:Connect(function()
                if not intangivelOn then return end
                local h = GetHum()
                if h then
                    h.Health = h.MaxHealth
                    h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    h.BreakJointsOnDeath = false
                end
                local ch = GetChar()
                if ch then for _, p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
            end))
            Notify("Intangivel ON - nao leva dano")
        else Notify("Intangivel OFF") end
    end)

    tog("Modo Implacavel (TP + seguir)", function(v)
        implacavelOn = v
        if implacavelConn then implacavelConn:Disconnect(); implacavelConn = nil end
        if v then
            if not intangivelOn then
                intangivelOn = true
                if intangivelConn then intangivelConn:Disconnect(); intangivelConn = nil end
                intangivelConn = addConn(RunService.Heartbeat:Connect(function()
                    if not intangivelOn then return end
                    local h = GetHum()
                    if h then h.Health = h.MaxHealth; h.BreakJointsOnDeath = false end
                    local ch = GetChar()
                    if ch then for _, p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
                end))
            end
            local targets = {}
            local targetIdx = 1
            local teleportTimer = 0
            implacavelConn = addConn(RunService.RenderStepped:Connect(function()
                if not implacavelOn then return end
                teleportTimer = teleportTimer + task.wait()
                targets = {}
                local myPos = GetHRP() and GetHRP().Position
                if not myPos then return end
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local r = plr.Character:FindFirstChild("HumanoidRootPart")
                        if r then table.insert(targets, { plr = plr, hrp = r, dist = (r.Position - myPos).Magnitude }) end
                    end
                end
                table.sort(targets, function(a, b) return a.dist < b.dist end)
                if #targets > 0 then
                    if teleportTimer >= 0.8 then
                        teleportTimer = 0
                        targetIdx = targetIdx + 1
                        if targetIdx > #targets then targetIdx = 1 end
                    end
                    local idx = math.min(targetIdx, #targets)
                    local myHRP = GetHRP()
                    local tHRP = targets[idx].hrp
                    if myHRP and tHRP then
                        local behind = tHRP.CFrame.LookVector * -1
                        local offset = Vector3.new(0, 0, 0)
                        if teleportTimer < 0.2 then
                            offset = behind * 8 + Vector3.new(0, 3, 0)
                        elseif teleportTimer < 0.4 then
                            offset = Vector3.new(4, 1, 4)
                        elseif teleportTimer < 0.6 then
                            offset = Vector3.new(-4, 2, -4)
                        else
                            offset = behind * 5 + Vector3.new(2, 1, -2)
                        end
                        if teleportTimer < 0.05 then
                            myHRP.CFrame = CFrame.new(tHRP.Position + offset)
                        else
                            local targetPos = tHRP.Position + offset
                            local moveDir = (targetPos - myHRP.Position).Unit * math.min((targetPos - myHRP.Position).Magnitude * 0.3, 30)
                            myHRP.CFrame = myHRP.CFrame + moveDir
                        end
                        local dir = (tHRP.Position - myHRP.Position).Unit
                        myHRP.CFrame = CFrame.lookAt(myHRP.Position, myHRP.Position + dir * 100)
                    end
                end
            end))
            Notify("Modo Implacavel ON")
        else Notify("Modo Implacavel OFF") end
    end)

    sec("MOVIMENTO")
    tog("Atravessar Paredes (Noclip)", function(v)
        NoclipOn = v
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        if v then
            noclipConn = addConn(RunService.Stepped:Connect(function()
                local ch = GetChar()
                if ch then for _, p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
            end))
            Notify("Noclip ON")
        else Notify("Noclip OFF") end
    end)

    tog("Voar (WASD + Space/Shift)", function(v)
        FlyOn = v
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if flyBody then flyBody:Destroy(); flyBody = nil end
        if flyGyro then flyGyro:Destroy(); flyGyro = nil end
        if v then
            local hrp = GetHRP()
            if hrp then
                flyGyro = Instance.new("BodyGyro", hrp)
                flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); flyGyro.P = 9000; flyGyro.D = 500
                flyBody = Instance.new("BodyVelocity", hrp)
                flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge); flyBody.Velocity = Vector3.zero
                flyConn = addConn(RunService.RenderStepped:Connect(function()
                    local cam = workspace.CurrentCamera
                    local d = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.new(0, 1, 0) end
                    if flyBody and flyGyro then flyBody.Velocity = d.Unit * 80; flyGyro.CFrame = cam.CFrame end
                end))
                Notify("Fly ON")
            end
        else Notify("Fly OFF") end
    end)

    sec("PINTAR")
    btn("Pintar Inteiro - VERMELHO", function() PaintChar(cc(255, 0, 0), true) end)
    btn("Pintar Inteiro - AZUL", function() PaintChar(cc(0, 100, 255), true) end)
    btn("Pintar Inteiro - VERDE", function() PaintChar(cc(0, 200, 0), true) end)
    btn("Pintar Inteiro - PRETO", function() PaintChar(cc(0, 0, 0), true) end)
    btn("Pintar Inteiro - BRANCO", function() PaintChar(cc(255, 255, 255), true) end)
    btn("Pintar Inteiro - AMARELO", function() PaintChar(cc(255, 255, 0), true) end)
    btn("Pintar Inteiro - ROXO", function() PaintChar(cc(150, 0, 255), true) end)
    btn("Pintar Inteiro - LARANJA", function() PaintChar(cc(255, 120, 0), true) end)

    sec("PINTAR UMA PARTE (G)")
    if gpConn then gpConn:Disconnect(); gpConn = nil end
    gpConn = addConn(UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if gameMode ~= "macacamelon" then return end
        if input.KeyCode == Enum.KeyCode.G then
            PaintSinglePart(cc(255, 255, 0))
        end
    end))
    local partIdx = Instance.new("TextLabel")
    partIdx.Size = UDim2.new(1, 0, 0, 18)
    partIdx.BackgroundTransparency = 1
    partIdx.Text = "  Pressione G para pintar a prox. parte"
    partIdx.TextColor3 = Color3.fromRGB(140, 140, 170)
    partIdx.TextSize = 10
    partIdx.Font = Enum.Font.Gotham
    partIdx.TextXAlignment = Enum.TextXAlignment.Left
    partIdx.Parent = content

    sec("COR DO CENARIO")
    tog("Conta-gotas (copiar cor)", function(v)
        if eyeDropConn then eyeDropConn:Disconnect(); eyeDropConn = nil end
        if v then
            Notify("Clique em algo para copiar a cor")
            eyeDropConn = addConn(Mouse.Button1Down:Connect(function()
                local c = GetSceneryColor()
                if c then Notify("Cor copiada!") end
            end))
        end
    end)

    sec("INVISIBILIDADE")
    tog("Ficar Totalmente Invisivel", function(v)
        InvisOn = v
        local ch = GetChar()
        if ch then
            for _, p in pairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.Transparency = v and 1 or 0; p.CanCollide = not v end
                if p:IsA("Decal") then p.Transparency = v and 1 or 0 end
                if p:IsA("ForceField") then p.Visible = not v end
            end
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum then hum.DisplayDistanceType = v and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Default end
        end
        Notify(v and "Invisivel" or "Visivel")
    end)

    sec("FECHAR MENU")
    btn("FECHAR e limpar tudo", function()
        local confirm = Instance.new("Frame")
        confirm.Size = UDim2.new(0, 260, 0, 140)
        confirm.Position = UDim2.new(0.5, -130, 0.5, -70)
        confirm.BackgroundColor3 = Color3.fromRGB(10, 30, 10)
        confirm.BorderSizePixel = 0
        confirm.Parent = gui
        confirm.ZIndex = 999
        Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 10)
        Instance.new("UIStroke", confirm).Color = Color3.fromRGB(60, 200, 80)

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, -20, 0, 40)
        txt.Position = UDim2.new(0, 10, 0, 15)
        txt.BackgroundTransparency = 1
        txt.Text = "Tem certeza?\nTodos os comandos serao parados."
        txt.TextColor3 = Color3.new(1, 1, 1)
        txt.TextSize = 13
        txt.Font = Enum.Font.GothamBold
        txt.Parent = confirm

        local yesBtn = Instance.new("TextButton")
        yesBtn.Size = UDim2.new(0.45, 0, 0, 32)
        yesBtn.Position = UDim2.new(0.05, 5, 1, -45)
        yesBtn.BackgroundColor3 = Color3.fromRGB(30, 180, 60)
        yesBtn.Text = "SIM, FECHAR"
        yesBtn.TextColor3 = Color3.new(1, 1, 1)
        yesBtn.TextSize = 12
        yesBtn.Font = Enum.Font.GothamBold
        yesBtn.Parent = confirm
        Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 6)

        local noBtn = Instance.new("TextButton")
        noBtn.Size = UDim2.new(0.45, 0, 0, 32)
        noBtn.Position = UDim2.new(0.5, 0, 1, -45)
        noBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        noBtn.Text = "CANCELAR"
        noBtn.TextColor3 = Color3.new(1, 1, 1)
        noBtn.TextSize = 12
        noBtn.Font = Enum.Font.GothamBold
        noBtn.Parent = confirm
        Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 6)

        yesBtn.MouseButton1Click:Connect(function()
            confirm:Destroy()
            for _, c in pairs(conns) do pcall(function() c:Disconnect() end) end
            conns = {}
            Cleanup()
            frame.Visible = false
            gameMode = nil
            selector.Visible = true
            Notify("Tudo fechado!")
        end)
        noBtn.MouseButton1Click:Connect(function()
            confirm:Destroy()
        end)
    end)

    frame.Visible = true
    Notify("Macacamelon Hub! F1 = menu | F2 = liberar mouse | G = pintar parte")
end

-- ============================================================
-- BROOKHAVEN MODE
-- ============================================================
local function LoadBrookhaven()
    Cleanup()
    local frame, content, sec, tog, btn = MakeMenu("Brookhaven Security Hub", Color3.fromRGB(255, 50, 50))
    local brookConns = {}
    local function addBC(c) table.insert(brookConns, c) return c end

    local f1conn
    f1conn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.F1 then frame.Visible = not frame.Visible end
    end)
    table.insert(brookConns, f1conn)

    sec("ESP (Drawing 2D)")
    tog("ESP (Caixa + Nome)", function(v)
        EspOn = v
        if not v then ClearESP() end
        if v then
            if EspUpdateConn then EspUpdateConn:Disconnect() end
            EspUpdateConn = RunService.RenderStepped:Connect(function()
                if EspOn then UpdateESP() end
            end)
        end
        Notify(v and "ESP ON" or "ESP OFF")
    end)
    btn("Cor - Vermelho", function() espColor = Color3.new(1, 0, 0); Notify("Cor = Vermelho") end)
    btn("Cor - Verde", function() espColor = Color3.new(0, 1, 0); Notify("Cor = Verde") end)
    btn("Cor - Azul", function() espColor = Color3.new(0, 0.5, 1); Notify("Cor = Azul") end)

    sec("MOVIMENTO")
    tog("Noclip", function(v)
        NoclipOn = v
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        if v then
            noclipConn = addBC(RunService.Stepped:Connect(function()
                local ch = GetChar()
                if ch then for _, p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
            end))
            Notify("Noclip ON")
        else Notify("Noclip OFF") end
    end)
    tog("Fly (WASD)", function(v)
        FlyOn = v
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if flyBody then flyBody:Destroy(); flyBody = nil end
        if flyGyro then flyGyro:Destroy(); flyGyro = nil end
        if v then
            local hrp = GetHRP()
            if hrp then
                flyGyro = Instance.new("BodyGyro", hrp); flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); flyGyro.P = 9000; flyGyro.D = 500
                flyBody = Instance.new("BodyVelocity", hrp); flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge); flyBody.Velocity = Vector3.zero
                flyConn = addBC(RunService.RenderStepped:Connect(function()
                    local cam = workspace.CurrentCamera
                    local d = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.new(0, 1, 0) end
                    if flyBody and flyGyro then flyBody.Velocity = d.Unit * 80; flyGyro.CFrame = cam.CFrame end
                end))
                Notify("Fly ON")
            end
        else Notify("Fly OFF") end
    end)
    tog("Super Rapido (Speed)", function(v)
        local h = GetHum()
        if h then
            h.WalkSpeed = v and 80 or 16
            Notify(v and "Speed ON" or "Speed OFF")
        end
    end)

    sec("SEGUIR JOGADOR")
    local followConn2 = nil
    local followTarget2 = nil
    local selectedPlr = nil

    btn("Selecionar perto (alvo)", function()
        local closest, closestDist = nil, math.huge
        local myPos = GetHRP() and GetHRP().Position
        if not myPos then return end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local r = plr.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    local d = (r.Position - myPos).Magnitude
                    if d < closestDist then closestDist = d; closest = plr end
                end
            end
        end
        if closest then selectedPlr = closest; Notify("Alvo: " .. closest.Name)
        else Notify("Nenhum perto") end
    end)

    tog("Seguir jogador (auto perto)", function(v)
        if followConn2 then followConn2:Disconnect(); followConn2 = nil end
        if v then
            followConn2 = addBC(RunService.RenderStepped:Connect(function()
                local closest, closestDist = nil, math.huge
                local myPos = GetHRP() and GetHRP().Position
                if not myPos then return end
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local r = plr.Character:FindFirstChild("HumanoidRootPart")
                        if r then
                            local d = (r.Position - myPos).Magnitude
                            if d < closestDist then closestDist = d; closest = r end
                        end
                    end
                end
                if closest then
                    followTarget2 = closest
                    local myHRP = GetHRP()
                    if myHRP then myHRP.CFrame = closest.CFrame end
                end
            end))
            Notify("Seguindo perto")
        else Notify("Parou") end
    end)

    tog("Seguir dentro (CFrame)", function(v)
        if followConn2 then followConn2:Disconnect(); followConn2 = nil end
        if v then
            if not selectedPlr then Notify("Selecione alvo!"); return end
            followConn2 = addBC(RunService.RenderStepped:Connect(function()
                if not selectedPlr or not selectedPlr.Character then Notify("Alvo perdido"); return end
                local myHRP = GetHRP()
                local tHRP = selectedPlr.Character:FindFirstChild("HumanoidRootPart")
                if myHRP and tHRP then myHRP.CFrame = tHRP.CFrame end
            end))
            Notify("Dentro de " .. selectedPlr.Name)
        else Notify("Parou") end
    end)

    btn("Parar de seguir", function()
        if followConn2 then followConn2:Disconnect(); followConn2 = nil end
        Notify("Parou")
    end)

    sec("PROTECAO")
    local godConn = nil
    local godOn = false
    tog("God Mode", function(v)
        godOn = v
        if godConn then godConn:Disconnect(); godConn = nil end
        if v then
            godConn = addBC(RunService.Heartbeat:Connect(function()
                if not godOn then return end
                local h = GetHum(); if h then h.Health = h.MaxHealth end
            end))
            Notify("God ON")
        else Notify("God OFF") end
    end)
    local afkConn = nil
    local afkOn = false
    tog("Anti-AFK", function(v)
        afkOn = v
        if afkConn then afkConn:Disconnect(); afkConn = nil end
        if v then
            afkConn = addBC(RunService.Heartbeat:Connect(function()
                if not afkOn then return end
                pcall(function()
                    local vu = game:GetService("VirtualUser")
                    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(0.1)
                    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
            end))
            Notify("Anti-AFK ON")
        else Notify("Anti-AFK OFF") end
    end)
    tog("Intocavel (1 click)", function(v)
        intangivelOn = v
        if intangivelConn then intangivelConn:Disconnect(); intangivelConn = nil end
        if v then
            intangivelConn = addBC(RunService.Heartbeat:Connect(function()
                if not intangivelOn then return end
                local h = GetHum()
                if h then
                    h.Health = h.MaxHealth
                    h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    h.BreakJointsOnDeath = false
                end
                local ch = GetChar()
                if ch then for _, p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
            end))
            Notify("Intocavel ON")
        else Notify("Intocavel OFF") end
    end)

    sec("INVISIBILIDADE")
    tog("Ficar Invisivel", function(v)
        InvisOn = v
        local ch = GetChar()
        if ch then
            for _, p in pairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.Transparency = v and 1 or 0; p.CanCollide = not v end
                if p:IsA("Decal") then p.Transparency = v and 1 or 0 end
                if p:IsA("ForceField") then p.Visible = not v end
            end
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum then hum.DisplayDistanceType = v and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Default end
        end
        Notify(v and "Invisivel" or "Visivel")
    end)

    sec("PUXAR OBJETOS")
    local pullConn = nil
    local pulling = false
    tog("Puxar com Mouse (segurar)", function(v)
        pulling = v
        if pullConn then pullConn:Disconnect(); pullConn = nil end
        if v then
            Notify("Clique e segure em qualquer objeto")
            pullConn = addBC(Mouse.Button1Down:Connect(function()
                if not pulling then return end
                local result = RaycastFromMouse()
                if not result or not result.Instance then return end
                local target = result.Instance
                if target:IsA("BasePart") and not target:IsDescendantOf(LP.Character or game) then
                    local bp = Instance.new("BodyPosition")
                    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bp.D = 400; bp.P = 10000
                    bp.Position = target.Position
                    bp.Parent = target
                    local moveConn
                    moveConn = addBC(RunService.RenderStepped:Connect(function()
                        if not pulling or not bp or not bp.Parent then
                            if moveConn then moveConn:Disconnect() end
                            return
                        end
                        local r = RaycastFromMouse()
                        if r then bp.Position = r.Position + Vector3.new(0, 2, 0) end
                    end))
                    Notify("Puxando: " .. target.Name)
                end
            end))
        else Notify("Puxar OFF") end
    end)
    btn("Listar Objetos Perto", function()
        local myPos = GetHRP() and GetHRP().Position
        if not myPos then return end
        local count = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LP.Character or game) then
                local d = (obj.Position - myPos).Magnitude
                if d < 50 then count = count + 1 end
            end
        end
        Notify(count .. " objetos perto (50m)")
    end)

    sec("PUXAR TUDO (sem distancia)")
    local puxarTudoOn = false
    local puxarTudoConn = nil
    local puxarTudoParts = {}

    tog("Puxar tudo (click em qualquer lugar)", function(v)
        puxarTudoOn = v
        if puxarTudoConn then puxarTudoConn:Disconnect(); puxarTudoConn = nil end
        if not v then
            for _, info in pairs(puxarTudoParts) do
                if info.bp and info.bp.Parent then info.bp:Destroy() end
                if info.part and info.part.Parent then info.part.CanCollide = true end
            end
            puxarTudoParts = {}
        end
        if v then
            Notify("Clique em qualquer objeto do mapa (sem limite de distancia)")
            puxarTudoConn = addBC(Mouse.Button1Down:Connect(function()
                if not puxarTudoOn then return end
                local result = RaycastFromMouse()
                if not result or not result.Instance then return end
                local target = result.Instance
                if target:IsA("BasePart") and not target:IsDescendantOf(LP.Character or LP.Character) then
                    puxarTudoParts[target] = puxarTudoParts[target] or {}
                    local info = puxarTudoParts[target]
                    if not info.bp or not info.bp.Parent then
                        target.CanCollide = false
                        local bp = Instance.new("BodyPosition")
                        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bp.D = 500
                        bp.P = 50000
                        bp.Position = target.Position
                        bp.Parent = target
                        info.bp = bp
                        info.part = target
                        Notify("Puxando: " .. target.Name)
                    end
                end
            end))
            addBC(RunService.RenderStepped:Connect(function()
                if not puxarTudoOn then return end
                local myHRP = GetHRP()
                if not myHRP then return end
                local count = 0
                for part, info in pairs(puxarTudoParts) do
                    if not part or not part.Parent then
                        puxarTudoParts[part] = nil
                    else
                        count = count + 1
                        local bp = info.bp
                        if bp and bp.Parent then
                            bp.Position = myHRP.Position + Vector3.new(0, 5 + count * 3, 0)
                        end
                    end
                end
            end))
        else Notify("Puxar tudo OFF") end
    end)

    btn("Puxar carros (todos perto)", function()
        local myPos = GetHRP() and GetHRP().Position
        if not myPos then return end
        local count = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local name = obj.Name:lower()
                if name:find("car") or name:find("veh") or name:find("truck") or name:find("bus") then
                    for _, p in pairs(obj:GetDescendants()) do
                        if p:IsA("BasePart") and not p:IsDescendantOf(LP.Character) then
                            puxarTudoParts[p] = puxarTudoParts[p] or {}
                            if not puxarTudoParts[p].bp or not puxarTudoParts[p].bp.Parent then
                                p.CanCollide = false
                                local bp = Instance.new("BodyPosition")
                                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                bp.D = 500
                                bp.P = 50000
                                bp.Position = p.Position
                                bp.Parent = p
                                puxarTudoParts[p] = { bp = bp, part = p }
                            end
                            count = count + 1
                        end
                    end
                end
            end
        end
        if count > 0 then
            addBC(RunService.RenderStepped:Connect(function()
                local myHRP = GetHRP()
                if not myHRP then return end
                local i = 0
                for part, info in pairs(puxarTudoParts) do
                    if part and part.Parent and info.bp and info.bp.Parent then
                        i = i + 1
                        info.bp.Position = myHRP.Position + Vector3.new(0, 5 + i * 3, 0)
                    end
                end
            end))
        end
        Notify("Puxou " .. count .. " partes de carros")
    end)

    btn("Soltar tudo", function()
        for _, info in pairs(puxarTudoParts) do
            if info.bp and info.bp.Parent then info.bp:Destroy() end
            if info.part and info.part.Parent then info.part.CanCollide = true end
        end
        puxarTudoParts = {}
        Notify("Tudo solto!")
    end)

    sec("PORTA GIRATORIA (voa pessoa)")
    local portaOn = false
    local portaConn = nil
    local portaPart = nil
    local portaAngle = 0
    local portaTouchConn = nil

    tog("Porta Giratoria ON (click)", function(v)
        portaOn = v
        if portaConn then portaConn:Disconnect(); portaConn = nil end
        if portaTouchConn then portaTouchConn:Disconnect(); portaTouchConn = nil end
        if portaPart and portaPart.Parent then
            if portaPart:FindFirstChild("BodyPosition_porta") then portaPart.BodyPosition_porta:Destroy() end
            if portaPart:FindFirstChild("BodyAngularVelocity_porta") then portaPart.BodyAngularVelocity_porta:Destroy() end
            portaPart.CanCollide = true
        end
        portaPart = nil
        portaAngle = 0
        if v then
            portaConn = addBC(Mouse.Button1Down:Connect(function()
                if not portaOn or portaPart then return end
                local result = RaycastFromMouse()
                if not result or not result.Instance then return end
                local target = result.Instance
                if target:IsA("BasePart") and not target:IsDescendantOf(LP.Character or game) then
                    portaPart = target
                    target.CanCollide = false
                    local bp = Instance.new("BodyPosition")
                    bp.Name = "BodyPosition_porta"
                    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bp.D = 400; bp.P = 10000
                    bp.Position = target.Position
                    bp.Parent = target
                    local bav = Instance.new("BodyAngularVelocity")
                    bav.Name = "BodyAngularVelocity_porta"
                    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    bav.AngularVelocity = Vector3.new(0, 30, 0)
                    bav.P = 5000
                    bav.Parent = target
                    portaTouchConn = addBC(target.Touched:Connect(function(hit)
                        if not portaOn or not portaPart then return end
                        local char = hit:FindFirstAncestorOfClass("Model")
                        if not char then return end
                        local plr = Players:GetPlayerFromCharacter(char)
                        if plr and plr ~= LP then
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.AssemblyLinearVelocity = Vector3.new(
                                    math.random(-80, 80),
                                    math.random(150, 250),
                                    math.random(-80, 80)
                                )
                                Notify("VOOU: " .. plr.Name)
                            end
                        end
                    end))
                    Notify("Porta girando! Aproxime de pessoas")
                end
            end))
            local spinConn
            spinConn = addBC(RunService.RenderStepped:Connect(function()
                if not portaOn or not portaPart or not portaPart.Parent then
                    if spinConn then spinConn:Disconnect() end
                    return
                end
                local myHRP = GetHRP()
                if not myHRP then return end
                portaAngle = portaAngle + 0.15
                local radius = 6
                local x = math.cos(portaAngle) * radius
                local z = math.sin(portaAngle) * radius
                local targetPos = myHRP.Position + Vector3.new(x, 0, z)
                local bp = portaPart:FindFirstChild("BodyPosition_porta")
                if bp then bp.Position = targetPos end
            end))
            Notify("Clique numa porta/objeto pra girar!")
        else Notify("Porta OFF") end
    end)

    btn("Soltar porta", function()
        if portaPart and portaPart.Parent then
            if portaPart:FindFirstChild("BodyPosition_porta") then portaPart.BodyPosition_porta:Destroy() end
            if portaPart:FindFirstChild("BodyAngularVelocity_porta") then portaPart.BodyAngularVelocity_porta:Destroy() end
            portaPart.CanCollide = true
        end
        portaPart = nil
        Notify("Porta solta")
    end)

    sec("CHAT / JOGADORES")
    btn("Quem tem mesmo chat", function()
        local myChat = LP.Chatted
        local names = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP then
                table.insert(names, plr.Name)
            end
        end
        if #names > 0 then
            Notify("Jogadores: " .. table.concat(names, ", "))
        else
            Notify("So voce no server")
        end
    end)
    btn("Listar Players + HP", function()
        for _, plr in pairs(Players:GetPlayers()) do
            local info = plr.Name
            if plr.Character then
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if h then info = info .. " | HP:" .. math.floor(h.Health) end
            end
            Notify(info)
        end
    end)

    sec("INVASAO")
    tog("Remote Spy", function(v)
        local rs = game:GetService("ReplicatedStorage")
        if v then
            for _, obj in pairs(rs:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    addBC(obj.OnClientEvent:Connect(function(...)
                        Notify("Remote: " .. obj.Name .. " | " .. tostring(select('#', ...)) .. " args")
                    end))
                end
            end
            Notify("Spy ON")
        else Notify("Spy OFF") end
    end)
    btn("FireServer (todos)", function()
        local c = 0
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if obj:IsA("RemoteEvent") then pcall(function() obj:FireServer("test", 123, nil, math.huge) end); c = c + 1 end
        end
        Notify("FireServer em " .. c .. " remotes")
    end)
    btn("InvokeServer (todos)", function()
        local c = 0
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if obj:IsA("RemoteFunction") then pcall(function() obj:InvokeServer("test") end); c = c + 1 end
        end
        Notify("InvokeServer em " .. c .. " functions")
    end)
    btn("Stress Test", function()
        local t = {}; for i = 1, 500 do t[i] = string.rep("X", 500) end
        local c = 0
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if obj:IsA("RemoteEvent") then pcall(function() obj:FireServer(nil, t, {}, math.huge) end); c = c + 1 end
        end
        Notify("Stress em " .. c .. " remotes")
    end)

    sec("INFORMACOES")
    btn("Listar Remotes", function()
        local c = 0
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then c = c + 1 end
        end
        Notify(c .. " remotes em ReplicatedStorage")
    end)
    btn("Server Hop", function()
        pcall(function()
            local t = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            local d = game:GetService("HttpService"):JSONDecode(t)
            local s = {}
            if d and d.data then for _, v in pairs(d.data) do if v.id ~= game.JobId and v.playing < v.maxPlayers then table.insert(s, v.id) end end end
            if #s > 0 then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s[math.random(1, #s)], LP) else Notify("Nenhum servidor") end
        end)
    end)
    btn("Copiar Server ID", function() setclipboard(game.JobId); Notify("Copiado!") end)

    sec("FECHAR MENU")
    btn("FECHAR e limpar tudo", function()
        local confirm = Instance.new("Frame")
        confirm.Size = UDim2.new(0, 260, 0, 140)
        confirm.Position = UDim2.new(0.5, -130, 0.5, -70)
        confirm.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        confirm.BorderSizePixel = 0
        confirm.Parent = gui
        confirm.ZIndex = 999
        Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 10)
        Instance.new("UIStroke", confirm).Color = Color3.fromRGB(255, 60, 60)

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, -20, 0, 40)
        txt.Position = UDim2.new(0, 10, 0, 15)
        txt.BackgroundTransparency = 1
        txt.Text = "Tem certeza?\nTodos os comandos serao parados."
        txt.TextColor3 = Color3.new(1, 1, 1)
        txt.TextSize = 13
        txt.Font = Enum.Font.GothamBold
        txt.Parent = confirm

        local yesBtn = Instance.new("TextButton")
        yesBtn.Size = UDim2.new(0.45, 0, 0, 32)
        yesBtn.Position = UDim2.new(0.05, 5, 1, -45)
        yesBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        yesBtn.Text = "SIM, FECHAR"
        yesBtn.TextColor3 = Color3.new(1, 1, 1)
        yesBtn.TextSize = 12
        yesBtn.Font = Enum.Font.GothamBold
        yesBtn.Parent = confirm
        Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 6)

        local noBtn = Instance.new("TextButton")
        noBtn.Size = UDim2.new(0.45, 0, 0, 32)
        noBtn.Position = UDim2.new(0.5, 0, 1, -45)
        noBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        noBtn.Text = "CANCELAR"
        noBtn.TextColor3 = Color3.new(1, 1, 1)
        noBtn.TextSize = 12
        noBtn.Font = Enum.Font.GothamBold
        noBtn.Parent = confirm
        Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 6)

        yesBtn.MouseButton1Click:Connect(function()
            confirm:Destroy()
            for _, c in pairs(brookConns) do pcall(function() c:Disconnect() end) end
            brookConns = {}
            Cleanup()
            frame.Visible = false
            gameMode = nil
            selector.Visible = true
            Notify("Tudo fechado!")
        end)
        noBtn.MouseButton1Click:Connect(function()
            confirm:Destroy()
        end)
    end)

    frame.Visible = true
    Notify("Brookhaven Hub! F1 = menu | F2 = liberar mouse")
end

-- ============================================================
-- GAME SELECTOR
-- ============================================================
local selector = Instance.new("Frame")
selector.Size = UDim2.new(0, 360, 0, 280)
selector.Position = UDim2.new(0.5, -180, 0.5, -140)
selector.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
selector.BorderSizePixel = 0
selector.Active = true
selector.Draggable = true
selector.Parent = gui
Instance.new("UICorner", selector).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", selector).Color = Color3.fromRGB(100, 100, 150)
Instance.new("UIStroke", selector).Thickness = 1

local sTitle = Instance.new("TextLabel")
sTitle.Size = UDim2.new(1, -20, 0, 36)
sTitle.Position = UDim2.new(0, 10, 0, 14)
sTitle.BackgroundTransparency = 1
sTitle.Text = "SELECIONE O JOGO"
sTitle.TextColor3 = Color3.fromRGB(200, 200, 230)
sTitle.TextSize = 18
sTitle.Font = Enum.Font.GothamBold
sTitle.Parent = selector

local sSub = Instance.new("TextLabel")
sSub.Size = UDim2.new(1, -20, 0, 20)
sSub.Position = UDim2.new(0, 10, 0, 50)
sSub.BackgroundTransparency = 1
sSub.Text = "Escolha qual jogo testar:"
sSub.TextColor3 = Color3.fromRGB(120, 120, 150)
sSub.TextSize = 12
sSub.Font = Enum.Font.Gotham
sSub.Parent = selector

local btn1 = Instance.new("TextButton")
btn1.Size = UDim2.new(1, -40, 0, 50)
btn1.Position = UDim2.new(0, 20, 0, 85)
btn1.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
btn1.Text = "BROOKHAVEN"
btn1.TextColor3 = Color3.new(1, 1, 1)
btn1.TextSize = 16
btn1.Font = Enum.Font.GothamBold
btn1.Parent = selector
Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 8)
btn1.MouseEnter:Connect(function() btn1.BackgroundColor3 = Color3.fromRGB(240, 50, 50) end)
btn1.MouseLeave:Connect(function() btn1.BackgroundColor3 = Color3.fromRGB(200, 40, 40) end)
btn1.MouseButton1Click:Connect(function()
    selector.Visible = false
    gameMode = "brookhaven"
    LoadBrookhaven()
end)

local btn2 = Instance.new("TextButton")
btn2.Size = UDim2.new(1, -40, 0, 50)
btn2.Position = UDim2.new(0, 20, 0, 145)
btn2.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
btn2.Text = "MACACAMELON"
btn2.TextColor3 = Color3.new(1, 1, 1)
btn2.TextSize = 16
btn2.Font = Enum.Font.GothamBold
btn2.Parent = selector
Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 8)
btn2.MouseEnter:Connect(function() btn2.BackgroundColor3 = Color3.fromRGB(0, 200, 80) end)
btn2.MouseLeave:Connect(function() btn2.BackgroundColor3 = Color3.fromRGB(0, 160, 60) end)
btn2.MouseButton1Click:Connect(function()
    selector.Visible = false
    gameMode = "macacamelon"
    LoadMacacamelon()
end)

local sFoot = Instance.new("TextLabel")
sFoot.Size = UDim2.new(1, 0, 0, 16)
sFoot.Position = UDim2.new(0, 0, 1, -20)
sFoot.BackgroundTransparency = 1
sFoot.Text = "Ferramenta de teste de seguranca"
sFoot.TextColor3 = Color3.fromRGB(70, 70, 100)
sFoot.TextSize = 10
sFoot.Font = Enum.Font.Gotham
sFoot.Parent = selector

selector.Visible = true
Notify("Selecione um jogo")

-- F2 = Liberar/travar mouse (pra conseguir clicar no menu)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F2 then
        if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter or UserInputService.MouseBehavior == Enum.MouseBehavior.LockOnFocus then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
            Notify("Mouse liberado (F2)")
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            Notify("Mouse travado (F2)")
        end
    end
end)
