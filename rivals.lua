local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JSInvasor/2T1-Hub/refs/heads/main/best2.lua"))()

local Window = Library:Window({
    Title = "2t1 Project [Version > 1.2]",
    Desc = "https://discord.gg/wB4FNzmUPx",
    Icon = 88445176259961,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "2t1"
    }
})

local Tab = Window:Tab({Title = "Main", Icon = "star"}) do
    Tab:Section({Title = "Combat Features"})
    
    Tab:Toggle({
        Title = "Silent Aim",
        Desc = "Enable/Disable Silent Aim feature",
        Value = false,
        Callback = function(enabled)
            if enabled then
                print("Silent Aim: ON")
                -- Silent aim scriptini buraya ekle
                loadstring(game:HttpGet("https://raw.githubusercontent.com/JSInvasor/2T1-Hub/refs/heads/main/silentaim.lua"))()
                
                Window:Notify({
                    Title = "Silent Aim",
                    Desc = "Silent Aim activated successfully!",
                    Time = 3
                })
            else
                print("Silent Aim: OFF")
                Window:Notify({
                    Title = "Silent Aim", 
                    Desc = "Silent Aim deactivated. May require rejoin to fully disable.",
                    Time = 3
                })
            end
        end
    })
    
    Tab:Section({Title = "Aim Settings"})
    
    Tab:Toggle({
        Title = "Show FOV",
        Desc = "Show FOV circle for Silent Aim",
        Value = false,
        Callback = function(enabled)
            getgenv().ShowFOV = enabled
            if enabled then
                Window:Notify({
                    Title = "FOV Circle",
                    Desc = "FOV circle enabled!",
                    Time = 2
                })
            else
                Window:Notify({
                    Title = "FOV Circle",
                    Desc = "FOV circle disabled!",
                    Time = 2
                })
            end
        end
    })
    
    Tab:Slider({
        Title = "FOV Size",
        Min = 10,
        Max = 500,
        Rounding = 0,
        Value = 100,
        Callback = function(value)
            getgenv().FOVSize = value
        end
    })
end

Window:Line()

local Visuals = Window:Tab({Title = "Visuals", Icon = "eye"}) do
    Visuals:Section({Title = "ESP Features"})
    
    Visuals:Toggle({
        Title = "Player ESP",
        Desc = "Show all players through walls",
        Value = false,
        Callback = function(enabled)
            if enabled then
                print("Player ESP: ON")
                -- ESP scriptini buraya ekle
                loadstring(game:HttpGet("https://raw.githubusercontent.com/JSInvasor/2T1-Hub/refs/heads/main/esp.lua"))()
                
                Window:Notify({
                    Title = "Player ESP",
                    Desc = "ESP activated! You can see all players.",
                    Time = 3
                })
            else
                print("Player ESP: OFF")
                Window:Notify({
                    Title = "Player ESP",
                    Desc = "ESP deactivated. May require rejoin to fully disable.",
                    Time = 3
                })
            end
        end
    })
    
    Visuals:Toggle({
        Title = "Box ESP",
        Desc = "Draw boxes around players",
        Value = false,
        Callback = function(enabled)
            getgenv().BoxESPEnabled = enabled
            if enabled then
                Window:Notify({
                    Title = "Box ESP",
                    Desc = "Box ESP enabled!",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Box ESP",
                    Desc = "Box ESP disabled!",
                    Time = 3
                })
            end
        end
    })
    
    Visuals:Toggle({
        Title = "Name ESP",
        Desc = "Show player names",
        Value = false,
        Callback = function(enabled)
            getgenv().NameESPEnabled = enabled
            if enabled then
                Window:Notify({
                    Title = "Name ESP",
                    Desc = "Name ESP enabled!",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Name ESP",
                    Desc = "Name ESP disabled!",
                    Time = 3
                })
            end
        end
    })
    
    Visuals:Toggle({
        Title = "Distance ESP",
        Desc = "Show distance to players",
        Value = false,
        Callback = function(enabled)
            getgenv().DistanceESPEnabled = enabled
            if enabled then
                Window:Notify({
                    Title = "Distance ESP",
                    Desc = "Distance ESP enabled!",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Distance ESP",
                    Desc = "Distance ESP disabled!",
                    Time = 3
                })
            end
        end
    })
    
    Visuals:Toggle({
        Title = "Health Bar",
        Desc = "Show player health bars",
        Value = false,
        Callback = function(enabled)
            getgenv().HealthESPEnabled = enabled
            if enabled then
                Window:Notify({
                    Title = "Health ESP",
                    Desc = "Health bars enabled!",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Health ESP",
                    Desc = "Health bars disabled!",
                    Time = 3
                })
            end
        end
    })
    
    Visuals:Section({Title = "ESP Settings"})
    
    Visuals:Slider({
        Title = "ESP Max Distance",
        Min = 100,
        Max = 10000,
        Rounding = 0,
        Value = 5000,
        Callback = function(value)
            getgenv().ESPMaxDistance = value
        end
    })
    
    Visuals:Slider({
        Title = "ESP Text Size",
        Min = 10,
        Max = 30,
        Rounding = 0,
        Value = 14,
        Callback = function(value)
            getgenv().ESPTextSize = value
        end
    })
    
    Visuals:Toggle({
        Title = "Team Check",
        Desc = "Don't show ESP on teammates",
        Value = false,
        Callback = function(enabled)
            getgenv().ESPTeamCheck = enabled
            if enabled then
                Window:Notify({
                    Title = "Team Check",
                    Desc = "Team check enabled!",
                    Time = 2
                })
            else
                Window:Notify({
                    Title = "Team Check",
                    Desc = "Team check disabled!",
                    Time = 2
                })
            end
        end
    })
    
    Visuals:Toggle({
        Title = "Visible Check",
        Desc = "Different color when player is visible",
        Value = false,
        Callback = function(enabled)
            getgenv().ESPVisibleCheck = enabled
            if enabled then
                Window:Notify({
                    Title = "Visible Check",
                    Desc = "Visible check enabled!",
                    Time = 2
                })
            else
                Window:Notify({
                    Title = "Visible Check",
                    Desc = "Visible check disabled!",
                    Time = 2
                })
            end
        end
    })
