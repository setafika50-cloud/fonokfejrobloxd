-- Roblox Modern GUI - Library Nélkül
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true
MainFrame.AutoButtonColor = false

-- UI Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "🌌 Universal GUI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = MainFrame

-- Tabs Frame (Left)
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0, 120, 1, -50)
TabsFrame.Position = UDim2.new(0, 0, 0, 50)
TabsFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

local TabsUICorner = Instance.new("UICorner")
TabsUICorner.CornerRadius = UDim.new(0, 12)
TabsUICorner.Parent = TabsFrame

-- Content Frame (Right)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -120, 1, -50)
ContentFrame.Position = UDim2.new(0, 120, 0, 50)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentUICorner = Instance.new("UICorner")
ContentUICorner.CornerRadius = UDim.new(0, 12)
ContentUICorner.Parent = ContentFrame

-- Helper function to create tabs
local function CreateTabButton(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Position = UDim2.new(0, 5, 0, (#TabsFrame:GetChildren()-1)*45)
    Button.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255,255,255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 18
    Button.BorderSizePixel = 0
    Button.Parent = TabsFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    return Button
end

-- Example tabs
local tabs = {"Player","Teleports","AutoFarm","Misc"}
local tabButtons = {}
local currentTab = nil

for _, tname in pairs(tabs) do
    local btn = CreateTabButton(tname)
    table.insert(tabButtons, btn)
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)

        currentTab = tname
        UpdateContent()
    end)
end

-- Content Elements
local ContentElements = {}

local function ClearContent()
    for _, e in pairs(ContentElements) do
        e:Destroy()
    end
    ContentElements = {}
end

local function UpdateContent()
    ClearContent()
    if currentTab == "Player" then
        -- WalkSpeed Slider
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(1, -20, 0, 30)
        SliderLabel.Position = UDim2.new(0, 10, 0, 10)
        SliderLabel.Text = "WalkSpeed"
        SliderLabel.TextColor3 = Color3.fromRGB(255,255,255)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextSize = 18
        SliderLabel.Parent = ContentFrame
        table.insert(ContentElements, SliderLabel)

        local Slider = Instance.new("TextBox")
        Slider.Size = UDim2.new(1, -20, 0, 30)
        Slider.Position = UDim2.new(0, 10, 0, 45)
        Slider.PlaceholderText = "Enter value (16-500)"
        Slider.Text = ""
        Slider.BackgroundColor3 = Color3.fromRGB(80,80,80)
        Slider.TextColor3 = Color3.fromRGB(255,255,255)
        Slider.BorderSizePixel = 0
        Slider.Font = Enum.Font.Gotham
        Slider.TextSize = 18
        Slider.Parent = ContentFrame
        table.insert(ContentElements, Slider)

        Slider.FocusLost:Connect(function(enter)
            local val = tonumber(Slider.Text)
            if val and val >= 16 and val <= 500 then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = val
                end
            end
        end)
    elseif currentTab == "Teleports" then
        -- Teleport Button Example
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -20, 0, 40)
        Btn.Position = UDim2.new(0, 10, 0, 10)
        Btn.Text = "Teleport to Spawn"
        Btn.TextColor3 = Color3.fromRGB(255,255,255)
        Btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        Btn.BorderSizePixel = 0
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 18
        Btn.Parent = ContentFrame
        table.insert(ContentElements, Btn)

        Btn.MouseButton1Click:Connect(function()
            local spawn = workspace:FindFirstChild("SpawnLocation")
            if LocalPlayer.Character and spawn then
                LocalPlayer.Character:SetPrimaryPartCFrame(spawn.CFrame + Vector3.new(0,5,0))
            end
        end)
    elseif currentTab == "AutoFarm" then
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -20, 0, 30)
        Label.Position = UDim2.new(0, 10, 0, 10)
        Label.Text = "Auto Farm not implemented (example)"
        Label.TextColor3 = Color3.fromRGB(255,255,255)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 18
        Label.Parent = ContentFrame
        table.insert(ContentElements, Label)
    elseif currentTab == "Misc" then
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -20, 0, 40)
        Btn.Position = UDim2.new(0, 10, 0, 10)
        Btn.Text = "Rejoin Game"
        Btn.TextColor3 = Color3.fromRGB(255,255,255)
        Btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        Btn.BorderSizePixel = 0
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 18
        Btn.Parent = ContentFrame
        table.insert(ContentElements, Btn)

        Btn.MouseButton1Click:Connect(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        end)
    end
end

-- Initialize first tab
tabButtons[1].BackgroundColor3 = Color3.fromRGB(100,100,100)
currentTab = tabs[1]
UpdateContent()
