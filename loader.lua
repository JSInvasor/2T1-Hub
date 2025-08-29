-- 2T1 Hub Universal Loader
-- Automatic Game Detection & Script Loading

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Game Database
local GameDatabase = {
    [13772394625] = {
        name = "Blade Ball",
        script = "bladeball.lua",
        icon = "⚔️"
    },
    [14915220621] = {
        name = "Rivals",
        script = "rivals.lua", 
        icon = "🔫"
    },
    [8395031745] = {
        name = "HyperShot",
        script = "hypershot.lua",
        icon = "🎯"
    }
}

-- Loader UI
local LoaderUI = {}

function LoaderUI:Create()
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "2T1Loader"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui or LocalPlayer.PlayerGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Rounded Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Gradient Background
    local Gradient = Instance.new("UIGradient")
    Gradient.Rotation = 45
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 40))
    })
    Gradient.Parent = MainFrame
    
    -- Glow Effect
    local Glow = Instance.new("ImageLabel")
    Glow.Size = UDim2.new(1, 30, 1, 30)
    Glow.Position = UDim2.new(0, -15, 0, -15)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = Color3.fromRGB(138, 43, 226)
    Glow.ImageTransparency = 0.8
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(24, 24, 276, 276)
    Glow.Parent = MainFrame
    
    -- Logo Container
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Size = UDim2.new(1, 0, 0, 60)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Parent = MainFrame
    
    -- Logo Text
    local LogoText = Instance.new("TextLabel")
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "2T1 HUB"
    LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoText.TextSize = 32
    LogoText.Font = Enum.Font.GothamBold
    LogoText.Parent = LogoContainer
    
    -- Logo Gradient
    local LogoGradient = Instance.new("UIGradient")
    LogoGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(198, 65, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
    })
    LogoGradient.Parent = LogoText
    
    -- Status Container
    local StatusContainer = Instance.new("Frame")
    StatusContainer.Size = UDim2.new(1, -40, 0, 80)
    StatusContainer.Position = UDim2.new(0, 20, 0, 70)
    StatusContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    StatusContainer.BorderSizePixel = 0
    StatusContainer.Parent = MainFrame
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 8)
    StatusCorner.Parent = StatusContainer
    
    -- Game Icon
    local GameIcon = Instance.new("TextLabel")
    GameIcon.Size = UDim2.new(0, 60, 0, 60)
    GameIcon.Position = UDim2.new(0, 10, 0.5, -30)
    GameIcon.BackgroundTransparency = 1
    GameIcon.Text = "🎮"
    GameIcon.TextSize = 40
    GameIcon.Parent = StatusContainer
    
    -- Detection Text
    local DetectionText = Instance.new("TextLabel")
    DetectionText.Size = UDim2.new(1, -80, 0, 30)
    DetectionText.Position = UDim2.new(0, 80, 0, 10)
    DetectionText.BackgroundTransparency = 1
    DetectionText.Text = "Detecting Game..."
    DetectionText.TextColor3 = Color3.fromRGB(200, 200, 200)
    DetectionText.TextSize = 18
    DetectionText.Font = Enum.Font.GothamSemibold
    DetectionText.TextXAlignment = Enum.TextXAlignment.Left
    DetectionText.Parent = StatusContainer
    
    -- Game Name Text
    local GameNameText = Instance.new("TextLabel")
    GameNameText.Size = UDim2.new(1, -80, 0, 20)
    GameNameText.Position = UDim2.new(0, 80, 0, 40)
    GameNameText.BackgroundTransparency = 1
    GameNameText.Text = ""
    GameNameText.TextColor3 = Color3.fromRGB(138, 43, 226)
    GameNameText.TextSize = 14
    GameNameText.Font = Enum.Font.Gotham
    GameNameText.TextXAlignment = Enum.TextXAlignment.Left
    GameNameText.Parent = StatusContainer
    
    -- Loading Bar Container
    local LoadingContainer = Instance.new("Frame")
    LoadingContainer.Size = UDim2.new(1, -40, 0, 6)
    LoadingContainer.Position = UDim2.new(0, 20, 0, 170)
    LoadingContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    LoadingContainer.BorderSizePixel = 0
    LoadingContainer.Parent = MainFrame
    
    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(1, 0)
    LoadingCorner.Parent = LoadingContainer
    
    -- Loading Bar
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = LoadingContainer
    
    local LoadingBarCorner = Instance.new("UICorner")
    LoadingBarCorner.CornerRadius = UDim.new(1, 0)
    LoadingBarCorner.Parent = LoadingBar
    
    -- Loading Gradient
    local LoadingGradient = Instance.new("UIGradient")
    LoadingGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(198, 65, 255))
    })
    LoadingGradient.Parent = LoadingBar
    
    -- Status Text
    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, -40, 0, 20)
    StatusText.Position = UDim2.new(0, 20, 0, 190)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Initializing..."
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusText.TextSize = 12
    StatusText.Font = Enum.Font.Gotham
    StatusText.Parent = MainFrame
    
    -- Version Text
    local VersionText = Instance.new("TextLabel")
    VersionText.Size = UDim2.new(1, -40, 0, 20)
    VersionText.Position = UDim2.new(0, 20, 1, -25)
    VersionText.BackgroundTransparency = 1
    VersionText.Text = "v3.0 | Universal Loader"
    VersionText.TextColor3 = Color3.fromRGB(100, 100, 100)
    VersionText.TextSize = 10
    VersionText.Font = Enum.Font.Gotham
    VersionText.Parent = MainFrame
    
    -- Opening Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 250),
        Position = UDim2.new(0.5, -200, 0.5, -125)
    }):Play()
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        DetectionText = DetectionText,
        GameNameText = GameNameText,
        LoadingBar = LoadingBar,
        StatusText = StatusText,
        GameIcon = GameIcon
    }
