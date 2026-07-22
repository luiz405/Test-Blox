local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local noclipConn, flyConn, flyBody, flyGyro
local NoclipOn = false
local FlyOn = false
local AntiAFKOn = false
local EspBoxOn = false
local EspNameOn = false
local EspHPOn = false
local EspTracerOn = false
local RemoteSpyOn = false
local GodModeOn = false
local EspOn = false
local ESPObjects = {}
local RemoteLog = {}
local HookedRemotes = {}

local espConfig = {
    boxColor = Color3.new(1, 0, 0),
    tracerColor = Color3.new(1, 0, 0),
    nameColor = Color3.new(1, 1, 1),
    hpColor = Color3.new(0, 1, 0),
    boxThickness = 1.5,
    tracerThickness = 1.5,
    textSize = 14,
    range = 500,
}

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
    boxOutline.Thickness = 3; boxOutline.Color = Color3.new(0, 0, 0); boxOutline.Filled = false; boxOutline.Visible = false; boxOutline.ZIndex = 1
    local box = Drawing.new("Quad")
    box.Thickness = espConfig.boxThickness; box.Color = espConfig.boxColor; box.Filled = false; box.Visible = false; box.ZIndex = 2
    local tracer = Drawing.new("Line")
    tracer.Thickness = espConfig.tracerThickness; tracer.Color = espConfig.tracerColor; tracer.Visible = false; tracer.ZIndex = 2
    local nameT = Drawing.new("Text")
    nameT.Size = espConfig.textSize; nameT.Color = espConfig.nameColor; nameT.Center = true; nameT.Outline = true; nameT.OutlineColor = Color3.new(0, 0, 0); nameT.Visible = false; nameT.ZIndex = 2
    local hpBg = Drawing.new("Line")
    hpBg.Thickness = 4; hpBg.Color = Color3.new(0, 0, 0); hpBg.Visible = false; hpBg.ZIndex = 1
    local hp = Drawing.new("Line")
    hp.Thickness = 2; hp.Color = espConfig.hpColor; hp.Visible = false; hp.ZIndex = 2
    local dist = Drawing.new("Text")
    dist.Size = 11; dist.Color = Color3.fromRGB(180, 180, 180); dist.Center = true; dist.Outline = true; dist.OutlineColor = Color3.new(0, 0, 0); dist.Visible = false; dist.ZIndex = 2
    ESPObjects[plr] = { boxOutline = boxOutline, box = box, tracer = tracer, name = nameT, hpBg = hpBg, hp = hp, dist = dist }
end

