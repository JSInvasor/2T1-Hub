local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local function AddLogo(imageId)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Parent = ScreenGui
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 10, 0, 10)
    ImageLabel.Size = UDim2.new(0, 100, 0, 100)
    ImageLabel.Image = "rbxassetid://" .. imageId
    ImageLabel.ScaleType = Enum.ScaleType.Fit
end


AddLogo("1234567890")

local X = Material.Load({
    Title = " 2t1 Hub | Rivals",
    Style = 2,
    SizeX = 500,
    SizeY = 350,
    Theme = "Dark",
    ColorOverrides = {
        MainFrame = Color3.fromRGB(40,40,70)
    }
})

local MainTab = X.New({
    Title = "Main"
})

local VisualTab = X.New({
    Title = "Visual"
})

local SettingsTab = X.New({
    Title = "Settings"
})

local SilentAimToggle = MainTab.Toggle({
    Text = "Silent Aim",
    Callback = function(Value)
        print("Silent Aim:", Value)
        -- Silent aim kodu buraya
    end,
    Enabled = false
})

local SilentAimFOV = MainTab.Slider({
    Text = "Silent Aim FOV",
    Callback = function(Value)
        print("FOV:", Value)
    end,
    Min = 10,
    Max = 500,
    Def = 100
})

local SilentAimHitbox = MainTab.Dropdown({
    Text = "Target Hitbox",
    Callback = function(Value)
        print("Hitbox:", Value)
    end,
    Options = {
        "Head",
        "Torso",
        "Random"
    }
})

local SilentAimDistance = MainTab.Slider({
    Text = "Max Distance",
    Callback = function(Value)
        print("Max Distance:", Value)
    end,
    Min = 50,
    Max = 1000,
    Def = 500
})

local TeamCheck = MainTab.Toggle({
    Text = "Team Check",
    Callback = function(Value)
        print("Team Check:", Value)
    end,
    Enabled = true
})


local ESPEnabled = false
local BoxesEnabled = false
local TracersEnabled = false
local ESPConnections = {}
local ESPObjects = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ESPMainColor = Color3.fromRGB(255, 0, 0)

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end
    
    local espHolder = {}
    
    local espGui = Instance.new("BillboardGui")
    espGui.Name = "ESP"
    espGui.AlwaysOnTop = true
    espGui.Size = UDim2.new(4, 0, 5.5, 0)
    espGui.StudsOffset = Vector3.new(0, 0, 0)
    
    local boxFrame = Instance.new("Frame")
    boxFrame.Parent = espGui
    boxFrame.BackgroundTransparency = 1
    boxFrame.Size = UDim2.new(1, 0, 1, 0)
    boxFrame.Position = UDim2.new(0, 0, 0, 0)
    
    local leftLine = Instance.new("Frame")
    leftLine.Parent = boxFrame
    leftLine.BackgroundColor3 = ESPMainColor
    leftLine.BorderSizePixel = 0
    leftLine.Size = UDim2.new(0, 2, 1, 0)
    leftLine.Position = UDim2.new(0, 0, 0, 0)
    
    local rightLine = Instance.new("Frame")
    rightLine.Parent = boxFrame
    rightLine.BackgroundColor3 = ESPMainColor
    rightLine.BorderSizePixel = 0
    rightLine.Size = UDim2.new(0, 2, 1, 0)
    rightLine.Position = UDim2.new(1, -2, 0, 0)
    
    local topLine = Instance.new("Frame")
    topLine.Parent = boxFrame
    topLine.BackgroundColor3 = ESPMainColor
    topLine.BorderSizePixel = 0
    topLine.Size = UDim2.new(1, 0, 0, 2)
    topLine.Position = UDim2.new(0, 0, 0, 0)
    
    local bottomLine = Instance.new("Frame")
    bottomLine.Parent = boxFrame
    bottomLine.BackgroundColor3 = ESPMainColor
    bottomLine.BorderSizePixel = 0
    bottomLine.Size = UDim2.new(1, 0, 0, 2)
    bottomLine.Position = UDim2.new(0, 0, 1, -2)
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = espGui
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, -0.2, 0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextColor3 = ESPMainColor
    nameLabel.TextScaled = true
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Parent = espGui
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Position = UDim2.new(0, 0, 1, 0)
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.TextColor3 = ESPMainColor
    distanceLabel.TextScaled = true
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = ESPMainColor
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    
    local tracerGui = Instance.new("ScreenGui")
    tracerGui.Parent = game:GetService("CoreGui")
    tracerGui.Name = "Tracer"
    
    local tracer = Instance.new("Frame")
    tracer.Parent = tracerGui
    tracer.BackgroundColor3 = ESPMainColor
    tracer.BorderSizePixel = 0
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.Size = UDim2.new(0, 1, 0, 1)
    
    espHolder.Billboard = espGui
    espHolder.BoxFrame = boxFrame
    espHolder.BoxLines = {leftLine, rightLine, topLine, bottomLine}
    espHolder.NameLabel = nameLabel
    espHolder.DistanceLabel = distanceLabel
    espHolder.Highlight = highlight
    espHolder.TracerGui = tracerGui
    espHolder.Tracer = tracer
    
    ESPObjects[player] = espHolder
    
    local function UpdateESP()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            local rootPart = player.Character.HumanoidRootPart
            
            if humanoid.Health > 0 then
                -- Billboard'u karaktere ekle
                if espGui.Parent ~= rootPart then
                    espGui.Parent = rootPart
                end
                
                if highlight.Parent ~= player.Character then
                    highlight.Parent = player.Character
                end
                
                boxFrame.Visible = BoxesEnabled
                
                nameLabel.Text = player.Name .. " [" .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. "]"
                
                -- Mesafe hesapla
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    distanceLabel.Text = "[" .. math.floor(distance) .. " studs]"
                end
                
                if TracersEnabled and rootPart then
                    local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        local endPos = Vector2.new(vector.X, vector.Y)
                        local distance = (endPos - startPos).Magnitude
                        
                        tracer.Size = UDim2.new(0, 2, 0, distance)
                        tracer.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
                        tracer.Rotation = math.deg(math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)) + 90
                        tracer.Visible = true
                        tracer.BackgroundColor3 = ESPMainColor
                    else
                        tracer.Visible = false
                    end
                else
                    tracer.Visible = false
                end
                
                local teamColor = ESPMainColor
                if player.Team and LocalPlayer.Team then
                    if player.Team == LocalPlayer.Team then
                        teamColor = Color3.new(0, 1, 0)
                    else
                        teamColor = Color3.new(1, 0, 0)
                    end
                else
                    teamColor = Color3.new(1, 1, 0)
                end
                
                highlight.FillColor = teamColor
                nameLabel.TextColor3 = teamColor
                distanceLabel.TextColor3 = teamColor
                for _, line in pairs(espHolder.BoxLines) do
                    line.BackgroundColor3 = teamColor
                end
                tracer.BackgroundColor3 = teamColor
            else
                espGui.Parent = nil
                highlight.Parent = nil
                tracer.Visible = false
            end
        else
            espGui.Parent = nil
            highlight.Parent = nil
            tracer.Visible = false
        end
    end
    
    espHolder.UpdateConnection = RunService.RenderStepped:Connect(UpdateESP)
