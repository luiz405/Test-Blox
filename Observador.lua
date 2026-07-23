local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local targetPlayer = nil
local followActive = false
local invisible = false
local observeActive = false
local followConn = nil
local followDist = 10
local offsetHeight = 5

local function Notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = "Observador", Text = txt, Duration = 4 })
    end)
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

local function MakeInvisible(state)
    invisible = state
    local ch = GetChar()
    if ch then
        for _, p in pairs(ch:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Transparency = state and 1 or 0
                p.CanCollide = not state
                if state then
                    p.Material = Enum.Material.SmoothPlastic
                end
            end
            if p:IsA("Decal") then
                p.Transparency = state and 1 or 0
            end
            if p:IsA("ForceField") then
                p.Visible = not state
            end
        end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = invisible and 24 or 16
            hum.DisplayDistanceType = state and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Default
            hum.SetStateEnabled and hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
        ch.DescendantAdded:Connect(function(p)
            task.wait(0.1)
            if invisible then
                if p:IsA("BasePart") then p.Transparency = 1; p.CanCollide = false end
                if p:IsA("Decal") then p.Transparency = 1 end
            end
        end)
    end
    Notify(state and "Invisivel" or "Visivel")
end

local function StartFollow()
    if followConn then followConn:Disconnect(); followConn = nil end
    if not targetPlayer then Notify("Selecione um jogador!"); return end
    followActive = true
    Notify("Seguindo " .. targetPlayer.Name)

    followConn = RunService.RenderStepped:Connect(function()
        if not followActive or not targetPlayer or not targetPlayer.Character then
            return
        end
        local myHRP = GetHRP()
        local tgtHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myHRP and tgtHRP then
            local direction = (tgtHRP.CFrame.LookVector * -1)
            local targetPos = tgtHRP.Position + (direction * followDist) + Vector3.new(0, offsetHeight, 0)
            local hum = GetHum()
            if hum then
                hum.WalkSpeed = 24
                hum.AutoRotate = true
            end
            myHRP.CFrame = CFrame.lookAt(myHRP.Position, tgtHRP.Position)
            local dist = (myHRP.Position - targetPos).Magnitude
            if dist > 2 then
                local moveVec = (targetPos - myHRP.Position).Unit * math.min(dist, 50)
                myHRP.CFrame = myHRP.CFrame + moveVec
            end
        end
    end)
end

local function StopFollow()
    followActive = false
    if followConn then followConn:Disconnect(); followConn = nil end
    Notify("Parou de seguir")
end

-- ============================================================
-- UI
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "ObservadorHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 420)
main.Position = UDim2.new(0.5, -170, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 180, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "OBSERVADOR INVISIVEL"
title.TextColor3 = Color3.fromRGB(0, 180, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -12, 1, -50)
content.Position = UDim2.new(0, 6, 0, 42)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
content.BorderSizePixel = 0
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Parent = main
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
local pad = Instance.new("UIPadding", content)
pad.PaddingTop = UDim.new(0, 6)
pad.PaddingLeft = UDim.new(0, 6)
pad.PaddingRight = UDim.new(0, 6)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 12)
footer.Position = UDim2.new(0, 0, 1, -15)
footer.BackgroundTransparency = 1
footer.Text = "F2 = Abrir/Fechar"
footer.TextColor3 = Color3.fromRGB(60, 60, 90)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.Parent = main

-- ============================================================
-- UI ELEMENTS
-- ============================================================
local function addSection(text)
    local s = Instance.new("TextLabel")
    s.Size = UDim2.new(1, 0, 0, 20)
    s.BackgroundTransparency = 1
    s.Text = "  " .. text
    s.TextColor3 = Color3.fromRGB(0, 180, 255)
    s.TextSize = 11
    s.Font = Enum.Font.GothamBold
    s.TextXAlignment = Enum.TextXAlignment.Left
    s.Parent = content
end

local function addToggle(text, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 30)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    f.BorderSizePixel = 0
    f.Parent = content
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -48, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(200, 200, 220)
    l.TextSize = 12
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local tg = Instance.new("TextButton")
    tg.Size = UDim2.new(0, 36, 0, 18)
    tg.Position = UDim2.new(1, -44, 0.5, -9)
    tg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    tg.Text = ""
    tg.Parent = f
    Instance.new("UICorner", tg).CornerRadius = UDim.new(0, 9)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(0, 2, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
    dot.Parent = tg
    Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 7)
    local on = false
    tg.MouseButton1Click:Connect(function()
        on = not on
        if on then
            tg.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            dot:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.12, true)
            dot.BackgroundColor3 = Color3.new(1, 1, 1)
        else
            tg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            dot:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.12, true)
            dot.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
        end
        callback(on)
    end)
end

