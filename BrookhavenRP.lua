--[[
â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—
â•‘              BROOKHAVEN RP - SCRIPT COMPLETO v3.0               â•‘
â•‘  F1/Insert = toggle menu                                        â•‘
â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--]]

print([[
â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—
â•‘        BROOKHAVEN RP SCRIPT v3.0             â•‘
â•‘  F1 ou Insert para abrir/fechar o menu       â•‘
â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
]])

-- SERVICES
local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Http = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- THEME
local C = {
	BG      = Color3.fromRGB(18,18,26),
	BG2     = Color3.fromRGB(28,28,38),
	BG3     = Color3.fromRGB(38,38,50),
	BG4     = Color3.fromRGB(50,50,65),
	Primary = Color3.fromRGB(0,160,255),
	PrimaryD= Color3.fromRGB(0,120,200),
	PrimaryL= Color3.fromRGB(0,190,255),
	Text    = Color3.fromRGB(225,225,240),
	TextDim = Color3.fromRGB(140,140,165),
	Success = Color3.fromRGB(0,200,80),
	Danger  = Color3.fromRGB(230,50,50),
	Warning = Color3.fromRGB(255,180,0),
	Border  = Color3.fromRGB(42,42,55),
	Header  = Color3.fromRGB(22,22,32),
	TabA    = Color3.fromRGB(0,100,180),
	TabI    = Color3.fromRGB(30,30,42),
}

-- NOTIFY
local function Notify(title, text, dur)
	pcall(StarterGui.SetCore, StarterGui, "SendNotification", {
		Title = title, Text = text, Duration = dur or 5
	})
end

