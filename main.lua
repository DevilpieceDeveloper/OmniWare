-- FULL OMNIWARE SCRIPT
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local playerGui = player:WaitForChild("PlayerGui")

local themes = {
    Forest = {Outline = Color3.fromRGB(34, 139, 34), Accent = Color3.fromRGB(50, 205, 50)},
    Fire   = {Outline = Color3.fromRGB(255, 69, 0),   Accent = Color3.fromRGB(255, 140, 0)},
    Sea    = {Outline = Color3.fromRGB(0, 191, 255),  Accent = Color3.fromRGB(135, 206, 250)}
}
local currentTheme = "Sea"

local function applyTheme(obj)
    obj.UIStroke.Color = themes[currentTheme].Outline
end

local function makeHoverScale(obj)
    local origSize = obj.Size
    obj.MouseEnter:Connect(function()
        obj:TweenSize(UDim2.new(origSize.X.Scale * 1.001, origSize.X.Offset * 1.001, origSize.Y.Scale * 1.001, origSize.Y.Offset * 1.001), "Out", "Quad", 0.1, true)
    end)
    obj.MouseLeave:Connect(function()
        obj:TweenSize(origSize, "Out", "Quad", 0.1, true)
    end)
end

local function makeButton(text, parent)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(1, -10, 0, 40)
    button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    button.TextColor3 = themes[currentTheme].Accent
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Name = text
    button.ClipsDescendants = true
    button.Parent = parent

    local uicorner = Instance.new("UICorner", button)
    uicorner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", button)
    stroke.Thickness = 2
    stroke.Color = themes[currentTheme].Outline

    makeHoverScale(button)
    return button
end

-- Main UI setup
local mainUI = Instance.new("ScreenGui", playerGui)
mainUI.Name = "OmniWare"

local bgFrame = Instance.new("Frame", mainUI)
bgFrame.Size = UDim2.new(0, 900, 0, 500)
bgFrame.Position = UDim2.new(0.5, -450, 0.5, -250)
bgFrame.BackgroundColor3 = Color3.new(0, 0, 0)
bgFrame.BorderSizePixel = 0

local drag = Instance.new("Frame", bgFrame)
drag.Size = UDim2.new(1, 0, 0, 40)
drag.BackgroundTransparency = 1

local uicorner = Instance.new("UICorner", bgFrame)
uicorner.CornerRadius = UDim.new(0, 18)

local stroke = Instance.new("UIStroke", bgFrame)
stroke.Color = themes[currentTheme].Outline
stroke.Thickness = 3

local uilist = Instance.new("UIListLayout", bgFrame)
uilist.FillDirection = Enum.FillDirection.Horizontal
uilist.SortOrder = Enum.SortOrder.LayoutOrder

-- Side tab buttons
local tabColumn = Instance.new("Frame", bgFrame)
tabColumn.Size = UDim2.new(0, 160, 1, 0)
tabColumn.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabColumn)
tabLayout.FillDirection = Enum.FillDirection.Vertical
tabLayout.Padding = UDim.new(0, 10)

local pages = {
    General = Instance.new("Frame"),
    Executor = Instance.new("Frame"),
    TP = Instance.new("ScrollingFrame"),
    Settings = Instance.new("Frame")
}

for name, frame in pairs(pages) do
    frame.Name = name
    frame.Parent = bgFrame
    frame.Size = UDim2.new(1, -170, 1, -10)
    frame.Position = UDim2.new(0, 170, 0, 5)
    frame.Visible = name == "General"
    frame.BackgroundColor3 = Color3.new(0, 0, 0)

    local fcorner = Instance.new("UICorner", frame)
    fcorner.CornerRadius = UDim.new(0, 12)

    local fstroke = Instance.new("UIStroke", frame)
    fstroke.Color = themes[currentTheme].Outline
    fstroke.Thickness = 2

    if name == "TP" then
        frame.CanvasSize = UDim2.new(0, 0, 10, 0)
        frame.ScrollBarThickness = 6
    end
end

-- Tab Button Control
local function switchTab(tab)
    for name, frame in pairs(pages) do
        frame.Visible = (name == tab)
    end
end

for _, tabName in ipairs({"General", "Executor", "TP", "Settings"}) do
    local btn = makeButton(tabName, tabColumn)
    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

-- FPS Display
local fpsLabel = Instance.new("TextLabel", pages.General)
fpsLabel.Text = "FPS:"
fpsLabel.Size = UDim2.new(0, 200, 0, 30)
fpsLabel.Position = UDim2.new(0, 200, 1, -40)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = themes[currentTheme].Accent
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextSize = 18
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Game Name Display
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local gameLabel = Instance.new("TextLabel", pages.General)
gameLabel.Text = "Game: " .. gameName
gameLabel.Size = UDim2.new(1, -20, 0, 30)
gameLabel.Position = UDim2.new(0, 10, 0, 10)
gameLabel.BackgroundTransparency = 1
gameLabel.TextColor3 = themes[currentTheme].Accent
gameLabel.Font = Enum.Font.Gotham
gameLabel.TextSize = 20
gameLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Update FPS
local frames = 0
local lastTime = tick()
RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. tostring(frames)
        frames = 0
        lastTime = tick()
    end
