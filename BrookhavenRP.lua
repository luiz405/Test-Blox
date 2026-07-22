--[[
    BROOKHAVEN RP HUB - SECURITY TESTING TOOLKIT v9.0
    Para testes de seguranca em jogos proprios
    Delete = Abrir/Fechar menu
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

local noclipConn, flyConn, flyBody, flyGyro
local NoclipOn = false
local FlyOn = false
local AntiAFKOn = false
local EspOn = false
local RemoteSpyOn = false
local GodModeOn = false
local NukeOn = false

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Highlights"
ESPFolder.Parent = workspace

local RemoteLog = {}
local HookedRemotes = {}

local function Notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = "Security Test", Text = txt, Duration = 4 })
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

local function LogRemote(name, args)
    table.insert(RemoteLog, {
        time = os.time(),
        name = name,
        args = args
    })
    if #RemoteLog > 200 then table.remove(RemoteLog, 1) end
end

-- ============================================================
-- UI
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "SecTestHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 420, 0, 520)
main.Position = UDim2.new(0.5, -210, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 50, 50)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
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
title.Text = "SECURITY TEST HUB"
title.TextColor3 = Color3.fromRGB(255, 60, 60)
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
footer.Text = "Delete = Abrir/Fechar | Ferramentas de teste de seguranca"
footer.TextColor3 = Color3.fromRGB(80, 80, 110)
footer.TextSize = 11
footer.Font = Enum.Font.Gotham
footer.Parent = main

local tabBtns = {}
local tabFrames = {}

local function switchTab(name)
    for n, f in pairs(tabFrames) do f.Visible = (n == name) end
    for n, b in pairs(tabBtns) do
        b.BackgroundColor3 = (n == name) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(30, 30, 45)
        b.TextColor3 = (n == name) and Color3.new(1, 1, 1) or Color3.fromRGB(140, 140, 170)
    end
end

local function addTab(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 68, 1, 0)
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
    f.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
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
    s.TextColor3 = Color3.fromRGB(255, 60, 60)
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
            tg.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
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
    b.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(220, 40, 40) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(180, 30, 30) end)
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
    vl.TextColor3 = Color3.fromRGB(255, 80, 80)
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
    fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((def - min) / (max - min), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 7)
    local drag = false
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end end)
    knob.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
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

local function addLogBox(parent, name, height)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "  " .. name
    l.TextColor3 = Color3.fromRGB(200, 200, 220)
    l.TextSize = 11
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    local box = Instance.new("ScrollingFrame")
    box.Size = UDim2.new(1, 0, 0, height or 100)
    box.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    box.BorderSizePixel = 0
    box.ScrollBarThickness = 3
    box.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    box.CanvasSize = UDim2.new(0, 0, 0, 0)
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    local layout = Instance.new("UIListLayout", box)
    layout.Padding = UDim.new(0, 1)
    return box
end

-- ============================================================
-- TABS
-- ============================================================
local tExploit = addTab("Exploit")
local tRemotes = addTab("Remotes")
local tDump = addTab("Dump")
local tNetwork = addTab("Network")

-- ============================================================
-- TAB: EXPLOIT
-- ============================================================
addSection(tExploit, "Movimento")

addToggle(tExploit, "Noclip (Atravessar paredes)", function(v)
    NoclipOn = v
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if v then
        noclipConn = RunService.Stepped:Connect(function()
            local ch = GetChar()
            if ch then for _, p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end)
        Notify("Noclip ON")
    else Notify("Noclip OFF") end
end)

addToggle(tExploit, "Fly (WASD + Space/Shift)", function(v)
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
            Notify("Fly ON")
        end
    else Notify("Fly OFF") end
end)

addSlider(tExploit, "Walk Speed", 16, 500, 16, function(v)
    local h = GetHum(); if h then h.WalkSpeed = v end
end)

addSlider(tExploit, "Jump Power", 50, 500, 50, function(v)
    local h = GetHum(); if h then h.JumpPower = v end
end)

addSection(tExploit, "ExploraÃ§Ã£o")

