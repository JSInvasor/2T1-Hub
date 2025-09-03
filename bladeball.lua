local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
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
