-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local toggleKey = Enum.KeyCode.G -- Menü megjelenítés G betűvel
local menuEnabled = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalMenu"
screenGui.Parent = playerGui
screenGui.Enabled = menuEnabled

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Tabs container
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, 0, 0, 30)
tabsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabsFrame.Parent = mainFrame

-- Buttons container
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, 0, 1, -30)
buttonsFrame.Position = UDim2.new(0, 0, 0, 30)
buttonsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
buttonsFrame.Parent = mainFrame

-- Helper function to create tabs
local function createTab(tabName)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.Text = tabName
    tabButton.Parent = tabsFrame
    tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    tabButton.TextColor3 = Color3.new(1, 1, 1)

    tabButton.MouseButton1Click:Connect(function()
        -- Hide all other buttons
        for _, frame in ipairs(buttonsFrame:GetChildren()) do
            if frame:IsA("Frame") then
                frame.Visible = false
            end
        end
        -- Show current tab
        local tabFrame = buttonsFrame:FindFirstChild(tabName)
        if tabFrame then
            tabFrame.Visible = true
        end
    end)

    -- Create content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = tabName
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = buttonsFrame

    return contentFrame
end

-- Example tabs
local mainTab = createTab("Main")
local funTab = createTab("Fun")

-- Add buttons to tabs
local function createButton(parent, buttonText, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 40)
    button.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 45)
    button.Text = buttonText
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Parent = parent

    button.MouseButton1Click:Connect(callback)
end

-- Sample buttons
createButton(mainTab, "Print Hello", function()
    print("Hello World!")
end)

createButton(funTab, "Change Background Color", function()
    mainFrame.BackgroundColor3 = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
end)

-- Keybind toggle (G betű)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == toggleKey then
        menuEnabled = not menuEnabled
        screenGui.Enabled = menuEnabled
    end
end)
