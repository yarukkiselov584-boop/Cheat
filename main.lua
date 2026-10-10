-- ==========================================================
-- UNIVERSAL ESP + AIMBOT + MINIMAP
-- ==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ==========================================================
-- CONFIG
-- ==========================================================
local Config = {
    ESP = {
        Enabled = false,
        Box = true,
        BoxColor = Color3.fromRGB(255, 60, 60),
        LineThickness = 1.5,
        Outline = true,
        Lines = true,
        LineFrom = "Bottom",
        Name = true,
        Health = true,
        HealthBar = true,
        Distance = true,
        TeamCheck = true,
        MaxDistance = 1000,
    },
    Aimbot = {
        Enabled = false,
        FOV = 150,
        ShowFOV = true,
        Smoothness = 0.35,
        Part = "Head",
        TeamCheck = true,
        WallCheck = true,
        Key = Enum.UserInputType.MouseButton2,
    },
    Misc = {
        WalkSpeed = 16,
        JumpPower = 50,
        PotatoMode = false,
    },
    Minimap = {
        Enabled = true,
        Size = 150,
        Position = UDim2.new(1, -170, 0, 20),
        Scale = 0.5, -- 1 stud = 0.5 pixels
    }
}

local LocalTeam = LocalPlayer.Team

-- ==========================================================
-- МЕНЮ (УКРАЇНСЬКОЮ)
-- ==========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeoMenuUA"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Colors = {
    Bg = Color3.fromRGB(18, 16, 24),
    Bg2 = Color3.fromRGB(24, 20, 32),
    Accent = Color3.fromRGB(155, 89, 255),
    Text = Color3.fromRGB(240, 240, 250),
    TextDim = Color3.fromRGB(150, 145, 170),
}

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 400, 0, 480)
Main.Position = UDim2.new(0.5, -200, 0.5, -240)
Main.BackgroundColor3 = Colors.Bg
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Colors.Bg2
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✨ NEO МЕНЮ"
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Перетягування
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
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

local TabsBar = Instance.new("Frame", Main)
TabsBar.Size = UDim2.new(1, -20, 0, 32)
TabsBar.Position = UDim2.new(0, 10, 0, 50)
TabsBar.BackgroundTransparency = 1
local TabsLayout = Instance.new("UIListLayout", TabsBar)
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.Padding = UDim.new(0, 5)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -20, 1, -95)
Content.Position = UDim2.new(0, 10, 0, 90)
Content.BackgroundTransparency = 1

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
        for n, page in pairs(pages) do page.Visible = (n == name) end
        for _, b in ipairs(TabsBar:GetChildren()) do
            if b:IsA("TextButton") then
                b.TextColor3 = (b == btn) and Colors.Accent or Colors.TextDim
                b.BackgroundColor3 = (b == btn) and Colors.Bg or Colors.Bg2
            end
        end
    end)
    return btn
end

local tabs = { "Головна", "ESP", "Аім", "Міні-карта", "Різне" }
for _, t in ipairs(tabs) do createPage(t) end
local firstTab
for _, t in ipairs(tabs) do
    local b = createTabButton(t)
    if not firstTab then firstTab = b end
end
pages["Головна"].Visible = true
firstTab.TextColor3 = Colors.Accent
firstTab.BackgroundColor3 = Colors.Bg

-- ЕЛЕМЕНТИ
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
        TweenService:Create(indicator, TweenInfo.new(0.15), {BackgroundColor3 = state and Colors.Accent or Color3.fromRGB(50, 45, 60)}):Play()
        TweenService:Create(dot, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        callback(state)
    end)
end

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
    bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
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
    currentBtn.TextColor3 = Colors.Accent
    currentBtn.Font = Enum.Font.Gotham
    currentBtn.TextSize = 12
    currentBtn.BorderSizePixel = 0
    Instance.new("UICorner", currentBtn).CornerRadius = UDim.new(0, 4)
    local isOpen, listHolder = false, nil
    local function closeList() if listHolder then listHolder:Destroy() listHolder = nil end isOpen = false end
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
-- НАПОВНЕННЯ
-- ==========================================================
local pMain, pESP, pAim, pMap, pMisc = pages["Головна"], pages["ESP"], pages["Аім"], pages["Міні-карта"], pages["Різне"]

makeSection(pMain, "Загальне")
makeToggle(pMain, "Увімкнути ESP", false, function(v) Config.ESP.Enabled = v end)
makeToggle(pMain, "Увімкнути Аімбот", false, function(v) Config.Aimbot.Enabled = v end)

