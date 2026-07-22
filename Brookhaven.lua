print([[
██████╗ ██████╗  ██████╗  ██████╗ ██╗  ██╗ █████╗ ██╗   ██╗███████╗███╗   ██╗
██╔══██╗██╔══██╗██╔═══██╗██╔═══██╗██║  ██║██╔══██╗██║   ██║██╔════╝████╗  ██║
██████╔╝██████╔╝██║   ██║██║   ██║███████║███████║██║   ██║█████╗  ██╔██╗ ██║
██╔══██╗██╔══██╗██║   ██║██║   ██║██╔══██║██╔══██║╚██╗ ██╔╝██╔══╝  ██║╚██╗██║
██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║  ██║██║  ██║ ╚████╔╝ ███████╗██║ ╚████║
╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝
                                                                               
   =====  BROOKHAVEN RP  |  v1.0  =====
]])

-- ================================================================
-- SERVICOS
-- ================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- ================================================================
-- CORES
-- ================================================================
local C = {
    bg      = Color3.fromRGB(20, 20, 30),
    fg      = Color3.fromRGB(30, 30, 44),
    fg2     = Color3.fromRGB(38, 38, 52),
    az      = Color3.fromRGB(0, 170, 255),
    az2     = Color3.fromRGB(0, 130, 210),
    az3     = Color3.fromRGB(0, 90, 170),
    tx      = Color3.fromRGB(225, 225, 240),
    tx2     = Color3.fromRGB(140, 140, 165),
    ok      = Color3.fromRGB(0, 200, 80),
    no      = Color3.fromRGB(230, 60, 60),
    am      = Color3.fromRGB(255, 180, 0),
    br      = Color3.fromRGB(200, 120, 255),
    borda   = Color3.fromRGB(45, 45, 60),
}

-- ================================================================
-- LIBRARY
-- ================================================================
local Lib = {}
Lib.Windows = {}
Lib.ActiveWindow = nil

