-- ==========================================================
-- UNIVERSAL ESP + AIMBOT v2
-- Для Solara / будь-який executor з Drawing API
-- Працює: Laplace, будь-яка гра з Players
-- ==========================================================

local Players = game:GetService("Players")
local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==========================================================
-- CONFIG
-- ==========================================================
local Config = {
    ESP = {
        Enabled = false,
        Box = true,
        BoxColor = Color3.fromRGB(255, 60, 60),
        Outline = true,
        Lines = true,
        LineFrom = "Bottom",  -- Bottom / Top / Center
        Name = true,
        Health = true,
        HealthBar = true,
        Distance = true,
        HeadDot = true,
        TeamCheck = true,
        MaxDistance = 1000,
        TextSize = 14,
    },
    Aimbot = {
        Enabled = false,
        FOV = 150,
        ShowFOV = true,
        FOVColor = Color3.fromRGB(160, 100, 255),
        Smoothness = 0.35,
        Part = "Head",       -- Head / Torso / UpperTorso / HumanoidRootPart / Nearest / Random
        TeamCheck = true,
        WallCheck = true,
        Key = Enum.UserInputType.MouseButton2,
        Method = "Camera",   -- Camera / Mouse
        Prediction = false,
    },
    Misc = {
        WalkSpeed = 16,
        JumpPower = 50,
        Fullbright = false,
        Noclip = false,
    }
}

local LocalTeam = nil
task.spawn(function()
    pcall(function() LocalTeam = LocalPlayer.Team end)
end)
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() LocalTeam = LocalPlayer.Team end)

-- ==========================================================
-- DRAWING SETUP
-- ==========================================================
local hasDrawing = pcall(function() return Drawing.new("Line") end)

-- ==========================================================
-- МЕНЮ (в стилі Laplace - темне, фіолетові акценти)
-- ==========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeoMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Colors = {
    Bg = Color3.fromRGB(18, 16, 24),
    Bg2 = Color3.fromRGB(24, 20, 32),
    Accent = Color3.fromRGB(155, 89, 255),
    Accent2 = Color3.fromRGB(200, 130, 255),
    Text = Color3.fromRGB(240, 240, 250),
    TextDim = Color3.fromRGB(150, 145, 170),
    Green = Color3.fromRGB(80, 220, 120),
    Red = Color3.fromRGB(255, 80, 100),
}

-- Головне вікно
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 420, 0, 480)
Main.Position = UDim2.new(0.5, -210, 0.5, -240)
Main.BackgroundColor3 = Colors.Bg
Main.BorderSizePixel = 0
Main.Visible = false
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3

-- Заголовок
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Colors.Bg2
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Colors.Bg2
HeaderFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✨  NEO  MENU"
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка закриття
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 6)
CloseBtn.BackgroundColor3 = Colors.Bg
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Colors.TextDim
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.2)
    Main.Visible = false
    Main.Size = UDim2.new(0, 420, 0, 480)
end)

-- Перетягування
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
Header.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Вкладки (кнопки зверху)
local TabsBar = Instance.new("Frame", Main)
TabsBar.Size = UDim2.new(1, -20, 0, 32)
TabsBar.Position = UDim2.new(0, 10, 0, 50)
TabsBar.BackgroundTransparency = 1

local TabsLayout = Instance.new("UIListLayout", TabsBar)
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Контент
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -20, 1, -95)
Content.Position = UDim2.new(0, 10, 0, 90)
Content.BackgroundTransparency = 1

-- Скрол контейнер (для кожної вкладки свій)
local pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Colors.Accent
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 5)
    pad.PaddingLeft = UDim.new(0, 5)
    pad.PaddingRight = UDim.new(0, 5)

    pages[name] = page
    return page
end

local function createTabButton(name)
    local btn = Instance.new("TextButton", TabsBar)
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.BackgroundColor3 = Colors.Bg2
    btn.Text = name
    btn.TextColor3 = Colors.TextDim
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for n, page in pairs(pages) do
            page.Visible = (n == name)
        end
        for _, b in ipairs(TabsBar:GetChildren()) do
            if b:IsA("TextButton") then
                if b == btn then
                    b.TextColor3 = Colors.Accent
                    b.BackgroundColor3 = Colors.Bg
                else
                    b.TextColor3 = Colors.TextDim
                    b.BackgroundColor3 = Colors.Bg2
                end
            end
        end
    end)
    return btn