end

local function RemoveESP(player)
    if ESPObjects[player] then
        if ESPObjects[player].Billboard then
            ESPObjects[player].Billboard:Destroy()
        end
        if ESPObjects[player].Highlight then
            ESPObjects[player].Highlight:Destroy()
        end
        if ESPObjects[player].TracerGui then
            ESPObjects[player].TracerGui:Destroy()
        end
        if ESPObjects[player].UpdateConnection then
            ESPObjects[player].UpdateConnection:Disconnect()
        end
        ESPObjects[player] = nil
    end
end

local function EnableESP()
    ESPEnabled = true
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
    
    ESPConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        if ESPEnabled then
            CreateESP(player)
        end
    end)
    
    ESPConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        RemoveESP(player)
    end)
end

local function DisableESP()
    ESPEnabled = false
    
    for player, _ in pairs(ESPObjects) do
        RemoveESP(player)
    end
    
    for _, connection in pairs(ESPConnections) do
        connection:Disconnect()
    end
    ESPConnections = {}
end

local ESPToggle = VisualTab.Toggle({
    Text = "ESP",
    Callback = function(Value)
        if Value then
            EnableESP()
            print("ESP Enabled")
        else
            DisableESP()
            print("ESP Disabled")
        end
    end,
    Enabled = false
})

local ESPBoxes = VisualTab.Toggle({
    Text = "ESP Boxes",
    Callback = function(Value)
        BoxesEnabled = Value
        print("ESP Boxes:", Value)
    end,
    Enabled = false
})

local ESPTracers = VisualTab.Toggle({
    Text = "ESP Tracers",
    Callback = function(Value)
        TracersEnabled = Value
        print("ESP Tracers:", Value)
    end,
    Enabled = false
})

local ESPDistance = VisualTab.Slider({
    Text = "ESP Max Distance",
    Callback = function(Value)
        print("ESP Distance:", Value)
    end,
    Min = 100,
    Max = 5000,
    Def = 1500
})

local ESPColor = VisualTab.ColorPicker({
    Text = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        ESPMainColor = Value
        -- Mevcut ESP'lerin rengini güncelle
        for player, espData in pairs(ESPObjects) do
            if espData.BoxLines then
                for _, line in pairs(espData.BoxLines) do
                    line.BackgroundColor3 = ESPMainColor
                end
            end
            if espData.NameLabel then
                espData.NameLabel.TextColor3 = ESPMainColor
            end
            if espData.DistanceLabel then
                espData.DistanceLabel.TextColor3 = ESPMainColor
            end
            if espData.Tracer then
                espData.Tracer.BackgroundColor3 = ESPMainColor
            end
            if espData.Highlight then
                espData.Highlight.FillColor = ESPMainColor
            end
        end
        print("ESP Color Changed")
    end
})

local ConfigName = SettingsTab.TextField({
    Text = "Config Name",
    Callback = function(Value)
        print("Config:", Value)
    end
})

local SaveButton = SettingsTab.Button({
    Text = "Save Config",
    Callback = function()
        X.Banner({
            Text = "Config Saved!"
        })
    end
})

local LoadButton = SettingsTab.Button({
    Text = "Load Config", 
    Callback = function()
        X.Banner({
            Text = "Config Loaded!"
        })
    end
})
