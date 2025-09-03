--[[
Private For 2t1 Hub autoclash.lua
Made By Inspector
]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local ballFolder = Workspace:WaitForChild("Balls")
local localPlayer = Players.LocalPlayer

local lastClashTime = 0
local clashActive = false
local ballTargetHistory = {}

local function calculateTime(ball, player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local relativePos = ball.Position - root.Position
        local velocity = ball.Velocity + root.Velocity
        
        if velocity.Magnitude > 0 then
            local a = (ball.Size.Magnitude / 2)
            local b = relativePos.Magnitude
            local c = math.sqrt(a * a + b * b)
            local timeToHit = (c - a) / velocity.Magnitude
            return timeToHit
        end
    end
    return math.huge
end

local function detectClash(ball)
    if ball.Name ~= "realBall" then
        return false
    end
    
    local target = ball:GetAttribute("target")
    
    if target ~= localPlayer.Name then
        return false
    end
    
    local ballSpeed = ball.Velocity.Magnitude
    local timeToHit = calculateTime(ball, localPlayer)
    
    -- Clash detection parameters
    local speedThreshold = 100
    local clashWindow = math.clamp(0.10 + (ballSpeed * 0.0006), 0.10, 0.16)
    
    -- Track target changes for clash detection
    local ballId = tostring(ball)
    if not ballTargetHistory[ballId] then
        ballTargetHistory[ballId] = {target = target, changeCount = 0, lastChange = tick()}
    else
        if ballTargetHistory[ballId].target ~= target then
            ballTargetHistory[ballId].changeCount = ballTargetHistory[ballId].changeCount + 1
            ballTargetHistory[ballId].target = target
            ballTargetHistory[ballId].lastChange = tick()
        end
    end
    
    -- Clash if rapid target changes detected
    if ballTargetHistory[ballId].changeCount >= 2 and (tick() - ballTargetHistory[ballId].lastChange) < 0.5 then
        if timeToHit <= clashWindow and ballSpeed >= speedThreshold then
            ballTargetHistory[ballId].changeCount = 0
            return true
        end
    end
    
    -- High speed clash detection
    if ballSpeed >= 150 and timeToHit <= 0.14 then
        local playerDistance = (ball.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
        if playerDistance <= 10 then
            return true
        end
    end
    
    -- Very close proximity clash
    if timeToHit <= 0.11 and ballSpeed >= 120 then
        return true
    end
    
    return false
end

local function performClash()
    if (tick() - lastClashTime) < 0.35 or clashActive then
        return
    end
    
    clashActive = true
    lastClashTime = tick()
    
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
    task.wait(0.008)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
    
    task.wait(0.2)
    clashActive = false
end

local function monitorBall()
    for _, ball in pairs(ballFolder:GetChildren()) do
        if ball and ball.Name == "realBall" then
            if detectClash(ball) then
                performClash()
                break
            end
        end
    end
end

-- Clean up old ball history
task.spawn(function()
    while true do
        task.wait(2)
        for ballId, data in pairs(ballTargetHistory) do
            if (tick() - data.lastChange) > 3 then
                ballTargetHistory[ballId] = nil
            end
        end
    end
end)

RunService.Heartbeat:Connect(monitorBall)
