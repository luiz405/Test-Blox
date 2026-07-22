--[[
╔══════════════════════════════════════════════════════╗
║            BROOKHAVEN - KILL METHODS v1.0            ║
║                                                      ║
║  COMO USAR:                                          ║
║  1. Execute no executor com o jogo aberto            ║
║  2. Selecione um alvo na caixa de texto              ║
║  3. Escolha o metodo de kill                         ║
║  4. Pressione F1 para abrir/fechar o menu            ║
╚══════════════════════════════════════════════════════╝
--]]

print("KILL METHODS - Selecione um alvo e escolha como eliminar")

local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local LP = Players.LocalPlayer

local C = {
    bg=Color3.fromRGB(14,14,22); fg=Color3.fromRGB(26,26,38);
    az=Color3.fromRGB(0,160,255); az2=Color3.fromRGB(0,110,200);
    tx=Color3.fromRGB(220,220,235); tx2=Color3.fromRGB(130,130,155);
    ok=Color3.fromRGB(0,200,80); no=Color3.fromRGB(230,50,50);
    br=Color3.fromRGB(255,180,0);
}

local pai = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
if not pai then return end
local gui = Instance.new("ScreenGui")
gui.Name = "KILL_MENU"; gui.ResetOnSpawn = false; gui.Parent = pai; gui.DisplayOrder = 9999

local win = Instance.new("Frame")
win.Size = UDim2.new(0, 380, 0, 480); win.Position = UDim2.new(0.5, -190, 0.5, -240)
win.BackgroundColor3 = C.bg; win.BorderSizePixel = 0; win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 8)
local s = Instance.new("UIStroke", win); s.Color = C.fg; s.Thickness = 2

-- HEADER
local h = Instance.new("Frame")
h.Size = UDim2.new(1,0,0,38); h.BackgroundColor3 = C.fg; h.BorderSizePixel = 0; h.Parent = win
Instance.new("UICorner", h).CornerRadius = UDim.new(0, 8)
local hf = Instance.new("Frame")
hf.Size = UDim2.new(1,0,0,6); hf.Position = UDim2.new(0,0,1,-6); hf.BackgroundColor3 = C.fg; hf.BorderSizePixel = 0; hf.Parent = h
local t = Instance.new("TextLabel")
t.Size = UDim2.new(1,-50,1,0); t.Position = UDim2.new(0,10,0,0); t.BackgroundTransparency = 1
t.Text = "KILL METHODS"; t.TextColor3 = C.az; t.Font = Enum.Font.GothamBold; t.TextSize = 16; t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = h

local fechar = Instance.new("TextButton")
fechar.Size = UDim2.new(0,26,0,26); fechar.Position = UDim2.new(1,-32,0.5,-13)
fechar.BackgroundColor3 = C.bg; fechar.BorderSizePixel = 0; fechar.Text = "X"
fechar.TextColor3 = C.tx; fechar.Font = Enum.Font.GothamBold; fechar.TextSize = 15; fechar.Parent = h
Instance.new("UICorner", fechar).CornerRadius = UDim.new(0, 4)
fechar.MouseButton1Click:Connect(function() gui:Destroy() end)

-- SCROLL
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

-- VARS
local Alvo = nil
local function SelectAlvo(nome)
    for _, p in Players:GetPlayers() do
        if p.Name:lower():find(nome:lower()) or (p.DisplayName and p.DisplayName:lower():find(nome:lower())) then
            Alvo = p; return p
        end
    end; return nil
end

-- HELPERS
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
    l.Text = texto; l.TextColor3 = C.tx2; l.Font = Enum.Font.Gotham; l.TextSize = 12; l.Parent = scroll
    return l
end

local function Titulo(texto)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,0,24); l.BackgroundTransparency = 1
    l.Text = texto; l.TextColor3 = C.az; l.Font = Enum.Font.GothamBold; l.TextSize = 13; l.Parent = scroll
    return l
end

local function CaixaTexto(placeholder, fn)
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
-- METODOS DE KILL
-- ================================================================
local function GetHRP(p)
    return p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end
local function GetHum(p)
    return p.Character and p.Character:FindFirstChildOfClass("Humanoid")
