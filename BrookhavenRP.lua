local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/lKoPoJLb/Scripts/main/Libraries/Library.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer

local noclipConn, flyConn, flyBody, flyGyro
local NoclipOn = false
local FlyOn = false
local AntiAFKOn = false
local EspOn = false

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Highlights"
ESPFolder.Parent = workspace

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

local Window = DiscordLib:Window("Brookhaven RP Hub")
local Server = Window:Server("Brookhaven", "")

local ChLocal = Server:Channel("Local")
local ChESP = Server:Channel("ESP")
local ChTools = Server:Channel("Tools")
local ChMisc = Server:Channel("Misc")

ChLocal:Toggle("Noclip (Atravessar paredes)", false, function(v)
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

ChLocal:Toggle("Fly (WASD + Space/Shift)", false, function(v)
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

ChLocal:Slider("Walk Speed", 16, 200, 16, function(v)
    local hum = GetHum()
    if hum then hum.WalkSpeed = v end
end)

ChLocal:Slider("Jump Power", 50, 200, 50, function(v)
    local hum = GetHum()
    if hum then hum.JumpPower = v end
end)

ChLocal:Button("Resetar Personagem", function()
    local c = GetChar()
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
    end
end)

ChLocal:Button("Copiar Server ID", function()
    setclipboard(game.JobId)
    Notify("Server ID copiado!")
end)

ChLocal:Seperator()

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

ChESP:Toggle("ESP (Caixa + Nome)", false, function(v)
    EspOn = v
    if v then
        UpdateESP()
        Notify("ESP Ativado")
    else
        for _, obj in pairs(ESPFolder:GetChildren()) do obj:Destroy() end
        Notify("ESP Desativado")
    end
end)

ChESP:Button("Atualizar ESP", function()
    if EspOn then UpdateESP() end
end)

Players.PlayerAdded:Connect(function()
    if EspOn then task.wait(2); UpdateESP() end
end)
Players.PlayerRemoving:Connect(function()
    if EspOn then task.wait(1); UpdateESP() end
end)

ChTools:Button("Invisibility", function()
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

ChTools:Dropdown("Jogador", playerNames, function(opt)
    selectedPlayer = opt
end)

ChTools:Button("Teleportar!", function()
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

ChMisc:Toggle("Anti-AFK", false, function(v)
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

ChMisc:Button("Server Hop", function()
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

ChMisc:Seperator()
ChMisc:Label("Menu = Delete para abrir/fechar")
