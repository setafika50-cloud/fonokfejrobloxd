-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables
local espEnabled = false
local flying = false
local flySpeed = 50
local flyDirection = Vector3.new(0,0,0)
local flyBodyVelocity = Instance.new("BodyVelocity")
flyBodyVelocity.MaxForce = Vector3.new(400000,400000,400000)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- Drag Functionality
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tabs
local tabs = {}
local function createTab(name)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 90, 0, 25)
    button.Position = UDim2.new(0, (#tabs*95)+5, 0, 5)
    button.BackgroundColor3 = Color3.fromRGB(60,60,60)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Parent = mainFrame

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 1, -40)
    frame.Position = UDim2.new(0, 5, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    frame.Visible = false
    frame.Parent = mainFrame

    button.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do t.frame.Visible = false end
        frame.Visible = true
    end)

    tabs[#tabs+1] = {button=button, frame=frame}
    return frame
end

local playerTab = createTab("Player")
local miscTab = createTab("Misc")
local settingsTab = createTab("Settings")

-- Player Tab
-- WalkSpeed
local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(0, 100, 0, 20)
wsLabel.Position = UDim2.new(0, 10, 0, 10)
wsLabel.Text = "WalkSpeed"
wsLabel.BackgroundTransparency = 1
wsLabel.TextColor3 = Color3.new(1,1,1)
wsLabel.Parent = playerTab

local wsBox = Instance.new("TextBox")
wsBox.Size = UDim2.new(0, 50, 0, 20)
wsBox.Position = UDim2.new(0, 120, 0, 10)
wsBox.PlaceholderText = "16"
wsBox.Parent = playerTab
wsBox.FocusLost:Connect(function()
    local val = tonumber(wsBox.Text)
    if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-- JumpPower
local jpLabel = Instance.new("TextLabel")
jpLabel.Size = UDim2.new(0, 100, 0, 20)
jpLabel.Position = UDim2.new(0, 10, 0, 40)
jpLabel.Text = "JumpPower"
jpLabel.BackgroundTransparency = 1
jpLabel.TextColor3 = Color3.new(1,1,1)
jpLabel.Parent = playerTab

local jpBox = Instance.new("TextBox")
jpBox.Size = UDim2.new(0, 50, 0, 20)
jpBox.Position = UDim2.new(0, 120, 0, 40)
jpBox.PlaceholderText = "50"
jpBox.Parent = playerTab
jpBox.FocusLost:Connect(function()
    local val = tonumber(jpBox.Text)
    if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

-- Teleport to mouse
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 150, 0, 25)
tpButton.Position = UDim2.new(0, 10, 0, 70)
tpButton.Text = "Teleport to Mouse"
tpButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
tpButton.TextColor3 = Color3.new(1,1,1)
tpButton.Parent = playerTab

tpButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer:GetMouse().Hit.Position + Vector3.new(0,3,0))
    end
end)

-- Misc Tab
-- ESP Toggle
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 150, 0, 25)
espButton.Position = UDim2.new(0, 10, 0, 10)
espButton.Text = "Toggle ESP (E)"
espButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
espButton.TextColor3 = Color3.new(1,1,1)
espButton.Parent = miscTab

-- Auto-Collect Example
local autoCollect = false
local acButton = Instance.new("TextButton")
acButton.Size = UDim2.new(0, 150, 0, 25)
acButton.Position = UDim2.new(0, 10, 0, 40)
acButton.Text = "Toggle Auto Collect"
acButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
acButton.TextColor3 = Color3.new(1,1,1)
acButton.Parent = miscTab

acButton.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
end)

-- Settings Tab
local guiToggle = Instance.new("TextButton")
guiToggle.Size = UDim2.new(0, 150, 0, 25)
guiToggle.Position = UDim2.new(0, 10, 0, 10)
guiToggle.Text = "Toggle GUI"
guiToggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
guiToggle.TextColor3 = Color3.new(1,1,1)
guiToggle.Parent = settingsTab

guiToggle.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

-- ESP Logic
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP_Folder"
espFolder.Parent = game:GetService("CoreGui")

local function createESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = root
    box.Color3 = Color3.fromRGB(255,0,0)
    box.Size = Vector3.new(4,6,2)
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Parent = espFolder

    local nameTag = Instance.new("BillboardGui")
    nameTag.Size = UDim2.new(0,100,0,50)
    nameTag.Adornee = root
    nameTag.AlwaysOnTop = true
    nameTag.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextScaled = true
    label.TextColor3 = Color3.new(1,1,1)
    label.Parent = nameTag
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.E then
        espEnabled = not espEnabled
    elseif input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            flyBodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        else
            flyBodyVelocity.Parent = nil
        end
    end
end)

-- Fly Controls
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then flyDirection = flyDirection + Vector3.new(0,0,-1) end
        if input.KeyCode == Enum.KeyCode.S then flyDirection = flyDirection + Vector3.new(0,0,1) end
        if input.KeyCode == Enum.KeyCode.A then flyDirection = flyDirection + Vector3.new(-1,0,0) end
        if input.KeyCode == Enum.KeyCode.D then flyDirection = flyDirection + Vector3.new(1,0,0) end
        if input.KeyCode == Enum.KeyCode.Space then flyDirection = flyDirection + Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyDirection = flyDirection + Vector3.new(0,-1,0) end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then flyDirection = flyDirection - Vector3.new(0,0,-1) end
        if input.KeyCode == Enum.KeyCode.S then flyDirection = flyDirection - Vector3.new(0,0,1) end
        if input.KeyCode == Enum.KeyCode.A then flyDirection = flyDirection - Vector3.new(-1,0,0) end
        if input.KeyCode == Enum.KeyCode.D then flyDirection = flyDirection - Vector3.new(1,0,0) end
        if input.KeyCode == Enum.KeyCode.Space then flyDirection = flyDirection - Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyDirection = flyDirection - Vector3.new(0,-1,0) end
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- ESP
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local exists = false
                for _, obj in pairs(espFolder:GetChildren()) do
                    if obj:IsA("BoxHandleAdornment") and obj.Adornee == player.Character.HumanoidRootPart then
                        exists = true
                    end
                end
                if not exists then
                    createESP(player)
                end
            end
        end
    else
        espFolder:ClearAllChildren()
    end

    -- Auto Collect
    if autoCollect and LocalPlayer.Character then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Coin" and obj:IsA("BasePart") then
                obj.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end

    -- Fly
    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if flyDirection.Magnitude > 0 then
            flyBodyVelocity.Velocity = flyDirection.Unit * flySpeed
        else
            flyBodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end
end)

print("Universal Hub loaded! E = ESP, F = Fly")
