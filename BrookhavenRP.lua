--[[
╔══════════════════════════════════════════════════════════════════╗
║              BROOKHAVEN RP - SCRIPT COMPLETO v2.0               ║
║  COMO USAR:                                                     ║
║  1. Abra o Roblox e entre no Brookhaven RP                      ║
║  2. Abra seu executor (Synapse, Fluxus, Krnl, etc.)             ║
║  3. Conecte ao jogo (Attach / Inject)                           ║
║  4. Copie este codigo e cole no executor                        ║
║  5. Execute! (F5 ou botao Execute)                              ║
║  6. Pressione F1 ou Insert para abrir o menu                    ║
╚══════════════════════════════════════════════════════════════════╝
--]]

-- ================================================================
-- BANNER
-- ================================================================
print([[
╔══════════════════════════════════════════════════════╗
║    ██████╗ ██████╗  ██████╗  ██████╗ ██╗  ██╗       ║
║    ██╔══██╗██╔══██╗██╔═══██╗██╔═══██╗██║  ██║       ║
║    ██████╔╝██████╔╝██║   ██║██║   ██║███████║       ║
║    ██╔══██╗██╔══██╗██║   ██║██║   ██║██╔══██║       ║
║    ██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║  ██║       ║
║    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝       ║
║                                                      ║
║           BROOKHAVEN RP  |  SCRIPT v2.0              ║
║                                                      ║
║   F1 = Abrir/Fechar menu                             ║
║   Arraste pelo cabecalho para mover                  ║
╚══════════════════════════════════════════════════════╝
]])

-- ================================================================
-- SERVICOS
-- ================================================================
local Services = {
    Players = game:GetService("Players"),
    Run = game:GetService("RunService"),
    Input = game:GetService("UserInputService"),
    Tween = game:GetService("TweenService"),
    Teleport = game:GetService("TeleportService"),
    VirtualUser = game:GetService("VirtualUser"),
    Marketplace = game:GetService("MarketplaceService"),
    Replicated = game:GetService("ReplicatedStorage"),
    Debris = game:GetService("Debris"),
    Http = game:GetService("HttpService"),
    StarterGui = game:GetService("StarterGui"),
}

local LP = Services.Players.LocalPlayer
local Mouse = LP:GetMouse()

-- ================================================================
-- CORES (Tema noturno profissional)
-- ================================================================
local Theme = {
    BG      = Color3.fromRGB(16, 16, 24),
    BG2     = Color3.fromRGB(26, 26, 36),
    BG3     = Color3.fromRGB(36, 36, 50),
    BG4     = Color3.fromRGB(46, 46, 60),
    Primary = Color3.fromRGB(0, 160, 255),
    PrimaryD= Color3.fromRGB(0, 120, 200),
    PrimaryL= Color3.fromRGB(0, 190, 255),
    Text    = Color3.fromRGB(225, 225, 240),
    TextDim = Color3.fromRGB(140, 140, 165),
    TextInv = Color3.fromRGB(30, 30, 40),
    Success = Color3.fromRGB(0, 200, 80),
    Danger  = Color3.fromRGB(230, 50, 50),
    Warning = Color3.fromRGB(255, 180, 0),
    Info    = Color3.fromRGB(120, 100, 255),
    Border  = Color3.fromRGB(42, 42, 55),
    Shadow  = Color3.fromRGB(0, 0, 0),
    Header  = Color3.fromRGB(22, 22, 32),
    TabActive = Color3.fromRGB(0, 100, 180),
    TabInactive= Color3.fromRGB(30, 30, 42),
}

-- ================================================================
-- BIBLIOTECA DE INTERFACE (UI Library)
-- ================================================================
local UI = {Windows = {}}
UI.__index = UI

function UI:Notificar(titulo, texto, tempo)
    tempo = tempo or 5
    local ok, err = pcall(function()
        Services.StarterGui:SetCore("SendNotification", {
            Title = titulo,
            Text = texto,
            Duration = tempo,
        })
    end)
    if not ok then
        print(string.format("[NOTIFICACAO] %s: %s", titulo, texto))
    end
end

