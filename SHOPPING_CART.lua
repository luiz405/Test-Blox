--[[
╔══════════════════════════════════════════════════════╗
║        BROOKHAVEN - SHOPPING CART KIDNAP v1.0        ║
║                                                      ║
║  O carrinho de compras persegue o alvo, captura,     ║
║  e leva ao limbo!                                    ║
║                                                      ║
║  F1 = Abrir/Fechar                                   ║
╚══════════════════════════════════════════════════════╝
--]]

print("SHOPPING CART KIDNAP - Carrinho assassino!")

local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local LP = Players.LocalPlayer

local C = {
    bg=Color3.fromRGB(14,14,22); fg=Color3.fromRGB(26,26,38);
    az=Color3.fromRGB(0,200,255); az2=Color3.fromRGB(0,140,200);
    tx=Color3.fromRGB(220,220,235); tx2=Color3.fromRGB(130,130,155);
    ok=Color3.fromRGB(0,200,80); no=Color3.fromRGB(230,50,50); br=Color3.fromRGB(255,180,0);
}

local pai = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
if not pai then return end
local gui = Instance.new("ScreenGui")
gui.Name = "CART_KIDNAP"; gui.ResetOnSpawn = false; gui.Parent = pai; gui.DisplayOrder = 9999

local win = Instance.new("Frame")
win.Size = UDim2.new(0, 350, 0, 420); win.Position = UDim2.new(0.5, -175, 0.5, -210)
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
tit.Text = "CARRINHO KIDNAP"; tit.TextColor3 = C.az; tit.Font = Enum.Font.GothamBold; tit.TextSize = 15; tit.TextXAlignment = Enum.TextXAlignment.Left; tit.Parent = h

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
layout.Padding = UDim.new(0,5); layout.Parent = scroll
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)
local pad = Instance.new("Frame")
pad.Size = UDim2.new(1,0,0,4); pad.BackgroundTransparency = 1; pad.Parent = scroll

-- Helpers
local function Btn(texto, cor, fn)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-10,0,34); f.BackgroundColor3 = cor or C.fg; f.BorderSizePixel = 0; f.Parent = scroll
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
    l.Size = UDim2.new(1,-10,0,20); l.BackgroundTransparency = 1
    l.Text = texto; l.TextColor3 = C.tx2; l.Font = Enum.Font.Gotham; l.TextSize = 12; l.Parent = scroll; return l
end
local function Tit(texto)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,0,22); l.BackgroundTransparency = 1
    l.Text = texto; l.TextColor3 = C.az; l.Font = Enum.Font.GothamBold; l.TextSize = 13; l.Parent = scroll; return l
end
local function Box(placeholder, fn)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-10,0,32); f.BackgroundColor3 = C.fg; f.BorderSizePixel = 0; f.Parent = scroll
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
local Perseguindo = false
local PerseguirCon = nil
local Carrinho = nil

local function GetHRP(p) return p.Character and p.Character:FindFirstChild("HumanoidRootPart") end
local function GetHum(p) return p.Character and p.Character:FindFirstChildOfClass("Humanoid") end

local function SelectAlvo(nome)
    for _, p in Players:GetPlayers() do
        if p.Name:lower():find(nome:lower()) or (p.DisplayName and p.DisplayName:lower():find(nome:lower())) then
            Alvo = p; return p
        end
    end; return nil
end

-- Puxar da cadeira/veiculo
local function PuxarDaCadeira(p)
    local char = p.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    -- Verifica se esta sentado
    if hum.Sit then
        hum.Sit = false
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 2)
        task.wait(0.2)
        return true
    end
    -- Verifica se esta em um VehicleSeat
    for _, v in workspace:GetDescendants() do
        if v:IsA("VehicleSeat") and v.Occupant and v.Occupant.Parent == hum then
            v.Occupant = nil
            task.wait(0.1)
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 2)
            return true
        end
    end
    return false
end

