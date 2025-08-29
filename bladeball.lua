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

AddLogo("125037834893944")

local X = Material.Load({
    Title = " 2t1 Hub * Private",
    Style = 2,
    SizeX = 500,
    SizeY = 350,
    Theme = "Dark",
    ColorOverrides = {
        MainFrame = Color3.fromRGB(40,40,70)
    }
})

local Y = X.New({
    Title = "Main"
})

local Z = X.New({
    Title = "Rage"
})

local B = Y.Toggle({
    Text = "Auto Parry v1",
    Callback = function(Value)
        print(Value)
    end,
    Enabled = false
})

local RageParryButton = Z.Toggle({
    Text = "Rage Parry",
    Callback = function(Value)
        print(Value)
    end,
    Enabled = false
})