-- ================================================================
-- UI BUILDER
-- ================================================================
local function CreateWindow(title, w, h)
	w = w or 580
	h = h or 440

	local parent = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

	local gui = Instance.new("ScreenGui")
	gui.Name = "BHRP"
	gui.ResetOnSpawn = false
	gui.Parent = parent
	gui.DisplayOrder = 9999
	gui.IgnoreGuiInset = true
	gui.Enabled = true

	-- MAIN FRAME
	local main = Instance.new("Frame")
	main.Size = UDim2.new(0,w,0,h)
	main.Position = UDim2.new(0.5,-w/2,0.5,-h/2)
	main.BackgroundColor3 = C.BG
	main.BorderSizePixel = 0
	main.Parent = gui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0,8)
	mainCorner.Parent = main

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = C.Border
	mainStroke.Thickness = 2
	mainStroke.Parent = main

	-- HEADER
	local hdr = Instance.new("Frame")
	hdr.Size = UDim2.new(1,0,0,40)
	hdr.BackgroundColor3 = C.Header
	hdr.BorderSizePixel = 0
	hdr.Parent = main

	local hdrCorner = Instance.new("UICorner")
	hdrCorner.CornerRadius = UDim.new(0,8)
	hdrCorner.Parent = hdr

	local hdrFill = Instance.new("Frame")
	hdrFill.Size = UDim2.new(1,0,0,10)
	hdrFill.Position = UDim2.new(0,0,1,-10)
	hdrFill.BackgroundColor3 = C.Header
	hdrFill.BorderSizePixel = 0
	hdrFill.Parent = hdr

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1,-90,1,0)
	titleLbl.Position = UDim2.new(0,14,0,0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = C.Primary
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 17
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = hdr

	-- TAB BAR
	local tabBar = Instance.new("Frame")
	tabBar.Size = UDim2.new(1,0,0,30)
	tabBar.Position = UDim2.new(0,0,0,40)
	tabBar.BackgroundColor3 = C.BG2
	tabBar.BorderSizePixel = 0
	tabBar.Parent = main

	-- TAB CONTAINER (ScrollingFrame)
	local tabCont = Instance.new("ScrollingFrame")
	tabCont.Size = UDim2.new(1,0,1,-70)
	tabCont.Position = UDim2.new(0,0,0,70)
	tabCont.BackgroundTransparency = 1
	tabCont.BorderSizePixel = 0
	tabCont.ScrollBarThickness = 4
	tabCont.ScrollBarImageColor3 = C.Primary
	tabCont.CanvasSize = UDim2.new(0,0,0,0)
	tabCont.Parent = main

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Padding = UDim.new(0,6)
	tabLayout.Parent = tabCont
	tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabCont.CanvasSize = UDim2.new(0,0,0,tabLayout.AbsoluteContentSize.Y + 10)
	end)

	-- SPACER (first element padding)
	local spacer = Instance.new("Frame")
	spacer.Size = UDim2.new(1,0,0,5)
	spacer.BackgroundTransparency = 1
	spacer.Parent = tabCont

	-- TABS
	local tabs = {}
	local activeTab = nil
	local tabIdx = 0

	local function SwitchTab(tab)
		if activeTab then
			activeTab.Container.Visible = false
			activeTab.Btn.BackgroundColor3 = C.TabI
			activeTab.Btn.TextColor3 = C.TextDim
		end
		activeTab = tab
		if tab then
			tab.Container.Visible = true
			tab.Btn.BackgroundColor3 = C.TabA
			tab.Btn.TextColor3 = C.Text
		end
	end

	local function MakeTab(name)
		tabIdx = tabIdx + 1

		-- Container frame (replaces ScrollingFrame - we use the main one instead)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(1,-10,1,0)
		container.Position = UDim2.new(0,5,0,0)
		container.BackgroundTransparency = 1
		container.BorderSizePixel = 0
		container.Parent = tabCont
		container.Visible = false

		-- Layout inside container
		local lay = Instance.new("UIListLayout")
		lay.Padding = UDim.new(0,5)
		lay.Parent = container

		-- Tab button
		local btnW = math.max(65, math.floor((w - 8) / 6) - 4)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0,btnW,0,24)
		btn.Position = UDim2.new(0,4 + (tabIdx-1)*(btnW+4), 0,3)
		btn.BackgroundColor3 = C.TabI
		btn.BorderSizePixel = 0
		btn.Text = name
		btn.TextColor3 = C.TextDim
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 12
		btn.Parent = tabBar

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0,5)
		btnCorner.Parent = btn

		if tabIdx == 1 then
			SwitchTab({Container = container, Btn = btn})
			container.Visible = true
			btn.BackgroundColor3 = C.TabA
			btn.TextColor3 = C.Text
		end

		btn.MouseButton1Click:Connect(function()
			SwitchTab({Container = container, Btn = btn})
		end)
		btn.MouseEnter:Connect(function()
			if activeTab and activeTab.Btn ~= btn then
				btn.BackgroundColor3 = C.PrimaryD
			end
		end)
		btn.MouseLeave:Connect(function()
			if activeTab and activeTab.Btn ~= btn then
				btn.BackgroundColor3 = C.TabI
			end
		end)

		local tab = {
			Container = container,
			Btn = btn,
			Name = name,
			Layout = lay,
		}

		-- HELPERS --

		function tab:Title(text)
			local l = Instance.new("TextLabel")
			l.Size = UDim2.new(1,-10,0,26)
			l.Position = UDim2.new(0,5,0,0)
			l.BackgroundTransparency = 1
			l.Text = text
			l.TextColor3 = C.Primary
			l.Font = Enum.Font.GothamBold
			l.TextSize = 14
			l.TextXAlignment = Enum.TextXAlignment.Left
			l.Parent = container
			return l
		end

		function tab:Label(text)
			local l = Instance.new("TextLabel")
			l.Size = UDim2.new(1,-10,0,20)
			l.Position = UDim2.new(0,5,0,0)
			l.BackgroundTransparency = 1
			l.Text = text
			l.TextColor3 = C.TextDim
			l.Font = Enum.Font.Gotham
			l.TextSize = 12
			l.TextXAlignment = Enum.TextXAlignment.Left
			l.Parent = container

			local obj = {Label = l}
			function obj:Set(t) l.Text = t end
			function obj:SetCor(c) l.TextColor3 = c end
			return obj
		end

		function tab:Separator()
			local s = Instance.new("Frame")
			s.Size = UDim2.new(1,-10,0,1)
			s.Position = UDim2.new(0,5,0,0)
			s.BackgroundColor3 = C.Border
			s.BorderSizePixel = 0
			s.Parent = container
			return s
		end

		function tab:Spacer(h)
			h = h or 4
			local s = Instance.new("Frame")
			s.Size = UDim2.new(1,0,0,h)
			s.BackgroundTransparency = 1
			s.BorderSizePixel = 0
			s.Parent = container
			return s
		end

		function tab:Button(text, fn)
			local f = Instance.new("Frame")
			f.Size = UDim2.new(1,-10,0,34)
			f.Position = UDim2.new(0,5,0,0)
			f.BackgroundColor3 = C.BG3
			f.BorderSizePixel = 0
			f.Parent = container

			local fCorner = Instance.new("UICorner")
			fCorner.CornerRadius = UDim.new(0,6)
			fCorner.Parent = f

			local fStroke = Instance.new("UIStroke")
			fStroke.Color = C.Border
			fStroke.Thickness = 1
			fStroke.Parent = f

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1,0,1,0)
			label.BackgroundTransparency = 1
			label.Text = text
			label.TextColor3 = C.Text
			label.Font = Enum.Font.GothamBold
			label.TextSize = 13
			label.Parent = f

			local btn2 = Instance.new("TextButton")
			btn2.Size = UDim2.new(1,0,1,0)
			btn2.BackgroundTransparency = 1
			btn2.Text = ""
			btn2.Parent = f

			btn2.MouseButton1Click:Connect(fn)
			btn2.MouseEnter:Connect(function()
				f.BackgroundColor3 = C.PrimaryD
			end)
			btn2.MouseLeave:Connect(function()
				f.BackgroundColor3 = C.BG3
			end)

			return f
		end

		function tab:Toggle(text, get, toggle)
			local f = Instance.new("Frame")
			f.Size = UDim2.new(1,-10,0,36)
			f.Position = UDim2.new(0,5,0,0)
			f.BackgroundColor3 = C.BG3
			f.BorderSizePixel = 0
			f.Parent = container

			local fCorner = Instance.new("UICorner")
			fCorner.CornerRadius = UDim.new(0,6)
			fCorner.Parent = f

			local fStroke = Instance.new("UIStroke")
			fStroke.Color = C.Border
			fStroke.Thickness = 1
			fStroke.Parent = f

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1,-60,1,0)
			label.Position = UDim2.new(0,10,0,0)
			label.BackgroundTransparency = 1
			label.Text = text
			label.TextColor3 = C.Text
			label.Font = Enum.Font.Gotham
			label.TextSize = 13
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = f

			local sw = Instance.new("Frame")
			sw.Size = UDim2.new(0,44,0,22)
			sw.Position = UDim2.new(1,-52,0.5,-11)
			sw.BackgroundColor3 = C.Danger
			sw.BorderSizePixel = 0
			sw.Parent = f

			local swCorner = Instance.new("UICorner")
			swCorner.CornerRadius = UDim.new(1,0)
			swCorner.Parent = sw

			local ball = Instance.new("Frame")
			ball.Size = UDim2.new(0,18,0,18)
			ball.Position = UDim2.new(0,2,0.5,-9)
			ball.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ball.BorderSizePixel = 0
			ball.Parent = sw

			local ballCorner = Instance.new("UICorner")
			ballCorner.CornerRadius = UDim.new(1,0)
			ballCorner.Parent = ball

			local function Update()
				local v = get()
				sw.BackgroundColor3 = v and C.Success or C.Danger
				local tx = v and (sw.AbsoluteSize.X - 20) or 2
				ball.Position = UDim2.new(0,tx,0.5,-9)
			end

			local btnT = Instance.new("TextButton")
			btnT.Size = UDim2.new(1,0,1,0)
			btnT.BackgroundTransparency = 1
			btnT.Text = ""
			btnT.Parent = f

			btnT.MouseButton1Click:Connect(function()
				toggle()
				Update()
			end)
			btnT.MouseEnter:Connect(function()
				f.BackgroundColor3 = C.BG4
			end)
			btnT.MouseLeave:Connect(function()
				f.BackgroundColor3 = C.BG3
			end)

			Update()

			return {Frame = f, Update = Update}
		end

		function tab:TextBox(placeholder, fn)
			local f = Instance.new("Frame")
			f.Size = UDim2.new(1,-10,0,34)
			f.Position = UDim2.new(0,5,0,0)
			f.BackgroundColor3 = C.BG3
			f.BorderSizePixel = 0
			f.Parent = container

			local fCorner = Instance.new("UICorner")
			fCorner.CornerRadius = UDim.new(0,6)
			fCorner.Parent = f

			local fStroke = Instance.new("UIStroke")
			fStroke.Color = C.Border
			fStroke.Thickness = 1
			fStroke.Parent = f

			local box = Instance.new("TextBox")
			box.Size = UDim2.new(1,-10,1,0)
			box.Position = UDim2.new(0,5,0,0)
			box.BackgroundTransparency = 1
			box.TextColor3 = C.Text
			box.PlaceholderColor3 = C.TextDim
			box.PlaceholderText = placeholder
			box.Font = Enum.Font.Gotham
			box.TextSize = 13
			box.ClearTextOnFocus = false
			box.Parent = f

			box.FocusLost:Connect(function(enter)
				if enter and fn then fn(box.Text) end
			end)

			return {Frame = f, Box = box}
		end

		function tab:Slider(text, minv, maxv, def, fn)
			local f = Instance.new("Frame")
			f.Size = UDim2.new(1,-10,0,48)
			f.Position = UDim2.new(0,5,0,0)
			f.BackgroundColor3 = C.BG3
			f.BorderSizePixel = 0
			f.Parent = container

			local fCorner = Instance.new("UICorner")
			fCorner.CornerRadius = UDim.new(0,6)
			fCorner.Parent = f

			local fStroke = Instance.new("UIStroke")
			fStroke.Color = C.Border
			fStroke.Thickness = 1
			fStroke.Parent = f

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,-10,0,18)
			lbl.Position = UDim2.new(0,5,0,4)
			lbl.BackgroundTransparency = 1
			lbl.Text = text .. ": " .. tostring(def)
			lbl.TextColor3 = C.Text
			lbl.Font = Enum.Font.Gotham
			lbl.TextSize = 12
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = f

			local track = Instance.new("Frame")
			track.Size = UDim2.new(1,-10,0,4)
			track.Position = UDim2.new(0,5,0,32)
			track.BackgroundColor3 = C.BG
			track.BorderSizePixel = 0
			track.Parent = f

			local trackCorner = Instance.new("UICorner")
			trackCorner.CornerRadius = UDim.new(1,0)
			trackCorner.Parent = track

			local ratio = (def - minv) / (maxv - minv)
			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(ratio,0,1,0)
			fill.BackgroundColor3 = C.Primary
			fill.BorderSizePixel = 0
			fill.Parent = track

			local fillCorner = Instance.new("UICorner")
			fillCorner.CornerRadius = UDim.new(1,0)
			fillCorner.Parent = fill

			local grip = Instance.new("TextButton")
			grip.Size = UDim2.new(0,14,0,14)
			grip.Position = UDim2.new(ratio,-7,0.5,-7)
			grip.BackgroundColor3 = C.PrimaryL
			grip.BorderSizePixel = 0
			grip.Text = ""
			grip.Parent = track

			local gripCorner = Instance.new("UICorner")
			gripCorner.CornerRadius = UDim.new(1,0)
			gripCorner.Parent = grip

			local dragging = false
			local sliderObj = {}

			local function SetVal(posX)
				local tw = track.AbsoluteSize.X
				if tw <= 0 then return end
				local p = math.clamp((posX - track.AbsolutePosition.X) / tw, 0, 1)
				local v = math.floor(minv + (maxv - minv) * p)
				fill.Size = UDim2.new(p,0,1,0)
				grip.Position = UDim2.new(p,-7,0.5,-7)
				lbl.Text = text .. ": " .. tostring(v)
				if fn then fn(v) end
			end

			function sliderObj:Set(v)
				local r = math.clamp((v - minv) / (maxv - minv), 0, 1)
				fill.Size = UDim2.new(r,0,1,0)
				grip.Position = UDim2.new(r,-7,0.5,-7)
				lbl.Text = text .. ": " .. tostring(math.floor(v))
			end

			-- Single input handler for this window will be set up below
			-- For now, store slider data for the global handler
			if not gui._sliders then gui._sliders = {} end
			table.insert(gui._sliders, {
				track = track,
				set = SetVal,
				grip = grip,
			})

			grip.MouseButton1Down:Connect(function()
				dragging = true
			end)

			-- Update dragging flag via InputEnded on grip
			grip.MouseButton1Up:Connect(function()
				dragging = false
			end)

			-- Also detect mouse up globally
			local trackCon
			trackCon = grip.MouseLeave:Connect(function()
				-- no-op, we handle via global InputEnded
			end)

			-- Store drag state on gui for global handler
			grip.MouseButton1Down:Connect(function()
				gui._dragSlider = sliderObj
				gui._dragActive = true
			end)

			return sliderObj
		end

		table.insert(tabs, tab)
		return tab
	end

	-- GLOBAL INPUT HANDLERS (single per window)
	do
		-- Slider dragging
		gui._dragActive = false
		gui._dragSlider = nil

		gui.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				-- Check if clicking on any slider track
				if gui._sliders then
					for _, s in ipairs(gui._sliders) do
						local tp = s.track
						local abs = tp.AbsolutePosition
						local sz = tp.AbsoluteSize
						if inp.Position.X >= abs.X and inp.Position.X <= abs.X + sz.X and
						   inp.Position.Y >= abs.Y - 8 and inp.Position.Y <= abs.Y + sz.Y + 8 then
							s.set(inp.Position.X)
							gui._dragActive = true
							gui._dragSlider = s
							break
						end
					end
				end
			end
		end)

		gui.InputChanged:Connect(function(inp)
			if gui._dragActive and gui._dragSlider and inp.UserInputType == Enum.UserInputType.MouseMovement then
				gui._dragSlider.set(inp.Position.X)
			end
		end)

		gui.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				gui._dragActive = false
				gui._dragSlider = nil
			end
		end)
	end

	-- HEADER BUTTONS
	local minimized = false
	local normalH = h
	local minH = 40

	local function MakeHeaderBtn(x, text, color, fn)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0,26,0,26)
		b.Position = UDim2.new(1,x,0.5,-13)
		b.BackgroundColor3 = C.BG2
		b.BorderSizePixel = 0
		b.Text = text
		b.TextColor3 = color or C.Text
		b.Font = Enum.Font.GothamBold
		b.TextSize = 14
		b.Parent = hdr

		local bCorner = Instance.new("UICorner")
		bCorner.CornerRadius = UDim.new(0,5)
		bCorner.Parent = b

		b.MouseButton1Click:Connect(fn)
		b.MouseEnter:Connect(function()
			b.BackgroundColor3 = C.PrimaryD
		end)
		b.MouseLeave:Connect(function()
			b.BackgroundColor3 = C.BG2
		end)
		return b
	end

	MakeHeaderBtn(-60, "â”€", C.Text, function()
		minimized = not minimized
		tabBar.Visible = not minimized
		tabCont.Visible = not minimized
		main.Size = UDim2.new(0,w,0,minimized and minH or normalH)
	end)

	MakeHeaderBtn(-32, "X", C.Danger, function()
		gui:Destroy()
	end)

	-- DRAG
	do
		local dragging = false
		local dragStart = Vector2.new()
		local dragPos = UDim2.new()

		hdr.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = Vector2.new(inp.Position.X, inp.Position.Y)
				dragPos = main.Position
			end
		end)

		hdr.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		gui.InputChanged:Connect(function(inp)
			if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = Vector2.new(inp.Position.X, inp.Position.Y) - dragStart
				main.Position = UDim2.new(
					dragPos.X.Scale, dragPos.X.Offset + delta.X,
					dragPos.Y.Scale, dragPos.Y.Offset + delta.Y
				)
			end
		end)
	end

	local win = {
		Gui = gui,
		Main = main,
		Tabs = tabs,
		MakeTab = MakeTab,
		Title = title,
	}
	return win
