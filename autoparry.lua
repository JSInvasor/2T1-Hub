--[[ 
Private 2t1 Inspector
Made By Beyefendi
Modified for Epsilon UI
]]

local w = game:GetService("Workspace")
local p = game:GetService("Players")
local rs = game:GetService("RunService")
local vim = game:GetService("VirtualInputManager")
local ballFolder = w:WaitForChild("Balls")

local ind = Instance.new("Part")
ind.Size = Vector3.new(5, 5, 5)
ind.Anchored = true
ind.CanCollide = false
ind.Transparency = 1
ind.BrickColor = BrickColor.new("Bright red")
ind.Parent = w

local t = nil
local isKeyPressed = false

local function calcTime(ball, plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local root = plr.Character.HumanoidRootPart
        local rel = ball.Position - root.Position
        local vel = ball.Velocity + root.Velocity
        if vel.Magnitude > 0 then
            local a = (ball.Size.Magnitude / 2)
            local b = rel.Magnitude
            local c = math.sqrt(a * a + b * b)
            local time = (c - a) / vel.Magnitude
            return time
        end
    end
    return math.huge
end

local function updateInd(ball)
    if getgenv().ShowIndicator then
        ind.Transparency = 0.5
        ind.Position = ball.Position
    else
        ind.Transparency = 1
    end
end

local function resetKey(ball)
    if t == ball then
        isKeyPressed = false
        t = nil
    end
end

local function checkProx(ball, plr)
    local pred = calcTime(ball, plr)
    local real = ball:GetAttribute("realBall")
    local target = ball:GetAttribute("target")
    
    -- UI'dan gelen timing offset değerini kullan
    local baseOffset = getgenv().TimingOffset or 0.18
    local th = math.clamp(baseOffset + (ball.Velocity.Magnitude * 0.0015), baseOffset, 0.35)
    
    if pred <= th and real == true and target == plr.Name and not isKeyPressed then
        vim:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
        task.wait(0.005)
        vim:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
        t = ball
        isKeyPressed = true
        ball.AncestryChanged:Connect(function(_, parent)
            if not parent then
                resetKey(ball)
            end
        end)
    elseif t == ball and (pred > th or real ~= true or target ~= plr.Name) then
        resetKey(ball)
    end
end

local function prox()
    -- Sadece AutoParryEnabled açıkken çalış
    if not getgenv().AutoParryEnabled then return end
    
    local plr = p.LocalPlayer
    if plr then
        for _, ball in pairs(ballFolder:GetChildren()) do
            checkProx(ball, plr)
            updateInd(ball)
        end
    end
end

rs.Heartbeat:Connect(prox)
print("Made By love4Invasor - Epsilon UI Edition")
