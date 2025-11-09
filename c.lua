--[[
Universal Roblox GUI Script
Features:
- Toggle with a key (Insert)
- Multiple tabs: Home, Player, Fun
- Buttons with example functions
- Fully customizable
--]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalScriptMenu"
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Universal Script Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24
Title.Parent = MainFrame

-- Tab Buttons
local Tabs = {"Home", "Player", "Fun"}
local TabFrames = {}

local ButtonHolder = Instance.new("Frame")
ButtonHolder.Size = UDim2.new(1, 0, 0, 30)
ButtonHolder.Position = UDim2.new(0, 0, 0, 50)
ButtonHolder.BackgroundTransparency = 1
ButtonHolder.Parent = MainFrame

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*100, 0, 0)
    btn.Text = tabName
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Parent = ButtonHolder

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, -30)
    frame.Position = UDim2.new(0, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Visible = (i == 1)
    frame.Parent = MainFrame
    TabFrames[tabName] = frame

    btn.MouseButton1Click:Connect(function()
        for name, f in pairs(TabFrames) do
            f.Visible = false
        end
        frame.Visible = true
    end)
end

-- Example Features
-- Home Tab
local homeFrame = TabFrames["Home"]
local homeLabel = Instance.new("TextLabel")
homeLabel.Size = UDim2.new(1, 0, 0, 50)
homeLabel.Position = UDim2.new(0, 0, 0, 0)
homeLabel.Text = "Welcome to the universal script!"
homeLabel.TextColor3 = Color3.fromRGB(255,255,255)
homeLabel.BackgroundTransparency = 1
homeLabel.Font = Enum.Font.SourceSans
homeLabel.TextSize = 20
homeLabel.Parent = homeFrame

-- Player Tab
local playerFrame = TabFrames["Player"]
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 200, 0, 50)
tpButton.Position = UDim2.new(0, 10, 0, 10)
tpButton.Text = "Teleport to Spawn"
tpButton.Font = Enum.Font.SourceSans
tpButton.TextSize = 18
tpButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
tpButton.TextColor3 = Color3.fromRGB(255,255,255)
tpButton.Parent = playerFrame

tpButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10,0)) -- Change spawn location
    end
end)

-- Fun Tab
local funFrame = TabFrames["Fun"]
local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0, 200, 0, 50)
jumpButton.Position = UDim2.new(0, 10, 0, 10)
jumpButton.Text = "Super Jump"
jumpButton.Font = Enum.Font.SourceSans
jumpButton.TextSize = 18
jumpButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
jumpButton.TextColor3 = Color3.fromRGB(255,255,255)
jumpButton.Parent = funFrame

jumpButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 200
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        wait(1)
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

-- Toggle Menu
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