end

-- ================================================================
-- GAME MODULE
-- ================================================================
local BH = {
	ESP = false,
	Invisivel = false,
	Noclip = false,
	AntiAFK = false,
	Fly = false,
	Speed = 16,
	JumpPower = 50,
	Seguir = false,
	SeguirPlayer = nil,
	Godmode = false,
	Grudado = false,
	GrudadoPlayer = nil,
	Limbo = CFrame.new(0,-500,0),
	PosOriginal = nil,
	Config = {},
	Loops = {},
	ESPObjs = {},
}

-- ESP
function BH:CriarESP(p)
	if p == LP or BH.ESPObjs[p] then return end
	local f = Instance.new("Folder")
	f.Name = "ESP_" .. p.Name
	local hl = Instance.new("Highlight", f)
	hl.FillColor = Color3.fromRGB(255,50,50)
	hl.OutlineColor = Color3.fromRGB(255,255,255)
	hl.FillTransparency = 0.35
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	local bg = Instance.new("BillboardGui", f)
	bg.Size = UDim2.new(0,220,0,50)
	bg.StudsOffset = Vector3.new(0,3.5,0)
	bg.AlwaysOnTop = true
	bg.LightInfluence = 0
	local nl = Instance.new("TextLabel")
	nl.Size = UDim2.new(1,0,0.5,0)
	nl.BackgroundTransparency = 1
	nl.Text = p.Name
	nl.TextColor3 = Color3.fromRGB(255,80,80)
	nl.TextStrokeTransparency = 0.2
	nl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	nl.Font = Enum.Font.GothamBold
	nl.TextSize = 15
	nl.Parent = bg
	local dl = Instance.new("TextLabel")
	dl.Size = UDim2.new(1,0,0.5,0)
	dl.Position = UDim2.new(0,0,0.5,0)
	dl.BackgroundTransparency = 1
	dl.Text = ""
	dl.TextColor3 = Color3.fromRGB(200,200,200)
	dl.TextStrokeTransparency = 0.3
	dl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	dl.Font = Enum.Font.Gotham
	dl.TextSize = 12
	dl.Parent = bg
	BH.ESPObjs[p] = {Folder = f, Highlight = hl, NameLabel = nl, DistLabel = dl, Billboard = bg}
	f.Parent = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
