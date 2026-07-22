--[[
╔══════════════════════════════════════════════════════╗
║        BROOKHAVEN - SOUND SPAMMER v1.0              ║
║                                                      ║
║  Toque sons altos no ouvido dos outros!              ║
║  Pode prender o som no alvo ou no mundo.             ║
║                                                      ║
║  F1 = Abrir/Fechar                                   ║
╚══════════════════════════════════════════════════════╝
--]]

print("SOUND SPAMMER - Sons altos em loop!")

local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- IDs de sons (altos e irritantes)
local SONS_PRE = {
    {"🔊 Apito (agudo)", 9120238690},
    {"🔊 Alarme", 142276783},
    {"🔊 Megafone", 277432638},
    {"🔊 Buzina", 154613110},
    {"🔊 Sirene Policia", 4482320917},
    {"🔊 Explosao", 6569044134},
    {"🔊 Grito", 185224200},
    {"🔊 Risada Malefica", 4821260278},
    {"🔊 Batida", 184078413},
    {"🔊 Campainha", 4701487939},
    {"🔊 Chao de Fabrica", 9080255893},
    {"🔊 Sirene Bombeiro", 4886024332},
    {"🔊 Heavy Bass", 5869410313},
    {"🔊 Earrape", 133138384},
    {"🔊 Vibracao", 6332522236},
    {"🔊 Telefone", 159391316},
    {"🔊 Despertador", 4452393102},
    {"🔊 Buzina Caminhao", 269988817},
}

local C = {
    bg=Color3.fromRGB(10,10,18); fg=Color3.fromRGB(22,22,34);
    az=Color3.fromRGB(255,100,100); az2=Color3.fromRGB(200,60,60);
    tx=Color3.fromRGB(220,220,235); tx2=Color3.fromRGB(130,130,155);
    ok=Color3.fromRGB(0,200,80); no=Color3.fromRGB(230,50,50);
    br=Color3.fromRGB(255,180,0); roxo=Color3.fromRGB(180,80,255);
}

local pai = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
if not pai then return end
local gui = Instance.new("ScreenGui")
gui.Name = "SOUND_SPAM"; gui.ResetOnSpawn = false; gui.Parent = pai; gui.DisplayOrder = 9999

local win = Instance.new("Frame")
win.Size = UDim2.new(0, 400, 0, 500); win.Position = UDim2.new(0.5, -200, 0.5, -250)
win.BackgroundColor3 = C.bg; win.BorderSizePixel = 0; win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 8)
local ss = Instance.new("UIStroke", win); ss.Color = C.fg; ss.Thickness = 2

local h = Instance.new("Frame")
h.Size = UDim2.new(1,0,0,38); h.BackgroundColor3 = C.fg; h.BorderSizePixel = 0; h.Parent = win
Instance.new("UICorner", h).CornerRadius = UDim.new(0, 8)
local hf = Instance.new("Frame")
hf.Size = UDim2.new(1,0,0,6); hf.Position = UDim2.new(0,0,1,-6); hf.BackgroundColor3 = C.fg; hf.BorderSizePixel = 0; hf.Parent = h
local tit = Instance.new("TextLabel")
tit.Size = UDim2.new(1,-50,1,0); tit.Position = UDim2.new(0,10,0,0); tit.BackgroundTransparency = 1
tit.Text = "SOUND SPAMMER"; tit.TextColor3 = C.az; tit.Font = Enum.Font.GothamBold; tit.TextSize = 15; tit.TextXAlignment = Enum.TextXAlignment.Left; tit.Parent = h

local fechar = Instance.new("TextButton")
fechar.Size = UDim2.new(0,26,0,26); fechar.Position = UDim2.new(1,-32,0.5,-13)
fechar.BackgroundColor3 = C.bg; fechar.BorderSizePixel = 0; fechar.Text = "X"
fechar.TextColor3 = C.tx; fechar.Font = Enum.Font.GothamBold; fechar.TextSize = 15; fechar.Parent = h
Instance.new("UICorner", fechar).CornerRadius = UDim.new(0, 4)
fechar.MouseButton1Click:Connect(function() gui:Destroy() end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-38); scroll.Position = UDim2.new(0,0,0,38)
scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = C.az
scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.Parent = win
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,4); layout.Parent = scroll
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)
local pad = Instance.new("Frame")
pad.Size = UDim2.new(1,0,0,4); pad.BackgroundTransparency = 1; pad.Parent = scroll