end

-- Main Loader Function
local function LoadGame()
    local UI = LoaderUI:Create()
    local PlaceId = game.PlaceId
    local GameInfo = GameDatabase[PlaceId]
    
    -- Animate loading stages
    local function UpdateLoading(progress, status)
        TweenService:Create(UI.LoadingBar, TweenInfo.new(0.3), {
            Size = UDim2.new(progress, 0, 1, 0)
        }):Play()
        UI.StatusText.Text = status
    end
    
    wait(0.5)
    UpdateLoading(0.2, "Checking game database...")
    wait(0.3)
    
    if GameInfo then
        -- Game detected
        UpdateLoading(0.4, "Game detected!")
        UI.DetectionText.Text = "Game Detected!"
        UI.GameNameText.Text = GameInfo.name
        UI.GameIcon.Text = GameInfo.icon
        
        -- Pulse animation for detection
        local pulseSize = UI.GameIcon.Size
        TweenService:Create(UI.GameIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 70, 0, 70)
        }):Play()
        wait(0.3)
        TweenService:Create(UI.GameIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = pulseSize
        }):Play()
        
        UpdateLoading(0.6, "Loading script...")
        wait(0.5)
        
        UpdateLoading(0.8, "Initializing UI...")
        wait(0.3)
        
        UpdateLoading(1, "Launching " .. GameInfo.name .. "...")
        wait(0.5)
        
        -- Close loader with animation
        TweenService:Create(UI.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 400, 0, 0),
            Position = UDim2.new(0.5, -200, 0.5, 0)
        }):Play()
        
        wait(0.3)
        UI.ScreenGui:Destroy()
        
        -- Load game script
        if GameInfo.script == "bladeball.lua" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/2T1Hub/Scripts/main/bladeball.lua"))()
        elseif GameInfo.script == "rivals.lua" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/2T1Hub/Scripts/main/rivals.lua"))()
        elseif GameInfo.script == "hypershot.lua" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/2T1Hub/Scripts/main/hypershot.lua"))()
        end
        
    else
        -- Game not supported
        UpdateLoading(0.5, "Game not supported!")
        UI.DetectionText.Text = "Game Not Supported"
        UI.GameNameText.Text = "Place ID: " .. tostring(PlaceId)
        UI.GameIcon.Text = "❌"
        
        wait(2)
        UpdateLoading(1, "Loading universal features...")
        wait(1)
        
        -- Close and load universal script
        TweenService:Create(UI.MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        wait(0.3)
        UI.ScreenGui:Destroy()
    end
end

-- Start Loader
LoadGame()