function Lib:Window(nome)
    local pai = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
    if not pai then return nil end

    local gui = Instance.new("ScreenGui")
    gui.Name = "BH_" .. nome
    gui.ResetOnSpawn = false
    gui.Parent = pai
    gui.DisplayOrder = 999
    gui.IgnoreGuiInset = true

    local w = 520
    local h = 380

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, w, 0, h)
    main.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
    main.BackgroundColor3 = C.bg
    main.BorderSizePixel = 0
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    local strk = Instance.new("UIStroke", main)
    strk.Color = C.borda; strk.Thickness = 2

    -- HEADER
    local topo = Instance.new("Frame")
    topo.Size = UDim2.new(1, 0, 0, 38)
    topo.BackgroundColor3 = C.fg
    topo.BorderSizePixel = 0
    topo.Parent = main
    Instance.new("UICorner", topo).CornerRadius = UDim.new(0, 8)
    local tp = Instance.new("Frame")
    tp.Size = UDim2.new(1, 0, 0, 6)
    tp.Position = UDim2.new(0, 0, 1, -6)
    tp.BackgroundColor3 = C.fg; tp.BorderSizePixel = 0; tp.Parent = topo

    local tit = Instance.new("TextLabel")
    tit.Size = UDim2.new(1, -80, 1, 0)
    tit.Position = UDim2.new(0, 12, 0, 0)
    tit.BackgroundTransparency = 1
    tit.Text = nome
    tit.TextColor3 = C.az
    tit.Font = Enum.Font.GothamBold
    tit.TextSize = 16
    tit.TextXAlignment = Enum.TextXAlignment.Left
    tit.Parent = topo

    -- HEADER BOTOES
    local function HBtn(x, txt, fn)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 26, 0, 26)
        b.Position = UDim2.new(1, x, 0.5, -13)
        b.BackgroundColor3 = C.bg; b.BorderSizePixel = 0
        b.Text = txt; b.TextColor3 = C.tx
        b.Font = Enum.Font.GothamBold; b.TextSize = 16
        b.Parent = topo
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        b.MouseButton1Click:Connect(fn)
        b.MouseEnter:Connect(function() b.BackgroundColor3 = C.az2 end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = C.bg end)
        return b
    end

    local min = false
    HBtn(-62, "─", function()
        min = not min
        corpo.Visible = not min
        main:TweenSize(UDim2.new(0, w, 0, min and 38 or h), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end)
    HBtn(-32, "X", function() gui:Destroy() end)

    -- CORPO
    local corpo = Instance.new("Frame")
    corpo.Size = UDim2.new(1, 0, 1, -38)
    corpo.Position = UDim2.new(0, 0, 0, 38)
    corpo.BackgroundTransparency = 1
    corpo.Parent = main

    -- TABS
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.BackgroundColor3 = C.fg2
    tabBar.BorderSizePixel = 0
    tabBar.Parent = corpo

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 1, -30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = corpo

    local Tabs = {}
    local activeTab = nil

    local function SwitchTab(tab)
        if activeTab then activeTab.Container.Visible = false; activeTab.Btn.BackgroundColor3 = C.fg end
        activeTab = tab
        if tab then
            tab.Container.Visible = true
            tab.Btn.BackgroundColor3 = C.az3
        end
    end

    function Tabs:Tab(nome)
        local cont = Instance.new("ScrollingFrame")
        cont.Size = UDim2.new(1, 0, 1, 0)
        cont.BackgroundTransparency = 1
        cont.BorderSizePixel = 0
        cont.ScrollBarThickness = 3
        cont.ScrollBarImageColor3 = C.az
        cont.CanvasSize = UDim2.new(0, 0, 0, 0)
        cont.Parent = tabContainer
        cont.Visible = false

        local layout = Instance.new("UIListLayout", cont)
        layout.Padding = UDim.new(0, 6)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            cont.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
        end)

        local pad = Instance.new("Frame")
        pad.Size = UDim2.new(1, 0, 0, 4)
        pad.BackgroundTransparency = 1; pad.Parent = cont

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 1, 0)
        btn.Position = UDim2.new(0, #Tabs * 80 + 4 * #Tabs + 4, 0, 0)
        btn.BackgroundColor3 = C.fg; btn.BorderSizePixel = 0
        btn.Text = nome; btn.TextColor3 = C.tx
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 12
        btn.Parent = tabBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

        if #Tabs == 0 then
            SwitchTab({Container = cont, Btn = btn})
            cont.Visible = true
            btn.BackgroundColor3 = C.az3
        end

        btn.MouseButton1Click:Connect(function()
            SwitchTab({Container = cont, Btn = btn})
        end)
        btn.MouseEnter:Connect(function() if activeTab ~= btn then btn.BackgroundColor3 = C.az2 end end)
        btn.MouseLeave:Connect(function() if activeTab ~= btn then btn.BackgroundColor3 = C.fg end end)

        local tabObj = {Container = cont, Btn = btn, Name = nome}

        -- helpers
        function tabObj:Button(texto, fn)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -10, 0, 34)
            f.BackgroundColor3 = C.fg; f.BorderSizePixel = 0
            f.Parent = cont
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
            l.Text = texto; l.TextColor3 = C.tx; l.Font = Enum.Font.GothamBold; l.TextSize = 13; l.Parent = f

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundTransparency = 1; b.Text = ""; b.Parent = f
            b.MouseButton1Click:Connect(fn)
            b.MouseEnter:Connect(function() f.BackgroundColor3 = C.az2 end)
            b.MouseLeave:Connect(function() f.BackgroundColor3 = C.fg end)
            return f
        end

        function tabObj:Toggle(texto, get, set)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -10, 0, 34)
            f.BackgroundColor3 = C.fg; f.BorderSizePixel = 0
            f.Parent = cont
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -60, 1, 0); l.BackgroundTransparency = 1
            l.Text = texto; l.TextColor3 = C.tx; l.Font = Enum.Font.Gotham; l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f

            local tb = Instance.new("Frame")
            tb.Size = UDim2.new(0, 44, 0, 22)
            tb.Position = UDim2.new(1, -52, 0.5, -11)
            tb.BackgroundColor3 = C.no; tb.BorderSizePixel = 0; tb.Parent = f
            Instance.new("UICorner", tb).CornerRadius = UDim.new(1, 0)

            local tc = Instance.new("Frame")
            tc.Size = UDim2.new(0, 18, 0, 18)
            tc.Position = UDim2.new(0, 2, 0.5, -9)
            tc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            tc.BorderSizePixel = 0; tc.Parent = tb
            Instance.new("UICorner", tc).CornerRadius = UDim.new(1, 0)

            local function upd()
                local s = get()
                tb.BackgroundColor3 = s and C.ok or C.no
                tc:TweenPosition(s and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
            end

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundTransparency = 1; b.Text = ""; b.Parent = f
            b.MouseButton1Click:Connect(function() set(); upd() end)
            b.MouseEnter:Connect(function() f.BackgroundColor3 = C.fg2 end)
            b.MouseLeave:Connect(function() f.BackgroundColor3 = C.fg end)

            upd()
            return {Frame = f, Update = upd}
        end

        function tabObj:Label(texto)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -10, 0, 20)
            l.BackgroundTransparency = 1
            l.Text = texto; l.TextColor3 = C.tx2; l.Font = Enum.Font.Gotham; l.TextSize = 12
            l.Parent = cont
            local u = function(t) l.Text = t end
            return {Label = l, Set = u}
        end

        function tabObj:Textbox(placeholder, fn)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -10, 0, 34)
            f.BackgroundColor3 = C.fg; f.BorderSizePixel = 0
            f.Parent = cont
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -10, 1, 0); box.Position = UDim2.new(0, 5, 0, 0)
            box.BackgroundTransparency = 1
            box.TextColor3 = C.tx; box.PlaceholderColor3 = C.tx2
            box.PlaceholderText = placeholder
            box.Font = Enum.Font.Gotham; box.TextSize = 13
            box.ClearTextOnFocus = false; box.Parent = f

            box.FocusLost:Connect(function(enter)
                if enter then fn(box.Text) end
            end)
            return box
        end

        function tabObj:Slider(texto, min, max, default, callback)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -10, 0, 45)
            f.BackgroundColor3 = C.fg; f.BorderSizePixel = 0
            f.Parent = cont
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -10, 0, 18)
            l.Position = UDim2.new(0, 5, 0, 2)
            l.BackgroundTransparency = 1
            l.Text = texto .. ": " .. tostring(default)
            l.TextColor3 = C.tx; l.Font = Enum.Font.Gotham; l.TextSize = 12
            l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, -10, 0, 4)
            bar.Position = UDim2.new(0, 5, 0, 30)
            bar.BackgroundColor3 = C.bg; bar.BorderSizePixel = 0; bar.Parent = f
            Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = C.az; fill.BorderSizePixel = 0; fill.Parent = bar
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

            local drag = Instance.new("TextButton")
            drag.Size = UDim2.new(0, 12, 0, 12)
            drag.Position = UDim2.new(fill.Size.X.Scale, fill.Size.X.Offset - 6, 0.5, -6)
            drag.BackgroundColor3 = C.az; drag.BorderSizePixel = 0
            drag.Text = ""; drag.Parent = bar
            Instance.new("UICorner", drag).CornerRadius = UDim.new(1, 0)

            local dragging = false
            drag.MouseButton1Down:Connect(function() dragging = true end)
            drag.MouseButton1Up:Connect(function() dragging = false end)
            drag.MouseLeave:Connect(function() dragging = false end)

            local function update(x)
                local size = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * size)
                fill.Size = UDim2.new(size, 0, 1, 0)
                drag.Position = UDim2.new(size, -6, 0.5, -6)
                l.Text = texto .. ": " .. tostring(val)
                callback(val)
            end

            gui.InputChanged:Connect(function(inp)
                if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    update(inp.Position.X)
                end
            end)

            return {Set = function(v)
                local size = (v - min) / (max - min)
                fill.Size = UDim2.new(size, 0, 1, 0)
                drag.Position = UDim2.new(size, -6, 0.5, -6)
                l.Text = texto .. ": " .. tostring(v)
            end}
        end

        function tabObj:Dropdown(texto, lista, callback)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -10, 0, 34)
            f.BackgroundColor3 = C.fg; f.BorderSizePixel = 0
            f.Parent = cont
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -40, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = texto; l.TextColor3 = C.tx; l.Font = Enum.Font.Gotham; l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f

            local selected = Instance.new("TextLabel")
            selected.Size = UDim2.new(0, 100, 1, 0)
            selected.Position = UDim2.new(1, -110, 0, 0)
            selected.BackgroundTransparency = 1
            selected.Text = "..."; selected.TextColor3 = C.tx2; selected.Font = Enum.Font.Gotham; selected.TextSize = 12
            selected.TextXAlignment = Enum.TextXAlignment.Right; selected.Parent = f

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundTransparency = 1; b.Text = ""; b.Parent = f

            local open = false
            local dropContainer = Instance.new("Frame")
            dropContainer.Size = UDim2.new(1, -10, 0, 0)
            dropContainer.BackgroundColor3 = C.fg2
            dropContainer.BorderSizePixel = 0
            dropContainer.Parent = cont
            dropContainer.Visible = false
            Instance.new("UICorner", dropContainer).CornerRadius = UDim.new(0, 5)
            dropContainer.ZIndex = 10

            local dropLayout = Instance.new("UIListLayout", dropContainer)
            dropLayout.Padding = UDim.new(0, 2)

            b.MouseButton1Click:Connect(function()
                open = not open
                dropContainer.Visible = open
                if open then
                    dropContainer.Size = UDim2.new(1, -10, 0, math.min(#lista * 28, 140))
                end
            end)
            b.MouseEnter:Connect(function() f.BackgroundColor3 = C.fg2 end)
            b.MouseLeave:Connect(function() f.BackgroundColor3 = C.fg end)

            for _, item in ipairs(lista) do
                local ib = Instance.new("TextButton")
                ib.Size = UDim2.new(1, 0, 0, 26)
                ib.BackgroundTransparency = 1
                ib.Text = item; ib.TextColor3 = C.tx; ib.Font = Enum.Font.Gotham; ib.TextSize = 12
                ib.Parent = dropContainer
                ib.MouseButton1Click:Connect(function()
                    selected.Text = item
                    callback(item)
                    open = false
                    dropContainer.Visible = false
                end)
                ib.MouseEnter:Connect(function() ib.BackgroundColor3 = C.az3 end)
                ib.MouseLeave:Connect(function() ib.BackgroundColor3 = Color3.fromRGB(0,0,0) ib.BackgroundTransparency = 1 end)
            end

            return {Set = function(v) selected.Text = v end}
        end

        function tabObj:Separator()
            local s = Instance.new("Frame")
            s.Size = UDim2.new(1, -10, 0, 1)
            s.BackgroundColor3 = C.borda; s.BorderSizePixel = 0; s.Parent = cont
        end

        table.insert(Tabs, tabObj)
        return tabObj
    end

    -- ARRASTAR
    do
        local d = false; local di = Vector2.new(); local dp = UDim2.new()
        topo.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                d = true; di = Vector2.new(i.Position.X, i.Position.Y); dp = main.Position
            end
        end)
        topo.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end
        end)
        gui.InputChanged:Connect(function(i)
            if d and i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = Vector2.new(i.Position.X, i.Position.Y) - di
                main.Position = UDim2.new(dp.X.Scale, dp.X.Offset + delta.X, dp.Y.Scale, dp.Y.Offset + delta.Y)
            end
        end)
    end

    local win = {Gui = gui, Main = main, Tabs = Tabs, Tab = Tabs.Tab}
    table.insert(Lib.Windows, win)
    return win