end

-- 1. KILL POR QUEDA (teleporta alto e solta)
local function KillQueda()
    if not Alvo then return end
    local hrp = GetHRP(Alvo); local hum = GetHum(Alvo)
    if hrp and hum then
        hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 300, 0))
        hum.PlatformStand = true
        task.wait(0.1)
        hum.PlatformStand = false
    end
end

-- 2. KILL POR VEICULO (teleporta veiculo em cima)
local function KillVeiculo()
    if not Alvo then return end
    local hrp = GetHRP(Alvo)
    if not hrp then return end
    local maisPerto = nil; local menor = math.huge
    for _, v in workspace:GetDescendants() do
        if v:IsA("VehicleSeat") and v.Parent and v.Parent:FindFirstChild("HumanoidRootPart") then
            local d = (v.Parent:FindFirstChild("HumanoidRootPart").Position - hrp.Position).Magnitude
            if d < menor then menor = d; maisPerto = v.Parent end
        end
    end
    if maisPerto and maisPerto:FindFirstChild("HumanoidRootPart") then
        maisPerto:FindFirstChild("HumanoidRootPart").CFrame = hrp.CFrame + Vector3.new(0, 10, 0)
        maisPerto:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, -50, 0)
    end
end

-- 3. KILL POR EXPLOSAO
local function KillExplosao()
    if not Alvo then return end
    local hrp = GetHRP(Alvo)
    if hrp then
        local exp = Instance.new("Explosion")
        exp.Position = hrp.Position
        exp.BlastRadius = 10
        exp.BlastPressure = 10000
        exp.DestroyJointRadiusPercent = 1
        exp.Parent = workspace
    end
end

-- 4. KILL POR BREAK JOINTS (quebra ossos)
local function KillBreakJoints()
    if not Alvo then return end
    local hum = GetHum(Alvo)
    if hum then hum:BreakJoints() end
end

-- 5. KILL POR AFOGAMENTO (teleporta para baixo da agua)
local function KillAfogamento()
    if not Alvo then return end
    local hrp = GetHRP(Alvo)
    if hrp then
        hrp.CFrame = CFrame.new(hrp.Position.X, -50, hrp.Position.Z)
    end
end

-- 6. KILL POR FOGO (cria fire)
local function KillFogo()
    if not Alvo then return end
    local char = Alvo.Character
    if char then
        for _, v in char:GetDescendants() do
            if v:IsA("BasePart") then
                local f = Instance.new("Fire")
                f.Heat = 20; f.Size = 10; f.Parent = v
            end
        end
    end
end

-- 7. KILL POR SPAWN KILL (teleporta e fica em loop)
local KillLoop = false
local KillLoopCon = nil
local function KillLoopToggle()
    if not Alvo then return end
    KillLoop = not KillLoop
    if KillLoop then
        local hrp = GetHRP(Alvo)
        if hrp then
            local pos = hrp.Position
            KillLoopCon = Run.RenderStepped:Connect(function()
                if not KillLoop or not Alvo or not Alvo.Parent then
                    if KillLoopCon then KillLoopCon:Disconnect(); KillLoopCon = nil end; return
                end
                local a = GetHRP(Alvo)
                if a then
                    a.CFrame = CFrame.new(pos.X, pos.Y + 300, pos.Z)
                    local hum = GetHum(Alvo)
                    if hum then hum.PlatformStand = true; task.wait(0.05); hum.PlatformStand = false end
                end
            end)
        end
    else
        if KillLoopCon then KillLoopCon:Disconnect(); KillLoopCon = nil end
    end
end

-- 8. KILL POR FORÇA G (gravidade alta)
local GravLoop = false
local GravCon = nil
local function KillGravidade()
    if not Alvo then return end
    GravLoop = not GravLoop
    if GravLoop then
        local hrp = GetHRP(Alvo)
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0)
        end
        GravCon = Run.Stepped:Connect(function()
            if not GravLoop or not Alvo or not Alvo.Parent then
                if GravCon then GravCon:Disconnect(); GravCon = nil end; return
            end
            local hrp = GetHRP(Alvo)
            if hrp then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, hrp.Velocity.Y - 200, hrp.Velocity.Z)
            end
        end)
    else
        if GravCon then GravCon:Disconnect(); GravCon = nil end
    end
