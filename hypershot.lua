local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local ESPEnabled = false
local BoxESPEnabled = true
local NameESPEnabled = true
local HealthBarEnabled = true
local DistanceESPEnabled = true
local TracerEnabled = false
local SkeletonEnabled = false
local ChamsEnabled = false
local TeamCheckEnabled = false
local ESPColor = Color3.fromRGB(255, 0, 0)
local ESPDistance = 1000
local TextSize = 14
local ESPThickness = 1

local ESPObjects = {}

-- Küçük Frame
local smallFrame = Instance.new("Frame")
smallFrame.Size = UDim2.new(0, 140, 0, 55)
smallFrame.Position = UDim2.new(0, 20, 0.4, 0)
smallFrame.BackgroundTransparency = 0.45
smallFrame.BorderSizePixel = 0
smallFrame.Parent = screenGui

local smallCorner = Instance.new("UICorner")
smallCorner.CornerRadius = UDim.new(0, 16)
smallCorner.Parent = smallFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 120, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 235, 235))
}
gradient.Parent = smallFrame

local strokeSmall = Instance.new("UIStroke")
strokeSmall.Thickness = 2
strokeSmall.Color = Color3.fromRGB(255, 255, 255)
strokeSmall.Transparency = 0.65
strokeSmall.Parent = smallFrame

local charImage = Instance.new("ImageButton")
charImage.Size = UDim2.new(0, 36, 0, 36)
charImage.Position = UDim2.new(0, 8, 0.5, -18)
charImage.BackgroundTransparency = 1
charImage.Image = "rbxassetid://88445176259961"
charImage.Parent = smallFrame

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -55, 1, 0)
textLabel.Position = UDim2.new(0, 50, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "2t1.lua"
textLabel.Font = Enum.Font.SourceSansLight
textLabel.TextSize = 22
textLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Parent = smallFrame

local bigFrame = Instance.new("Frame")
bigFrame.Size = UDim2.new(0, 650, 0, 400)
bigFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
bigFrame.BackgroundTransparency = 0.45
bigFrame.Visible = false
bigFrame.BorderSizePixel = 0
bigFrame.Parent = screenGui

local bigCorner = Instance.new("UICorner")
bigCorner.CornerRadius = UDim.new(0, 20)
bigCorner.Parent = bigFrame

local bigGradient = gradient:Clone()
bigGradient.Parent = bigFrame

local strokeBig = Instance.new("UIStroke")
strokeBig.Thickness = 2
strokeBig.Color = Color3.fromRGB(255, 255, 255)
strokeBig.Transparency = 0.65
strokeBig.Parent = bigFrame

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundTransparency = 0.25
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sidebar.BorderSizePixel = 0
sidebar.Parent = bigFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 20)
sidebarCorner.Parent = sidebar

local topBox = Instance.new("Frame")
topBox.Size = UDim2.new(1, -20, 0, 55)
topBox.Position = UDim2.new(0, 10, 0, 10)
topBox.BackgroundTransparency = 0.45
topBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
topBox.BorderSizePixel = 0
topBox.Parent = sidebar

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBox

local topStroke = Instance.new("UIStroke")
topStroke.Thickness = 1.5
topStroke.Color = Color3.fromRGB(255, 255, 255)
topStroke.Transparency = 0.65
topStroke.Parent = topBox

local charImage2 = charImage:Clone()
charImage2.Position = UDim2.new(0, 8, 0.5, -18)
charImage2.Parent = topBox

local textLabel2 = textLabel:Clone()
textLabel2.Position = UDim2.new(0, 50, 0, 0)
textLabel2.Text = "2t1.lua"
textLabel2.Parent = topBox

local function createButton(name, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundTransparency = 0.4
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansLight
    btn.TextSize = 16
    btn.Text = name
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
    }
    btnGradient.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Transparency = 0.7
    btnStroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.2
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.4
        }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.4
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.7
        }):Play()
    end)

    return btn
end

local silentAimBtn = createButton("Silent Aim", 80)
local espBtn = createButton("ESP", 130)

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -190, 1, -20)
contentFrame.Position = UDim2.new(0, 190, 0, 10)
contentFrame.BackgroundTransparency = 0.5
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = bigFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 15)
contentCorner.Parent = contentFrame