end

-- ================================================================
-- FUNCOES DO JOGO
-- ================================================================
local BH = {
    ESP = false,
    Invisivel = false,
    Seguir = false,
    SeguirPlayer = nil,
    Fly = false,
    Speed = 16,
    JumpPower = 50,
    Noclip = false,
    AntiAFK = false,
    Loop = {},
}

-- ESP
local ESPObjs = {}
local function ESP_Criar(p)
    if p == LP or ESPObjs[p] then return end
    local f = Instance.new("Folder")
    f.Name = "ESP_" .. p.Name
    local h = Instance.new("Highlight", f)
    h.FillColor = Color3.fromRGB(255, 50, 50)
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.FillTransparency = 0.4; h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local bg = Instance.new("BillboardGui", f)
    bg.Size = UDim2.new(0, 200, 0, 40); bg.StudsOffset = Vector3.new(0, 3, 0)
    bg.AlwaysOnTop = true; bg.LightInfluence = 0
    local nl = Instance.new("TextLabel", bg)
    nl.Size = UDim2.new(1, 0, 0.5, 0); nl.BackgroundTransparency = 1
    nl.Text = p.Name; nl.TextColor3 = Color3.fromRGB(255, 50, 50)
    nl.TextStrokeTransparency = 0.3; nl.Font = Enum.Font.GothamBold; nl.TextSize = 14
    local dl = Instance.new("TextLabel", bg)
    dl.Size = UDim2.new(1, 0, 0.5, 0); dl.Position = UDim2.new(0, 0, 0.5, 0)
    dl.BackgroundTransparency = 1; dl.TextColor3 = Color3.fromRGB(255, 255, 255)
    dl.TextStrokeTransparency = 0.3; dl.Font = Enum.Font.Gotham; dl.TextSize = 11
    ESPObjs[p] = {Folder = f, Highlight = h, NL = nl, DL = dl, BG = bg}
    f.Parent = LP:FindFirstChild("PlayerGui")
