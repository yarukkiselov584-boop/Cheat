-- ==========================================================
-- NEO MENU — iOS EDITION (ESP + AIMBOT)
-- Оптимізовано для Delta Executor на iPhone
-- ==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ==========================================================
-- CONFIG
-- ==========================================================
local Config = {
    ESP = {
        Enabled = false,
        Box = true,
        BoxColor = Color3.fromRGB(255, 80, 90),
        BoxThickness = 2,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Name = true,
        NameColor = Color3.fromRGB(255, 255, 255),
        Health = true,
        Distance = true,
        DistanceColor = Color3.fromRGB(200, 200, 220),
        TeamCheck = false,
        MaxDistance = 1000,
    },
    Aimbot = {
        Enabled = false,
        Mode = "Hold",
        Key = Enum.UserInputType.MouseButton2,
        FOV = 150,
        ShowFOV = true,
        FOVColor = Color3.fromRGB(160, 100, 255),
        Smoothness = 0.35,
        Part = "Head",
        TeamCheck = false,
        MaxDistance = 1000,
    }
}

-- ==========================================================
-- ПРОСТЕ МЕНЮ (мінімум для iOS)
-- ==========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeoIOS"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Menu = Instance.new("Frame", ScreenGui)
Menu.Size = UDim2.new(0, 240, 0, 280)
Menu.Position = UDim2.new(0, 20, 0, 100)
Menu.BackgroundColor3 = Color3.fromRGB(15, 18, 35)
Menu.BorderSizePixel = 0
Menu.Visible = false
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 10)

local MenuStroke = Instance.new("UIStroke", Menu)
MenuStroke.Color = Color3.fromRGB(130, 90, 220)
MenuStroke.Thickness = 1.5

local Title = Instance.new("TextLabel", Menu)
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
Title.Text = "✦ NEO iOS"
Title.TextColor3 = Color3.fromRGB(220, 180, 90)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)
local TitlePad = Instance.new("UIPadding", Title)
TitlePad.PaddingLeft = UDim.new(0, 12)

-- Перетягування (для iOS — через touch)
local dragging, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Menu.Position
    end
end)
Title.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        Menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Контейнер для кнопок
local Scroll = Instance.new("ScrollingFrame", Menu)
Scroll.Size = UDim2.new(1, -16, 1, -50)
Scroll.Position = UDim2.new(0, 8, 0, 42)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(130, 90, 220)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local ScrollLayout = Instance.new("UIListLayout", Scroll)
ScrollLayout.Padding = UDim.new(0, 6)

-- Функція створення тумблера
local function makeToggle(text, default, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
    btn.Text = "  " .. text .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = default and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(255, 80, 90)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = "  " .. text .. ": " .. (state and "ON" or "OFF")
        btn.TextColor3 = state and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(255, 80, 90)
        callback(state)
    end)
end

local function makeSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -10, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(230, 230, 245)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local barBg = Instance.new("Frame", frame)
    barBg.Size = UDim2.new(1, -16, 0, 8)
    barBg.Position = UDim2.new(0, 8, 0, 28)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 45, 70)
    barBg.BorderSizePixel = 0
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", barBg)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(130, 90, 220)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- Кнопки
makeToggle("ESP", false, function(v) Config.ESP.Enabled = v end)
makeToggle("Box", true, function(v) Config.ESP.Box = v end)
makeToggle("Outline", true, function(v) Config.ESP.Outline = v end)
makeToggle("Name", true, function(v) Config.ESP.Name = v end)
makeToggle("Health", true, function(v) Config.ESP.Health = v end)
makeToggle("Distance", true, function(v) Config.ESP.Distance = v end)
makeToggle("Team Check", false, function(v) Config.ESP.TeamCheck = v end)
makeToggle("Aimbot", false, function(v) Config.Aimbot.Enabled = v end)
makeToggle("Show FOV", true, function(v) Config.Aimbot.ShowFOV = v end)
makeSlider("FOV", 20, 600, 150, function(v) Config.Aimbot.FOV = v end)
makeSlider("Smoothness", 5, 100, 35, function(v) Config.Aimbot.Smoothness = v / 100 end)

-- Кнопка відкриття/закриття меню (тап на іконку в кутку)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0, 30)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 18, 35)
OpenBtn.Text = "✦"
OpenBtn.TextColor3 = Color3.fromRGB(220, 180, 90)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 24
OpenBtn.BorderSizePixel = 0
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(130, 90, 220)
OpenBtn.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

-- ==========================================================
-- ESP (спрощений, для iOS)
-- ==========================================================
local ESPData = {}

local function createESP(player)
    if player == LocalPlayer or ESPData[player] then return end
    local ok, data = pcall(function()
        local d = {}
        d.box = Drawing.new("Square")
        d.box.Thickness = Config.ESP.BoxThickness
        d.box.Filled = false
        d.box.Color = Config.ESP.BoxColor
        d.box.Visible = false
        
        d.name = Drawing.new("Text")
        d.name.Size = 14
        d.name.Center = true
        d.name.Outline = true
        d.name.Color = Config.ESP.NameColor
        d.name.Visible = false
        
        d.health = Drawing.new("Text")
        d.health.Size = 12
        d.health.Center = true
        d.health.Outline = true
        d.health.Color = Color3.fromRGB(80, 255, 120)
        d.health.Visible = false
        
        d.dist = Drawing.new("Text")
        d.dist.Size = 11
        d.dist.Center = true
        d.dist.Outline = true
        d.dist.Color = Config.ESP.DistanceColor
        d.dist.Visible = false
        
        return d
    end)
    if ok and data then ESPData[player] = data end
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
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1.5
    fovCircle.NumSides = 64
    fovCircle.Filled = false
    fovCircle.Color = Config.Aimbot.FOVColor
    fovCircle.Visible = false