function UI:Window(titulo, largura, altura)
    largura = largura or 580
    altura = altura or 420

    local pai = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "BH_" .. Services.Http:GenerateGUID(false)
    gui.ResetOnSpawn = false
    gui.Parent = pai
    gui.DisplayOrder = 9999
    gui.IgnoreGuiInset = true
    gui.Enabled = true

    -- SOMBRA
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Theme.Shadow
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = 0

    -- JANELA PRINCIPAL
    local win = Instance.new("Frame")
    win.Size = UDim2.new(0, largura, 0, altura)
    win.Position = UDim2.new(0.5, -largura/2, 0.5, -altura/2)
    win.BackgroundColor3 = Theme.BG
    win.BorderSizePixel = 0
    win.ClipsDescendants = true

    local winCorner = Instance.new("UICorner")
    winCorner.CornerRadius = UDim.new(0, 10)

    local winStroke = Instance.new("UIStroke")
    winStroke.Color = Theme.Border
    winStroke.Thickness = 2

    -- CABECALHO
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 42)
    header.BackgroundColor3 = Theme.Header
    header.BorderSizePixel = 0

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)

    local headerFill = Instance.new("Frame")
    headerFill.Size = UDim2.new(1, 0, 0, 10)
    headerFill.Position = UDim2.new(0, 0, 1, -10)
    headerFill.BackgroundColor3 = Theme.Header
    headerFill.BorderSizePixel = 0

    local tituloLabel = Instance.new("TextLabel")
    tituloLabel.Size = UDim2.new(1, -90, 1, 0)
    tituloLabel.Position = UDim2.new(0, 14, 0, 0)
    tituloLabel.BackgroundTransparency = 1
    tituloLabel.Text = titulo
    tituloLabel.TextColor3 = Theme.Primary
    tituloLabel.Font = Enum.Font.GothamBold
    tituloLabel.TextSize = 17
    tituloLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- BOTOES DO CABECALHO
    local function CriarBotaoCabecalho(x, texto, cor, fn)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 28, 0, 28)
        b.Position = UDim2.new(1, x, 0.5, -14)
        b.BackgroundColor3 = Theme.BG2
        b.BorderSizePixel = 0
        b.Text = texto
        b.TextColor3 = cor or Theme.Text
        b.Font = Enum.Font.GothamBold
        b.TextSize = 15

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 5)

        b.MouseButton1Click:Connect(fn)
        b.MouseEnter:Connect(function()
            Services.Tween:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Theme.PrimaryD}):Play()
        end)
        b.MouseLeave:Connect(function()
            Services.Tween:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Theme.BG2}):Play()
        end)
        return b
    end

    local minimizado = false
    local alturaNormal = altura
    local alturaMin = 42

    CriarBotaoCabecalho(-64, "─", Theme.Text, function()
        minimizado = not minimizado
        corpo.Visible = not minimizado
        tabBar.Visible = not minimizado
        local alvo = minimizado and alturaMin or alturaNormal
        Services.Tween:Create(win, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, largura, 0, alvo)
        }):Play()
    end)

    CriarBotaoCabecalho(-34, "X", Theme.Danger, function()
        gui:Destroy()
    end)

    -- BARRA DE ABAS
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 32)
    tabBar.Position = UDim2.new(0, 0, 0, 42)
    tabBar.BackgroundColor3 = Theme.BG2
    tabBar.BorderSizePixel = 0

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 1, -74)
    tabContainer.Position = UDim2.new(0, 0, 0, 74)
    tabContainer.BackgroundTransparency = 1

    -- CORPO
    local corpo = Instance.new("Frame")
    corpo.Size = UDim2.new(1, 0, 1, -42)
    corpo.Position = UDim2.new(0, 0, 0, 42)
    corpo.BackgroundTransparency = 1

    -- MONTAR HIERARQUIA
    shadow.Parent = win
    win.Parent = gui
    tituloLabel.Parent = header
    headerFill.Parent = header
    headerCorner.Parent = header
    header.Parent = win
    tabBar.Parent = win
    tabContainer.Parent = win
    winCorner.Parent = win
    winStroke.Parent = win
    corpo.Parent = win

    -- SISTEMA DE ABAS
    local Abas = {}
    local abaAtiva = nil

    local function AtivarAba(aba)
        if abaAtiva then
            abaAtiva.Container.Visible = false
            abaAtiva.Botao.BackgroundColor3 = Theme.TabInactive
            abaAtiva.Botao.TextColor3 = Theme.TextDim
        end
        abaAtiva = aba
        if aba then
            aba.Container.Visible = true
            aba.Botao.BackgroundColor3 = Theme.TabActive
            aba.Botao.TextColor3 = Theme.Text
        end
    end

    function Abas:NovaAba(nome)
        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.BorderSizePixel = 0
        container.ScrollBarThickness = 4
        container.ScrollBarImageColor3 = Theme.Primary
        container.CanvasSize = UDim2.new(0, 0, 0, 0)
        container.Parent = tabContainer
        container.Visible = false

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 7)
        layout.Parent = container
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
        end)

        local padding = Instance.new("Frame")
        padding.Size = UDim2.new(1, 0, 0, 5)
        padding.BackgroundTransparency = 1
        padding.Parent = container

        -- BOTAO DA ABA
        local qtd = #Abas
        local btnLargura = math.max(70, math.floor((largura - 8) / math.max(1, #Abas + 1)) - 4)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, btnLargura, 0, 26)
        btn.Position = UDim2.new(0, 4 + qtd * (btnLargura + 4), 0, 3)
        btn.BackgroundColor3 = Theme.TabInactive
        btn.BorderSizePixel = 0
        btn.Text = nome
        btn.TextColor3 = Theme.TextDim
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = btn
        btn.Parent = tabBar

        if qtd == 0 then
            AtivarAba({Container = container, Botao = btn})
            container.Visible = true
            btn.BackgroundColor3 = Theme.TabActive
            btn.TextColor3 = Theme.Text
        end

        btn.MouseButton1Click:Connect(function()
            AtivarAba({Container = container, Botao = btn})
        end)
        btn.MouseEnter:Connect(function()
            if abaAtiva and abaAtiva.Botao ~= btn then
                btn.BackgroundColor3 = Theme.PrimaryD
            end
        end)
        btn.MouseLeave:Connect(function()
            if abaAtiva and abaAtiva.Botao ~= btn then
                btn.BackgroundColor3 = Theme.TabInactive
            end
        end)

        local aba = {
            Container = container,
            Botao = btn,
            Nome = nome,
        }

        -- ============================================================
        -- HELPERS DE ELEMENTOS
        -- ============================================================

        function aba:Botao(texto, fn)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -12, 0, 36)
            f.BackgroundColor3 = Theme.BG3
            f.BorderSizePixel = 0
            f.Parent = container

            local fCorner = Instance.new("UICorner")
            fCorner.CornerRadius = UDim.new(0, 6)
            fCorner.Parent = f

            local fStroke = Instance.new("UIStroke")
            fStroke.Color = Theme.Border
            fStroke.Thickness = 1
            fStroke.Parent = f

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = texto
            label.TextColor3 = Theme.Text
            label.Font = Enum.Font.GothamBold
            label.TextSize = 13
            label.Parent = f

            local btnOverlay = Instance.new("TextButton")
            btnOverlay.Size = UDim2.new(1, 0, 1, 0)
            btnOverlay.BackgroundTransparency = 1
            btnOverlay.Text = ""
            btnOverlay.Parent = f

            btnOverlay.MouseButton1Click:Connect(fn)
            btnOverlay.MouseEnter:Connect(function()
                Services.Tween:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = Theme.PrimaryD}):Play()
            end)
            btnOverlay.MouseLeave:Connect(function()
                Services.Tween:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = Theme.BG3}):Play()
            end)

            return f
        end

        function aba:Toggle(texto, obter, alternar)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -12, 0, 38)
            f.BackgroundColor3 = Theme.BG3
            f.BorderSizePixel = 0
            f.Parent = container

            local fCorner = Instance.new("UICorner")
            fCorner.CornerRadius = UDim.new(0, 6)
            fCorner.Parent = f

            local fStroke = Instance.new("UIStroke")
            fStroke.Color = Theme.Border
            fStroke.Thickness = 1
            fStroke.Parent = f

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -64, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = texto
            label.TextColor3 = Theme.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = f

            -- SWITCH
            local switch = Instance.new("Frame")
            switch.Size = UDim2.new(0, 46, 0, 24)
            switch.Position = UDim2.new(1, -56, 0.5, -12)
            switch.BackgroundColor3 = Theme.Danger
            switch.BorderSizePixel = 0
            switch.Parent = f

            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(1, 0)
            switchCorner.Parent = switch

            local bola = Instance.new("Frame")
            bola.Size = UDim2.new(0, 20, 0, 20)
            bola.Position = UDim2.new(0, 2, 0.5, -10)
            bola.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            bola.BorderSizePixel = 0
            bola.Parent = switch

            local bolaCorner = Instance.new("UICorner")
            bolaCorner.CornerRadius = UDim.new(1, 0)
            bolaCorner.Parent = bola

            local function AtualizarToggle()
                local estado = obter()
                switch.BackgroundColor3 = estado and Theme.Success or Theme.Danger
                local alvoX = estado and (switch.AbsoluteSize.X - 22) or 2
                Services.Tween:Create(bola, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, alvoX, 0.5, -10)
                }):Play()
            end

            local btnToggle = Instance.new("TextButton")
            btnToggle.Size = UDim2.new(1, 0, 1, 0)
            btnToggle.BackgroundTransparency = 1
            btnToggle.Text = ""
            btnToggle.Parent = f

            btnToggle.MouseButton1Click:Connect(function()
                alternar()
                AtualizarToggle()
            end)
            btnToggle.MouseEnter:Connect(function()
                Services.Tween:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = Theme.BG4}):Play()
            end)
            btnToggle.MouseLeave:Connect(function()
                Services.Tween:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = Theme.BG3}):Play()
            end)

            AtualizarToggle()

            return {Frame = f, Atualizar = AtualizarToggle}
        end

        function aba:Label(texto)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -12, 0, 22)
            l.BackgroundTransparency = 1
            l.Text = texto
            l.TextColor3 = Theme.TextDim
            l.Font = Enum.Font.Gotham
            l.TextSize = 12
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = container

            return {
                Label = l,
                Set = function(novoTexto)
                    l.Text = novoTexto
                end,
                SetCor = function(cor)
                    l.TextColor3 = cor
                end,
            }
        end

        function aba:Titulo(texto)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -12, 0, 26)
            l.BackgroundTransparency = 1
            l.Text = texto
            l.TextColor3 = Theme.Primary
            l.Font = Enum.Font.GothamBold
            l.TextSize = 14
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = container
            return l
        end

        function aba:CaixaTexto(placeholder, fn)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -12, 0, 36)
            f.BackgroundColor3 = Theme.BG3
            f.BorderSizePixel = 0
            f.Parent = container

            local fCorner = Instance.new("UICorner")
            fCorner.CornerRadius = UDim.new(0, 6)
            fCorner.Parent = f

            local fStroke = Instance.new("UIStroke")
            fStroke.Color = Theme.Border
            fStroke.Thickness = 1
            fStroke.Parent = f

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -12, 1, 0)
            box.Position = UDim2.new(0, 6, 0, 0)
            box.BackgroundTransparency = 1
            box.TextColor3 = Theme.Text
            box.PlaceholderColor3 = Theme.TextDim
            box.PlaceholderText = placeholder
            box.Font = Enum.Font.Gotham
            box.TextSize = 13
            box.ClearTextOnFocus = false
            box.Parent = f

            box.FocusLost:Connect(function(enter)
                if enter and fn then
                    fn(box.Text)
                end
            end)

            -- Hover effect
            local hover = Instance.new("TextButton")
            hover.Size = UDim2.new(1, 0, 1, 0)
            hover.BackgroundTransparency = 1
            hover.Text = ""
            hover.Parent = f
            hover.ZIndex = -1

            return {Frame = f, Box = box}
        end

        function aba:Slider(texto, min, max, padrao, fn)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -12, 0, 50)
            f.BackgroundColor3 = Theme.BG3
            f.BorderSizePixel = 0
            f.Parent = container

            local fCorner = Instance.new("UICorner")
            fCorner.CornerRadius = UDim.new(0, 6)
            fCorner.Parent = f

            local fStroke = Instance.new("UIStroke")
            fStroke.Color = Theme.Border
            fStroke.Thickness = 1
            fStroke.Parent = f

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -12, 0, 18)
            label.Position = UDim2.new(0, 6, 0, 4)
            label.BackgroundTransparency = 1
            label.Text = texto .. ": " .. tostring(padrao)
            label.TextColor3 = Theme.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = f

            local trilho = Instance.new("Frame")
            trilho.Size = UDim2.new(1, -12, 0, 4)
            trilho.Position = UDim2.new(0, 6, 0, 34)
            trilho.BackgroundColor3 = Theme.BG
            trilho.BorderSizePixel = 0
            trilho.Parent = f

            local trilhoCorner = Instance.new("UICorner")
            trilhoCorner.CornerRadius = UDim.new(1, 0)
            trilhoCorner.Parent = trilho

            local razao = (padrao - min) / (max - min)
            local preenchido = Instance.new("Frame")
            preenchido.Size = UDim2.new(razao, 0, 1, 0)
            preenchido.BackgroundColor3 = Theme.Primary
            preenchido.BorderSizePixel = 0
            preenchido.Parent = trilho

            local preenchidoCorner = Instance.new("UICorner")
            preenchidoCorner.CornerRadius = UDim.new(1, 0)
            preenchidoCorner.Parent = preenchido

            local puxador = Instance.new("TextButton")
            puxador.Size = UDim2.new(0, 14, 0, 14)
            puxador.Position = UDim2.new(razao, -7, 0.5, -7)
            puxador.BackgroundColor3 = Theme.PrimaryL
            puxador.BorderSizePixel = 0
            puxador.Text = ""
            puxador.Parent = trilho

            local puxadorCorner = Instance.new("UICorner")
            puxadorCorner.CornerRadius = UDim.new(1, 0)
            puxadorCorner.Parent = puxador

            local arrastando = false

            local function AtualizarSlider(posX)
                local tamanho = trilho.AbsoluteSize.X
                if tamanho <= 0 then return end
                local novo = math.clamp((posX - trilho.AbsolutePosition.X) / tamanho, 0, 1)
                local valor = math.floor(min + (max - min) * novo)
                preenchido.Size = UDim2.new(novo, 0, 1, 0)
                puxador.Position = UDim2.new(novo, -7, 0.5, -7)
                label.Text = texto .. ": " .. tostring(valor)
                if fn then fn(valor) end
            end

            puxador.MouseButton1Down:Connect(function()
                arrastando = true
            end)

            gui.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Clicou no trilho
                    local mp = Mouse.ViewportSize
                    local pos = inp.Position
                    -- So ativa se clicou perto do trilho
                    local abs = trilho.AbsolutePosition
                    local absSize = trilho.AbsoluteSize
                    if pos.X >= abs.X and pos.X <= abs.X + absSize.X and
                       pos.Y >= abs.Y - 10 and pos.Y <= abs.Y + absSize.Y + 10 then
                        AtualizarSlider(pos.X)
                    end
                end
            end)

            gui.InputChanged:Connect(function(inp)
                if arrastando and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    AtualizarSlider(inp.Position.X)
                end
            end)

            gui.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    arrastando = false
                end
            end)

            local sliderObj = {}
            function sliderObj:Definir(valor)
                local r = math.clamp((valor - min) / (max - min), 0, 1)
                preenchido.Size = UDim2.new(r, 0, 1, 0)
                puxador.Position = UDim2.new(r, -7, 0.5, -7)
                label.Text = texto .. ": " .. tostring(math.floor(valor))
            end

            return sliderObj
        end

        function aba:Dropdown(texto, lista, fn)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -12, 0, 36)
            f.BackgroundColor3 = Theme.BG3
            f.BorderSizePixel = 0
            f.Parent = container

            local fCorner = Instance.new("UICorner")
            fCorner.CornerRadius = UDim.new(0, 6)
            fCorner.Parent = f

            local fStroke = Instance.new("UIStroke")
            fStroke.Color = Theme.Border
            fStroke.Thickness = 1
            fStroke.Parent = f

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = texto
            label.TextColor3 = Theme.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = f

            local selected = Instance.new("TextLabel")
            selected.Size = UDim2.new(0, 90, 1, 0)
            selected.Position = UDim2.new(1, -100, 0, 0)
            selected.BackgroundTransparency = 1
            selected.Text = "..."
            selected.TextColor3 = Theme.TextDim
            selected.Font = Enum.Font.Gotham
            selected.TextSize = 12
            selected.TextXAlignment = Enum.TextXAlignment.Right
            selected.Parent = f

            local seta = Instance.new("TextLabel")
            seta.Size = UDim2.new(0, 20, 1, 0)
            seta.Position = UDim2.new(1, -22, 0, 0)
            seta.BackgroundTransparency = 1
            seta.Text = "▼"
            seta.TextColor3 = Theme.TextDim
            seta.Font = Enum.Font.GothamBold
            seta.TextSize = 10
            seta.Parent = f

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = f

            local aberto = false
            local dropContainer = Instance.new("Frame")
            dropContainer.Size = UDim2.new(1, -12, 0, 0)
            dropContainer.BackgroundColor3 = Theme.BG4
            dropContainer.BorderSizePixel = 0
            dropContainer.Parent = container
            dropContainer.Visible = false
            dropContainer.ZIndex = 10

            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 5)
            dropCorner.Parent = dropContainer

            local dropStroke = Instance.new("UIStroke")
            dropStroke.Color = Theme.Border
            dropStroke.Thickness = 1
            dropStroke.Parent = dropContainer

            local dropLayout = Instance.new("UIListLayout")
            dropLayout.Padding = UDim.new(0, 2)
            dropLayout.Parent = dropContainer

            for _, item in ipairs(lista) do
                local ib = Instance.new("TextButton")
                ib.Size = UDim2.new(1, 0, 0, 28)
                ib.BackgroundTransparency = 1
                ib.Text = item
                ib.TextColor3 = Theme.Text
                ib.Font = Enum.Font.Gotham
                ib.TextSize = 13
                ib.Parent = dropContainer

                ib.MouseButton1Click:Connect(function()
                    selected.Text = item
                    aberto = false
                    dropContainer.Visible = false
                    seta.Text = "▼"
                    if fn then fn(item) end
                end)
                ib.MouseEnter:Connect(function()
                    ib.BackgroundTransparency = 0.5
                    ib.BackgroundColor3 = Theme.PrimaryD
                end)
                ib.MouseLeave:Connect(function()
                    ib.BackgroundTransparency = 1
                end)
            end

            btn.MouseButton1Click:Connect(function()
                aberto = not aberto
                dropContainer.Visible = aberto
                seta.Text = aberto and "▲" or "▼"
                if aberto then
                    local qtd = #lista
                    dropContainer.Size = UDim2.new(1, -12, 0, math.min(qtd * 30, 150))
                    container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + dropLayout.AbsoluteContentSize.Y + 50)
                end
            end)

            btn.MouseEnter:Connect(function()
                Services.Tween:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = Theme.BG4}):Play()
            end)
            btn.MouseLeave:Connect(function()
                Services.Tween:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = Theme.BG3}):Play()
            end)

            local dropObj = {}
            function dropObj:Set(v)
                selected.Text = v
            end
            return dropObj
        end

        function aba:Separador()
            local s = Instance.new("Frame")
            s.Size = UDim2.new(1, -12, 0, 1)
            s.BackgroundColor3 = Theme.Border
            s.BorderSizePixel = 0
            s.Parent = container
            return s
        end

        function aba:Espaco(altura)
            altura = altura or 4
            local s = Instance.new("Frame")
            s.Size = UDim2.new(1, 0, 0, altura)
            s.BackgroundTransparency = 1
            s.Parent = container
            return s
        end

        table.insert(Abas, aba)
        return aba
    end

    -- ARRASTAR
    do
        local movendo = false
        local inicio = Vector2.new()
        local posOriginal = UDim2.new()

        header.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                movendo = true
                inicio = Vector2.new(inp.Position.X, inp.Position.Y)
                posOriginal = win.Position
            end
        end)

        header.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                movendo = false
            end
        end)

        gui.InputChanged:Connect(function(inp)
            if movendo and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = Vector2.new(inp.Position.X, inp.Position.Y) - inicio
                win.Position = UDim2.new(
                    posOriginal.X.Scale, posOriginal.X.Offset + delta.X,
                    posOriginal.Y.Scale, posOriginal.Y.Offset + delta.Y
                )
            end
        end)
    end

    local janela = {
        Gui = gui,
        Win = win,
        Abas = Abas,
        NovaAba = Abas.NovaAba,
        Titulo = titulo,
    }
    table.insert(UI.Windows, janela)
    return janela