end

function BH:RemoverESP(p)
	if BH.ESPObjs[p] then
		BH.ESPObjs[p].Folder:Destroy()
		BH.ESPObjs[p] = nil
	end
end

function BH:ToggleESP()
	BH.ESP = not BH.ESP
	if BH.ESP then
		for _, p in Players:GetPlayers() do
			if p ~= LP then BH:CriarESP(p) end
		end
	else
		for p in pairs(BH.ESPObjs) do BH:RemoverESP(p) end
	end
	return BH.ESP
end

function BH:AtualizarESP()
	for p, obj in pairs(BH.ESPObjs) do
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
				local cor = Color3.fromRGB(255*(1-r), 255*r, 0)
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

-- INVISIVEL
function BH:ToggleInvisivel()
	BH.Invisivel = not BH.Invisivel
	local char = LP.Character
	if char then
		for _, v in char:GetDescendants() do
			if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("MeshPart") then
				v.Transparency = BH.Invisivel and 1 or 0
			end
		end
		local tool = char:FindFirstChildOfClass("Tool")
		if tool then
			for _, v in tool:GetDescendants() do
				if v:IsA("BasePart") then v.Transparency = 0 end
			end
		end
	end
	return BH.Invisivel
end

-- NOCLIP
function BH:ToggleNoclip()
	BH.Noclip = not BH.Noclip
	if BH.Noclip then
		BH.Loops.Noclip = Run.Stepped:Connect(function()
			local char = LP.Character
			if not char then return end
			for _, v in char:GetDescendants() do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end)
	else
		if BH.Loops.Noclip then BH.Loops.Noclip:Disconnect(); BH.Loops.Noclip = nil end
	end
	return BH.Noclip