local function RemoveESPForPlayer(plr)
    if ESPObjects[plr] then
        for _, drawing in pairs(ESPObjects[plr]) do pcall(function() drawing:Remove() end) end
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
    return {
        topLeft = Vector2.new(top2d.X - width / 2, top2d.Y),
        topRight = Vector2.new(top2d.X + width / 2, top2d.Y),
        botLeft = Vector2.new(bot2d.X - width / 2, bot2d.Y),
        botRight = Vector2.new(bot2d.X + width / 2, bot2d.Y),
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
                    shouldShow = (root.Position - myRoot.Position).Magnitude <= espConfig.range
                else shouldShow = true end
            end
            if shouldShow then
                local bb = GetBoundingBox(char)
                if bb then
                    local color = espConfig.boxColor
                    if EspBoxOn then
                        obj.boxOutline.Points = { bb.topLeft, bb.topRight, bb.botRight, bb.botLeft }
                        obj.boxOutline.Visible = true
                        obj.box.Points = { bb.topLeft, bb.topRight, bb.botRight, bb.botLeft }
                        obj.box.Color = color; obj.box.Visible = true
                    else obj.boxOutline.Visible = false; obj.box.Visible = false end
                    if EspTracerOn then
                        local screenSize = Camera.ViewportSize
                        obj.tracer.From = Vector2.new(screenSize.X / 2, screenSize.Y)
                        obj.tracer.To = bb.botCenter; obj.tracer.Color = color; obj.tracer.Visible = true
                    else obj.tracer.Visible = false end
                    if EspNameOn then
                        obj.name.Position = bb.topCenter - Vector2.new(0, 16)
                        obj.name.Text = plr.Name; obj.name.Color = espConfig.nameColor; obj.name.Visible = true
                    else obj.name.Visible = false end
                    if EspHPOn and hum then
                        local hpPct = hum.Health / hum.MaxHealth
                        local barY = bb.topLeft.Y
                        local hpY = bb.botLeft.Y - (bb.height * hpPct)
                        local barX = bb.topLeft.X - 5
                        obj.hpBg.From = Vector2.new(barX, bb.topLeft.Y); obj.hpBg.To = Vector2.new(barX, bb.botLeft.Y); obj.hpBg.Visible = true
                        obj.hp.From = Vector2.new(barX, bb.botLeft.Y); obj.hp.To = Vector2.new(barX, hpY)
                        obj.hp.Color = (hpPct > 0.5) and Color3.new(0, 1, 0) or (hpPct > 0.25) and Color3.new(1, 1, 0) or Color3.new(1, 0, 0)
                        obj.hp.Visible = true
                    else obj.hpBg.Visible = false; obj.hp.Visible = false end
                    if myRoot then
                        obj.dist.Position = bb.botCenter + Vector2.new(0, 4)
                        obj.dist.Text = math.floor((root.Position - myRoot.Position).Magnitude) .. "m"
                        obj.dist.Visible = true
                    else obj.dist.Visible = false end
                else
                    obj.boxOutline.Visible = false; obj.box.Visible = false; obj.tracer.Visible = false
                    obj.name.Visible = false; obj.hpBg.Visible = false; obj.hp.Visible = false; obj.dist.Visible = false
                end
            else
                obj.boxOutline.Visible = false; obj.box.Visible = false; obj.tracer.Visible = false
                obj.name.Visible = false; obj.hpBg.Visible = false; obj.hp.Visible = false; obj.dist.Visible = false
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
main.Size = UDim2.new(0, 380, 0, 480)
main.Position = UDim2.new(0.5, -190, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 50, 50)
stroke.Thickness = 1.5
stroke.Transparency = 0.4
stroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SECURITY TEST HUB"
title.TextColor3 = Color3.fromRGB(255, 60, 60)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 24, 0, 24)
hideBtn.Position = UDim2.new(1, -62, 0, 7)
hideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
hideBtn.Text = "_"
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.TextSize = 14
hideBtn.Font = Enum.Font.GothamBold
hideBtn.Parent = header
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 5)
hideBtn.MouseButton1Click:Connect(function() main.Visible = false end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -34, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
closeBtn.MouseButton1Click:Connect(function() main:Destroy(); gui:Destroy() end)

local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1, -12, 0, 30)
tabs.Position = UDim2.new(0, 6, 0, 42)
tabs.BackgroundTransparency = 1
tabs.Parent = main
local tabLayout = Instance.new("UIListLayout", tabs)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 3)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -12, 1, -90)
content.Position = UDim2.new(0, 6, 0, 78)
content.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
content.BorderSizePixel = 0
content.Parent = main
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 6)
content.ClipsDescendants = true

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 14)
footer.Position = UDim2.new(0, 0, 1, -17)
footer.BackgroundTransparency = 1
footer.Text = "F1 = Abrir/Fechar | Clique no header para arrastar"
footer.TextColor3 = Color3.fromRGB(70, 70, 100)
footer.TextSize = 10
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
    b.Size = UDim2.new(0, 62, 1, 0)
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
    f.ScrollBarThickness = 4
    f.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    f.BorderSizePixel = 0
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.ScrollingDirection = Enum.ScrollingDirection.Y
    f.Visible = false
    f.Parent = content
    f.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", f)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", f)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    tabBtns[name] = b
    tabFrames[name] = f
    b.MouseButton1Click:Connect(function() switchTab(name) end)
    return f
end

local function addSection(parent, text)
    local s = Instance.new("TextLabel")
    s.Size = UDim2.new(1, 0, 0, 20)
    s.BackgroundTransparency = 1
    s.Text = "  " .. text
    s.TextColor3 = Color3.fromRGB(255, 60, 60)
    s.TextSize = 11
    s.Font = Enum.Font.GothamBold
    s.TextXAlignment = Enum.TextXAlignment.Left
    s.Parent = parent
end

local function addToggle(parent, text, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 30)
    f.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    f.BorderSizePixel = 0
    f.Parent = parent
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
            tg.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
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

local function addButton(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(220, 40, 40) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(180, 30, 30) end)
    b.MouseButton1Click:Connect(callback)
end

local function addColorBtn(parent, text, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(callback)
end

local function addSlider(parent, text, min, max, def, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 38)
    f.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    f.BorderSizePixel = 0
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.6, 0, 0, 16)
    l.Position = UDim2.new(0, 8, 0, 2)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(200, 200, 220)
    l.TextSize = 11
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local vl = Instance.new("TextLabel")
    vl.Size = UDim2.new(0.4, -10, 0, 16)
    vl.Position = UDim2.new(0.6, 0, 0, 2)
    vl.BackgroundTransparency = 1
    vl.Text = tostring(def)
    vl.TextColor3 = Color3.fromRGB(255, 80, 80)
    vl.TextSize = 11
    vl.Font = Enum.Font.GothamBold
    vl.TextXAlignment = Enum.TextXAlignment.Right
    vl.Parent = f
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -16, 0, 5)
    bar.Position = UDim2.new(0, 8, 0, 24)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    bar.Parent = f
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((def - min) / (max - min), -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 6)
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
            knob.Position = UDim2.new(p, -6, 0.5, -6)
            vl.Text = tostring(v)
            callback(v)
        end
    end)
