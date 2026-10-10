-- main.lua — твій чит
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🎯 My Cheat Menu",
    LoadingTitle = "Завантаження...",
    LoadingSubtitle = "by You",
    Theme = "Dark",
    KeySystem = false  -- ключ вже перевірено в loader
})

-- Сервіси
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============ ESP ============
local ESPEnabled = false
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "MyESP"

local function createESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end

    local highlight = Instance.new("Highlight", ESPFolder)
    highlight.Name = player.Name
    highlight.Adornee = char
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
end

local function removeESP(player)
    for _, v in pairs(ESPFolder:GetChildren()) do
        if v.Name == player.Name then
            v:Destroy()
        end
    end
end

local espConnection = Players.PlayerAdded:Connect(function(p)
    if ESPEnabled then
        p.CharacterAdded:Connect(function()
            task.wait(1)
            if ESPEnabled then createESP(p) end
        end)
    end
end)

-- Оновлення ESP
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not ESPFolder:FindFirstChild(p.Name) then
            createESP(p)
        end
    end
end)

-- ============ AIMBOT ============
local AimbotEnabled = false
local AimFOV = 150
local AimPart = "Head"
local Sensitivity = 0.15

local function getClosestPlayer()
    local closest = nil
    local shortest = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local part = p.Character:FindFirstChild(AimPart)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortest and dist < AimFOV then
                        shortest = dist
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end
    local target = getClosestPlayer()
    if target then
        local screenPos = Camera:WorldToViewportPoint(target.Position)
        local mousePos = UserInputService:GetMouseLocation()
        local delta = Vector2.new(screenPos.X, screenPos.Y) - mousePos
        mousemoverel(delta.X * Sensitivity, delta.Y * Sensitivity)
    end
end)

-- ============ GUI ============
local MainTab = Window:CreateTab("Головна", nil)
local MainSection = MainTab:CreateSection("Основне")

MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(v)
        AimbotEnabled = v
    end
})

MainTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 150,
    Flag = "AimFOV",
    Callback = function(v)
        AimFOV = v
    end
})

MainTab:CreateDropdown({
    Name = "Цільова частина",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = {"Head"},
    Flag = "AimPart",
    Callback = function(opt)
        AimPart = opt[1]
    end
})

MainTab:CreateSlider({
    Name = "Чутливість (менше = плавніше)",
    Range = {0.01, 1},
    Increment = 0.01,
    CurrentValue = 0.15,
    Flag = "Sensitivity",
    Callback = function(v)
        Sensitivity = v
    end
})

local ESPTab = Window:CreateTab("ESP", nil)
ESPTab:CreateToggle({
    Name = "ESP (підсвітка гравців)",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(v)
        ESPEnabled = v
        if v then
            for _, p in pairs(Players:GetPlayers()) do
                createESP(p)
            end
        else
            for _, v in pairs(ESPFolder:GetChildren()) do
                v:Destroy()
            end
        end
    end
})

Rayfield:Notify({
    Title = "✅ Чит завантажено",
    Content = "Меню відкрито. Приємної гри!",
    Duration = 5
})