end

-- ANTI AFK
function BH:ToggleAntiAFK()
	BH.AntiAFK = not BH.AntiAFK
	if BH.AntiAFK then
		BH.Loops.AntiAFK = LP.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	else
		if BH.Loops.AntiAFK then BH.Loops.AntiAFK:Disconnect(); BH.Loops.AntiAFK = nil end
	end
	return BH.AntiAFK
end

-- FLY
function BH:ToggleFly()
	BH.Fly = not BH.Fly
	local char = LP.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end
	if BH.Fly then
		hum.PlatformStand = true
		local bp = Instance.new("BodyPosition")
		bp.Name = "FlyBP"
		bp.MaxForce = Vector3.new(1,1,1)*9e9
		bp.P = 2000
		bp.D = 100
		local old = hrp:FindFirstChild("FlyBP")
		if old then old:Destroy() end
		bp.Parent = hrp
		BH.Loops.Fly = Run.RenderStepped:Connect(function()
			if not BH.Fly or not hrp or not hrp.Parent then
				if BH.Loops.Fly then BH.Loops.Fly:Disconnect(); BH.Loops.Fly = nil end
				return
			end
			local dir = Vector3.new()
			if Input:IsKeyDown(Enum.KeyCode.W) then dir = dir + Vector3.new(0,0,-1) end
			if Input:IsKeyDown(Enum.KeyCode.S) then dir = dir + Vector3.new(0,0,1) end
			if Input:IsKeyDown(Enum.KeyCode.A) then dir = dir + Vector3.new(-1,0,0) end
			if Input:IsKeyDown(Enum.KeyCode.D) then dir = dir + Vector3.new(1,0,0) end
			if Input:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
			if Input:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir + Vector3.new(0,-1,0) end
			local cam = workspace.CurrentCamera
			if cam then dir = cam.CFrame:VectorToObjectSpace(dir) end
			bp.Position = hrp.Position + dir * (BH.Speed * 0.12)
		end)
	else
		hum.PlatformStand = false
		local bp = hrp:FindFirstChild("FlyBP")
		if bp then bp:Destroy() end
		if BH.Loops.Fly then BH.Loops.Fly:Disconnect(); BH.Loops.Fly = nil end
	end
	return BH.Fly
end

-- SPEED / JUMP
function BH:SetSpeed(v)
	BH.Speed = v
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = v end
end

function BH:SetJump(v)
	BH.JumpPower = v
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.JumpPower = v end
end

-- SEGUIR
function BH:SelectPlayer(nome)
	for _, p in Players:GetPlayers() do
		if p.Name:lower():find(nome:lower()) or (p.DisplayName and p.DisplayName:lower():find(nome:lower())) then
			BH.SeguirPlayer = p
			return p
		end
	end
	return nil
end

function BH:ToggleSeguir()
	if not BH.SeguirPlayer then BH.Seguir = false; return false end
	BH.Seguir = not BH.Seguir
	return BH.Seguir
end

-- GODMODE
function BH:ToggleGodmode()
	BH.Godmode = not BH.Godmode
	if BH.Godmode then
		BH.Loops.Godmode = Run.RenderStepped:Connect(function()
			local char = LP.Character
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.MaxHealth = math.huge; hum.Health = math.huge end
		end)
	else
		if BH.Loops.Godmode then BH.Loops.Godmode:Disconnect(); BH.Loops.Godmode = nil end
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.MaxHealth = 100; hum.Health = 100 end
	end
	return BH.Godmode
end

-- REPELIR VEICULOS
function BH:RepelirVeiculos()
	local char = LP.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return 0 end
	local pos = char:FindFirstChild("HumanoidRootPart").Position
	local count = 0
	for _, v in workspace:GetDescendants() do
		if v:IsA("VehicleSeat") then
			local veic = v.Parent
			if veic and veic:FindFirstChild("HumanoidRootPart") then
				local hrp = veic:FindFirstChild("HumanoidRootPart")
				local dist = (hrp.Position - pos).Magnitude
				if dist <= 30 then
					local dir = (hrp.Position - pos).Unit
					hrp.CFrame = hrp.CFrame + dir * Vector3.new(50,10,50)
					hrp.Velocity = dir * 100 + Vector3.new(0,30,0)
					count = count + 1
				end
			end
		end
	end
	Notify("Repelir", count .. " veiculo(s) repelidos!")
	return count
end

-- GRUDAR
function BH:ToggleGrudar()
	if not BH.SeguirPlayer then
		Notify("Erro", "Selecione um alvo primeiro!")
		return false
	end
	BH.Grudado = not BH.Grudado
	if BH.Grudado then
		BH.GrudadoPlayer = BH.SeguirPlayer
		local myChar = LP.Character
		local alvoChar = BH.GrudadoPlayer.Character
		if not myChar or not alvoChar then BH.Grudado = false; return false end
		local myHRP = myChar:FindFirstChild("HumanoidRootPart")
		local alvoHRP = alvoChar:FindFirstChild("HumanoidRootPart")
		if not myHRP or not alvoHRP then BH.Grudado = false; return false end
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
		BH.Loops.Grude = Run.RenderStepped:Connect(function()
			if not BH.Grudado or not BH.GrudadoPlayer or not BH.GrudadoPlayer.Parent then BH:SolteGrude(); return end
			local a = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			local b = BH.GrudadoPlayer.Character and BH.GrudadoPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not a or not b then BH:SolteGrude() end
		end)
		Notify("Grudado", "Voce esta grudado em " .. BH.GrudadoPlayer.Name)
		return true
	else
		BH:SolteGrude()
		return false
	end
end