local function Btn(texto, cor, fn)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-10,0,30); f.BackgroundColor3 = cor or C.fg; f.BorderSizePixel = 0; f.Parent = scroll
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
    l.Text = texto; l.TextColor3 = C.tx; l.Font = Enum.Font.GothamBold; l.TextSize = 11; l.Parent = f
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,1,0); b.BackgroundTransparency = 1; b.Text = ""; b.Parent = f
    b.MouseButton1Click:Connect(fn)
    b.MouseEnter:Connect(function() f.BackgroundColor3 = C.az2 end)
    b.MouseLeave:Connect(function() f.BackgroundColor3 = cor or C.fg end)
    return f
end
local function Label(texto, cor)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,0,18); l.BackgroundTransparency = 1
    l.Text = texto; l.TextColor3 = cor or C.tx2; l.Font = Enum.Font.Gotham; l.TextSize = 11; l.Parent = scroll; return l
end
local function Tit(texto)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,0,20); l.BackgroundTransparency = 1
    l.Text = texto; l.TextColor3 = C.az; l.Font = Enum.Font.GothamBold; l.TextSize = 12; l.Parent = scroll; return l
end
local function Box(placeholder, fn)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-10,0,28); f.BackgroundColor3 = C.fg; f.BorderSizePixel = 0; f.Parent = scroll
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-10,1,0); box.Position = UDim2.new(0,5,0,0)
    box.BackgroundTransparency = 1; box.TextColor3 = C.tx; box.PlaceholderColor3 = C.tx2
    box.PlaceholderText = placeholder; box.Font = Enum.Font.Gotham; box.TextSize = 11
    box.ClearTextOnFocus = false; box.Parent = f
    box.FocusLost:Connect(function(enter) if enter and fn then fn(box.Text) end end)
    return box
end

-- ================================================================
-- SOUND SYSTEM
-- ================================================================
local SonsAtivos = {}
local LoopGeral = false
local LoopCon = nil
local Volume = 10
local Alvo = nil

local function GetHRP(p) return p.Character and p.Character:FindFirstChild("HumanoidRootPart") end
local function SelectAlvo(nome)
    for _, p in Players:GetPlayers() do
        if p.Name:lower():find(nome:lower()) or (p.DisplayName and p.DisplayName:lower():find(nome:lower())) then
            Alvo = p; return p
        end
    end; return nil
end

local function TocarSom(id, volume, parente)
    volume = volume or Volume
    parente = parente or workspace

    local som = Instance.new("Sound")
    som.SoundId = "rbxassetid://" .. tostring(id)
    som.Volume = math.clamp(volume, 0, 10)
    som.Looped = false
    som.PlayOnRemove = false
    som.Parent = parente

    -- Aplica efeitos para distorcer
    local eq = Instance.new("SoundEqualizerEffect")
    eq.HighGain = 20
    eq.LowGain = 20
    eq.MidGain = 20
    eq.Parent = som

    local dist = Instance.new("DistortionSoundEffect")
    dist.Level = 1
    dist.Parent = som

    som:Play()

    -- Auto-destroy
    task.delay(som.TimeLength or 5, function()
        pcall(function() som:Destroy() end)
    end)

    return som
end

local function PararTodosSons()
    for _, s in ipairs(SonsAtivos) do
        pcall(function() s:Stop(); s:Destroy() end)
    end
    SonsAtivos = {}
end

local function TocarSomNoAlvo(id)
    if not Alvo then return end
    local hrp = GetHRP(Alvo)
    if not hrp then return end

    local som = TocarSom(id, Volume, hrp)
    table.insert(SonsAtivos, som)
end

local function TocarNoMundo(id)
    local som = TocarSom(id, Volume, workspace)
    table.insert(SonsAtivos, som)
end

-- Loop de som
local function IniciarLoop(id, noAlvo, intervalo)
    intervalo = intervalo or 0.3
    PararTodosSons()
    LoopGeral = true

    LoopCon = Run.RenderStepped:Connect(function()
        if not LoopGeral then
            if LoopCon then LoopCon:Disconnect(); LoopCon = nil end
            return
        end

        if noAlvo and Alvo then
            TocarSomNoAlvo(id)
        else
            TocarNoMundo(id)
        end
        task.wait(intervalo)
    end)
end

local function PararLoop()
    LoopGeral = false
    if LoopCon then LoopCon:Disconnect(); LoopCon = nil end
    PararTodosSons()
end

-- ================================================================
-- UI
-- ================================================================
Tit("ALVO (opcional)")
local lblAlvo = Label("Nenhum (som no mundo)")
Box("Nome do jogador...", function(txt)
    local p = SelectAlvo(txt)
    if p then lblAlvo.Text = "Alvo: " .. p.Name; lblAlvo.TextColor3 = C.ok
    else lblAlvo.Text = "Nenhum (som no mundo)"; lblAlvo.TextColor3 = C.tx2 end
end)

