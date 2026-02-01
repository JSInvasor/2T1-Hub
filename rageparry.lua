--[[
Made By Drawat Rageparry.lua
Modified for Epsilon UI
]]

local rageParryConnections = {
    Spin = nil,
    Block = nil,
    Spam = nil,
}
local rageParryRunning = false

local Rand = math.random
local Vec3 = {}
for i = 1, 60 do
    Vec3[i] = Vector3.new(Rand(-15,15), -10, Rand(-15,15))
end
local Count = 60
local LPlayer = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CurrentBall = workspace.Balls:GetChildren()[2]

workspace.Balls.ChildAdded:Connect(function(Part)
    CurrentBall = Part
end)

local function FSpin()
    if LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") and CurrentBall then
        LPlayer.Character.HumanoidRootPart.CFrame = CurrentBall.CFrame + Vec3[Count]
        Count = Count % 60 + 1
    end
end

local function FBlock()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
end

local function FSpam()
    VirtualInputManager:SendMouseButtonEvent(815, 180, 0, true, nil, 0)
    VirtualInputManager:SendMouseButtonEvent(815, 180, 0, false, nil, 0)
end

local function LAnimatorTrack(Animator)
    Animator.AnimationPlayed:Connect(function(Track)
        Track.Stopped:Once(function()
            if LPlayer.Character and LPlayer.Character:FindFirstChild("Highlight") then
                if Track.Animation.AnimationId == "rbxassetid://14556917319" and not rageParryConnections.Spam then
                    rageParryConnections.Spam = RunService.RenderStepped:Connect(FSpam)
                end
            elseif rageParryConnections.Spam then
                rageParryConnections.Spam:Disconnect()
                rageParryConnections.Spam = nil
            end
        end)
    end)
end

if LPlayer.Character then
    LAnimatorTrack(LPlayer.Character.Humanoid.Animator)
end

LPlayer.CharacterAdded:Connect(function(Character)
    if rageParryConnections.Spam then
        rageParryConnections.Spam:Disconnect()
        rageParryConnections.Spam = nil
    end
    LAnimatorTrack(Character:WaitForChild("Humanoid"):WaitForChild("Animator"))
end)

-- Ana loop - getgenv() kontrol ediyor
RunService.Heartbeat:Connect(function()
    if getgenv().RageParryEnabled and not rageParryRunning then
        -- Rage Parry AÇ
        rageParryRunning = true
        rageParryConnections.Spin = RunService.Heartbeat:Connect(FSpin)
        rageParryConnections.Block = RunService.Stepped:Connect(FBlock)
        print("Rage Parry On")
        
    elseif not getgenv().RageParryEnabled and rageParryRunning then
        -- Rage Parry KAPAT
        rageParryRunning = false
        if rageParryConnections.Spin then
            rageParryConnections.Spin:Disconnect()
            rageParryConnections.Spin = nil
        end
        if rageParryConnections.Block then
            rageParryConnections.Block:Disconnect()
            rageParryConnections.Block = nil
        end
        if rageParryConnections.Spam then
            rageParryConnections.Spam:Disconnect()
            rageParryConnections.Spam = nil
        end
        print("Rage Parry Off")
    end
end)