end

-- ================================================================
-- FUNCOES DO JOGO (GAME MODULES)
-- ================================================================
local BH = {
    ESP = false,
    Invisivel = false,
    Noclip = false,
    AntiAFK = false,
    Fly = false,
    Speed = 16,
    JumpPower = 50,
    Gravidade = 196.2,
    Seguir = false,
    SeguirPlayer = nil,
    Godmode = false,
    Infectar = false,
    Grudado = false,
    GrudadoPlayer = nil,
    Limbo = CFrame.new(0, -500, 0),
    PosOriginal = nil,
    Config = {},
}

BH.Loops = {}
BH.ESPObjs = {}

-- ================================================================
-- ESP
-- ================================================================
function BH:CriarESP(p)
    if p == LP or self.ESPObjs[p] then return end
    local f = Instance.new("Folder")
    f.Name = "ESP_" .. p.Name

    local hl = Instance.new("Highlight", f)
    hl.FillColor = Color3.fromRGB(255, 50, 50)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.35
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local bg = Instance.new("BillboardGui", f)
    bg.Size = UDim2.new(0, 220, 0, 50)
    bg.StudsOffset = Vector3.new(0, 3.5, 0)
    bg.AlwaysOnTop = true
    bg.LightInfluence = 0

    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1, 0, 0.5, 0)
    nl.BackgroundTransparency = 1
    nl.Text = p.Name
    nl.TextColor3 = Color3.fromRGB(255, 80, 80)
    nl.TextStrokeTransparency = 0.2
    nl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nl.Font = Enum.Font.GothamBold
    nl.TextSize = 15
    nl.Parent = bg

    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, 0, 0.5, 0)
    dl.Position = UDim2.new(0, 0, 0.5, 0)
    dl.BackgroundTransparency = 1
    dl.Text = ""
    dl.TextColor3 = Color3.fromRGB(200, 200, 200)
    dl.TextStrokeTransparency = 0.3
    dl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    dl.Font = Enum.Font.Gotham
    dl.TextSize = 12
    dl.Parent = bg

    self.ESPObjs[p] = {Folder = f, Highlight = hl, NameLabel = nl, DistLabel = dl, Billboard = bg}
    f.Parent = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