Tit("CONTROLES")
local statusSom = Label("Status: Parado")
local somAtual = Label("Som: nenhum")

Btn("PARAR TUDO", C.no, function()
    PararLoop()
    statusSom.Text = "Status: Parado"; statusSom.TextColor3 = C.tx2
end)

Tit("VOLUME: " .. Volume)
Btn("+ Aumentar volume", nil, function()
    Volume = math.min(Volume + 1, 10)
    statusSom.Text = "Volume: " .. Volume; statusSom.TextColor3 = C.br
end)
Btn("- Diminuir volume", nil, function()
    Volume = math.max(Volume - 1, 1)
    statusSom.Text = "Volume: " .. Volume; statusSom.TextColor3 = C.br
end)

Tit("SONS PRE-DEFINIDOS")
for _, somInfo in ipairs(SONS_PRE) do
    Btn(somInfo[1], nil, function()
        local id = somInfo[2]
        somAtual.Text = "Som: " .. somInfo[1]
        TocarNoMundo(id)
        statusSom.Text = "Tocando: " .. somInfo[1]; statusSom.TextColor3 = C.ok
    end)
end

Tit("LOOP NO ALVO")
for _, somInfo in ipairs(SONS_PRE) do
    Btn(somInfo[1] .. " (loop no alvo)", C.br, function()
        if not Alvo then
            statusSom.Text = "Selecione um alvo primeiro!"; statusSom.TextColor3 = C.no
            return
        end
        somAtual.Text = "Som: " .. somInfo[1] .. " [LOOP NO ALVO]"
        IniciarLoop(somInfo[2], true, 0.2)
        statusSom.Text = "LOOP no alvo: " .. somInfo[1]; statusSom.TextColor3 = C.no
    end)
end

Tit("LOOP NO MUNDO")
for _, somInfo in ipairs(SONS_PRE) do
    Btn(somInfo[1] .. " (loop mundo)", nil, function()
        somAtual.Text = "Som: " .. somInfo[1] .. " [LOOP]"
        IniciarLoop(somInfo[2], false, 0.3)
        statusSom.Text = "LOOP: " .. somInfo[1]; statusSom.TextColor3 = C.ok
    end)
end

Tit("SOM PERSONALIZADO")
Box("ID do som (ex: 9120238690)", function(txt)
    local id = tonumber(txt:match("%d+"))
    if id then
        TocarNoMundo(id)
        somAtual.Text = "Som custom: " .. id
        statusSom.Text = "Tocando som custom"; statusSom.TextColor3 = C.roxo
    end
end)
local idLoopCustom = nil
Box("ID para loop custom", function(txt)
    idLoopCustom = tonumber(txt:match("%d+"))
    if idLoopCustom then
        statusSom.Text = "ID custom salvo: " .. idLoopCustom; statusSom.TextColor3 = C.roxo
    end
end)
Btn("Loop com ID custom", C.roxo, function()
    if idLoopCustom then
        somAtual.Text = "Som custom: " .. idLoopCustom .. " [LOOP]"
        IniciarLoop(idLoopCustom, false, 0.3)
        statusSom.Text = "LOOP custom"; statusSom.TextColor3 = C.roxo
    end
end)
Btn("Loop no alvo com ID custom", C.roxo, function()
    if not Alvo then
        statusSom.Text = "Selecione um alvo!"; statusSom.TextColor3 = C.no
        return
    end
    if idLoopCustom then
        somAtual.Text = "Som custom: " .. idLoopCustom .. " [LOOP NO ALVO]"
        IniciarLoop(idLoopCustom, true, 0.2)
        statusSom.Text = "LOOP no alvo custom"; statusSom.TextColor3 = C.roxo
    end
end)

-- ARRASTAR
local d = false; local di = Vector2.new(); local dp = UDim2.new()
h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true; di=Vector2.new(i.Position.X,i.Position.Y); dp=win.Position end end)
h.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end end)
gui.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then
    local delta = Vector2.new(i.Position.X,i.Position.Y)-di; win.Position=UDim2.new(dp.X.Scale,dp.X.Offset+delta.X,dp.Y.Scale,dp.Y.Offset+delta.Y) end end)

Input.InputBegan:Connect(function(i) if i.KeyCode==Enum.KeyCode.F1 or i.KeyCode==Enum.KeyCode.Insert then gui.Enabled=not gui.Enabled end end)

print("SOUND SPAMMER - F1 abre/fecha")
