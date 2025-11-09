-- Roblox Script with Tabs for God Mode, Fly, and Auto Stealer

-- Create a ScreenGui to hold the tabs
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Create a Frame for the tabs
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(0, 200, 0, 300)
tabFrame.Position = UDim2.new(0, 10, 0, 10)
tabFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
tabFrame.Parent = screenGui

-- Create a TabButton for God Mode
local godModeButton = Instance.new("TextButton")
godModeButton.Size = UDim2.new(1, 0, 0, 50)
godModeButton.Position = UDim2.new(0, 0, 0, 0)
godModeButton.Text = "God Mode"
godModeButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
godModeButton.Parent = tabFrame

-- Create a TabButton for Fly
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, 0, 0, 50)
flyButton.Position = UDim2.new(0, 0, 0, 50)
flyButton.Text = "Fly"
flyButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
flyButton.Parent = tabFrame

-- Create a TabButton for Auto Stealer
local autoStealerButton = Instance.new("TextButton")
autoStealerButton.Size = UDim2.new(1, 0, 0, 50)
autoStealerButton.Position = UDim2.new(0, 0, 0, 100)
autoStealerButton.Text = "Auto Stealer"
autoStealerButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
autoStealerButton.Parent = tabFrame

-- God Mode Function
local function godMode()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.PlatformStand = true
    humanoid.WalkSpeed = 50
    humanoid.JumpPower = 100

    while true do
        humanoid.Health = 100
        wait(1)
    end
end

-- Fly Function
local function fly()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.cframe = character.PrimaryPart.CFrame
    bodyGyro.Parent = character.PrimaryPart

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.velocity = Vector3.new(0, 0, 0)
    bodyVelocity.maxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = character.PrimaryPart

    local bg = bodyGyro
    local bv = bodyVelocity

    local function update()
        bg.cframe = character.PrimaryPart.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
        bv.velocity = (character.PrimaryPart.CFrame.lookVector * Vector3.new(0, 0, -1)).unit * 50
    end

    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if input.KeyCode == Enum.KeyCode.W then
                bv.velocity = (character.PrimaryPart.CFrame.lookVector * Vector3.new(0, 0, -1)).unit * 50
            elseif input.KeyCode == Enum.KeyCode.S then
                bv.velocity = (character.PrimaryPart.CFrame.lookVector * Vector3.new(0, 0, 1)).unit * 50
            elseif input.KeyCode == Enum.KeyCode.A then
                bv.velocity = (character.PrimaryPart.CFrame.lookVector * Vector3.new(-1, 0, 0)).unit * 50
            elseif input.KeyCode == Enum.KeyCode.D then
                bv.velocity = (character.PrimaryPart.CFrame.lookVector * Vector3.new(1, 0, 0)).unit * 50
            end
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(update)
end

-- Auto Stealer Function
local function autoStealer()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    while true do
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (character.PrimaryPart.Position - v.Character.PrimaryPart.Position).magnitude
                if distance < 20 then
                    local brainrot = v.Character:FindFirstChild("Brainrot")
                    if brainrot then
                        brainrot.Parent = character
                        wait(1)
                    end
                end
            end
        end
        wait(1)
    end
end

-- Connect buttons to functions
godModeButton.MouseButton1Click:Connect(godMode)
flyButton.MouseButton1Click:Connect(fly)
autoStealerButton.MouseButton1Click:Connect(autoStealer)
