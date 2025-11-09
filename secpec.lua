--[[ 
    Universal Roblox Script
    Features: WalkSpeed, JumpPower, Teleport, Auto-Collect, ESP, Notifications
    Tabs: Player, Misc, Settings
--]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- Tabs
local tabs = {}
local function createTab(name)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 120, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Position = UDim2.new(0, (#tabs*125), 0, 0)
    button.Text = name
    button.TextColor3 = Color3.new(1,1,1)
    button.Parent = mainFrame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 1, -40)
    frame.Position = UDim2.new(0, 5, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.Visible = false
    frame.Parent = mainFrame
    tabs[#tabs+1] = {button = button, frame = frame}
    button.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.frame.Visible = false
        end
        frame.Visible = true
    end)
    return frame
end

local playerTab = createTab("Player")
local miscTab = createTab("Misc")
local settingsTab = createTab("Settings")

-- Player Tab Features
-- WalkSpeed
local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(0, 150, 0, 30)
wsLabel.Position = UDim2.new(0, 10, 0, 10)
wsLabel.Text = "WalkSpeed:"
wsLabel.TextColor3 = Color3.new(1,1,1)
wsLabel.BackgroundTransparency = 1
wsLabel.Parent = playerTab

local wsBox = Instance.new("TextBox")
wsBox.Size = UDim2.new(0, 100, 0, 30)
wsBox.Position = UDim2.new(0, 160, 0, 10)
wsBox.PlaceholderText = "16"
wsBox.Text = ""
wsBox.Parent = playerTab

wsBox.FocusLost:Connect(function()
    local val = tonumber(wsBox.Text)
    if val then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-- JumpPower
local jpLabel = Instance.new("TextLabel")
jpLabel.Size = UDim2.new(0, 150, 0, 30)
jpLabel.Position = UDim2.new(0, 10, 0, 50)
jpLabel.Text = "JumpPower:"
jpLabel.TextColor3 = Color3.new(1,1,1)
jpLabel.BackgroundTransparency = 1
jpLabel.Parent = playerTab

local jpBox = Instance.new("TextBox")
jpBox.Size = UDim2.new(0, 100, 0, 30)
jpBox.Position = UDim2.new(0, 160, 0, 50)
jpBox.PlaceholderText = "50"
jpBox.Text = ""
jpBox.Parent = playerTab

jpBox.FocusLost:Connect(function()
    local val = tonumber(jpBox.Text)
    if val then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

-- Teleport (to mouse position)
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 150, 0, 30)
tpButton.Position = UDim2.new(0, 10, 0, 90)
tpButton.Text = "Teleport to Mouse"
tpButton.TextColor3 = Color3.new(1,1,1)
tpButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
tpButton.Parent = playerTab

tpButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,3,0))
    end
end)

-- Misc Tab Features
-- Simple ESP
local espEnabled = false
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 150, 0, 30)
espButton.Position = UDim2.new(0, 10, 0, 10)
espButton.Text = "Toggle ESP"
espButton.TextColor3 = Color3.new(1,1,1)
espButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
espButton.Parent = miscTab

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local highlight = player.Character and player.Character:FindFirstChild("Highlight")
            if espEnabled and not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "Highlight"
                highlight.FillColor = Color3.fromRGB(255,0,0)
                highlight.OutlineColor = Color3.fromRGB(255,255,255)
                highlight.Parent = player.Character
            elseif not espEnabled and highlight then
                highlight:Destroy()
            end
        end
    end
end)

-- Auto-Collect Example (coins named "Coin" in workspace)
local autoCollect = false
local acButton = Instance.new("TextButton")
acButton.Size = UDim2.new(0, 150, 0, 30)
acButton.Position = UDim2.new(0, 10, 0, 50)
acButton.Text = "Toggle Auto Collect"
acButton.TextColor3 = Color3.new(1,1,1)
acButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
acButton.Parent = miscTab

acButton.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
end)

RunService.RenderStepped:Connect(function()
    if autoCollect then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Coin" and obj:IsA("BasePart") then
                obj.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Settings Tab Features
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 100, 0, 30)
closeButton.Position = UDim2.new(0, 10, 0, 10)
closeButton.Text = "Toggle GUI"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
closeButton.Parent = settingsTab

closeButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

-- End of Script
