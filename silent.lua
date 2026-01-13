--[[
2t1 Hub HyperShot Silent Aim @Drawat
]]
local LPlayer = game.Players.LocalPlayer
local EnemyPos = Vector3.new(100, 100, 100)

game:GetService("RunService").Heartbeat:Connect(function()
    local MinDistance = math.huge
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Head") then
        local LH = LPlayer.Character.Head
        for _, Child in ipairs(workspace:GetChildren()) do
            if Child.Name ~= LPlayer.Name and Child:FindFirstChild("Head") and Child:FindFirstChild("EnemyHighlight") then
                local EH = Child.Head
                local Distance = (EH.Position - LH.Position).Magnitude
                if Distance < MinDistance then
                    MinDistance = Distance
                    EnemyPos = EH.Position
                end
            end
        end
    end
end)

local oldmetamethod;oldmetamethod = hookmetamethod(game, "namecall", newcclosure(function(...)
    if getnamecallmethod() == "Raycast" and oldmetamethod(...) and not isfunctionhooked(oldmetamethod) then
        local oldfunc;oldfunc = hookfunction(oldmetamethod, newcclosure(function(v1, v2, ...)
            if getnamecallmethod() == "Raycast" then
                return oldfunc(v1, v2, EnemyPos - v2, select(2, ...))
            end
            return oldfunc(v1, v2, ...)
        end))
        hookmetamethod(game, "namecall", oldmetamethod)
    end
    return oldmetamethod(...)
end))
