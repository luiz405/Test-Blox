--[[
  BROOKHAVEN RP SCRIPT v3.1
  F1 ou Insert = Abrir/Fechar menu
]]

-- ================================================================
-- SERVICES
-- ================================================================
local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LP = Players.LocalPlayer

-- ================================================================
-- NOTIFY
-- ================================================================
local function Notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = dur or 5,
        })
    end)
end

-- ================================================================
-- THEME
-- ================================================================
local BG   = Color3.fromRGB(18, 18, 26)
local BG2  = Color3.fromRGB(28, 28, 38)
local BG3  = Color3.fromRGB(38, 38, 50)
local BG4  = Color3.fromRGB(50, 50, 65)
local ACC  = Color3.fromRGB(0, 160, 255)
local ACCD = Color3.fromRGB(0, 120, 200)
local TXT  = Color3.fromRGB(225, 225, 240)
local DIM  = Color3.fromRGB(140, 140, 165)
local GRN  = Color3.fromRGB(0, 200, 80)
local RED  = Color3.fromRGB(230, 50, 50)
local YEL  = Color3.fromRGB(255, 180, 0)
local BRD  = Color3.fromRGB(42, 42, 55)
local HDR  = Color3.fromRGB(22, 22, 32)

-- ================================================================
-- UI BUILDER
-- ================================================================
local function MakeCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = parent
    return c
end

local function MakeStroke(parent)
    local s = Instance.new("UIStroke")
    s.Color = BRD
    s.Thickness = 1
    s.Parent = parent
    return s
end