end)

-- Part 2: Tabs and Features Setup (Executor, General, TP, Settings)

local tabs = {
	General = Instance.new("Frame"),
	Executor = Instance.new("Frame"),
	TP = Instance.new("Frame"),
	Settings = Instance.new("Frame")
}

for name, tab in pairs(tabs) do
	tab.Name = name
	tab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	tab.Size = UDim2.new(1, 0, 1, 0)
	tab.Position = UDim2.new(0, 0, 0, 0)
	tab.Visible = false
	tab.BorderSizePixel = 0
	tab.Parent = mainFrame
end

-- Make "General" tab visible by default
tabs.General.Visible = true

-- Tab Button Function
local function switchTab(tabName)
	for name, frame in pairs(tabs) do
		frame.Visible = (name == tabName)
	end
end

-- Create Tab Buttons
local tabNames = {"General", "Executor", "TP", "Settings"}
for i, name in ipairs(tabNames) do
	local btn = createButton(name, theme.accent)
	btn.Position = UDim2.new(0.03, 0, 0.1 + ((i - 1) * 0.11), 0)
	btn.Size = UDim2.new(0.22, 0, 0.1, 0)
	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)
	btn.Parent = mainFrame
end

-- General Tab Content
local welcome = Instance.new("TextLabel", tabs.General)
welcome.Text = "Welcome, " .. plr.DisplayName
welcome.Font = Enum.Font.SourceSans
welcome.TextColor3 = theme.accent
welcome.TextSize = 20
welcome.BackgroundTransparency = 1
welcome.Position = UDim2.new(0.32, 0, 0.8, 0)
welcome.Size = UDim2.new(0.4, 0, 0.05, 0)

local fpsLabel = Instance.new("TextLabel", tabs.General)
fpsLabel.Text = "FPS: "
fpsLabel.Font = Enum.Font.SourceSans
fpsLabel.TextColor3 = theme.accent
fpsLabel.TextSize = 20
fpsLabel.BackgroundTransparency = 1
fpsLabel.Position = UDim2.new(0.6, 0, 0.8, 0)
fpsLabel.Size = UDim2.new(0.2, 0, 0.05, 0)

local runService = game:GetService("RunService")
local lastTime = tick()
local frameCount = 0

runService.RenderStepped:Connect(function()
	frameCount += 1
	local now = tick()
	if now - lastTime >= 1 then
		fpsLabel.Text = "FPS: " .. frameCount
		frameCount = 0
		lastTime = now
	end
end)

-- Display Game Name
local gameLabel = Instance.new("TextLabel", tabs.General)
gameLabel.Text = "Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
gameLabel.Font = Enum.Font.SourceSans
gameLabel.TextColor3 = theme.accent
gameLabel.TextSize = 20
gameLabel.BackgroundTransparency = 1
gameLabel.Position = UDim2.new(0.32, 0, 0.85, 0)
gameLabel.Size = UDim2.new(0.5, 0, 0.05, 0)

-- Drawing UI
local drawButton = createButton("Build Drawing", theme.accent)
drawButton.Position = UDim2.new(0.4, 0, 0.3, 0)
drawButton.Parent = tabs.General

drawButton.MouseButton1Click:Connect(function()
	for i = 1, 10 do
		local part = Instance.new("Part")
		part.Anchored = true
		part.Size = Vector3.new(1, 1, 1)
		part.Position = plr.Character.Head.Position + Vector3.new(i, 5, 0)
		part.Parent = workspace
	end
end)

-- UNC Loadstring
local uncBtn = createButton("UNC Test", theme.accent)
uncBtn.Position = UDim2.new(0.4, 0, 0.4, 0)
uncBtn.Parent = tabs.General
uncBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/unified-naming-convention/NamingStandard/main/UNCCheckEnv.lua", true))()
end)

-- Executor
local execBox = Instance.new("TextBox", tabs.Executor)
execBox.PlaceholderText = "-- Script Here"
execBox.MultiLine = true
execBox.Size = UDim2.new(0.9, 0, 0.6, 0)
execBox.Position = UDim2.new(0.05, 0, 0.1, 0)
execBox.TextScaled = true
execBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
execBox.TextColor3 = theme.accent
execBox.Font = Enum.Font.Code
execBox.BorderSizePixel = 0

local runBtn = createButton("Execute", theme.accent)
runBtn.Position = UDim2.new(0.4, 0, 0.75, 0)
runBtn.Parent = tabs.Executor

runBtn.MouseButton1Click:Connect(function()
	local code = execBox.Text
	local func, err = loadstring(code)
	if func then
		pcall(func)
	end
end)

-- Settings Theme Change
local themeBox = Instance.new("TextLabel", tabs.Settings)
themeBox.Text = "Themes"
themeBox.Font = Enum.Font.SourceSansBold
themeBox.TextColor3 = theme.accent
themeBox.TextSize = 24
themeBox.Position = UDim2.new(0.35, 0, 0.1, 0)
themeBox.Size = UDim2.new(0.3, 0, 0.05, 0)
themeBox.BackgroundTransparency = 1