local espScrollFrame = Instance.new("ScrollingFrame")
espScrollFrame.Size = UDim2.new(1, -10, 1, -10)
espScrollFrame.Position = UDim2.new(0, 5, 0, 5)
espScrollFrame.BackgroundTransparency = 1
espScrollFrame.BorderSizePixel = 0
espScrollFrame.ScrollBarThickness = 6
espScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
espScrollFrame.ScrollBarImageTransparency = 0.5
espScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
espScrollFrame.Visible = false
espScrollFrame.Parent = contentFrame

local silentAimContent = Instance.new("Frame")
silentAimContent.Size = UDim2.new(1, 0, 1, 0)
silentAimContent.BackgroundTransparency = 1
silentAimContent.Visible = true
silentAimContent.Parent = contentFrame

local function createToggle(parent, text, default, callback, yPos)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = UDim2.new(0, 10, 0, yPos or 60)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 54, 0, 24)
    switch.Position = UDim2.new(1, -64, 0.5, -12)
    switch.BackgroundTransparency = 1
    switch.BorderSizePixel = 0
    switch.Parent = toggleFrame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -16, 0, 2)
    track.Position = UDim2.new(0, 8, 0.5, -1)
    track.BackgroundTransparency = 1
    track.Parent = switch

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Thickness = 2
    trackStroke.Transparency = 0.3
    trackStroke.Parent = track

    local trackGradient = Instance.new("UIGradient")
    trackGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 120, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
    }
    trackGradient.Parent = trackStroke

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local knobGradient = Instance.new("UIGradient")
    knobGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(245, 245, 245))
    }
    knobGradient.Parent = knob

    local enabled = default

    local function updateToggle(state)
        enabled = state
        local goalPos = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        TweenService:Create(
            knob,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Position = goalPos }
        ):Play()
        
        if callback then callback(state) end
    end

    local function tryToggle(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle(not enabled)
        end
    end

    toggleFrame.InputBegan:Connect(tryToggle)
    switch.InputBegan:Connect(tryToggle)
    knob.InputBegan:Connect(tryToggle)

    return {
        Set = updateToggle,
        Get = function() return enabled end
    }
end

local function dropdownkanka(parent, text, options, default, callback, yPos)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, -20, 0, 50)
    dropdownFrame.Position = UDim2.new(0, 10, 0, yPos or 120)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownFrame

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0, 120, 0, 35)
    dropdown.Position = UDim2.new(1, -130, 0.5, -17.5)
    dropdown.BackgroundTransparency = 0.2
    dropdown.BorderSizePixel = 0
    dropdown.Text = ""
    dropdown.Parent = dropdownFrame

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 8)
    dropdownCorner.Parent = dropdown

    local dropdownGradient = Instance.new("UIGradient")
    dropdownGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
    }
    dropdownGradient.Parent = dropdown

    local dropdownStroke = Instance.new("UIStroke")
    dropdownStroke.Thickness = 1.5
    dropdownStroke.Color = Color3.fromRGB(255, 255, 255)
    dropdownStroke.Transparency = 0.6
    dropdownStroke.Parent = dropdown

    local selectedText = Instance.new("TextLabel")
    selectedText.Size = UDim2.new(1, -30, 1, 0)
    selectedText.Position = UDim2.new(0, 10, 0, 0)
    selectedText.BackgroundTransparency = 1
    selectedText.Text = tostring(default)
    selectedText.Font = Enum.Font.SourceSansLight
    selectedText.TextSize = 16
    selectedText.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectedText.TextXAlignment = Enum.TextXAlignment.Left
    selectedText.Parent = dropdown

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.SourceSansBold
    arrow.TextSize = 12
    arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
    arrow.Parent = dropdown

    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(0, 120, 0, math.min(#options * 30, 150))
    dropdownList.Position = UDim2.new(0, 0, 1, 5)
    dropdownList.BackgroundTransparency = 0.1
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ZIndex = 10
    dropdownList.Parent = dropdown

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 8)
    listCorner.Parent = dropdownList

    local listGradient = Instance.new("UIGradient")
    listGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 60, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
    }
    listGradient.Parent = dropdownList

    local listStroke = Instance.new("UIStroke")
    listStroke.Thickness = 1.5
    listStroke.Color = Color3.fromRGB(255, 255, 255)
    listStroke.Transparency = 0.5
    listStroke.Parent = dropdownList

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -4, 1, -4)
    scrollFrame.Position = UDim2.new(0, 2, 0, 2)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scrollFrame.ScrollBarImageTransparency = 0.7
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
    scrollFrame.Parent = dropdownList

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = scrollFrame

    local isOpen = false
    local selectedValue = default

    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, -8, 0, 26)
        optionBtn.BackgroundTransparency = 0.3
        optionBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = tostring(option)
        optionBtn.Font = Enum.Font.SourceSansLight
        optionBtn.TextSize = 14
        optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionBtn.AutoButtonColor = false
        optionBtn.Parent = scrollFrame

        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 6)
        optionCorner.Parent = optionBtn

        optionBtn.MouseEnter:Connect(function()
            TweenService:Create(optionBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 0.1,
                BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            }):Play()
        end)

        optionBtn.MouseLeave:Connect(function()
            TweenService:Create(optionBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 0.3,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            }):Play()
        end)

        optionBtn.MouseButton1Click:Connect(function()
            selectedValue = option
            selectedText.Text = tostring(option)
            dropdownList.Visible = false
            arrow.Text = "▼"
            isOpen = false
            
            if callback then callback(option) end
        end)
    end

    dropdown.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        dropdownList.Visible = isOpen
        arrow.Text = isOpen and "▲" or "▼"
        
        if isOpen then
            dropdownList.Size = UDim2.new(0, 120, 0, 0)
            TweenService:Create(dropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 120, 0, math.min(#options * 30, 150))
            }):Play()
        end
    end)

    return {
        SetValue = function(value)
            selectedValue = value
            selectedText.Text = tostring(value)
            if callback then callback(value) end
        end,
        GetValue = function() return selectedValue end,
        GetSelected = function() return selectedValue end
    }
