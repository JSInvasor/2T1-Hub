--[[
	Mako UI Lib
		@author 2ds
		RAHHHHHHHHHHHHHHHHHH
--]]

local MakoLib = {}
local Objects = (game:GetService("RunService"):IsStudio() and game.ReplicatedStorage.MakoUI) or game:GetObjects("rbxassetid://13874998303")[1]
local MainColor = Color3.fromRGB(255, 255, 255)
local Services = setmetatable({}, {
	__index = function(self, key)
		return game:GetService(key)
	end,
})
local Player = Services.Players.LocalPlayer
local Mouse = Player:GetMouse()

local Window = {}; do
	Window.__index = Window
	local Tab = {}; do
		Tab.__index = Tab
		local Section = {}; do
			Section.__index = Section
			function Section:CreateToggle(data)
				local keybindSet = nil
				local nwToggle = Objects.Props.Toggle:Clone()
				nwToggle.Title.Text = data.Title
				nwToggle.Parent = self.UI.Main
				local tInfo = TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, 0, false, 0)
				local onTween = Services.TweenService:Create(nwToggle.ToggleButton, tInfo, {BackgroundTransparency = 0})
				local offTween = Services.TweenService:Create(nwToggle.ToggleButton, tInfo, {BackgroundTransparency = 1})
				local boolToTween = {
					[true] = onTween,
					[false] = offTween
				}
				boolToTween[data.CurrentValue]:Play()
				local function update(t)
					if not t then
						data.CurrentValue = not data.CurrentValue
					end
					boolToTween[data.CurrentValue]:Play()
					data.Callback(data.CurrentValue)
				end
				nwToggle.ToggleButton.MouseButton1Click:Connect(function()
					update(false)
				end)
				self.UI.Main.Size += UDim2.new(0, 0, 0, 26)
				if data.Binding then
					nwToggle.SetKeyButton.Visible = true
					local waiting = false
					nwToggle.SetKeyButton.MouseButton1Click:Connect(function()
						if not waiting then
							waiting = true
							nwToggle.SetKeyButton.Text = "Waiting.."
							local e; e = Services.UserInputService.InputBegan:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.Keyboard then
									nwToggle.SetKeyButton.Text = input.KeyCode.Name
									waiting = false
									task.spawn(function()
										task.wait()
										keybindSet = input.KeyCode
									end)
									e:Disconnect()
								end
							end)
						end
					end)
					Services.UserInputService.InputBegan:Connect(function(input, gp)
						if not gp then
							if input.KeyCode == keybindSet then
								update()
							end
						end
					end)
				end
				return {
					Set = function(val)
						data.CurrentValue = val
						update(true)
					end,
				}
			end
			function Section:CreateSlider(data)
				local rangeMin = data.Range[1]
				local rangeMax = data.Range[2]
				local dragging, dragInput = false, nil
				local nwSlider = Objects.Props.Slider:Clone()
				nwSlider.Title.Text = data.Title
				nwSlider.Parent = self.UI.Main
				local function update()
					local percentage = (data.CurrentValue - rangeMin) / (rangeMax - rangeMin)
					nwSlider.Number.Text = math.round(data.CurrentValue * 10) / 10
					nwSlider.BG.Bar.Size = UDim2.new(math.clamp(percentage, 0, 1), 0, 1, 0)
					data.Callback(data.CurrentValue)
				end
				update()
				nwSlider.BG.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						local e; e = input.Changed:Connect(function()
							if input.UserInputState == Enum.UserInputState.End then
								dragging = false
								e:Disconnect()
							end
						end)
					end
				end)

				nwSlider.BG.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						dragInput = input
					end
				end)

				Services.UserInputService.InputChanged:Connect(function(input)
					if input == dragInput and dragging then
						local mousePos = Services.UserInputService:GetMouseLocation()
						local mouseX, mouseY = mousePos.X, mousePos.Y
						local boundaries0 = nwSlider.BG.AbsolutePosition.X 
						local boundaries1 = nwSlider.BG.AbsolutePosition.X + nwSlider.BG.AbsoluteSize.X
						local at = mouseX - boundaries0
						local goal = boundaries1 - boundaries0
						local percentage = math.clamp(at / goal, 0, 1)
						data.CurrentValue = rangeMin + ((rangeMax - rangeMin) * percentage)
						update()	
					end
				end)

				nwSlider.Number.FocusLost:Connect(function()
					data.CurrentValue = math.clamp(tonumber(nwSlider.Number.Text) or rangeMin, rangeMin, rangeMax)
					update()
				end)

				self.UI.Main.Size += UDim2.new(0, 0, 0, 48)
				return {
					Set = function(val)
						data.CurrentValue = val
						update()
					end,
				}
			end
			function Section:CreateDropdown(data)
				local nwDropdown = Objects.Props.Dropdown:Clone()
				local showing = false
				nwDropdown.Title.Text = data.Title
				nwDropdown.Parent = self.UI.Main
				local arrowImages = {
					[true] = "rbxassetid://13582361562",
					[false] = "rbxassetid://13582137949"
				}
				local function update()
					nwDropdown.Frame.Title.Text = data.CurrentOption
					data.Callback(data.CurrentOption)	
				end
				local function updateList()
					nwDropdown.Frame.Arrow.Image = arrowImages[showing]
					nwDropdown.List.Visible = showing
					if showing then
						local e; e = Mouse.Button1Down:Connect(function()
							showing = false
							updateList()
							e:Disconnect()
						end)
					end	
				end
				nwDropdown.Frame.Arrow.MouseButton1Click:Connect(function()
					showing = not showing
					updateList()
				end)
				update()
				updateList()
				self.UI.Main.Size += UDim2.new(0, 0, 0, 48)
				for index, option in pairs(data.Options) do
					local dropdownButton = Objects.Props.DropdownButton:Clone()
					dropdownButton.Text = option
					dropdownButton.Parent = nwDropdown.List
					nwDropdown.List.Size += UDim2.new(0, 0, 0, 25)
					dropdownButton.MouseButton1Click:Connect(function()
						showing = false
						data.CurrentOption = option
						updateList()
						update()
					end)
				end
			end
			function Section:CreateButton(data)
				local keybindSet = nil
				local nwButton = Objects.Props.Button:Clone()
				nwButton.Parent = self.UI.Main
				nwButton.Title.Text = " "..data.Title
				local function onPress()
					data.Callback()
					local frame = Instance.new("Frame")
					local tInfo = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, 0, false, 0)
					local uiCorner = Instance.new("UICorner")
					uiCorner.Parent = frame
					uiCorner.CornerRadius = UDim.new(1, 0)
					frame.BackgroundTransparency = 0
					frame.BackgroundColor3 = MainColor
					local t = Services.TweenService:Create(frame, tInfo, {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1})
					local pos = Services.UserInputService:GetMouseLocation() - nwButton.AbsolutePosition
					frame.Parent = nwButton
					frame.Size = UDim2.new(0, 0, 0, 0)
					frame.AnchorPoint = Vector2.new(0.5, 0.5)
					frame.Position = UDim2.new(0, pos.X, 0, pos.Y - 37.5)
					t:Play()
					t.Completed:Wait()
					frame:Destroy()
				end
				nwButton.MouseButton1Click:Connect(onPress)
				self.UI.Main.Size += UDim2.new(0, 0, 0, 32)
				if data.Binding then
					nwButton.SetKeyButton.Visible = true
					local waiting = false
					nwButton.SetKeyButton.MouseButton1Click:Connect(function()
						if not waiting then
							waiting = true
							nwButton.SetKeyButton.Text = "Waiting.."
							local e; e = Services.UserInputService.InputBegan:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.Keyboard then
									nwButton.SetKeyButton.Text = input.KeyCode.Name
									waiting = false
									task.spawn(function()
										task.wait()
										keybindSet = input.KeyCode
									end)
									e:Disconnect()
								end
							end)
						end
					end)
					Services.UserInputService.InputBegan:Connect(function(input, gp)
						if not gp then
							if input.KeyCode == keybindSet then
								onPress()
							end
						end
					end)
				end
			end
		end
		function Tab:CreateSection(name, image)
			local nwSection = setmetatable({}, Section)
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 0, 0)
			frame.BackgroundTransparency = 1
			nwSection.UI = Objects.Props.Section:Clone()
			nwSection.UI.Title.Text = name
			nwSection.Frame = frame
			nwSection.UI.Image.Image = "rbxassetid://"..tostring(image)
			nwSection.Side = self.CurrentSide
			nwSection.Tab = self
			self.CurrentSide = (self.CurrentSide == "Left" and "Right") or "Left"
			self.Sections[#self.Sections + 1] = nwSection
			return nwSection
		end
		function Tab:Show()
			if self.Visible then return end
			local tInfo = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, 0, false, 0)
			local t = Services.TweenService:Create(self.UI.Dark, tInfo, {BackgroundTransparency = 1})
			local t2 = Services.TweenService:Create(self.UI, tInfo, {Size = UDim2.new(0.114, 0, 0, 26)})
			local t3 = Services.TweenService:Create(self.UI.Image, tInfo, {ImageTransparency = 0})
			local t4 = Services.TweenService:Create(self.UI.UIStroke, tInfo, {Color = Color3.fromRGB(255, 255, 255)})
			t:Play(); t2:Play(); t3:Play(); t4:Play()
			self.UI.Title.Visible = true
			self.Visible = true
			for index, section in pairs(self.Sections) do
				section.UI.Parent = self.Window.Frame.SectionsBG.Sections[section.Side]
				section.Frame.Parent = self.Window.Frame.SectionsBG.Sections[section.Side]
				section.Frame.Size = UDim2.new(1, 0, 0, section.UI.Main.AbsoluteSize.Y - 10)
			end
		end
		function Tab:Hide()
			if not self.Visible then return end
			local tInfo = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, 0, false, 0)
			local t = Services.TweenService:Create(self.UI.Dark, tInfo, {BackgroundTransparency = 0.75})
			local t2 = Services.TweenService:Create(self.UI, tInfo, {Size = UDim2.new(0, 26, 0, 26)})
			local t3 = Services.TweenService:Create(self.UI.Image, tInfo, {ImageTransparency = 0.5})
			local t4 = Services.TweenService:Create(self.UI.UIStroke, tInfo, {Color = Color3.fromRGB(255, 255, 255)})
			t:Play(); t2:Play(); t3:Play(); t4:Play()
			self.Visible = false
			self.UI.Title.Visible = false
			for index, section in pairs(self.Sections) do
				section.UI.Parent = nil
				section.Frame.Parent = nil
			end
		end
	end
	
	function Window:CreateTab(name, image)
		local nwTab = setmetatable({}, Tab)
		nwTab.UI = Objects.Props.Category:Clone()
		nwTab.UI.Parent = self.UI.Frame.CategoriesBG.Categories
		nwTab.UI.Image.Image = "rbxassetid://"..tostring(image)
		nwTab.UI.Title.Text = name
		nwTab.Sections = {}
		nwTab.Visible = false
		nwTab.Window = self.UI
		nwTab.CurrentSide = "Left"
		nwTab.UI.MouseButton1Click:Connect(function()
			if self.LastTab then
				self.LastTab:Hide()
			end
			local frame = Instance.new("Frame")
			local tInfo = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, 0, false, 0)
			local uiCorner = Instance.new("UICorner")
			uiCorner.Parent = frame
			uiCorner.CornerRadius = UDim.new(1, 0)
			frame.BackgroundTransparency = 0
			frame.BackgroundColor3 = MainColor
			local t = Services.TweenService:Create(frame, tInfo, {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1})
			local pos = Services.UserInputService:GetMouseLocation() - nwTab.UI.AbsolutePosition
			frame.Parent = nwTab.UI.Dark
			frame.Size = UDim2.new(0, 0, 0, 0)
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.Position = UDim2.new(0, pos.X, 0, pos.Y - 37.5)
			t:Play()
			nwTab:Show()
			self.LastTab = nwTab
			t.Completed:Wait()
			frame:Destroy()
		end)
		return nwTab
	end
	function Window:CreateKeybind(data)
		Services.UserInputService.InputBegan:Connect(function(input, gp)
			if not data.AllowGameProcessing then
				if gp then return end
			end
			if input.KeyCode == data.KeyCode then
				data.Callback()
			end
		end)
	end