end

function BH:RemoverESP(p)
    if self.ESPObjs[p] then
        self.ESPObjs[p].Folder:Destroy()
        self.ESPObjs[p] = nil
    end
end

function BH:ToggleESP()
    self.ESP = not self.ESP
    if self.ESP then
        for _, p in Services.Players:GetPlayers() do
            if p ~= LP then self:CriarESP(p) end
        end
    else
        for p in pairs(self.ESPObjs) do self:RemoverESP(p) end
    end
    return self.ESP
end

function BH:AtualizarESP()
    for p, obj in pairs(self.ESPObjs) do
        local char = p.Character
        local myChar = LP.Character
        if char and myChar then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local myHrp = myChar:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and myHrp and hum and hum.Health > 0 then
                obj.Highlight.Adornee = char
                obj.Billboard.Adornee = hrp
                local dist = (hrp.Position - myHrp.Position).Magnitude
                local hp = math.floor((hum.Health / hum.MaxHealth) * 100)
                obj.DistLabel.Text = string.format("[%dm] HP: %d%%", math.floor(dist), hp)
                local r = hum.Health / hum.MaxHealth
                local cor = Color3.fromRGB(255 * (1 - r), 255 * r, 0)
                obj.Highlight.FillColor = cor
                obj.NameLabel.TextColor3 = cor
            else
                obj.Highlight.Adornee = nil
                obj.Billboard.Adornee = nil
            end
        else
            obj.Highlight.Adornee = nil
            obj.Billboard.Adornee = nil
        end
    end
end

