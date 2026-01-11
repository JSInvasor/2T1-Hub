--[[
    Premium UI Library
    Version: 1.0
    Modern, Clean, Smooth
]]--

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Config
local Config = {
    MainColor = Color3.fromRGB(147, 51, 234),
    BackgroundColor = Color3.fromRGB(17, 17, 17),
    SecondaryColor = Color3.fromRGB(24, 24, 24),
    TertiaryColor = Color3.fromRGB(32, 32, 32),
    TextColor = Color3.fromRGB(240, 240, 240),
    SubTextColor = Color3.fromRGB(170, 170, 170),
    AccentGradient = {
        Color3.fromRGB(147, 51, 234),
        Color3.fromRGB(79, 70, 229)
    },
    Font = Enum.Font.GothamBold,
    FontSemiBold = Enum.Font.GothamSemibold,
    FontRegular = Enum.Font.Gotham,
    AnimationSpeed = 0.2
}

-- Utility Functions
local function Tween(obj, props, duration, style, direction)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration or Config.AnimationSpeed, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

local function CreateInstance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    if props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function Ripple(button)
    local ripple = CreateInstance("Frame", {
        Parent = button,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, Mouse.X - button.AbsolutePosition.X, 0, Mouse.Y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        ZIndex = 10
    })
    CreateInstance("UICorner", {Parent = ripple, CornerRadius = UDim.new(1, 0)})
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
    task.delay(0.5, function() ripple:Destroy() end)
end