end

-- Створюємо вкладки
local tabs = { "Main", "ESP", "Aimbot", "Misc" }
for _, t in ipairs(tabs) do createPage(t) end

local firstTab
for _, t in ipairs(tabs) do
    local b = createTabButton(t)
    if not firstTab then firstTab = b end
end
pages["Main"].Visible = true
firstTab.TextColor3 = Colors.Accent
firstTab.BackgroundColor3 = Colors.Bg

-- ==========================================================
-- ЕЛЕМЕНТИ МЕНЮ
-- ==========================================================

-- Toggle
local function makeToggle(page, text, default, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Colors.Bg2
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 40, 0, 20)
    indicator.Position = UDim2.new(1, -50, 0.5, -10)
    indicator.BackgroundColor3 = default and Colors.Accent or Color3.fromRGB(50, 45, 60)
    indicator.BorderSizePixel = 0
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", indicator)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    dot.BackgroundColor3 = Colors.Text
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(indicator, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Colors.Accent or Color3.fromRGB(50, 45, 60)
        }):Play()
        TweenService:Create(dot, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        }):Play()
        callback(state)
    end)
end

-- Slider
local function makeSlider(page, text, min, max, default, callback)
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Colors.Bg2
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(1, -24, 0, 6)
    bar.Position = UDim2.new(0, 12, 0, 35)
    bar.BackgroundColor3 = Color3.fromRGB(45, 40, 55)
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Accent
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local drag = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- Dropdown (простий)
local function makeDropdown(page, text, options, default, callback)
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Colors.Bg2
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local currentBtn = Instance.new("TextButton", frame)
    currentBtn.Size = UDim2.new(1, -24, 0, 26)
    currentBtn.Position = UDim2.new(0, 12, 0, 28)
    currentBtn.BackgroundColor3 = Colors.Bg
    currentBtn.Text = default
    currentBtn.TextColor3 = Colors.Accent2
    currentBtn.Font = Enum.Font.Gotham
    currentBtn.TextSize = 12
    currentBtn.BorderSizePixel = 0
    Instance.new("UICorner", currentBtn).CornerRadius = UDim.new(0, 4)

    local isOpen = false
    local listHolder = nil

    local function closeList()
        if listHolder then listHolder:Destroy() listHolder = nil end
        isOpen = false
    end

    currentBtn.MouseButton1Click:Connect(function()
        if isOpen then closeList() return end
        isOpen = true
        listHolder = Instance.new("Frame", ScreenGui)
        listHolder.Position = UDim2.new(0, currentBtn.AbsolutePosition.X, 0, currentBtn.AbsolutePosition.Y + 28)
        listHolder.Size = UDim2.new(0, currentBtn.AbsoluteSize.X, 0, #options * 26)
        listHolder.BackgroundColor3 = Colors.Bg
        listHolder.BorderSizePixel = 0
        listHolder.ZIndex = 50
        Instance.new("UICorner", listHolder).CornerRadius = UDim.new(0, 4)

        for i, opt in ipairs(options) do
            local o = Instance.new("TextButton", listHolder)
            o.Size = UDim2.new(1, 0, 0, 26)
            o.Position = UDim2.new(0, 0, 0, (i-1)*26)
            o.BackgroundColor3 = Colors.Bg
            o.Text = opt
            o.TextColor3 = Colors.Text
            o.Font = Enum.Font.Gotham
            o.TextSize = 12
            o.BorderSizePixel = 0
            o.ZIndex = 51
            o.MouseButton1Click:Connect(function()
                currentBtn.Text = opt
                closeList()
                callback(opt)
            end)
        end
    end)
end

-- Секція (заголовок)
local function makeSection(page, text)
    local lbl = Instance.new("TextLabel", page)
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "▸ " .. text
    lbl.TextColor3 = Colors.Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

-- ==========================================================
-- НАПОВНЕННЯ ВКЛАДОК
-- ==========================================================
local pMain = pages["Main"]
local pESP = pages["ESP"]
local pAim = pages["Aimbot"]
local pMisc = pages["Misc"]

-- MAIN
makeSection(pMain, "Загальне")
makeToggle(pMain, "ESP Enabled", false, function(v) Config.ESP.Enabled = v end)
makeToggle(pMain, "Aimbot Enabled", false, function(v) Config.Aimbot.Enabled = v end)

makeSection(pMain, "Інформація")
local info = Instance.new("TextLabel", pMain)
info.Size = UDim2.new(1, 0, 0, 60)
info.BackgroundColor3 = Colors.Bg2
info.Text = "  🎮 Гра: " .. game.PlaceId .. "\n  👥 Гравців: " .. #Players:GetPlayers() .. "\n  ⚙️ Drawing API: " .. (hasDrawing and "OK" or "НЕ ПІДТРИМУЄТЬСЯ")
info.TextColor3 = Colors.TextDim
info.Font = Enum.Font.Gotham
info.TextSize = 12
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
Instance.new("UICorner", info).CornerRadius = UDim.new(0, 6)

-- ESP
makeSection(pESP, "Загальне")
makeToggle(pESP, "Box", true, function(v) Config.ESP.Box = v end)
makeToggle(pESP, "Outline", true, function(v) Config.ESP.Outline = v end)
makeToggle(pESP, "Snaplines", true, function(v) Config.ESP.Lines = v end)
makeToggle(pESP, "Name", true, function(v) Config.ESP.Name = v end)
makeToggle(pESP, "Health Text", true, function(v) Config.ESP.Health = v end)
makeToggle(pESP, "Health Bar", true, function(v) Config.ESP.HealthBar = v end)
makeToggle(pESP, "Distance", true, function(v) Config.ESP.Distance = v end)
makeToggle(pESP, "Head Dot", true, function(v) Config.ESP.HeadDot = v end)
makeToggle(pESP, "Team Check", true, function(v) Config.ESP.TeamCheck = v end)

makeSection(pESP, "Налаштування")
makeSlider(pESP, "Max Distance", 100, 5000, 1000, function(v) Config.ESP.MaxDistance = v end)
makeSlider(pESP, "Text Size", 10, 20, 14, function(v) Config.ESP.TextSize = v end)
makeDropdown(pESP, "Lines From", {"Bottom", "Top", "Center"}, "Bottom", function(v) Config.ESP.LineFrom = v end)

-- AIMBOT
makeSection(pAim, "Загальне")
makeToggle(pAim, "Aimbot", false, function(v) Config.Aimbot.Enabled = v end)
makeToggle(pAim, "Show FOV Circle", true, function(v) Config.Aimbot.ShowFOV = v end)
makeToggle(pAim, "Team Check", true, function(v) Config.Aimbot.TeamCheck = v end)
makeToggle(pAim, "Wall Check", true, function(v) Config.Aimbot.WallCheck = v end)
makeToggle(pAim, "Prediction", false, function(v) Config.Aimbot.Prediction = v end)

makeSection(pAim, "Налаштування")
makeSlider(pAim, "FOV", 20, 600, 150, function(v) Config.Aimbot.FOV = v end)
makeSlider(pAim, "Smoothness (%)", 5, 100, 35, function(v) Config.Aimbot.Smoothness = v / 100 end)
makeDropdown(pAim, "Target Part", {"Head", "Torso", "UpperTorso", "HumanoidRootPart", "Nearest", "Random"}, "Head", function(v) Config.Aimbot.Part = v end)
makeDropdown(pAim, "Method", {"Camera", "Mouse"}, "Camera", function(v) Config.Aimbot.Method = v end)
makeDropdown(pAim, "Activation Key", {"MouseButton2", "E", "Q", "CapsLock"}, "MouseButton2", function(v)
    Config.Aimbot.Key = Enum.UserInputType[v] or Enum.KeyCode[v] or Enum.UserInputType.MouseButton2
end)

-- MISC
makeSection(pMisc, "Movement")
makeSlider(pMisc, "Walk Speed", 16, 200, 16, function(v)
    Config.Misc.WalkSpeed = v
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end)
makeSlider(pMisc, "Jump Power", 50, 300, 50, function(v)
    Config.Misc.JumpPower = v
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = v hum.UseJumpPower = true end
end)

makeSection(pMisc, "World")
makeToggle(pMisc, "Fullbright", false, function(v)
    Config.Misc.Fullbright = v
    if v then
        game.Lighting.Ambient = Color3.fromRGB(255,255,255)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        game.Lighting.Brightness = 2
    else
        game.Lighting.Ambient = Color3.fromRGB(70,70,70)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        game.Lighting.Brightness = 1
    end
end)
makeToggle(pMisc, "Noclip", false, function(v) Config.Misc.Noclip = v end)

-- ==========================================================
-- ESP DRAWING
-- ==========================================================
local ESPData = {}

local function createESP(player)
    if player == LocalPlayer or ESPData[player] then return end
    if not hasDrawing then return end

    local data = {}
    data.box = Drawing.new("Square")
    data.box.Thickness = 1.5
    data.box.Filled = false
    data.box.Color = Config.ESP.BoxColor
    data.box.Visible = false
    data.box.ZIndex = 2

    data.outline = Drawing.new("Square")
    data.outline.Thickness = 3
    data.outline.Filled = false
    data.outline.Color = Color3.fromRGB(0, 0, 0)
    data.outline.Visible = false
    data.outline.ZIndex = 1

    data.name = Drawing.new("Text")
    data.name.Size = 14
    data.name.Center = true
    data.name.Outline = true
    data.name.Color = Color3.fromRGB(255, 255, 255)
    data.name.Visible = false
    data.name.ZIndex = 3

    data.hpText = Drawing.new("Text")
    data.hpText.Size = 13
    data.hpText.Center = true
    data.hpText.Outline = true
    data.hpText.Color = Color3.fromRGB(80, 255, 120)
    data.hpText.Visible = false
    data.hpText.ZIndex = 3

    data.distText = Drawing.new("Text")
    data.distText.Size = 12
    data.distText.Center = true
    data.distText.Outline = true
    data.distText.Color = Color3.fromRGB(200, 200, 220)
    data.distText.Visible = false
    data.distText.ZIndex = 3

    data.tracer = Drawing.new("Line")
    data.tracer.Thickness = 1.2
    data.tracer.Color = Config.ESP.BoxColor
    data.tracer.Visible = false
    data.tracer.ZIndex = 2

    data.hpBarBg = Drawing.new("Line")
    data.hpBarBg.Thickness = 2
    data.hpBarBg.Color = Color3.fromRGB(0, 0, 0)
    data.hpBarBg.Visible = false
    data.hpBarBg.ZIndex = 2

    data.hpBar = Drawing.new("Line")
    data.hpBar.Thickness = 2
    data.hpBar.Color = Color3.fromRGB(80, 255, 120)
    data.hpBar.Visible = false
    data.hpBar.ZIndex = 3

    data.headDot = Drawing.new("Circle")
    data.headDot.Radius = 3
    data.headDot.Filled = true
    data.headDot.Color = Color3.fromRGB(255, 255, 255)
    data.headDot.Visible = false
    data.headDot.ZIndex = 3

    ESPData[player] = data
end

local function removeESP(player)
    local d = ESPData[player]
    if not d then return end
    for _, obj in pairs(d) do
        pcall(function() obj:Remove() end)
    end
    ESPData[player] = nil
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end

-- FOV Circle
local fovCircle
if hasDrawing then
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1.5
    fovCircle.NumSides = 64
    fovCircle.Radius = Config.Aimbot.FOV
    fovCircle.Filled = false
    fovCircle.Color = Config.Aimbot.FOVColor
    fovCircle.Visible = false
    fovCircle.ZIndex = 1
end

-- ==========================================================
-- HELPERS
-- ==========================================================
local function getPart(char)
    if not char then return nil end
    if Config.Aimbot.Part == "Nearest" or Config.Aimbot.Part == "Random" then
        -- вибираємо випадкову/найближчу доступну частину
        local parts = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"}
        if Config.Aimbot.Part == "Random" then
            return char:FindFirstChild(parts[math.random(1, #parts)])
        else
            for _, n in ipairs(parts) do
                local p = char:FindFirstChild(n)
                if p then return p end
            end
        end
    end
    local p = char:FindFirstChild(Config.Aimbot.Part)
    if not p then
        -- fallback
        for _, n in ipairs({"Head", "UpperTorso", "Torso", "HumanoidRootPart"}) do
            p = char:FindFirstChild(n)
            if p then return p end
        end
    end
    return p
end

local function isVisible(part)
    if not Config.Aimbot.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local dir = (part.Position - origin).Unit * (part.Position - origin).Magnitude
    local ray = Ray.new(origin, dir)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, part.Parent}, false, true)
    return hit == nil or hit:IsDescendantOf(part.Parent)
end

local function isTeammate(player)
    if not Config.Aimbot.TeamCheck and not Config.ESP.TeamCheck then return false end
    if not LocalTeam or not player.Team then return false end
    return player.Team == LocalTeam
end

local function getHealthColor(hp, maxHp)
    local ratio = hp / math.max(maxHp, 1)
    if ratio > 0.6 then return Color3.fromRGB(80, 255, 120)
    elseif ratio > 0.3 then return Color3.fromRGB(255, 200, 80)
    else return Color3.fromRGB(255, 80, 100) end
end

-- ==========================================================
-- MAIN LOOP
-- ==========================================================
local lastAimTarget = nil

RunService.RenderStepped:Connect(function()
    -- ========== ESP ==========
    if Config.ESP.Enabled and hasDrawing then
        for player, data in pairs(ESPData) do
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
            local head = char and char:FindFirstChild("Head")

            if player == LocalPlayer or not hum or hum.Health <= 0 or not root or (Config.ESP.TeamCheck and isTeammate(player)) then
                for _, obj in pairs(data) do pcall(function() obj.Visible = false end) end
            else
                local rootPos, rootOnScreen = Camera:WorldToViewportPoint(root.Position)
                local dist = (Camera.CFrame.Position - root.Position).Magnitude

                if not rootOnScreen or rootPos.Z <= 0 or dist > Config.ESP.MaxDistance then
                    for _, obj in pairs(data) do pcall(function() obj.Visible = false end) end
                else
                    -- розрахунок розмірів
                    local headPos = head and Camera:WorldToViewportPoint(head.Position) or rootPos
                    local topY = headPos.Y - 20
                    local bottomY = rootPos.Y + 25
                    local height = math.abs(bottomY - topY)
                    local width = height * 0.55

                    if Config.ESP.Box then
                        data.outline.Size = Vector2.new(width, height)
                        data.outline.Position = Vector2.new(rootPos.X - width/2, topY)
                        data.outline.Visible = Config.ESP.Outline

                        data.box.Size = Vector2.new(width, height)
                        data.box.Position = Vector2.new(rootPos.X - width/2, topY)
                        data.box.Color = isTeammate(player) and Color3.fromRGB(80, 200, 255) or Config.ESP.BoxColor
                        data.box.Visible = true
                    else
                        data.box.Visible = false
                        data.outline.Visible = false
                    end

                    if Config.ESP.Lines then
                        local from
                        if Config.ESP.LineFrom == "Bottom" then
                            from = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        elseif Config.ESP.LineFrom == "Top" then
                            from = Vector2.new(Camera.ViewportSize.X / 2, 0)
                        else
                            from = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        end
                        data.tracer.From = from
                        data.tracer.To = Vector2.new(rootPos.X, bottomY)
                        data.tracer.Color = isTeammate(player) and Color3.fromRGB(80, 200, 255) or Config.ESP.BoxColor
                        data.tracer.Visible = true
                    else
                        data.tracer.Visible = false
                    end

                    if Config.ESP.Name then
                        data.name.Text = player.Name
                        data.name.Size = Config.ESP.TextSize
                        data.name.Position = Vector2.new(rootPos.X, topY - 16)