-- ================================================================
-- INVISIVEL
-- ================================================================
function BH:ToggleInvisivel()
    self.Invisivel = not self.Invisivel
    local char = LP.Character
    if char then
        for _, v in char:GetDescendants() do
            if v:IsA("BasePart") then v.Transparency = self.Invisivel and 1 or 0 end
            if v:IsA("Decal") then v.Transparency = self.Invisivel and 1 or 0 end
            if v:IsA("MeshPart") then v.Transparency = self.Invisivel and 1 or 0 end
        end
        -- Mantem ferramenta visivel
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in tool:GetDescendants() do
                if v:IsA("BasePart") then v.Transparency = 0 end
            end
        end
    end
    return self.Invisivel
end

-- ================================================================
-- NOCLIP
-- ================================================================
function BH:ToggleNoclip()
    self.Noclip = not self.Noclip
    if self.Noclip then
        self.Loops.Noclip = Services.Run.Stepped:Connect(function()
            local char = LP.Character
            if not char then return end
            for _, v in char:GetDescendants() do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    else
        if self.Loops.Noclip then
            self.Loops.Noclip:Disconnect()
            self.Loops.Noclip = nil
        end
    end
    return self.Noclip
end

-- ================================================================
-- ANTI AFK
-- ================================================================
function BH:ToggleAntiAFK()
    self.AntiAFK = not self.AntiAFK
    if self.AntiAFK then
        local con
        con = LP.Idled:Connect(function()
            Services.VirtualUser:CaptureController()
            Services.VirtualUser:ClickButton2(Vector2.new())
        end)
        self.Loops.AntiAFK = con
    else
        if self.Loops.AntiAFK then
            self.Loops.AntiAFK:Disconnect()
            self.Loops.AntiAFK = nil
        end
    end
    return self.AntiAFK
end

-- ================================================================
-- FLY
-- ================================================================
function BH:ToggleFly()
    self.Fly = not self.Fly
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if self.Fly then
        hum.PlatformStand = true
        local bp = Instance.new("BodyPosition")
        bp.Name = "FlyBP"
        bp.MaxForce = Vector3.new(1, 1, 1) * 9e9
        bp.P = 2000
        bp.D = 100
        local old = hrp:FindFirstChild("BodyPosition")
        if old then old:Destroy() end
        bp.Parent = hrp

        self.Loops.Fly = Services.Run.RenderStepped:Connect(function()
            if not self.Fly or not hrp or not hrp.Parent then
                if self.Loops.Fly then self.Loops.Fly:Disconnect(); self.Loops.Fly = nil end
                return
            end
            local dir = Vector3.new()
            if Services.Input:IsKeyDown(Enum.KeyCode.W) then dir = dir + Vector3.new(0, 0, -1) end
            if Services.Input:IsKeyDown(Enum.KeyCode.S) then dir = dir + Vector3.new(0, 0, 1) end
            if Services.Input:IsKeyDown(Enum.KeyCode.A) then dir = dir + Vector3.new(-1, 0, 0) end
            if Services.Input:IsKeyDown(Enum.KeyCode.D) then dir = dir + Vector3.new(1, 0, 0) end
            if Services.Input:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if Services.Input:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir + Vector3.new(0, -1, 0) end

            local cam = workspace.CurrentCamera
            if cam then
                dir = cam.CFrame:VectorToObjectSpace(dir)
            end
            bp.Position = hrp.Position + dir * (self.Speed * 0.12)
        end)
    else
        hum.PlatformStand = false
        local bp = hrp:FindFirstChild("FlyBP")
        if bp then bp:Destroy() end
        if self.Loops.Fly then self.Loops.Fly:Disconnect(); self.Loops.Fly = nil end
    end
    return self.Fly
end

-- ================================================================
-- SPEED / JUMP / GRAVIDADE
-- ================================================================
function BH:SetSpeed(v)
    self.Speed = v
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end

function BH:SetJump(v)
    self.JumpPower = v
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = v end
end

function BH:SetGravidade(v)
    self.Gravidade = v
    workspace.Gravity = v
end

-- ================================================================
-- SEGUIR JOGADOR
-- ================================================================
function BH:SelectPlayer(nome)
    for _, p in Services.Players:GetPlayers() do
        if p.Name:lower():find(nome:lower()) or (p.DisplayName and p.DisplayName:lower():find(nome:lower())) then
            self.SeguirPlayer = p
            return p
        end
    end
    return nil
end

function BH:ToggleSeguir()
    if not self.SeguirPlayer then
        self.Seguir = false
        return false
    end
    self.Seguir = not self.Seguir
    return self.Seguir
end

-- ================================================================
-- GODMODE
-- ================================================================
function BH:ToggleGodmode()
    self.Godmode = not self.Godmode
    if self.Godmode then
        self.Loops.Godmode = Services.Run.RenderStepped:Connect(function()
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end
        end)
    else
        if self.Loops.Godmode then
            self.Loops.Godmode:Disconnect()
            self.Loops.Godmode = nil
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = 100
                hum.Health = 100
            end
        end
    end
    return self.Godmode
end

-- ================================================================
-- REPELIR VEICULOS
-- ================================================================
function BH:RepelirVeiculos()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local pos = char:FindFirstChild("HumanoidRootPart").Position
    local raio = 30
    local repelidos = 0

    for _, v in workspace:GetDescendants() do
        if v:IsA("VehicleSeat") then
            local veiculo = v.Parent
            if veiculo and veiculo:FindFirstChild("HumanoidRootPart") then
                local hrp = veiculo:FindFirstChild("HumanoidRootPart")
                local dist = (hrp.Position - pos).Magnitude
                if dist <= raio then
                    local dir = (hrp.Position - pos).Unit
                    hrp.CFrame = hrp.CFrame + dir * Vector3.new(50, 10, 50)
                    hrp.Velocity = dir * 100 + Vector3.new(0, 30, 0)
                    repelidos = repelidos + 1
                end
            end
        end
    end

    UI:Notificar("Repelir", repelidos .. " veiculo(s) repelidos!")
    return repelidos
end

-- ================================================================
-- GRUDAR NO ALVO (clicar para prender)
-- ================================================================
function BH:ToggleGrudar()
    if not BH.SeguirPlayer then
        UI:Notificar("Erro", "Selecione um alvo primeiro!")
        return false
    end

    self.Grudado = not self.Grudado
    if self.Grudado then
        self.GrudadoPlayer = self.SeguirPlayer
        -- Cria uma corrente invisivel entre os dois
        local myChar = LP.Character
        local alvoChar = self.GrudadoPlayer.Character
        if not myChar or not alvoChar then self.Grudado = false; return false end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        local alvoHRP = alvoChar:FindFirstChild("HumanoidRootPart")
        if not myHRP or not alvoHRP then self.Grudado = false; return false end

        -- Usa AlignPosition para grudar
        local att1 = Instance.new("Attachment")
        att1.Name = "GrudeAtt"
        att1.Parent = myHRP

        local att2 = Instance.new("Attachment")
        att2.Name = "GrudeAtt"
        att2.Parent = alvoHRP

        local align = Instance.new("AlignPosition")
        align.Attachment0 = att1
        align.Attachment1 = att2
        align.RigidityEnabled = true
        align.MaxForce = 9e9
        align.Responsiveness = 200
        align.Parent = myHRP

        self.Loops.Grude = Services.Run.RenderStepped:Connect(function()
            if not self.Grudado or not self.GrudadoPlayer or not self.GrudadoPlayer.Parent then
                self:SolteGrude()
            end
            local a = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local b = self.GrudadoPlayer and self.GrudadoPlayer.Character and self.GrudadoPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not a or not b then self:SolteGrude() end
        end)

        UI:Notificar("Grudado", "Voce esta grudado em " .. self.GrudadoPlayer.Name)
        return true
    else
        self:SolteGrude()
        return false
    end
end

function BH:SolteGrude()
    self.Grudado = false
    self.GrudadoPlayer = nil

    if self.Loops.Grude then
        self.Loops.Grude:Disconnect()
        self.Loops.Grude = nil
    end

    -- Remove attachments e aligns
    local myChar = LP.Character
    if myChar then
        local hrp = myChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            local old = hrp:FindFirstChild("GrudeAtt")
            if old then old:Destroy() end
            local oldAlign = hrp:FindFirstChildOfClass("AlignPosition")
            if oldAlign then oldAlign:Destroy() end
        end
    end

    -- Remove do alvo tambem
    for _, p in Services.Players:GetPlayers() do
        local c = p.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            local att = c:FindFirstChild("HumanoidRootPart"):FindFirstChild("GrudeAtt")
            if att then att:Destroy() end
        end
    end

    UI:Notificar("Solto", "Voce se soltou do alvo!")
end

-- ================================================================
-- PUXAR VEICULO (traz o veiculo ate voce)
-- ================================================================
function BH:PuxarVeiculo()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local pos = char:FindFirstChild("HumanoidRootPart").Position
    local maisPerto = nil
    local menorDist = math.huge

    for _, v in workspace:GetDescendants() do
        if v:IsA("VehicleSeat") then
            local veiculo = v.Parent
            if veiculo and veiculo:FindFirstChild("HumanoidRootPart") then
                local hrp = veiculo:FindFirstChild("HumanoidRootPart")
                local dist = (hrp.Position - pos).Magnitude
                if dist < menorDist then
                    menorDist = dist
                    maisPerto = veiculo
                end
            end
        end
    end

    if maisPerto and maisPerto:FindFirstChild("HumanoidRootPart") then
        local hrp = maisPerto:FindFirstChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2, -5))
        hrp.Velocity = Vector3.new()
        UI:Notificar("Veiculo", "Veiculo puxado ate voce!")
    else
        UI:Notificar("Veiculo", "Nenhum veiculo encontrado!")
    end
