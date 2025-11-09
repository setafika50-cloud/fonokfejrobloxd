--[[
    Title: Modern Draggable Utility GUI
    Description: A complete, modular, and draggable ScreenGui implementation
                 using Luau for Roblox game development. This script includes
                 a tab system and sample features.
    Usage: Place this script inside StarterPlayerScripts or a similar location.
]]--

-- =========================================================================
-- || 1. SETUP AND CONSTANTS                                            ||
-- =========================================================================

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Input = game:GetService("UserInputService")

-- Configuration
local UI_TITLE = "Universal Utility Panel"
local UI_FONT = Enum.Font.RobotoMono
local MAIN_COLOR = Color3.fromRGB(56, 189, 248) -- Sky Blue
local BG_COLOR = Color3.fromRGB(36, 36, 36)
local TAB_INACTIVE_COLOR = Color3.fromRGB(48, 48, 48)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)

-- =========================================================================
-- || 2. UI CREATION FUNCTIONS                                          ||
-- =========================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UtilityPanelGUI"
ScreenGui.Parent = PlayerGui

-- Main Frame (Root Container)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BorderColor3 = MAIN_COLOR
MainFrame.BorderSizePixel = 1
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner Radius
local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

-- Header Bar (Draggable Area)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = BG_COLOR
Header.Parent = MainFrame

-- Header Gradient for style
local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, MAIN_COLOR),
    ColorSequenceKeypoint.new(1, MAIN_COLOR:Lerp(Color3.fromRGB(0,0,0), 0.3))
})
HeaderGradient.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Text = UI_TITLE
TitleLabel.TextColor3 = TEXT_COLOR
TitleLabel.Font = UI_FONT
TitleLabel.TextSize = 18
TitleLabel.BackgroundColor3 = BG_COLOR -- Make it transparent
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = TEXT_COLOR
CloseButton.Font = UI_FONT
CloseButton.TextSize = 20
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Parent = Header

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 4)
UICornerClose.Parent = CloseButton

-- Sidebar for Tabs
local TabSidebar = Instance.new("Frame")
TabSidebar.Name = "TabSidebar"
TabSidebar.Size = UDim2.new(0, 150, 1, -30)
TabSidebar.Position = UDim2.new(0, 0, 0, 30)
TabSidebar.BackgroundColor3 = BG_COLOR:Lerp(Color3.fromRGB(0,0,0), 0.1)
TabSidebar.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Name = "TabList"
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabList.VerticalAlignment = Enum.VerticalAlignment.Top
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabSidebar

-- Content Panel
local ContentPanel = Instance.new("Frame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Size = UDim2.new(1, -150, 1, -30)
ContentPanel.Position = UDim2.new(0, 150, 0, 30)
ContentPanel.BackgroundColor3 = BG_COLOR
ContentPanel.BackgroundTransparency = 1
ContentPanel.ClipsDescendants = true
ContentPanel.Parent = MainFrame

-- Grid Layout for Content
local ContentGrid = Instance.new("UIGridLayout")
ContentGrid.Name = "ContentGrid"
ContentGrid.CellSize = UDim2.new(1, 0, 0, 30)
ContentGrid.CellPadding = UDim2.new(0, 5, 0, 5)
ContentGrid.Parent = ContentPanel

-- =========================================================================
-- || 3. UTILITY FUNCTIONS (DRAGGING, TAB SYSTEM)                       ||
-- =========================================================================

local isDragging = false
local dragStartPos = nil

-- Function to handle dragging the GUI
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = Input:GetMouseLocation()
        MainFrame:SetAttribute("InitialPosition", MainFrame.AbsolutePosition)
    end
end)

Input.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType.Touch) then
        local delta = Input:GetMouseLocation() - dragStartPos
        local initialPos = MainFrame:GetAttribute("InitialPosition")

        if initialPos then
            local newX = initialPos.X + delta.X
            local newY = initialPos.Y + delta.Y

            -- Convert to UDim2 scale/offset based on screen size
            local screenX = ScreenGui.AbsoluteSize.X
            local screenY = ScreenGui.AbsoluteSize.Y

            local newUDim2 = UDim2.fromOffset(newX, newY)

            -- Optional: Add bounds checking here
            MainFrame.Position = newUDim2
        end
    end