function BH:SolteGrude()
	BH.Grudado = false
	BH.GrudadoPlayer = nil
	if BH.Loops.Grude then BH.Loops.Grude:Disconnect(); BH.Loops.Grude = nil end
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
	for _, p in Players:GetPlayers() do
		local c = p.Character
		if c and c:FindFirstChild("HumanoidRootPart") then
			local att = c:FindFirstChild("HumanoidRootPart"):FindFirstChild("GrudeAtt")
			if att then att:Destroy() end
		end
	end
	Notify("Solto", "Voce se soltou do alvo!")
end

-- PUXAR VEICULO
function BH:PuxarVeiculo()
	local char = LP.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local pos = char:FindFirstChild("HumanoidRootPart").Position
	local closest = nil
	local minDist = math.huge
	for _, v in workspace:GetDescendants() do
		if v:IsA("VehicleSeat") then
			local veic = v.Parent
			if veic and veic:FindFirstChild("HumanoidRootPart") then
				local hrp = veic:FindFirstChild("HumanoidRootPart")
				local dist = (hrp.Position - pos).Magnitude
				if dist < minDist then minDist = dist; closest = veic end
			end
		end
	end
	if closest and closest:FindFirstChild("HumanoidRootPart") then
		local hrp = closest:FindFirstChild("HumanoidRootPart")
		hrp.CFrame = CFrame.new(pos + Vector3.new(0,2,-5))
		hrp.Velocity = Vector3.new()
		Notify("Veiculo", "Veiculo puxado ate voce!")
	else
		Notify("Veiculo", "Nenhum veiculo encontrado!")
	end
end

-- ONIBUS SEQUESTRO
function BH:OnibusSequestro()
	if not BH.SeguirPlayer then Notify("Onibus", "Selecione um alvo primeiro!"); return end
	local alvo = BH.SeguirPlayer
	local alvoChar = alvo.Character
	if not alvoChar then Notify("Onibus", "Alvo sem personagem!"); return end
	local char = LP.Character
	if not char then return end
	local myHRP = char:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end
	BH.PosOriginal = myHRP.CFrame
	Notify("Onibus", "Procurando onibus escolar...")
	local onibus = nil
	local termos = {"SchoolBus", "School Bus", "Bus", "Escolar"}
	for _, v in workspace:GetDescendants() do
		if v:IsA("Model") then
			local nome = v.Name:lower()
			for _, t in ipairs(termos) do
				if nome:find(t:lower()) and v:FindFirstChildWhichIsA("VehicleSeat") then
					onibus = v; break
				end
			end
		end
		if onibus then break end
	end
	if not onibus then Notify("Onibus", "Nenhum onibus escolar encontrado!"); return end
	local busHRP = onibus:FindFirstChild("HumanoidRootPart") or onibus:FindFirstChildWhichIsA("BasePart")
	if not busHRP then Notify("Onibus", "Onibus sem parte principal!"); return end
	Notify("Onibus", "Onibus encontrado! Perseguindo alvo...")
	myHRP.CFrame = busHRP.CFrame + Vector3.new(0,3,0)
	local passos = 0
	local maxPassos = 300
	local con
	con = Run.RenderStepped:Connect(function()
		passos = passos + 1
		if passos > maxPassos then con:Disconnect(); Notify("Onibus", "Alvo fugiu! Abortando."); return end
		local alvoCharAt = alvo.Character
		if not alvoCharAt then con:Disconnect(); Notify("Onibus", "Alvo desconectou!"); return end
		local alvoHRP = alvoCharAt:FindFirstChild("HumanoidRootPart")
		if not alvoHRP then con:Disconnect(); return end
		local dir = (alvoHRP.Position - busHRP.Position).Unit
		local dist = (alvoHRP.Position - busHRP.Position).Magnitude
		busHRP.CFrame = CFrame.lookAt(busHRP.Position, alvoHRP.Position) * CFrame.new(0,0,math.min(1.5,dist))
		busHRP.CFrame = busHRP.CFrame + dir * math.min(2,dist)
		if dist < 8 then
			con:Disconnect()
			Notify("Onibus", "Alvo capturado! Enviando ao limbo...")
			task.wait(0.5)
			local alvoChar2 = alvo.Character
			if alvoChar2 and alvoChar2:FindFirstChild("HumanoidRootPart") then
				alvoChar2:FindFirstChild("HumanoidRootPart").CFrame = BH.Limbo
				task.wait(1)
				if BH.PosOriginal then
					task.wait(0.3)
					local charAt = LP.Character
					if charAt and charAt:FindFirstChild("HumanoidRootPart") then
						charAt:FindFirstChild("HumanoidRootPart").CFrame = BH.PosOriginal
					end
				end
				Notify("Onibus", "Sequestro concluido!")
			end
		end
	end)
end

-- TELEPORTES
function BH:TeleportarCFrame(cf)
	local char = LP.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char:FindFirstChild("HumanoidRootPart").CFrame = cf
	end
end

function BH:TeleportarJogador(nome)
	for _, p in Players:GetPlayers() do
		if p.Name:lower():find(nome:lower()) or (p.DisplayName and p.DisplayName:lower():find(nome:lower())) then
			local char = p.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				BH:TeleportarCFrame(char:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(2,0,2))
				return true
			end
		end
	end
	return false
end

function BH:TeleportarCoordenadas(x,y,z)
	BH:TeleportarCFrame(CFrame.new(x,y,z))
end

-- RESET
function BH:Reset()
	BH.ESP = false; BH.Invisivel = false; BH.Noclip = false; BH.AntiAFK = false
	BH.Fly = false; BH.Seguir = false; BH.SeguirPlayer = nil; BH.Godmode = false
	BH.Grudado = false; BH.GrudadoPlayer = nil; BH.Speed = 16; BH.JumpPower = 50
	BH:SolteGrude()
	for k, v in pairs(BH.Loops) do
		if v then pcall(function() v:Disconnect() end) end
	end
	BH.Loops = {}
	for p in pairs(BH.ESPObjs) do BH:RemoverESP(p) end
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum:BreakJoints() end
end

-- MAIN LOOP
Run.RenderStepped:Connect(function()
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

-- PLAYER EVENTS
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		task.wait(1.5)
		if BH.ESP then BH:CriarESP(p) end
	end)
