--// OmniWare V2 - Performance & Animation Update

-- SERVICES
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- VARIABLES
local injected = false
local keyValid = false
local gui = Instance.new("ScreenGui")
local mainFrame, injectButton, execFrame, statusLight
local themes = {
    ["Default"] = {MainColor = Color3.fromRGB(10,10,10), AccentColor = Color3.fromRGB(0, 170, 255)},
    ["Red"] = {MainColor = Color3.fromRGB(40,0,0), AccentColor = Color3.fromRGB(255,50,50)},
    ["Green"] = {MainColor = Color3.fromRGB(0,30,0), AccentColor = Color3.fromRGB(0,255,0)},
    ["Navy"] = {MainColor = Color3.fromRGB(0,0,40), AccentColor = Color3.fromRGB(0,100,255)}
}
local currentTheme = "Default"

-- FUNCTIONS

local function tweenObject(obj, goals, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goals)
    tween:Play()
    return tween
end

local function makeGlow(frame)
    local glow = Instance.new("UIStroke")
    glow.Color = themes[currentTheme].AccentColor
    glow.Thickness = 2
    glow.Transparency = 0.3
    glow.Parent = frame
end

local function createButton(text, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.BackgroundColor3 = themes[currentTheme].MainColor
    btn.TextColor3 = themes[currentTheme].AccentColor
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = text
    btn.Parent = parent
    makeGlow(btn)
    return btn
end

local function screenShake()
    local magnitude = 10
    for i = 1, 10 do
        local offset = Vector3.new(math.random(-magnitude, magnitude), math.random(-magnitude, magnitude), 0)
        camera.CFrame = camera.CFrame * CFrame.new(offset/50)
        RunService.RenderStepped:Wait()
    end
end

local function loadKeys()
    local keys = {}
    local success, response = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/DevilpieceDeveloper/OmniWare/refs/heads/main/keys.txt")
    end)

    if success and response then
        for key in string.gmatch(response, "[^\r\n]+") do
            table.insert(keys, key)
        end
    else
        warn("[OmniWare] Failed to fetch keys from GitHub.")
    end
    return keys
end

local function validateKey(inputKey)
    local keys = loadKeys()
    for _, key in ipairs(keys) do
        if key == inputKey then
            return true
        end
    end
    return false
end

local function setupGui()
    gui.Name = "OmniWareUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = game:GetService("CoreGui")

    -- Main Frame
    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = themes[currentTheme].MainColor
    mainFrame.Visible = true
    mainFrame.Parent = gui
    makeGlow(mainFrame)

    -- Inject Button
    injectButton = createButton("Inject", mainFrame)
    injectButton.Position = UDim2.new(0.5, -100, 0, 20)

    -- Status Light
    statusLight = Instance.new("Frame")
    statusLight.Size = UDim2.new(0, 20, 0, 20)
    statusLight.Position = UDim2.new(0.5, 90, 0, 30)
    statusLight.BackgroundColor3 = Color3.fromRGB(255,0,0)
    statusLight.Parent = mainFrame
    makeGlow(statusLight)

    -- Exec Frame
    execFrame = Instance.new("Frame")
    execFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
    execFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    execFrame.BackgroundColor3 = themes[currentTheme].MainColor
    execFrame.Visible = false
    execFrame.Parent = mainFrame
    makeGlow(execFrame)
end

local function toggleInject()
    injected = not injected
    if injected then
        statusLight.BackgroundColor3 = Color3.fromRGB(0,255,0)
        execFrame.Visible = true
    else
        statusLight.BackgroundColor3 = Color3.fromRGB(255,0,0)
        execFrame.Visible = false
    end
end

local function mobileCompat()
    if UserInputService.TouchEnabled then
        mainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
    end
end

local function setupKeySystem()
    -- Add Key System Frame here if you want
    -- Currently skipped for performance
    -- We'll call validateKey() on player input
end

local function setupHotkeys()
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)
end

-- TAB SYSTEM
local tabs = {}
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(0, 150, 1, 0)
tabContainer.Position = UDim2.new(0, 0, 0, 0)
tabContainer.BackgroundColor3 = themes[currentTheme].MainColor
tabContainer.Parent = mainFrame
makeGlow(tabContainer)

local pages = Instance.new("Frame")
pages.Size = UDim2.new(1, -150, 1, 0)
pages.Position = UDim2.new(0, 150, 0, 0)
pages.BackgroundTransparency = 1
pages.Parent = mainFrame

local function createTab(name)
    local tab = createButton(name, tabContainer)
    tab.Size = UDim2.new(1, 0, 0, 50)

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Position = UDim2.new(0, 0, 0, 0)
    page.BackgroundTransparency = 1
    page.Parent = pages

    tab.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Visible = false
        end
        page.Visible = true
    end)

    tabs[name] = page
end

-- Create default tabs
createTab("Home")
createTab("Status")
createTab("TP")
createTab("ClientSide OmniWare")
createTab("Settings")

-- MAIN EXECUTION
setupGui()
setupHotkeys()
mobileCompat()

injectButton.MouseButton1Click:Connect(toggleInject)