end

-- ================================================================
-- ONIBUS SEQUESTRO (busca onibus, persegue alvo, leva ao limbo)
-- ================================================================
function BH:OnibusSequestro()
    if not self.SeguirPlayer then
        UI:Notificar("Onibus", "Selecione um alvo primeiro!")
        return
    end

    local alvo = self.SeguirPlayer
    local alvoChar = alvo.Character
    if not alvoChar then
        UI:Notificar("Onibus", "Alvo sem personagem!")
        return
    end

    local char = LP.Character
    if not char then return end
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    -- Salva posicao original
    self.PosOriginal = myHRP.CFrame
    UI:Notificar("Onibus", "Procurando onibus escolar...")

    -- Procura o onibus escolar no workspace
    local onibus = nil
    local possibilidades = {"SchoolBus", "School Bus", "Bus", "Escolar"}
    for _, v in workspace:GetDescendants() do
        if v:IsA("Model") then
            local nome = v.Name:lower()
            for _, termo in ipairs(possibilidades) do
                if nome:find(termo:lower()) then
                    -- Verifica se tem VehicleSeat
                    if v:FindFirstChildWhichIsA("VehicleSeat") then
                        onibus = v
                        break
                    end
                end
            end
        end
        if onibus then break end
    end

    if not onibus then
        UI:Notificar("Onibus", "Nenhum onibus escolar encontrado!")
        return
    end

    local busHRP = onibus:FindFirstChild("HumanoidRootPart") or onibus:FindFirstChildWhichIsA("BasePart")
    if not busHRP then
        UI:Notificar("Onibus", "Onibus sem parte principal!")
        return
    end

    UI:Notificar("Onibus", "Onibus encontrado! Perseguindo alvo...")

    -- Teletransporta jogador para o onibus
    myHRP.CFrame = busHRP.CFrame + Vector3.new(0, 3, 0)

    -- Persegue o alvo com o onibus
    local passos = 0
    local maxPassos = 300

    local con
    con = Services.Run.RenderStepped:Connect(function()
        passos = passos + 1
        if passos > maxPassos then
            con:Disconnect()
            UI:Notificar("Onibus", "Alvo fugiu! Abortando.")
            return
        end

        local alvoCharAtual = alvo.Character
        if not alvoCharAtual then
            con:Disconnect()
            UI:Notificar("Onibus", "Alvo desconectou!")
            return
        end

        local alvoHRP = alvoCharAtual:FindFirstChild("HumanoidRootPart")
        if not alvoHRP then
            con:Disconnect()
            return
        end

        -- Move onibus em direcao ao alvo
        local dir = (alvoHRP.Position - busHRP.Position).Unit
        local dist = (alvoHRP.Position - busHRP.Position).Magnitude
        busHRP.CFrame = CFrame.lookAt(busHRP.Position, alvoHRP.Position) * CFrame.new(0, 0, math.min(1.5, dist))
        busHRP.CFrame = busHRP.CFrame + dir * math.min(2, dist)

        -- Se chegou perto do alvo
        if dist < 8 then
            con:Disconnect()

            UI:Notificar("Onibus", "Alvo capturado! Enviando ao limbo...")

            -- Pega o alvo e leva pro limbo
            task.wait(0.5)
            local alvoChar2 = alvo.Character
            if alvoChar2 and alvoChar2:FindFirstChild("HumanoidRootPart") then
                -- Salva pos do alvo pra depois
                local alvoAntes = alvoChar2:FindFirstChild("HumanoidRootPart").CFrame

                -- Leva ao limbo
                alvoChar2:FindFirstChild("HumanoidRootPart").CFrame = self.Limbo

                -- Solta o alvo
                task.wait(1)

                -- Volta jogador para pos original
                if self.PosOriginal then
                    task.wait(0.3)
                    local charAtual = LP.Character
                    if charAtual and charAtual:FindFirstChild("HumanoidRootPart") then
                        charAtual:FindFirstChild("HumanoidRootPart").CFrame = self.PosOriginal
                    end
                end

                UI:Notificar("Onibus", "Sequestro concluido!")
            end
        end
    end)
end

-- ================================================================
-- TELEPORTES
-- ================================================================
function BH:TeleportarCFrame(cf)
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:FindFirstChild("HumanoidRootPart").CFrame = cf
    end
end

function BH:TeleportarJogador(nome)
    for _, p in Services.Players:GetPlayers() do
        if p.Name:lower():find(nome:lower()) or (p.DisplayName and p.DisplayName:lower():find(nome:lower())) then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                self:TeleportarCFrame(char:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(2, 0, 2))
                return true
            end
        end
    end
    return false
end

function BH:TeleportarCoordenadas(x, y, z)
    self:TeleportarCFrame(CFrame.new(x, y, z))
end

