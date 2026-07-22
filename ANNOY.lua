--[[
╔══════════════════════════════════════════════════════╗
║        BROOKHAVEN - ANNOY/HARASS TOOLBOX v1.0        ║
║                                                      ║
║  Todas as ferramentas para incomodar!                ║
║  - Empurrar, puxar, rodar, cegar, sacudir...        ║
║                                                      ║
║  F1 = Abrir/Fechar                                   ║
╚══════════════════════════════════════════════════════╝
--]]

print("ANNOY TOOLBOX - Ferramentas para incomodar!")

local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local LP = Players.LocalPlayer

local C = {
    bg=Color3.fromRGB(18,16,20); fg=Color3.fromRGB(30,28,34); fg2=Color3.fromRGB(40,38,46);
    az=Color3.fromRGB(255,120,80); az2=Color3.fromRGB(210,80,50);
    tx=Color3.fromRGB(220,220,235); tx2=Color3.fromRGB(130,130,155);
    ok=Color3.fromRGB(0,200,80); no=Color3.fromRGB(230,50,50); br=Color3.fromRGB(255,180,0);
    roxo=Color3.fromRGB(180,80,255); verde=Color3.fromRGB(0,255,150);
}

local pai = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
if not pai then return end
local gui = Instance.new("ScreenGui")
gui.Name = "ANNOY_MENU"; gui.ResetOnSpawn = false; gui.Parent = pai; gui.DisplayOrder = 9999

local win = Instance.new("Frame")
win.Size = UDim2.new(0, 360, 0, 520); win.Position = UDim2.new(0.5, -180, 0.5, -260)
win.BackgroundColor3 = C.bg; win.BorderSizePixel = 0; win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 8)
local ss = Instance.new("UIStroke", win); ss.Color = C.fg; ss.Thickness = 2

local h = Instance.new("Frame")
h.Size = UDim2.new(1,0,0,36); h.BackgroundColor3 = C.fg; h.BorderSizePixel = 0; h.Parent = win
Instance.new("UICorner", h).CornerRadius = UDim.new(0, 8)
local hf = Instance.new("Frame")
hf.Size = UDim2.new(1,0,0,6); hf.Position = UDim2.new(0,0,1,-6); hf.BackgroundColor3 = C.fg; hf.BorderSizePixel = 0; hf.Parent = h
local tit = Instance.new("TextLabel")
tit.Size = UDim2.new(1,-50,1,0); tit.Position = UDim2.new(0,10,0,0); tit.BackgroundTransparency = 1
tit.Text = "ANNOY TOOLBOX"; tit.TextColor3 = C.az; tit.Font = Enum.Font.GothamBold; tit.TextSize = 15; tit.TextXAlignment = Enum.TextXAlignment.Left; tit.Parent = h

local fechar = Instance.new("TextButton")
fechar.Size = UDim2.new(0,26,0,26); fechar.Position = UDim2.new(1,-32,0.5,-13)
fechar.BackgroundColor3 = C.bg; fechar.BorderSizePixel = 0; fechar.Text = "X"
fechar.TextColor3 = C.tx; fechar.Font = Enum.Font.GothamBold; fechar.TextSize = 15; fechar.Parent = h
Instance.new("UICorner", fechar).CornerRadius = UDim.new(0, 4)
fechar.MouseButton1Click:Connect(function() gui:Destroy() end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-36); scroll.Position = UDim2.new(0,0,0,36)
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
local function Label(texto)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,0,18); l.BackgroundTransparency = 1
    l.Text = texto; l.TextColor3 = C.tx2; l.Font = Enum.Font.Gotham; l.TextSize = 11; l.Parent = scroll; return l
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
-- LOGICA
-- ================================================================
local Alvo = nil
local function SelectAlvo(nome)
    for _, p in Players:GetPlayers() do
        if p.Name:lower():find(nome:lower()) or (p.DisplayName and p.DisplayName:lower():find(nome:lower())) then
            Alvo = p; return p
        end
    end; return nil
end
local function GetHRP(p) return p.Character and p.Character:FindFirstChild("HumanoidRootPart") end
local function GetHum(p) return p.Character and p.Character:FindFirstChildOfClass("Humanoid") end

-- Loops
local Loops = {}
local function PararLoop(nome)
    if Loops[nome] then Loops[nome]:Disconnect(); Loops[nome] = nil end
end
local function IniciarLoop(nome, fn)
    PararLoop(nome)
    Loops[nome] = Run.RenderStepped:Connect(function()
        if not Alvo or not Alvo.Parent then PararLoop(nome); return end
        fn()
    end)
end

-- ================================================================
-- 1. EMPURRAR
-- ================================================================
local function Empurrar(forca)
    if not Alvo then return end
    local hrp = GetHRP(Alvo)
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(forca, 5, 0) end
end

