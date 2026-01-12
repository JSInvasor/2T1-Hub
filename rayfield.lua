--[[
    Ultra Premium UI Library
    Version: 2.0
    Glassmorphism | Glow Effects | Smooth Animations
]]--

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Premium Config
local Theme = {
    Primary = Color3.fromRGB(139, 92, 246),
    Secondary = Color3.fromRGB(236, 72, 153),
    Background = Color3.fromRGB(13, 13, 13),
    Surface = Color3.fromRGB(22, 22, 22),
    SurfaceLight = Color3.fromRGB(32, 32, 32),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(160, 160, 160),
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68),
    
    GradientPrimary = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 92, 246)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 72, 153))
    },
    GradientDark = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 12))
    },
    GradientSurface = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
    }
}

-- Utility Functions
local function Tween(obj, props, duration, style, direction)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

-- Glow Effect
local function AddGlow(parent, color, size)
    local glow = Create("ImageLabel", {
        Parent = parent,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, size or 60, 1, size or 60),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Image = "rbxassetid://7912134082",
        ImageColor3 = color or Theme.Primary,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(30, 30, 70, 70)
    })
    return glow
end

-- Shine Effect (animated shine across element)
local function AddShine(parent)
    local shine = Create("Frame", {
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        Size = UDim2.new(0, 50, 2, 0),
        Position = UDim2.new(-0.3, 0, -0.5, 0),
        Rotation = 25,
        ZIndex = 10
    })
    Create("UIGradient", {
        Parent = shine,
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.7),
            NumberSequenceKeypoint.new(1, 1)
        }
    })
    
    local function PlayShine()
        shine.Position = UDim2.new(-0.3, 0, -0.5, 0)
        Tween(shine, {Position = UDim2.new(1.3, 0, -0.5, 0)}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    end
    
    return PlayShine
end

-- ScreenGui
local ScreenGui = Create("ScreenGui", {
    Name = "UltraPremiumUI",
    Parent = RunService:IsStudio() and Player:WaitForChild("PlayerGui") or game:GetService("CoreGui"),
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

-- Notification Holder
local NotifHolder = Create("Frame", {
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -20, 1, -20),
    Size = UDim2.new(0, 320, 1, -40),
    AnchorPoint = Vector2.new(1, 1)
})
Create("UIListLayout", {
    Parent = NotifHolder,
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDim.new(0, 12)
})

-- Premium Notification
function Library:Notify(options)
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 5
    local notifType = options.Type or "info"
    
    local accentColor = notifType == "success" and Theme.Success or notifType == "error" and Theme.Error or Theme.Primary
    
    local notif = Create("Frame", {
        Parent = NotifHolder,
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = notif, CornerRadius = UDim.new(0, 12)})
    Create("UIStroke", {Parent = notif, Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5})
    Create("UIGradient", {
        Parent = notif,
        Color = Theme.GradientSurface,
        Rotation = 135
    })
    
    AddGlow(notif, accentColor, 40)
    
    local accent = Create("Frame", {
        Parent = notif,
        BackgroundColor3 = accentColor,
        Size = UDim2.new(0, 4, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    })
    Create("UICorner", {Parent = accent, CornerRadius = UDim.new(0, 4)})
    
    local iconBg = Create("Frame", {
        Parent = notif,
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0, 16, 0, 16),
        Size = UDim2.new(0, 36, 0, 36)
    })
    Create("UICorner", {Parent = iconBg, CornerRadius = UDim.new(0, 8)})
    
    local icon = Create("ImageLabel", {
        Parent = iconBg,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = notifType == "success" and "rbxassetid://7072706796" or notifType == "error" and "rbxassetid://7072725342" or "rbxassetid://7072717857",
        ImageColor3 = accentColor
    })
    
    Create("TextLabel", {
        Parent = notif,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 64, 0, 14),
        Size = UDim2.new(1, -80, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    Create("TextLabel", {
        Parent = notif,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 64, 0, 36),
        Size = UDim2.new(1, -80, 0, 30),
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = Theme.SubText,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    
    local progress = Create("Frame", {
        Parent = notif,
        BackgroundColor3 = accentColor,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3)
    })
    Create("UICorner", {Parent = progress, CornerRadius = UDim.new(1, 0)})
    
    Tween(notif, {Size = UDim2.new(1, 0, 0, 80)}, 0.4, Enum.EasingStyle.Back)
    task.wait(0.1)
    Tween(progress, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)
    
    task.delay(duration, function()
        Tween(notif, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.4)
        notif:Destroy()
    end)
end

-- Main Window
function Library:CreateWindow(options)
    local title = options.Title or "Premium UI"
    local subtitle = options.Subtitle or ""
    local size = options.Size or UDim2.new(0, 600, 0, 420)
    local icon = options.Icon
    
    local Window = {}
    local Tabs = {}
    local currentTab = nil
    local minimized = false
    local dragging, dragStart, startPos
    
    -- Main Container
    local Main = Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(15, 15, 18),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = size,
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 16)})
    
    -- Background Gradient
    local bgGradient = Create("UIGradient", {
        Parent = Main,
        Color = Theme.GradientDark,
        Rotation = 145
    })
    
    -- Animated gradient rotation
    task.spawn(function()
        local rotation = 145
        while Main and Main.Parent do
            rotation = rotation + 0.1
            bgGradient.Rotation = rotation
            task.wait(0.05)
        end
    end)
    
    -- Outer Glow
    AddGlow(Main, Theme.Primary, 80)
    
    -- Border Stroke with Gradient
    local stroke = Create("UIStroke", {
        Parent = Main,
        Thickness = 1.5,
        Transparency = 0.6
    })
    Create("UIGradient", {
        Parent = stroke,
        Color = Theme.GradientPrimary,
        Rotation = 90
    })
    
    -- Accent Lines (top decorative lines)
    local accentTop = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.3, 0, 0, 2),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    Create("UIGradient", {
        Parent = accentTop,
        Color = Theme.GradientPrimary,
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0),
            NumberSequenceKeypoint.new(0.7, 0),
            NumberSequenceKeypoint.new(1, 1)
        }
    })
    Create("UICorner", {Parent = accentTop, CornerRadius = UDim.new(1, 0)})
    
    -- Topbar
    local Topbar = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60)
    })
    
    -- Logo/Icon Container
    local LogoContainer = Create("Frame", {
        Parent = Topbar,
        BackgroundColor3 = Theme.Primary,
        BackgroundTransparency = 0.9,
        Position = UDim2.new(0, 18, 0.5, 0),
        Size = UDim2.new(0, 42, 0, 42),
        AnchorPoint = Vector2.new(0, 0.5)
    })
    Create("UICorner", {Parent = LogoContainer, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = LogoContainer, Color = Theme.Primary, Thickness = 1, Transparency = 0.7})
    
    if icon then
        Create("ImageLabel", {
            Parent = LogoContainer,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 26, 0, 26),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://" .. icon,
            ImageColor3 = Theme.Text
        })
    end
    
    -- Title & Subtitle
    local TitleContainer = Create("Frame", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 72, 0.5, 0),
        Size = UDim2.new(0, 200, 0, 40),
        AnchorPoint = Vector2.new(0, 0.5)
    })
    
    Create("TextLabel", {
        Parent = TitleContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    if subtitle ~= "" then
        Create("TextLabel", {
            Parent = TitleContainer,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 22),
            Size = UDim2.new(1, 0, 0, 16),
            Font = Enum.Font.Gotham,
            Text = subtitle,
            TextColor3 = Theme.SubText,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    
    -- Window Controls
    local Controls = Create("Frame", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.new(0, 70, 0, 30),
        AnchorPoint = Vector2.new(1, 0.5)
    })
    Create("UIListLayout", {
        Parent = Controls,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10)
    })
    
    local function CreateWindowButton(iconId, hoverColor)
        local btn = Create("TextButton", {
            Parent = Controls,
            BackgroundColor3 = Theme.SurfaceLight,
            BackgroundTransparency = 0.5,
            Size = UDim2.new(0, 30, 0, 30),
            Text = "",
            AutoButtonColor = false
        })
        Create("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 8)})
        
        local ico = Create("ImageLabel", {
            Parent = btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 14, 0, 14),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = iconId,
            ImageColor3 = Theme.SubText
        })
        
        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundTransparency = 0}, 0.2)
            Tween(ico, {ImageColor3 = hoverColor or Theme.Text}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundTransparency = 0.5}, 0.2)
            Tween(ico, {ImageColor3 = Theme.SubText}, 0.2)
        end)
        
        return btn
    end
    
    local CloseBtn = CreateWindowButton("rbxassetid://7072725342", Theme.Error)
    local MinBtn = CreateWindowButton("rbxassetid://7072719338", Theme.Primary)
    
    -- Divider Line
    local Divider = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.95,
        Position = UDim2.new(0, 0, 0, 60),
        Size = UDim2.new(1, 0, 0, 1)
    })
    
    -- Tab Sidebar
    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(18, 18, 22),
        Position = UDim2.new(0, 0, 0, 61),
        Size = UDim2.new(0, 160, 1, -61)
    })
    Create("UIGradient", {
        Parent = Sidebar,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 28)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 20))
        },
        Rotation = 180
    })
    
    local TabList = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 12),
        Size = UDim2.new(1, 0, 1, -24),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    Create("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    Create("UIPadding", {
        Parent = TabList,
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12)
    })
    
    -- Content Area
    local Content = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 170, 0, 70),
        Size = UDim2.new(1, -185, 1, -85)
    })
    
    -- Minimize Icon
    local MinIcon = Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(0, 25, 0.5, 0),
        Size = UDim2.new(0, 55, 0, 55),
        AnchorPoint = Vector2.new(0, 0.5),
        Visible = false
    })
    Create("UICorner", {Parent = MinIcon, CornerRadius = UDim.new(0, 14)})
    Create("UIGradient", {
        Parent = MinIcon,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 92, 246)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 60, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
        },
        Rotation = 135
    })
    Create("UIStroke", {
        Parent = MinIcon,
        Color = Theme.Primary,
        Thickness = 1.5,
        Transparency = 0.5
    })
    AddGlow(MinIcon, Theme.Primary, 50)
    
    local MinIconImg = Create("ImageLabel", {
        Parent = MinIcon,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 28, 0, 28),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = icon and ("rbxassetid://" .. icon) or "rbxassetid://7733960981",
        ImageColor3 = Theme.Text
    })
    
    local MinIconBtn = Create("TextButton", {
        Parent = MinIcon,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    
    -- Dragging
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Tween(Main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.08)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- MinIcon Drag & Hover
    local minDrag, minStart, minPos
    MinIconBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            minDrag = true
            minStart = input.Position
            minPos = MinIcon.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if minDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - minStart
            MinIcon.Position = UDim2.new(minPos.X.Scale, minPos.X.Offset + delta.X, minPos.Y.Scale, minPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            minDrag = false
        end
    end)
    
    MinIconBtn.MouseEnter:Connect(function()
        Tween(MinIcon, {Size = UDim2.new(0, 62, 0, 62)}, 0.25, Enum.EasingStyle.Back)
    end)
    MinIconBtn.MouseLeave:Connect(function()
        Tween(MinIcon, {Size = UDim2.new(0, 55, 0, 55)}, 0.25, Enum.EasingStyle.Back)
    end)
    
    -- Minimize Toggle
    local function ToggleMinimize()
        minimized = not minimized
        if minimized then
            Tween(Main, {Size = UDim2.new(0, size.X.Offset, 0, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.3)
            Main.Visible = false
            MinIcon.Visible = true
            MinIcon.Size = UDim2.new(0, 0, 0, 0)
            Tween(MinIcon, {Size = UDim2.new(0, 55, 0, 55)}, 0.35, Enum.EasingStyle.Back)
        else
            MinIcon.Visible = false
            Main.Visible = true
            Main.Size = UDim2.new(0, size.X.Offset, 0, 0)
            Tween(Main, {Size = size}, 0.35, Enum.EasingStyle.Back)
        end
    end
    
    MinBtn.MouseButton1Click:Connect(ToggleMinimize)
    MinIconBtn.MouseButton1Click:Connect(ToggleMinimize)
    
    -- Close
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0, size.X.Offset, 0, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.35)
        ScreenGui:Destroy()
    end)
    
    -- Create Tab Function
    function Window:CreateTab(options)
        local tabName = options.Name or "Tab"
        local tabIcon = options.Icon
        
        local Tab = {}
        
        -- Tab Button
        local TabBtn = Create("TextButton", {
            Parent = TabList,
            BackgroundColor3 = Theme.Surface,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 40),
            Text = "",
            AutoButtonColor = false
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 10)})
        
        local TabGlow = Create("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Theme.Primary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 0
        })
        Create("UICorner", {Parent = TabGlow, CornerRadius = UDim.new(0, 10)})
        
        local TabIndicator = Create("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Theme.Primary,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5)
        })
        Create("UICorner", {Parent = TabIndicator, CornerRadius = UDim.new(1, 0)})
        
        local TabContent = Create("Frame", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0)
        })
        Create("UIListLayout", {
            Parent = TabContent,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 10)
        })
        Create("UIPadding", {Parent = TabContent, PaddingLeft = UDim.new(0, 14)})
        
        local TabIconLabel
        if tabIcon then
            TabIconLabel = Create("ImageLabel", {
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 18, 0, 18),
                Image = "rbxassetid://" .. tabIcon,
                ImageColor3 = Theme.SubText
            })
        end
        
        local TabTitle = Create("TextLabel", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 100, 0, 20),
            Font = Enum.Font.GothamSemibold,
            Text = tabName,
            TextColor3 = Theme.SubText,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Tab Page
        local TabPage = Create("ScrollingFrame", {
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Primary,
            ScrollBarImageTransparency = 0.5,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        })
        Create("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        Create("UIPadding", {
            Parent = TabPage,
            PaddingRight = UDim.new(0, 8)
        })
        
        table.insert(Tabs, {
            Button = TabBtn,
            Page = TabPage,
            Title = TabTitle,
            Icon = TabIconLabel,
            Indicator = TabIndicator,
            Glow = TabGlow
        })
        
        local function SelectTab()
            for _, tab in ipairs(Tabs) do
                tab.Page.Visible = false
                Tween(tab.Button, {BackgroundTransparency = 1}, 0.25)
                Tween(tab.Title, {TextColor3 = Theme.SubText}, 0.25)
                if tab.Icon then Tween(tab.Icon, {ImageColor3 = Theme.SubText}, 0.25) end
                Tween(tab.Indicator, {Size = UDim2.new(0, 0, 0.5, 0)}, 0.25)
                Tween(tab.Glow, {BackgroundTransparency = 1}, 0.25)
            end
            TabPage.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0.92}, 0.25)
            Tween(TabTitle, {TextColor3 = Theme.Text}, 0.25)
            if TabIconLabel then Tween(TabIconLabel, {ImageColor3 = Theme.Primary}, 0.25) end
            Tween(TabIndicator, {Size = UDim2.new(0, 3, 0.5, 0)}, 0.3, Enum.EasingStyle.Back)
            Tween(TabGlow, {BackgroundTransparency = 0.95}, 0.25)
            currentTab = TabPage
        end
        
        TabBtn.MouseButton1Click:Connect(SelectTab)
        TabBtn.MouseEnter:Connect(function()
            if TabPage ~= currentTab then
                Tween(TabBtn, {BackgroundTransparency = 0.95}, 0.2)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if TabPage ~= currentTab then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        if #Tabs == 1 then SelectTab() end
        
        -- Element Base
        local function CreateElementBase(name, height)
            local element = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, height or 50)
            })
            Create("UICorner", {Parent = element, CornerRadius = UDim.new(0, 10)})
            Create("UIStroke", {Parent = element, Color = Theme.SurfaceLight, Thickness = 1, Transparency = 0.8})
            Create("UIGradient", {
                Parent = element,
                Color = Theme.GradientSurface,
                Rotation = 90
            })
            
            if name then
                Create("TextLabel", {
                    Parent = element,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 16, 0, 0),
                    Size = UDim2.new(1, -120, 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end
            
            return element
        end
        
        -- Section
        function Tab:CreateSection(name)
            local section = Create("Frame", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30)
            })
            
            local line1 = Create("Frame", {
                Parent = section,
                BackgroundColor3 = Theme.SurfaceLight,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(0.2, 0, 0, 1),
                AnchorPoint = Vector2.new(0, 0.5)
            })
            
            Create("TextLabel", {
                Parent = section,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 100, 0, 20),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBold,
                Text = name or "Section",
                TextColor3 = Theme.SubText,
                TextSize = 11,
                TextTransparency = 0.3
            })
            
            local line2 = Create("Frame", {
                Parent = section,
                BackgroundColor3 = Theme.SurfaceLight,
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0.2, 0, 0, 1),
                AnchorPoint = Vector2.new(1, 0.5)
            })
        end
        
        -- Premium Toggle
        function Tab:CreateToggle(options)
            local name = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end
            local toggled = default
            
            local element = CreateElementBase(name, 50)
            
            local toggleContainer = Create("Frame", {
                Parent = element,
                BackgroundColor3 = toggled and Theme.Primary or Theme.SurfaceLight,
                Position = UDim2.new(1, -62, 0.5, 0),
                Size = UDim2.new(0, 46, 0, 26),
                AnchorPoint = Vector2.new(0, 0.5)
            })
            Create("UICorner", {Parent = toggleContainer, CornerRadius = UDim.new(1, 0)})
            
            local toggleGlow = AddGlow(toggleContainer, Theme.Primary, 20)
            toggleGlow.ImageTransparency = toggled and 0.6 or 1
            
            local toggleCircle = Create("Frame", {
                Parent = toggleContainer,
                BackgroundColor3 = Theme.Text,
                Position = toggled and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
                Size = UDim2.new(0, 20, 0, 20),
                AnchorPoint = Vector2.new(0, 0.5)
            })
            Create("UICorner", {Parent = toggleCircle, CornerRadius = UDim.new(1, 0)})
            
            -- Inner circle shine
            local innerShine = Create("Frame", {
                Parent = toggleCircle,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.8,
                Position = UDim2.new(0.2, 0, 0.15, 0),
                Size = UDim2.new(0.3, 0, 0.3, 0)
            })
            Create("UICorner", {Parent = innerShine, CornerRadius = UDim.new(1, 0)})
            
            local btn = Create("TextButton", {
                Parent = element,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local function UpdateToggle()
                if toggled then
                    Tween(toggleContainer, {BackgroundColor3 = Theme.Primary}, 0.3, Enum.EasingStyle.Quint)
                    Tween(toggleCircle, {Position = UDim2.new(1, -24, 0.5, 0)}, 0.3, Enum.EasingStyle.Back)
                    Tween(toggleGlow, {ImageTransparency = 0.6}, 0.3)
                else
                    Tween(toggleContainer, {BackgroundColor3 = Theme.SurfaceLight}, 0.3, Enum.EasingStyle.Quint)
                    Tween(toggleCircle, {Position = UDim2.new(0, 4, 0.5, 0)}, 0.3, Enum.EasingStyle.Back)
                    Tween(toggleGlow, {ImageTransparency = 1}, 0.3)
                end
                callback(toggled)
            end
            
            btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
            end)
            
            btn.MouseEnter:Connect(function()
                Tween(element, {BackgroundColor3 = Color3.fromRGB(28, 28, 35)}, 0.2)
            end)
            btn.MouseLeave:Connect(function()
                Tween(element, {BackgroundColor3 = Theme.Surface}, 0.2)
            end)
            
            local funcs = {}
            function funcs:Set(value)
                toggled = value
                UpdateToggle()
            end
            return funcs
        end
        
        -- Premium Button
        function Tab:CreateButton(options)
            local name = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local element = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, 50),
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = element, CornerRadius = UDim.new(0, 10)})
            Create("UIStroke", {Parent = element, Color = Theme.SurfaceLight, Thickness = 1, Transparency = 0.8})
            Create("UIGradient", {
                Parent = element,
                Color = Theme.GradientSurface,
                Rotation = 90
            })
            
            Create("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local arrow = Create("ImageLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -35, 0.5, 0),
                Size = UDim2.new(0, 18, 0, 18),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = "rbxassetid://7072706663",
                ImageColor3 = Theme.SubText
            })
            
            local btn = Create("TextButton", {
                Parent = element,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local playShine = AddShine(element)
            
            btn.MouseButton1Click:Connect(function()
                playShine()
                Tween(arrow, {Position = UDim2.new(1, -30, 0.5, 0)}, 0.15)
                task.wait(0.1)
                Tween(arrow, {Position = UDim2.new(1, -35, 0.5, 0)}, 0.15)
                callback()
            end)
            
            btn.MouseEnter:Connect(function()
                Tween(element, {BackgroundColor3 = Color3.fromRGB(28, 28, 35)}, 0.2)
                Tween(arrow, {ImageColor3 = Theme.Primary}, 0.2)
            end)
            btn.MouseLeave:Connect(function()
                Tween(element, {BackgroundColor3 = Theme.Surface}, 0.2)
                Tween(arrow, {ImageColor3 = Theme.SubText}, 0.2)
            end)
        end
        
        -- Premium Slider
        function Tab:CreateSlider(options)
            local name = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            
            local element = CreateElementBase(nil, 65)
            
            Create("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 10),
                Size = UDim2.new(1, -80, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local valueLabel = Create("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -60, 0, 10),
                Size = UDim2.new(0, 50, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = tostring(default),
                TextColor3 = Theme.Primary,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local sliderBg = Create("Frame", {
                Parent = element,
                BackgroundColor3 = Theme.SurfaceLight,
                Position = UDim2.new(0, 16, 0, 42),
                Size = UDim2.new(1, -32, 0, 8)
            })
            Create("UICorner", {Parent = sliderBg, CornerRadius = UDim.new(1, 0)})
            
            local sliderFill = Create("Frame", {
                Parent = sliderBg,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            })
            Create("UICorner", {Parent = sliderFill, CornerRadius = UDim.new(1, 0)})
            Create("UIGradient", {
                Parent = sliderFill,
                Color = Theme.GradientPrimary
            })
            
            local sliderKnob = Create("Frame", {
                Parent = sliderFill,
                BackgroundColor3 = Theme.Text,
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                AnchorPoint = Vector2.new(0.5, 0.5)
            })
            Create("UICorner", {Parent = sliderKnob, CornerRadius = UDim.new(1, 0)})
            AddGlow(sliderKnob, Theme.Primary, 15)
            
            local sliderBtn = Create("TextButton", {
                Parent = sliderBg,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 20),
                Position = UDim2.new(0, 0, 0, -10),
                Text = ""
            })
            
            local sliding = false
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                valueLabel.Text = tostring(value)
                Tween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.08)
                callback(value)
            end
            
            sliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    Update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
            
            local funcs = {}
            function funcs:Set(value)
                local pos = (value - min) / (max - min)
                valueLabel.Text = tostring(value)
                Tween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.15)
                callback(value)
            end
            return funcs
        end
        
        -- Premium Dropdown
        function Tab:CreateDropdown(options)
            local name = options.Name or "Dropdown"
            local list = options.Options or {}
            local default = options.Default or list[1]
            local callback = options.Callback or function() end
            local opened = false
            
            local element = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, 50),
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = element, CornerRadius = UDim.new(0, 10)})
            Create("UIStroke", {Parent = element, Color = Theme.SurfaceLight, Thickness = 1, Transparency = 0.8})
            Create("UIGradient", {
                Parent = element,
                Color = Theme.GradientSurface,
                Rotation = 90
            })
            
            Create("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.5, 0, 0, 50),
                Font = Enum.Font.GothamSemibold,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local selectedLabel = Create("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, -45, 0, 50),
                Font = Enum.Font.Gotham,
                Text = default or "Select",
                TextColor3 = Theme.SubText,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local arrow = Create("ImageLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0, 18),
                Size = UDim2.new(0, 14, 0, 14),
                Image = "rbxassetid://7072706318",
                ImageColor3 = Theme.SubText
            })
            
            local optionsHolder = Create("Frame", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 55),
                Size = UDim2.new(1, -20, 0, 0)
            })
            Create("UIListLayout", {
                Parent = optionsHolder,
                Padding = UDim.new(0, 5)
            })
            
            local mainBtn = Create("TextButton", {
                Parent = element,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50),
                Text = ""
            })
            
            local function CreateOption(optName)
                local opt = Create("TextButton", {
                    Parent = optionsHolder,
                    BackgroundColor3 = Theme.SurfaceLight,
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, 35),
                    Text = "",
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = opt, CornerRadius = UDim.new(0, 8)})
                
                Create("TextLabel", {
                    Parent = opt,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = optName,
                    TextColor3 = Theme.Text,
                    TextSize = 12
                })
                
                opt.MouseEnter:Connect(function()
                    Tween(opt, {BackgroundColor3 = Theme.Primary, BackgroundTransparency = 0.3}, 0.2)
                end)
                opt.MouseLeave:Connect(function()
                    Tween(opt, {BackgroundColor3 = Theme.SurfaceLight, BackgroundTransparency = 0.5}, 0.2)
                end)
                opt.MouseButton1Click:Connect(function()
                    selectedLabel.Text = optName
                    callback(optName)
                    opened = false
                    Tween(element, {Size = UDim2.new(1, 0, 0, 50)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    Tween(arrow, {Rotation = 0}, 0.25)
                end)
            end
            
            for _, opt in ipairs(list) do
                CreateOption(opt)
            end
            
            mainBtn.MouseButton1Click:Connect(function()
                opened = not opened
                local height = opened and (55 + (#list * 40)) or 50
                Tween(element, {Size = UDim2.new(1, 0, 0, height)}, 0.3, Enum.EasingStyle.Back)
                Tween(arrow, {Rotation = opened and 180 or 0}, 0.3)
            end)
            
            if default then callback(default) end
            
            local funcs = {}
            function funcs:Set(value)
                selectedLabel.Text = value
                callback(value)
            end
            return funcs
        end
        
        -- Keybind
        function Tab:CreateKeybind(options)
            local name = options.Name or "Keybind"
            local default = options.Default or Enum.KeyCode.E
            local callback = options.Callback or function() end
            local currentKey = default
            local listening = false
            
            local element = CreateElementBase(name, 50)
            
            local keyBtn = Create("TextButton", {
                Parent = element,
                BackgroundColor3 = Theme.SurfaceLight,
                Position = UDim2.new(1, -70, 0.5, 0),
                Size = UDim2.new(0, 55, 0, 28),
                AnchorPoint = Vector2.new(0, 0.5),
                Font = Enum.Font.GothamBold,
                Text = default.Name,
                TextColor3 = Theme.Text,
                TextSize = 11,
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = keyBtn, CornerRadius = UDim.new(0, 8)})
            Create("UIStroke", {Parent = keyBtn, Color = Theme.Primary, Thickness = 1, Transparency = 0.7})
            
            keyBtn.MouseButton1Click:Connect(function()
                keyBtn.Text = "..."
                Tween(keyBtn, {BackgroundColor3 = Theme.Primary}, 0.2)
                listening = true
            end)
            
            UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    keyBtn.Text = currentKey.Name
                    Tween(keyBtn, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
                    listening = false
                elseif input.KeyCode == currentKey then
                    callback()
                end
            end)
            
            local funcs = {}
            function funcs:Set(key)
                currentKey = key
                keyBtn.Text = key.Name
            end
            return funcs
        end
        
        -- Label
        function Tab:CreateLabel(text)
            local element = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 40)
            })
            Create("UICorner", {Parent = element, CornerRadius = UDim.new(0, 10)})
            
            local label = Create("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text or "Label",
                TextColor3 = Theme.SubText,
                TextSize = 12
            })
            
            local funcs = {}
            function funcs:Set(newText)
                label.Text = newText
            end
            return funcs
        end
        
        -- Textbox
        function Tab:CreateTextbox(options)
            local name = options.Name or "Textbox"
            local placeholder = options.Placeholder or "Type here..."
            local callback = options.Callback or function() end
            
            local element = CreateElementBase(name, 50)
            
            local inputBox = Create("TextBox", {
                Parent = element,
                BackgroundColor3 = Theme.SurfaceLight,
                Position = UDim2.new(0.45, 0, 0.5, 0),
                Size = UDim2.new(0.52, -16, 0, 30),
                AnchorPoint = Vector2.new(0, 0.5),
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder,
                PlaceholderColor3 = Theme.SubText,
                Text = "",
                TextColor3 = Theme.Text,
                TextSize = 12,
                ClearTextOnFocus = false
            })
            Create("UICorner", {Parent = inputBox, CornerRadius = UDim.new(0, 8)})
            Create("UIPadding", {Parent = inputBox, PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})
            
            inputBox.FocusLost:Connect(function(enter)
                if enter then
                    callback(inputBox.Text)
                end
            end)
            
            inputBox.Focused:Connect(function()
                Tween(inputBox, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}, 0.2)
            end)
            inputBox.FocusLost:Connect(function()
                Tween(inputBox, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
            end)
        end
        
        return Tab
    end
    
    return Window
end

return Library