end)

-- ==========================================================
-- HELPERS
-- ==========================================================
local function isTeammate(player)
    if not LocalPlayer.Team or not player.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function getPart(char, partName)
    if not char then return nil end
    local p = char:FindFirstChild(partName)
    if not p then
        for _, n in ipairs({"Head", "UpperTorso", "Torso", "HumanoidRootPart"}) do
            p = char:FindFirstChild(n)
            if p then return p end
        end
    end
    return p
end

-- ==========================================================
-- MAIN LOOP
-- ==========================================================
RunService.RenderStepped:Connect(function()
    -- ESP
    if Config.ESP.Enabled then
        for player, data in pairs(ESPData) do
            local ok = pcall(function()
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local head = char and char:FindFirstChild("Head")

                if player == LocalPlayer or not hum or hum.Health <= 0 or not root or (Config.ESP.TeamCheck and isTeammate(player)) then
                    data.box.Visible = false
                    data.name.Visible = false
                    data.health.Visible = false
                    data.dist.Visible = false
                    return
                end

                local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                local dist = (Camera.CFrame.Position - root.Position).Magnitude
                if not onScreen or rootPos.Z <= 0 or dist > Config.ESP.MaxDistance then
                    data.box.Visible = false
                    data.name.Visible = false
                    data.health.Visible = false
                    data.dist.Visible = false
                    return
                end

                local headPos = head and Camera:WorldToViewportPoint(head.Position) or rootPos
                local topY, bottomY = headPos.Y - 20, rootPos.Y + 25
                local height = math.abs(bottomY - topY)
                local width = height * 0.55

                if Config.ESP.Box then
                    data.box.Size = Vector2.new(width, height)
                    data.box.Position = Vector2.new(rootPos.X - width/2, topY)
                    data.box.Visible = true
                else
                    data.box.Visible = false
                end

                if Config.ESP.Name then
                    data.name.Text = player.Name
                    data.name.Position = Vector2.new(rootPos.X, topY - 16)
                    data.name.Visible = true
                else
                    data.name.Visible = false
                end

                if Config.ESP.Health then
                    data.health.Text = "❤ " .. math.floor(hum.Health)
                    data.health.Position = Vector2.new(rootPos.X, bottomY + 2)
                    data.health.Visible = true
                else
                    data.health.Visible = false
                end

                if Config.ESP.Distance then
                    data.dist.Text = "[" .. math.floor(dist) .. "m]"
                    data.dist.Position = Vector2.new(rootPos.X, topY - 30)
                    data.dist.Visible = true
                else
                    data.dist.Visible = false
                end
            end)
            if not ok then
                removeESP(player)
                task.delay(0.5, function() createESP(player) end)
            end
        end
    else
        for _, data in pairs(ESPData) do
            pcall(function()
                data.box.Visible = false
                data.name.Visible = false
                data.health.Visible = false
                data.dist.Visible = false
            end)
        end
    end

    -- FOV Circle
    if fovCircle then
        fovCircle.Radius = Config.Aimbot.FOV
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        fovCircle.Visible = Config.Aimbot.Enabled and Config.Aimbot.ShowFOV
    end

    -- AIMBOT
    if Config.Aimbot.Enabled then
        local shouldAim = false
        if Config.Aimbot.Mode == "Hold" then
            if typeof(Config.Aimbot.Key) == "EnumItem" then
                if Config.Aimbot.Key.EnumType == Enum.UserInputType then
                    shouldAim = UserInputService:IsMouseButtonPressed(Config.Aimbot.Key)
                else
                    shouldAim = UserInputService:IsKeyDown(Config.Aimbot.Key)
                end
            end
        else
            shouldAim = true
        end

        if shouldAim and LocalPlayer.Character then
            local mousePos = UserInputService:GetMouseLocation()
            local closest, shortest = nil, math.huge

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local char = p.Character
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 and not (Config.Aimbot.TeamCheck and isTeammate(p)) then
                        local part = getPart(char, Config.Aimbot.Part)
                        if part then
                            local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen and sp.Z > 0 then
                                local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                                if d < shortest and d < Config.Aimbot.FOV then
                                    shortest = d
                                    closest = part
                                end
                            end
                        end
                    end
                end
            end

            if closest then
                local camCF = Camera.CFrame
                Camera.CFrame = camCF:Lerp(CFrame.new(camCF.Position, closest.Position), math.clamp(Config.Aimbot.Smoothness, 0, 1))
            end
        end
    end
end)

-- ==========================================================
-- ПОВІДОМЛЕННЯ
-- ==========================================================
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "✨ Neo iOS",
        Text = "Тапни ✦ щоб відкрити меню",
        Duration = 5
    })
end)