-- ================================================================
-- 2. RODAR (girar sem parar)
-- ================================================================
local function Rodar()
    if not Alvo then return end
    if Loops.Rodar then PararLoop("Rodar"); return end
    IniciarLoop("Rodar", function()
        local hrp = GetHRP(Alvo)
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0) end
    end)
end

-- ================================================================
-- 3. SACUDIR (teleporte rapido pra cima e baixo)
-- ================================================================
local function Sacudir()
    if not Alvo then return end
    if Loops.Sacudir then PararLoop("Sacudir"); return end
    local direcao = 1
    IniciarLoop("Sacudir", function()
        local hrp = GetHRP(Alvo)
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, direcao * 5, 0)
            direcao = direcao * -1
        end
    end)
end

-- ================================================================
-- 4. CEGAR (colocar parte branca na frente dos olhos)
-- ================================================================
local function Cegar()
    if not Alvo then return end
    local char = Alvo.Character
    if not char then return end
    local hrp = GetHRP(Alvo)
    if not hrp then return end

    local tela = Instance.new("Part")
    tela.Name = "TelaBranca"
    tela.Size = Vector3.new(10, 10, 0.1)
    tela.Anchored = false
    tela.CanCollide = false
    tela.Transparency = 0
    tela.Color = Color3.fromRGB(255, 255, 255)
    tela.BrickColor = BrickColor.new("White")
    tela.Material = Enum.Material.SmoothPlastic
    tela.Parent = workspace

    local weld = Instance.new("Weld")
    weld.Part0 = hrp
    weld.Part1 = tela
    weld.C0 = CFrame.new(0, 0.5, -2)
    weld.Parent = hrp

    task.delay(3, function() pcall(function() weld:Destroy(); tela:Destroy() end) end)
end

-- ================================================================
-- 5. FAKE ARREST (prende numa cela invisivel)
-- ================================================================
local function Prender()
    if not Alvo then return end
    local hrp = GetHRP(Alvo)
    if not hrp then return end

    -- Cria paredes em volta
    local pos = hrp.Position
    for x = -1, 1 do
        for z = -1, 1 do
            if x ~= 0 or z ~= 0 then
                local parede = Instance.new("Part")
                parede.Size = Vector3.new(1, 5, 1)
                parede.Position = pos + Vector3.new(x * 3, 2.5, z * 3)
                parede.Anchored = true
                parede.CanCollide = true
                parede.Color = Color3.fromRGB(50, 50, 150)
                parede.Material = Enum.Material.Metal
                parede.Parent = workspace
                task.delay(10, function() pcall(function() parede:Destroy() end) end)
            end
        end
    end
    -- Teto
    local teto = Instance.new("Part")
    teto.Size = Vector3.new(6, 0.5, 6)
    teto.Position = pos + Vector3.new(0, 5, 0)
    teto.Anchored = true; teto.CanCollide = true; teto.Parent = workspace
    teto.Color = Color3.fromRGB(50, 50, 150)
    task.delay(10, function() pcall(function() teto:Destroy() end) end)
end

-- ================================================================
-- 6. TROCAR DE LUGAR (swap)
-- ================================================================
local function TrocarLugar()
    if not Alvo then return end
    local myHrp = GetHRP(LP); local alvoHrp = GetHRP(Alvo)
    if myHrp and alvoHrp then
        local temp = myHrp.CFrame
        myHrp.CFrame = alvoHrp.CFrame
        alvoHrp.CFrame = temp
    end
end

-- ================================================================
-- 7. PUXAR PRA PERTO (grab)
-- ================================================================
local function PuxarPerto()
    if not Alvo then return end
    local myHrp = GetHRP(LP); local alvoHrp = GetHRP(Alvo)
    if myHrp and alvoHrp then
        alvoHrp.CFrame = myHrp.CFrame + Vector3.new(0, 0, -3)
    end
end

-- ================================================================
-- 8. JOGAR PRA CIMA (launch)
-- ================================================================
local function JogarCima()
    if not Alvo then return end
    local hrp = GetHRP(Alvo)
    if hrp then
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0)
        local hum = GetHum(Alvo)
        if hum then hum.PlatformStand = true; task.wait(0.1); hum.PlatformStand = false end
    end
end

-- ================================================================
-- 9. SEGUIR COLADO (follow exato)
-- ================================================================
local function SeguirColado()
    if not Alvo then return end
    if Loops.SeguirColado then PararLoop("SeguirColado"); return end
    IniciarLoop("SeguirColado", function()
        local myHrp = GetHRP(LP); local alvoHrp = GetHRP(Alvo)
        if myHrp and alvoHrp then
            myHrp.CFrame = alvoHrp.CFrame + Vector3.new(0, 0, 2)
        end
    end)
end