local function addButton(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(0, 150, 240) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(0, 120, 200) end)
    b.MouseButton1Click:Connect(callback)
end

local function addDangerButton(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(220, 40, 40) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(180, 30, 30) end)
    b.MouseButton1Click:Connect(callback)
end

local function addLabel(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "  " .. text
    l.TextColor3 = Color3.fromRGB(90, 90, 120)
    l.TextSize = 10
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = content
end

local function addSlider(text, min, max, def, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 38)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    f.BorderSizePixel = 0
    f.Parent = content
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.6, 0, 0, 16)
    l.Position = UDim2.new(0, 8, 0, 2)
    l.BackgroundTransparency = 1; l.Text = text
    l.TextColor3 = Color3.fromRGB(200, 200, 220); l.TextSize = 11; l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local vl = Instance.new("TextLabel")
    vl.Size = UDim2.new(0.4, -10, 0, 16)
    vl.Position = UDim2.new(0.6, 0, 0, 2)
    vl.BackgroundTransparency = 1; vl.Text = tostring(def)
    vl.TextColor3 = Color3.fromRGB(0, 180, 255); vl.TextSize = 11; vl.Font = Enum.Font.GothamBold
    vl.TextXAlignment = Enum.TextXAlignment.Right; vl.Parent = f
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -16, 0, 5)
    bar.Position = UDim2.new(0, 8, 0, 24)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 60); bar.Parent = f
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255); fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((def - min) / (max - min), -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.new(1, 1, 1); knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 6)
    local drag = false
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end end)
    knob.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max - min) * p)
            fill.Size = UDim2.new(p, 0, 1, 0)
            knob.Position = UDim2.new(p, -6, 0.5, -6)
            vl.Text = tostring(v); callback(v)
        end
    end)
end

-- ============================================================
-- BUILD MENU
-- ============================================================
addSection("CAPACIDADES DO OBSERVADOR")
addToggle("Invisibilidade Total", function(v) MakeInvisible(v) end)
addToggle("Seguir Jogador", function(v) if v then StartFollow() else StopFollow() end end)

addSection("ALVO")
local playerNames = {}
local selectedName = nil
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then table.insert(playerNames, p.Name) end
end

local dropFrame = Instance.new("Frame")
dropFrame.Size = UDim2.new(1, 0, 0, 34)
dropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
dropFrame.BorderSizePixel = 0
dropFrame.Parent = content
dropFrame.ClipsDescendants = true
Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)

local dropLabel = Instance.new("TextLabel")
dropLabel.Size = UDim2.new(0.4, 0, 0, 34)
dropLabel.Position = UDim2.new(0, 8, 0, 0)
dropLabel.BackgroundTransparency = 1
dropLabel.Text = "  Alvo"
dropLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
dropLabel.TextSize = 12
dropLabel.Font = Enum.Font.Gotham
dropLabel.TextXAlignment = Enum.TextXAlignment.Left
dropLabel.Parent = dropFrame

local dropBtn = Instance.new("TextButton")
dropBtn.Size = UDim2.new(0.55, -10, 0, 24)
dropBtn.Position = UDim2.new(0.42, 0, 0, 5)
dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
dropBtn.Text = "Selecionar..."
dropBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
dropBtn.TextSize = 11
dropBtn.Font = Enum.Font.Gotham
dropBtn.Parent = dropFrame
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 5)

local dropList = Instance.new("ScrollingFrame")
dropList.Size = UDim2.new(1, -12, 0, 100)
dropList.Position = UDim2.new(0, 6, 0, 38)
dropList.BackgroundTransparency = 1
dropList.ScrollBarThickness = 2
dropList.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
dropList.BorderSizePixel = 0
dropList.CanvasSize = UDim2.new(0, 0, 0, 0)
dropList.Visible = false
dropList.Parent = dropFrame
Instance.new("UIListLayout", dropList).Padding = UDim.new(0, 2)

local dropOpen = false
dropBtn.MouseButton1Click:Connect(function()
    dropOpen = not dropOpen
    dropList.Visible = dropOpen
    dropFrame.Size = dropOpen and UDim2.new(1, 0, 0, 142) or UDim2.new(1, 0, 0, 34)
end)

for _, name in ipairs(playerNames) do
    local ob = Instance.new("TextButton")
    ob.Size = UDim2.new(1, 0, 0, 22)
    ob.BackgroundColor3 = Color3.fromRGB(25, 25, 42)
    ob.Text = name
    ob.TextColor3 = Color3.fromRGB(180, 180, 200)
    ob.TextSize = 11
    ob.Font = Enum.Font.Gotham
    ob.Parent = dropList
    Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 4)
    ob.MouseEnter:Connect(function() ob.BackgroundColor3 = Color3.fromRGB(0, 100, 200) end)
    ob.MouseLeave:Connect(function() ob.BackgroundColor3 = Color3.fromRGB(25, 25, 42) end)
    ob.MouseButton1Click:Connect(function()
        dropBtn.Text = name
        selectedName = name
        targetPlayer = Players:FindFirstChild(name)
        dropOpen = false
        dropList.Visible = false
        dropFrame.Size = UDim2.new(1, 0, 0, 34)
        Notify("Alvo: " .. name)
    end)