-- ScreenGui
local ScreenGui = CreateInstance("ScreenGui", {
    Name = "PremiumUI",
    Parent = RunService:IsStudio() and Player:WaitForChild("PlayerGui") or game:GetService("CoreGui"),
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

-- Notification Container
local NotificationHolder = CreateInstance("Frame", {
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -20, 1, -20),
    Size = UDim2.new(0, 300, 1, -40),
    AnchorPoint = Vector2.new(1, 1)
})
CreateInstance("UIListLayout", {
    Parent = NotificationHolder,
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDim.new(0, 10)
})

-- Notification Function
function Library:Notify(options)
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 4
    
    local notif = CreateInstance("Frame", {
        Parent = NotificationHolder,
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true
    })
    CreateInstance("UICorner", {Parent = notif, CornerRadius = UDim.new(0, 8)})
    CreateInstance("UIStroke", {Parent = notif, Color = Config.TertiaryColor, Thickness = 1})
    
    local accent = CreateInstance("Frame", {
        Parent = notif,
        BackgroundColor3 = Config.MainColor,
        Size = UDim2.new(0, 3, 1, 0)
    })
    
    local titleLabel = CreateInstance("TextLabel", {
        Parent = notif,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -25, 0, 18),
        Font = Config.Font,
        Text = title,
        TextColor3 = Config.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local msgLabel = CreateInstance("TextLabel", {
        Parent = notif,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 30),
        Size = UDim2.new(1, -25, 0, 16),
        Font = Config.FontRegular,
        Text = message,
        TextColor3 = Config.SubTextColor,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    
    local progress = CreateInstance("Frame", {
        Parent = notif,
        BackgroundColor3 = Config.MainColor,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(1, 0, 0, 2)
    })
    
    Tween(notif, {Size = UDim2.new(1, 0, 0, 60)}, 0.3, Enum.EasingStyle.Back)
    Tween(progress, {Size = UDim2.new(0, 0, 0, 2)}, duration)
    
    task.delay(duration, function()
        Tween(notif, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- Main Window Function
function Library:CreateWindow(options)
    local windowTitle = options.Title or "Premium UI"
    local windowSize = options.Size or UDim2.new(0, 550, 0, 380)
    local windowIcon = options.Icon or nil
    
    local Window = {}
    local Tabs = {}
    local currentTab = nil
    local minimized = false
    local dragging, dragStart, startPos
    
    -- Main Frame
    local MainFrame = CreateInstance("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Config.BackgroundColor,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = windowSize,
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true
    })
    CreateInstance("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 12)})
    
    -- Shadow
    local Shadow = CreateInstance("ImageLabel", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 40, 1, 40),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Image = "rbxassetid://7912134082",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(30, 30, 70, 70)
    })

    -- Topbar
    local Topbar = CreateInstance("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(1, 0, 0, 45)
    })
    CreateInstance("UICorner", {Parent = Topbar, CornerRadius = UDim.new(0, 12)})
    
    local TopbarCover = CreateInstance("Frame", {
        Parent = Topbar,
        BackgroundColor3 = Config.SecondaryColor,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0)
    })

    -- Title
    local TitleLabel = CreateInstance("TextLabel", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Config.Font,
        Text = windowTitle,
        TextColor3 = Config.TextColor,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Window Controls
    local Controls = CreateInstance("Frame", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -90, 0, 0),
        Size = UDim2.new(0, 80, 1, 0)
    })
    CreateInstance("UIListLayout", {
        Parent = Controls,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8)
    })
    
    local function CreateControl(icon, color)
        local btn = CreateInstance("TextButton", {
            Parent = Controls,
            BackgroundColor3 = Config.TertiaryColor,
            Size = UDim2.new(0, 28, 0, 28),
            Text = "",
            AutoButtonColor = false
        })
        CreateInstance("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 6)})
        CreateInstance("ImageLabel", {
            Parent = btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 16, 0, 16),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = icon,
            ImageColor3 = color or Config.SubTextColor
        })
        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = Config.TertiaryColor}, 0.15)
        end)
        return btn
    end
    
    local CloseBtn = CreateControl("rbxassetid://7072725342", Color3.fromRGB(240, 80, 80))
    local MinimizeBtn = CreateControl("rbxassetid://7072719338")

    -- Tab Container
    local TabContainer = CreateInstance("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Config.SecondaryColor,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(0, 140, 1, -45)
    })
    
    local TabList = CreateInstance("ScrollingFrame", {
        Parent = TabContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -20),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    CreateInstance("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    CreateInstance("UIPadding", {
        Parent = TabList,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })

    -- Content Container
    local ContentContainer = CreateInstance("Frame", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 145, 0, 50),
        Size = UDim2.new(1, -155, 1, -60)
    })

    -- Minimize Icon (küçük ikon)
    local MinIcon = CreateInstance("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(0, 20, 0.5, 0),
        Size = UDim2.new(0, 50, 0, 50),
        AnchorPoint = Vector2.new(0, 0.5),
        Visible = false
    })
    CreateInstance("UICorner", {Parent = MinIcon, CornerRadius = UDim.new(0, 12)})
    
    local MinIconGradient = CreateInstance("UIGradient", {
        Parent = MinIcon,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(147, 51, 234)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
        },
        Rotation = 45
    })
    
    local MinIconImage = CreateInstance("ImageLabel", {
        Parent = MinIcon,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 28, 0, 28),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = windowIcon and ("rbxassetid://" .. windowIcon) or "rbxassetid://7733960981",
        ImageColor3 = Color3.fromRGB(255, 255, 255)
    })
    
    local MinIconBtn = CreateInstance("TextButton", {
        Parent = MinIcon,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })

    -- Dragging
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Tween(MainFrame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- MinIcon Dragging
    local minDragging, minDragStart, minStartPos
    MinIconBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            minDragging = true
            minDragStart = input.Position
            minStartPos = MinIcon.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if minDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - minDragStart
            MinIcon.Position = UDim2.new(minStartPos.X.Scale, minStartPos.X.Offset + delta.X, minStartPos.Y.Scale, minStartPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            minDragging = false
        end
    end)

    -- MinIcon Hover
    MinIconBtn.MouseEnter:Connect(function()
        Tween(MinIcon, {Size = UDim2.new(0, 55, 0, 55)}, 0.2, Enum.EasingStyle.Back)
        Tween(MinIconImage, {Rotation = 15}, 0.2)
    end)
    MinIconBtn.MouseLeave:Connect(function()
        Tween(MinIcon, {Size = UDim2.new(0, 50, 0, 50)}, 0.2, Enum.EasingStyle.Back)
        Tween(MinIconImage, {Rotation = 0}, 0.2)
    end)

    -- Minimize Function
    local function ToggleMinimize()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, {Size = UDim2.new(0, windowSize.X.Offset, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.25)
            MainFrame.Visible = false
            MinIcon.Visible = true
            MinIcon.Size = UDim2.new(0, 0, 0, 0)
            Tween(MinIcon, {Size = UDim2.new(0, 50, 0, 50)}, 0.3, Enum.EasingStyle.Back)
        else
            MinIcon.Visible = false
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, windowSize.X.Offset, 0, 0)
            Tween(MainFrame, {Size = windowSize}, 0.3, Enum.EasingStyle.Back)
        end
    end

    MinimizeBtn.MouseButton1Click:Connect(ToggleMinimize)
    MinIconBtn.MouseButton1Click:Connect(ToggleMinimize)

    -- Close Function
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, windowSize.X.Offset, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    -- Tab Function
    function Window:CreateTab(options)
        local tabName = options.Name or "Tab"
        local tabIcon = options.Icon or nil
        
        local Tab = {}
        
        -- Tab Button
        local TabBtn = CreateInstance("TextButton", {
            Parent = TabList,
            BackgroundColor3 = Config.TertiaryColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 36),
            Text = "",
            AutoButtonColor = false
        })
        CreateInstance("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 8)})
        
        local TabIndicator = CreateInstance("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Config.MainColor,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0.6, 0),
            AnchorPoint = Vector2.new(0, 0.5)
        })
        CreateInstance("UICorner", {Parent = TabIndicator, CornerRadius = UDim.new(0, 2)})
        
        local TabTitle = CreateInstance("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, tabIcon and 35 or 12, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Font = Config.FontSemiBold,
            Text = tabName,
            TextColor3 = Config.SubTextColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        if tabIcon then
            CreateInstance("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0.5, 0),
                Size = UDim2.new(0, 18, 0, 18),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = "rbxassetid://" .. tabIcon,
                ImageColor3 = Config.SubTextColor
            })
        end
        
        -- Tab Content
        local TabContent = CreateInstance("ScrollingFrame", {
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Config.MainColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        })
        CreateInstance("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        CreateInstance("UIPadding", {
            Parent = TabContent,
            PaddingRight = UDim.new(0, 10)
        })
        
        table.insert(Tabs, {Button = TabBtn, Content = TabContent, Title = TabTitle, Indicator = TabIndicator})
        
        local function SelectTab()
            for _, tab in ipairs(Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundTransparency = 1}, 0.15)
                Tween(tab.Title, {TextColor3 = Config.SubTextColor}, 0.15)
                Tween(tab.Indicator, {Size = UDim2.new(0, 0, 0.6, 0)}, 0.15)
            end
            TabContent.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0.9}, 0.15)
            Tween(TabTitle, {TextColor3 = Config.TextColor}, 0.15)
            Tween(TabIndicator, {Size = UDim2.new(0, 3, 0.6, 0)}, 0.15, Enum.EasingStyle.Back)
            currentTab = TabContent
        end
        
        TabBtn.MouseButton1Click:Connect(SelectTab)
        TabBtn.MouseEnter:Connect(function()
            if TabContent ~= currentTab then
                Tween(TabBtn, {BackgroundTransparency = 0.95}, 0.15)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if TabContent ~= currentTab then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        if #Tabs == 1 then SelectTab() end

        -- Section
        function Tab:CreateSection(name)
            local Section = CreateInstance("Frame", {
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25)
            })
            CreateInstance("TextLabel", {
                Parent = Section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Config.Font,
                Text = name or "Section",
                TextColor3 = Config.SubTextColor,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        -- Toggle
        function Tab:CreateToggle(options)
            local toggleName = options.Name or "Toggle"
            local toggleDefault = options.Default or false
            local toggleCallback = options.Callback or function() end
            local toggled = toggleDefault
            
            local Toggle = CreateInstance("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Config.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 42)
            })
            CreateInstance("UICorner", {Parent = Toggle, CornerRadius = UDim.new(0, 8)})
            
            CreateInstance("TextLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Font = Config.FontSemiBold,
                Text = toggleName,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ToggleBtn = CreateInstance("Frame", {
                Parent = Toggle,
                BackgroundColor3 = Config.TertiaryColor,
                Position = UDim2.new(1, -52, 0.5, 0),
                Size = UDim2.new(0, 38, 0, 20),
                AnchorPoint = Vector2.new(0, 0.5)
            })
            CreateInstance("UICorner", {Parent = ToggleBtn, CornerRadius = UDim.new(1, 0)})
            
            local ToggleCircle = CreateInstance("Frame", {
                Parent = ToggleBtn,
                BackgroundColor3 = Config.SubTextColor,
                Position = UDim2.new(0, 3, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14),
                AnchorPoint = Vector2.new(0, 0.5)
            })
            CreateInstance("UICorner", {Parent = ToggleCircle, CornerRadius = UDim.new(1, 0)})
            
            local ClickBtn = CreateInstance("TextButton", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local function UpdateToggle()
                if toggled then
                    Tween(ToggleBtn, {BackgroundColor3 = Config.MainColor}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -17, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2, Enum.EasingStyle.Back)
                else
                    Tween(ToggleBtn, {BackgroundColor3 = Config.TertiaryColor}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = Config.SubTextColor}, 0.2, Enum.EasingStyle.Back)
                end
                toggleCallback(toggled)
            end
            
            ClickBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
            end)
            
            UpdateToggle()
            
            local ToggleFuncs = {}
            function ToggleFuncs:Set(value)
                toggled = value
                UpdateToggle()
            end
            return ToggleFuncs
        end

        -- Button
        function Tab:CreateButton(options)
            local btnName = options.Name or "Button"
            local btnCallback = options.Callback or function() end
            
            local Button = CreateInstance("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Config.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 42),
                ClipsDescendants = true
            })
            CreateInstance("UICorner", {Parent = Button, CornerRadius = UDim.new(0, 8)})
            
            CreateInstance("TextLabel", {
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Font = Config.FontSemiBold,
                Text = btnName,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            CreateInstance("ImageLabel", {
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -32, 0.5, 0),
                Size = UDim2.new(0, 18, 0, 18),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = "rbxassetid://7072706663",
                ImageColor3 = Config.SubTextColor
            })
            
            local ClickBtn = CreateInstance("TextButton", {
                Parent = Button,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            ClickBtn.MouseButton1Click:Connect(function()
                Ripple(Button)
                btnCallback()
            end)
            
            ClickBtn.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Config.TertiaryColor}, 0.15)
            end)
            ClickBtn.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Config.SecondaryColor}, 0.15)
            end)
        end

        -- Slider
        function Tab:CreateSlider(options)
            local sliderName = options.Name or "Slider"
            local sliderMin = options.Min or 0
            local sliderMax = options.Max or 100
            local sliderDefault = options.Default or sliderMin
            local sliderCallback = options.Callback or function() end
            
            local Slider = CreateInstance("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Config.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 55)
            })
            CreateInstance("UICorner", {Parent = Slider, CornerRadius = UDim.new(0, 8)})
            
            CreateInstance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 8),
                Size = UDim2.new(1, -70, 0, 18),
                Font = Config.FontSemiBold,
                Text = sliderName,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = CreateInstance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -55, 0, 8),
                Size = UDim2.new(0, 45, 0, 18),
                Font = Config.FontSemiBold,
                Text = tostring(sliderDefault),
                TextColor3 = Config.MainColor,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local SliderBar = CreateInstance("Frame", {
                Parent = Slider,
                BackgroundColor3 = Config.TertiaryColor,
                Position = UDim2.new(0, 14, 0, 35),
                Size = UDim2.new(1, -28, 0, 6)
            })
            CreateInstance("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})
            
            local SliderFill = CreateInstance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Config.MainColor,
                Size = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), 0, 1, 0)
            })
            CreateInstance("UICorner", {Parent = SliderFill, CornerRadius = UDim.new(1, 0)})
            
            local SliderBtn = CreateInstance("TextButton", {
                Parent = SliderBar,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 20),
                Position = UDim2.new(0, 0, 0, -10),
                Text = ""
            })
            
            local sliding = false
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(sliderMin + (sliderMax - sliderMin) * pos)
                ValueLabel.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                sliderCallback(value)
            end
            
            SliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            local SliderFuncs = {}
            function SliderFuncs:Set(value)
                local pos = (value - sliderMin) / (sliderMax - sliderMin)
                ValueLabel.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                sliderCallback(value)
            end
            return SliderFuncs
        end

        -- Dropdown
        function Tab:CreateDropdown(options)
            local dropName = options.Name or "Dropdown"
            local dropOptions = options.Options or {}
            local dropDefault = options.Default or dropOptions[1]
            local dropCallback = options.Callback or function() end
            local opened = false
            
            local Dropdown = CreateInstance("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Config.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 42),
                ClipsDescendants = true
            })
            CreateInstance("UICorner", {Parent = Dropdown, CornerRadius = UDim.new(0, 8)})
            
            CreateInstance("TextLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.5, 0, 0, 42),
                Font = Config.FontSemiBold,
                Text = dropName,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Selected = CreateInstance("TextLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, -35, 0, 42),
                Font = Config.FontRegular,
                Text = dropDefault or "Select",
                TextColor3 = Config.SubTextColor,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local Arrow = CreateInstance("ImageLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -28, 0, 14),
                Size = UDim2.new(0, 14, 0, 14),
                Image = "rbxassetid://7072706318",
                ImageColor3 = Config.SubTextColor
            })
            
            local OptionsHolder = CreateInstance("Frame", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 46),
                Size = UDim2.new(1, -16, 0, 0)
            })
            CreateInstance("UIListLayout", {
                Parent = OptionsHolder,
                Padding = UDim.new(0, 4)
            })
            
            local MainBtn = CreateInstance("TextButton", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 42),
                Text = ""
            })
            
            local function CreateOption(name)
                local Opt = CreateInstance("TextButton", {
                    Parent = OptionsHolder,
                    BackgroundColor3 = Config.TertiaryColor,
                    Size = UDim2.new(1, 0, 0, 32),
                    Text = "",
                    AutoButtonColor = false
                })
                CreateInstance("UICorner", {Parent = Opt, CornerRadius = UDim.new(0, 6)})
                CreateInstance("TextLabel", {
                    Parent = Opt,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Config.FontRegular,
                    Text = name,
                    TextColor3 = Config.TextColor,
                    TextSize = 12
                })
                
                Opt.MouseEnter:Connect(function()
                    Tween(Opt, {BackgroundColor3 = Config.MainColor}, 0.15)
                end)
                Opt.MouseLeave:Connect(function()
                    Tween(Opt, {BackgroundColor3 = Config.TertiaryColor}, 0.15)
                end)
                Opt.MouseButton1Click:Connect(function()
                    Selected.Text = name
                    dropCallback(name)
                    opened = false
                    Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 42)}, 0.2)
                    Tween(Arrow, {Rotation = 0}, 0.2)
                end)
            end
            
            for _, opt in ipairs(dropOptions) do
                CreateOption(opt)
            end
            
            MainBtn.MouseButton1Click:Connect(function()
                opened = not opened
                local height = opened and (46 + (#dropOptions * 36)) or 42
                Tween(Dropdown, {Size = UDim2.new(1, 0, 0, height)}, 0.2, Enum.EasingStyle.Back)
                Tween(Arrow, {Rotation = opened and 180 or 0}, 0.2)
            end)
            
            if dropDefault then dropCallback(dropDefault) end
            
            local DropFuncs = {}
            function DropFuncs:Set(value)
                Selected.Text = value
                dropCallback(value)
            end
            return DropFuncs
        end

        -- Textbox
        function Tab:CreateTextbox(options)
            local textName = options.Name or "Textbox"
            local textPlaceholder = options.Placeholder or "Enter text..."
            local textCallback = options.Callback or function() end
            
            local Textbox = CreateInstance("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Config.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 42)
            })
            CreateInstance("UICorner", {Parent = Textbox, CornerRadius = UDim.new(0, 8)})
            
            CreateInstance("TextLabel", {
                Parent = Textbox,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.4, 0, 1, 0),
                Font = Config.FontSemiBold,
                Text = textName,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local InputBox = CreateInstance("TextBox", {
                Parent = Textbox,
                BackgroundColor3 = Config.TertiaryColor,
                Position = UDim2.new(0.4, 5, 0.5, 0),
                Size = UDim2.new(0.6, -20, 0, 28),
                AnchorPoint = Vector2.new(0, 0.5),
                Font = Config.FontRegular,
                PlaceholderText = textPlaceholder,
                PlaceholderColor3 = Config.SubTextColor,
                Text = "",
                TextColor3 = Config.TextColor,
                TextSize = 12,
                ClearTextOnFocus = false
            })
            CreateInstance("UICorner", {Parent = InputBox, CornerRadius = UDim.new(0, 6)})
            CreateInstance("UIPadding", {Parent = InputBox, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
            
            InputBox.FocusLost:Connect(function(enter)
                if enter then
                    textCallback(InputBox.Text)
                end
            end)
        end

        -- Keybind
        function Tab:CreateKeybind(options)
            local keyName = options.Name or "Keybind"
            local keyDefault = options.Default or Enum.KeyCode.E
            local keyCallback = options.Callback or function() end
            local currentKey = keyDefault
            local listening = false
            
            local Keybind = CreateInstance("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Config.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 42)
            })
            CreateInstance("UICorner", {Parent = Keybind, CornerRadius = UDim.new(0, 8)})
            
            CreateInstance("TextLabel", {
                Parent = Keybind,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -80, 1, 0),
                Font = Config.FontSemiBold,
                Text = keyName,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local KeyBtn = CreateInstance("TextButton", {
                Parent = Keybind,
                BackgroundColor3 = Config.TertiaryColor,
                Position = UDim2.new(1, -65, 0.5, 0),
                Size = UDim2.new(0, 50, 0, 26),
                AnchorPoint = Vector2.new(0, 0.5),
                Font = Config.FontSemiBold,
                Text = keyDefault.Name,
                TextColor3 = Config.TextColor,
                TextSize = 11,
                AutoButtonColor = false
            })
            CreateInstance("UICorner", {Parent = KeyBtn, CornerRadius = UDim.new(0, 6)})
            
            KeyBtn.MouseButton1Click:Connect(function()
                KeyBtn.Text = "..."
                listening = true
            end)
            
            UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    KeyBtn.Text = currentKey.Name
                    listening = false
                elseif input.KeyCode == currentKey then
                    keyCallback()
                end
            end)
            
            local KeyFuncs = {}
            function KeyFuncs:Set(key)
                currentKey = key
                KeyBtn.Text = key.Name
            end
            return KeyFuncs
        end

        -- Label
        function Tab:CreateLabel(text)
            local Label = CreateInstance("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Config.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 36)
            })
            CreateInstance("UICorner", {Parent = Label, CornerRadius = UDim.new(0, 8)})
            
            local LabelText = CreateInstance("TextLabel", {
                Parent = Label,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Config.FontRegular,
                Text = text or "Label",
                TextColor3 = Config.SubTextColor,
                TextSize = 12
            })
            
            local LabelFuncs = {}
            function LabelFuncs:Set(newText)
                LabelText.Text = newText
            end
            return LabelFuncs
        end

        return Tab
    end

    return Window
end

return Library
