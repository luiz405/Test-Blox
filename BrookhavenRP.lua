--[[
    BROOKHAVEN RP HUB - FINAL
    Zero dependencias externas
    Cole direto no executor
    Delete = Abrir/Fechar menu
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer

local noclipConn, flyConn, flyBody, flyGyro
local NoclipOn = false
local FlyOn = false
local AntiAFKOn = false
local EspOn = false

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Highlights"
ESPFolder.Parent = workspace

local function Notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = "Brookhaven Hub", Text = txt, Duration = 3 })
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

local oldWS, oldJP
local c = GetChar()
if c then
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then oldWS = h.WalkSpeed; oldJP = h.JumpPower end
end
LP.CharacterAdded:Connect(function(ch)
    local h = ch:WaitForChild("Humanoid")
    if NoclipOn then h.WalkSpeed = 24 else h.WalkSpeed = oldWS or 16 end
    if FlyOn then
        task.wait(0.5)
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if hrp then
            flyGyro = Instance.new("BodyGyro", hrp)
            flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            flyGyro.P = 9000
            flyGyro.D = 500
            flyBody = Instance.new("BodyVelocity", hrp)
            flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyBody.Velocity = Vector3.zero
        end
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "BrookhavenHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 380, 0, 480)
main.Position = UDim2.new(0.5, -190, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 120, 255)
stroke.Thickness = 1
stroke.Transparency = 0.4
stroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BROOKHAVEN RP HUB"
title.TextColor3 = Color3.fromRGB(0, 160, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1, -12, 0, 34)
tabs.Position = UDim2.new(0, 6, 0, 50)
tabs.BackgroundTransparency = 1
tabs.Parent = main
Instance.new("UIListLayout", tabs).FillDirection = Enum.FillDirection.Horizontal
Instance.new("UIListLayout", tabs).Padding = UDim.new(0, 3)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -12, 1, -100)
content.Position = UDim2.new(0, 6, 0, 90)
content.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
content.BorderSizePixel = 0
content.Parent = main
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 6)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 16)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.BackgroundTransparency = 1
footer.Text = "Delete = Abrir/Fechar"
footer.TextColor3 = Color3.fromRGB(80, 80, 110)
footer.TextSize = 11
footer.Font = Enum.Font.Gotham
footer.Parent = main

local tabBtns = {}
local tabFrames = {}
local currentTab = nil

local function switchTab(name)
    for n, f in pairs(tabFrames) do f.Visible = (n == name) end
    for n, b in pairs(tabBtns) do
        if n == name then
            b.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            b.TextColor3 = Color3.new(1, 1, 1)
        else
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            b.TextColor3 = Color3.fromRGB(140, 140, 170)
        end
    end
    currentTab = name
end

local function addTab(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 60, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(140, 140, 170)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.Parent = tabs
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 3
    f.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)
    f.BorderSizePixel = 0
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.Visible = false
    f.Parent = content
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 5)
    Instance.new("UIPadding", f).PaddingTop = UDim.new(0, 4)
    Instance.new("UIPadding", f).PaddingLeft = UDim.new(0, 4)
    Instance.new("UIPadding", f).PaddingRight = UDim.new(0, 4)

    tabBtns[name] = b
    tabFrames[name] = f
    b.MouseButton1Click:Connect(function() switchTab(name) end)
    return f
end

local function addSection(parent, text)
    local s = Instance.new("TextLabel")
    s.Size = UDim2.new(1, 0, 0, 22)
    s.BackgroundTransparency = 1
    s.Text = "  " .. text
    s.TextColor3 = Color3.fromRGB(0, 140, 255)
    s.TextSize = 12
    s.Font = Enum.Font.GothamBold
    s.TextXAlignment = Enum.TextXAlignment.Left
    s.Parent = parent
end

local function addToggle(parent, text, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    f.BorderSizePixel = 0
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -52, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(200, 200, 220)
    l.TextSize = 13
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local tg = Instance.new("TextButton")
    tg.Size = UDim2.new(0, 40, 0, 20)
    tg.Position = UDim2.new(1, -48, 0.5, -10)
    tg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    tg.Text = ""
    tg.Parent = f
    Instance.new("UICorner", tg).CornerRadius = UDim.new(0, 10)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new(0, 2, 0.5, -8)
    dot.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
    dot.Parent = tg
    Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 8)

    local on = false
    tg.MouseButton1Click:Connect(function()
        on = not on
        if on then
            tg.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            dot:TweenPosition(UDim2.new(1, -18, 0.5, -8), "Out", "Quad", 0.12, true)
            dot.BackgroundColor3 = Color3.new(1, 1, 1)
        else
            tg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            dot:TweenPosition(UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.12, true)
            dot.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
        end
        callback(on)
    end)