end

local function createSlider(parent, text, min, max, default, callback, yPos)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 60)
    sliderFrame.Position = UDim2.new(0, 10, 0, yPos or 180)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 30)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.Font = Enum.Font.SourceSansLight
    valueLabel.TextSize = 18
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Parent = sliderFrame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 4)
    sliderBar.Position = UDim2.new(0, 10, 0, 35)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBar

    local fillBar = Instance.new("Frame")
    fillBar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fillBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fillBar.BorderSizePixel = 0
    fillBar.Parent = sliderBar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fillBar

    local sliderButton = Instance.new("Frame")
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderBar

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton

    local dragging = false
    local currentValue = default

    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * relativeX)
        
        currentValue = value
        valueLabel.Text = tostring(value)
        
        TweenService:Create(fillBar, TweenInfo.new(0.1), {Size = UDim2.new(relativeX, 0, 1, 0)}):Play()
        TweenService:Create(sliderButton, TweenInfo.new(0.1), {Position = UDim2.new(relativeX, -8, 0.5, -8)}):Play()
        
        if callback then callback(value) end
    end

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return {
        GetValue = function() return currentValue end,
        SetValue = function(value)
            currentValue = value
            valueLabel.Text = tostring(value)
            local relativeX = (value - min) / (max - min)
            fillBar.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -8, 0.5, -8)
            if callback then callback(value) end
        end
    }
end

