--[[
╔══════════════════════════════════════════════════════╗
║     BROOKHAVEN - PUXAR DA CADEIRA/VEICULO v1.0      ║
║                                                      ║
║  Puxe qualquer jogador de qualquer cadeira ou        ║
║  veiculo que estiver sentado!                        ║
║                                                      ║
║  F1 = Abrir/Fechar                                   ║
╚══════════════════════════════════════════════════════╝
--]]

print("PUXAR DA CADEIRA - Arranque qualquer um do sofa!")

local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local C = {
    bg=Color3.fromRGB(14,14,22); fg=Color3.fromRGB(26,26,38); fg2=Color3.fromRGB(36,36,50);
    az=Color3.fromRGB(100,200,255); az2=Color3.fromRGB(60,150,210);
    tx=Color3.fromRGB(220,220,235); tx2=Color3.fromRGB(130,130,155);
    ok=Color3.fromRGB(0,200,80); no=Color3.fromRGB(230,50,50); br=Color3.fromRGB(255,180,0);
}

local pai = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
if not pai then return end
local gui = Instance.new("ScreenGui")
gui.Name = "PUXAR_MENU"; gui.ResetOnSpawn = false; gui.Parent = pai; gui.DisplayOrder = 9999

local win = Instance.new("Frame")
win.Size = UDim2.new(0, 320, 0, 380); win.Position = UDim2.new(0.5, -160, 0.5, -190)
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
tit.Text = "PUXAR DA CADEIRA"; tit.TextColor3 = C.az; tit.Font = Enum.Font.GothamBold; tit.TextSize = 14; tit.TextXAlignment = Enum.TextXAlignment.Left; tit.Parent = h

local fechar = Instance.new("TextButton")
fechar.Size = UDim2.new(0,24,0,24); fechar.Position = UDim2.new(1,-30,0.5,-12)
fechar.BackgroundColor3 = C.bg; fechar.BorderSizePixel = 0; fechar.Text = "X"
fechar.TextColor3 = C.tx; fechar.Font = Enum.Font.GothamBold; fechar.TextSize = 14; fechar.Parent = h
Instance.new("UICorner", fechar).CornerRadius = UDim.new(0, 4)
fechar.MouseButton1Click:Connect(function() gui:Destroy() end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-36); scroll.Position = UDim2.new(0,0,0,36)
scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = C.az
scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.Parent = win
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,5); layout.Parent = scroll
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)
local pad = Instance.new("Frame")
pad.Size = UDim2.new(1,0,0,4); pad.BackgroundTransparency = 1; pad.Parent = scroll

local function Btn(texto, cor, fn)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-10,0,32); f.BackgroundColor3 = cor or C.fg; f.BorderSizePixel = 0; f.Parent = scroll
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
    l.Text = texto; l.TextColor3 = C.tx; l.Font = Enum.Font.GothamBold; l.TextSize = 12; l.Parent = f
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
    f.Size = UDim2.new(1,-10,0,30); f.BackgroundColor3 = C.fg; f.BorderSizePixel = 0; f.Parent = scroll
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-10,1,0); box.Position = UDim2.new(0,5,0,0)
    box.BackgroundTransparency = 1; box.TextColor3 = C.tx; box.PlaceholderColor3 = C.tx2
    box.PlaceholderText = placeholder; box.Font = Enum.Font.Gotham; box.TextSize = 12
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

-- 1. Puxar da cadeira (Hum.Sit = false)
local function PuxarCadeira(p)
    local hum = GetHum(p)
    if not hum then return false, "Sem humanoid" end
    if hum.Sit then
        hum.Sit = false
        local hrp = GetHRP(p)
        if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 3) end
        return true, "Puxado da cadeira!"
    end
    return false, "Nao esta sentado"
end

-- 2. Puxar de veiculo (VehicleSeat)
local function PuxarVeiculo(p)
    local hum = GetHum(p)
    if not hum then return false, "Sem humanoid" end
    for _, v in workspace:GetDescendants() do
        if v:IsA("VehicleSeat") and v.Occupant and v.Occupant.Parent == hum then
            v.Occupant = nil
            hum.Sit = false
            task.wait(0.1)
            local hrp = GetHRP(p)
            if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 3) end
            return true, "Puxado do veiculo!"
        end
    end
    return false, "Nao esta em veiculo"
end

-- 3. Puxar de qualquer coisa
local function PuxarTudo(p)
    local hum = GetHum(p)
    if not hum then return false, "Sem humanoid" end
    local puxou = false

    -- Tenta cadeira
    if hum.Sit then
        hum.Sit = false
        puxou = true
    end

    -- Tenta veiculo
    for _, v in workspace:GetDescendants() do
        if v:IsA("VehicleSeat") and v.Occupant and v.Occupant.Parent == hum then
            v.Occupant = nil
            puxou = true
        end
    end

    -- Tenta outros metodos (seats em geral)
    for _, v in workspace:GetDescendants() do
        if v:IsA("Seat") and v.Occupant and v.Occupant.Parent == hum then
            v.Occupant = nil
            puxou = true
        end
    end

    if puxou then
        task.wait(0.1)
        local hrp = GetHRP(p)
        if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 5) end
        return true, "Puxado com sucesso!"
    end

    return false, "Nao encontrou cadeira/veiculo"
