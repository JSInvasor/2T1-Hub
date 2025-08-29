-- 2T1 Hub - Blade Ball GUI
-- WiiHub Style Interface

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "2T1Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui or LocalPlayer.PlayerGui

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

-- Path Text (Projects / 2t1 / Main)
local PathText = Instance.new("TextLabel")
PathText.Size = UDim2.new(0.7, 0, 1, 0)
PathText.Position = UDim2.new(0, 10, 0, 0)
PathText.BackgroundTransparency = 1
PathText.Text = "Projects / 2t1 / Main"
PathText.TextColor3 = Color3.fromRGB(150, 150, 170)
PathText.TextSize = 12
PathText.Font = Enum.Font.Gotham
PathText.TextXAlignment = Enum.TextXAlignment.Left
PathText.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 170)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.Parent = TopBar

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Tab Buttons Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -10, 1, -10)
TabContainer.Position = UDim2.new(0, 5, 0, 5)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar

local TabLayout = Instance.new("UIListLayout")
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabContainer

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -120, 1, -30)
ContentArea.Position = UDim2.new(0, 120, 0, 30)
ContentArea.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

-- Create Tab Function
local tabs = {}
local currentTab = nil

local function CreateTab(name)
    -- Tab Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 30)
    TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(120, 120, 140)
    TabBtn.TextSize = 12
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.AutoButtonColor = false
    TabBtn.Parent = TabContainer
    
    -- Tab Content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, -10, 1, -10)
    TabContent.Position = UDim2.new(0, 5, 0, 5)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 2
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = ContentArea
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = TabContent
    
    local tab = {
        button = TabBtn,
        content = TabContent,
        layout = ContentLayout
    }
    
    -- Select Tab
    TabBtn.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.button.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            currentTab.button.TextColor3 = Color3.fromRGB(120, 120, 140)
            currentTab.content.Visible = false
        end
        
        currentTab = tab
        TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
        TabContent.Visible = true
    end)
    
    table.insert(tabs, tab)
    
    -- Auto select first tab
    if #tabs == 1 then
        TabBtn.MouseButton1Click:Fire()
    end
    
    return tab
end

-- Create Toggle Function
local function CreateToggle(tab, text)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = tab.content
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleText = Instance.new("TextLabel")
    ToggleText.Size = UDim2.new(1, -50, 1, 0)
    ToggleText.Position = UDim2.new(0, 10, 0, 0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Text = text
    ToggleText.TextColor3 = Color3.fromRGB(180, 180, 200)
    ToggleText.TextSize = 12
    ToggleText.Font = Enum.Font.Gotham
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Parent = ToggleFrame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 38, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleBtn.Text = ""
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleBtn
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ToggleCircle.Parent = ToggleBtn
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local enabled = false
    
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        if enabled then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            }):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -18, 0.5, -8)
            }):Play()
        else
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            }):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -8)
            }):Play()
        end
    end)
    
    -- Update canvas size
    tab.content.CanvasSize = UDim2.new(0, 0, 0, tab.layout.AbsoluteContentSize.Y)
end

-- Create Tabs and Toggles
local generalTab = CreateTab("General")
local combatTab = CreateTab("Combat")
local visualsTab = CreateTab("Visuals")
local miscTab = CreateTab("Misc")

-- General Tab
CreateToggle(generalTab, "Auto Parry")
CreateToggle(generalTab, "Parry Visualizer")
CreateToggle(generalTab, "Spam Parry")

-- Combat Tab  
CreateToggle(combatTab, "Auto Block")
CreateToggle(combatTab, "Auto Dodge")
CreateToggle(combatTab, "Perfect Timing")

-- Visuals Tab
CreateToggle(visualsTab, "Ball ESP")
CreateToggle(visualsTab, "Player ESP")
CreateToggle(visualsTab, "Hitbox Viewer")

-- Misc Tab
CreateToggle(miscTab, "Infinite Stamina")
CreateToggle(miscTab, "Speed Boost")
CreateToggle(miscTab, "No Cooldown")

-- Dragging
local dragging, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Close Button
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Visible = false
end)

-- Right Ctrl Toggle
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Visible = not ScreenGui.Visible
    end
end)