end)

Players.PlayerRemoving:Connect(function(p)
	BH:RemoverESP(p)
	if BH.SeguirPlayer == p then BH.SeguirPlayer = nil; BH.Seguir = false end
end)

for _, p in Players:GetPlayers() do
	if p ~= LP then
		if BH.ESP then BH:CriarESP(p) end
		p.CharacterAdded:Connect(function()
			task.wait(1.5)
			if BH.ESP then BH:CriarESP(p) end
		end)
	end
end

-- CONFIG
function BH:SalvarConfig()
	local dados = {
		ESP = BH.ESP, Invisivel = BH.Invisivel, Noclip = BH.Noclip,
		AntiAFK = BH.AntiAFK, Speed = BH.Speed, JumpPower = BH.JumpPower,
	}
	BH.Config = dados
	local json = Http:JSONEncode(dados)
	writefile("BH_Config.json", json)
	return true
end

function BH:CarregarConfig()
	local arquivo = readfile("BH_Config.json")
	if arquivo then
		local ok, dados = pcall(Http.JSONDecode, Http, arquivo)
		if ok and type(dados) == "table" then
			BH.Config = dados
			if dados.ESP ~= nil then BH.ESP = dados.ESP end
			if dados.Invisivel ~= nil then BH.Invisivel = dados.Invisivel end
			if dados.Noclip ~= nil then BH.Noclip = dados.Noclip end
			if dados.AntiAFK ~= nil then BH.AntiAFK = dados.AntiAFK end
			if dados.Speed then BH:SetSpeed(dados.Speed) end
			if dados.JumpPower then BH:SetJump(dados.JumpPower) end
			return true
		end
	end
	return false
end

-- ================================================================
-- BUILD UI
-- ================================================================
local Janela = CreateWindow("BROOKHAVEN RP", 580, 440)

-- TAB: PLAYER
local tabP = Janela:MakeTab("Player")
tabP:Title("Hacks do Personagem")
local togESP = tabP:Toggle("ESP (Visao atraves)", function() return BH.ESP end, function() BH:ToggleESP() end)
local togInv = tabP:Toggle("Invisivel", function() return BH.Invisivel end, function() BH:ToggleInvisivel() end)
local togNoc = tabP:Toggle("Noclip (Atravessar paredes)", function() return BH.Noclip end, function() BH:ToggleNoclip() end)
local togAFK = tabP:Toggle("Anti AFK", function() return BH.AntiAFK end, function() BH:ToggleAntiAFK() end)
local togFly = tabP:Toggle("Modo Voo", function() return BH.Fly end, function() BH:ToggleFly() end)
tabP:Separator()
tabP:Title("Status")
local lblSpd = tabP:Label("WalkSpeed: " .. BH.Speed)
local lblJmp = tabP:Label("JumpPower: " .. BH.JumpPower)
tabP:Separator()
tabP:Title("Controles")
tabP:Slider("WalkSpeed", 10, 200, BH.Speed, function(v)
	BH:SetSpeed(v)
	lblSpd:Set("WalkSpeed: " .. v)
end)
tabP:Slider("JumpPower", 10, 300, BH.JumpPower, function(v)
	BH:SetJump(v)
	lblJmp:Set("JumpPower: " .. v)
end)

-- TAB: SEGUIR
local tabS = Janela:MakeTab("Seguir")
tabS:Title("Buscar Jogador")
local lblAlvo = tabS:Label("Alvo: nenhum")
tabS:TextBox("Digite o nome do jogador...", function(txt)
	local p = BH:SelectPlayer(txt)
	if p then
		lblAlvo:Set("Alvo: " .. p.Name)
		lblAlvo:SetCor(C.Success)
		Notify("Alvo selecionado", p.Name)
	else
		lblAlvo:Set("Jogador nao encontrado: " .. txt)
		lblAlvo:SetCor(C.Danger)
	end
end)
tabS:Separator()
tabS:Title("Controles de Seguir")
local lblSeg = tabS:Label("Status: Parado")
tabS:Button("Seguir alvo", function()
	local s = BH:ToggleSeguir()
	lblSeg:Set(s and "Status: Seguindo " .. (BH.SeguirPlayer and BH.SeguirPlayer.Name or "?") or "Status: Parado")
	lblSeg:SetCor(s and C.Success or C.TextDim)
end)
tabS:Button("Parar de seguir", function()
	BH.Seguir = false; BH.SeguirPlayer = nil
	lblAlvo:Set("Alvo: nenhum"); lblAlvo:SetCor(C.TextDim)
	lblSeg:Set("Status: Parado"); lblSeg:SetCor(C.TextDim)
end)
tabS:Separator()
tabS:Title("Grudar no Alvo")
local lblGru = tabS:Label("Grudado: Nao")
tabS:Button("Grudar / Soltar alvo", function()
	local s = BH:ToggleGrudar()
	lblGru:Set(s and "Grudado: " .. (BH.GrudadoPlayer and BH.GrudadoPlayer.Name or "?") or "Grudado: Nao")
	lblGru:SetCor(s and C.Success or C.TextDim)
end)
tabS:Button("Soltar grude", function()
	BH:SolteGrude()
	lblGru:Set("Grudado: Nao"); lblGru:SetCor(C.TextDim)
end)

