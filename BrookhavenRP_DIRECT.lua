--[[
    BROOKHAVEN RP HUB - VERSÃƒO FINAL
    COLE DIRETO NO EXECUTOR (sem precisar de URL)
    Menu: F1 = Abrir/Fechar
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer

local function Notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = "Brookhaven Hub", Text = txt, Duration = 3 })
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

local noclipConn, flyConn, flyBody, flyGyro
local NoclipOn = false
local FlyOn = false
local AntiAFKOn = false
local EspOn = false

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Highlights"
ESPFolder.Parent = workspace

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrookhavenHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 520)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 140, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.3
Stroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.BorderSizePixel = 0
Title.Text = "BROOKHAVEN RP HUB"
Title.TextColor3 = Color3.fromRGB(0, 180, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -42, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Title
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -16, 0, 40)
TabFrame.Position = UDim2.new(0, 8, 0, 55)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -16, 1, -110)
ContentFrame.Position = UDim2.new(0, 8, 0, 100)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentFrame

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 8)
Padding.PaddingRight = UDim.new(0, 8)
Padding.Parent = ContentFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -25)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "F1 = Abrir/Fechar | Arrastar o menu"
StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 130)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

local TabButtons = {}
local TabFrames = {}

local function SwitchTab(name)
    for n, f in pairs(TabFrames) do
        f.Visible = (n == name)
    end
    for n, b in pairs(TabButtons) do
        if n == name then
            b.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
            b.TextColor3 = Color3.new(1, 1, 1)
        else
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            b.TextColor3 = Color3.fromRGB(160, 160, 180)
        end
    end
end

local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = Color3.fromRGB(0, 140, 255)
    frame.BorderSizePixel = 0
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.Parent = ContentFrame
    frame.Visible = false
    Instance.new("UIListLayout", frame).Padding = UDim.new(0, 6)
    Instance.new("UIPadding", frame).PaddingTop = UDim.new(0, 4)

    TabButtons[name] = btn
    TabFrames[name] = frame

    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)

    return frame
end

local function CreateToggle(parent, name, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(210, 210, 230)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 44, 0, 24)
    toggle.Position = UDim2.new(1, -54, 0.5, -12)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggle.Text = ""
    toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 12)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 3, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
    circle.Parent = toggle
    Instance.new("UICorner", circle).CornerRadius = UDim.new(0, 9)

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggle.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
            circle:TweenPosition(UDim2.new(1, -21, 0.5, -9), "Out", "Quad", 0.15, true)
            circle.BackgroundColor3 = Color3.new(1, 1, 1)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            circle:TweenPosition(UDim2.new(0, 3, 0.5, -9), "Out", "Quad", 0.15, true)
            circle.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
        end
        callback(state)
    end)
end

local function CreateButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
    end)
    btn.MouseButton1Click:Connect(callback)
end

local function CreateSlider(parent, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(210, 210, 230)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valLabel.Position = UDim2.new(0.7, 0, 0, 4)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(default)
    valLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
    valLabel.TextSize = 13
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 8)
    bar.Position = UDim2.new(0, 10, 0, 34)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 8)

    local dragging = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = bar.AbsolutePosition.X
            local size = bar.AbsoluteSize.X
            local pct = math.clamp((input.Position.X - pos) / size, 0, 1)
            local val = math.floor(min + (max - min) * pct)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, -8, 0.5, -8)
            valLabel.Text = tostring(val)
            callback(val)
        end
    end)
end

local function CreateDropdown(parent, name, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    frame.ClipsDescendants = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 38)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(210, 210, 230)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0.45, 0, 0, 28)
    dropBtn.Position = UDim2.new(0.53, 0, 0, 5)
    dropBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    dropBtn.Text = "Selecionar..."
    dropBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    dropBtn.TextSize = 12
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.Parent = frame
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -16, 0, 120)
    listFrame.Position = UDim2.new(0, 8, 0, 42)
    listFrame.BackgroundTransparency = 1
    listFrame.ScrollBarThickness = 3
    listFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 140, 255)
    listFrame.BorderSizePixel = 0
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.Visible = false
    listFrame.Parent = frame
    Instance.new("UIListLayout", listFrame).Padding = UDim.new(0, 2)

    local expanded = false
    dropBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        listFrame.Visible = expanded
        frame.Size = expanded and UDim2.new(1, 0, 0, 165) or UDim2.new(1, 0, 0, 38)
    end)

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 26)
        optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
        optBtn.TextSize = 12
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = listFrame
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        end)
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        end)
        optBtn.MouseButton1Click:Connect(function()
            dropBtn.Text = opt
            expanded = false
            listFrame.Visible = false
            frame.Size = UDim2.new(1, 0, 0, 38)
            callback(opt)
        end)
    end
end

local TabLocal = CreateTab("Local")
local TabESP = CreateTab("ESP")
local TabTools = CreateTab("Tools")
local TabMisc = CreateTab("Misc")