end

Window:Line()

local Extra = Window:Tab({Title = "Extra", Icon = "tag"}) do
    Extra:Section({Title = "Movement"})
    
    Extra:Button({
        Title = "Run Fly Bypass",
        Desc = "Click to load Fly Bypass (Press F to toggle fly)",
        Callback = function()
            print("Loading Fly Bypass...")
            -- Fly Bypass scriptini çalıştır
            loadstring(game:HttpGet("https://raw.githubusercontent.com/JSInvasor/2T1-Hub/refs/heads/main/flybypass.lua"))()
            
            Window:Notify({
                Title = "Fly Bypass",
                Desc = "Fly Bypass loaded! Press F to start/stop flying.",
                Time = 4
            })
        end
    })
    
    Extra:Section({Title = "Teleports"})
    
    Extra:Button({
        Title = "Teleport to Random Player",
        Desc = "Teleport to a random player in the game",
        Callback = function()
            local players = game.Players:GetPlayers()
            local localPlayer = game.Players.LocalPlayer
            local randomPlayer = players[math.random(1, #players)]
            
            if randomPlayer ~= localPlayer and randomPlayer.Character then
                localPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
                Window:Notify({
                    Title = "Teleported",
                    Desc = "Teleported to " .. randomPlayer.Name,
                    Time = 3
                })
            end
        end
    })
end

Window:Line()

local Misc = Window:Tab({Title = "Misc", Icon = "settings"}) do
    Misc:Section({Title = "Player Mods"})
    
    Misc:Toggle({
        Title = "Infinite Jump",
        Desc = "Jump multiple times in the air",
        Value = false,
        Callback = function(enabled)
            getgenv().InfiniteJumpEnabled = enabled
            if enabled then
                game:GetService("UserInputService").JumpRequest:Connect(function()
                    if getgenv().InfiniteJumpEnabled then
                        local player = game.Players.LocalPlayer
                        if player.Character and player.Character:FindFirstChild("Humanoid") then
                            player.Character.Humanoid:ChangeState("Jumping")
                        end
                    end
                end)
                
                Window:Notify({
                    Title = "Infinite Jump",
                    Desc = "Infinite Jump enabled!",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Infinite Jump",
                    Desc = "Infinite Jump disabled!",
                    Time = 3
                })
            end
        end
    })
    
    Misc:Toggle({
        Title = "Noclip",
        Desc = "Walk through walls",
        Value = false,
        Callback = function(enabled)
            getgenv().Noclip = enabled
            if enabled then
                game:GetService("RunService").Stepped:Connect(function()
                    if getgenv().Noclip then
                        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
                
                Window:Notify({
                    Title = "Noclip",
                    Desc = "Noclip enabled!",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Noclip",
                    Desc = "Noclip disabled!",
                    Time = 3
                })
            end
        end
    })
    
    Misc:Section({Title = "Server"})
    
    Misc:Button({
        Title = "Server Info",
        Desc = "Show current server information",
        Callback = function()
            local players = #game.Players:GetPlayers()
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            local fps = math.floor(1/game:GetService("RunService").RenderStepped:Wait())
            
            Window:Notify({
                Title = "Server Info",
                Desc = "Players: " .. players .. "/50 | Ping: " .. ping .. " | FPS: " .. fps,
                Time = 5
            })
        end
    })
    
    Misc:Button({
        Title = "Rejoin Game",
        Desc = "Quickly rejoin the current server",
        Callback = function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
        end
    })
    
    -- Server Hop
    Misc:Button({
        Title = "Server Hop",
        Desc = "Join a different server",
        Callback = function()
            local PlaceID = game.PlaceId
            local AllIDs = {}
            local foundAnything = ""
            local actualHour = os.date("!*t").hour
            local Deleted = false
            
            function TPReturner()
                local Site;
                if foundAnything == "" then
                    Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
                else
                    Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
                end
                local ID = ""
                if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                    foundAnything = Site.nextPageCursor
                end
                local num = 0;
                for i,v in pairs(Site.data) do
                    local Possible = true
                    ID = tostring(v.id)
                    if tonumber(v.maxPlayers) > tonumber(v.playing) then
                        for _,Existing in pairs(AllIDs) do
                            if num ~= 0 then
                                if ID == tostring(Existing) then
                                    Possible = false
                                end
                            else
                                if tonumber(actualHour) ~= tonumber(Existing) then
                                    local delFile = pcall(function()
                                        AllIDs = {}
                                        table.insert(AllIDs, actualHour)
                                    end)
                                end
                            end
                            num = num + 1
                        end
                        if Possible == true then
                            table.insert(AllIDs, ID)
                            wait()
                            pcall(function()
                                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                            end)
                            wait(4)
                        end
                    end
                end
            end
            
            function Teleport()
                while wait() do
                    pcall(function()
                        TPReturner()
                        if foundAnything ~= "" then
                            TPReturner()
                        end
                    end)
                end
            end
            
            Teleport()
        end
    })
    
    Misc:Section({Title = "Other"})
    
    -- Discord Server
    Misc:Button({
        Title = "Discord Server",
        Desc = "Copy Discord invite to clipboard",
        Callback = function()
            setclipboard("https://discord.gg/wB4FNzmUPx")
            Window:Notify({
                Title = "Discord",
                Desc = "Discord link copied to clipboard!",
                Time = 3
            })
        end
    })
    
    -- Anti AFK
    Misc:Toggle({
        Title = "Anti AFK",
        Desc = "Prevents you from being kicked for idling",
        Value = false,
        Callback = function(enabled)
            if enabled then
                for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
                    v:Disable()
                end
                Window:Notify({
                    Title = "Anti AFK",
                    Desc = "Anti AFK enabled!",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Anti AFK",
                    Desc = "Anti AFK disabled! Rejoin to restore.",
                    Time = 3
                })
            end
        end
    })
end

Window:Line()

local Settings = Window:Tab({Title = "Settings", Icon = "wrench"}) do
    Settings:Section({Title = "Performance"})
    
    Settings:Toggle({
        Title = "FPS Boost",
        Desc = "Disable textures and effects for better FPS",
        Value = false,
        Callback = function(enabled)
            if enabled then
                settings().Rendering.QualityLevel = 1
                game:GetService("Lighting").GlobalShadows = false
                game:GetService("Lighting").FogEnd = 9e9
                
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                        v.Material = "Plastic"
                        v.Reflectance = 0
                    elseif v:IsA("Decal") or v:IsA("Texture") then
                        v.Transparency = 1
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                        v.Lifetime = NumberRange.new(0)
                    elseif v:IsA("Explosion") then
                        v.BlastPressure = 1
                        v.BlastRadius = 1
                    end
                end
                
                Window:Notify({
                    Title = "FPS Boost",
                    Desc = "FPS Boost enabled! Graphics reduced.",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "FPS Boost",
                    Desc = "FPS Boost disabled. Rejoin to restore graphics.",
                    Time = 3
                })
            end
        end
    })
    
    Settings:Toggle({
        Title = "Anti-Lag",
        Desc = "Remove unnecessary parts to reduce lag",
        Value = false,
        Callback = function(enabled)
            if enabled then
                local function antiLag()
                    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                        if v:IsA("Seat") or v:IsA("VehicleSeat") then
                            -- Seats hariç (fly bypass için gerekli)
                        elseif v:IsA("MeshPart") and v.TextureID ~= "" then
                            v.TextureID = ""
                        elseif v:IsA("SpecialMesh") and v.TextureId ~= "" then
                            v.TextureId = ""
                        end
                    end
                end
                antiLag()
                
                Window:Notify({
                    Title = "Anti-Lag",
                    Desc = "Anti-Lag enabled! Textures removed.",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Anti-Lag",
                    Desc = "Anti-Lag disabled. Rejoin to restore.",
                    Time = 3
                })
            end
        end
    })
    
    Settings:Section({Title = "Player"})
    
    Settings:Slider({
        Title = "Walk Speed",
        Min = 16,
        Max = 200,
        Rounding = 0,
        Value = 16,
        Callback = function(value)
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = value
            end
        end
    })
    
    Settings:Slider({
        Title = "Jump Power",
        Min = 50,
        Max = 300,
        Rounding = 0,
        Value = 50,
        Callback = function(value)
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = value
            end
        end
    })
end

Window:Notify({
    Title = "2t1 Hub",
    Desc = "Loaded successfully! Credits: @Invasor , @Drawat",
    Time = 10
})