end

local function addLabel(parent, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "  " .. text
    l.TextColor3 = Color3.fromRGB(100, 100, 130)
    l.TextSize = 10
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
end

-- ============================================================
-- TABS
-- ============================================================
local tESP = addTab("ESP")
local tMove = addTab("Movimento")
local tExploit = addTab("Exploit")
local tRemotes = addTab("Remotes")
local tDump = addTab("Dump")
local tMisc = addTab("Misc")

-- ============================================================
-- TAB: ESP
-- ============================================================
addSection(tESP, "VISUAIS (Drawing 2D)")
addToggle(tESP, "Box (Caixa 3D)", function(v) EspBoxOn = v; EspOn = EspBoxOn or EspNameOn or EspHPOn or EspTracerOn; if not EspOn then ClearESP() end; Notify(v and "Box ON" or "Box OFF") end)
addToggle(tESP, "Tracer (Linha)", function(v) EspTracerOn = v; EspOn = EspBoxOn or EspNameOn or EspHPOn or EspTracerOn; if not EspOn then ClearESP() end; Notify(v and "Tracer ON" or "Tracer OFF") end)
addToggle(tESP, "Nome", function(v) EspNameOn = v; EspOn = EspBoxOn or EspNameOn or EspHPOn or EspTracerOn; if not EspOn then ClearESP() end; Notify(v and "Name ON" or "Name OFF") end)
addToggle(tESP, "Barra de HP", function(v) EspHPOn = v; EspOn = EspBoxOn or EspNameOn or EspHPOn or EspTracerOn; if not EspOn then ClearESP() end; Notify(v and "HP ON" or "HP OFF") end)

addSection(tESP, "CONFIGURACAO")
addSlider(tESP, "Alcance (studs)", 50, 2000, 500, function(v) espConfig.range = v end)
addSlider(tESP, "Tamanho texto", 8, 24, 14, function(v) espConfig.textSize = v end)

addSection(tESP, "COR DA BOX E TRACER")
addColorBtn(tESP, "Vermelho", Color3.new(1, 0, 0), function() espConfig.boxColor = Color3.new(1, 0, 0); espConfig.tracerColor = Color3.new(1, 0, 0); Notify("Cor = Vermelho") end)
addColorBtn(tESP, "Verde", Color3.new(0, 0.7, 0), function() espConfig.boxColor = Color3.new(0, 0.7, 0); espConfig.tracerColor = Color3.new(0, 0.7, 0); Notify("Cor = Verde") end)
addColorBtn(tESP, "Azul", Color3.new(0, 0.4, 1), function() espConfig.boxColor = Color3.new(0, 0.4, 1); espConfig.tracerColor = Color3.new(0, 0.4, 1); Notify("Cor = Azul") end)
addColorBtn(tESP, "Amarelo", Color3.new(1, 1, 0), function() espConfig.boxColor = Color3.new(1, 1, 0); espConfig.tracerColor = Color3.new(1, 1, 0); Notify("Cor = Amarelo") end)
addColorBtn(tESP, "Rosa", Color3.new(1, 0, 1), function() espConfig.boxColor = Color3.new(1, 0, 1); espConfig.tracerColor = Color3.new(1, 0, 1); Notify("Cor = Rosa") end)
addColorBtn(tESP, "Branco", Color3.new(1, 1, 1), function() espConfig.boxColor = Color3.new(1, 1, 1); espConfig.tracerColor = Color3.new(1, 1, 1); Notify("Cor = Branco") end)

-- ============================================================
-- TAB: MOVIMENTO
-- ============================================================
addSection(tMove, "NOCLIP E FLY")
addToggle(tMove, "Noclip", function(v)
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

addToggle(tMove, "Fly (WASD + Space/Shift)", function(v)
    FlyOn = v
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBody then flyBody:Destroy(); flyBody = nil end
    if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    if v then
        local hrp = GetHRP()
        if hrp then
            flyGyro = Instance.new("BodyGyro", hrp)
            flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            flyGyro.P = 9000; flyGyro.D = 500
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

addSection(tMove, "VELOCIDADE E PULO")
addSlider(tMove, "Walk Speed", 16, 500, 16, function(v) local h = GetHum(); if h then h.WalkSpeed = v end end)
addSlider(tMove, "Jump Power", 50, 500, 50, function(v) local h = GetHum(); if h then h.JumpPower = v end end)

-- ============================================================
-- TAB: EXPLOIT
-- ============================================================
addSection(tExploit, "PROTECAO")
addToggle(tExploit, "God Mode (Invencivel)", function(v)
    GodModeOn = v
    if v then
        spawn(function()
            while GodModeOn do
                task.wait(0.1)
                local h = GetHum()
                if h then h.Health = h.MaxHealth end
            end
        end)
        Notify("God Mode ON")
    else Notify("God Mode OFF") end
end)

addToggle(tExploit, "Anti-AFK", function(v)
    AntiAFKOn = v
    if v then
        spawn(function()
            while AntiAFKOn do
                task.wait(30)
                pcall(function()
                    local vu = game:GetService("VirtualUser")
                    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(0.1); vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
            end
        end)
        Notify("Anti-AFK ON")
    else Notify("Anti-AFK OFF") end
end)

addSection(tExploit, "ACAO")
addButton(tExploit, "Resetar Personagem", function() local h = GetHum(); if h then h.Health = 0 end end)
addButton(tExploit, "Forcar Respawn", function()
    local h = GetHum(); if h then h.Health = 0 end
    task.wait(0.5)
    local hrp = GetHRP()
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, -100, 0) end
end)

-- ============================================================
-- TAB: REMOTES
-- ============================================================
addSection(tRemotes, "REMOTE SPY")
addToggle(tRemotes, "Remote Spy (capturar chamadas)", function(v)
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
                            Notify("Remote: " .. obj.Name .. " | " .. tostring(#args) .. " args")
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
                            Notify("Remote: " .. obj.Name .. " | " .. tostring(#args) .. " args")
                        end
                    end)
                end
            end
        end)
    else Notify("Remote Spy OFF") end
end)

addSection(tRemotes, "ENVIO MANUAL")
addButton(tRemotes, "FireServer (todos)", function()
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function() obj:FireServer("test", 123, true, nil, math.huge) end)
            count = count + 1
        end
    end
    Notify("FireServer em " .. count .. " remotes")
end)

addButton(tRemotes, "InvokeServer (todos)", function()
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteFunction") then
            pcall(function() obj:InvokeServer("test", 123, true) end)
            count = count + 1
        end
    end
    Notify("InvokeServer em " .. count .. " functions")
end)

addSection(tRemotes, "STRESS TEST")
addButton(tRemotes, "Tabelas grandes + nil", function()
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

addButton(tRemotes, "Argumentos invalidos", function()
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
    Notify("Args invalidos em " .. count .. " remotes")
end)

-- ============================================================
-- TAB: DUMP
-- ============================================================
addSection(tDump, "INFORMACOES DO JOGO")
addButton(tDump, "Listar Remotes", function()
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            count = count + 1
        end
    end
    Notify(count .. " remotes encontrados em ReplicatedStorage")
end)

addButton(tDump, "Listar ModuleScripts", function()
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("ModuleScript") then count = count + 1 end
    end
    Notify(count .. " ModuleScripts em ReplicatedStorage")
end)

addButton(tDump, "Listar LocalScripts", function()
    local count = 0
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") then count = count + 1 end
    end
    Notify(count .. " LocalScripts encontrados")
end)

addButton(tDump, "Info dos Jogadores", function()
    for _, plr in pairs(Players:GetPlayers()) do
        local info = plr.Name .. " | UserId:" .. plr.UserId .. " | Age:" .. plr.AccountAge .. "d"
        if plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h then info = info .. " | HP:" .. math.floor(h.Health) .. "/" .. math.floor(h.MaxHealth) end
        end
        Notify(info)
    end
end)

-- ============================================================
-- TAB: MISC
-- ============================================================
addSection(tMisc, "SERVIDOR")
addButton(tMisc, "Server Hop", function()
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

addButton(tMisc, "Copiar Server ID", function() setclipboard(game.JobId); Notify("Copiado!") end)

addSection(tMisc, "CONTROLES")
addLabel(tMisc, "F1 = Abrir/Fechar menu")
addLabel(tMisc, "Clique no header para arrastar")
addLabel(tMisc, "_ = Minimizar  X = Fechar")

-- ============================================================
-- ESP LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    if EspOn then UpdateESP() end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if EspOn then CreateESPForPlayer(plr) end
    end)
end)
Players.PlayerRemoving:Connect(function(plr) RemoveESPForPlayer(plr) end)

-- ============================================================
-- KEYBIND
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        main.Visible = not main.Visible
    end
end)

switchTab("ESP")
main.Visible = true
Notify("Hub carregado! F1 = Abrir/Fechar | Scroll = Rolar menu")