end

-- 4. Puxar + Jogar (puxa e teleporta pra longe)
local function PuxarEAtirar(p)
    local ok, msg = PuxarTudo(p)
    if ok then
        task.wait(0.2)
        local hrp = GetHRP(p)
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 100)
            local hum = GetHum(p)
            if hum then hum.PlatformStand = true; task.wait(0.1); hum.PlatformStand = false end
        end
        return true, "Puxou e arremessou!"
    end
    return false, msg
end

-- 5. Puxar em loop (ficar puxando toda hora)
local LoopPuxar = false
local LoopCon = nil
local function IniciarLoopPuxar()
    if not Alvo then return end
    LoopPuxar = not LoopPuxar
    if LoopPuxar then
        LoopCon = Run.Stepped:Connect(function()
            if not LoopPuxar or not Alvo or not Alvo.Parent then
                if LoopCon then LoopCon:Disconnect(); LoopCon = nil end; return
            end
            local hum = GetHum(Alvo)
            if hum and hum.Sit then
                hum.Sit = false
            end
            for _, v in workspace:GetDescendants() do
                if v:IsA("VehicleSeat") and v.Occupant and v.Occupant.Parent == hum then
                    v.Occupant = nil
                end
            end
        end)
    else
        if LoopCon then LoopCon:Disconnect(); LoopCon = nil end
    end
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

Tit("ACOES")
local status = Label("Pronto")
Btn("Puxar da cadeira", nil, function()
    if not Alvo then status.Text = "Selecione um alvo!"; status.TextColor3 = C.no; return end
    local ok, msg = PuxarCadeira(Alvo)
    status.Text = msg; status.TextColor3 = ok and C.ok or C.no
end)
Btn("Puxar do veiculo", nil, function()
    if not Alvo then status.Text = "Selecione um alvo!"; status.TextColor3 = C.no; return end
    local ok, msg = PuxarVeiculo(Alvo)
    status.Text = msg; status.TextColor3 = ok and C.ok or C.no
end)
Btn("Puxar de TUDO (auto)", C.az, function()
    if not Alvo then status.Text = "Selecione um alvo!"; status.TextColor3 = C.no; return end
    local ok, msg = PuxarTudo(Alvo)
    status.Text = msg; status.TextColor3 = ok and C.ok or C.no
end)
Btn("Puxar e arremessar", C.br, function()
    if not Alvo then status.Text = "Selecione um alvo!"; status.TextColor3 = C.no; return end
    local ok, msg = PuxarEAtirar(Alvo)
    status.Text = msg; status.TextColor3 = ok and C.ok or C.no
end)
Btn("Loop Puxar (ON/OFF)", nil, function()
    if not Alvo then status.Text = "Selecione um alvo!"; status.TextColor3 = C.no; return end
    IniciarLoopPuxar()
    status.Text = LoopPuxar and "Loop puxar ATIVADO" or "Loop puxar DESATIVADO"
    status.TextColor3 = LoopPuxar and C.no or C.tx2
end)
Btn("PARAR loop", C.no, function()
    LoopPuxar = false
    if LoopCon then LoopCon:Disconnect(); LoopCon = nil end
    status.Text = "Loop parado"; status.TextColor3 = C.tx2
end)

Tit("RADIUS (puxar todos perto)")
Btn("Puxar todos num raio de 20m", nil, function()
    local myPos = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return end
    myPos = myPos.Position
    local count = 0
    for _, p in Players:GetPlayers() do
        if p ~= LP then
            local hrp = GetHRP(p)
            if hrp and (hrp.Position - myPos).Magnitude <= 20 then
                local ok = PuxarTudo(p)
                if ok then count = count + 1 end
            end
        end
    end
    status.Text = "Puxou " .. count .. " jogador(es)"
    status.TextColor3 = C.ok
end)

-- ARRASTAR
local d = false; local di = Vector2.new(); local dp = UDim2.new()
h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true; di=Vector2.new(i.Position.X,i.Position.Y); dp=win.Position end end)
h.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end end)
gui.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then
    local delta = Vector2.new(i.Position.X,i.Position.Y)-di; win.Position=UDim2.new(dp.X.Scale,dp.X.Offset+delta.X,dp.Y.Scale,dp.Y.Offset+delta.Y) end end)

Input.InputBegan:Connect(function(i) if i.KeyCode==Enum.KeyCode.F1 or i.KeyCode==Enum.KeyCode.Insert then gui.Enabled=not gui.Enabled end end)

print("PUXAR DA CADEIRA - F1 abre/fecha")