end

local function addButton(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(0, 130, 240) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(0, 100, 200) end)
    b.MouseButton1Click:Connect(callback)
end

local function addSlider(parent, text, min, max, def, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 44)
    f.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    f.BorderSizePixel = 0
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.65, 0, 0, 18)
    l.Position = UDim2.new(0, 10, 0, 3)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(200, 200, 220)
    l.TextSize = 12
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local vl = Instance.new("TextLabel")
    vl.Size = UDim2.new(0.35, -10, 0, 18)
    vl.Position = UDim2.new(0.65, 0, 0, 3)
    vl.BackgroundTransparency = 1
    vl.Text = tostring(def)
    vl.TextColor3 = Color3.fromRGB(0, 160, 255)
    vl.TextSize = 12
    vl.Font = Enum.Font.GothamBold
    vl.TextXAlignment = Enum.TextXAlignment.Right
    vl.Parent = f

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 6)
    bar.Position = UDim2.new(0, 10, 0, 28)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    bar.Parent = f
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((def - min) / (max - min), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 7)

    local drag = false
    knob.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end
    end)
    knob.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max - min) * p)
            fill.Size = UDim2.new(p, 0, 1, 0)
            knob.Position = UDim2.new(p, -7, 0.5, -7)
            vl.Text = tostring(v)
            callback(v)
        end
    end)
end

local function addDropdown(parent, text, opts, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    f.BorderSizePixel = 0
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    f.ClipsDescendants = true

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.45, 0, 0, 34)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(200, 200, 220)
    l.TextSize = 12
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -10, 0, 24)
    btn.Position = UDim2.new(0.48, 0, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 55)
    btn.Text = "Selecionar..."
    btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.Parent = f
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -12, 0, 100)
    list.Position = UDim2.new(0, 6, 0, 38)
    list.BackgroundTransparency = 1
    list.ScrollBarThickness = 2
    list.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)
    list.BorderSizePixel = 0
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.Visible = false
    list.Parent = f
    Instance.new("UIListLayout", list).Padding = UDim.new(0, 2)

    local open = false
    btn.MouseButton1Click:Connect(function()
        open = not open
        list.Visible = open
        f.Size = open and UDim2.new(1, 0, 0, 142) or UDim2.new(1, 0, 0, 34)
    end)

    for _, o in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1, 0, 0, 24)
        ob.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        ob.Text = o
        ob.TextColor3 = Color3.fromRGB(180, 180, 200)
        ob.TextSize = 11
        ob.Font = Enum.Font.Gotham
        ob.Parent = list
        Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 4)
        ob.MouseEnter:Connect(function() ob.BackgroundColor3 = Color3.fromRGB(0, 80, 180) end)
        ob.MouseLeave:Connect(function() ob.BackgroundColor3 = Color3.fromRGB(30, 30, 45) end)
        ob.MouseButton1Click:Connect(function()
            btn.Text = o
            open = false
            list.Visible = false
            f.Size = UDim2.new(1, 0, 0, 34)
            callback(o)
        end)
    end
end