local function CreateWindow(title, W, H)
    W = W or 520
    H = H or 400

    local parent = LP:FindFirstChild("PlayerGui")
    if not parent then
        pcall(function() parent = game:GetService("CoreGui") end)
    end
    if not parent then return end

    local gui = Instance.new("ScreenGui")
    gui.Name = "BHRP_v31"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 9999
    gui.Enabled = true
    gui.Parent = parent

    -- MAIN FRAME
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, W, 0, H)
    main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
    main.BackgroundColor3 = BG
    main.BorderSizePixel = 0
    main.Parent = gui
    MakeCorner(main, 8)
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = BRD
    mainStroke.Thickness = 2
    mainStroke.Parent = main

    -- HEADER
    local hdr = Instance.new("Frame")
    hdr.Name = "Header"
    hdr.Size = UDim2.new(1, 0, 0, 38)
    hdr.BackgroundColor3 = HDR
    hdr.BorderSizePixel = 0
    hdr.Parent = main
    MakeCorner(hdr, 8)

    local hdrFill = Instance.new("Frame")
    hdrFill.Size = UDim2.new(1, 0, 0, 10)
    hdrFill.Position = UDim2.new(0, 0, 1, -10)
    hdrFill.BackgroundColor3 = HDR
    hdrFill.BorderSizePixel = 0
    hdrFill.Parent = hdr

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -80, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = ACC
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 16
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = hdr

    -- HEADER BUTTONS
    local function HBtn(x, txt, col, fn)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 26, 0, 26)
        b.Position = UDim2.new(1, x, 0.5, -13)
        b.BackgroundColor3 = BG2
        b.BorderSizePixel = 0
        b.Text = txt
        b.TextColor3 = col
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        b.Parent = hdr
        MakeCorner(b, 5)
        b.MouseButton1Click:Connect(fn)
        b.MouseEnter:Connect(function() b.BackgroundColor3 = ACCD end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = BG2 end)
    end

    local minimized = false
    HBtn(-60, "â€”", TXT, function()
        minimized = not minimized
        tabBar.Visible = not minimized
        content.Visible = not minimized
        main.Size = UDim2.new(0, W, 0, minimized and 38 or H)
    end)
    HBtn(-32, "X", RED, function() gui:Destroy() end)

    -- TAB BAR
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.Position = UDim2.new(0, 0, 0, 38)
    tabBar.BackgroundColor3 = BG2
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main

    -- CONTENT AREA
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -68)
    content.Position = UDim2.new(0, 0, 0, 68)
    content.BackgroundColor3 = BG
    content.BorderSizePixel = 0
    content.ClipsDescendants = true
    content.Parent = main

    -- TAB SYSTEM
    local tabPages = {}
    local activeTab = nil

    local function SwitchTab(name)
        if activeTab then
            activeTab.Page.Visible = false
            activeTab.Btn.BackgroundColor3 = BG3
            activeTab.Btn.TextColor3 = DIM
        end
        local tab = tabPages[name]
        if tab then
            tab.Page.Visible = true
            tab.Btn.BackgroundColor3 = ACC
            tab.Btn.TextColor3 = TXT
            activeTab = tab
        end
    end

    local function MakeTab(name)
        -- Tab button
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 1, 0)
        btn.BackgroundColor3 = BG3
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = DIM
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = tabBar
        MakeCorner(btn, 4)

        -- Content page (ScrollingFrame)
        local page = Instance.new("ScrollingFrame")
        page.Name = name
        page.Size = UDim2.new(1, -6, 1, -6)
        page.Position = UDim2.new(0, 3, 0, 3)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = ACC
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = content

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 4)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Parent = page

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
        end)

        local pad = Instance.new("Frame")
        pad.Size = UDim2.new(1, 0, 0, 2)
        pad.BackgroundTransparency = 1
        pad.Parent = page

        -- Store tab
        tabPages[name] = {Btn = btn, Page = page, Layout = layout}
        btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
        btn.MouseEnter:Connect(function()
            if activeTab ~= tabPages[name] then btn.BackgroundColor3 = BG4 end
        end)
        btn.MouseLeave:Connect(function()
            if activeTab ~= tabPages[name] then btn.BackgroundColor3 = BG3 end
        end)

        -- ELEMENT HELPERS
        local tab = {}

        function tab:Title(txt)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -10, 0, 24)
            l.BackgroundTransparency = 1
            l.Text = "  " .. txt
            l.TextColor3 = ACC
            l.Font = Enum.Font.GothamBold
            l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = page
        end

        function tab:Label(txt)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -10, 0, 20)
            l.BackgroundTransparency = 1
            l.Text = "  " .. txt
            l.TextColor3 = DIM
            l.Font = Enum.Font.Gotham
            l.TextSize = 12
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = page
            local obj = {}
            function obj:Set(t) l.Text = "  " .. t end
            function obj:SetColor(c) l.TextColor3 = c end
            return obj
        end

        function tab:Sep()
            local s = Instance.new("Frame")
            s.Size = UDim2.new(1, -10, 0, 1)
            s.BackgroundColor3 = BRD
            s.BorderSizePixel = 0
            s.Parent = page
        end

        function tab:Btn(txt, fn)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -10, 0, 32)
            f.BackgroundColor3 = BG3
            f.BorderSizePixel = 0
            f.Parent = page
            MakeCorner(f, 5)
            MakeStroke(f)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = txt
            l.TextColor3 = TXT
            l.Font = Enum.Font.GothamBold
            l.TextSize = 12
            l.Parent = f

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 1, 0)
            b.BackgroundTransparency = 1
            b.Text = ""
            b.Parent = f
            b.MouseButton1Click:Connect(fn)
            b.MouseEnter:Connect(function() f.BackgroundColor3 = ACCD end)
            b.MouseLeave:Connect(function() f.BackgroundColor3 = BG3 end)
        end

        function tab:Toggle(txt, get, tog)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -10, 0, 34)
            f.BackgroundColor3 = BG3
            f.BorderSizePixel = 0
            f.Parent = page
            MakeCorner(f, 5)
            MakeStroke(f)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -56, 1, 0)
            l.Position = UDim2.new(0, 10, 0, 0)
            l.BackgroundTransparency = 1
            l.Text = txt
            l.TextColor3 = TXT
            l.Font = Enum.Font.Gotham
            l.TextSize = 12
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = f

            local sw = Instance.new("Frame")
            sw.Size = UDim2.new(0, 40, 0, 20)
            sw.Position = UDim2.new(1, -48, 0.5, -10)
            sw.BackgroundColor3 = RED
            sw.BorderSizePixel = 0
            sw.Parent = f
            MakeCorner(sw, 10)

            local ball = Instance.new("Frame")
            ball.Size = UDim2.new(0, 16, 0, 16)
            ball.Position = UDim2.new(0, 2, 0.5, -8)
            ball.BackgroundColor3 = Color3.new(1, 1, 1)
            ball.BorderSizePixel = 0
            ball.Parent = sw
            MakeCorner(ball, 8)

            local function Upd()
                local v = get()
                sw.BackgroundColor3 = v and GRN or RED
                ball.Position = UDim2.new(0, v and 22 or 2, 0.5, -8)
            end

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 1, 0)
            b.BackgroundTransparency = 1
            b.Text = ""
            b.Parent = f
            b.MouseButton1Click:Connect(function() tog(); Upd() end)
            b.MouseEnter:Connect(function() f.BackgroundColor3 = BG4 end)
            b.MouseLeave:Connect(function() f.BackgroundColor3 = BG3 end)

            Upd()
            return {Update = Upd}
        end

        function tab:Input(placeholder, fn)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -10, 0, 32)
            f.BackgroundColor3 = BG3
            f.BorderSizePixel = 0
            f.Parent = page
            MakeCorner(f, 5)
            MakeStroke(f)

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -10, 1, 0)
            box.Position = UDim2.new(0, 5, 0, 0)
            box.BackgroundTransparency = 1
            box.TextColor3 = TXT
            box.PlaceholderColor3 = DIM
            box.PlaceholderText = placeholder
            box.Font = Enum.Font.Gotham
            box.TextSize = 12
            box.ClearTextOnFocus = false
            box.Parent = f
            box.FocusLost:Connect(function(enter)
                if enter and fn then fn(box.Text) end
            end)
        end

        function tab:Slider(txt, minv, maxv, def, fn)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -10, 0, 44)
            f.BackgroundColor3 = BG3
            f.BorderSizePixel = 0
            f.Parent = page
            MakeCorner(f, 5)
            MakeStroke(f)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 0, 18)
            lbl.Position = UDim2.new(0, 5, 0, 3)
            lbl.BackgroundTransparency = 1
            lbl.Text = txt .. ": " .. tostring(def)
            lbl.TextColor3 = TXT
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -10, 0, 4)
            track.Position = UDim2.new(0, 5, 0, 28)
            track.BackgroundColor3 = BG
            track.BorderSizePixel = 0
            track.Parent = f
            MakeCorner(track, 2)

            local ratio = (def - minv) / (maxv - minv)
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(ratio, 0, 1, 0)
            fill.BackgroundColor3 = ACC
            fill.BorderSizePixel = 0
            fill.Parent = track
            MakeCorner(fill, 2)

            local grip = Instance.new("TextButton")
            grip.Size = UDim2.new(0, 14, 0, 14)
            grip.Position = UDim2.new(ratio, -7, 0.5, -7)
            grip.BackgroundColor3 = Color3.fromRGB(0, 190, 255)
            grip.BorderSizePixel = 0
            grip.Text = ""
            grip.Parent = track
            MakeCorner(grip, 7)

            local function SetVal(posX)
                local tw = track.AbsoluteSize.X
                if tw <= 0 then return end
                local p = math.clamp((posX - track.AbsolutePosition.X) / tw, 0, 1)
                local v = math.floor(minv + (maxv - minv) * p)
                fill.Size = UDim2.new(p, 0, 1, 0)
                grip.Position = UDim2.new(p, -7, 0.5, -7)
                lbl.Text = txt .. ": " .. tostring(v)
                if fn then fn(v) end
            end

            local obj = {}
            local dragging = false

            grip.MouseButton1Down:Connect(function() dragging = true end)
            grip.MouseButton1Up:Connect(function() dragging = false end)

            gui.InputBegan:Connect(function(inp)
                if dragging and inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    SetVal(inp.Position.X)
                end
            end)
            gui.InputChanged:Connect(function(inp)
                if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    SetVal(inp.Position.X)
                end
            end)
            gui.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            function obj:Set(v)
                local r = math.clamp((v - minv) / (maxv - minv), 0, 1)
                fill.Size = UDim2.new(r, 0, 1, 0)
                grip.Position = UDim2.new(r, -7, 0.5, -7)
                lbl.Text = txt .. ": " .. tostring(math.floor(v))
            end

            return obj
        end

        return tab
    end

    -- DRAG
    do
        local dragging = false
        local dragStart = Vector2.new()
        local startPos = UDim2.new()
        hdr.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = Vector2.new(inp.Position.X, inp.Position.Y)
                startPos = main.Position
            end
        end)
        hdr.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        gui.InputChanged:Connect(function(inp)
            if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local d = Vector2.new(inp.Position.X, inp.Position.Y) - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    -- FIRST TAB VISIBLE
    local first = true
    local function FinishSetup()
        for name, tab in pairs(tabPages) do
            if first then
                SwitchTab(name)
                first = false
            end
        end
    end

    return {Gui = gui, MakeTab = MakeTab, Finish = FinishSetup}
end

-- ================================================================
-- GAME STATE
-- ================================================================
local BH = {
    ESP = false,
    Invisivel = false,
    Noclip = false,
    AntiAFK = false,
    Fly = false,
    Speed = 16,
    JumpPower = 50,
    Seguir = false,
    SeguirPlayer = nil,
    Godmode = false,
    Grudado = false,
    GrudadoPlayer = nil,
    Limbo = CFrame.new(0, -500, 0),
    PosOriginal = nil,
    Loops = {},
    ESPObjs = {},
}

-- ================================================================
-- ESP
-- ================================================================
function BH:CriarESP(p)
    if p == LP or BH.ESPObjs[p] then return end
    local f = Instance.new("Folder")
    f.Name = "ESP_" .. p.Name
    local hl = Instance.new("Highlight", f)
    hl.FillColor = Color3.fromRGB(255, 50, 50)
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.35
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    local bg = Instance.new("BillboardGui", f)
    bg.Size = UDim2.new(0, 200, 0, 40)
    bg.StudsOffset = Vector3.new(0, 3, 0)
    bg.AlwaysOnTop = true
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1, 0, 0.5, 0)
    nl.BackgroundTransparency = 1
    nl.Text = p.Name
    nl.TextColor3 = Color3.fromRGB(255, 80, 80)
    nl.TextStrokeTransparency = 0.2
    nl.TextStrokeColor3 = Color3.new(0, 0, 0)
    nl.Font = Enum.Font.GothamBold
    nl.TextSize = 14
    nl.Parent = bg
    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, 0, 0.5, 0)
    dl.Position = UDim2.new(0, 0, 0.5, 0)
    dl.BackgroundTransparency = 1
    dl.Text = ""
    dl.TextColor3 = Color3.fromRGB(200, 200, 200)
    dl.TextStrokeTransparency = 0.3
    dl.TextStrokeColor3 = Color3.new(0, 0, 0)
    dl.Font = Enum.Font.Gotham
    dl.TextSize = 11
    dl.Parent = bg
    BH.ESPObjs[p] = {Folder = f, HL = hl, NL = nl, DL = dl, BG = bg}
    f.Parent = LP:FindFirstChild("PlayerGui")