-- Encontrar carrinho
local function AcharCarrinho()
    for _, v in workspace:GetDescendants() do
        if v:IsA("Model") and (v.Name:lower():find("cart") or v.Name:lower():find("carrinho") or v.Name:lower():find("trolley") or v.Name:lower():find("shopping")) then
            local hrp = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
            if hrp then return v, hrp end
        end
    end
    -- Fallback: procura qualquer veiculo pequeno
    for _, v in workspace:GetDescendants() do
        if v:IsA("VehicleSeat") and v.Parent then
            local hrp = v.Parent:FindFirstChild("HumanoidRootPart") or v.Parent:FindFirstChildWhichIsA("BasePart")
            if hrp and hrp.Size.Magnitude < 20 then -- veiculo pequeno
                return v.Parent, hrp
            end
        end
    end
    return nil, nil
end

-- Capturar no carrinho
local function CapturarNoCarrinho()
    if not Alvo then return end
    local alvoChar = Alvo.Character
    local alvoHRP = GetHRP(Alvo)
    if not alvoChar or not alvoHRP then
        UI:Notify("Erro", "Alvo sem personagem")
        return
    end

    local carrinho, carrinhoHRP = AcharCarrinho()
    if not carrinho or not carrinhoHRP then
        -- Spawna um carrinho
        carrinhoHRP = Instance.new("Part")
        carrinhoHRP.Name = "CarrinhoHRP"
        carrinhoHRP.Size = Vector3.new(3, 2, 4)
        carrinhoHRP.Anchored = false
        carrinhoHRP.CFrame = GetHRP(LP).CFrame + Vector3.new(0, 0, -5)
        carrinhoHRP.Color = Color3.fromRGB(200, 100, 50)
        carrinhoHRP.Material = Enum.Material.Plastic
        carrinhoHRP.Parent = workspace

        local seat = Instance.new("VehicleSeat")
        seat.Parent = carrinhoHRP
        seat.CFrame = CFrame.new(0, 0.5, 0)

        carrinho = carrinhoHRP
    end

    local charDoAlvo = Alvo.Character
    if not charDoAlvo then return end

    -- Puxa da cadeira se estiver sentado
    PuxarDaCadeira(Alvo)

    task.wait(0.3)

    -- Prende o alvo no carrinho (Weld)
    local alvoHRP2 = GetHRP(Alvo)
    if not alvoHRP2 then return end

    local welder = Instance.new("Weld")
    welder.Part0 = carrinhoHRP
    welder.Part1 = alvoHRP2
    welder.C0 = CFrame.new(0, 1, 0)
    welder.C1 = CFrame.new(0, 0, 0)
    welder.Parent = carrinhoHRP

    -- Leva ao limbo
    for i = 1, 30 do
        local ahrp = GetHRP(Alvo)
        if ahrp then
            carrinhoHRP.CFrame = carrinhoHRP.CFrame + Vector3.new(0, 0, -3)
            ahrp.CFrame = carrinhoHRP.CFrame
        end
        task.wait(0.05)
    end

    -- Joga no limbo
    task.wait(0.3)
    carrinhoHRP.CFrame = CFrame.new(0, -500, 0)
    if alvoHRP2 then
        alvoHRP2.CFrame = CFrame.new(0, -500, 0)
    end

    -- Solta
    task.wait(0.5)
    welder:Destroy()
end