end

local function ESP_Remover(p)
    if ESPObjs[p] then ESPObjs[p].Folder:Destroy(); ESPObjs[p] = nil end
end

function BH.ToggleESP()
    BH.ESP = not BH.ESP
    if BH.ESP then
        for _, p in Players:GetPlayers() do if p ~= LP then ESP_Criar(p) end end
    else
        for p in pairs(ESPObjs) do ESP_Remover(p) end
    end
    return BH.ESP
end

-- INVISIVEL
function BH.ToggleInvisivel()
    BH.Invisivel = not BH.Invisivel
    local char = LP.Character
    if char then
        for _, v in char:GetDescendants() do
            if v:IsA("BasePart") then v.Transparency = BH.Invisivel and 1 or 0 end
            if v:IsA("Decal") then v.Transparency = BH.Invisivel and 1 or 0 end
        end
    end
    return BH.Invisivel
end

-- SEGUIR
function BH.SelectPlayer(nome)
    for _, p in Players:GetPlayers() do
        if p.Name:lower():find(nome:lower()) or p.DisplayName:lower():find(nome:lower()) then
            BH.SeguirPlayer = p
            return p
        end
    end
    return nil
end

function BH.ToggleSeguir()
    if not BH.SeguirPlayer then BH.Seguir = false; return false end
    BH.Seguir = not BH.Seguir
    return BH.Seguir