local function addLabel(parent, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = "  " .. text
    l.TextColor3 = Color3.fromRGB(120, 120, 150)
    l.TextSize = 11
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
end

local tL = addTab("Local")
local tE = addTab("ESP")
local tT = addTab("Tools")
local tM = addTab("Misc")

addSection(tL, "Movimento")
addToggle(tL, "Noclip", function(v)
    NoclipOn = v
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if v then
        noclipConn = RunService.Stepped:Connect(function()
            local ch = GetChar()
            if ch then for _, p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end)
        Notify("Noclip Ativado")
    else Notify("Noclip Desativado") end
end)

addToggle(tL, "Fly (WASD)", function(v)
    FlyOn = v
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBody then flyBody:Destroy(); flyBody = nil end
    if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    if v then
        local hrp = GetHRP()
        if hrp then
            flyGyro = Instance.new("BodyGyro", hrp)
            flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            flyGyro.P = 9000
            flyGyro.D = 500
            flyBody = Instance.new("BodyVelocity", hrp)
            flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyBody.Velocity = Vector3.zero
            flyConn = RunService.RenderStepped:Connect(function()
                local cam = workspace.CurrentCamera
                local d = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.new(0, 1, 0) end
                if flyBody and flyGyro then flyBody.Velocity = d.Unit * 80; flyGyro.CFrame = cam.CFrame end
            end)
            Notify("Fly Ativado")
        end
    else Notify("Fly Desativado") end
end)

addSlider(tL, "Walk Speed", 16, 200, 16, function(v)
    local h = GetHum(); if h then h.WalkSpeed = v end
end)

addSlider(tL, "Jump Power", 50, 200, 50, function(v)
    local h = GetHum(); if h then h.JumpPower = v end
end)

addSection(tL, "Outros")
addButton(tL, "Resetar Personagem", function()
    local h = GetHum(); if h then h.Health = 0 end
end)
addButton(tL, "Copiar Server ID", function()
    setclipboard(game.JobId); Notify("Copiado!")
end)

addSection(tE, "Visual")
local function UpdateESP()
    for _, o in pairs(ESPFolder:GetChildren()) do o:Destroy() end
    if not EspOn then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local b = Instance.new("BoxHandleAdornment")
                b.Adornee = hrp; b.Size = Vector3.new(4, 5, 1)
                b.Color3 = Color3.fromRGB(0, 140, 255); b.Transparency = 0.5; b.AlwaysOnTop = true; b.Parent = ESPFolder
                local bg = Instance.new("BillboardGui")
                bg.Adornee = hrp; bg.Size = UDim2.new(0, 180, 0, 30); bg.StudsOffset = Vector3.new(0, 3, 0); bg.AlwaysOnTop = true; bg.Parent = ESPFolder
                local tl = Instance.new("TextLabel", bg)
                tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = plr.Name
                tl.TextColor3 = Color3.new(1, 1, 1); tl.TextScaled = true; tl.Font = Enum.Font.GothamBold; tl.TextStrokeTransparency = 0.5
            end
        end
    end
end

addToggle(tE, "ESP (Caixa + Nome)", function(v)
    EspOn = v
    if v then UpdateESP(); Notify("ESP On") else for _, o in pairs(ESPFolder:GetChildren()) do o:Destroy() end; Notify("ESP Off") end
end)
addButton(tE, "Atualizar ESP", function() if EspOn then UpdateESP() end end)
Players.PlayerAdded:Connect(function() if EspOn then task.wait(2); UpdateESP() end end)
Players.PlayerRemoving:Connect(function() if EspOn then task.wait(1); UpdateESP() end end)

addSection(tT, "Player")
addButton(tT, "Invisibility", function()
    local ch = GetChar()
    if ch then
        local t = ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
        if t then
            t.Transparency = 1
            if t:FindFirstChild("roblox") then t.roblox:Destroy() end
            local p = Instance.new("Part", t); p.Name = "ip"; p.Size = t.Size; p.Transparency = 1; p.CanCollide = false
            local w = Instance.new("Weld", p); w.Part0 = t; w.Part1 = p
            Notify("Invis Ativado")
        end
    end
end)

addSection(tT, "Teleport")
local pNames = {}
local selP = nil
for _, p in pairs(Players:GetPlayers()) do if p ~= LP then table.insert(pNames, p.Name) end end
addDropdown(tT, "Jogador", pNames, function(o) selP = o end)
addButton(tT, "Teleportar!", function()
    if selP then
        local tgt = Players:FindFirstChild(selP)
        if tgt and tgt.Character then
            local my = GetHRP(); local th = tgt.Character:FindFirstChild("HumanoidRootPart")
            if my and th then my.CFrame = th.CFrame * CFrame.new(0, 0, -5); Notify("TP -> " .. selP) end
        end
    else Notify("Selecione um jogador!") end
end)

addSection(tM, "Utilidades")
addToggle(tM, "Anti-AFK", function(v)
    AntiAFKOn = v
    if v then
        Notify("Anti-AFK On")
        spawn(function()
            while AntiAFKOn do
                task.wait(30)
                pcall(function()
                    local vu = game:GetService("VirtualUser")
                    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(0.1)
                    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
            end
        end)
    else Notify("Anti-AFK Off") end
end)

addButton(tM, "Server Hop", function()
    pcall(function()
        local http = game:GetService("HttpService")
        local t = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = http:JSONDecode(t)
        local srv = {}
        if data and data.data then
            for _, s in pairs(data.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then table.insert(srv, s.id) end
            end
        end
        if #srv > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, srv[math.random(1, #srv)], LP)
        else Notify("Nenhum servidor") end
    end)
end)

addLabel(tM, "Delete = Abrir/Fechar")

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Delete then main.Visible = not main.Visible end
end)

switchTab("Local")
main.Visible = true
Notify("Hub carregado! Delete = menu")