local function createColorPicker(parent, text, defaultColor, callback, yPos)
    local colorFrame = Instance.new("Frame")
    colorFrame.Size = UDim2.new(1, -20, 0, 180)  -- Daha büyük alan
    colorFrame.Position = UDim2.new(0, 10, 0, yPos or 240)
    colorFrame.BackgroundTransparency = 1
    colorFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = colorFrame

    local colorDisplay = Instance.new("Frame")
    colorDisplay.Size = UDim2.new(0, 100, 0, 35)
    colorDisplay.Position = UDim2.new(1, -110, 0, 0)
    colorDisplay.BackgroundColor3 = defaultColor
    colorDisplay.BorderSizePixel = 0
    colorDisplay.Parent = colorFrame

    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 10)
    colorCorner.Parent = colorDisplay

    local colorStroke = Instance.new("UIStroke")
    colorStroke.Thickness = 2
    colorStroke.Color = Color3.fromRGB(255, 255, 255)
    colorStroke.Transparency = 0.4
    colorStroke.Parent = colorDisplay

    local currentR = defaultColor.R * 255
    local currentG = defaultColor.G * 255
    local currentB = defaultColor.B * 255

    local function updateColor()
        local newColor = Color3.fromRGB(currentR, currentG, currentB)
        colorDisplay.BackgroundColor3 = newColor
        if callback then callback(newColor) end
    end

    local redFrame = Instance.new("Frame")
    redFrame.Size = UDim2.new(1, -10, 0, 35)
    redFrame.Position = UDim2.new(0, 5, 0, 45)
    redFrame.BackgroundTransparency = 1
    redFrame.Parent = colorFrame

    local redLabel = Instance.new("TextLabel")
    redLabel.Size = UDim2.new(0, 30, 1, 0)
    redLabel.BackgroundTransparency = 1
    redLabel.Text = "R"
    redLabel.Font = Enum.Font.SourceSansBold
    redLabel.TextSize = 16
    redLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    redLabel.Parent = redFrame

    local redValue = Instance.new("TextLabel")
    redValue.Size = UDim2.new(0, 40, 1, 0)
    redValue.Position = UDim2.new(1, -45, 0, 0)
    redValue.BackgroundTransparency = 1
    redValue.Text = tostring(math.floor(currentR))
    redValue.Font = Enum.Font.SourceSans
    redValue.TextSize = 14
    redValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    redValue.Parent = redFrame

    local redBar = Instance.new("Frame")
    redBar.Size = UDim2.new(1, -120, 0, 6)
    redBar.Position = UDim2.new(0, 35, 0.5, -3)
    redBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    redBar.BorderSizePixel = 0
    redBar.Parent = redFrame

    local redBarCorner = Instance.new("UICorner")
    redBarCorner.CornerRadius = UDim.new(1, 0)
    redBarCorner.Parent = redBar

    local redFill = Instance.new("Frame")
    redFill.Size = UDim2.new(currentR / 255, 0, 1, 0)
    redFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    redFill.BorderSizePixel = 0
    redFill.Parent = redBar

    local redFillCorner = Instance.new("UICorner")
    redFillCorner.CornerRadius = UDim.new(1, 0)
    redFillCorner.Parent = redFill

    local redKnob = Instance.new("Frame")
    redKnob.Size = UDim2.new(0, 14, 0, 14)
    redKnob.Position = UDim2.new(currentR / 255, -7, 0.5, -7)
    redKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    redKnob.BorderSizePixel = 0
    redKnob.Parent = redBar

    local redKnobCorner = Instance.new("UICorner")
    redKnobCorner.CornerRadius = UDim.new(1, 0)
    redKnobCorner.Parent = redKnob

    local greenFrame = Instance.new("Frame")
    greenFrame.Size = UDim2.new(1, -10, 0, 35)
    greenFrame.Position = UDim2.new(0, 5, 0, 85)
    greenFrame.BackgroundTransparency = 1
    greenFrame.Parent = colorFrame

    local greenLabel = Instance.new("TextLabel")
    greenLabel.Size = UDim2.new(0, 30, 1, 0)
    greenLabel.BackgroundTransparency = 1
    greenLabel.Text = "G"
    greenLabel.Font = Enum.Font.SourceSansBold
    greenLabel.TextSize = 16
    greenLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    greenLabel.Parent = greenFrame

    local greenValue = Instance.new("TextLabel")
    greenValue.Size = UDim2.new(0, 40, 1, 0)
    greenValue.Position = UDim2.new(1, -45, 0, 0)
    greenValue.BackgroundTransparency = 1
    greenValue.Text = tostring(math.floor(currentG))
    greenValue.Font = Enum.Font.SourceSans
    greenValue.TextSize = 14
    greenValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    greenValue.Parent = greenFrame

    local greenBar = Instance.new("Frame")
    greenBar.Size = UDim2.new(1, -120, 0, 6)
    greenBar.Position = UDim2.new(0, 35, 0.5, -3)
    greenBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    greenBar.BorderSizePixel = 0
    greenBar.Parent = greenFrame

    local greenBarCorner = Instance.new("UICorner")
    greenBarCorner.CornerRadius = UDim.new(1, 0)
    greenBarCorner.Parent = greenBar

    local greenFill = Instance.new("Frame")
    greenFill.Size = UDim2.new(currentG / 255, 0, 1, 0)
    greenFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    greenFill.BorderSizePixel = 0
    greenFill.Parent = greenBar

    local greenFillCorner = Instance.new("UICorner")
    greenFillCorner.CornerRadius = UDim.new(1, 0)
    greenFillCorner.Parent = greenFill

    local greenKnob = Instance.new("Frame")
    greenKnob.Size = UDim2.new(0, 14, 0, 14)
    greenKnob.Position = UDim2.new(currentG / 255, -7, 0.5, -7)
    greenKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    greenKnob.BorderSizePixel = 0
    greenKnob.Parent = greenBar

    local greenKnobCorner = Instance.new("UICorner")
    greenKnobCorner.CornerRadius = UDim.new(1, 0)
    greenKnobCorner.Parent = greenKnob

    local blueFrame = Instance.new("Frame")
    blueFrame.Size = UDim2.new(1, -10, 0, 35)
    blueFrame.Position = UDim2.new(0, 5, 0, 125)
    blueFrame.BackgroundTransparency = 1
    blueFrame.Parent = colorFrame

    local blueLabel = Instance.new("TextLabel")
    blueLabel.Size = UDim2.new(0, 30, 1, 0)
    blueLabel.BackgroundTransparency = 1
    blueLabel.Text = "B"
    blueLabel.Font = Enum.Font.SourceSansBold
    blueLabel.TextSize = 16
    blueLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
    blueLabel.Parent = blueFrame

    local blueValue = Instance.new("TextLabel")
    blueValue.Size = UDim2.new(0, 40, 1, 0)
    blueValue.Position = UDim2.new(1, -45, 0, 0)
    blueValue.BackgroundTransparency = 1
    blueValue.Text = tostring(math.floor(currentB))
    blueValue.Font = Enum.Font.SourceSans
    blueValue.TextSize = 14
    blueValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    blueValue.Parent = blueFrame

    local blueBar = Instance.new("Frame")
    blueBar.Size = UDim2.new(1, -120, 0, 6)
    blueBar.Position = UDim2.new(0, 35, 0.5, -3)
    blueBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    blueBar.BorderSizePixel = 0
    blueBar.Parent = blueFrame

    local blueBarCorner = Instance.new("UICorner")
    blueBarCorner.CornerRadius = UDim.new(1, 0)
    blueBarCorner.Parent = blueBar

    local blueFill = Instance.new("Frame")
    blueFill.Size = UDim2.new(currentB / 255, 0, 1, 0)
    blueFill.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    blueFill.BorderSizePixel = 0
    blueFill.Parent = blueBar

    local blueFillCorner = Instance.new("UICorner")
    blueFillCorner.CornerRadius = UDim.new(1, 0)
    blueFillCorner.Parent = blueFill

    local blueKnob = Instance.new("Frame")
    blueKnob.Size = UDim2.new(0, 14, 0, 14)
    blueKnob.Position = UDim2.new(currentB / 255, -7, 0.5, -7)
    blueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    blueKnob.BorderSizePixel = 0
    blueKnob.Parent = blueBar

    local blueKnobCorner = Instance.new("UICorner")
    blueKnobCorner.CornerRadius = UDim.new(1, 0)
    blueKnobCorner.Parent = blueKnob

    local function setupSlider(bar, knob, fill, valueLabel, colorIndex)
        local dragging = false
        
        local function update(input)
            local relativeX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local value = math.floor(relativeX * 255)
            
            if colorIndex == "R" then
                currentR = value
            elseif colorIndex == "G" then
                currentG = value
            elseif colorIndex == "B" then
                currentB = value
            end
            
            valueLabel.Text = tostring(value)
            knob.Position = UDim2.new(relativeX, -7, 0.5, -7)
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            
            updateColor()
        end
        
        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                update(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end

    setupSlider(redBar, redKnob, redFill, redValue, "R")
    setupSlider(greenBar, greenKnob, greenFill, greenValue, "G")
    setupSlider(blueBar, blueKnob, blueFill, blueValue, "B")

    return {
        GetColor = function() return Color3.fromRGB(currentR, currentG, currentB) end,
        SetColor = function(color)
            currentR = color.R * 255
            currentG = color.G * 255
            currentB = color.B * 255
            updateColor()
        end
    }
end

local function CreateESP(plr)
    if plr == player then return end
    if ESPObjects[plr] then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = plr.Name .. "_ESP"
    espFolder.Parent = screenGui
    
    ESPObjects[plr] = {
        Folder = espFolder,
        Box = {},
        Name = nil,
        Health = {},
        Distance = nil,
        Tracer = nil,
        Skeleton = {},
        Chams = {}
    }
    
    local function createBoxESP()
        local box = {}
        
        for i = 1, 4 do
            local line = Instance.new("Frame")
            line.BackgroundColor3 = ESPColor
            line.BorderSizePixel = 0
            line.Visible = false
            line.Parent = espFolder
            box[i] = line
        end
        
        ESPObjects[plr].Box = box
    end
    
    local function createNameESP()
        local nameLabel = Instance.new("TextLabel")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = plr.Name
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = TextSize
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Visible = false
        nameLabel.Parent = espFolder
        
        ESPObjects[plr].Name = nameLabel
    end
    
    local function createHealthBar()
        local healthBG = Instance.new("Frame")
        healthBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        healthBG.BorderSizePixel = 0
        healthBG.Visible = false
        healthBG.Parent = espFolder
        
        local healthFill = Instance.new("Frame")
        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthFill.BorderSizePixel = 0
        healthFill.Parent = healthBG
        
        ESPObjects[plr].Health = {BG = healthBG, Fill = healthFill}
    end
    
    local function createDistanceESP()
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = "0m"
        distanceLabel.Font = Enum.Font.SourceSans
        distanceLabel.TextSize = TextSize - 2
        distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        distanceLabel.TextStrokeTransparency = 0
        distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distanceLabel.Visible = false
        distanceLabel.Parent = espFolder
        
        ESPObjects[plr].Distance = distanceLabel
    end
    
    local function createTracer()
        local tracer = Instance.new("Frame")
        tracer.BackgroundColor3 = ESPColor
        tracer.BorderSizePixel = 0
        tracer.AnchorPoint = Vector2.new(0.5, 0.5)
        tracer.Visible = false
        tracer.Parent = espFolder
        
        ESPObjects[plr].Tracer = tracer
    end
    
    createBoxESP()
    createNameESP()
    createHealthBar()
    createDistanceESP()
    createTracer()
end

local function RemoveESP(plr)
    if ESPObjects[plr] then
        ESPObjects[plr].Folder:Destroy()
        ESPObjects[plr] = nil
    end
end

local function oyleespiste()
    for plr, esp in pairs(ESPObjects) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
            local hrp = plr.Character.HumanoidRootPart
            local humanoid = plr.Character.Humanoid
            local head = plr.Character:FindFirstChild("Head")
            
            local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
            
            if distance <= ESPDistance then
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    -- Bunu Güncellersin hocam işte box tam olmuyor
                    if BoxESPEnabled and esp.Box then
                        local topLeft = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(-2, 3, 0)).Position)
                        local topRight = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(2, 3, 0)).Position)
                        local bottomLeft = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(-2, -3.5, 0)).Position)
                        local bottomRight = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(2, -3.5, 0)).Position)
                        
                        esp.Box[1].Position = UDim2.new(0, topLeft.X, 0, topLeft.Y)
                        esp.Box[1].Size = UDim2.new(0, topRight.X - topLeft.X, 0, ESPThickness)
                        esp.Box[1].Visible = true
                        esp.Box[1].BackgroundColor3 = ESPColor
                        
                        esp.Box[2].Position = UDim2.new(0, bottomLeft.X, 0, bottomLeft.Y)
                        esp.Box[2].Size = UDim2.new(0, bottomRight.X - bottomLeft.X, 0, ESPThickness)
                        esp.Box[2].Visible = true
                        esp.Box[2].BackgroundColor3 = ESPColor
                        
                        esp.Box[3].Position = UDim2.new(0, topLeft.X, 0, topLeft.Y)
                        esp.Box[3].Size = UDim2.new(0, ESPThickness, 0, bottomLeft.Y - topLeft.Y)
                        esp.Box[3].Visible = true
                        esp.Box[3].BackgroundColor3 = ESPColor
                        
                        esp.Box[4].Position = UDim2.new(0, topRight.X, 0, topRight.Y)
                        esp.Box[4].Size = UDim2.new(0, ESPThickness, 0, bottomRight.Y - topRight.Y)
                        esp.Box[4].Visible = true
                        esp.Box[4].BackgroundColor3 = ESPColor
                    else
                        for _, line in pairs(esp.Box) do
                            line.Visible = false
                        end
                    end
                    
                    if NameESPEnabled and esp.Name and head then
                        local headPos = Camera:WorldToViewportPoint((head.CFrame * CFrame.new(0, 1, 0)).Position)
                        esp.Name.Position = UDim2.new(0, headPos.X, 0, headPos.Y)
                        esp.Name.Visible = true
                        esp.Name.Text = plr.Name
                    elseif esp.Name then
                        esp.Name.Visible = false
                    end
                    
                    if HealthBarEnabled and esp.Health.BG then
                        local topLeft = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(-2.5, 3, 0)).Position)
                        local bottomLeft = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(-2.5, -3.5, 0)).Position)
                        
                        esp.Health.BG.Position = UDim2.new(0, topLeft.X - 5, 0, topLeft.Y)
                        esp.Health.BG.Size = UDim2.new(0, 3, 0, bottomLeft.Y - topLeft.Y)
                        esp.Health.BG.Visible = true
                        
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.Health.Fill.Size = UDim2.new(1, 0, healthPercent, 0)
                        esp.Health.Fill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
                        
                        if healthPercent > 0.66 then
                            esp.Health.Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        elseif healthPercent > 0.33 then
                            esp.Health.Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                        else
                            esp.Health.Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    elseif esp.Health.BG then
                        esp.Health.BG.Visible = false
                    end
                    
                    if DistanceESPEnabled and esp.Distance then
                        local bottomPos = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, -4, 0)).Position)
                        esp.Distance.Position = UDim2.new(0, bottomPos.X, 0, bottomPos.Y)
                        esp.Distance.Text = math.floor(distance) .. "m"
                        esp.Distance.Visible = true
                    elseif esp.Distance then
                        esp.Distance.Visible = false
                    end
                    
                    if TracerEnabled and esp.Tracer then
                        local tracerStart = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        local tracerEnd = Vector2.new(screenPos.X, screenPos.Y)
                        
                        local angle = math.atan2(tracerEnd.Y - tracerStart.Y, tracerEnd.X - tracerStart.X)
                        local distance = (tracerEnd - tracerStart).Magnitude
                        
                        esp.Tracer.Position = UDim2.new(0, tracerStart.X, 0, tracerStart.Y)
                        esp.Tracer.Size = UDim2.new(0, distance, 0, ESPThickness)
                        esp.Tracer.Rotation = math.deg(angle)
                        esp.Tracer.BackgroundColor3 = ESPColor
                        esp.Tracer.Visible = true
                    elseif esp.Tracer then
                        esp.Tracer.Visible = false
                    end
                else
                    for _, line in pairs(esp.Box) do
                        line.Visible = false
                    end
                    if esp.Name then esp.Name.Visible = false end
                    if esp.Health.BG then esp.Health.BG.Visible = false end
                    if esp.Distance then esp.Distance.Visible = false end
                    if esp.Tracer then esp.Tracer.Visible = false end
                end
            else
                for _, line in pairs(esp.Box) do
                    line.Visible = false
                end
                if esp.Name then esp.Name.Visible = false end
                if esp.Health.BG then esp.Health.BG.Visible = false end
                if esp.Distance then esp.Distance.Visible = false end
                if esp.Tracer then esp.Tracer.Visible = false end
            end
        else
            for _, line in pairs(esp.Box) do
                line.Visible = false
            end
            if esp.Name then esp.Name.Visible = false end
            if esp.Health.BG then esp.Health.BG.Visible = false end
            if esp.Distance then esp.Distance.Visible = false end
            if esp.Tracer then esp.Tracer.Visible = false end
        end
    end
