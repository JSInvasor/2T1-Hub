local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

-- Sol üst köşeye logo/decal ekleme
local function AddLogo(imageId)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Parent = ScreenGui
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 10, 0, 10)
    ImageLabel.Size = UDim2.new(0, 100, 0, 100)
    ImageLabel.Image = "rbxassetid://" .. imageId -- Decal ID buraya gelecek
    ImageLabel.ScaleType = Enum.ScaleType.Fit
end

-- Decal ID'yi buraya gir (örnek: 1234567890)
AddLogo("125037834893944") -- BURAYA DECAL ID'NİZİ GİRİN

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

local C = Y.Slider({
    Text = "Slip and... you get the idea",
    Callback = function(Value)
        print(Value)
    end,
    Min = 200,
    Max = 400,
    Def = 300
})

local D = Y.Dropdown({
    Text = "Dropping care package",
    Callback = function(Value)
        print(Value)
    end,
    Options = {
        "Floor 1",
        "Floor 2",
        "Floor 3",
        "Floor 4",
        "Floor 5"
    },
    Menu = {
        Information = function(self)
            X.Banner({
                Text = "Test alert!"
            })
        end
    }
})

local E = Y.ChipSet({
    Text = "Chipping away",
    Callback = function(ChipSet)
        table.foreach(ChipSet, function(Option, Value)
            print(Option, Value)
        end)
    end,
    Options = {
        TeamCheck = false,
        UselessBool = {
            Enabled = true,
            Menu = {
                Information = function(self)
                    X.Banner({
                        Text = "This bool has absolutely no purpose whatsoever."
                    })
                end
            }
        }
    }
})

local F = Y.DataTable({
    Text = "Chipping away",
    Callback = function(ChipSet)
        table.foreach(ChipSet, function(Option, Value)
            print(Option, Value)
        end)
    end,
    Options = {
        TeamCheck2 = false,
        UselessBool2 = {
            Enabled = true,
            Menu = {
                Information = function(self)
                    X.Banner({
                        Text = "This bool ALSO has absolutely no purpose. Sorry."
                    })
                end
            }
        }
    }
})

local H = Y.TextField({
    Text = "Country",
    Callback = function(Value)
        print(Value)
    end,
    Menu = {
        GB = function(self)
            self.SetText("GB")
        end,
        JP = function(self)
            self.SetText("JP")
        end,
        KO = function(self)
            self.SetText("KO")
        end
    }
})

-- RAGE SEKMESINE RAGE PARRY BUTONU
local RageParryButton = Z.Toggle({
    Text = "Rage Parry",
    Callback = function(Value)
        print(Value)
    end,
    Enabled = false
})