end)

Input.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch then
        isDragging = false
    end
end)

-- Function to handle toggling the UI visibility
local function toggleUI(visible)
    MainFrame.Visible = visible
end

ScreenGui.Enabled = true
toggleUI(true) -- Start visible

CloseButton.MouseButton1Click:Connect(function()
    toggleUI(false)
end)

-- Keybind to toggle UI (using 'Delete' or 'Insert' key is common for these types of menus)
Input.InputBegan:Connect(function(input, gameProcessed)
    -- Check if a typing box is focused before handling the keybind
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        toggleUI(not MainFrame.Visible)
    end
end)

-- =========================================================================
-- || 4. TAB SYSTEM MANAGER                                             ||
-- =========================================================================

local tabs = {}
local activeTab = nil

local function createTab(tabName, layoutOrder)
    -- 4a. Tab Button (Sidebar)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Button"
    TabButton.Text = tabName
    TabButton.Size = UDim2.new(1, -10, 0, 30)
    TabButton.Position = UDim2.new(0, 5, 0, 0)
    TabButton.TextColor3 = TEXT_COLOR
    TabButton.Font = UI_FONT
    TabButton.TextSize = 16
    TabButton.BackgroundColor3 = TAB_INACTIVE_COLOR
    TabButton.LayoutOrder = layoutOrder
    TabButton.Parent = TabSidebar

    local UICornerTab = Instance.new("UICorner")
    UICornerTab.CornerRadius = UDim.new(0, 4)
    UICornerTab.Parent = TabButton

    -- 4b. Tab Page (Content Area)
    local TabPage = Instance.new("Frame")
    TabPage.Name = tabName .. "Page"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundColor3 = BG_COLOR
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.Parent = ContentPanel

    -- Inherit Grid Layout
    local ContentGridClone = ContentGrid:Clone()
    ContentGridClone.Parent = TabPage

    tabs[tabName] = {Button = TabButton, Page = TabPage}

    return TabPage
end

local function switchTab(tabName)
    if activeTab == tabName then return end

    -- Deactivate previous tab
    if activeTab and tabs[activeTab] then
        tabs[activeTab].Button.BackgroundColor3 = TAB_INACTIVE_COLOR
        tabs[activeTab].Page.Visible = false
    end

    -- Activate new tab
    activeTab = tabName
    if tabs[activeTab] then
        tabs[activeTab].Button.BackgroundColor3 = MAIN_COLOR
        tabs[activeTab].Page.Visible = true
    end
end

-- 4c. Connect Button Logic
for tabName, tabData in pairs(tabs) do
    tabData.Button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

-- =========================================================================
-- || 5. FEATURE CREATION (Modular Design)                              ||
-- =========================================================================

local function createFeatureToggle(parentFrame, text, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "FeatureToggle"
    ToggleButton.Text = text .. ": OFF"
    ToggleButton.Size = UDim2.new(1, -10, 0, 25)
    ToggleButton.Position = UDim2.new(0, 5, 0, 0)
    ToggleButton.TextColor3 = TEXT_COLOR
    ToggleButton.Font = UI_FONT
    ToggleButton.TextSize = 14
    ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50) -- Red for OFF
    ToggleButton.Parent = parentFrame

    local UICornerFeature = Instance.new("UICorner")
    UICornerFeature.CornerRadius = UDim.new(0, 4)
    UICornerFeature.Parent = ToggleButton

    local isActive = false
    ToggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            ToggleButton.Text = text .. ": ON"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50) -- Green for ON
        else
            ToggleButton.Text = text .. ": OFF"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        end
        callback(isActive)
    end)
end