end

addSection("DISTANCIA")
addSlider("Distancia do alvo", 3, 50, 10, function(v) followDist = v end)
addSlider("Altura (offset)", 0, 20, 5, function(v) offsetHeight = v end)

addSection("ACAO")
addButton("Seguir Agora", function()
    if targetPlayer then
        followActive = false
        if followConn then followConn:Disconnect(); followConn = nil end
        MakeInvisible(true)
        StartFollow()
    else
        Notify("Selecione um jogador!")
    end
end)

addDangerButton("Parar de Seguir", function()
    StopFollow()
end)

addSection("OBSERVACAO EM TEMPO REAL")
local obsFrame = Instance.new("Frame")
obsFrame.Size = UDim2.new(1, 0, 0, 80)
obsFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
obsFrame.BorderSizePixel = 0
obsFrame.Parent = content
Instance.new("UICorner", obsFrame).CornerRadius = UDim.new(0, 5)

local obsTitle = Instance.new("TextLabel")
obsTitle.Size = UDim2.new(1, -10, 0, 16)
obsTitle.Position = UDim2.new(0, 8, 0, 4)
obsTitle.BackgroundTransparency = 1
obsTitle.Text = "Status do Observador"
obsTitle.TextColor3 = Color3.fromRGB(0, 180, 255)
obsTitle.TextSize = 11
obsTitle.Font = Enum.Font.GothamBold
obsTitle.TextXAlignment = Enum.TextXAlignment.Left
obsTitle.Parent = obsFrame

local obsAlvo = Instance.new("TextLabel")
obsAlvo.Size = UDim2.new(1, -10, 0, 14)
obsAlvo.Position = UDim2.new(0, 8, 0, 22)
obsAlvo.BackgroundTransparency = 1
obsAlvo.Text = "Alvo: Nenhum"
obsAlvo.TextColor3 = Color3.fromRGB(160, 160, 180)
obsAlvo.TextSize = 10
obsAlvo.Font = Enum.Font.Gotham
obsAlvo.TextXAlignment = Enum.TextXAlignment.Left
obsAlvo.Parent = obsFrame

local obsDist = Instance.new("TextLabel")
obsDist.Size = UDim2.new(1, -10, 0, 14)
obsDist.Position = UDim2.new(0, 8, 0, 38)
obsDist.BackgroundTransparency = 1
obsDist.Text = "Distancia: --"
obsDist.TextColor3 = Color3.fromRGB(160, 160, 180)
obsDist.TextSize = 10
obsDist.Font = Enum.Font.Gotham
obsDist.TextXAlignment = Enum.TextXAlignment.Left
obsDist.Parent = obsFrame

local obsHP = Instance.new("TextLabel")
obsHP.Size = UDim2.new(1, -10, 0, 14)
obsHP.Position = UDim2.new(0, 8, 0, 54)
obsHP.BackgroundTransparency = 1
obsHP.Text = "HP: --"
obsHP.TextColor3 = Color3.fromRGB(160, 160, 180)
obsHP.TextSize = 10
obsHP.Font = Enum.Font.Gotham
obsHP.TextXAlignment = Enum.TextXAlignment.Left
obsHP.Parent = obsFrame

addLabel("F2 = Abrir/Fechar menu")

-- ============================================================
-- OBSERVATION LOOP
-- ============================================================
spawn(function()
    while true do
        task.wait(0.5)
        if targetPlayer and targetPlayer.Character then
            obsAlvo.Text = "Alvo: " .. targetPlayer.Name
            local myHRP = GetHRP()
            local tgtHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local tgtHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if myHRP and tgtHRP then
                local d = math.floor((tgtHRP.Position - myHRP.Position).Magnitude)
                obsDist.Text = "Distancia: " .. d .. " studs"
            end
            if tgtHum then
                obsHP.Text = "HP: " .. math.floor(tgtHum.Health) .. "/" .. math.floor(tgtHum.MaxHealth)
            end
        else
            obsAlvo.Text = "Alvo: Nenhum"
            obsDist.Text = "Distancia: --"
            obsHP.Text = "HP: --"
        end
    end
end)

-- ============================================================
-- KEYBIND
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F2 then
        main.Visible = not main.Visible
    end
end)

main.Visible = true
Notify("Observador Invisivel carregado! F2 = menu")
