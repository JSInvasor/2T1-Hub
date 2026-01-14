local Settings = {
    -- Görünüm Ayarları
    Color = Color3.fromRGB(0, 255, 255), -- Cyan (Turkuaz - Box Beyazsa bu renk iyi durur)
    Thickness = 1.5,
    Transparency = 1,
    
    -- Özellikler
    ShowSkeleton = true,
    ShowHeadDot = true,
    ShowViewTracer = true, -- Adamın nereye baktığını gösteren çizgi
    
    -- Mesafe
    MaxDistance = 1500
}

--// Services & Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// Cache System
local Drawings = {} 

--// Functions
local function NewLine()
    local L = Drawing.new("Line")
    L.Visible = false
    L.Color = Settings.Color
    L.Thickness = Settings.Thickness
    L.Transparency = Settings.Transparency
    return L
end

local function NewCircle()
    local C = Drawing.new("Circle")
    C.Visible = false
    C.Color = Settings.Color
    C.Radius = 3
    C.Thickness = 1
    C.Filled = true
    return C
end

--// Skeleton Connections (Kemik Bağlantıları)
local R15_Connections = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}
}

local R6_Connections = {
    {"Head", "Torso"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
    {"Torso", "Left Arm"}, {"Torso", "Right Arm"}
}

--// Main Logic
local function AddESP(Player)
    if Drawings[Player] then return end
    
    Drawings[Player] = {
        Skeleton = {},
        HeadDot = NewCircle(),
        ViewTracer = NewLine()
        -- Name (İsim) objesi kaldırıldı.
    }
    
    -- Skeleton çizgilerini oluştur
    for i = 1, 20 do 
        table.insert(Drawings[Player].Skeleton, NewLine())
    end
end

local function RemoveESP(Player)
    if Drawings[Player] then
        for _, Line in pairs(Drawings[Player].Skeleton) do Line:Remove() end
        Drawings[Player].HeadDot:Remove()
        Drawings[Player].ViewTracer:Remove()
        Drawings[Player] = nil
    end
end

local function UpdateESP()
    for Player, Data in pairs(Drawings) do
        local Character = Player.Character
        local ShouldDraw = false
        
        if Character and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("HumanoidRootPart") and Character.Humanoid.Health > 0 and Player ~= LocalPlayer then
            
            local RootPart = Character.HumanoidRootPart
            local Distance = (Camera.CFrame.Position - RootPart.Position).Magnitude
            local _, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)

            if OnScreen and Distance <= Settings.MaxDistance then
                ShouldDraw = true
                
                -- 1. KAFA NOKTASI & BAKIŞ ÇİZGİSİ
                local Head = Character:FindFirstChild("Head")
                if Head then
                    local HeadScreen = Camera:WorldToViewportPoint(Head.Position)
                    
                    -- Kafa Noktası
                    Data.HeadDot.Position = Vector2.new(HeadScreen.X, HeadScreen.Y)
                    Data.HeadDot.Visible = Settings.ShowHeadDot
                    Data.HeadDot.Color = Settings.Color
                    
                    -- Bakış Çizgisi (View Tracer)
                    if Settings.ShowViewTracer then
                        local LookDir = Head.CFrame.LookVector * 10 
                        local LookPos = Camera:WorldToViewportPoint(Head.Position + LookDir)
                        Data.ViewTracer.From = Vector2.new(HeadScreen.X, HeadScreen.Y)
                        Data.ViewTracer.To = Vector2.new(LookPos.X, LookPos.Y)
                        Data.ViewTracer.Visible = true
                    else
                        Data.ViewTracer.Visible = false
                    end
                else
                    Data.HeadDot.Visible = false
                    Data.ViewTracer.Visible = false
                end

                -- 2. SKELETON
                if Settings.ShowSkeleton then
                    local Connections = (Character.Humanoid.RigType == Enum.HumanoidRigType.R15) and R15_Connections or R6_Connections
                    local LineIndex = 1

                    for _, Pair in pairs(Connections) do
                        local PartA = Character:FindFirstChild(Pair[1])
                        local PartB = Character:FindFirstChild(Pair[2])

                        if PartA and PartB then
                            local PosA, VisA = Camera:WorldToViewportPoint(PartA.Position)
                            local PosB, VisB = Camera:WorldToViewportPoint(PartB.Position)

                            if VisA and VisB and Data.Skeleton[LineIndex] then
                                local Line = Data.Skeleton[LineIndex]
                                Line.From = Vector2.new(PosA.X, PosA.Y)
                                Line.To = Vector2.new(PosB.X, PosB.Y)
                                Line.Visible = true
                                Line.Color = Settings.Color
                                LineIndex = LineIndex + 1
                            end
                        end
                    end
                    -- Kullanılmayan fazla çizgileri gizle
                    for i = LineIndex, #Data.Skeleton do Data.Skeleton[i].Visible = false end
                else
                    for _, Line in pairs(Data.Skeleton) do Line.Visible = false end
                end
            end
        end
        
        -- Eğer çizilmemesi gerekiyorsa (ShouldDraw = false), her şeyi gizle
        if not ShouldDraw then
            Data.HeadDot.Visible = false
            Data.ViewTracer.Visible = false
            for _, Line in pairs(Data.Skeleton) do Line.Visible = false end
        end
    end
end

--// Events
Players.PlayerAdded:Connect(AddESP)
Players.PlayerRemoving:Connect(RemoveESP)

for _, P in pairs(Players:GetPlayers()) do
    if P ~= LocalPlayer then AddESP(P) end
end

RunService.RenderStepped:Connect(UpdateESP)