-- ================================================================
-- 10. INVERTER CONTROLES (confunde o alvo)
-- ================================================================
local InverterAtivo = false
local function InverterControles()
    if not Alvo then return end
    InverterAtivo = not InverterAtivo
    if InverterAtivo then
        IniciarLoop("Inverter", function()
            local hum = GetHum(Alvo)
            if hum then
                -- Inverte direcao periodica
                local hrp = GetHRP(Alvo)
                if hrp then
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(180), 0)
                end
            end
        end)
    else
        PararLoop("Inverter")
    end
end

-- ================================================================
-- 11. FAKE LAG (teleporta em circulo)
-- ================================================================
local function FakeLag()
    if not Alvo then return end
    if Loops.FakeLag then PararLoop("FakeLag"); return end
    local ang = 0
    IniciarLoop("FakeLag", function()
        local hrp = GetHRP(Alvo)
        if hrp then
            ang = ang + 5
            hrp.CFrame = hrp.CFrame + Vector3.new(math.sin(math.rad(ang)) * 3, 0, math.cos(math.rad(ang)) * 3)
        end
    end)
end

-- ================================================================
-- 12. PARAR TUDO
-- ================================================================
local function PararTudo()
    for nome in pairs(Loops) do PararLoop(nome) end
    InverterAtivo = false
end

-- ================================================================
-- UI
-- ================================================================
Tit("ALVO")
local lblAlvo = Label("Nenhum alvo")
Box("Nome do jogador...", function(txt)
    local p = SelectAlvo(txt)
    if p then lblAlvo.Text = "Alvo: " .. p.Name; lblAlvo.TextColor3 = C.ok
    else lblAlvo.Text = "Nao encontrado"; lblAlvo.TextColor3 = C.no end
end)

Tit("MOVIMENTACAO")
local status = Label("Pronto")
Btn("1. Empurrar (direita)", nil, function() if Alvo then Empurrar(20) end end)
Btn("2. Empurrar (esquerda)", nil, function() if Alvo then Empurrar(-20) end end)
Btn("3. Rodar (ON/OFF)", C.br, function() Rodar(); status.Text = Loops.Rodar and "Rodando!" or "Parou"; status.TextColor3 = Loops.Rodar and C.br or C.tx2 end)
Btn("4. Sacudir (ON/OFF)", C.br, function() Sacudir(); status.Text = Loops.Sacudir and "Sacudindo!" or "Parou"; status.TextColor3 = Loops.Sacudir and C.br or C.tx2 end)
Btn("5. Jogar pra cima", nil, function() JogarCima(); status.Text = "Jogou pra cima!"; status.TextColor3 = C.ok end)
Btn("6. Puxar pra perto", nil, function() PuxarPerto(); status.Text = "Puxou pra perto!"; status.TextColor3 = C.ok end)
Btn("7. Trocar de lugar (swap)", C.roxo, function() TrocarLugar(); status.Text = "Trocou de lugar!"; status.TextColor3 = C.roxo end)

Tit("PERTURBACAO")
Btn("8. Cegar (flash)", nil, function() Cegar(); status.Text = "Cegou o alvo!"; status.TextColor3 = C.no end)
Btn("9. Prender (celula)", nil, function() Prender(); status.Text = "Prensou o alvo!"; status.TextColor3 = C.no end)
Btn("10. Fake Lag (ON/OFF)", C.br, function() FakeLag(); status.Text = Loops.FakeLag and "Fake Lag!" or "Parou"; status.TextColor3 = Loops.FakeLag and C.br or C.tx2 end)
Btn("11. Inverter controles (ON/OFF)", C.br, function() InverterControles(); status.Text = InverterAtivo and "Invertendo!" or "Parou"; status.TextColor3 = InverterAtivo and C.br or C.tx2 end)
Btn("12. Seguir colado (ON/OFF)", C.verde, function() SeguirColado(); status.Text = Loops.SeguirColado and "Seguindo!" or "Parou"; status.TextColor3 = Loops.SeguirColado and C.verde or C.tx2 end)

Tit("GERAL")
Btn("PARAR TUDO", C.no, function() PararTudo(); status.Text = "Tudo parado"; status.TextColor3 = C.tx2 end)

-- STATUS GERAL
local statusExtra = Label("F1 = Abrir/Fechar | Selecione um alvo primeiro")

-- ARRASTAR
local d = false; local di = Vector2.new(); local dp = UDim2.new()
h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true; di=Vector2.new(i.Position.X,i.Position.Y); dp=win.Position end end)
h.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end end)
gui.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then
    local delta = Vector2.new(i.Position.X,i.Position.Y)-di; win.Position=UDim2.new(dp.X.Scale,dp.X.Offset+delta.X,dp.Y.Scale,dp.Y.Offset+delta.Y) end end)

Input.InputBegan:Connect(function(i) if i.KeyCode==Enum.KeyCode.F1 or i.KeyCode==Enum.KeyCode.Insert then gui.Enabled=not gui.Enabled end end)

print("ANNOY TOOLBOX - F1 abre/fecha")
