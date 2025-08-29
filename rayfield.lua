-- omg
local TweenService = game:GetService("TweenService") 
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

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
charImage.Image = "rbxassetid://16725645010"
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
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Text = name
    btn.AutoButtonColor = true
    btn.Parent = sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    return btn
end

local autoParryBtn = createButton("Autoparry", 80)
local playerBtn = createButton("Player", 130)
local visualsBtn = createButton("Visuals", 180)
local worldBtn = createButton("World", 230)
local miscBtn = createButton("Misc", 280)
local exclusiveBtn = createButton("Exclusive", 330)

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

local pages = {
    Autoparry = "Autoparry Settings",
    Player = "Player Settings",
    Visuals = "Visual Settings",
    World = "World Options",
    Misc = "Miscellaneous",
    Exclusive = "Exclusive Features"
}

local contentLabel = Instance.new("TextLabel")
contentLabel.Size = UDim2.new(1, 0, 1, 0)
contentLabel.BackgroundTransparency = 1
contentLabel.Font = Enum.Font.GothamSemibold
contentLabel.TextSize = 24
contentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
contentLabel.Text = "Select a category"
contentLabel.Parent = contentFrame

local function switchPage(name)
    contentLabel.Text = pages[name] or "Unknown"
end

autoParryBtn.MouseButton1Click:Connect(function() switchPage("Autoparry") end)
playerBtn.MouseButton1Click:Connect(function() switchPage("Player") end)
visualsBtn.MouseButton1Click:Connect(function() switchPage("Visuals") end)
worldBtn.MouseButton1Click:Connect(function() switchPage("World") end)
miscBtn.MouseButton1Click:Connect(function() switchPage("Misc") end)
exclusiveBtn.MouseButton1Click:Connect(function() switchPage("Exclusive") end)

local isOpen = false
local isTweening = false

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
			Position = UDim2.new(0, 20, 0.4, 0)
		})
		tween1:Play()
		tween1.Completed:Wait()

		bigFrame.Visible = false
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