addToggle(tExploit, "God Mode (InvencÃ­vel)", function(v)
    GodModeOn = v
    if v then
        spawn(function()
            while GodModeOn do
                task.wait(0.1)
                local c = GetChar()
                if c then
                    local h = c:FindFirstChildOfClass("Humanoid")
                    if h then
                        h.Health = h.MaxHealth
                        h:GetPropertyChangedSignal("Health"):Connect(function()
                            if GodModeOn then h.Health = h.MaxHealth end
                        end)
                    end
                end
            end
        end)
        Notify("God Mode ON")
    else Notify("God Mode OFF") end
end)

addToggle(tExploit, "Invisibility", function(v)
    if v then
        local ch = GetChar()
        if ch then
            for _, p in pairs(ch:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.Transparency = 1
                elseif p:IsA("Decal") then
                    p.Transparency = 1
                end
            end
            ch.DescendantAdded:Connect(function(p)
                if v and p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.Transparency = 1
                elseif v and p:IsA("Decal") then
                    p.Transparency = 1
                end
            end)
            Notify("Invisibility ON")
        end
    else Notify("Invisibility OFF") end
end)

addButton(tExploit, "Resetar Personagem", function()
    local h = GetHum(); if h then h.Health = 0 end
end)

addButton(tExploit, "ForÃ§ar Respawn", function()
    local ch = GetChar()
    if ch then
        local h = ch:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
        task.wait(1)
        local hrp = GetHRP()
        if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, -50, 0) end
    end
end)

-- ============================================================
-- TAB: REMOTES
-- ============================================================
addSection(tRemotes, "Remote Spy")

local logBox = addLogBox(tRemotes, "Log de Remotes", 120)

addToggle(tRemotes, "Remote Spy (Capturar chamadas)", function(v)
    RemoteSpyOn = v
    if v then
        Notify("Remote Spy ON - capturando...")
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not HookedRemotes[obj] then
                HookedRemotes[obj] = true
                if obj:IsA("RemoteEvent") then
                    obj.OnClientEvent:Connect(function(...)
                        if RemoteSpyOn then
                            local args = {...}
                            LogRemote(obj.Name, args)
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(1, 0, 0, 16)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = "  [RECV] " .. obj.Name .. " | " .. tostring(#args) .. " args"
                            lbl.TextColor3 = Color3.fromRGB(100, 200, 255)
                            lbl.TextSize = 10
                            lbl.Font = Enum.Font.Code
                            lbl.TextXAlignment = Enum.TextXAlignment.Left
                            lbl.Parent = logBox
                            logBox.CanvasSize = UDim2.new(0, 0, 0, logBox.CanvasSize.Y.Offset + 16)
                        end
                    end)
                end
            end
        end
        ReplicatedStorage.DescendantAdded:Connect(function(obj)
            if RemoteSpyOn and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not HookedRemotes[obj] then
                HookedRemotes[obj] = true
                if obj:IsA("RemoteEvent") then
                    obj.OnClientEvent:Connect(function(...)
                        if RemoteSpyOn then
                            local args = {...}
                            LogRemote(obj.Name, args)
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(1, 0, 0, 16)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = "  [RECV] " .. obj.Name .. " | " .. tostring(#args) .. " args"
                            lbl.TextColor3 = Color3.fromRGB(100, 200, 255)
                            lbl.TextSize = 10
                            lbl.Font = Enum.Font.Code
                            lbl.TextXAlignment = Enum.TextXAlignment.Left
                            lbl.Parent = logBox
                            logBox.CanvasSize = UDim2.new(0, 0, 0, logBox.CanvasSize.Y.Offset + 16)
                        end
                    end)
                end
            end
        end)
    else
        Notify("Remote Spy OFF")
    end
end)

addButton(tRemotes, "Limpar Log", function()
    for _, c in pairs(logBox:GetChildren()) do c:Destroy() end
    RemoteLog = {}
    logBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    Notify("Log limpo")
end)

addSection(tRemotes, "Envio Manual")

addButton(tRemotes, "FireServer em todos os RemoteEvents", function()
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function()
                obj:FireServer("Test", 123, true)
                count = count + 1
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 0, 16)
                lbl.BackgroundTransparency = 1
                lbl.Text = "  [FIRE] " .. obj.Name
                lbl.TextColor3 = Color3.fromRGB(255, 100, 100)
                lbl.TextSize = 10
                lbl.Font = Enum.Font.Code
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Parent = logBox
                logBox.CanvasSize = UDim2.new(0, 0, 0, logBox.CanvasSize.Y.Offset + 16)
            end)
        end
    end
    Notify("FireServer em " .. count .. " remotes")
end)

