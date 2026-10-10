-- ============================================
-- Universal ESP + Aimbot for Solara
-- Працює: Laplace, будь-яка гра з Players
-- ============================================

local Players = game:GetService("Players")
local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Налаштування
local Config = {
    ESP = { Enabled = false, Box = true, Lines = true, Name = true, Health = true, Distance = true },
    Aimbot = { Enabled = false, FOV = 150, Part = "Head", Smoothness = 0.15, Key = Enum.UserInputType.MouseButton2 }
}

-- ============================================
-- МЕНЮ (своє, просте)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalMenu"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Головна рамка
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(60, 60, 70)

-- Заголовок (перетягування)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
Title.Text = "  🎯 Universal Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

-- Перетягування
local dragging, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
Title.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Скрол для контенту
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -45)
Scroll.Position = UDim2.new(0, 10, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function makeToggle(text, callback, default)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    btn.Text = "  " .. text .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = "  " .. text .. ": " .. (state and "ON" or "OFF")
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)
        callback(state)
    end)
end

local function makeSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -10, 0, 20); lbl.Position = UDim2.new(0, 5, 0, 5)
    lbl.BackgroundTransparency = 1; lbl.Text = text .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(1, -20, 0, 6); bar.Position = UDim2.new(0, 10, 0, 35)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 70); bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 150, 255); fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
            rel = math.clamp(rel, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            lbl.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- ============================================
-- ESP
-- ============================================
local ESPData = {}

local function createESP(player)
    if player == LocalPlayer or ESPData[player] then return end

    local box = Drawing.new("Square")
    box.Thickness = 1; box.Filled = false; box.Color = Color3.fromRGB(255, 0, 0); box.Visible = false; box.ZIndex = 1

    local outline = Drawing.new("Square")
    outline.Thickness = 3; outline.Filled = false; outline.Color = Color3.fromRGB(0, 0, 0); outline.Visible = false; outline.ZIndex = 1

    local name = Drawing.new("Text")
    name.Size = 14; name.Center = true; name.Outline = true; name.Color = Color3.fromRGB(255, 255, 255); name.Visible = false; name.ZIndex = 2

    local hpText = Drawing.new("Text")
    hpText.Size = 13; hpText.Center = true; hpText.Outline = true; hpText.Color = Color3.fromRGB(0, 255, 0); hpText.Visible = false; hpText.ZIndex = 2

    local lines = {}
    lines.tracer = Drawing.new("Line")
    lines.tracer.Thickness = 1; lines.tracer.Color = Color3.fromRGB(255, 0, 0); lines.tracer.Visible = false; lines.tracer.ZIndex = 1

    lines.healthBar = Drawing.new("Line")
    lines.healthBar.Thickness = 2; lines.healthBar.Color = Color3.fromRGB(0, 255, 0); lines.healthBar.Visible = false; lines.healthBar.ZIndex = 2

    lines.healthBg = Drawing.new("Line")
    lines.healthBg.Thickness = 2; lines.healthBg.Color = Color3.fromRGB(0, 0, 0); lines.healthBg.Visible = false; lines.healthBg.ZIndex = 1

    ESPData[player] = { box = box, outline = outline, name = name, hpText = hpText, lines = lines }
end

local function removeESP(player)
    local data = ESPData[player]
    if not data then return end
    for _, obj in pairs(data) do
        if typeof(obj) == "table" then
            for _, line in pairs(obj) do line:Remove() end
        else
            obj:Remove()
        end
    end
    ESPData[player] = nil
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end

-- ============================================
-- Aimbot
-- ============================================
local function getClosestTarget()
    local closest, shortest = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local part = p.Character:FindFirstChild(Config.Aimbot.Part)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortest and dist < Config.Aimbot.FOV then
                        shortest = dist
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

-- ============================================
-- Main Loop
-- ============================================
RunService.RenderStepped:Connect(function()
    -- ESP
    for player, data in pairs(ESPData) do
        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if not Config.ESP.Enabled or not humanoid or humanoid.Health <= 0 or not root or player == LocalPlayer then
            data.box.Visible = false; data.outline.Visible = false; data.name.Visible = false
            data.hpText.Visible = false; data.lines.tracer.Visible = false
            data.lines.healthBar.Visible = false; data.lines.healthBg.Visible = false
        else
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local size = char:GetExtentsSize()
            local topPos = Camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, size.Y/2, 0)).Position)
            local bottomPos = Camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, -size.Y/2, 0)).Position)

            if onScreen and topPos.Z > 0 then
                local height = math.abs(topPos.Y - bottomPos.Y)
                local width = height * 0.6

                -- Box
                if Config.ESP.Box then
                    data.outline.Size = Vector2.new(width, height)
                    data.outline.Position = Vector2.new(topPos.X - width/2, topPos.Y)
                    data.outline.Visible = true
                    data.box.Size = data.outline.Size
                    data.box.Position = data.outline.Position
                    data.box.Visible = true
                else
                    data.box.Visible = false; data.outline.Visible = false
                end

                -- Tracer (лінія від низу екрану до гравця)
                if Config.ESP.Lines then
                    data.lines.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    data.lines.tracer.To = Vector2.new(topPos.X, topPos.Y + height)
                    data.lines.tracer.Visible = true
                else
                    data.lines.tracer.Visible = false
                end

                -- Name
                if Config.ESP.Name then
                    data.name.Text = player.Name
                    data.name.Position = Vector2.new(topPos.X, topPos.Y - 18)
                    data.name.Visible = true
                else
                    data.name.Visible = false
                end

                -- Health
                if Config.ESP.Health then
                    local hp = math.floor(humanoid.Health)
                    local maxHp = math.floor(humanoid.MaxHealth)
                    data.hpText.Text = "❤ " .. hp .. "/" .. maxHp
                    data.hpText.Position = Vector2.new(topPos.X, topPos.Y + height + 2)
                    data.hpText.Visible = true

                    local barHeight = height * (hp / maxHp)
                    data.lines.healthBg.From = Vector2.new(topPos.X - width/2 - 5, topPos.Y)
                    data.lines.healthBg.To = Vector2.new(topPos.X - width/2 - 5, topPos.Y + height)
                    data.lines.healthBg.Visible = true

                    data.lines.healthBar.From = Vector2.new(topPos.X - width/2 - 5, topPos.Y + height - barHeight)
                    data.lines.healthBar.To = Vector2.new(topPos.X - width/2 - 5, topPos.Y + height)
                    data.lines.healthBar.Visible = true
                else
                    data.hpText.Visible = false
                    data.lines.healthBar.Visible = false; data.lines.healthBg.Visible = false
                end
            else
                data.box.Visible = false; data.outline.Visible = false
                data.name.Visible = false; data.hpText.Visible = false
                data.lines.tracer.Visible = false
                data.lines.healthBar.Visible = false; data.lines.healthBg.Visible = false
            end
        end
    end

    -- Aimbot (тільки коли затиснута права кнопка)
    if Config.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Config.Aimbot.Key) then
        local target = getClosestTarget()
        if target then
            local screenPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local delta = Vector2.new(screenPos.X, screenPos.Y) - mousePos
            mousemoverel(delta.X * Config.Aimbot.Smoothness, delta.Y * Config.Aimbot.Smoothness)
        end
    end
end)

-- ============================================
-- Меню контент
-- ============================================
makeToggle("ESP Enabled", function(v) Config.ESP.Enabled = v end, false)
makeToggle("Box", function(v) Config.ESP.Box = v end, true)
makeToggle("Lines", function(v) Config.ESP.Lines = v end, true)
makeToggle("Name", function(v) Config.ESP.Name = v end, true)
makeToggle("Health", function(v) Config.ESP.Health = v end, true)
makeToggle("Aimbot", function(v) Config.Aimbot.Enabled = v end, false)
makeSlider("Aimbot FOV", 50, 500, 150, function(v) Config.Aimbot.FOV = v end)
makeSlider("Aimbot Smoothness", 1, 100, 15, function(v) Config.Aimbot.Smoothness = v / 100 end)

-- Кнопка відкриття меню (права кнопка миші)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Toggle меню на клавішу K
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Повідомлення
game.StarterGui:SetCore("SendNotification", {
    Title = "✅ ESP Loaded",
    Text = "Press K to open menu",
    Duration = 5
})
