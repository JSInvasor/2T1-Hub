-- omg
local TweenService = game:GetService("TweenService") 
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Küçük Frame
local smallFrame = Instance.new("Frame")
smallFrame.Size = UDim2.new(0, 140, 0, 55)
smallFrame.Position = UDim2.new(0, 20, 0.4, 0)
smallFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
smallFrame.BackgroundTransparency = 0.1
smallFrame.BorderSizePixel = 0
smallFrame.Parent = screenGui

local smallCorner = Instance.new("UICorner")
smallCorner.CornerRadius = UDim.new(0, 16)
smallCorner.Parent = smallFrame

local strokeSmall = Instance.new("UIStroke")
strokeSmall.Thickness = 2
strokeSmall.Color = Color3.fromRGB(200,200,200)
strokeSmall.Transparency = 0.3
strokeSmall.Parent = smallFrame

local charImage = Instance.new("ImageButton")
charImage.Size = UDim2.new(0, 36, 0, 36)
charImage.Position = UDim2.new(0, 8, 0.5, -18)
charImage.BackgroundTransparency = 1
charImage.Image = "rbxassetid://16725645010"
charImage.Parent = smallFrame

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -55, 1, 0)
textLabel.Position = UDim2.new(0, 50, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "2t1.lua"
textLabel.Font = Enum.Font.Gotham
textLabel.TextSize = 22
textLabel.TextColor3 = Color3.fromRGB(240,240,240)
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Parent = smallFrame

local bigFrame = Instance.new("Frame")
bigFrame.Size = UDim2.new(0, 650, 0, 400)
bigFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
bigFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
bigFrame.BackgroundTransparency = 0.05
bigFrame.Visible = false
bigFrame.BorderSizePixel = 0
bigFrame.Parent = screenGui

local bigCorner = Instance.new("UICorner")
bigCorner.CornerRadius = UDim.new(0, 20)
bigCorner.Parent = bigFrame

local strokeBig = Instance.new("UIStroke")
strokeBig.Thickness = 2
strokeBig.Color = Color3.fromRGB(200,200,200)
strokeBig.Transparency = 0.3
strokeBig.Parent = bigFrame

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(25,25,25)
sidebar.BorderSizePixel = 0
sidebar.Parent = bigFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 20)
sidebarCorner.Parent = sidebar

local topBox = Instance.new("Frame")
topBox.Size = UDim2.new(1, -20, 0, 55)
topBox.Position = UDim2.new(0, 10, 0, 10)
topBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
topBox.BorderSizePixel = 0
topBox.Parent = sidebar

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBox

local topStroke = Instance.new("UIStroke")
topStroke.Thickness = 1
topStroke.Color = Color3.fromRGB(200,200,200)
topStroke.Transparency = 0.4
topStroke.Parent = topBox

local charImage2 = charImage:Clone()
charImage2.Parent = topBox

local textLabel2 = textLabel:Clone()
textLabel2.Text = "2t1.lua"
textLabel2.Parent = topBox

local function createButton(name, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Text = name
    btn.AutoButtonColor = true
    btn.Parent = sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(55,55,55)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
    end)

    return btn
end

local silentBtn = createButton("Silent Aim", 80)
local espBtn = createButton("ESP", 130)

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -190, 1, -20)
contentFrame.Position = UDim2.new(0, 190, 0, 10)
contentFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = bigFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 15)
contentCorner.Parent = contentFrame

local function createToggle(parent, text, y)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 220, 0, 35)
    toggle.Position = UDim2.new(0, 20, 0, y)
    toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
    toggle.TextColor3 = Color3.fromRGB(220,220,220)
    toggle.Text = text .. ": OFF"
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 18
    toggle.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toggle

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = text .. (state and ": ON" or ": OFF")
        TweenService:Create(toggle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundColor3 = state and Color3.fromRGB(240,240,240) or Color3.fromRGB(30,30,30),
            TextColor3 = state and Color3.fromRGB(20,20,20) or Color3.fromRGB(220,220,220)
        }):Play()
    end)

    return toggle
end

local function createDropdown(parent, text, items, y)
    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 220, 0, 35)
    box.Position = UDim2.new(0, 20, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(30,30,30)
    box.Text = text .. ": " .. items[1]
    box.TextColor3 = Color3.fromRGB(220,220,220)
    box.Font = Enum.Font.Gotham
    box.TextSize = 18
    box.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box

    local currentIndex = 1
    box.MouseButton1Click:Connect(function()
        currentIndex = (currentIndex % #items) + 1
        TweenService:Create(box, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
        task.wait(0.2)
        box.Text = text .. ": " .. items[currentIndex]
        TweenService:Create(box, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
    end)

    return box
end

local function switchPage(name)
    for _,v in pairs(contentFrame:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end

    if name == "Silent Aim" then
        createToggle(contentFrame, "Enable Silent Aim", 20)
        createDropdown(contentFrame, "Target Part", {"Head", "Torso", "Random"}, 70)

    elseif name == "ESP" then
        createToggle(contentFrame, "Enable ESP", 20)
        createDropdown(contentFrame, "ESP Mode", {"Box", "Highlight", "Chams"}, 70)
    end
end

silentBtn.MouseButton1Click:Connect(function() switchPage("Silent Aim") end)
espBtn.MouseButton1Click:Connect(function() switchPage("ESP") end)

local isOpen, isTweening = false, false
local function toggleGui()
    if isTweening then return end
    isTweening = true

    if not isOpen then
        bigFrame.Visible = true
        bigFrame.Size = UDim2.new(0, 140, 0, 55)
        bigFrame.Position = smallFrame.Position
        smallFrame.Visible = false

        local tween1 = TweenService:Create(bigFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 650, 0, 400),
            Position = UDim2.new(0.5, -325, 0.5, -200)
        })
        tween1:Play()
        tween1.Completed:Wait()

        isOpen, isTweening = true, false
    else
        local tween1 = TweenService:Create(bigFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 140, 0, 55),
            Position = UDim2.new(0, 20, 0.4, 0)
        })
        tween1:Play()
        tween1.Completed:Wait()

        bigFrame.Visible = false
        smallFrame.Visible = true
        isOpen, isTweening = false, false
    end
end

charImage.MouseButton1Click:Connect(toggleGui)
charImage2.MouseButton1Click:Connect(toggleGui)

local dragging, dragStart, startPos = false
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
    end
end

smallFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = smallFrame.Position
    end
end)

smallFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement 
    or input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
