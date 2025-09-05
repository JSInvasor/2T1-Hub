local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JSInvasor/2T1-Hub/refs/heads/main/best2.lua"))()

local Window = Library:Window({
    Title = "2t1 Project [Version > 1.1]",
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
        Title = "Auto Parry",
        Desc = "Enable/Disable Auto Parry feature",
        Value = false,
        Callback = function(enabled)
            if enabled then
                print("Auto Parry: ON")
                loadstring(game:HttpGet("https://raw.githubusercontent.com/JSInvasor/2T1-Hub/refs/heads/main/autoparry.lua"))()
                
                Window:Notify({
                    Title = "Auto Parry",
                    Desc = "Auto Parry activated successfully!",
                    Time = 3
                })
            else
                print("Auto Parry: OFF")
                Window:Notify({
                    Title = "Auto Parry", 
                    Desc = "Auto Parry deactivated. May require rejoin to fully disable.",
                    Time = 3
                })
            end
        end
    })
    
    Tab:Toggle({
        Title = "Manuel Spam",
        Desc = "Press E to toggle F spam (For Blade Ball Clash)",
        Value = false,
        Callback = function(enabled)
            getgenv().ManuelSpamEnabled = enabled
            
            if enabled then
                getgenv().SpammingActive = false
                local spamConnection
                
                getgenv().ManuelSpamConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.KeyCode == Enum.KeyCode.E and getgenv().ManuelSpamEnabled then
                        getgenv().SpammingActive = not getgenv().SpammingActive
                        
                        if getgenv().SpammingActive then
                            Window:Notify({
                                Title = "Spam ON",
                                Desc = "F key spam started!",
                                Time = 2
                            })
                            
                            spamConnection = game:GetService("RunService").Heartbeat:Connect(function()
                                if getgenv().SpammingActive and getgenv().ManuelSpamEnabled then
                                    -- F tuşunu simüle et
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                                    task.wait(0.01) -- Çok hızlı spam için küçük delay
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                                else
                                    if spamConnection then
                                        spamConnection:Disconnect()
                                    end
                                end
                            end)
                        else
                            Window:Notify({
                                Title = "Spam OFF",
                                Desc = "F key spam stopped!",
                                Time = 2
                            })
                            
                            if spamConnection then
                                spamConnection:Disconnect()
                            end
                        end
                    end
                end)
                
                Window:Notify({
                    Title = "Manuel Spam",
                    Desc = "Manuel Spam enabled! Press E to toggle spam.",
                    Time = 3
                })
            else
                -- Spam'ı durdur ve connectionları temizle
                getgenv().SpammingActive = false
                
                if getgenv().ManuelSpamConnection then
                    getgenv().ManuelSpamConnection:Disconnect()
                end
                
                Window:Notify({
                    Title = "Manuel Spam",
                    Desc = "Manuel Spam disabled!",
                    Time = 3
                })
            end
        end
    })
end

Window:Line()

-- Extra Tab
local Extra = Window:Tab({Title = "Extra", Icon = "tag"}) do
    Extra:Section({Title = "Movement"})
    
    Extra:Button({
        Title = "Run Fly Bypass",
        Desc = "Click to load Fly Bypass (Press F to toggle fly)",
        Callback = function()
            print("Loading Fly Bypass...")
            -- Fly Bypass scriptini çalıştır
            loadstring(game:HttpGet("https://raw.githubusercontent.com/JSInvasor/2T1-Hub/refs/heads/main/flybypass.lua"))()
            
            -- Bildirim göster
            Window:Notify({
                Title = "Fly Bypass",
                Desc = "Fly Bypass loaded! Press F to start/stop flying.",
                Time = 4
            })
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
    
    Settings:Toggle({
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
    
    Settings:Section({Title = "Info"})
    
    Settings:Button({
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
    
    Settings:Button({
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
    
    -- Rejoin Button
    Settings:Button({
        Title = "Rejoin Game",
        Desc = "Quickly rejoin the current server",
        Callback = function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
        end
    })
end

Window:Notify({
    Title = "2t1 Hub",
    Desc = "Loaded successfully! Credits: @Invasor , @Drawat",
    Time = 4
})
