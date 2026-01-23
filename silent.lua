local LPlayer = game.Players.LocalPlayer
local EnemyPos = Vector3.new(1000, 1000, 1000)
local MobsFolder = Workspace.Mobs

local NamecallHook;NamecallHook = hookmetamethod(game, "_namecall", function(...)
    if getnamecallmethod() == "Raycast" then
        local , Origin, _, Params = ...
        return NamecallHook(Workspace, Origin, EnemyPos - Origin, Params)
    end
    return NamecallHook(...)
end)

game:GetService("RunService").Heartbeat:Connect(function()
    local MinDistance = 99999
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Head") then
        local LHead = LPlayer.Character.Head
        local Alives = MobsFolder:GetChildren()
        local Objects = Workspace:GetChildren()
        table.move(Objects, 35, #Objects, #Alives + 1, Alives)
        for i = 1, #Alives do
            if Alives[i]:FindFirstChild("EnemyHighlight") then
                local EHead = Alives[i].Head
                local Distance = (EHead.Position - LHead.Position).Magnitude
                if Distance < MinDistance then
                    MinDistance = Distance
                    EnemyPos = EHead.Position
                end
            end
        end
    end
end)