end

local espMainToggle = createToggle(espScrollFrame, "Enable ESP", false, function(state)
    ESPEnabled = state
    if state then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                CreateESP(plr)
            end
        end
    else
        for plr, _ in pairs(ESPObjects) do
            RemoveESP(plr)
        end
    end
end, 10)

local boxToggle = createToggle(espScrollFrame, "Box ESP", true, function(state)
    BoxESPEnabled = state
end, 60)

local nameToggle = createToggle(espScrollFrame, "Name ESP", true, function(state)
    NameESPEnabled = state
end, 110)

local healthToggle = createToggle(espScrollFrame, "Health Bar", true, function(state)
    HealthBarEnabled = state
end, 160)

local distanceToggle = createToggle(espScrollFrame, "Distance", true, function(state)
    DistanceESPEnabled = state
end, 210)

local tracerToggle = createToggle(espScrollFrame, "Tracers", false, function(state)
    TracerEnabled = state
end, 260)

local teamCheckToggle = createToggle(espScrollFrame, "Team Check", false, function(state)
    TeamCheckEnabled = state
end, 310)

local espDistanceSlider = createSlider(espScrollFrame, "Max Distance", 100, 5000, 1000, function(value)
    ESPDistance = value
end, 360)

local espColorPicker = createColorPicker(espScrollFrame, "ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    ESPColor = color
end, 430)