end

-- FLY
function BH.ToggleFly()
    BH.Fly = not BH.Fly
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if BH.Fly then
        hum.PlatformStand = true
        local bp = Instance.new("BodyPosition")
        bp.Name = "FlyBP"; bp.MaxForce = Vector3.new(1,1,1) * 9e9
        bp.P = 2000; bp.D = 100
        hrp:WaitForChild("BodyPosition"):Destroy()
        bp.Parent = hrp
        BH.Loop.Fly = RunService.RenderStepped:Connect(function()
            if not BH.Fly or not hrp or not hrp.Parent then
                if BH.Loop.Fly then BH.Loop.Fly:Disconnect(); BH.Loop.Fly = nil end
                return
            end
            local move = Vector3.new(Mouse.Hit.lookVector.X, 0, Mouse.Hit.lookVector.Z)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
            bp.Position = hrp.Position + move * (BH.Speed / 10)
        end)
    else
        hum.PlatformStand = false
        hrp:FindFirstChild("FlyBP"):Destroy()
        if BH.Loop.Fly then BH.Loop.Fly:Disconnect(); BH.Loop.Fly = nil end
    end
    return BH.Fly
end

-- SPEED
function BH.SetSpeed(v)
    BH.Speed = v
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end

-- NOCLIP
function BH.ToggleNoclip()
    BH.Noclip = not BH.Noclip
    if BH.Noclip then
        BH.Loop.Noclip = RunService.Stepped:Connect(function()
            local char = LP.Character
            if not char then return end
            for _, v in char:GetDescendants() do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end)
    else
        if BH.Loop.Noclip then BH.Loop.Noclip:Disconnect(); BH.Loop.Noclip = nil end
    end
    return BH.Noclip
end

-- ANTI-AFK
function BH.ToggleAntiAFK()
    BH.AntiAFK = not BH.AntiAFK
    if BH.AntiAFK then
        local con
        con = LP.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        BH.Loop.AntiAFK = con
    else
        if BH.Loop.AntiAFK then BH.Loop.AntiAFK:Disconnect(); BH.Loop.AntiAFK = nil end
    end
    return BH.AntiAFK
end

-- RESET
function BH.Reset()
    ESPObjs = {}
    BH.Loop = {}
    BH.ESP = false; BH.Invisivel = false; BH.Seguir = false
    BH.Fly = false; BH.Noclip = false; BH.AntiAFK = false
    BH.SeguirPlayer = nil
    LP.CharacterAdded:Wait()
