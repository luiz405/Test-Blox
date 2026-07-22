local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "Brookhaven RP Hub",
    LoadingTitle = "Brookhaven RP Hub",
    LoadingSubtitle = "Carregando...",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Highlights"
ESPFolder.Parent = workspace

local noclipConn, flyConn, flyBody, flyGyro
local ESPOn = false
local NoclipOn = false
local FlyOn = false
local AntiAFKOn = false
local EspOn = false
local InvisOn = false

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

-- ======================== TAB: LOCAL ========================
local LocalTab = Window:CreateTab("Local", 4483362458)

LocalTab:CreateToggle({
    Name = "Noclip (Atravessar paredes)",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(v)
        NoclipOn = v
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        if v then
            noclipConn = RunService.Stepped:Connect(function()
                local c = GetChar()
                if c then
                    for _, p in pairs(c:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                end
            end)
            Notify("Noclip Ativado")
        else
            Notify("Noclip Desativado")
        end
    end,
})

LocalTab:CreateToggle({
    Name = "Fly (Voar)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(v)
        FlyOn = v
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if flyBody then flyBody:Destroy(); flyBody = nil end
        if flyGyro then flyGyro:Destroy(); flyGyro = nil end
        if v then
            local hrp = GetHRP()
            local hum = GetHum()
            if hrp and hum then
                flyGyro = Instance.new("BodyGyro", hrp)
                flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                flyGyro.P = 9000
                flyGyro.D = 500

                flyBody = Instance.new("BodyVelocity", hrp)
                flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                flyBody.Velocity = Vector3.zero

                local speed = 80
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
                        flyBody.Velocity = dir.Unit * speed
                        flyGyro.CFrame = cam.CFrame
                    end
                end)
                Notify("Fly Ativado (WASD + Space/Shift)")
            end
        else
            Notify("Fly Desativado")
        end
    end,
})

LocalTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(v)
        local hum = GetHum()
        if hum then hum.WalkSpeed = v end
    end,
})

LocalTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 50,
    Flag = "JumpSlider",
    Callback = function(v)
        local hum = GetHum()
        if hum then hum.JumpPower = v end
    end,
})

LocalTab:CreateButton({
    Name = "Resetar Personagem",
    Callback = function()
        local c = GetChar()
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end,
})

LocalTab:CreateButton({
    Name = "Copiar Server ID",
    Callback = function()
        setclipboard(game.JobId)
        Notify("Server ID copiado!")
    end,
})

-- ======================== TAB: ESP ========================
local ESPTab = Window:CreateTab("ESP", 6023426925)

local function UpdateESP()
    for _, obj in pairs(ESPFolder:GetChildren()) do
        obj:Destroy()
    end
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

ESPTab:CreateToggle({
    Name = "Ativar ESP (Caixa + Nome)",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(v)
        EspOn = v
        if v then
            UpdateESP()
            Notify("ESP Ativado")
        else
            for _, obj in pairs(ESPFolder:GetChildren()) do
                obj:Destroy()
            end
            Notify("ESP Desativado")
        end
    end,
})

ESPTab:CreateButton({
    Name = "Atualizar ESP",
    Callback = function()
        if EspOn then UpdateESP() end
    end,
})

Players.PlayerAdded:Connect(function()
    if EspOn then task.wait(2); UpdateESP() end
end)
Players.PlayerRemoving:Connect(function()
    if EspOn then task.wait(1); UpdateESP() end
end)

-- ======================== TAB: TOOLS ========================
local ToolsTab = Window:CreateTab("Tools", 6023426925)

ToolsTab:CreateButton({
    Name = "Invisibility (Invis)",
    Callback = function()
        local c = GetChar()
        if c then
            local torso = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
            if torso then
                torso.Transparency = 1
                if torso:FindFirstChild("roblox") then
                    torso.roblox:Destroy()
                end
                local part = Instance.new("Part", torso)
                part.Name = "invis_part"
                part.Size = torso.Size
                part.Transparency = 1
                part.CanCollide = false
                part.Anchored = false
                local weld = Instance.new("Weld", part)
                weld.Part0 = torso
                weld.Part1 = part
                InvisOn = true
                Notify("Invis Ativado")
            end
        end
    end,
})

ToolsTab:CreateButton({
    Name = "Teleportar atÃ© jogador",
    Callback = function()
        Rayfield:CreateDropdown({
            Name = "Selecionar Jogador",
            Options = {},
        })
    end,
})

local playerNames = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then
        table.insert(playerNames, p.Name)
    end
end

local selectedPlayer = nil

ToolsTab:CreateDropdown({
    Name = "Jogador para Teleportar",
    Options = playerNames,
    CurrentOption = {""},
    Flag = "PlayerDropdown",
    Callback = function(opt)
        selectedPlayer = opt[1]
    end,
})

ToolsTab:CreateButton({
    Name = "Teleportar!",
    Callback = function()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character then
                local myHRP = GetHRP()
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                if myHRP and targetHRP then
                    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -5)
                    Notify("Teleportado para " .. selectedPlayer)
                end
            end
        else
            Notify("Selecione um jogador primeiro!")
        end
    end,
})

-- ======================== TAB: ANTI-AFK ========================
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFKToggle",
    Callback = function(v)
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
    end,
})

MiscTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local servers = {}
        local t = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local http = game:GetService("HttpService")
        local data = http:JSONDecode(t)
        if data and data.data then
            for _, s in pairs(data.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    table.insert(servers, s.id)
                end
            end
        end
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LP)
        else
            Notify("Nenhum servidor encontrado")
        end
    end,
})

Rayfield:LoadConfiguration()