makeSection(pESP, "Елементи")
makeToggle(pESP, "Бокс", true, function(v) Config.ESP.Box = v end)
makeToggle(pESP, "Обводка", true, function(v) Config.ESP.Outline = v end)
makeToggle(pESP, "Лінії", true, function(v) Config.ESP.Lines = v end)
makeToggle(pESP, "Ім'я", true, function(v) Config.ESP.Name = v end)
makeToggle(pESP, "Здоров'я", true, function(v) Config.ESP.Health = v end)
makeToggle(pESP, "Смуга HP", true, function(v) Config.ESP.HealthBar = v end)
makeToggle(pESP, "Дистанція", true, function(v) Config.ESP.Distance = v end)
makeToggle(pESP, "Перевірка команди", true, function(v) Config.ESP.TeamCheck = v end)

makeSection(pESP, "Налаштування")
makeSlider(pESP, "Товщина ліній", 1, 5, 2, function(v) Config.ESP.LineThickness = v end)
makeSlider(pESP, "Макс. дистанція", 100, 5000, 1000, function(v) Config.ESP.MaxDistance = v end)

makeSection(pAim, "Загальне")
makeToggle(pAim, "Аімбот", false, function(v) Config.Aimbot.Enabled = v end)
makeToggle(pAim, "Показувати FOV", true, function(v) Config.Aimbot.ShowFOV = v end)
makeToggle(pAim, "Перевірка команди", true, function(v) Config.Aimbot.TeamCheck = v end)
makeToggle(pAim, "Перевірка стін", true, function(v) Config.Aimbot.WallCheck = v end)

makeSection(pAim, "Налаштування")
makeSlider(pAim, "FOV", 20, 600, 150, function(v) Config.Aimbot.FOV = v end)
makeSlider(pAim, "Плавність", 5, 100, 35, function(v) Config.Aimbot.Smoothness = v / 100 end)
makeDropdown(pAim, "Частина тіла", {"Head", "Torso", "UpperTorso", "HumanoidRootPart", "Nearest"}, "Head", function(v) Config.Aimbot.Part = v end)
makeDropdown(pAim, "Клавіша активації", {"MouseButton2", "E", "Q", "CapsLock"}, "MouseButton2", function(v)
    Config.Aimbot.Key = Enum.UserInputType[v] or Enum.KeyCode[v] or Enum.UserInputType.MouseButton2
end)

makeSection(pMap, "Міні-карта")
makeToggle(pMap, "Увімкнути", true, function(v) Config.Minimap.Enabled = v end)
makeSlider(pMap, "Розмір", 100, 300, 150, function(v)
    Config.Minimap.Size = v
    if MinimapFrame then MinimapFrame.Size = UDim2.new(0, v, 0, v) end
end)
makeSlider(pMap, "Масштаб", 10, 200, 50, function(v) Config.Minimap.Scale = v / 100 end)

makeSection(pMisc, "Рух")
makeSlider(pMisc, "Швидкість", 16, 200, 16, function(v)
    Config.Misc.WalkSpeed = v
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end)
makeSlider(pMisc, "Сила стрибка", 50, 300, 50, function(v)
    Config.Misc.JumpPower = v
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = v; hum.UseJumpPower = true end
end)

makeSection(pMisc, "Продуктивність")
makeToggle(pMisc, "🥔 Картопляний режим", false, function(v)
    Config.Misc.PotatoMode = v
    if v then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.Brightness = 1
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then v.Enabled = false end
            end
        end)
    end
end)

-- ==========================================================
-- ESP DRAWING (ВИПРАВЛЕНО)
-- ==========================================================
local ESPData = {}
local hasDrawing = pcall(function() return Drawing.new("Line") end)

