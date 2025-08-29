-- 2T1 Hub - HyperShot Script
-- Auto Aim & Advanced Features

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- HyperShot Specific Variables
local AutoAimEnabled = false
local TriggerBotEnabled = false
local NoRecoilEnabled = false
local InfiniteAmmoEnabled = false

-- Create Main GUI
local function CreateHyperShotGUI()
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "HyperShotHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui or LocalPlayer.PlayerGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 520, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = MainFrame
    
    -- Animated Background Pattern
    local Pattern = Instance.new("ImageLabel")
    Pattern.Size = UDim2.new(1, 0, 1, 0)
    Pattern.BackgroundTransparency = 1
    Pattern.Image = "rbxassetid://5553946656"
    Pattern.ImageTransparency = 0.95
    Pattern.ImageColor3 = Color3.fromRGB(0, 200, 255)
    Pattern.ScaleType = Enum.ScaleType.Tile
    Pattern.TileSize = UDim2.new(0, 100, 0, 100)
    Pattern.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 55)
    TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 14)
    TopCorner.Parent = TopBar
    
    local TopCover = Instance.new("Frame")
    TopCover.Size = UDim2.new(1, 0, 0, 20)
    TopCover.Position = UDim2.new(0, 0, 1, -20)
    TopCover.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    TopCover.BorderSizePixel = 0
    TopCover.Parent = TopBar
    
    -- Logo with Animation
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(0, 250, 1, 0)
    Logo.Position = UDim2.new(0, 20, 0, 0)
    Logo.BackgroundTransparency = 1
    Logo.Text = "🎯 HYPERSHOT"
    Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    Logo.TextSize = 24
    Logo.Font = Enum.Font.GothamBold
    Logo.TextXAlignment = Enum.TextXAlignment.Left
    Logo.Parent = TopBar
    
    -- Cyan Gradient
    local LogoGradient = Instance.new("UIGradient")
    LogoGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 200))
    })
    LogoGradient.Parent = Logo
    
    -- Status Indicator
    local StatusFrame = Instance.new("Frame")
    StatusFrame.Size = UDim2.new(0, 100, 0, 28)
    StatusFrame.Position = UDim2.new(1, -115, 0.5, -14)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    StatusFrame.BackgroundTransparency = 0.8
    StatusFrame.Parent = TopBar
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 6)
    StatusCorner.Parent = StatusFrame
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, 0, 1, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "ONLINE"
    StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusText.TextSize = 12
    StatusText.Font = Enum.Font.GothamBold
    StatusText.Parent = StatusFrame
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -20, 1, -75)
    ContentContainer.Position = UDim2.new(0, 10, 0, 65)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Create Sections
    local sections = {
        {name = "COMBAT", color = Color3.fromRGB(0, 200, 255)},
        {name = "WEAPON", color = Color3.fromRGB(0, 255, 150)},
        {name = "PLAYER", color = Color3.fromRGB(255, 200, 0)}
    }
    
    local yOffset = 0
    for _, section in ipairs(sections) do
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Size = UDim2.new(1, 0, 0, 90)
        SectionFrame.Position = UDim2.new(0, 0, 0, yOffset)
        SectionFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
        SectionFrame.BorderSizePixel = 0
        SectionFrame.Parent = ContentContainer
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 10)
        SectionCorner.Parent = SectionFrame
        
        -- Section Border
        local SectionBorder = Instance.new("UIStroke")
        SectionBorder.Color = section.color
        SectionBorder.Transparency = 0.7
        SectionBorder.Thickness = 1
        SectionBorder.Parent = SectionFrame
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Size = UDim2.new(1, -20, 0, 25)
        SectionTitle.Position = UDim2.new(0, 10, 0, 5)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = section.name
        SectionTitle.TextColor3 = section.color
        SectionTitle.TextSize = 13
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = SectionFrame
        
        yOffset = yOffset + 100
    end
    
    -- Combat Section Features
    local CombatSection = ContentContainer:GetChildren()[1]
    
    local AutoAimBtn = Instance.new("TextButton")
    AutoAimBtn.Size = UDim2.new(0, 100, 0, 30)
    AutoAimBtn.Position = UDim2.new(0, 10, 0, 35)
    AutoAimBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    AutoAimBtn.Text = "Auto Aim"
    AutoAimBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    AutoAimBtn.TextSize = 11
    AutoAimBtn.Font = Enum.Font.Gotham
    AutoAimBtn.AutoButtonColor = false
    AutoAimBtn.Parent = CombatSection
    
    local AutoAimCorner = Instance.new("UICorner")
    AutoAim