end

function BH:RemoverESP(p)
    if BH.ESPObjs[p] then pcall(function() BH.ESPObjs[p].Folder:Destroy() end); BH.ESPObjs[p] = nil end
end

function BH:ToggleESP()
    BH.ESP = not BH.ESP
    if BH.ESP then
        for _, p in Players:GetPlayers() do
            if p ~= LP then BH:CriarESP(p) end
        end
    else
        for p in pairs(BH.ESPObjs) do BH:RemoverESP(p) end
    end
    return BH.ESP
end

function BH:AtualizarESP()
    for p, obj in pairs(BH.ESPObjs) do
        local c = p.Character
        local mc = LP.Character
        if c and mc then
            local h = c:FindFirstChild("HumanoidRootPart")
            local mh = mc:FindFirstChild("HumanoidRootPart")
            local hu = c:FindFirstChildOfClass("Humanoid")
            if h and mh and hu and hu.Health > 0 then
                obj.HL.Adornee = c
                obj.BG.Adornee = h
                local dist = (h.Position - mh).Magnitude
                local hp = math.floor((hu.Health / hu.MaxHealth) * 100)
                obj.DL.Text = string.format("[%dm] HP: %d%%", math.floor(dist), hp)
                local r = hu.Health / hu.MaxHealth
                local cor = Color3.fromRGB(255 * (1 - r), 255 * r, 0)
                obj.HL.FillColor = cor
                obj.NL.TextColor3 = cor
            else
                obj.HL.Adornee = nil
                obj.BG.Adornee = nil
            end
        else
            obj.HL.Adornee = nil
            obj.BG.Adornee = nil
        end
    end