local function createESP(player)
    if player == LocalPlayer or ESPData[player] or not hasDrawing then return end
    local d = {}
    d.box = Drawing.new("Square"); d.box.Thickness = Config.ESP.LineThickness; d.box.Filled = false; d.box.Color = Config.ESP.BoxColor; d.box.Visible = false; d.box.ZIndex = 2
    d.outline = Drawing.new("Square"); d.outline.Thickness = 3; d.outline.Filled = false; d.outline.Color = Color3.new(0,0,0); d.outline.Visible = false; d.outline.ZIndex = 1
    d.name = Drawing.new("Text"); d.name.Size = 14; d.name.Center = true; d.name.Outline = true; d.name.Color = Color3.new(1,1,1); d.name.Visible = false; d.name.ZIndex = 3
    d.hpText = Drawing.new("Text"); d.hpText.Size = 13; d.hpText.Center = true; d.hpText.Outline = true; d.hpText.Color = Color3.fromRGB(80, 255, 120); d.hpText.Visible = false; d.hpText.ZIndex = 3
    d.distText = Drawing.new("Text"); d.distText.Size = 12; d.distText.Center = true; d.distText.Outline = true; d.distText.Color = Color3.fromRGB(200, 200, 220); d.distText.Visible = false; d.distText.ZIndex = 3
    d.tracer = Drawing.new("Line"); d.tracer.Thickness = Config.ESP.LineThickness; d.tracer.Color = Config.ESP.BoxColor; d.tracer.Visible = false; d.tracer.ZIndex = 2
    d.hpBarBg = Drawing.new("Line"); d.hpBarBg.Thickness = 2; d.hpBarBg.Color = Color3.new(0,0,0); d.hpBarBg.Visible = false; d.hpBarBg.ZIndex = 2
    d.hpBar = Drawing.new("Line"); d.hpBar.Thickness = 2; d.hpBar.Color = Color3.fromRGB(80, 255, 120); d.hpBar.Visible = false; d.hpBar.ZIndex = 3
    ESPData[player] = d
end

local function removeESP(player)
    local d = ESPData[player]
    if not d then return end
    for _, obj in pairs(d) do pcall(function() obj:Remove() end) end
    ESPData[player] = nil
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end

-- FOV CIRCLE
local fovCircle
if hasDrawing then
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1.5
    fovCircle.NumSides = 64
    fovCircle.Filled = false
    fovCircle.Color = Color3.fromRGB(160, 100, 255)
    fovCircle.Visible = false
    fovCircle.ZIndex = 1
end

-- ==========================================================
-- MINIMAP
-- ==========================================================
local MinimapFrame = Instance.new("Frame", ScreenGui)
MinimapFrame.Size = UDim2.new(0, Config.Minimap.Size, 0, Config.Minimap.Size)
MinimapFrame.Position = Config.Minimap.Position
MinimapFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MinimapFrame.BackgroundTransparency = 0.3
MinimapFrame.BorderSizePixel = 1
MinimapFrame.BorderColor3 = Colors.Accent
MinimapFrame.Visible = Config.Minimap.Enabled
Instance.new("UICorner", MinimapFrame).CornerRadius = UDim.new(0, 6)

local MinimapDots = {}
local function updateMinimap()
    if not Config.Minimap.Enabled then MinimapFrame.Visible = false return end
    MinimapFrame.Visible = true
    
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    local origin = localRoot.Position
    local scale = Config.Minimap.Scale
    
    -- Очищення старих точок
    for _, dot in pairs(MinimapDots) do dot:Destroy() end
    MinimapDots = {}
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local rel = (root.Position - origin) * scale
                local dot = Instance.new("Frame", MinimapFrame)
                dot.Size = UDim2.new(0, 6, 0, 6)
                dot.Position = UDim2.new(0.5, rel.X - 3, 0.5, -rel.Z - 3)
                dot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
                dot.BorderSizePixel = 0
                Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
                table.insert(MinimapDots, dot)
            end
        end
    end
end

-- ==========================================================
-- HELPERS & MAIN LOOP
-- ==========================================================
local function getPart(char)
    if not char then return nil end
    if Config.Aimbot.Part == "Nearest" then
        local parts = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"}
        for _, n in ipairs(parts) do local p = char:FindFirstChild(n); if p then return p end end
    end
    local p = char:FindFirstChild(Config.Aimbot.Part)
    if not p then
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