CreateToggle(TabLocal, "Noclip (Atravessar paredes)", function(v)
    NoclipOn = v
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if v then
        noclipConn = RunService.Stepped:Connect(function()
            local c = GetChar()
            if c then
                for _, p in pairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
        Notify("Noclip Ativado")
    else
        Notify("Noclip Desativado")
    end
end)

CreateToggle(TabLocal, "Fly (WASD + Space/Shift)", function(v)
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
                local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
                if flyBody and flyGyro then
                    flyBody.Velocity = dir.Unit * 80
                    flyGyro.CFrame = cam.CFrame
                end
            end)
            Notify("Fly Ativado")
        end
    else
        Notify("Fly Desativado")
    end
end)

CreateSlider(TabLocal, "Walk Speed", 16, 200, 16, function(v)
    local hum = GetHum()
    if hum then hum.WalkSpeed = v end
end)

CreateSlider(TabLocal, "Jump Power", 50, 200, 50, function(v)
    local hum = GetHum()
    if hum then hum.JumpPower = v end
end)

CreateButton(TabLocal, "Resetar Personagem", function()
    local c = GetChar()
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
    end
end)

CreateButton(TabLocal, "Copiar Server ID", function()
    setclipboard(game.JobId)
    Notify("Server ID copiado!")
end)

local function UpdateESP()
    for _, obj in pairs(ESPFolder:GetChildren()) do obj:Destroy() end
    if not EspOn then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            local c = plr.Character
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local b = Instance.new("BoxHandleAdornment")
                    b.Adornee = hrp
                    b.Size = Vector3.new(4, 5, 1)
                    b.Color3 = Color3.fromRGB(0, 160, 255)
                    b.Transparency = 0.5
                    b.AlwaysOnTop = true
                    b.Parent = ESPFolder
                    local bg = Instance.new("BillboardGui")
                    bg.Adornee = hrp
                    bg.Size = UDim2.new(0, 200, 0, 40)
                    bg.StudsOffset = Vector3.new(0, 3, 0)
                    bg.AlwaysOnTop = true
                    bg.Parent = ESPFolder
                    local tl = Instance.new("TextLabel", bg)
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Text = plr.Name
                    tl.TextColor3 = Color3.new(1, 1, 1)
                    tl.TextScaled = true
                    tl.Font = Enum.Font.GothamBold
                    tl.TextStrokeTransparency = 0.5
                end
            end
        end
    end
end

CreateToggle(TabESP, "ESP (Caixa + Nome)", function(v)
    EspOn = v
    if v then
        UpdateESP()
        Notify("ESP Ativado")
    else
        for _, obj in pairs(ESPFolder:GetChildren()) do obj:Destroy() end
        Notify("ESP Desativado")
    end
end)

CreateButton(TabESP, "Atualizar ESP", function()
    if EspOn then UpdateESP() end
end)

Players.PlayerAdded:Connect(function()
    if EspOn then task.wait(2); UpdateESP() end
end)
Players.PlayerRemoving:Connect(function()
    if EspOn then task.wait(1); UpdateESP() end
end)

CreateButton(TabTools, "Invisibility", function()
    local c = GetChar()
    if c then
        local torso = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
        if torso then
            torso.Transparency = 1
            if torso:FindFirstChild("roblox") then torso.roblox:Destroy() end
            local part = Instance.new("Part", torso)
            part.Name = "invis_part"
            part.Size = torso.Size
            part.Transparency = 1
            part.CanCollide = false
            local weld = Instance.new("Weld", part)
            weld.Part0 = torso
            weld.Part1 = part
            Notify("Invis Ativado")
        end
    end
end)

local playerNames = {}
local selectedPlayer = nil
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then table.insert(playerNames, p.Name) end
end

CreateDropdown(TabTools, "Jogador", playerNames, function(opt)
    selectedPlayer = opt
end)

CreateButton(TabTools, "Teleportar!", function()
    if selectedPlayer then
        local target = Players:FindFirstChild(selectedPlayer)
        if target and target.Character then
            local myHRP = GetHRP()
            local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if myHRP and tHRP then
                myHRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, -5)
                Notify("Teleportado para " .. selectedPlayer)
            end
        end
    else
        Notify("Selecione um jogador!")
    end
end)

CreateToggle(TabMisc, "Anti-AFK", function(v)
    AntiAFKOn = v
    if v then
        Notify("Anti-AFK Ativado")
        spawn(function()
            while AntiAFKOn do
                task.wait(30)
                pcall(function()
                    local VirtualUser = game:GetService("VirtualUser")
                    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(0.1)
                    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
            end
        end)
    else
        Notify("Anti-AFK Desativado")
    end
end)

CreateButton(TabMisc, "Server Hop", function()
    pcall(function()
        local http = game:GetService("HttpService")
        local t = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = http:JSONDecode(t)
        local servers = {}
        if data and data.data then
            for _, s in pairs(data.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    table.insert(servers, s.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LP)
        else
            Notify("Nenhum servidor encontrado")
        end
    end)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

SwitchTab("Local")
MainFrame.Visible = true
Notify("Menu carregado! F1 = Abrir/Fechar")