end

-- ================================================================
-- TOGGLES
-- ================================================================
function BH:ToggleInvisivel()
    BH.Invisivel = not BH.Invisivel
    local c = LP.Character
    if c then
        for _, v in c:GetDescendants() do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = BH.Invisivel and 1 or 0
            end
        end
        local tool = c:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in tool:GetDescendants() do
                if v:IsA("BasePart") then v.Transparency = 0 end
            end
        end
    end
    return BH.Invisivel
end

function BH:ToggleNoclip()
    BH.Noclip = not BH.Noclip
    if BH.Noclip then
        BH.Loops.Noclip = Run.Stepped:Connect(function()
            local c = LP.Character
            if c then
                for _, v in c:GetDescendants() do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    else
        if BH.Loops.Noclip then BH.Loops.Noclip:Disconnect(); BH.Loops.Noclip = nil end
    end
    return BH.Noclip
end

function BH:ToggleAntiAFK()
    BH.AntiAFK = not BH.AntiAFK
    if BH.AntiAFK then
        BH.Loops.AntiAFK = LP.Idled:Connect(function()
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end)
    else
        if BH.Loops.AntiAFK then BH.Loops.AntiAFK:Disconnect(); BH.Loops.AntiAFK = nil end
    end
    return BH.AntiAFK
end

function BH:ToggleFly()
    BH.Fly = not BH.Fly
    local c = LP.Character
    if not c then return BH.Fly end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return BH.Fly end
    if BH.Fly then
        hum.PlatformStand = true
        local bp = Instance.new("BodyPosition")
        bp.Name = "FlyBP"
        bp.MaxForce = Vector3.new(1, 1, 1) * 9e9
        bp.P = 2000
        bp.D = 100
        bp.Parent = hrp
        BH.Loops.Fly = Run.RenderStepped:Connect(function()
            if not BH.Fly or not hrp or not hrp.Parent then
                if BH.Loops.Fly then BH.Loops.Fly:Disconnect(); BH.Loops.Fly = nil end
                return
            end
            local dir = Vector3.new()
            if Input:IsKeyDown(Enum.KeyCode.W) then dir = dir + Vector3.new(0, 0, -1) end
            if Input:IsKeyDown(Enum.KeyCode.S) then dir = dir + Vector3.new(0, 0, 1) end
            if Input:IsKeyDown(Enum.KeyCode.A) then dir = dir + Vector3.new(-1, 0, 0) end
            if Input:IsKeyDown(Enum.KeyCode.D) then dir = dir + Vector3.new(1, 0, 0) end
            if Input:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if Input:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir + Vector3.new(0, -1, 0) end
            local cam = workspace.CurrentCamera
            if cam then dir = cam.CFrame:VectorToObjectSpace(dir) end
            bp.Position = hrp.Position + dir * (BH.Speed * 0.12)
        end)
    else
        hum.PlatformStand = false
        local bp = hrp:FindFirstChild("FlyBP")
        if bp then bp:Destroy() end
        if BH.Loops.Fly then BH.Loops.Fly:Disconnect(); BH.Loops.Fly = nil end
    end
    return BH.Fly
end

function BH:SetSpeed(v)
    BH.Speed = v
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end

function BH:SetJump(v)
    BH.JumpPower = v
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = v end
end

function BH:SelectPlayer(nome)
    for _, p in Players:GetPlayers() do
        if p.Name:lower():find(nome:lower()) or (p.DisplayName and p.DisplayName:lower():find(nome:lower())) then
            BH.SeguirPlayer = p
            return p
        end
    end
    return nil
end

function BH:ToggleSeguir()
    if not BH.SeguirPlayer then BH.Seguir = false; return false end
    BH.Seguir = not BH.Seguir
    return BH.Seguir
end

function BH:ToggleGodmode()
    BH.Godmode = not BH.Godmode
    if BH.Godmode then
        BH.Loops.Godmode = Run.RenderStepped:Connect(function()
            local c = LP.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then h.MaxHealth = math.huge; h.Health = math.huge end
            end
        end)
    else
        if BH.Loops.Godmode then BH.Loops.Godmode:Disconnect(); BH.Loops.Godmode = nil end
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.MaxHealth = 100; hum.Health = 100 end
    end
    return BH.Godmode
end

function BH:RepelirVeiculos()
    local c = LP.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return 0 end
    local pos = c:FindFirstChild("HumanoidRootPart").Position
    local count = 0
    for _, v in workspace:GetDescendants() do
        if v:IsA("VehicleSeat") then
            local veic = v.Parent
            if veic then
                local hrp = veic:FindFirstChild("HumanoidRootPart") or v
                if (hrp.Position - pos).Magnitude <= 30 then
                    local dir = (hrp.Position - pos).Unit
                    hrp.CFrame = hrp.CFrame + dir * Vector3.new(50, 10, 50)
                    hrp.Velocity = dir * 100 + Vector3.new(0, 30, 0)
                    count = count + 1
                end
            end
        end
    end
    Notify("Repelir", count .. " veiculo(s) repelidos!")
    return count
end

function BH:ToggleGrudar()
    if not BH.SeguirPlayer then Notify("Erro", "Selecione um alvo primeiro!"); return false end
    BH.Grudado = not BH.Grudado
    if BH.Grudado then
        BH.GrudadoPlayer = BH.SeguirPlayer
        local mc = LP.Character
        local ac = BH.GrudadoPlayer.Character
        if not mc or not ac then BH.Grudado = false; return false end
        local mhrp = mc:FindFirstChild("HumanoidRootPart")
        local ahrp = ac:FindFirstChild("HumanoidRootPart")
        if not mhrp or not ahrp then BH.Grudado = false; return false end
        local a1 = Instance.new("Attachment"); a1.Name = "GAtt"; a1.Parent = mhrp
        local a2 = Instance.new("Attachment"); a2.Name = "GAtt"; a2.Parent = ahrp
        local al = Instance.new("AlignPosition")
        al.Attachment0 = a1; al.Attachment1 = a2
        al.RigidityEnabled = true; al.MaxForce = 9e9; al.Responsiveness = 200
        al.Parent = mhrp
        BH.Loops.Grude = Run.RenderStepped:Connect(function()
            if not BH.Grudado or not BH.GrudadoPlayer or not BH.GrudadoPlayer.Parent then BH:SolteGrude() end
        end)
        Notify("Grudado", "Grudado em " .. BH.GrudadoPlayer.Name)
        return true
    else
        BH:SolteGrude()
        return false
    end
end

function BH:SolteGrude()
    BH.Grudado = false; BH.GrudadoPlayer = nil
    if BH.Loops.Grude then BH.Loops.Grude:Disconnect(); BH.Loops.Grude = nil end
    pcall(function()
        local c = LP.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            local h = c:FindFirstChild("HumanoidRootPart")
            local a = h:FindFirstChild("GAtt"); if a then a:Destroy() end
            local al = h:FindFirstChildOfClass("AlignPosition"); if al then al:Destroy() end
        end
    end)
    for _, p in Players:GetPlayers() do
        pcall(function()
            local c = p.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                local a = c:FindFirstChild("HumanoidRootPart"):FindFirstChild("GAtt")
                if a then a:Destroy() end
            end
        end)
    end
    Notify("Solto", "Soltou do alvo!")
end

function BH:PuxarVeiculo()
    local c = LP.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local pos = c:FindFirstChild("HumanoidRootPart").Position
    local closest, minD = nil, math.huge
    for _, v in workspace:GetDescendants() do
        if v:IsA("VehicleSeat") then
            local veic = v.Parent
            if veic then
                local hrp = veic:FindFirstChild("HumanoidRootPart") or v
                local d = (hrp.Position - pos).Magnitude
                if d < minD then minD = d; closest = veic end
            end
        end
    end
    if closest then
        local hrp = closest:FindFirstChild("HumanoidRootPart") or closest:FindFirstChildWhichIsA("BasePart")
        if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2, -5)); hrp.Velocity = Vector3.new(); Notify("Veiculo", "Puxado!") end
    else
        Notify("Veiculo", "Nenhum encontrado!")
    end