local themeBtns = {
	Forest = Color3.fromRGB(0, 255, 140),
	Fire = Color3.fromRGB(255, 70, 70),
	Sea = Color3.fromRGB(70, 170, 255)
}

local y = 0.2
for name, col in pairs(themeBtns) do
	local btn = createButton(name, col)
	btn.Position = UDim2.new(0.35, 0, y, 0)
	btn.Parent = tabs.Settings
	btn.MouseButton1Click:Connect(function()
		theme = {
			background = Color3.fromRGB(0, 0, 0),
			accent = col
		}
		refreshTheme()
	end)
	y += 0.1
end
-- Part 3: TP, RGB Input, Final Touches

-- Teleport System
local tpLabel = Instance.new("TextLabel", tabs.TP)
tpLabel.Text = "Enter coordinates (x, y, z):"
tpLabel.Font = Enum.Font.SourceSans
tpLabel.TextColor3 = theme.accent
tpLabel.TextSize = 20
tpLabel.Position = UDim2.new(0.3, 0, 0.15, 0)
tpLabel.Size = UDim2.new(0.5, 0, 0.05, 0)
tpLabel.BackgroundTransparency = 1

local coordBox = Instance.new("TextBox", tabs.TP)
coordBox.PlaceholderText = "Ex: 10,5,20"
coordBox.Text = ""
coordBox.Size = UDim2.new(0.5, 0, 0.08, 0)
coordBox.Position = UDim2.new(0.3, 0, 0.25, 0)
coordBox.TextScaled = true
coordBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
coordBox.TextColor3 = theme.accent
coordBox.Font = Enum.Font.Code
coordBox.BorderSizePixel = 0

local tpBtn = createButton("Teleport", theme.accent)
tpBtn.Position = UDim2.new(0.4, 0, 0.4, 0)
tpBtn.Parent = tabs.TP
tpBtn.MouseButton1Click:Connect(function()
	local coords = string.split(coordBox.Text, ",")
	if #coords == 3 then
		local x = tonumber(coords[1])
		local y = tonumber(coords[2])
		local z = tonumber(coords[3])
		if x and y and z and plr.Character then
			plr.Character:MoveTo(Vector3.new(x, y, z))
		end
	end
end)

-- RGB Color Input
local rgbBox = Instance.new("TextBox", tabs.Settings)
rgbBox.PlaceholderText = "Enter RGB color"
rgbBox.Text = ""
rgbBox.Size = UDim2.new(0.4, 0, 0.08, 0)
rgbBox.Position = UDim2.new(0.3, 0, 0.6, 0)
rgbBox.TextScaled = true
rgbBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
rgbBox.TextColor3 = theme.accent
rgbBox.Font = Enum.Font.Code
rgbBox.BorderSizePixel = 0

local rgbApplyBtn = createButton("Apply Color", theme.accent)
rgbApplyBtn.Position = UDim2.new(0.35, 0, 0.7, 0)
rgbApplyBtn.Parent = tabs.Settings

rgbApplyBtn.MouseButton1Click:Connect(function()
	local rgb = string.split(rgbBox.Text, ",")
	if #rgb == 3 then
		local r, g, b = tonumber(rgb[1]), tonumber(rgb[2]), tonumber(rgb[3])
		if r and g and b then
			theme.accent = Color3.fromRGB(r, g, b)
			refreshTheme()
		end
	end
end)

-- Webhook for valid key (OPTIONAL)
local webhookUrl = "https://discord.com/api/webhooks/1370959285441396737/T4Y0oqpix05ukD6IDW927UPev6olC8oCOtf7ggGRV7oNEs-Tsqus4YtGsuXMxUcM0cB4" -- Replace if desired

-- Bounce animation for OmniWare button
local bounce = Instance.new("UIScale", toggleBtn)
bounce.Scale = 1
local ts = game:GetService("TweenService")

local function animateBounce()
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = ts:Create(bounce, tweenInfo, {Scale = 1.2})
	tween:Play()
	tween.Completed:Connect(function()
		ts:Create(bounce, TweenInfo.new(0.15), {Scale = 1}):Play()
	end)
end

toggleBtn.MouseButton1Click:Connect(animateBounce)

-- Optional webhook call after correct key
submitBtn.MouseButton1Click:Connect(function()
	if keyBox.Text == key then
		mainFrame.Visible = true
		keyFrame.Visible = false
		if webhookUrl and webhookUrl ~= "" then
			pcall(function()
				syn.request({
					Url = webhookUrl,
					Method = "POST",
					Headers = {["Content-Type"] = "application/json"},
					Body = game:GetService("HttpService"):JSONEncode({
						content = "Key used: " .. key .. " by " .. plr.Name
					})
				})
			end)
		end
	end
end)

-- Click Sound (optional)
local clickSound = Instance.new("Sound", toggleBtn)
clickSound.SoundId = "rbxassetid://9118823105"
clickSound.Volume = 0.8
toggleBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
end)