-- TAB: VEICULOS
local tabV = Janela:MakeTab("Veiculos")
tabV:Title("Controle de Veiculos")
tabV:Button("Repelir veiculos (30m)", function() BH:RepelirVeiculos() end)
tabV:Button("Puxar veiculo ate voce", function() BH:PuxarVeiculo() end)
tabV:Separator()
tabV:Title("Onibus Escolar - Sequestro")
local lblOni = tabV:Label("Status: Aguardando")
tabV:Button("INICIAR SEQUESTRO", function()
	lblOni:Set("Status: Executando sequestro..."); lblOni:SetCor(C.Warning)
	task.spawn(function()
		BH:OnibusSequestro()
		task.wait(0.5)
		lblOni:Set("Status: Pronto"); lblOni:SetCor(C.Success)
	end)
end)
tabV:Separator()
tabV:Title("Locais de Veiculos (Brookhaven)")
local veicLoc = {
	{"Garagem (casa padrao)", CFrame.new(190,23.5,210)},
	{"Concessionaria", CFrame.new(270,23.5,230)},
	{"Estacionamento Hospital", CFrame.new(255,23.5,285)},
	{"Oficina Mecanica", CFrame.new(220,23.5,155)},
	{"Estacionamento Escola", CFrame.new(340,23.5,215)},
	{"Heliporto", CFrame.new(310,30,290)},
}
for _, loc in ipairs(veicLoc) do
	tabV:Button(loc[1], function() BH:TeleportarCFrame(loc[2]) end)
end

-- TAB: TELEPORTES
local tabT = Janela:MakeTab("Teleportes")
tabT:Title("Locais do Brookhaven")
local locais = {
	{"Policia", CFrame.new(183,24,220)},
	{"Hospital", CFrame.new(242,24,275)},
	{"Escola", CFrame.new(350,24,200)},
	{"Supermercado", CFrame.new(290,24,170)},
	{"Banco", CFrame.new(315,24,315)},
	{"Praia", CFrame.new(430,20,350)},
	{"Flamingo", CFrame.new(100,28,470)},
	{"Castelo", CFrame.new(80,50,80)},
	{"Estacao de Trem", CFrame.new(145,24,340)},
	{"Prefeitura", CFrame.new(530,24,305)},
	{"Igreja", CFrame.new(410,24,225)},
	{"Posto de Gasolina", CFrame.new(195,24,170)},
}
for _, loc in ipairs(locais) do
	tabT:Button(loc[1], function()
		BH:TeleportarCFrame(loc[2])
		Notify("Teleporte", "Indo para " .. loc[1])
	end)
end
tabT:Separator()
tabT:Title("Teleporte Personalizado")
local lblTP = tabT:Label("")
tabT:TextBox("Nome do jogador...", function(txt)
	local ok = BH:TeleportarJogador(txt)
	if ok then lblTP:Set("Teleportado para " .. txt); lblTP:SetCor(C.Success)
	else lblTP:Set("Jogador nao encontrado: " .. txt); lblTP:SetCor(C.Danger) end
end)
tabT:TextBox("X, Y, Z (ex: 100, 24, 100)", function(txt)
	local xStr, yStr, zStr = txt:match("([%d%.%-]+)%s*[,%s]+([%d%.%-]+)%s*[,%s]+([%d%.%-]+)")
	if xStr and yStr and zStr then
		local x = tonumber(xStr); local y = tonumber(yStr); local z = tonumber(zStr)
		if x and y and z then
			BH:TeleportarCoordenadas(x,y,z)
			lblTP:Set(string.format("Teleportado para %.0f, %.0f, %.0f", x, y, z))
			lblTP:SetCor(C.Success)
			return
		end
	end
	lblTP:Set("Formato invalido. Use: X, Y, Z"); lblTP:SetCor(C.Danger)
end)

-- TAB: MISC
local tabM = Janela:MakeTab("Misc")
tabM:Title("Extras")
tabM:Button("Resetar Personagem", function()
	BH:Reset()
	Notify("Reset", "Personagem resetado!")
end)
local lblGod = tabM:Label("Godmode: Desativado")
tabM:Button("Godmode (Imortal)", function()
	local s = BH:ToggleGodmode()
	lblGod:Set(s and "Godmode: Ativado" or "Godmode: Desativado")
	lblGod:SetCor(s and C.Success or C.TextDim)
end)
tabM:Separator()
tabM:Title("Personagem")
tabM:Button("Renascer", function()
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum:BreakJoints() end
end)
tabM:Button("Destruir GUI", function()
	Janela.Gui:Destroy()
	Notify("GUI", "Menu fechado. Recarregue o script para reabrir.")
end)

-- TAB: CONFIG
local tabC = Janela:MakeTab("Config")
tabC:Title("Configuracoes")
local lblCfg = tabC:Label("Nenhuma configuracao carregada.")
tabC:Button("Salvar Configuracao", function()
	local ok = BH:SalvarConfig()
	if ok then lblCfg:Set("Configuracao salva!"); lblCfg:SetCor(C.Success); Notify("Config", "Salva com sucesso!")
	else lblCfg:Set("Erro ao salvar!"); lblCfg:SetCor(C.Danger) end
end)
tabC:Button("Carregar Configuracao", function()
	local ok = BH:CarregarConfig()
	if ok then
		togESP.Update(); togInv.Update(); togNoc.Update(); togAFK.Update()
		lblSpd:Set("WalkSpeed: " .. BH.Speed); lblJmp:Set("JumpPower: " .. BH.JumpPower)
		lblCfg:Set("Configuracao carregada!"); lblCfg:SetCor(C.Success)
		Notify("Config", "Carregada com sucesso!")
	else
		lblCfg:Set("Nenhuma configuracao salva encontrada!"); lblCfg:SetCor(C.Danger)
	end
end)
tabC:Button("Resetar Configuracao", function()
	BH:SalvarConfig()
	lblCfg:Set("Configuracao resetada!"); lblCfg:SetCor(C.Warning)
end)
tabC:Separator()
tabC:Title("Sobre")
tabC:Label("Brookhaven RP Script v3.0")
tabC:Label("F1 / Insert = Abrir/Fechar menu")
tabC:Label("Criado para fins educacionais")

-- TOGGLE KEY
Input.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F1 or input.KeyCode == Enum.KeyCode.Insert then
		if Janela and Janela.Gui then Janela.Gui.Enabled = not Janela.Gui.Enabled end
	end
end)

Notify("Brookhaven RP", "Script carregado! Pressione F1 para abrir o menu.", 8)
print("â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—")
print("â•‘  BROOKHAVEN RP Script carregado!     â•‘")
print("â•‘  Pressione F1 ou Insert para o menu  â•‘")
print("â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•")