local textSizeSlider = createSlider(espScrollFrame, "Text Size", 10, 24, 14, function(value)
    TextSize = value
end, 620)

espScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 700)

local currentPage = "SilentAim"

local function switchPage(name)
    currentPage = name
    if name == "SilentAim" then
        silentAimContent.Visible = true
        espScrollFrame.Visible = false
    elseif name == "ESP" then
        silentAimContent.Visible = false
        espScrollFrame.Visible = true
    end
end

silentAimBtn.MouseButton1Click:Connect(function() switchPage("SilentAim") end)
espBtn.MouseButton1Click:Connect(function() switchPage("ESP") end)

Players.PlayerAdded:Connect(function(plr)
    if ESPEnabled and plr ~= player then
        CreateESP(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    RemoveESP(plr)
end)

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        oyleespiste()
    end
end)

local isOpen = false
local isTweening = false
local originalPosition = UDim2.new(0, 20, 0.4, 0)

local function toggleGui()
    if isTweening then return end
    isTweening = true

    if not isOpen then
        bigFrame.Visible = true
        bigFrame.Size = UDim2.new(0, 140, 0, 55)
        bigFrame.Position = smallFrame.Position
        smallFrame.Visible = false

        local tween1 = TweenService:Create(bigFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 650, 0, 400),
            Position = UDim2.new(0.5, -325, 0.5, -200)
        })
        tween1:Play()
        tween1.Completed:Wait()

        isOpen = true
        isTweening = false
    else
        local tween1 = TweenService:Create(bigFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 140, 0, 55),
            Position = originalPosition
        })
        tween1:Play()
        tween1.Completed:Wait()

        bigFrame.Visible = false
        smallFrame.Position = originalPosition
        smallFrame.Visible = true
        isOpen = false
        isTweening = false
    end
end

charImage.MouseButton1Click:Connect(toggleGui)
charImage2.MouseButton1Click:Connect(toggleGui)

local dragging = false
local dragStart, startPos

local function updateDrag(input)
    if dragging and not isOpen then
        local delta = input.Position - dragStart
        local goal = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

        TweenService:Create(
            smallFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = goal}
        ):Play()

        originalPosition = goal
    end
end

smallFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = smallFrame.Position
    end
end)

smallFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

switchPage("SilentAim")
