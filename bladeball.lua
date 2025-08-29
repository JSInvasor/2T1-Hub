-- WiiHub Tarzı GUI Template
-- Hazırlayan: ChatGPT

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Player
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WiiHubClone"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 350)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- UI Corner
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

-- Tab Menu (Sol Panel)
local tabMenu = Instance.new("Frame")
tabMenu.Size = UDim2.new(0, 150, 1, 0)
tabMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabMenu.BorderSizePixel = 0
tabMenu.Parent = mainFrame

Instance.new("UICorner", tabMenu).CornerRadius = UDim.new(0, 12)

-- Container (Sağ taraf)
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -150, 1, 0)
container.Position = UDim2.new(0, 150, 0, 0)
container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
container.BorderSizePixel = 0
container.Parent = mainFrame

Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)

-- Tab Buttons
local tabList = Instance.new("UIListLayout", tabMenu)
tabList.Padding = UDim.new(0, 8)
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabList.VerticalAlignment = Enum.VerticalAlignment.Top

local function createTab(name)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.new(0, 10, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = tabMenu
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    return button
end

-- Sekmeler
local combatTab = createTab("Combat")
local movementTab = createTab("Movement")
local miscTab = createTab("Misc")

-- Sayfalar
local function createPage(title)
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 50)
    label.Text = title
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Parent = page
    
    return page
end

local combatPage = createPage("Combat Settings")
local movementPage = createPage("Movement Settings")
local miscPage = createPage("Misc Settings")

-- Tab Switching
local pages = {
    [combatTab] = combatPage,
    [movementTab] = movementPage,
    [miscTab] = miscPage
}

for btn, page in pairs(pages) do
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do
            p.Visible = false
        end
        page.Visible = true
    end)
end

-- Default sayfa
combatPage.Visible = true

-- Toggle örneği
local function createToggle(parent, text)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 200, 0, 35)
    toggle.Position = UDim2.new(0, 20, 0, 60)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.Text = text .. " [OFF]"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.BorderSizePixel = 0
    toggle.Parent = parent
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = text .. (state and " [ON]" or " [OFF]")
        toggle.BackgroundColor3 = state and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(50, 50, 50)
    end)
    
    return toggle
end

-- Combat tabına bir toggle ekliyoruz
createToggle(combatPage, "Auto Parry")
createToggle(combatPage, "Aimbot")
createToggle(movementPage, "Speed Hack")
createToggle(miscPage, "ESP")

print("WiiHub tarzı GUI başarıyla yüklendi!")