end

function BH:OnibusSequestro()
    if not BH.SeguirPlayer then Notify("Onibus", "Selecione um alvo!"); return end
    local alvo = BH.SeguirPlayer
    local c = LP.Character
    if not c then return end
    local myHRP = c:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    BH.PosOriginal = myHRP.CFrame
    Notify("Onibus", "Procurando onibus...")
    local bus = nil
    for _, v in workspace:GetDescendants() do
        if v:IsA("Model") then
            local n = v.Name:lower()
            if (n:find("bus") or n:find("escolar")) and v:FindFirstChildWhichIsA("VehicleSeat") then
                bus = v; break
            end
        end
    end
    if not bus then Notify("Onibus", "Nenhum onibus encontrado!"); return end
    local busP = bus:FindFirstChild("HumanoidRootPart") or bus:FindFirstChildWhichIsA("BasePart")
    if not busP then Notify("Onibus", "Onibus sem parte!"); return end
    Notify("Onibus", "Perseguindo alvo...")
    myHRP.CFrame = busP.CFrame + Vector3.new(0, 3, 0)
    local steps = 0
    local con
    con = Run.RenderStepped:Connect(function()
        steps = steps + 1
        if steps > 300 then con:Disconnect(); Notify("Onibus", "Timeout!"); return end
        local ac = alvo.Character
        if not ac then con:Disconnect(); return end
        local ah = ac:FindFirstChild("HumanoidRootPart")
        if not ah then con:Disconnect(); return end
        local d = (ah.Position - busP.Position).Magnitude
        busP.CFrame = CFrame.lookAt(busP.Position, ah.Position) * CFrame.new(0, 0, math.min(1.5, d))
        busP.CFrame = busP.CFrame + (ah.Position - busP.Position).Unit * math.min(2, d)
        if d < 8 then
            con:Disconnect()
            task.wait(0.5)
            local ac2 = alvo.Character
            if ac2 and ac2:FindFirstChild("HumanoidRootPart") then
                ac2:FindFirstChild("HumanoidRootPart").CFrame = BH.Limbo
                task.wait(1)
                if BH.PosOriginal then
                    task.wait(0.3)
                    local mc = LP.Character
                    if mc and mc:FindFirstChild("HumanoidRootPart") then
                        mc:FindFirstChild("HumanoidRootPart").CFrame = BH.PosOriginal
                    end
                end
                Notify("Onibus", "Sequestro completo!")
            end
        end
    end)
