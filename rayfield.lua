-- Wiihub Full Advanced UI
-- LocalScript olarak çalıştırabilirsiniz

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "WiihubFullUI"

-- Blur arka plan
local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 12

-- Ana pencere
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 600, 0, 400)
frame.Position = UDim2.new(0.5, -300, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BackgroundTransparency = 0.1

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 15)

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(145, 95, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
}
gradient.Rotation = 45

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.4

-- Başlık
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Wiihub Full Advanced UI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 26

-- Tab menü
local tabHolder = Instance.new("Frame", frame)
tabHolder.Size = UDim2.new(0, 160, 1, -50)
tabHolder.Position = UDim2.new(0, 0, 0, 50)
tabHolder.BackgroundTransparency = 1

local contentHolder = Instance.new("Frame", frame)
contentHolder.Size = UDim2.new(1, -160, 1, -50)
contentHolder.Position = UDim2.new(0, 160, 0, 50)
contentHolder.BackgroundTransparency = 1

-- Tween
local tweenService = game:GetService("TweenService")
local info = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

-- Tab fonksiyonu
local tabs = {}
function createTab(name)
    local btn = Instance.new("TextButton", tabHolder)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, #tabs * 45)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 10)

    local page = Instance.new("Frame", contentHolder)
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.Visible = (#tabs == 0)

    btn.MouseEnter:Connect(function()
        tweenService:Create(btn, info, {BackgroundColor3 = Color3.fromRGB(145, 95, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if page.Visible == false then
            tweenService:Create(btn, info, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function()
        for _,tab in ipairs(tabs) do
            tab.page.Visible = false
            tweenService:Create(tab.button, info, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
        end
        page.Visible = true
        tweenService:Create(btn, info, {BackgroundColor3 = Color3.fromRGB(145, 95, 255)}):Play()
    end)

    table.insert(tabs, {button = btn, page = page})
    return page
end

-- TABLAR
local homeTab = createTab("Home")
local settingsTab = createTab("Settings")
local aboutTab = createTab("About")

-- HOME TAB: Buton
local homeBtn = Instance.new("TextButton", homeTab)
homeBtn.Size = UDim2.new(0, 200, 0, 50)
homeBtn.Position = UDim2.new(0, 50, 0, 50)
homeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
homeBtn.Text = "Launch"
homeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
homeBtn.Font = Enum.Font.GothamBold
homeBtn.TextSize = 20

local btnCorner = Instance.new("UICorner", homeBtn)
btnCorner.CornerRadius = UDim.new(0, 12)

homeBtn.MouseEnter:Connect(function()
    tweenService:Create(homeBtn, info, {BackgroundColor3 = Color3.fromRGB(145, 95, 255)}):Play()
end)
homeBtn.MouseLeave:Connect(function()
    tweenService:Create(homeBtn, info, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
end)

-- SETTINGS TAB: Toggle
local toggle = Instance.new("TextButton", settingsTab)
toggle.Size = UDim2.new(0, 200, 0, 50)
toggle.Position = UDim2.new(0, 50, 0, 50)
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
toggle.Text = "Feature: OFF"
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 18

local toggleCorner = Instance.new("UICorner", toggle)
toggleCorner.CornerRadius = UDim.new(0, 10)

local state = false
toggle.MouseButton1Click:Connect(function()
    state = not state
    if state then
        toggle.Text = "Feature: ON"
        tweenService:Create(toggle, info, {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
    else
        toggle.Text = "Feature: OFF"
        tweenService:Create(toggle, info, {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
    end
end)

-- SETTINGS TAB: Dropdown
local dropdown = Instance.new("TextButton", settingsTab)
dropdown.Size = UDim2.new(0, 200, 0, 40)
dropdown.Position = UDim2.new(0, 50, 0, 120)
dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
dropdown.Text = "Select Option"
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 16

local dropdownCorner = Instance.new("UICorner", dropdown)
dropdownCorner.CornerRadius = UDim.new(0, 8)

local listFrame = Instance.new("Frame", settingsTab)
listFrame.Size = UDim2.new(0, 200, 0, 0)
listFrame.Position = UDim2.new(0, 50, 0, 160)
listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
listFrame.Visible = false

local listCorner = Instance.new("UICorner", listFrame)
listCorner.CornerRadius = UDim.new(0, 8)

local options = {"Option A", "Option B", "Option C"}
for i, opt in ipairs(options) do
    local optBtn = Instance.new("TextButton", listFrame)
    optBtn.Size = UDim2.new(1, 0, 0, 30)
    optBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
    optBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    optBtn.Text = opt
    optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    optBtn.Font = Enum.Font.Gotham
    optBtn.TextSize = 14

    optBtn.MouseButton1Click:Connect(function()
        dropdown.Text = "Selected: "..opt
        listFrame.Visible = false
        listFrame.Size = UDim2.new(0, 200, 0, 0)
    end)
end

dropdown.MouseButton1Click:Connect(function()
    if listFrame.Visible then
        listFrame.Visible = false
        listFrame.Size = UDim2.new(0, 200, 0, 0)
    else
        listFrame.Visible = true
        listFrame.Size = UDim2.new(0, 200, 0, #options*30)
    end
end)

-- SETTINGS TAB: Keybind Picker
local keybindBtn = Instance.new("TextButton", settingsTab)
keybindBtn.Size = UDim2.new(0, 200, 0, 40)
keybindBtn.Position = UDim2.new(0, 50, 0, 220)
keybindBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
keybindBtn.Text = "Bind: None"
keybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindBtn.Font = Enum.Font.Gotham
keybindBtn.TextSize = 16

local keybindCorner = Instance.new("UICorner", keybindBtn)
keybindCorner.CornerRadius = UDim.new(0, 8)

local waiting = false
local currentKey = nil
local uis = game:GetService("UserInputService")

keybindBtn.MouseButton1Click:Connect(function()
    keybindBtn.Text = "Press any key..."
    waiting = true
end)

uis.InputBegan:Connect(function(input, gpe)
    if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
        currentKey = input.KeyCode
        keybindBtn.Text = "Bind: "..tostring(currentKey.Name)
        waiting = false
    elseif not gpe and currentKey and input.KeyCode == currentKey then
        print("Keybind activated: "..currentKey.Name)
    end
end)

-- ABOUT TAB
local aboutTxt = Instance.new("TextLabel", aboutTab)
aboutTxt.Size = UDim2.new(1, -20, 1, -20)
aboutTxt.Position = UDim2.new(0, 10, 0, 10)
aboutTxt.BackgroundTransparency = 1
aboutTxt.TextWrapped = true
aboutTxt.Text = "Wiihub Full Advanced UI Example\nTabs, Button, Toggle, Dropdown, Slider, Keybind"
aboutTxt.TextColor3 = Color3.fromRGB(255,255,255)
aboutTxt.Font = Enum.Font.Gotham
aboutTxt.TextSize = 18
