local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JSInvasor/2T1-Hub/refs/heads/main/best2.lua"))()

local Window = Library:Window({
    Title = "2t1 Project / HyperShot",
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
    Tab:Section({Title = "Combat"})
    
    Tab:Toggle({
        Title = "Silent Aim",
        Desc = "Silent Aim BETA!",
        Value = false,
        Callback = function(enabled)
            if enabled then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/JSInvasor/2T1-Hub/refs/heads/main/silent.lua"))()
                
                Window:Notify({
                    Title = "Silent Aim",
                    Desc = "Silent Aim Script Loaded!",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Silent Aim",
                    Desc = "Disabled",
                    Time = 3
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
            loadstring(game:HttpGet("https://raw.githubusercontent.com/JSInvasor/2T1-Hub/refs/heads/main/flybypass.lua"))()
            
            Window:Notify({
                Title = "Fly Bypass",
                Desc = "Fly Bypass loaded! Press F to start/stop flying.",
                Time = 4
            })
        end
    })
end

Window:Line()

-- SETTINGS TAB (Aynen Korundu)
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
                            -- Seats hariç
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
    Desc = "Loaded successfully! @Invasor @Drawat",
    Time = 4
})