end

function MakoLib:CreateWindow(data)
	local nwWindow = setmetatable({}, Window)
	nwWindow.UI = Objects.MakoUI:Clone()
	nwWindow.UI.Frame.Topbar.Title.Text = data.Title
	nwWindow.LastTab = nil
	if syn and syn.protect_gui then
		syn.protect_gui(nwWindow)
		nwWindow.UI.Parent = Services.CoreGui:FindFirstChild("RobloxGui")
	elseif gethui then
		nwWindow.UI.Parent = gethui()
	else
		local s, e = pcall(function()
			nwWindow.UI.Parent = Services.CoreGui:FindFirstChild("RobloxGui")
		end)
		if not s then
			nwWindow.UI.Parent = Player.PlayerGui 
		end
	end
	nwWindow.UI.Frame.Topbar.CloseButton.MouseButton1Click:Connect(function()
		nwWindow.UI.Enabled = false
	end)
	local e; e = Services.UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftControl then
			nwWindow.UI.Enabled = true
		end
	end)
	local isMinimized = false
	nwWindow.UI.Frame.Topbar.MinimizeButton.MouseButton1Click:Connect(function()
		if not isMinimized then
			nwWindow.UI.Frame.CategoriesBG.Visible = false
			nwWindow.UI.Frame.DropShadowHolder.Visible = false
			nwWindow.UI.Frame.SectionsBG.Visible = false
			nwWindow.UI.Frame.BackgroundTransparency = 1
		else
			nwWindow.UI.Frame.CategoriesBG.Visible = true
			nwWindow.UI.Frame.DropShadowHolder.Visible = true
			nwWindow.UI.Frame.SectionsBG.Visible = true
			nwWindow.UI.Frame.BackgroundTransparency = 0
		end
		isMinimized = not isMinimized
	end)
	do
		local gui = nwWindow.UI.Frame

		local dragging
		local dragInput
		local dragStart
		local startPos
		local nwPosition = gui.Position

		local function update(input)
			local delta = input.Position - dragStart
			nwPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end

		gui.Topbar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = gui.Position

				local e; e = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						e:Disconnect()
					end
				end)
			end
		end)

		gui.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)

		Services.UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)

		task.spawn(function()
			local tInfo = TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
			while true do
				task.wait()
				local t = Services.TweenService:Create(gui, tInfo, {Position = nwPosition})
				t:Play()
			end
		end)
	end
	return nwWindow
end

return MakoLib