end

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    -- ESP update
    for p, obj in pairs(ESPObjs) do
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp and myHrp then
            obj.Highlight.Adornee = p.Character
            obj.BG.Adornee = hrp
            local dist = (hrp.Position - myHrp.Position).Magnitude
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hp = hum and math.floor((hum.Health / hum.MaxHealth) * 100) or 0
            obj.DL.Text = string.format("[%d] HP: %d%%", math.floor(dist), hp)
            local r = hum and (hum.Health / hum.MaxHealth) or 1
            obj.Highlight.FillColor = Color3.fromRGB(255 * (1 - r), 255 * r, 0)
            obj.NL.TextColor3 = obj.Highlight.FillColor
        else
            obj.Highlight.Adornee = nil; obj.BG.Adornee = nil
        end
    end

    -- Follow
    if BH.Seguir and BH.SeguirPlayer then
        local c = LP.Character; local t = BH.SeguirPlayer.Character
        if c and t then
            local m = c:FindFirstChild("HumanoidRootPart")
            local h = c:FindFirstChildOfClass("Humanoid")
            local tm = t:FindFirstChild("HumanoidRootPart")
            if m and h and tm then
                local d = (tm.Position - m.Position).Magnitude
                if d > 4 then
                    m.CFrame = m.CFrame + (tm.Position - m.Position).Unit * math.min(BH.Speed * 0.1, d)
                    h.WalkToPoint = tm.Position
                end
            end
        end
    end
end)

-- PLAYER EVENTS
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if BH.ESP then ESP_Criar(p) end
    end)
end)
Players.PlayerRemoving:Connect(function(p)
    ESP_Remover(p)
    if BH.SeguirPlayer == p then BH.SeguirPlayer = nil; BH.Seguir = false end
end)
for _, p in Players:GetPlayers() do
    if p ~= LP then
        if BH.ESP then ESP_Criar(p) end
        p.CharacterAdded:Connect(function()
            task.wait(1)
            if BH.ESP then ESP_Criar(p) end
        end)
    end
end

-- ================================================================
-- UI
-- ================================================================
local win = Lib:Window("Brookhaven RP")

-- ABA: PLAYER
local tabPlayer = win:Tab("Player")
tabPlayer:Toggle("ESP", function() return BH.ESP end, function() BH.ToggleESP() end)
tabPlayer:Toggle("Invisivel", function() return BH.Invisivel end, function() BH.ToggleInvisivel() end)
tabPlayer:Toggle("Noclip", function() return BH.Noclip end, function() BH.ToggleNoclip() end)
tabPlayer:Toggle("Anti AFK", function() return BH.AntiAFK end, function() BH.ToggleAntiAFK() end)
tabPlayer:Separator()
tabPlayer:Slider("WalkSpeed", 10, 120, BH.Speed, function(v) BH.SetSpeed(v) end)
tabPlayer:Toggle("Fly", function() return BH.Fly end, function() BH.ToggleFly() end)

-- ABA: FOLLOW
local tabFollow = win:Tab("Seguir")
tabFollow:Label("Digite o nome do jogador:")
local fb = tabFollow:Textbox("Nome do jogador...", function(txt)
    local p = BH.SelectPlayer(txt)
    if p then
        lbl:Set("Alvo: " .. p.Name)
    else
        lbl:Set("Nao encontrado: " .. txt)
    end
end)
local lbl = tabFollow:Label("Alvo: nenhum")
tabFollow:Button("Seguir jogador", function()
    local s = BH.ToggleSeguir()
    btnSegue.Text = s and "Seguindo..." or "Seguir jogador"
end)
local btnSegue = tabFollow:Button("Seguir jogador", function() end)
tabFollow:Button("Parar de seguir", function()
    BH.Seguir = false
    BH.SeguirPlayer = nil
    lbl:Set("Alvo: nenhum")
end)

-- ABA: TELEPORTES
local tabTP = win:Tab("Teleportes")
local tps = {
    {"Policia", Vector3.new(183, 24, 220)},
    {"Hospital", Vector3.new(242, 24, 275)},
    {"Escola", Vector3.new(350, 24, 200)},
    {"Supermercado", Vector3.new(290, 24, 170)},
    {"Banco", Vector3.new(315, 24, 315)},
    {"Praia", Vector3.new(430, 20, 350)},
    {"Flamingo", Vector3.new(100, 28, 470)},
    {"Castelo", Vector3.new(80, 50, 80)},
    {"Estacao", Vector3.new(145, 24, 340)},
    {"Preferencia", Vector3.new(530, 24, 305)},
}
for _, tp in ipairs(tps) do
    tabTP:Button(tp[1], function()
        local c = LP.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            c:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(tp[2])
        end
    end)
end

-- ABA: DIVERSOS
local tabOutros = win:Tab("Outros")
tabOutros:Button("Resetar personagem", function()
    LP.CharacterAdded:Wait()
    task.wait(1)
    if BH.Invisivel then BH.ToggleInvisivel() end
end)
tabOutros:Button("Destruir GUI", function() win.Gui:Destroy() end)

print("Brookhaven RP carregado! F1 = toggle")