--[[
    BROOKHAVEN RP HUB - SECURITY TESTING TOOLKIT v10.0
    Drawing ESP + Remote Events + Exploit Tools
    Delete = Abrir/Fechar menu
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================================
-- ESTADO
-- ============================================================
local noclipConn, flyConn, flyBody, flyGyro
local NoclipOn = false
local FlyOn = false
local AntiAFKOn = false
local EspOn = false
local EspBoxOn = false
local EspNameOn = false
local EspHPOn = false
local EspTracerOn = false
local EspSkeletonOn = false
local RemoteSpyOn = false
local GodModeOn = false

local ESPObjects = {}
local RemoteLog = {}
local HookedRemotes = {}
local EspUpdateConn = nil

-- ============================================================
-- ESP CONFIG
-- ============================================================
local espConfig = {
    boxColor = Color3.new(1, 0, 0),
    tracerColor = Color3.new(1, 0, 0),
    nameColor = Color3.new(1, 1, 1),
    hpColor = Color3.new(0, 1, 0),
    skeletonColor = Color3.new(1, 1, 1),
    boxThickness = 1.5,
    tracerThickness = 1.5,
    skeletonThickness = 1,
    textSize = 14,
    range = 500,
    showTeam = false,
    teamColor = Color3.new(0, 1, 0),
}

-- ============================================================
-- FUNCOES AUXILIARES
-- ============================================================
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
    table.insert(RemoteLog, { time = os.time(), name = name, args = args })
    if #RemoteLog > 500 then table.remove(RemoteLog, 1) end
end

local function WorldToScreen(pos)
    local sp, on = Camera:WorldToScreenPoint(pos)
    return Vector2.new(sp.X, sp.Y), on
end

-- ============================================================
-- DRAWING ESP
-- ============================================================
local function ClearESP()
    for _, obj in pairs(ESPObjects) do
        for _, drawing in pairs(obj) do
            pcall(function() drawing:Remove() end)
        end
    end
    ESPObjects = {}
end

local function CreateESPForPlayer(plr)
    if plr == LP then return end
    if ESPObjects[plr] then return end

    local boxOutline = Drawing.new("Quad")
    boxOutline.Thickness = 3
    boxOutline.Color = Color3.new(0, 0, 0)
    boxOutline.Filled = false
    boxOutline.Visible = false
    boxOutline.ZIndex = 1

    local box = Drawing.new("Quad")
    box.Thickness = espConfig.boxThickness
    box.Color = espConfig.boxColor
    box.Filled = false
    box.Visible = false
    box.ZIndex = 2

    local tracer = Drawing.new("Line")
    tracer.Thickness = espConfig.tracerThickness
    tracer.Color = espConfig.tracerColor
    tracer.Visible = false
    tracer.ZIndex = 2

    local name = Drawing.new("Text")
    name.Size = espConfig.textSize
    name.Color = espConfig.nameColor
    name.Center = true
    name.Outline = true
    name.OutlineColor = Color3.new(0, 0, 0)
    name.Visible = false
    name.ZIndex = 2

    local hpBg = Drawing.new("Line")
    hpBg.Thickness = 4
    hpBg.Color = Color3.new(0, 0, 0)
    hpBg.Visible = false
    hpBg.ZIndex = 1

    local hp = Drawing.new("Line")
    hp.Thickness = 2
    hp.Color = espConfig.hpColor
    hp.Visible = false
    hp.ZIndex = 2

    local dist = Drawing.new("Text")
    dist.Size = 11
    dist.Color = Color3.fromRGB(180, 180, 180)
    dist.Center = true
    dist.Outline = true
    dist.OutlineColor = Color3.new(0, 0, 0)
    dist.Visible = false
    dist.ZIndex = 2

    ESPObjects[plr] = {
        boxOutline = boxOutline,
        box = box,
        tracer = tracer,
        name = name,
        hpBg = hpBg,
        hp = hp,
        dist = dist,
    }
end

local function RemoveESPForPlayer(plr)
    if ESPObjects[plr] then
        for _, drawing in pairs(ESPObjects[plr]) do
            pcall(function() drawing:Remove() end)
        end
        ESPObjects[plr] = nil
    end
end

local function GetBoundingBox(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local leg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftFoot")
    if not root or not head then return nil end

    local topPos = head.Position + Vector3.new(0, 0.5, 0)
    local botPos = leg and (leg.Position - Vector3.new(0, 0.5, 0)) or (root.Position - Vector3.new(0, 3, 0))

    local top2d, topOn = Camera:WorldToScreenPoint(topPos)
    local bot2d, botOn = Camera:WorldToScreenPoint(botPos)

    if not topOn or not botOn then return nil end

    local height = math.abs(top2d.Y - bot2d.Y)
    local width = height * 0.6

    local topLeft = Vector2.new(top2d.X - width / 2, top2d.Y)
    local topRight = Vector2.new(top2d.X + width / 2, top2d.Y)
    local botLeft = Vector2.new(bot2d.X - width / 2, bot2d.Y)
    local botRight = Vector2.new(bot2d.X + width / 2, bot2d.Y)

    return {
        topLeft = topLeft,
        topRight = topRight,
        botLeft = botLeft,
        botRight = botRight,
        topCenter = Vector2.new(top2d.X, top2d.Y),
        botCenter = Vector2.new(bot2d.X, bot2d.Y),
        center = Vector2.new(top2d.X, (top2d.Y + bot2d.Y) / 2),
        height = height,
    }
end

local function UpdateESP()
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            CreateESPForPlayer(plr)
            local obj = ESPObjects[plr]
            if not obj then continue end

            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local shouldShow = false

            if char and root and hum and hum.Health > 0 then
                if myRoot then
                    local dist = (root.Position - myRoot.Position).Magnitude
                    shouldShow = dist <= espConfig.range
                else
                    shouldShow = true
                end
            end

            if shouldShow then
                local bb = GetBoundingBox(char)
                if bb then
                    local color = espConfig.boxColor
                    if plr.Team and plr.Team == LP.Team then
                        color = espConfig.teamColor
                    end

                    -- Box
                    if EspBoxOn then
                        obj.boxOutline.Points = { bb.topLeft, bb.topRight, bb.botRight, bb.botLeft }
                        obj.boxOutline.Visible = true
                        obj.box.Points = { bb.topLeft, bb.topRight, bb.botRight, bb.botLeft }
                        obj.box.Color = color
                        obj.box.Visible = true
                    else
                        obj.boxOutline.Visible = false
                        obj.box.Visible = false
                    end

                    -- Tracer
                    if EspTracerOn then
                        local screenSize = Camera.ViewportSize
                        local from = Vector2.new(screenSize.X / 2, screenSize.Y)
                        obj.tracer.From = from
                        obj.tracer.To = bb.botCenter
                        obj.tracer.Color = color
                        obj.tracer.Visible = true
                    else
                        obj.tracer.Visible = false
                    end

                    -- Name
                    if EspNameOn then
                        obj.name.Position = bb.topCenter - Vector2.new(0, 16)
                        obj.name.Text = plr.Name
                        obj.name.Color = espConfig.nameColor
                        obj.name.Visible = true
                    else
                        obj.name.Visible = false
                    end

                    -- HP Bar
                    if EspHPOn and hum then
                        local hpPct = hum.Health / hum.MaxHealth
                        local barHeight = bb.height
                        local barX = bb.topLeft.X - 5
                        local barTop = bb.topLeft.Y
                        local barBot = bb.botLeft.Y
                        local hpY = barBot - (barHeight * hpPct)

                        obj.hpBg.From = Vector2.new(barX, barTop)
                        obj.hpBg.To = Vector2.new(barX, barBot)
                        obj.hpBg.Visible = true

                        obj.hp.From = Vector2.new(barX, barBot)
                        obj.hp.To = Vector2.new(barX, hpY)
                        if hpPct > 0.5 then
                            obj.hp.Color = Color3.new(0, 1, 0)
                        elseif hpPct > 0.25 then
                            obj.hp.Color = Color3.new(1, 1, 0)
                        else
                            obj.hp.Color = Color3.new(1, 0, 0)
                        end
                        obj.hp.Visible = true
                    else
                        obj.hpBg.Visible = false
                        obj.hp.Visible = false
                    end

                    -- Distance
                    if myRoot then
                        local d = math.floor((root.Position - myRoot.Position).Magnitude)
                        obj.dist.Position = bb.botCenter + Vector2.new(0, 4)
                        obj.dist.Text = d .. "m"
                        obj.dist.Visible = true
                    else
                        obj.dist.Visible = false
                    end
                else
                    obj.boxOutline.Visible = false
                    obj.box.Visible = false
                    obj.tracer.Visible = false
                    obj.name.Visible = false
                    obj.hpBg.Visible = false
                    obj.hp.Visible = false
                    obj.dist.Visible = false
                end
            else
                obj.boxOutline.Visible = false
                obj.box.Visible = false
                obj.tracer.Visible = false
                obj.name.Visible = false
                obj.hpBg.Visible = false
                obj.hp.Visible = false
                obj.dist.Visible = false
            end
        end
    end
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
main.Size = UDim2.new(0, 440, 0, 540)
main.Position = UDim2.new(0.5, -220, 0.5, -270)
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
title.Text = "SECURITY TEST HUB v10"
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
footer.Text = "Delete = Abrir/Fechar | v10.0 Drawing ESP"
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
    Instance.new("UIListLayout", box).Padding = UDim.new(0, 1)
    return box
end

-- ============================================================
-- TABS
-- ============================================================
local tESP = addTab("ESP")
local tExploit = addTab("Exploit")
local tRemotes = addTab("Remotes")
local tDump = addTab("Dump")

-- ============================================================
-- TAB: ESP (Drawing)
-- ============================================================
addSection(tESP, "Drawing ESP (2D)")

addToggle(tESP, "ESP Box (Caixa 3D)", function(v)
    EspBoxOn = v
    if v then
        EspOn = true
        Notify("Box ESP ON")
    else
        if not EspNameOn and not EspHPOn and not EspTracerOn then
            EspOn = false
            ClearESP()
        end
        Notify("Box ESP OFF")
    end
end)

addToggle(tESP, "ESP Tracer (Linha)", function(v)
    EspTracerOn = v
    if v then
        EspOn = true
        Notify("Tracer ESP ON")
    else
        if not EspBoxOn and not EspNameOn and not EspHPOn then
            EspOn = false
            ClearESP()
        end
        Notify("Tracer ESP OFF")
    end
end)

addToggle(tESP, "ESP Name (Nome)", function(v)
    EspNameOn = v
    if v then EspOn = true end
    if not EspBoxOn and not EspHPOn and not EspTracerOn and not v then
        EspOn = false
        ClearESP()
    end
    Notify(v and "Name ESP ON" or "Name ESP OFF")
end)

addToggle(tESP, "ESP HP (Barra de vida)", function(v)
    EspHPOn = v
    if v then EspOn = true end
    if not EspBoxOn and not EspNameOn and not EspTracerOn and not v then
        EspOn = false
        ClearESP()
    end
    Notify(v and "HP ESP ON" or "HP ESP OFF")
end)

addSection(tESP, "ConfiguraÃ§Ã£o")

addSlider(tESP, "Alcance ( studs )", 50, 2000, 500, function(v)
    espConfig.range = v
end)

addSlider(tESP, "Text Size", 8, 24, 14, function(v)
    espConfig.textSize = v
end)

addLabel(tESP, "Cor da Box: (padrÃ£o = vermelho)")

addButton(tESP, "Cor: VERMELHO", function()
    espConfig.boxColor = Color3.new(1, 0, 0)
    espConfig.tracerColor = Color3.new(1, 0, 0)
    Notify("Cor = Vermelho")
end)

addButton(tESP, "Cor: VERDE", function()
    espConfig.boxColor = Color3.new(0, 1, 0)
    espConfig.tracerColor = Color3.new(0, 1, 0)
    Notify("Cor = Verde")
end)

addButton(tESP, "Cor: AZUL", function()
    espConfig.boxColor = Color3.new(0, 0.5, 1)
    espConfig.tracerColor = Color3.new(0, 0.5, 1)
    Notify("Cor = Azul")
end)

addButton(tESP, "Cor: ROSA", function()
    espConfig.boxColor = Color3.new(1, 0, 1)
    espConfig.tracerColor = Color3.new(1, 0, 1)
    Notify("Cor = Rosa")
end)

-- ============================================================
-- TAB: EXPLOIT
-- ============================================================
addSection(tExploit, "Movimento")

addToggle(tExploit, "Noclip", function(v)
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

addToggle(tExploit, "Fly (WASD)", function(v)
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

addToggle(tExploit, "God Mode", function(v)
    GodModeOn = v
    if v then
        spawn(function()
            while GodModeOn do
                task.wait(0.1)
                local h = GetHum()
                if h then
                    h.Health = h.MaxHealth
                end
            end
        end)
        Notify("God Mode ON")
    else Notify("God Mode OFF") end
end)

addButton(tExploit, "Resetar Personagem", function()
    local h = GetHum(); if h then h.Health = 0 end
end)

addButton(tExploit, "ForÃ§ar Respawn", function()
    local ch = GetChar()
    if ch then
        local h = ch:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
        task.wait(0.5)
        local hrp = GetHRP()
        if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, -100, 0) end
    end
end)

-- ============================================================
-- TAB: REMOTES
-- ============================================================
addSection(tRemotes, "Remote Spy")

local logBox = addLogBox(tRemotes, "Log de Remotes", 100)

addToggle(tRemotes, "Remote Spy (Capturar)", function(v)
    RemoteSpyOn = v
    if v then
        Notify("Remote Spy ON")
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not HookedRemotes[obj] then
                HookedRemotes[obj] = true
                if obj:IsA("RemoteEvent") then
                    obj.OnClientEvent:Connect(function(...)
                        if RemoteSpyOn then
                            local args = {...}
                            LogRemote(obj.Name, args)
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(1, 0, 0, 14)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = "  [RECV] " .. obj.Name .. " | " .. tostring(#args) .. " args"
                            lbl.TextColor3 = Color3.fromRGB(100, 200, 255)
                            lbl.TextSize = 10
                            lbl.Font = Enum.Font.Code
                            lbl.TextXAlignment = Enum.TextXAlignment.Left
                            lbl.Parent = logBox
                            logBox.CanvasSize = UDim2.new(0, 0, 0, logBox.CanvasSize.Y.Offset + 14)
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
                            lbl.Size = UDim2.new(1, 0, 0, 14)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = "  [RECV] " .. obj.Name .. " | " .. tostring(#args) .. " args"
                            lbl.TextColor3 = Color3.fromRGB(100, 200, 255)
                            lbl.TextSize = 10
                            lbl.Font = Enum.Font.Code
                            lbl.TextXAlignment = Enum.TextXAlignment.Left
                            lbl.Parent = logBox
                            logBox.CanvasSize = UDim2.new(0, 0, 0, logBox.CanvasSize.Y.Offset + 14)
                        end
                    end)
                end
            end
        end)
    else Notify("Remote Spy OFF") end
end)

addButton(tRemotes, "Limpar Log", function()
    for _, c in pairs(logBox:GetChildren()) do c:Destroy() end
    RemoteLog = {}
    logBox.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

addSection(tRemotes, "Envio Manual")

addButton(tRemotes, "FireServer (todos os RemoteEvents)", function()
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function() obj:FireServer("Test", 123, true, nil, math.huge) end)
            count = count + 1
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = "  [FIRE] " .. obj.Name
            lbl.TextColor3 = Color3.fromRGB(255, 100, 100)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Code
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = logBox
            logBox.CanvasSize = UDim2.new(0, 0, 0, logBox.CanvasSize.Y.Offset + 14)
        end
    end
    Notify("FireServer em " .. count .. " remotes")
end)

addButton(tRemotes, "InvokeServer (todos RemoteFunctions)", function()
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteFunction") then
            pcall(function() obj:InvokeServer("Test", 123, true) end)
            count = count + 1
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = "  [INVOKE] " .. obj.Name
            lbl.TextColor3 = Color3.fromRGB(255, 180, 50)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Code
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = logBox
            logBox.CanvasSize = UDim2.new(0, 0, 0, logBox.CanvasSize.Y.Offset + 14)
        end
    end
    Notify("InvokeServer em " .. count .. " remote functions")
end)

addButton(tRemotes, "Stress Test (tabelas grandes + nil)", function()
    local bigTable = {}
    for i = 1, 500 do bigTable[i] = string.rep("X", 500) end
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function() obj:FireServer(nil, bigTable, {}, nil, math.huge, -math.huge, true, false, 0) end)
            count = count + 1
        end
    end
    Notify("Stress test em " .. count .. " remotes")
end)

addButton(tRemotes, "FireServer com argumentos invÃ¡lidos", function()
    local badArgs = {"", -999999, 0/0, true, false, nil, {}, newproxy(true), Vector3.new(math.huge, math.huge, math.huge)}
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            for _, arg in ipairs(badArgs) do
                pcall(function() obj:FireServer(arg) end)
            end
            count = count + 1
        end
    end
    Notify("Argumentos invÃ¡lidos em " .. count .. " remotes")
end)

-- ============================================================
-- TAB: DUMP
-- ============================================================
addSection(tDump, "AnÃ¡lise do Jogo")

local dumpBox = addLogBox(tDump, "Resultado", 140)

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
    addLabel(dumpBox, "Total: " .. count .. " remotes")
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
    Notify(count .. " ModuleScripts")
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
    Notify(count .. " LocalScripts")
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
end)

addButton(tDump, "Dados dos Players", function()
    for _, c in pairs(dumpBox:GetChildren()) do c:Destroy() end
    dumpBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    for _, plr in pairs(Players:GetPlayers()) do
        local info = plr.Name .. " | UserId:" .. plr.UserId .. " | Age:" .. plr.AccountAge .. "d"
        if plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h then info = info .. " | HP:" .. math.floor(h.Health) .. "/" .. math.floor(h.MaxHealth) .. " | Spd:" .. h.WalkSpeed end
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

addButton(tDump, "Copy Server ID", function()
    setclipboard(game.JobId)
    Notify("Copiado!")
end)

-- ============================================================
-- ESP UPDATE LOOP
-- ============================================================
EspUpdateConn = RunService.RenderStepped:Connect(function()
    if EspOn then
        UpdateESP()
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if EspOn then CreateESPForPlayer(plr) end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    RemoveESPForPlayer(plr)
end)

-- ============================================================
-- KEYBIND
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Delete then main.Visible = not main.Visible end
end)

switchTab("ESP")
main.Visible = true
Notify("Security Test Hub v10.0 | Drawing ESP carregado!")