end

function BH:TeleportarCFrame(cf)
    local c = LP.Character
    if c and c:FindFirstChild("HumanoidRootPart") then c:FindFirstChild("HumanoidRootPart").CFrame = cf end
end

function BH:TeleportarJogador(nome)
    for _, p in Players:GetPlayers() do
        if p.Name:lower():find(nome:lower()) or (p.DisplayName and p.DisplayName:lower():find(nome:lower())) then
            local c = p.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                BH:TeleportarCFrame(c:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(2, 0, 2))
                return true
            end
        end
    end
    return false
end

function BH:Reset()
    BH.ESP = false; BH.Invisivel = false; BH.Noclip = false; BH.AntiAFK = false
    BH.Fly = false; BH.Seguir = false; BH.SeguirPlayer = nil; BH.Godmode = false
    BH.Grudado = false; BH.GrudadoPlayer = nil; BH.Speed = 16; BH.JumpPower = 50
    BH:SolteGrude()
    for _, v in pairs(BH.Loops) do pcall(function() v:Disconnect() end) end
    BH.Loops = {}
    for p in pairs(BH.ESPObjs) do BH:RemoverESP(p) end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:BreakJoints() end
end

function BH:SalvarConfig()
    pcall(function()
        local dados = {ESP = BH.ESP, Invisivel = BH.Invisivel, Noclip = BH.Noclip, Speed = BH.Speed, JumpPower = BH.JumpPower}
        writefile("BH_Config.json", game:GetService("HttpService"):JSONEncode(dados))
    end)
end

function BH:CarregarConfig()
    local ok, dados = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile("BH_Config.json"))
    end)
    if ok and type(dados) == "table" then
        if dados.ESP ~= nil then BH.ESP = dados.ESP end
        if dados.Invisivel ~= nil then BH.Invisivel = dados.Invisivel end
        if dados.Noclip ~= nil then BH.Noclip = dados.Noclip end
        if dados.Speed then BH:SetSpeed(dados.Speed) end
        if dados.JumpPower then BH:SetJump(dados.JumpPower) end
        return true
    end
    return false