addButton(tRemotes, "InvokeServer em todos os RemoteFunctions", function()
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteFunction") then
            pcall(function()
                obj:InvokeServer("Test", 123, true)
                count = count + 1
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 0, 16)
                lbl.BackgroundTransparency = 1
                lbl.Text = "  [INVOKE] " .. obj.Name
                lbl.TextColor3 = Color3.fromRGB(255, 180, 50)
                lbl.TextSize = 10
                lbl.Font = Enum.Font.Code
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Parent = logBox
                logBox.CanvasSize = UDim2.new(0, 0, 0, logBox.CanvasSize.Y.Offset + 16)
            end)
        end
    end
    Notify("InvokeServer em " .. count .. " remote functions")
end)

addButton(tRemotes, "FireServer com nil/tables grandes", function()
    local bigTable = {}
    for i = 1, 1000 do bigTable[i] = string.rep("A", 100) end
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function()
                obj:FireServer(nil, bigTable, {}, nil, math.huge, -math.huge)
                count = count + 1
            end)
        end
    end
    Notify("Stress test em " .. count .. " remotes (tabelas grandes + nil)")
end)

-- ============================================================
-- TAB: DUMP
-- ============================================================
addSection(tDump, "AnÃ¡lise do Jogo")

local dumpBox = addLogBox(tDump, "Resultado", 160)

addButton(tDump, "Listar TODOS os Remotes", function()
    for _, c in pairs(dumpBox:GetChildren()) do c:Destroy() end
    dumpBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            count = count + 1
            local tipo = obj:IsA("RemoteEvent") and "Event" or "Function"
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = "  [" .. tipo .. "] " .. obj:GetFullName()
            lbl.TextColor3 = (tipo == "Event") and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(255, 200, 100)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Code
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = dumpBox
            dumpBox.CanvasSize = UDim2.new(0, 0, 0, dumpBox.CanvasSize.Y.Offset + 14)
        end
    end
    addLabel(dumpBox, "Total: " .. count .. " remotes encontrados")
    dumpBox.CanvasSize = UDim2.new(0, 0, 0, dumpBox.CanvasSize.Y.Offset + 20)
    Notify(count .. " remotes encontrados")
end)

addButton(tDump, "Listar ModuleScripts", function()
    for _, c in pairs(dumpBox:GetChildren()) do c:Destroy() end
    dumpBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("ModuleScript") then
            count = count + 1
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = "  [Module] " .. obj:GetFullName()
            lbl.TextColor3 = Color3.fromRGB(150, 255, 150)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Code
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = dumpBox
            dumpBox.CanvasSize = UDim2.new(0, 0, 0, dumpBox.CanvasSize.Y.Offset + 14)
        end
    end
    Notify(count .. " ModuleScripts encontrados")
end)

addButton(tDump, "Listar LocalScripts", function()
    for _, c in pairs(dumpBox:GetChildren()) do c:Destroy() end
    dumpBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    local count = 0
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") then
            count = count + 1
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = "  [LocalScript] " .. obj:GetFullName()
            lbl.TextColor3 = Color3.fromRGB(200, 150, 255)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Code
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = dumpBox
            dumpBox.CanvasSize = UDim2.new(0, 0, 0, dumpBox.CanvasSize.Y.Offset + 14)
        end
    end
    Notify(count .. " LocalScripts encontrados")
end)

addButton(tDump, "Listar BindableEvents/Functions", function()
    for _, c in pairs(dumpBox:GetChildren()) do c:Destroy() end
    dumpBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    local count = 0
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
            count = count + 1
            local tipo = obj:IsA("BindableEvent") and "BEvent" or "BFunc"
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = "  [" .. tipo .. "] " .. obj:GetFullName()
            lbl.TextColor3 = Color3.fromRGB(255, 200, 100)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Code
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = dumpBox
            dumpBox.CanvasSize = UDim2.new(0, 0, 0, dumpBox.CanvasSize.Y.Offset + 14)
        end
    end
    Notify(count .. " Bindables encontrados")
end)