RunService.RenderStepped:Connect(function()
    -- ESP UPDATE
    if Config.ESP.Enabled and hasDrawing then
        for player, data in pairs(ESPData) do
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")

            if player == LocalPlayer or not hum or hum.Health <= 0 or not root or (Config.ESP.TeamCheck and isTeammate(player)) then
                for _, obj in pairs(data) do pcall(function() obj.Visible = false end) end
            else
                local rootPos, rootOnScreen = Camera:WorldToViewportPoint(root.Position)
                local dist = (Camera.CFrame.Position - root.Position).Magnitude
                if not rootOnScreen or rootPos.Z <= 0 or dist > Config.ESP.MaxDistance then
                    for _, obj in pairs(data) do pcall(function() obj.Visible = false end) end
                else
                    local headPos = head and Camera:WorldToViewportPoint(head.Position) or rootPos
                    local topY, bottomY = headPos.Y - 20, rootPos.Y + 25
                    local height = math.abs(bottomY - topY)
                    local width = height * 0.55

                    if Config.ESP.Box then
                        data.outline.Size = Vector2.new(width, height); data.outline.Position = Vector2.new(rootPos.X - width/2, topY); data.outline.Visible = Config.ESP.Outline
                        data.box.Size = Vector2.new(width, height); data.box.Position = Vector2.new(rootPos.X - width/2, topY)
                        data.box.Color = isTeammate(player) and Color3.fromRGB(80, 200, 255) or Config.ESP.BoxColor
                        data.box.Visible = true
                    else data.box.Visible = false; data.outline.Visible = false end

                    if Config.ESP.Lines then
                        local from = Config.ESP.LineFrom == "Bottom" and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) or Config.ESP.LineFrom == "Top" and Vector2.new(Camera.ViewportSize.X / 2, 0) or Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        data.tracer.From = from; data.tracer.To = Vector2.new(rootPos.X, bottomY)
                        data.tracer.Color = isTeammate(player) and Color3.fromRGB(80, 200, 255) or Config.ESP.BoxColor
                        data.tracer.Visible = true
                    else data.tracer.Visible = false end

                    if Config.ESP.Name then data.name.Text = player.Name; data.name.Size = 14; data.name.Position = Vector2.new(rootPos.X, topY - 16); data.name.Visible = true else data.name.Visible = false end
                    if Config.ESP.Health then data.hpText.Text = "❤ " .. math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth); data.hpText.Size = 13; data.hpText.Position = Vector2.new(rootPos.X, bottomY + 2); data.hpText.Visible = true else data.hpText.Visible = false end

                    if Config.ESP.HealthBar then
                        local barX = rootPos.X - width/2 - 8
                        local fill = (bottomY - topY) * (hum.Health / math.max(hum.MaxHealth, 1))
                        data.hpBarBg.From = Vector2.new(barX, topY); data.hpBarBg.To = Vector2.new(barX, bottomY); data.hpBarBg.Visible = true
                        data.hpBar.From = Vector2.new(barX, bottomY - fill); data.hpBar.To = Vector2.new(barX, bottomY); data.hpBar.Visible = true
                    else data.hpBarBg.Visible = false; data.hpBar.Visible = false end

                    if Config.ESP.Distance then data.distText.Text = "[" .. math.floor(dist) .. "m]"; data.distText.Size = 12; data.distText.Position = Vector2.new(rootPos.X, topY - 30); data.distText.Visible = true else data.distText.Visible = false end
                end
            end
        end
    else
        for _, data in pairs(ESPData) do for _, obj in pairs(data) do pcall(function() obj.Visible = false end) end end
    end

    -- AIMBOT UPDATE
    if fovCircle then
        fovCircle.Radius = Config.Aimbot.FOV
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircle.Visible = Config.Aimbot.Enabled and Config.Aimbot.ShowFOV
    end

    local keyActive = false
    if typeof(Config.Aimbot.Key) == "EnumItem" then
        if Config.Aimbot.Key.EnumType == Enum.UserInputType then keyActive = UserInputService:IsMouseButtonPressed(Config.Aimbot.Key)
        else keyActive = UserInputService:IsKeyDown(Config.Aimbot.Key) end
    end

    if Config.Aimbot.Enabled and keyActive and LocalPlayer.Character then
        local mousePos = UserInputService:GetMouseLocation()
        local closest, shortest = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and not isTeammate(p) then
                    local part = getPart(char)
                    if part and isVisible(part) then
                        local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen and sp.Z > 0 then
                            local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                            if d < shortest and d < Config.Aimbot.FOV then shortest = d; closest = part end
                        end
                    end
                end
            end
        end
        if closest then
            local targetPos = closest.Position
            local sp = Camera:WorldToViewportPoint(targetPos)
            local delta = Vector2.new(sp.X, sp.Y) - mousePos
            local camCF = Camera.CFrame
            Camera.CFrame = camCF:Lerp(CFrame.new(camCF.Position, targetPos), math.clamp(Config.Aimbot.Smoothness, 0, 1))
        end
    end

    -- MINIMAP UPDATE
    updateMinimap()
end)

-- CONTROLS
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then
        if Main.Visible then
            TweenService:Create(Main, TweenInfo.new(0.15), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.15); Main.Visible = false; Main.Size = UDim2.new(0, 400, 0, 480)
        else
            Main.Visible = true; Main.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 480)}):Play()
        end
    end
end)