end

-- ================================================================
-- MAIN LOOP
-- ================================================================
Run.RenderStepped:Connect(function()
    if BH.ESP then BH:AtualizarESP() end
    if BH.Seguir and BH.SeguirPlayer then
        local c = LP.Character
        local t = BH.SeguirPlayer.Character
        if c and t then
            local m = c:FindFirstChild("HumanoidRootPart")
            local h = c:FindFirstChildOfClass("Humanoid")
            local tm = t:FindFirstChild("HumanoidRootPart")
            if m and h and tm then
                local d = (tm.Position - m.Position).Magnitude
                if d > 4 then
                    m.CFrame = m.CFrame + (tm.Position - m.Position).Unit * math.min(BH.Speed * 0.12, d)
                    h.WalkToPoint = tm.Position
                end
            end
        end
    end
end)

-- ================================================================
-- PLAYER EVENTS
-- ================================================================
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if BH.ESP then BH:CriarESP(p) end
    end)
end)
Players.PlayerRemoving:Connect(function(p)
    BH:RemoverESP(p)
    if BH.SeguirPlayer == p then BH.SeguirPlayer = nil; BH.Seguir = false end
end)
for _, p in Players:GetPlayers() do
    if p ~= LP then
        p.CharacterAdded:Connect(function()
            task.wait(1)
            if BH.ESP then BH:CriarESP(p) end
        end)
    end
end

-- ================================================================
-- BUILD UI
-- ================================================================
local W = CreateWindow("BROOKHAVEN RP v3.1", 520, 400)

-- TAB: PLAYER
local tP = W:MakeTab("Player")
tP:Title("Personagem")
local togESP = tP:Toggle("ESP", function() return BH.ESP end, function() BH:ToggleESP() end)
local togInv = tP:Toggle("Invisivel", function() return BH.Invisivel end, function() BH:ToggleInvisivel() end)
local togNoc = tP:Toggle("Noclip", function() return BH.Noclip end, function() BH:ToggleNoclip() end)
local togAFK = tP:Toggle("Anti AFK", function() return BH.AntiAFK end, function() BH:ToggleAntiAFK() end)
local togFly = tP:Toggle("Fly", function() return BH.Fly end, function() BH:ToggleFly() end)
tP:Sep()
tP:Title("Velocidade")
local lblSpd = tP:Label("WalkSpeed: " .. BH.Speed)
local lblJmp = tP:Label("JumpPower: " .. BH.JumpPower)
tP:Slider("WalkSpeed", 10, 200, BH.Speed, function(v) BH:SetSpeed(v); lblSpd:Set("WalkSpeed: " .. v) end)
tP:Slider("JumpPower", 10, 300, BH.JumpPower, function(v) BH:SetJump(v); lblJmp:Set("JumpPower: " .. v) end)

-- TAB: SEGUIR
local tS = W:MakeTab("Seguir")
tS:Title("Alvo")
local lblAlvo = tS:Label("Nenhum alvo selecionado")
tS:Input("Nome do jogador...", function(txt)
    local p = BH:SelectPlayer(txt)
    if p then lblAlvo:Set("Alvo: " .. p.Name); lblAlvo:SetColor(GRN)
    else lblAlvo:Set("Nao encontrado"); lblAlvo:SetColor(RED) end
end)
tS:Sep()
local lblSeg = tS:Label("Status: Parado")
tS:Btn("Seguir alvo", function()
    local s = BH:ToggleSeguir()
    lblSeg:Set(s and "Seguindo " .. (BH.SeguirPlayer and BH.SeguirPlayer.Name or "?") or "Parado")
    lblSeg:SetColor(s and GRN or DIM)
end)
tS:Btn("Parar de seguir", function()
    BH.Seguir = false; BH.SeguirPlayer = nil
    lblAlvo:Set("Nenhum alvo"); lblAlvo:SetColor(DIM)
    lblSeg:Set("Parado"); lblSeg:SetColor(DIM)
end)
tS:Sep()
tS:Title("Grudar")
local lblGru = tS:Label("Nao grudado")
tS:Btn("Grudar / Soltar", function()
    local s = BH:ToggleGrudar()
    lblGru:Set(s and "Grudado em " .. (BH.GrudadoPlayer and BH.GrudadoPlayer.Name or "?") or "Nao grudado")
    lblGru:SetColor(s and GRN or DIM)
end)
tS:Btn("Soltar", function() BH:SolteGrude(); lblGru:Set("Nao grudado"); lblGru:SetColor(DIM) end)