-- Perseguir com carrinho
local function IniciarPerseguicao()
    if not Alvo then
        return
    end
    Perseguindo = true

    local carrinho, carrinhoHRP = AcharCarrinho()
    if not carrinho or not carrinhoHRP then
        return
    end
    Carrinho = carrinho

    -- Puxa jogador pro carrinho
    local myHRP = GetHRP(LP)
    if myHRP then
        myHRP.CFrame = carrinhoHRP.CFrame + Vector3.new(0, 2, 2)
    end

    if PerseguirCon then PerseguirCon:Disconnect() end

    PerseguirCon = Run.RenderStepped:Connect(function()
        if not Perseguindo or not Alvo or not Alvo.Parent then
            Perseguindo = false
            if PerseguirCon then PerseguirCon:Disconnect(); PerseguirCon = nil end
            return
        end

        -- Re-encontra carrinho se perdeu
        if not Carrinho or not Carrinho.Parent then
            local c, ch = AcharCarrinho()
            Carrinho = c
            carrinhoHRP = ch
            if not Carrinho then
                Perseguindo = false; return
            end
        end

        -- Atualiza referencia do HRP
        local chrp = Carrinho:FindFirstChild("HumanoidRootPart") or Carrinho:FindFirstChildWhichIsA("BasePart")
        if not chrp then Perseguindo = false; return end
        carrinhoHRP = chrp

        local alvoHRP = GetHRP(Alvo)
        if not alvoHRP then return end

        -- Puxa da cadeira se sentado
        local hum = GetHum(Alvo)
        if hum and hum.Sit then
            PuxarDaCadeira(Alvo)
            task.wait(0.1)
        end

        -- Move carrinho ate o alvo
        local dir = (alvoHRP.Position - carrinhoHRP.Position).Unit
        local dist = (alvoHRP.Position - carrinhoHRP.Position).Magnitude
        carrinhoHRP.CFrame = CFrame.lookAt(carrinhoHRP.Position, alvoHRP.Position) * CFrame.new(0, 0, math.min(2, dist))
        carrinhoHRP.CFrame = carrinhoHRP.CFrame + dir * math.min(3, dist)

        -- Move o player junto
        local myHrp = GetHRP(LP)
        if myHrp then
            myHrp.CFrame = carrinhoHRP.CFrame + Vector3.new(0, 2, 0)
        end

        -- Capturou?
        if dist < 5 then
            Perseguindo = false
            if PerseguirCon then PerseguirCon:Disconnect(); PerseguirCon = nil end
            CapturarNoCarrinho()
        end
    end)
end

local function PararPerseguicao()
    Perseguindo = false
    if PerseguirCon then PerseguirCon:Disconnect(); PerseguirCon = nil end
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

Tit("CONTROLES")
Btn("Puxar da cadeira/veiculo", nil, function()
    if Alvo then
        local r = PuxarDaCadeira(Alvo)
        if r then UI:Notify("Puxado", "Alvo puxado da cadeira!") end
    end
end)

Btn("INICIAR PERSEGUICAO", C.br, function()
    if not Alvo then
        return
    end
    IniciarPerseguicao()
end)

Btn("PARAR PERSEGUICAO", C.no, function()
    PararPerseguicao()
end)

Tit("CAPTURA")
Btn("Capturar agora (teleporta)", nil, function()
    if not Alvo then return end
    local ahrp = GetHRP(Alvo)
    if ahrp then
        PuxarDaCadeira(Alvo)
        task.wait(0.2)
        ahrp.CFrame = CFrame.new(0, -500, 0)
    end
end)

Btn("Levar ao limbo", nil, function()
    if not Alvo then return end
    local ahrp = GetHRP(Alvo)
    if ahrp then ahrp.CFrame = CFrame.new(0, -500, 0) end
end)

Tit("CARRINHO")
Btn("Achar carrinho", nil, function()
    local c, hrp = AcharCarrinho()
    if c then
        local my = GetHRP(LP)
        if my then my.CFrame = hrp.CFrame + Vector3.new(0, 2, 2) end
    end
end)

-- ARRASTAR
local d = false; local di = Vector2.new(); local dp = UDim2.new()
h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true; di=Vector2.new(i.Position.X,i.Position.Y); dp=win.Position end end)
h.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end end)
gui.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then
    local delta = Vector2.new(i.Position.X,i.Position.Y)-di; win.Position=UDim2.new(dp.X.Scale,dp.X.Offset+delta.X,dp.Y.Scale,dp.Y.Offset+delta.Y) end end)

Input.InputBegan:Connect(function(i) if i.KeyCode==Enum.KeyCode.F1 or i.KeyCode==Enum.KeyCode.Insert then gui.Enabled=not gui.Enabled end end)

print("CARRINHO KIDNAP - F1 abre/fecha")