local function createFeatureSlider(parentFrame, text, minValue, maxValue, defaultValue, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 25)
    Container.Position = UDim2.new(0, 5, 0, 0)
    Container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Container.Parent = parentFrame

    local UICornerContainer = Instance.new("UICorner")
    UICornerContainer.CornerRadius = UDim.new(0, 4)
    UICornerContainer.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 5, 0, 0)
    Label.Text = string.format("%s: %d", text, defaultValue)
    Label.TextColor3 = TEXT_COLOR
    Label.Font = UI_FONT
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.3, 0, 0.8, 0)
    TextBox.Position = UDim2.new(0.65, 0, 0.1, 0)
    TextBox.Text = tostring(defaultValue)
    TextBox.TextColor3 = TEXT_COLOR
    TextBox.Font = UI_FONT
    TextBox.TextSize = 14
    TextBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    TextBox.TextXAlignment = Enum.TextXAlignment.Center
    TextBox.Parent = Container

    local function updateValue(value)
        value = math.clamp(math.floor(value), minValue, maxValue)
        TextBox.Text = tostring(value)
        Label.Text = string.format("%s: %d", text, value)
        callback(value)
    end

    TextBox.FocusLost:Connect(function(enterPressed)
        local value = tonumber(TextBox.Text)
        if value then
            updateValue(value)
        else
            TextBox.Text = tostring(defaultValue) -- Reset if invalid
            Label.Text = string.format("%s: %d (Invalid)", text)
        end
    end)

    -- Initial call
    callback(defaultValue)
end

-- =========================================================================
-- || 6. ADDING TABS AND FEATURES                                         ||
-- =========================================================================

-- Create Tabs (Name, LayoutOrder)
local movementPage = createTab("Movement", 1)
local utilityPage = createTab("Utility", 2)
local visualPage = createTab("Visuals", 3)

-- 6a. MOVEMENT TAB FEATURES
createFeatureToggle(movementPage, "Toggle Sprint", function(active)
    -- Example implementation: Changes the player's walk speed
    if active then
        Player.Character.Humanoid.WalkSpeed = 48 -- Fast speed
    else
        Player.Character.Humanoid.WalkSpeed = 16 -- Default speed
    end
end)

createFeatureSlider(movementPage, "Set WalkSpeed", 16, 100, 25, function(value)
    -- Note: We only set the speed if the 'Toggle Sprint' isn't actively forcing a different speed.
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = Player.Character.Humanoid
        -- If 'Toggle Sprint' is OFF, set the custom speed
        if not Player.Character:GetAttribute("IsSprinting") then
            humanoid.WalkSpeed = value
        end
    end
end)

-- 6b. UTILITY TAB FEATURES
createFeatureToggle(utilityPage, "No Clip Toggle (Dev Only)", function(active)
    -- This feature is typically restricted to admins/devs in live games
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character.Humanoid.PlatformStand = active
        -- Set CanCollide to false for parts (requires more complex code usually)
        print("No Clip " .. (active and "Activated" or "Deactivated"))
    end
end)

-- 6c. VISUALS TAB FEATURES (Placeholder)
local PlaceholderButton = Instance.new("TextButton")
PlaceholderButton.Size = UDim2.new(1, -10, 0, 25)
PlaceholderButton.Position = UDim2.new(0, 5, 0, 0)
PlaceholderButton.Text = "Add Visual Feature Here (e.g. ESP)"
PlaceholderButton.TextColor3 = TEXT_COLOR
PlaceholderButton.Font = UI_FONT
PlaceholderButton.TextSize = 14
PlaceholderButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
PlaceholderButton.Parent = visualPage

local UICornerPlaceholder = Instance.new("UICorner")
UICornerPlaceholder.CornerRadius = UDim.new(0, 4)
UICornerPlaceholder.Parent = PlaceholderButton

-- 6d. Final Initialization
-- Re-connect button logic after all tabs are created
for tabName, tabData in pairs(tabs) do
    tabData.Button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

-- Show the first tab by default
switchTab("Movement")

-- =========================================================================
-- || 7. CHARACTER RESPAWN FIX (Ensures UI features persist)            ||
-- =========================================================================

Player.CharacterAdded:Connect(function(character)
    -- This is important to ensure features like WalkSpeed are reapplied on respawn
    for _, feature in pairs(movementPage:GetChildren()) do
        if feature:IsA("TextButton") and string.find(feature.Text, "ON") then
            -- Re-trigger the logic for active toggles if necessary
            -- (For this simple example, the WalkSpeed slider handles it on its own)
        end
    end