-- ================================================================
-- RESET
-- ================================================================
function BH:Reset()
    self.ESP = false
    self.Invisivel = false
    self.Noclip = false
    self.AntiAFK = false
    self.Fly = false
    self.Seguir = false
    self.SeguirPlayer = nil
    self.Godmode = false
    self.Infectar = false
    self.Grudado = false
    self.GrudadoPlayer = nil
    self.Speed = 16
    self.JumpPower = 50

    self:SolteGrude()

    for k, v in pairs(self.Loops) do
        if v then pcall(function() v:Disconnect() end) end
    end
    self.Loops = {}
    for p in pairs(self.ESPObjs) do self:RemoverESP(p) end

    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:BreakJoints() end
end

-- ================================================================
-- LOOP PRINCIPAL
-- ================================================================
Services.Run.RenderStepped:Connect(function()
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
                    local dir = (tm.Position - m.Position).Unit
                    m.CFrame = m.CFrame + dir * math.min(BH.Speed * 0.12, d)
                    h.WalkToPoint = tm.Position
                end
            end
        end
    end
end)

-- ================================================================
-- EVENTOS DE JOGADOR
-- ================================================================
Services.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1.5)
        if BH.ESP then BH:CriarESP(p) end
    end)
end)

Services.Players.PlayerRemoving:Connect(function(p)
    BH:RemoverESP(p)
    if BH.SeguirPlayer == p then BH.SeguirPlayer = nil; BH.Seguir = false end
end)

for _, p in Services.Players:GetPlayers() do
    if p ~= LP then
        if BH.ESP then BH:CriarESP(p) end
        p.CharacterAdded:Connect(function()
            task.wait(1.5)
            if BH.ESP then BH:CriarESP(p) end
        end)
    end
end

-- ================================================================
-- CONFIGURACAO (salvar/carregar via HttpService)
-- ================================================================
function BH:SalvarConfig()
    local dados = {
        ESP = self.ESP,
        Invisivel = self.Invisivel,
        Noclip = self.Noclip,
        AntiAFK = self.AntiAFK,
        Speed = self.Speed,
        JumpPower = self.JumpPower,
        Gravidade = self.Gravidade,
    }
    self.Config = dados
    local json = Services.Http:JSONEncode(dados)
    writefile("BH_Config.json", json)
    return true
end

function BH:CarregarConfig()
    local arquivo = readfile("BH_Config.json")
    if arquivo then
        local ok, dados = pcall(Services.Http.JSONDecode, Services.Http, arquivo)
        if ok and type(dados) == "table" then
            self.Config = dados
            if dados.ESP ~= nil then self.ESP = dados.ESP end
            if dados.Invisivel ~= nil then self.Invisivel = dados.Invisivel end
            if dados.Noclip ~= nil then self.Noclip = dados.Noclip end
            if dados.AntiAFK ~= nil then self.AntiAFK = dados.AntiAFK end
            if dados.Speed then self:SetSpeed(dados.Speed) end
            if dados.JumpPower then self:SetJump(dados.JumpPower) end
            if dados.Gravidade then self:SetGravidade(dados.Gravidade) end
            return true
        end
    end
    return false
end

-- ================================================================
-- CRIACAO DA INTERFACE
-- ================================================================
local Janela = UI:Window("BROOKHAVEN RP", 580, 440)

-- ================================================================
-- ABA: PLAYER
-- ================================================================
local tabPlayer = Janela:NovaAba("Player")

tabPlayer:Titulo("Hacks do Personagem")
local togESP = tabPlayer:Toggle("ESP (Visao atraves)", function() return BH.ESP end, function() BH:ToggleESP() end)
local togInvis = tabPlayer:Toggle("Invisivel", function() return BH.Invisivel end, function() BH:ToggleInvisivel() end)
local togNoclip = tabPlayer:Toggle("Noclip (Atravessar paredes)", function() return BH.Noclip end, function() BH:ToggleNoclip() end)
local togAntiAFK = tabPlayer:Toggle("Anti AFK", function() return BH.AntiAFK end, function() BH:ToggleAntiAFK() end)
local togFly = tabPlayer:Toggle("Modo Voo", function() return BH.Fly end, function() BH:ToggleFly() end)
tabPlayer:Separador()

tabPlayer:Titulo("Status")
local lblSpeed = tabPlayer:Label("WalkSpeed: " .. BH.Speed)
local lblJump = tabPlayer:Label("JumpPower: " .. BH.JumpPower)
tabPlayer:Separador()

tabPlayer:Titulo("Controles")
tabPlayer:Slider("WalkSpeed", 10, 200, BH.Speed, function(v)
    BH:SetSpeed(v)
    lblSpeed:Set("WalkSpeed: " .. v)
end)
tabPlayer:Slider("JumpPower", 10, 300, BH.JumpPower, function(v)
    BH:SetJump(v)
    lblJump:Set("JumpPower: " .. v)
end)

-- ================================================================
-- ABA: SEGUIR
-- ================================================================
local tabSeguir = Janela:NovaAba("Seguir")

tabSeguir:Titulo("Buscar Jogador")
local lblAlvo = tabSeguir:Label("Alvo: nenhum")
tabSeguir:CaixaTexto("Digite o nome do jogador...", function(txt)
    local p = BH:SelectPlayer(txt)
    if p then
        lblAlvo:Set("Alvo: " .. p.Name)
        lblAlvo:SetCor(Theme.Success)
        UI:Notificar("Alvo selecionado", p.Name)
    else
        lblAlvo:Set("Jogador nao encontrado: " .. txt)
        lblAlvo:SetCor(Theme.Danger)
    end
end)

tabSeguir:Separador()
tabSeguir:Titulo("Controles de Seguir")
local lblSeguindo = tabSeguir:Label("Status: Parado")

tabSeguir:Botao("Seguir alvo", function()
    local s = BH:ToggleSeguir()
    lblSeguindo:Set(s and "Status: Seguindo " .. (BH.SeguirPlayer and BH.SeguirPlayer.Name or "?") or "Status: Parado")
    lblSeguindo:SetCor(s and Theme.Success or Theme.TextDim)
end)

tabSeguir:Botao("Parar de seguir", function()
    BH.Seguir = false
    BH.SeguirPlayer = nil
    lblAlvo:Set("Alvo: nenhum")
    lblAlvo:SetCor(Theme.TextDim)
    lblSeguindo:Set("Status: Parado")
    lblSeguindo:SetCor(Theme.TextDim)
end)

tabSeguir:Separador()
tabSeguir:Titulo("Grudar no Alvo")
local lblGrude = tabSeguir:Label("Grudado: Nao")
tabSeguir:Botao("Grudar / Soltar alvo", function()
    local s = BH:ToggleGrudar()
    lblGrude:Set(s and "Grudado: " .. (BH.GrudadoPlayer and BH.GrudadoPlayer.Name or "?") or "Grudado: Nao")
    lblGrude:SetCor(s and Theme.Success or Theme.TextDim)
end)
tabSeguir:Botao("Soltar grude", function()
    BH:SolteGrude()
    lblGrude:Set("Grudado: Nao")
    lblGrude:SetCor(Theme.TextDim)
end)

-- ================================================================
-- ABA: VEICULOS
-- ================================================================
local tabVeic = Janela:NovaAba("Veiculos")

tabVeic:Titulo("Controle de Veiculos")
tabVeic:Botao("Repelir veiculos (30m)", function()
    BH:RepelirVeiculos()
end)

tabVeic:Botao("Puxar veiculo ate voce", function()
    BH:PuxarVeiculo()
end)

