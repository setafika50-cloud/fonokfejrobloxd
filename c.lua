-- Minimalista Roblox GUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MinimalGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 400)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Tabs Frame
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0, 100, 1, 0)
TabsFrame.Position = UDim2.new(0, 0, 0, 0)
TabsFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -100, 1, 0)
ContentFrame.Position = UDim2.new(0, 100, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Tab Buttons
local tabs = {"Player", "Teleports", "AutoFarm", "Misc"}
local currentTab = nil
local tabButtons = {}

local function clearContent()
    for _, child in pairs(ContentFrame:GetChildren()) do
        child:Destroy()
    end
end

local function setTab(tabName)
    clearContent()
    currentTab = tabName
    
    if tabName == "Player" then
        local wsBtn = Instance.new("TextButton")
        wsBtn.Size = UDim2.new(0, 150, 0, 40)
        wsBtn.Position = UDim2.new(0, 10, 0, 10)
        wsBtn.Text = "Set WalkSpeed to 50"
        wsBtn.Parent = ContentFrame
        wsBtn.MouseButton1Click:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end)
    elseif tabName == "Teleports" then
        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0, 150, 0, 40)
        tpBtn.Position = UDim2.new(0, 10, 0, 10)
        tpBtn.Text = "Teleport to Spawn"
        tpBtn.Parent = ContentFrame
        tpBtn.MouseButton1Click:Connect(function()
            local spawn = workspace:FindFirstChild("SpawnLocation")
            if LocalPlayer.Character and spawn then
                LocalPlayer.Character:SetPrimaryPartCFrame(spawn.CFrame + Vector3.new(0,5,0))
            end
        end)
    elseif tabName == "AutoFarm" then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 200, 0, 40)
        lbl.Position = UDim2.new(0, 10, 0, 10)
        lbl.Text = "AutoFarm Placeholder"
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.BackgroundTransparency = 1
        lbl.Parent = ContentFrame
    elseif tabName == "Misc" then
        local rejoinBtn = Instance.new("TextButton")
        rejoinBtn.Size = UDim2.new(0, 150, 0, 40)
        rejoinBtn.Position = UDim2.new(0, 10, 0, 10)
        rejoinBtn.Text = "Rejoin Game"
        rejoinBtn.Parent = ContentFrame
        rejoinBtn.MouseButton1Click:Connect(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        end)
    end
end

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*45)
    btn.Text = name
    btn.Parent = TabsFrame
    btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    
    btn.MouseButton1Click:Connect(function()
        setTab(name)
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(80,80,80)
        end
        btn.BackgroundColor3 = Color3.fromRGB(120,120,120)
    end)
    
    table.insert(tabButtons, btn)
end

-- Initialize first tab
tabButtons[1].BackgroundColor3 = Color3.fromRGB(120,120,120)
setTab(tabs[1])