-- TAB: VEICULOS
local tV = W:MakeTab("Veiculos")
tV:Title("Acoes")
tV:Btn("Repelir veiculos (30m)", function() BH:RepelirVeiculos() end)
tV:Btn("Puxar veiculo mais perto", function() BH:PuxarVeiculo() end)
tV:Sep()
tV:Title("Sequestro")
local lblOni = tV:Label("Aguardando...")
tV:Btn("INICIAR SEQUESTRO", function()
    lblOni:Set("Executando..."); lblOni:SetColor(YEL)
    task.spawn(function()
        BH:OnibusSequestro()
        task.wait(0.5)
        lblOni:Set("Pronto"); lblOni:SetColor(GRN)
    end)
end)
tV:Sep()
tV:Title("Teleporte Veiculos")
local veicLoc = {
    {"Garagem", CFrame.new(190, 23.5, 210)},
    {"Concessionaria", CFrame.new(270, 23.5, 230)},
    {"Hospital", CFrame.new(255, 23.5, 285)},
    {"Oficina", CFrame.new(220, 23.5, 155)},
    {"Escola", CFrame.new(340, 23.5, 215)},
    {"Heliporto", CFrame.new(310, 30, 290)},
}
for _, loc in ipairs(veicLoc) do
    tV:Btn(loc[1], function() BH:TeleportarCFrame(loc[2]) end)
end

-- TAB: TELEPORTES
local tT = W:MakeTab("TP")
tT:Title("Locais")
local locais = {
    {"Policia", CFrame.new(183, 24, 220)},
    {"Hospital", CFrame.new(242, 24, 275)},
    {"Escola", CFrame.new(350, 24, 200)},
    {"Supermercado", CFrame.new(290, 24, 170)},
    {"Banco", CFrame.new(315, 24, 315)},
    {"Praia", CFrame.new(430, 20, 350)},
    {"Flamingo", CFrame.new(100, 28, 470)},
    {"Castelo", CFrame.new(80, 50, 80)},
    {"Estacao", CFrame.new(145, 24, 340)},
    {"Prefeitura", CFrame.new(530, 24, 305)},
    {"Igreja", CFrame.new(410, 24, 225)},
    {"Gasolina", CFrame.new(195, 24, 170)},
}
for _, loc in ipairs(locais) do
    tT:Btn(loc[1], function() BH:TeleportarCFrame(loc[2]) end)
end
tT:Sep()
tT:Title("Personalizado")
local lblTP = tT:Label("")
tT:Input("Nome do jogador...", function(txt)
    if BH:TeleportarJogador(txt) then lblTP:Set("TP para " .. txt); lblTP:SetColor(GRN)
    else lblTP:Set("Nao encontrado"); lblTP:SetColor(RED) end
end)
tT:Input("X, Y, Z (ex: 100, 24, 100)", function(txt)
    local x, y, z = txt:match("([%d%.%-]+)%s*[,%s]+([%d%.%-]+)%s*[,%s]+([%d%.%-]+)")
    x, y, z = tonumber(x), tonumber(y), tonumber(z)
    if x and y and z then
        BH:TeleportarCFrame(CFrame.new(x, y, z))
        lblTP:Set(string.format("TP para %.0f, %.0f, %.0f", x, y, z)); lblTP:SetColor(GRN)
    else
        lblTP:Set("Formato invalido"); lblTP:SetColor(RED)
    end
end)

-- TAB: MISC
local tM = W:MakeTab("Misc")
tM:Title("Extras")
tM:Btn("Resetar Personagem", function() BH:Reset(); Notify("Reset", "Feito!") end)
local lblGod = tM:Label("Godmode: OFF")
tM:Btn("Godmode", function()
    local s = BH:ToggleGodmode()
    lblGod:Set(s and "Godmode: ON" or "Godmode: OFF"); lblGod:SetColor(s and GRN or DIM)
end)
tM:Sep()
tM:Btn("Renascer", function()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:BreakJoints() end
end)
tM:Btn("Fechar Menu", function() W.Gui:Destroy() end)
tM:Sep()
tM:Title("Config")
tM:Btn("Salvar", function() BH:SalvarConfig(); Notify("Config", "Salvo!") end)
tM:Btn("Carregar", function()
    if BH:CarregarConfig() then
        togESP.Update(); togInv.Update(); togNoc.Update(); togAFK.Update()
        lblSpd:Set("WalkSpeed: " .. BH.Speed); lblJmp:Set("JumpPower: " .. BH.JumpPower)
        Notify("Config", "Carregado!")
    else Notify("Config", "Nenhum save encontrado!") end
end)
tM:Sep()
tM:Label("F1 / Insert = Abrir/Fechar")

W:Finish()

-- ================================================================
-- TOGGLE KEY
-- ================================================================
Input.InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.F1 or inp.KeyCode == Enum.KeyCode.Insert then
        if W and W.Gui then W.Gui.Enabled = not W.Gui.Enabled end
    end
end)

Notify("Brookhaven RP", "Script v3.1 carregado! F1 para menu.", 8)
print("BROOKHAVEN RP v3.1 carregado! F1/Insert para menu")
