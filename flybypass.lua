if not getgenv().cloneref then
	getgenv().cloneref = function(obj) return obj end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character, humanoidRootPart, humanoid

local flightSpeed = 100
local boostMultiplier = 2
local flying = false

local bodyVelocity, bodyGyro, flyConnection
local seat

local function updateCharacterReferences()
	character = player.Character or player.CharacterAdded:Wait()
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	humanoid = character:WaitForChild("Humanoid")
end

updateCharacterReferences()

local function cleanupMovement()
	if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	if flyConnection then flyConnection:Disconnect() flyConnection = nil end
end

local function getNearestSeat()
	local map = workspace:FindFirstChild("1# Map")
	if not map then return nil end

	local closestSeat, shortestDistance = nil, math.huge

	for _, obj in ipairs(map:GetDescendants()) do
		if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
			local distance = (obj.Position - humanoidRootPart.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closestSeat = obj
			end
		end
	end

	return closestSeat
end

local function bringSeatToPlayer()
	seat = getNearestSeat()
	if seat then
		seat.Anchored = false
		seat.CanCollide = true
		seat.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -3, 0)
		task.wait(0.1)
		seat:Sit(humanoid)
	end
end

local function keepUnanchoredAndSeated()
	RunService.Stepped:Connect(function()
		if humanoidRootPart and humanoidRootPart.Anchored then
			humanoidRootPart.Anchored = false
		end
		if humanoid and humanoid.PlatformStand then
			humanoid.PlatformStand = false
		end
		if flying and seat and humanoid.SeatPart ~= seat then
			seat:Sit(humanoid)
		end
	end)
end

local function startFlying()
	-- Toggle kontrolü - sadece toggle açıksa fly başlat
	if not getgenv().FlyBypassEnabled then 
		return 
	end
	
	if flying then return end
	flying = true

	updateCharacterReferences()

	bringSeatToPlayer()
	keepUnanchoredAndSeated()

	cleanupMovement()

	bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Velocity = Vector3.zero

	bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro.CFrame = humanoidRootPart.CFrame

	flyConnection = RunService.RenderStepped:Connect(function()
		if not flying or not humanoidRootPart or not workspace.CurrentCamera then return end

		local camCF = workspace.CurrentCamera.CFrame
		local direction = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.new(0, 1, 0) end

		local currentSpeed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
			and (flightSpeed * boostMultiplier) or flightSpeed

		bodyVelocity.Velocity = (direction.Magnitude > 0 and direction.Unit * currentSpeed) or Vector3.zero
		bodyGyro.CFrame = camCF
	end)
end

local function stopFlying()
	flying = false
	cleanupMovement()
	if seat and humanoid and humanoid.SeatPart == seat then
		humanoid.Sit = false
	end
	seat = nil
end

-- F tuşu kontrolü - Toggle kontrolü eklendi
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- Toggle kontrolü - sadece toggle açıksa F tuşu çalışsın
	if not getgenv().FlyBypassEnabled then 
		return 
	end
	
	if input.KeyCode == Enum.KeyCode.F then
		if flying then
			stopFlying()
		else
			startFlying()
		end
	end
end)
