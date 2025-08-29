-- 2T1 Hub - Blade Ball Script
-- Auto Parry & Advanced Features

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Blade Ball Specific Variables
local AutoParryEnabled = false
local AutoDodgeEnabled = false
local ParryDistance = 15
local ParryConnection = nil

-- Create Main GUI
local function CreateBladeBallGUI()
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BladeBallHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui or LocalPlayer.PlayerGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 23)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar
    
    local TopCover = Instance.new("Frame")
    TopCover.Size = UDim2.new(1, 0, 0, 15)
    TopCover.Position = UDim2.new(0, 0, 1, -15)
    TopCover.BackgroundColor3 = Color3.fromRGB(15, 15, 23)
    TopCover.BorderSizePixel = 0
    TopCover.Parent = TopBar
    
    -- Logo
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(0, 200, 1, 0)
    Logo.Position = UDim2.new(0, 15, 0, 0)
    Logo.BackgroundTransparency = 1
    Logo.Text = "⚔️ BLADE BALL"
    Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    Logo.TextSize = 20
    Logo.Font = Enum.Font.GothamBold
    Logo.TextXAlignment = Enum.TextXAlignment.Left
    Logo.Parent = TopBar
    
    -- Status Badge
    local StatusBadge = Instance.new("Frame")
    StatusBadge.Size = UDim2.new(0, 80, 0, 24)
    StatusBadge.Position = UDim2.new(1, -95, 0.5, -12)
    StatusBadge.BackgroundColor3 = Color3.fromRGB(50, 205, 100)
    StatusBadge.Parent = TopBar
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 6)
    StatusCorner.Parent = StatusBadge
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, 0, 1, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "ACTIVE"
    StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusText.TextSize = 11
    StatusText.Font = Enum.Font.GothamBold
    StatusText.Parent = StatusBadge
    
    -- Content Area
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -20, 1, -65)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 55)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 3
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
    ScrollFrame.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ScrollFrame
    
    -- Auto Parry Section
    local AutoParrySection = Instance.new("Frame")
    AutoParrySection.Size = UDim2.new(1, 0, 0, 120)
    AutoParrySection.BackgroundColor3 = Color3.fromRGB(18, 18, 27)
    AutoParrySection.BorderSizePixel = 0
    AutoParrySection.Parent = ScrollFrame
    
    local APCorner = Instance.new("UICorner")
    APCorner.CornerRadius = UDim.new(0, 8)
    APCorner.Parent = AutoParrySection
    
    local APTitle = Instance.new("TextLabel")
    APTitle.Size = UDim2.new(1, -20, 0, 30)
    APTitle.Position = UDim2.new(0, 10, 0, 5)
    APTitle.BackgroundTransparency = 1
    APTitle.Text = "AUTO PARRY"
    APTitle.TextColor3 = Color3.fromRGB(138, 43, 226)
    APTitle.TextSize = 14
    APTitle.Font = Enum.Font.GothamBold
    APTitle.TextXAlignment = Enum.TextXAlignment.Left
    APTitle.Parent = AutoParrySection
    
    -- Auto Parry Toggle
    local APToggle = Instance.new("TextButton")
    APToggle.Size = UDim2.new(0, 120, 0, 35)
    APToggle.Position = UDim2.new(0, 10, 0, 40)
    APToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    APToggle.Text = "DISABLED"
    APToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
    APToggle.TextSize = 12
    APToggle.Font = Enum.Font.GothamBold
    APToggle.AutoButtonColor = false
    APToggle.Parent = AutoParrySection
    
    local APToggleCorner = Instance.new("UICorner")
    APToggleCorner.CornerRadius = UDim.new(0, 6)
    APToggleCorner.Parent = APToggle
    
    -- Distance Slider
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Size = UDim2.new(1, -20, 0, 20)
    DistanceLabel.Position = UDim2.new(0, 10, 0, 80)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.Text = "Parry Distance: 15"
    DistanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DistanceLabel.TextSize = 12
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    DistanceLabel.Parent = AutoParrySection
    
    -- Player Stats Section
    local StatsSection = Instance.new("Frame")
    StatsSection.Size = UDim2.new(1, 0, 0, 100)
    StatsSection.BackgroundColor3 = Color3.fromRGB(18, 18, 27)
    StatsSection.BorderSizePixel = 0
    StatsSection.Parent = ScrollFrame
    
    local StatsCorner = Instance.new("UICorner")
    StatsCorner.CornerRadius = UDim.new(0, 8)
    StatsCorner.Parent = StatsSection
    
    local StatsTitle = Instance.new("TextLabel")
    StatsTitle.Size = UDim2.new(1, -20, 0, 30)
    StatsTitle.Position = UDim2.new(0, 10, 0, 5)
    StatsTitle.BackgroundTransparency = 1
    StatsTitle.Text = "STATISTICS"
    StatsTitle.TextColor3 = Color3.fromRGB(138, 43, 226)
    StatsTitle.TextSize = 14
    StatsTitle.Font = Enum.Font.GothamBold
    StatsTitle.TextXAlignment = Enum.TextXAlignment.Left
    StatsTitle.Parent = StatsSection
    
    local ParryCount = Instance.new("TextLabel")
    ParryCount.Size = UDim2.new(1, -20, 0, 20)
    ParryCount.Position = UDim2.new(0, 10, 0, 35)
    ParryCount.BackgroundTransparency = 1
    ParryCount.Text = "Total Parries: 0"
    ParryCount.TextColor3 = Color3.fromRGB(180, 180, 180)
    ParryCount.TextSize = 12
    ParryCount.Font = Enum.Font.Gotham
    ParryCount.TextXAlignment = Enum.TextXAlignment.Left
    ParryCount.Parent = StatsSection
    
    local WinRate = Instance.new("TextLabel")
    WinRate.Size = UDim2.new(1, -20, 0, 20)
    WinRate.Position = UDim2.new(0, 10, 0, 55)
    WinRate.BackgroundTransparency = 1
    WinRate.Text = "Win Rate: 0%"
    WinRate.TextColor3 = Color3.fromRGB(180, 180, 180)
    WinRate.TextSize = 12
    WinRate.Font = Enum.Font.Gotham
    WinRate.TextXAlignment = Enum.TextXAlignment.Left
    WinRate.Parent = StatsSection
    
    -- Movement Section
    local MovementSection = Instance.new("Frame")
    MovementSection.Size = UDim2.new(1, 0, 0, 120)
    MovementSection.BackgroundColor3 = Color3.fromRGB(18, 18, 27)
    MovementSection.BorderSizePixel = 0
    MovementSection.Parent = ScrollFrame
    
    local MovCorner = Instance.new("UICorner")
    MovCorner.CornerRadius = UDim.new(0, 8)
    MovCorner.Parent = MovementSection
    
    local MovTitle = Instance.new("TextLabel")
    MovTitle.Size = UDim2.new(1, -20, 0, 30)
    MovTitle.Position = UDim2.new(0, 10, 0, 5)
    MovTitle.BackgroundTransparency = 1
    MovTitle.Text = "MOVEMENT"
    MovTitle.TextColor3 = Color3.fromRGB(138, 43, 226)
    MovTitle.TextSize = 14
    MovTitle.Font = Enum.Font.GothamBold
    MovTitle.TextXAlignment = Enum.TextXAlignment.Left
    MovTitle.Parent = MovementSection
    
    -- Auto Dodge Toggle
    local DodgeToggle = Instance.new("TextButton")
    DodgeToggle.Size = UDim2.new(0, 120, 0, 35)
    DodgeToggle.Position = UDim2.new(0, 10, 0, 40)
    DodgeToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    DodgeToggle.Text = "AUTO DODGE"
    DodgeToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
    DodgeToggle.TextSize = 12
    DodgeToggle.Font = Enum.Font.GothamBold
    DodgeToggle.AutoButtonColor = false
    DodgeToggle.Parent = MovementSection
    
    local DodgeCorner = Instance.new("UICorner")
    DodgeCorner.CornerRadius = UDim.new(0, 6)
    DodgeCorner.Parent = DodgeToggle
    
    -- Speed Boost
    local SpeedBoost = Instance.new("TextButton")
    SpeedBoost.Size = UDim2.new(0, 120, 0, 35)
    SpeedBoost.Position = UDim2.new(0, 140, 0, 40)
    SpeedBoost.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    SpeedBoost.Text = "SPEED BOOST"
    SpeedBoost.TextColor3 = Color3.fromRGB(200, 200, 200)
    SpeedBoost.TextSize = 12
    SpeedBoost.Font = Enum.Font.GothamBold
    SpeedBoost.AutoButtonColor = false
    SpeedBoost.Parent = MovementSection
    
    local SpeedCorner = Instance.new("UICorner")
    SpeedCorner.CornerRadius = UDim.new(0, 6)
    SpeedCorner.Parent = SpeedBoost
    
    -- Toggle Functions
    local parryStats = {count = 0}
    
    APToggle.MouseButton1Click:Connect(function()
        AutoParryEnabled = not AutoParryEnabled
        
        if AutoParryEnabled then
            APToggle.Text = "ENABLED"
            APToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
            APToggle.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
            
            -- Start auto parry logic
            print("[Blade Ball] Auto Parry Enabled")
        else
            APToggle.Text = "DISABLED"
            APToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
            APToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            
            print("[Blade Ball] Auto Parry Disabled")
        end
    end)
    
    DodgeToggle.MouseButton1Click:Connect(function()
        AutoDodgeEnabled = not AutoDodgeEnabled
        
        if AutoDodgeEnabled then
            DodgeToggle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            DodgeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            DodgeToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            DodgeToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
    SpeedBoost.MouseButton1Click:Connect(function()
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = 30
            SpeedBoost.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            SpeedBoost.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            task.wait(5)
            
            Character.Humanoid.WalkSpeed = 16
            SpeedBoost.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            SpeedBoost.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
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
    
    -- Right Ctrl Toggle
    local UIVisible = true
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            UIVisible = not UIVisible
            MainFrame.Visible = UIVisible
        end
    end)
    
    -- Opening Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200)
    }):Play()
end

-- Initialize
CreateBladeBallGUI()
print("[2T1 Hub] Blade Ball script loaded successfully!")