-- 2T1 Hub - Rivals Script
-- Aimbot, ESP & Advanced Features

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Rivals Specific Variables
local AimbotEnabled = false
local ESPEnabled = false
local SilentAimEnabled = false
local FOV = 90
local TeamCheck = true

-- Create Main GUI
local function CreateRivalsGUI()
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RivalsHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui or LocalPlayer.PlayerGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 550, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -210)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Gradient Background
    local BGGradient = Instance.new("UIGradient")
    BGGradient.Rotation = 135
    BGGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 16)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 15, 30))
    })
    BGGradient.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(13, 13, 20)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar
    
    local TopCover = Instance.new("Frame")
    TopCover.Size = UDim2.new(1, 0, 0, 15)
    TopCover.Position = UDim2.new(0, 0, 1, -15)
    TopCover.BackgroundColor3 = Color3.fromRGB(13, 13, 20)
    TopCover.BorderSizePixel = 0
    TopCover.Parent = TopBar
    
    -- Logo
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(0, 200, 1, 0)
    Logo.Position = UDim2.new(0, 15, 0, 0)
    Logo.BackgroundTransparency = 1
    Logo.Text = "🔫 RIVALS"
    Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    Logo.TextSize = 22
    Logo.Font = Enum.Font.GothamBold
    Logo.TextXAlignment = Enum.TextXAlignment.Left
    Logo.Parent = TopBar
    
    -- Gradient on logo
    local LogoGradient = Instance.new("UIGradient")
    LogoGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))
    })
    LogoGradient.Parent = Logo
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -20, 0, 35)
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    -- Create Tabs
    local tabs = {"Combat", "Visuals", "Movement", "Misc"}
    local tabButtons = {}
    local tabFrames = {}
    
    for i, tabName in ipairs(tabs) do
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 120, 1, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 27)
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 14
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabContainer
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn
        
        tabButtons[tabName] = TabBtn
        
        -- Tab Frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Size = UDim2.new(1, -20, 1, -115)
        TabFrame.Position = UDim2.new(0, 10, 0, 105)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.ScrollBarThickness = 3
        TabFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
        TabFrame.Visible = false
        TabFrame.Parent = MainFrame
        
        local TabListLayout = Instance.new("UIListLayout")
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabListLayout.Padding = UDim.new(0, 8)
        TabListLayout.Parent = TabFrame
        
        tabFrames[tabName] = TabFrame
    end
    
    -- Select first tab
    local function selectTab(tabName)
        for name, btn in pairs(tabButtons) do
            if name == tabName then
                btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                tabFrames[name].Visible = true
            else
                btn.BackgroundColor3 = Color3.fromRGB(18, 18, 27)
                btn.TextColor3 = Color3.fromRGB(150, 150, 150)
                tabFrames[name].Visible = false
            end
        end
    end
    
    -- Tab click events
    for name, btn in pairs(tabButtons) do
        btn.MouseButton1Click:Connect(function()
            selectTab(name)
        end)
    end
    
    selectTab("Combat")
    
    -- Combat Tab Content
    local CombatTab = tabFrames["Combat"]
    
    -- Aimbot Section
    local AimbotSection = Instance.new("Frame")
    AimbotSection.Size = UDim2.new(1, 0, 0, 150)
    AimbotSection.BackgroundColor3 = Color3.fromRGB(15, 15, 23)
    AimbotSection.Parent = CombatTab
    
    local AimbotCorner = Instance.new("UICorner")
    AimbotCorner.CornerRadius = UDim.new(0, 8)
    AimbotCorner.Parent = AimbotSection
    
    local AimbotTitle = Instance.new("TextLabel")
    AimbotTitle.Size = UDim2.new(1, -20, 0, 30)
    AimbotTitle.Position = UDim2.new(0, 10, 0, 5)
    AimbotTitle.BackgroundTransparency = 1
    AimbotTitle.Text = "AIMBOT SETTINGS"
    AimbotTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
    AimbotTitle.TextSize = 14
    AimbotTitle.Font = Enum.Font.GothamBold
    AimbotTitle.TextXAlignment = Enum.TextXAlignment.Left
    AimbotTitle.Parent = AimbotSection
    
    -- Aimbot Toggle
    local AimbotToggle = Instance.new("TextButton")
    AimbotToggle.Size = UDim2.new(0, 110, 0, 32)
    AimbotToggle.Position = UDim2.new(0, 10, 0, 40)
    AimbotToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    AimbotToggle.Text = "Enable Aimbot"
    AimbotToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
    AimbotToggle.TextSize = 12
    AimbotToggle.Font = Enum.Font.Gotham
    AimbotToggle.AutoButtonColor = false
    AimbotToggle.Parent = AimbotSection
    
    local AimbotToggleCorner = Instance.new("UICorner")
    AimbotToggleCorner.CornerRadius = UDim.new(0, 6)
    AimbotToggleCorner.Parent = AimbotToggle
    
    -- Silent Aim Toggle
    local SilentAimToggle = Instance.new("TextButton")
    SilentAimToggle.Size = UDim2.new(0, 110, 0, 32)
    SilentAimToggle.Position = UDim2.new(0, 130, 0, 40)
    SilentAimToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    SilentAimToggle.Text = "Silent Aim"
    SilentAimToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SilentAimToggle.TextSize = 12
    SilentAimToggle.Font = Enum.Font.Gotham
    SilentAimToggle.AutoButtonColor = false
    SilentAimToggle.Parent = AimbotSection
    
    local SilentAimCorner = Instance.new("UICorner")
    SilentAimCorner.CornerRadius = UDim.new(0, 6)
    SilentAimCorner.Parent = SilentAimToggle
    
    -- Team Check Toggle
    local TeamCheckToggle = Instance.new("TextButton")
    TeamCheckToggle.Size = UDim2.new(0, 110, 0, 32)
    TeamCheckToggle.Position = UDim2.new(0, 250, 0, 40)
    TeamCheckToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    TeamCheckToggle.Text = "Team Check"
    TeamCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeamCheckToggle.TextSize = 12
    TeamCheckToggle.Font = Enum.Font.Gotham
    TeamCheckToggle.AutoButtonColor = false
    TeamCheckToggle.Parent = AimbotSection
    
    local TeamCheckCorner = Instance.new("UICorner")
    TeamCheckCorner.CornerRadius = UDim.new(0, 6)
    TeamCheckCorner.Parent = TeamCheckToggle
    
    -- FOV Slider
    local FOVLabel = Instance.new("TextLabel")
    FOVLabel.Size = UDim2.new(1, -20, 0, 20)
    FOVLabel.Position = UDim2.new(0, 10, 0, 80)
    FOVLabel.BackgroundTransparency = 1
    FOVLabel.Text = "FOV: 90"
    FOVLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    FOVLabel.TextSize = 12
    FOVLabel.Font = Enum.Font.Gotham
    FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
    FOVLabel.Parent = AimbotSection
    
    -- Visuals Tab Content
    local VisualsTab = tabFrames["Visuals"]
    
    -- ESP Section
    local ESPSection = Instance.new("Frame")
    ESPSection.Size = UDim2.new(1, 0, 0, 120)
    ESPSection.BackgroundColor3 = Color3.fromRGB(15, 15, 23)
    ESPSection.Parent = VisualsTab
    
    local ESPCorner = Instance.new("UICorner")
    ESPCorner.CornerRadius = UDim.new(0, 8)
    ESPCorner.Parent = ESPSection
    
    local ESPTitle = Instance.new("TextLabel")
    ESPTitle.Size = UDim2.new(1, -20, 0, 30)
    ESPTitle.Position = UDim2.new(0, 10, 0, 5)
    ESPTitle.BackgroundTransparency = 1
    ESPTitle.Text = "ESP SETTINGS"
    ESPTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
    ESPTitle.TextSize = 14
    ESPTitle.Font = Enum.Font.GothamBold
    ESPTitle.TextXAlignment = Enum.TextXAlignment.Left
    ESPTitle.Parent = ESPSection
    
    -- ESP Toggles
    local BoxESP = Instance.new("TextButton")
    BoxESP.Size = UDim2.new(0, 100, 0, 30)
    BoxESP.Position = UDim2.new(0, 10, 0, 40)
    BoxESP.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    BoxESP.Text = "Box ESP"
    BoxESP.TextColor3 = Color3.fromRGB(200, 200, 200)
    BoxESP.TextSize = 12
    BoxESP.Font = Enum.Font.Gotham
    BoxESP.AutoButtonColor = false
    BoxESP.Parent = ESPSection
    
    local BoxESPCorner = Instance.new("UICorner")
    BoxESPCorner.CornerRadius = UDim.new(0, 6)
    BoxESPCorner.Parent = BoxESP
    
    -- Toggle Functions
    AimbotToggle.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled
        if AimbotEnabled then
            AimbotToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            print("[Rivals] Aimbot Enabled")
        else
            AimbotToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            AimbotToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
            print("[Rivals] Aimbot Disabled")
        end
    end)
    
    SilentAimToggle.MouseButton1Click:Connect(function()
        SilentAimEnabled = not SilentAimEnabled
        if SilentAimEnabled then
            SilentAimToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            SilentAimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            SilentAimToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            SilentAimToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
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
        Size = UDim2.new(0, 550, 0, 420),
        Position = UDim2.new(0.5, -275, 0.5, -210)
    }):Play()
end

-- Initialize
CreateRivalsGUI()
print("[2T1 Hub] Rivals script loaded successfully!")