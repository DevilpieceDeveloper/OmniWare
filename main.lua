-- OmniWare V2 BETA
-- Full LocalScript | Made for Workspace | No RepStorage | Mobile Friendly

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local themes = {
    ["Default"] = {Color3.fromRGB(0, 170, 255), Color3.fromRGB(10, 10, 10)},
    ["Red-Orange"] = {Color3.fromRGB(255, 80, 0), Color3.fromRGB(10, 10, 10)},
    ["Navy"] = {Color3.fromRGB(0, 0, 80), Color3.fromRGB(10, 10, 10)},
    ["Green"] = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(10, 10, 10)},
    ["Purple Dream"] = {Color3.fromRGB(140, 0, 255), Color3.fromRGB(10, 10, 10)},
    ["Cyber Yellow"] = {Color3.fromRGB(255, 221, 0), Color3.fromRGB(10, 10, 10)},
    ["Abyss"] = {Color3.fromRGB(10, 10, 60), Color3.fromRGB(10, 10, 10)},
    ["Neo Pink"] = {Color3.fromRGB(255, 0, 150), Color3.fromRGB(10, 10, 10)}
}
local currentTheme = "Default"

local execEnabled = false
local keyEntered = false

-- Create GUI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "OmniWareGUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BackgroundColor3 = themes[currentTheme][2]
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false

local uICorner = Instance.new("UICorner", mainFrame)
uICorner.CornerRadius = UDim.new(0, 8)

local glow = Instance.new("UIStroke", mainFrame)
glow.Thickness = 3
glow.Color = themes[currentTheme][1]

-- Create Topbar
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = themes[currentTheme][1]
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "OmniWare"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)

-- Create Tabs
local tabButtons = {}
local tabFrames = {}

local tabNames = {"Home", "Status", "TP", "OmniWare", "Settings"}

local tabsHolder = Instance.new("Frame", mainFrame)
tabsHolder.Position = UDim2.new(0, 0, 0, 30)
tabsHolder.Size = UDim2.new(0, 100, 1, -30)
tabsHolder.BackgroundTransparency = 1

local function createTab(name)
    local btn = Instance.new("TextButton", tabsHolder)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundTransparency = 0.8
    btn.BackgroundColor3 = themes[currentTheme][2]
    btn.TextColor3 = themes[currentTheme][1]
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name

    table.insert(tabButtons, btn)

    local frame = Instance.new("Frame", mainFrame)
    frame.Position = UDim2.new(0, 100, 0, 30)
    frame.Size = UDim2.new(1, -100, 1, -30)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = themes[currentTheme][2]
    frame.Visible = false

    table.insert(tabFrames, frame)

    btn.MouseButton1Click:Connect(function()
        for i,v in pairs(tabFrames) do
            v.Visible = false
        end
        frame.Visible = true
    end)
end

for _, name in ipairs(tabNames) do
    createTab(name)
end

-- Make Home tab visible by default
tabFrames[1].Visible = true

-- [TP Tab] Teleport player or camera
local tpTab = tabFrames[3]

local tpInput = Instance.new("TextBox", tpTab)
tpInput.Position = UDim2.new(0, 10, 0, 10)
tpInput.Size = UDim2.new(0, 200, 0, 30)
tpInput.PlaceholderText = "Enter Player Name"
tpInput.Font = Enum.Font.Gotham
tpInput.TextSize = 14
tpInput.BackgroundColor3 = Color3.fromRGB(20,20,20)
tpInput.TextColor3 = Color3.fromRGB(255,255,255)

local tpButton = Instance.new("TextButton", tpTab)
tpButton.Position = UDim2.new(0, 10, 0, 50)
tpButton.Size = UDim2.new(0, 200, 0, 30)
tpButton.Text = "Teleport"
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 14
tpButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
tpButton.TextColor3 = Color3.fromRGB(255,255,255)

local toggleCam = false
local toggleButton = Instance.new("TextButton", tpTab)
toggleButton.Position = UDim2.new(0, 220, 0, 10)
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Text = "TP Camera: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)

toggleButton.MouseButton1Click:Connect(function()
    toggleCam = not toggleCam
    toggleButton.Text = toggleCam and "TP Camera: ON" or "TP Camera: OFF"
end)

tpButton.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(tpInput.Text)
    if target and target.Character then
        if toggleCam then
            workspace.CurrentCamera.CFrame = target.Character.HumanoidRootPart.CFrame
        else
            LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- [OmniWare Executor] 
local omniTab = tabFrames[4]
local codeBox = Instance.new("TextBox", omniTab)
codeBox.Position = UDim2.new(0,10,0,10)
codeBox.Size = UDim2.new(1,-20,0.7, -20)
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.PlaceholderText = "Write code here..."
codeBox.TextWrapped = true
codeBox.TextScaled = false
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 14
codeBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
codeBox.TextColor3 = Color3.fromRGB(0,255,0)

local injectButton = Instance.new("TextButton", omniTab)
injectButton.Position = UDim2.new(0,10,0.75,0)
injectButton.Size = UDim2.new(0, 150, 0, 30)
injectButton.Text = "Inject"
injectButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
injectButton.TextColor3 = Color3.fromRGB(255,255,255)

local injectStatus = Instance.new("Frame", injectButton)
injectStatus.Size = UDim2.new(0, 10, 0, 10)
injectStatus.Position = UDim2.new(1, -15, 0.5, -5)
injectStatus.BackgroundColor3 = Color3.fromRGB(255,0,0)
injectStatus.BorderSizePixel = 0

injectButton.MouseButton1Click:Connect(function()
    execEnabled = not execEnabled
    injectStatus.BackgroundColor3 = execEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)

local runButton = Instance.new("TextButton", omniTab)
runButton.Position = UDim2.new(0, 170, 0.75, 0)
runButton.Size = UDim2.new(0, 150, 0, 30)
runButton.Text = "Execute"
runButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
runButton.TextColor3 = Color3.fromRGB(255,255,255)

runButton.MouseButton1Click:Connect(function()
    if execEnabled then
        local scr = Instance.new("LocalScript", workspace)
        scr.Source = codeBox.Text
    else
        warn("OmniWare: Inject first before executing!")
    end
end)

-- [Settings Tab - Color Customizer coming in V2.1!]

-- [Toggle GUI with RightShift]
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- [Create OmniWare Button]
local button = Instance.new("TextButton")
button.Size = UDim2.new(0,150,0,50)
button.Position = UDim2.new(0, 5, 0.7, 0)
button.BackgroundColor3 = Color3.fromRGB(30,30,30)
button.TextColor3 = Color3.fromRGB(0,200,255)
button.Text = "OmniWare"
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

