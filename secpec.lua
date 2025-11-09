-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ESP Setup
local espEnabled = false
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP_Folder"
espFolder.Parent = game:GetService("CoreGui")

local function createESP(player)
    if player == LocalPlayer then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Size = Vector3.new(4, 6, 2)
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Parent = espFolder

    local nameTag = Instance.new("BillboardGui")
    nameTag.Size = UDim2.new(0, 100, 0, 50)
    nameTag.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    nameTag.AlwaysOnTop = true
    nameTag.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextScaled = true
    label.Text = player.Name
    label.Parent = nameTag
end

-- Fly Setup
local flying = false
local flySpeed = 50
local flyDirection = Vector3.new(0,0,0)
local flyBodyVelocity = Instance.new("BodyVelocity")
flyBodyVelocity.MaxForce = Vector3.new(400000,400000,400000)
flyBodyVelocity.Velocity = Vector3.new(0,0,0)

local function startFly()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    flyBodyVelocity.Parent = root
    flying = true
end

local function stopFly()
    flying = false
    flyBodyVelocity.Parent = nil
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then
            stopFly()
        else
            startFly()
        end
    end
end)

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

-- Update Loop
RunService.RenderStepped:Connect(function(delta)
    -- ESP
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local box = espFolder:FindFirstChild(player.Name.."Box")
                if not box then
                    createESP(player)
                end
            end
        end
    else
        espFolder:ClearAllChildren()
    end

    -- Fly
    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        flyBodyVelocity.Velocity = flyDirection.Unit * flySpeed
    end
end)

-- Toggle ESP (example key: E)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.E then
        espEnabled = not espEnabled
    end
end)

print("ESP & Fly loaded! Press 'E' to toggle ESP, 'F' to toggle Fly.")