end

-- 9. KILL POR LIMBO
local function KillLimbo()
    if not Alvo then return end
    local hrp = GetHRP(Alvo)
    if hrp then
        hrp.CFrame = CFrame.new(0, -500, 0)
    end
end

-- 10. LIMPAR CORPO
local function KillLimpar()
    if not Alvo then return end
    local char = Alvo.Character
    if char then
        for _, v in char:GetDescendants() do
            if v:IsA("BasePart") then v:ClearAllChildren() end
        end
        char:ClearAllChildren()
    end
end

-- 11. KILL POR ATAQUE DE FERRAMENTA (spawna ferramenta e bate)
local function KillFerramenta()
    if not Alvo then return end
    local hrp = GetHRP(Alvo)
    if hrp then
        local tool = Instance.new("Tool")
        tool.Name = "KillTool"; tool.Parent = LP.Backpack
        task.wait(0.1)
        local handle = Instance.new("Part")
        handle.Name = "Handle"; handle.Size = Vector3.new(2,2,2)
        handle.Anchored = false; handle.Parent = tool
        local cPart = Instance.new("Part")
        cPart.Size = Vector3.new(2,2,2); cPart.Anchored = false
        cPart.CFrame = hrp.CFrame; cPart.Parent = workspace
        local weld = Instance.new("Weld")
        weld.Part0 = handle; weld.Part1 = cPart; weld.Parent = handle
        tool.Activated:Connect(function()
            local exp = Instance.new("Explosion")
            exp.Position = hrp.Position; exp.BlastPressure = 100000
            exp.DestroyJointRadiusPercent = 1; exp.Parent = workspace
        end)
        tool.Parent = LP.Character
        task.wait(0.5)
        tool:Activate()
    end
end

-- ================================================================
-- UI
-- ================================================================
Titulo("ALVO")
local lblAlvo = Label("Nenhum alvo selecionado")
CaixaTexto("Digite o nome do jogador...", function(txt)
    local p = SelectAlvo(txt)
    if p then lblAlvo.Text = "Alvo: " .. p.Name; lblAlvo.TextColor3 = C.ok
    else lblAlvo.Text = "Nao encontrado"; lblAlvo.TextColor3 = C.no end
end)

Titulo("METODOS DE KILL")
Btn("1. Queda (300m)", nil, function() KillQueda() end)
Btn("2. Veiculo (esmaga)", nil, function() KillVeiculo() end)
Btn("3. Explosao", nil, function() KillExplosao() end)
Btn("4. Break Joints", nil, function() KillBreakJoints() end)
Btn("5. Afogamento", nil, function() KillAfogamento() end)
Btn("6. Fogo", nil, function() KillFogo() end)
Btn("7. Loop Kill (ON/OFF)", C.br, function() KillLoopToggle() end)
Btn("8. Gravidade (ON/OFF)", C.br, function() KillGravidade() end)
Btn("9. Limbo", nil, function() KillLimbo() end)
Btn("10. Limpar corpo", nil, function() KillLimpar() end)
Btn("11. Ferramenta", nil, function() KillFerramenta() end)

Titulo("RESET")
Btn("Parar todos os loops", C.no, function()
    KillLoop = false; GravLoop = false
    if KillLoopCon then KillLoopCon:Disconnect(); KillLoopCon = nil end
    if GravCon then GravCon:Disconnect(); GravCon = nil end
end)

-- ARRASTAR
local d = false; local di = Vector2.new(); local dp = UDim2.new()
h.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true; di=Vector2.new(i.Position.X,i.Position.Y); dp=win.Position end end)
h.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)
gui.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = Vector2.new(i.Position.X,i.Position.Y)-di; win.Position = UDim2.new(dp.X.Scale,dp.X.Offset+delta.X,dp.Y.Scale,dp.Y.Offset+delta.Y) end end)

Input.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.F1 or i.KeyCode == Enum.KeyCode.Insert then
        gui.Enabled = not gui.Enabled
    end
end)

print("KILL METHODS - F1 abre/fecha")