addButton(tDump, "Estrutura do Workspace", function()
    for _, c in pairs(dumpBox:GetChildren()) do c:Destroy() end
    dumpBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    local function scan(parent, depth)
        for _, obj in pairs(parent:GetChildren()) do
            local prefix = string.rep("  ", depth)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = "  " .. prefix .. obj.Name .. " [" .. obj.ClassName .. "]"
            lbl.TextColor3 = Color3.fromRGB(180, 180, 200)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Code
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = dumpBox
            dumpBox.CanvasSize = UDim2.new(0, 0, 0, dumpBox.CanvasSize.Y.Offset + 14)
            if depth < 3 then scan(obj, depth + 1) end
        end
    end
    scan(workspace, 0)
    Notify("Workspace structure dumped")
end)

addButton(tDump, "Listar Players + Dados", function()
    for _, c in pairs(dumpBox:GetChildren()) do c:Destroy() end
    dumpBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    for _, plr in pairs(Players:GetPlayers()) do
        local info = plr.Name .. " | UserId: " .. plr.UserId .. " | AccountAge: " .. plr.AccountAge .. "d"
        if plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h then info = info .. " | HP: " .. math.floor(h.Health) .. "/" .. math.floor(h.MaxHealth) .. " | Speed: " .. h.WalkSpeed end
        end
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 14)
        lbl.BackgroundTransparency = 1
        lbl.Text = "  " .. info
        lbl.TextColor3 = (plr == LP) and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 200, 220)
        lbl.TextSize = 10
        lbl.Font = Enum.Font.Code
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = dumpBox
        dumpBox.CanvasSize = UDim2.new(0, 0, 0, dumpBox.CanvasSize.Y.Offset + 14)
    end
end)

-- ============================================================
-- TAB: NETWORK
-- ============================================================
addSection(tNetwork, "ESP + Info")

addToggle(tNetwork, "ESP (Caixa + Nome + HP)", function(v)
    EspOn = v
    if v then
        Notify("ESP ON")
    else
        for _, o in pairs(ESPFolder:GetChildren()) do o:Destroy() end
        Notify("ESP OFF")
    end
end)

spawn(function()
    while true do
        task.wait(1)
        if EspOn then
            for _, o in pairs(ESPFolder:GetChildren()) do o:Destroy() end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local h = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hrp then
                        local b = Instance.new("BoxHandleAdornment")
                        b.Adornee = hrp; b.Size = Vector3.new(4, 5, 1)
                        b.Color3 = Color3.fromRGB(255, 50, 50); b.Transparency = 0.4; b.AlwaysOnTop = true; b.Parent = ESPFolder
                        local bg = Instance.new("BillboardGui")
                        bg.Adornee = hrp; bg.Size = UDim2.new(0, 200, 0, 50); bg.StudsOffset = Vector3.new(0, 3, 0); bg.AlwaysOnTop = true; bg.Parent = ESPFolder
                        local info = plr.Name
                        if h then info = info .. " | HP:" .. math.floor(h.Health) .. "/" .. math.floor(h.MaxHealth) end
                        local tl = Instance.new("TextLabel", bg)
                        tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = info
                        tl.TextColor3 = Color3.new(1, 1, 1); tl.TextScaled = true; tl.Font = Enum.Font.GothamBold; tl.TextStrokeTransparency = 0.5
                    end
                end
            end
        end
    end
end)

addSection(tNetwork, "Anti-AFK")

addToggle(tNetwork, "Anti-AFK", function(v)
    AntiAFKOn = v
    if v then
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
        Notify("Anti-AFK ON")
    else Notify("Anti-AFK OFF") end
end)

addSection(tNetwork, "Teleport")

addButton(tNetwork, "Server Hop", function()
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

addButton(tNetwork, "Copiar Server ID", function()
    setclipboard(game.JobId); Notify("Copiado!")
end)

addLabel(tNetwork, "Delete = Abrir/Fechar")

-- ============================================================
-- KEYBIND
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Delete then main.Visible = not main.Visible end
end)

switchTab("Exploit")
main.Visible = true
Notify("Security Test Hub v9.0 carregado!")