tabVeic:Separador()
tabVeic:Titulo("Onibus Escolar - Sequestro")
local lblOnibus = tabVeic:Label("Status: Aguardando")
tabVeic:Botao("INICIAR SEQUESTRO", function()
    lblOnibus:Set("Status: Executando sequestro...")
    lblOnibus:SetCor(Theme.Warning)
    task.spawn(function()
        BH:OnibusSequestro()
        task.wait(0.5)
        lblOnibus:Set("Status: Pronto")
        lblOnibus:SetCor(Theme.Success)
    end)
end)

tabVeic:Separador()
tabVeic:Titulo("Locais de Veiculos (Brookhaven)")
local veiculosLocais = {
    {"Garagem (casa padrao)", CFrame.new(190, 23.5, 210)},
    {"Concessionaria", CFrame.new(270, 23.5, 230)},
    {"Estacionamento Hospital", CFrame.new(255, 23.5, 285)},
    {"Oficina Mecanica", CFrame.new(220, 23.5, 155)},
    {"Estacionamento Escola", CFrame.new(340, 23.5, 215)},
    {"Heliporto", CFrame.new(310, 30, 290)},
}
for _, loc in ipairs(veiculosLocais) do
    tabVeic:Botao(loc[1], function()
        BH:TeleportarCFrame(loc[2])
    end)
end

-- ================================================================
-- ABA: TELEPORTES
-- ================================================================
local tabTP = Janela:NovaAba("Teleportes")

tabTP:Titulo("Locais do Brookhaven")
local locais = {
    {"Policia", CFrame.new(183, 24, 220)},
    {"Hospital", CFrame.new(242, 24, 275)},
    {"Escola", CFrame.new(350, 24, 200)},
    {"Supermercado", CFrame.new(290, 24, 170)},
    {"Banco", CFrame.new(315, 24, 315)},
    {"Praia", CFrame.new(430, 20, 350)},
    {"Flamingo", CFrame.new(100, 28, 470)},
    {"Castelo", CFrame.new(80, 50, 80)},
    {"Estacao de Trem", CFrame.new(145, 24, 340)},
    {"Prefeitura", CFrame.new(530, 24, 305)},
    {"Igreja", CFrame.new(410, 24, 225)},
    {"Posto de Gasolina", CFrame.new(195, 24, 170)},
}

for _, localInfo in ipairs(locais) do
    tabTP:Botao(localInfo[1], function()
        BH:TeleportarCFrame(localInfo[2])
        UI:Notificar("Teleporte", " Indo para " .. localInfo[1])
    end)
end

tabTP:Separador()
tabTP:Titulo("Teleporte Personalizado")

local lblTPStatus = tabTP:Label("")
tabTP:CaixaTexto("Nome do jogador...", function(txt)
    local ok = BH:TeleportarJogador(txt)
    if ok then
        lblTPStatus:Set("Teleportado para " .. txt)
        lblTPStatus:SetCor(Theme.Success)
    else
        lblTPStatus:Set("Jogador nao encontrado: " .. txt)
        lblTPStatus:SetCor(Theme.Danger)
    end
end)

tabTP:CaixaTexto("X, Y, Z (ex: 100, 24, 100)", function(txt)
    local partes = txt:match("([%d%.%-]+)%s*,%s*([%d%.%-]+)%s*,%s*([%d%.%-]+)")
    if partes then
        local x, y, z = tonumber(partes), tonumber(partes), tonumber(partes)
        if x and y and z then
            BH:TeleportarCoordenadas(x, y, z)
            lblTPStatus:Set(string.format("Teleportado para %.0f, %.0f, %.0f", x, y, z))
            lblTPStatus:SetCor(Theme.Success)
        end
    else
        lblTPStatus:Set("Formato invalido. Use: X, Y, Z")
        lblTPStatus:SetCor(Theme.Danger)
    end
end)

-- ================================================================
-- ABA: MISC
-- ================================================================
local tabMisc = Janela:NovaAba("Misc")

tabMisc:Titulo("Extras")
tabMisc:Botao("Resetar Personagem", function()
    BH:Reset()
    UI:Notificar("Reset", "Personagem resetado!")
end)

local lblGod = tabMisc:Label("Godmode: Desativado")
tabMisc:Botao("Godmode (Imortal)", function()
    local s = BH:ToggleGodmode()
    lblGod:Set(s and "Godmode: Ativado" or "Godmode: Desativado")
    lblGod:SetCor(s and Theme.Success or Theme.TextDim)
end)

tabMisc:Separador()
tabMisc:Titulo("Personagem")
tabMisc:Botao("Renascer", function()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:BreakJoints() end
end)

tabMisc:Botao("Destruir GUI", function()
    Janela.Gui:Destroy()
    UI:Notificar("GUI", "Menu fechado. Recarregue o script para reabrir.")
end)

-- ================================================================
-- ABA: CONFIG
-- ================================================================
local tabConfig = Janela:NovaAba("Config")

tabConfig:Titulo("Configuracoes")
local lblConfig = tabConfig:Label("Nenhuma configuracao carregada.")

tabConfig:Botao("Salvar Configuracao", function()
    local ok = BH:SalvarConfig()
    if ok then
        lblConfig:Set("Configuracao salva!")
        lblConfig:SetCor(Theme.Success)
        UI:Notificar("Config", "Salva com sucesso!")
    else
        lblConfig:Set("Erro ao salvar!")
        lblConfig:SetCor(Theme.Danger)
    end
end)

tabConfig:Botao("Carregar Configuracao", function()
    local ok = BH:CarregarConfig()
    if ok then
        togESP.Atualizar()
        togInvis.Atualizar()
        togNoclip.Atualizar()
        togAntiAFK.Atualizar()
        lblSpeed:Set("WalkSpeed: " .. BH.Speed)
        lblJump:Set("JumpPower: " .. BH.JumpPower)
        lblConfig:Set("Configuracao carregada!")
        lblConfig:SetCor(Theme.Success)
        UI:Notificar("Config", "Carregada com sucesso!")
    else
        lblConfig:Set("Nenhuma configuracao salva encontrada!")
        lblConfig:SetCor(Theme.Danger)
    end
end)

tabConfig:Botao("Resetar Configuracao", function()
    BH:SalvarConfig() -- salva estado atual como reset
    lblConfig:Set("Configuracao resetada!")
    lblConfig:SetCor(Theme.Warning)
end)

tabConfig:Separador()
tabConfig:Titulo("Sobre")
tabConfig:Label("Brookhaven RP Script v2.0")
tabConfig:Label("F1 / Insert = Abrir/Fechar menu")
tabConfig:Label("Criado para fins educacionais")

-- ================================================================
-- ATALHO DE TECLADO (F1 / INSERT)
-- ================================================================
Services.Input.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 or input.KeyCode == Enum.KeyCode.Insert then
        if Janela and Janela.Gui then
            Janela.Gui.Enabled = not Janela.Gui.Enabled
        end
    end
end)

-- ================================================================
-- NOTIFICACAO INICIAL
-- ================================================================
UI:Notificar("Brookhaven RP", "Script carregado! Pressione F1 para abrir o menu.", 8)
print("╔══════════════════════════════════════╗")
print("║  BROOKHAVEN RP Script carregado!     ║")
print("║  Pressione F1 ou Insert para o menu  ║")
print("╚══════════════════════════════════════╝")
