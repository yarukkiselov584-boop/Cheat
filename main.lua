-- ==========================================================
-- NEO MENU v8 — VISUAL EDITION
-- Themes + Corner Box + Rainbow FOV + Config Save + HUD
-- ==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ==========================================================
-- CONFIG
-- ==========================================================
local Config = {
    ESP = {
        Enabled=false, Box=true, BoxStyle="Full", -- Full / Corner / Gradient
        BoxColor=Color3.fromRGB(255,80,90), BoxThickness=1.5, CornerLength=8,
        Outline=true, OutlineColor=Color3.fromRGB(0,0,0), OutlineThickness=3,
        Lines=true, LineFrom="Bottom", LineColor=Color3.fromRGB(255,80,90), LineThickness=1.5,
        Name=true, NameColor=Color3.fromRGB(255,255,255),
        Health=true, HealthBar=true, Distance=true, DistanceColor=Color3.fromRGB(200,200,220),
        HeadDot=true, HeadDotColor=Color3.fromRGB(255,255,255),
        TeamCheck=true, TeamColor=Color3.fromRGB(80,200,255),
        MaxDistance=1000, TextSize=14,
        DeadMark=true, DeadColor=Color3.fromRGB(130,130,130),
        Gradient=true, -- градієнт по HP
    },
    Aimbot = {
        Enabled=false, Mode="Hold", Key=Enum.UserInputType.MouseButton2,
        FOV=150, ShowFOV=true, FOVColor=Color3.fromRGB(160,100,255), FOVFilled=false,
        FOVRainbow=false, FOVPulse=true, ShowTargetLine=true, TargetLineColor=Color3.fromRGB(255,100,100),
        Smoothness=0.35, Part="Head", TeamCheck=true, WallCheck=true,
        IgnoreDead=true, IgnoreKnocked=true,
        Prediction=false, PredictionAmount=0.15, MaxDistance=1000,
        Method="Camera",
    },
    AutoShoot = {
        Enabled=false, Delay=0.1, TeamCheck=true, WallCheck=true, MaxDistance=1000,
        OnlyWhenAimActive=false, Cooldown=0.15,
    },
    TriggerBot = {
        Enabled=false, Delay=0.05, TeamCheck=true, WallCheck=true, MaxDistance=1000,
    },
    AimOnShoot = {
        Enabled=false, Key=Enum.UserInputType.MouseButton1,
        TeamCheck=true, WallCheck=true, FOV=200, Part="Head",
    },
    Misc = {
        WalkSpeed=16, JumpPower=50, Fullbright=false, Noclip=false,
        PotatoMode=false, ExtremePotato=false,
        ShowFPS=true, ShowPing=true, ShowKills=true, ShowTimer=true, ShowWatermark=true,
    },
    UI = {
        Theme="Laplace", -- Laplace / Cyberpunk / Matrix / Frost / Gold
    },
    Minimap = { Enabled=true, Size=150, Scale=0.5, DotSize=6 }
}

local LocalTeam = LocalPlayer.Team
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() LocalTeam = LocalPlayer.Team end)

-- ==========================================================
-- ТЕМИ
-- ==========================================================
local Themes = {
    Laplace = {
        Bg1=Color3.fromRGB(10,12,28), Bg2=Color3.fromRGB(16,20,45), Bg3=Color3.fromRGB(22,28,60),
        Accent1=Color3.fromRGB(220,180,90), Accent2=Color3.fromRGB(130,90,220), Accent3=Color3.fromRGB(70,130,240),
        Text=Color3.fromRGB(230,230,245), TextDim=Color3.fromRGB(150,155,180),
        Red=Color3.fromRGB(255,80,90), Green=Color3.fromRGB(80,220,120),
    },
    Cyberpunk = {
        Bg1=Color3.fromRGB(15,5,25), Bg2=Color3.fromRGB(25,10,40), Bg3=Color3.fromRGB(35,15,55),
        Accent1=Color3.fromRGB(255,50,150), Accent2=Color3.fromRGB(0,255,255), Accent3=Color3.fromRGB(255,255,0),
        Text=Color3.fromRGB(255,240,255), TextDim=Color3.fromRGB(180,140,200),
        Red=Color3.fromRGB(255,50,80), Green=Color3.fromRGB(0,255,150),
    },
    Matrix = {
        Bg1=Color3.fromRGB(5,15,5), Bg2=Color3.fromRGB(10,25,10), Bg3=Color3.fromRGB(15,40,15),
        Accent1=Color3.fromRGB(0,255,80), Accent2=Color3.fromRGB(80,255,120), Accent3=Color3.fromRGB(150,255,150),
        Text=Color3.fromRGB(220,255,220), TextDim=Color3.fromRGB(120,180,120),
        Red=Color3.fromRGB(255,80,80), Green=Color3.fromRGB(0,255,100),
    },
    Frost = {
        Bg1=Color3.fromRGB(15,20,35), Bg2=Color3.fromRGB(20,30,55), Bg3=Color3.fromRGB(30,45,80),
        Accent1=Color3.fromRGB(120,200,255), Accent2=Color3.fromRGB(200,240,255), Accent3=Color3.fromRGB(80,150,220),
        Text=Color3.fromRGB(240,250,255), TextDim=Color3.fromRGB(150,180,210),
        Red=Color3.fromRGB(255,100,120), Green=Color3.fromRGB(120,255,180),
    },
    Gold = {
        Bg1=Color3.fromRGB(15,12,5), Bg2=Color3.fromRGB(25,20,10), Bg3=Color3.fromRGB(40,30,15),
        Accent1=Color3.fromRGB(255,215,0), Accent2=Color3.fromRGB(255,180,50), Accent3=Color3.fromRGB(200,150,30),
        Text=Color3.fromRGB(255,250,230), TextDim=Color3.fromRGB(180,160,120),
        Red=Color3.fromRGB(255,80,80), Green=Color3.fromRGB(180,255,120),
    },
}

local P = Themes[Config.UI.Theme]

local PALETTE = {
    Color3.fromRGB(255,80,90), Color3.fromRGB(255,140,60), Color3.fromRGB(255,220,80),
    Color3.fromRGB(120,255,120), Color3.fromRGB(80,255,200), Color3.fromRGB(80,200,255),
    Color3.fromRGB(120,120,255), Color3.fromRGB(180,100,255), Color3.fromRGB(255,100,220),
    Color3.fromRGB(255,255,255), Color3.fromRGB(150,150,150), Color3.fromRGB(0,0,0),
}

-- ==========================================================
-- GUI
-- ==========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeoMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local W, H = 660, 500

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, W, 0, H)
Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
Main.BackgroundColor3 = P.Bg1
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local bgGrad = Instance.new("UIGradient", Main)
bgGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, P.Bg2), ColorSequenceKeypoint.new(0.5, P.Bg1), ColorSequenceKeypoint.new(1, P.Bg2)})
bgGrad.Rotation = 135
local strokeOuter = Instance.new("UIStroke", Main)
strokeOuter.Color = P.Accent1; strokeOuter.Thickness = 1.5; strokeOuter.Transparency = 0.2

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = P.Bg3; Header.BackgroundTransparency = 0.2; Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
local headerFix = Instance.new("Frame", Header)
headerFix.Size = UDim2.new(1, 0, 0, 15); headerFix.Position = UDim2.new(0, 0, 1, -15)
headerFix.BackgroundColor3 = P.Bg3; headerFix.BackgroundTransparency = 0.2; headerFix.BorderSizePixel = 0
local headerGrad = Instance.new("UIGradient", Header)
headerGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, P.Accent2), ColorSequenceKeypoint.new(1, P.Accent3)})

local iconFrame = Instance.new("Frame", Header)
iconFrame.Size = UDim2.new(0, 34, 0, 34); iconFrame.Position = UDim2.new(0, 14, 0.5, -17)
iconFrame.BackgroundColor3 = P.Accent1; iconFrame.BorderSizePixel = 0
Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", iconFrame).Color = P.Accent1
local iconLbl = Instance.new("TextLabel", iconFrame)
iconLbl.Size = UDim2.new(1,0,1,0); iconLbl.BackgroundTransparency = 1
iconLbl.Text = "✦"; iconLbl.TextColor3 = P.Bg1; iconLbl.Font = Enum.Font.GothamBlack; iconLbl.TextSize = 20

-- Пульсація іконки
task.spawn(function()
    while true do
        task.wait(1)
        TweenService:Create(iconLbl, TweenInfo.new(0.5), {TextTransparency=0.5}):Play()
        task.wait(0.5)
        TweenService:Create(iconLbl, TweenInfo.new(0.5), {TextTransparency=0}):Play()
    end
end)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -120, 1, 0); Title.Position = UDim2.new(0, 58, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "NEO  MENU"
Title.TextColor3 = P.Accent1; Title.Font = Enum.Font.GothamBlack; Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel", Header)
Subtitle.Size = UDim2.new(1, -120, 0, 14); Subtitle.Position = UDim2.new(0, 59, 0, 32)
Subtitle.BackgroundTransparency = 1; Subtitle.Text = "v8  •  VISUAL EDITION"
Subtitle.TextColor3 = P.TextDim; Subtitle.Font = Enum.Font.Gotham; Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- HUD у хедері
local FpsLabel = Instance.new("TextLabel", Header)
FpsLabel.Size = UDim2.new(0, 60, 0, 14); FpsLabel.Position = UDim2.new(1, -230, 0, 8)
FpsLabel.BackgroundTransparency = 1; FpsLabel.Text = "FPS --"
FpsLabel.TextColor3 = P.Green; FpsLabel.Font = Enum.Font.GothamBold; FpsLabel.TextSize = 11
FpsLabel.TextXAlignment = Enum.TextXAlignment.Right

local PingLabel = Instance.new("TextLabel", Header)
PingLabel.Size = UDim2.new(0, 60, 0, 14); PingLabel.Position = UDim2.new(1, -230, 0, 26)
PingLabel.BackgroundTransparency = 1; PingLabel.Text = "Ping --"
PingLabel.TextColor3 = P.Accent3; PingLabel.Font = Enum.Font.GothamBold; PingLabel.TextSize = 11
PingLabel.TextXAlignment = Enum.TextXAlignment.Right

local KillLabel = Instance.new("TextLabel", Header)
KillLabel.Size = UDim2.new(0, 60, 0, 14); KillLabel.Position = UDim2.new(1, -165, 0, 8)
KillLabel.BackgroundTransparency = 1; KillLabel.Text = "☠ 0"
KillLabel.TextColor3 = P.Red; KillLabel.Font = Enum.Font.GothamBold; KillLabel.TextSize = 11
KillLabel.TextXAlignment = Enum.TextXAlignment.Right

local TimeLabel = Instance.new("TextLabel", Header)
TimeLabel.Size = UDim2.new(0, 60, 0, 14); TimeLabel.Position = UDim2.new(1, -165, 0, 26)
TimeLabel.BackgroundTransparency = 1; TimeLabel.Text = "⏱ 00:00"
TimeLabel.TextColor3 = P.Accent2; TimeLabel.Font = Enum.Font.GothamBold; TimeLabel.TextSize = 11
TimeLabel.TextXAlignment = Enum.TextXAlignment.Right

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -42, 0.5, -15)
CloseBtn.BackgroundColor3 = P.Bg1; CloseBtn.Text = "✕"
CloseBtn.TextColor3 = P.TextDim; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3=P.Red, TextColor3=P.Text}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3=P.Bg1, TextColor3=P.TextDim}):Play() end)
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.2), {Size=UDim2.new(0,0,0,0)}):Play()
    task.wait(0.2); Main.Visible = false; Main.Size = UDim2.new(0, W, 0, H)
end)

-- Watermark (окремо, у кутку)
local Watermark = Instance.new("TextLabel", ScreenGui)
Watermark.Size = UDim2.new(0, 140, 0, 24)
Watermark.Position = UDim2.new(0, 20, 0, 20)
Watermark.BackgroundColor3 = P.Bg1
Watermark.BackgroundTransparency = 0.3
Watermark.Text = "  ✦ NEO  v8"
Watermark.TextColor3 = P.Accent1
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 12
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.BorderSizePixel = 0
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", Watermark).Color = P.Accent1

-- Drag
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=input.Position; startPos=Main.Position
    end
end)
Header.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
end)
Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 60, 1, -70); Sidebar.Position = UDim2.new(0, 10, 0, 60)
Sidebar.BackgroundColor3 = P.Bg3; Sidebar.BackgroundTransparency = 0.4; Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)
local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 6); SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 8)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -90, 1, -70); Content.Position = UDim2.new(0, 80, 0, 60)
Content.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0
    page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = P.Accent2
    page.Visible = false; page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 5); pad.PaddingLeft = UDim.new(0, 5); pad.PaddingRight = UDim.new(0, 5)
    pages[name] = page
end

local sideButtons = {}
local function createSideButton(icon, name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0, 44, 0, 44); btn.BackgroundColor3 = P.Bg1
    btn.Text = icon; btn.TextColor3 = P.TextDim; btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20; btn.BorderSizePixel = 0; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = P.Accent2; stroke.Thickness = 0
    btn.MouseEnter:Connect(function()
        if pages[name].Visible then return end
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3=P.Bg2, TextColor3=P.Accent2}):Play()
        TweenService:Create(btn, TweenInfo.new(0.15), {Rotation=5}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if pages[name].Visible then return end
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3=P.Bg1, TextColor3=P.TextDim}):Play()
        TweenService:Create(btn, TweenInfo.new(0.15), {Rotation=0}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        for n, page in pairs(pages) do page.Visible = (n == name) end
        for _, b in ipairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                local s = b:FindFirstChildOfClass("UIStroke")
                if b == btn then
                    TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3=P.Accent2, TextColor3=P.Accent1}):Play()
                    if s then TweenService:Create(s, TweenInfo.new(0.2), {Thickness=2, Transparency=0}):Play() end
                else
                    TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3=P.Bg1, TextColor3=P.TextDim}):Play()
                    if s then TweenService:Create(s, TweenInfo.new(0.2), {Thickness=0}):Play() end
                end
            end
        end
    end)
    sideButtons[name] = btn
end

local tabs = {
    { icon="⚙", name="Головна" },
    { icon="◉", name="ESP" },
    { icon="✛", name="Аім" },
    { icon="✹", name="Авто" },
    { icon="◈", name="Карта" },
    { icon="✦", name="Різне" },
}
for _, t in ipairs(tabs) do createPage(t.name) end
for _, t in ipairs(tabs) do createSideButton(t.icon, t.name) end
pages["Головна"].Visible = true
sideButtons["Головна"].BackgroundColor3 = P.Accent2
sideButtons["Головна"].TextColor3 = P.Accent1
sideButtons["Головна"]:FindFirstChildOfClass("UIStroke").Thickness = 2

-- ==========================================================
-- ЕЛЕМЕНТИ
-- ==========================================================
local function makeToggle(page, text, default, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, 0, 0, 36); btn.BackgroundColor3 = P.Bg3
    btn.BackgroundTransparency = 0.3; btn.Text = ""; btn.BorderSizePixel = 0; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local grad = Instance.new("UIGradient", btn)
    grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, P.Bg2), ColorSequenceKeypoint.new(1, P.Bg1)})
    grad.Rotation = 90
    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, -70, 1, 0); label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = P.Text
    label.Font = Enum.Font.Gotham; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 44, 0, 22); indicator.Position = UDim2.new(1, -54, 0.5, -11)
    indicator.BackgroundColor3 = default and P.Accent2 or Color3.fromRGB(40,42,60)
    indicator.BorderSizePixel = 0
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", indicator)
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = default and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    dot.BackgroundColor3 = default and P.Accent1 or P.TextDim
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = state and P.Accent2 or Color3.fromRGB(40,42,60)}):Play()
        TweenService:Create(dot, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
            BackgroundColor3 = state and P.Accent1 or P.TextDim
        }):Play()
        callback(state)
    end)
end

local function makeSlider(page, text, min, max, default, callback)
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(1, 0, 0, 52); frame.BackgroundColor3 = P.Bg3
    frame.BackgroundTransparency = 0.3; frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local grad = Instance.new("UIGradient", frame)
    grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, P.Bg2), ColorSequenceKeypoint.new(1, P.Bg1)})
    grad.Rotation = 90
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 0, 20); label.Position = UDim2.new(0, 14, 0, 6)
    label.BackgroundTransparency = 1; label.Text = text .. ":  " .. default
    label.TextColor3 = P.Text; label.Font = Enum.Font.Gotham; label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    local barBg = Instance.new("Frame", frame)
    barBg.Size = UDim2.new(1, -28, 0, 5); barBg.Position = UDim2.new(0, 14, 0, 38)
    barBg.BackgroundColor3 = Color3.fromRGB(35,38,55); barBg.BorderSizePixel = 0
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", barBg)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = P.Accent2; fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, P.Accent3), ColorSequenceKeypoint.new(1, P.Accent2)})
    local drag = false
    barBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            label.Text = text .. ":  " .. val
            callback(val)
        end
    end)
end

local function makeDropdown(page, text, options, default, callback)
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(1, 0, 0, 62); frame.BackgroundColor3 = P.Bg3
    frame.BackgroundTransparency = 0.3; frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local grad = Instance.new("UIGradient", frame)
    grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, P.Bg2), ColorSequenceKeypoint.new(1, P.Bg1)})
    grad.Rotation = 90
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 0, 18); label.Position = UDim2.new(0, 14, 0, 6)
    label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = P.TextDim
    label.Font = Enum.Font.Gotham; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left
    local currentBtn = Instance.new("TextButton", frame)
    currentBtn.Size = UDim2.new(1, -28, 0, 26); currentBtn.Position = UDim2.new(0, 14, 0, 28)
    currentBtn.BackgroundColor3 = P.Bg1; currentBtn.Text = "  " .. default .. "  ▾"
    currentBtn.TextColor3 = P.Accent1; currentBtn.Font = Enum.Font.GothamSemibold; currentBtn.TextSize = 12
    currentBtn.BorderSizePixel = 0
    Instance.new("UICorner", currentBtn).CornerRadius = UDim.new(0, 6)
    local isOpen, listHolder = false, nil
    local function closeList() if listHolder then listHolder:Destroy() listHolder = nil end isOpen = false end
    currentBtn.MouseButton1Click:Connect(function()
        if isOpen then closeList() return end
        isOpen = true
        listHolder = Instance.new("Frame", ScreenGui)
        listHolder.Position = UDim2.new(0, currentBtn.AbsolutePosition.X, 0, currentBtn.AbsolutePosition.Y + 28)
        listHolder.Size = UDim2.new(0, currentBtn.AbsoluteSize.X, 0, #options * 26)
        listHolder.BackgroundColor3 = P.Bg1; listHolder.BorderSizePixel = 0; listHolder.ZIndex = 50
        Instance.new("UICorner", listHolder).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", listHolder).Color = P.Accent2
        for i, opt in ipairs(options) do
            local o = Instance.new("TextButton", listHolder)
            o.Size = UDim2.new(1, 0, 0, 26); o.Position = UDim2.new(0, 0, 0, (i-1)*26)
            o.BackgroundColor3 = P.Bg1; o.Text = opt; o.TextColor3 = P.Text
            o.Font = Enum.Font.Gotham; o.TextSize = 12; o.BorderSizePixel = 0
            o.ZIndex = 51; o.AutoButtonColor = false
            o.MouseEnter:Connect(function() TweenService:Create(o, TweenInfo.new(0.1), {BackgroundColor3=P.Accent2, TextColor3=P.Accent1}):Play() end)
            o.MouseLeave:Connect(function() TweenService:Create(o, TweenInfo.new(0.1), {BackgroundColor3=P.Bg1, TextColor3=P.Text}):Play() end)
            o.MouseButton1Click:Connect(function()
                currentBtn.Text = "  " .. opt .. "  ▾"
                closeList()
                callback(opt)
            end)
        end
    end)
end

local function makeSection(page, text)
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(1, 0, 0, 26); frame.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -20, 1, 0); lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = "◆  " .. string.upper(text)
    lbl.TextColor3 = P.Accent1; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local line = Instance.new("Frame", frame)
    line.Size = UDim2.new(1, -80, 0, 1); line.Position = UDim2.new(0, 80, 0.5, 0)
    line.BackgroundColor3 = P.Accent2; line.BackgroundTransparency = 0.5; line.BorderSizePixel = 0
end

local function makeColor(page, text, default, callback)
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(1, 0, 0, 36); frame.BackgroundColor3 = P.Bg3
    frame.BackgroundTransparency = 0.3; frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local grad = Instance.new("UIGradient", frame)
    grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, P.Bg2), ColorSequenceKeypoint.new(1, P.Bg1)})
    grad.Rotation = 90
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -70, 1, 0); label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = P.Text
    label.Font = Enum.Font.Gotham; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left
    local swatch = Instance.new("TextButton", frame)
    swatch.Size = UDim2.new(0, 44, 0, 22); swatch.Position = UDim2.new(1, -54, 0.5, -11)
    swatch.BackgroundColor3 = default; swatch.Text = ""; swatch.BorderSizePixel = 0
    swatch.AutoButtonColor = false
    Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", swatch).Color = P.Accent1
    local idx = 1
    for i, c in ipairs(PALETTE) do if c == default then idx = i break end end
    swatch.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #PALETTE then idx = 1 end
        swatch.BackgroundColor3 = PALETTE[idx]
        callback(PALETTE[idx])
    end)
end

-- ==========================================================
-- CONFIG SAVE/LOAD
-- ==========================================================
local function serializeConfig()
    local str = "{"
    local function ser(v)
        if type(v) == "number" then return tostring(v)
        elseif type(v) == "boolean" then return tostring(v)
        elseif type(v) == "string" then return '"'..v..'"'
        elseif type(v) == "table" and typeof(v) == "Color3" then
            return string.format("Color3.new(%f,%f,%f)", v.R, v.G, v.B)
        elseif type(v) == "table" then
            local t = "{"
            for k, vv in pairs(v) do
                t = t .. "[" .. ser(k) .. "]=" .. ser(vv) .. ","
            end
            return t .. "}"
        end
        return "nil"
    end
    return ser(Config)
end

local function saveConfig()
    local ok = pcall(function()
        if writefile then
            writefile("neo_config.txt", serializeConfig())
        end
    end)
    if ok then
        game.StarterGui:SetCore("SendNotification", {Title="💾 Збережено", Text="Конфіг збережено", Duration=3})
    else
        game.StarterGui:SetCore("SendNotification", {Title="❌ Помилка", Text="Не вдалось зберегти", Duration=3})
    end
end

-- ==========================================================
-- НАПОВНЕННЯ
-- ==========================================================
local pMain, pESP, pAim, pAuto, pMap, pMisc = pages["Головна"], pages["ESP"], pages["Аім"], pages["Авто"], pages["Карта"], pages["Різне"]

makeSection(pMain, "Загальне")
makeToggle(pMain, "Увімкнути ESP", false, function(v) Config.ESP.Enabled = v end)
makeToggle(pMain, "Увімкнути Аімбот", false, function(v) Config.Aimbot.Enabled = v end)
makeToggle(pMain, "Увімкнути Auto-Shoot", false, function(v) Config.AutoShoot.Enabled = v end)
makeToggle(pMain, "Увімкнути Trigger-Bot", false, function(v) Config.TriggerBot.Enabled = v end)
makeToggle(pMain, "Увімкнути Aim on Shoot", false, function(v) Config.AimOnShoot.Enabled = v end)
makeToggle(pMain, "Увімкнути Міні-карту", true, function(v) Config.Minimap.Enabled = v end)
makeSection(pMain, "Конфіг")
local saveBtn = Instance.new("TextButton", pMain)
saveBtn.Size = UDim2.new(1, 0, 0, 36); saveBtn.BackgroundColor3 = P.Accent2
saveBtn.Text = "💾 Зберегти налаштування"; saveBtn.TextColor3 = P.Bg1
saveBtn.Font = Enum.Font.GothamBold; saveBtn.TextSize = 13; saveBtn.BorderSizePixel = 0
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
saveBtn.MouseButton1Click:Connect(saveConfig)

makeSection(pESP, "Стиль боксу")
makeDropdown(pESP, "Стиль", {"Full", "Corner", "Gradient"}, "Full", function(v) Config.ESP.BoxStyle = v end)
makeToggle(pESP, "Градієнт по HP", true, function(v) Config.ESP.Gradient = v end)
makeSlider(pESP, "Довжина кутів", 4, 20, 8, function(v) Config.ESP.CornerLength = v end)
makeSection(pESP, "Елементи")
makeToggle(pESP, "Бокс", true, function(v) Config.ESP.Box = v end)
makeToggle(pESP, "Обводка", true, function(v) Config.ESP.Outline = v end)
makeToggle(pESP, "Лінії", true, function(v) Config.ESP.Lines = v end)
makeToggle(pESP, "Ім'я", true, function(v) Config.ESP.Name = v end)
makeToggle(pESP, "Здоров'я", true, function(v) Config.ESP.Health = v end)
makeToggle(pESP, "Смуга HP", true, function(v) Config.ESP.HealthBar = v end)
makeToggle(pESP, "Дистанція", true, function(v) Config.ESP.Distance = v end)
makeToggle(pESP, "Крапка на голові", true, function(v) Config.ESP.HeadDot = v end)
makeToggle(pESP, "Перевірка команди", true, function(v) Config.ESP.TeamCheck = v end)
makeToggle(pESP, "Позначати мертвих", true, function(v) Config.ESP.DeadMark = v end)
makeSection(pESP, "Розміри")
makeSlider(pESP, "Товщина боксу", 1, 5, 2, function(v) Config.ESP.BoxThickness = v end)
makeSlider(pESP, "Товщина ліній", 1, 5, 2, function(v) Config.ESP.LineThickness = v end)
makeSlider(pESP, "Розмір тексту", 10, 24, 14, function(v) Config.ESP.TextSize = v end)
makeSlider(pESP, "Макс. дистанція", 100, 5000, 1000, function(v) Config.ESP.MaxDistance = v end)
makeSection(pESP, "Кольори")
makeColor(pESP, "Колір ворога", Color3.fromRGB(255,80,90), function(c) Config.ESP.BoxColor = c; Config.ESP.LineColor = c end)
makeColor(pESP, "Колір союзника", Color3.fromRGB(80,200,255), function(c) Config.ESP.TeamColor = c end)
makeColor(pESP, "Колір мертвого", Color3.fromRGB(130,130,130), function(c) Config.ESP.DeadColor = c end)

makeSection(pAim, "Загальне")
makeToggle(pAim, "Аімбот", false, function(v) Config.Aimbot.Enabled = v end)
makeToggle(pAim, "Показувати FOV", true, function(v) Config.Aimbot.ShowFOV = v end)
makeToggle(pAim, "FOV Rainbow", false, function(v) Config.Aimbot.FOVRainbow = v end)
makeToggle(pAim, "FOV Пульсація", true, function(v) Config.Aimbot.FOVPulse = v end)
makeToggle(pAim, "Лінія до цілі", true, function(v) Config.Aimbot.ShowTargetLine = v end)
makeDropdown(pAim, "Режим", {"Hold","Always","Toggle"}, "Hold", function(v) Config.Aimbot.Mode = v end)
makeDropdown(pAim, "Клавіша", {"MouseButton2","E","Q","CapsLock","LeftAlt"}, "MouseButton2", function(v)
    Config.Aimbot.Key = Enum.UserInputType[v] or Enum.KeyCode[v] or Enum.UserInputType.MouseButton2
end)
makeDropdown(pAim, "Метод", {"Camera","Mouse"}, "Camera", function(v) Config.Aimbot.Method = v end)
makeSection(pAim, "Точність")
makeSlider(pAim, "FOV", 20, 600, 150, function(v) Config.Aimbot.FOV = v end)
makeSlider(pAim, "Плавність (%)", 5, 100, 35, function(v) Config.Aimbot.Smoothness = v / 100 end)
makeSlider(pAim, "Макс. дистанція", 100, 5000, 1000, function(v) Config.Aimbot.MaxDistance = v end)
makeDropdown(pAim, "Частина тіла", {"Head","Torso","UpperTorso","HumanoidRootPart","Nearest","Random"}, "Head", function(v) Config.Aimbot.Part = v end)
makeSection(pAim, "Фільтри")
makeToggle(pAim, "Ігнорувати мертвих", true, function(v) Config.Aimbot.IgnoreDead = v end)
makeToggle(pAim, "Ігнорувати лежачих", true, function(v) Config.Aimbot.IgnoreKnocked = v end)
makeToggle(pAim, "Перевірка команди", true, function(v) Config.Aimbot.TeamCheck = v end)
makeToggle(pAim, "Перевірка стін", true, function(v) Config.Aimbot.WallCheck = v end)
makeToggle(pAim, "Prediction", false, function(v) Config.Aimbot.Prediction = v end)
makeSlider(pAim, "Prediction сила", 0, 50, 15, function(v) Config.Aimbot.PredictionAmount = v / 100 end)

makeSection(pAuto, "Auto-Shoot")
makeToggle(pAuto, "Увімкнути Auto-Shoot", false, function(v) Config.AutoShoot.Enabled = v end)
makeToggle(pAuto, "Тільки коли Аім активний", false, function(v) Config.AutoShoot.OnlyWhenAimActive = v end)
makeToggle(pAuto, "Перевірка команди", true, function(v) Config.AutoShoot.TeamCheck = v end)
makeToggle(pAuto, "Перевірка стін", true, function(v) Config.AutoShoot.WallCheck = v end)
makeSlider(pAuto, "Затримка (мс×10)", 1, 50, 10, function(v) Config.AutoShoot.Delay = v / 100 end)
makeSlider(pAuto, "Кулдаун (мс×10)", 1, 50, 15, function(v) Config.AutoShoot.Cooldown = v / 100 end)
makeSlider(pAuto, "Макс. дистанція", 100, 5000, 1000, function(v) Config.AutoShoot.MaxDistance = v end)
makeSection(pAuto, "Trigger-Bot")
makeToggle(pAuto, "Увімкнути Trigger-Bot", false, function(v) Config.TriggerBot.Enabled = v end)
makeToggle(pAuto, "Перевірка команди (TB)", true, function(v) Config.TriggerBot.TeamCheck = v end)
makeToggle(pAuto, "Перевірка стін (TB)", true, function(v) Config.TriggerBot.WallCheck = v end)
makeSlider(pAuto, "Затримка (мс×10)", 1, 30, 5, function(v) Config.TriggerBot.Delay = v / 100 end)
makeSlider(pAuto, "Макс. дистанція (TB)", 100, 5000, 1000, function(v) Config.TriggerBot.MaxDistance = v end)
makeSection(pAuto, "Aim on Shoot")
makeToggle(pAuto, "Увімкнути Aim on Shoot", false, function(v) Config.AimOnShoot.Enabled = v end)
makeToggle(pAuto, "Перевірка команди (AoS)", true, function(v) Config.AimOnShoot.TeamCheck = v end)
makeToggle(pAuto, "Перевірка стін (AoS)", true, function(v) Config.AimOnShoot.WallCheck = v end)
makeDropdown(pAuto, "Клавіша пострілу", {"MouseButton1","E","Q","Space"}, "MouseButton1", function(v)
    Config.AimOnShoot.Key = Enum.UserInputType[v] or Enum.KeyCode[v] or Enum.UserInputType.MouseButton1
end)
makeSlider(pAuto, "FOV (AoS)", 20, 600, 200, function(v) Config.AimOnShoot.FOV = v end)

makeSection(pMap, "Міні-карта")
makeToggle(pMap, "Увімкнути", true, function(v) Config.Minimap.Enabled = v end)
makeSlider(pMap, "Розмір", 100, 400, 150, function(v)
    Config.Minimap.Size = v
    if MinimapFrame then MinimapFrame.Size = UDim2.new(0, v, 0, v) end
end)
makeSlider(pMap, "Масштаб", 10, 300, 50, function(v) Config.Minimap.Scale = v / 100 end)
makeSlider(pMap, "Розмір точки", 3, 12, 6, function(v) Config.Minimap.DotSize = v end)

makeSection(pMisc, "Тема меню")
makeDropdown(pMisc, "Тема", {"Laplace","Cyberpunk","Matrix","Frost","Gold"}, "Laplace", function(v)
    Config.UI.Theme = v
    game.StarterGui:SetCore("SendNotification", {Title="🎨 Тема", Text="Перезавантаж скрипт для зміни теми", Duration=5})
end)
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
makeSection(pMisc, "Світ")
makeToggle(pMisc, "Fullbright", false, function(v)
    Config.Misc.Fullbright = v
    if v then
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        Lighting.Brightness = 1
    end
end)
makeToggle(pMisc, "Noclip", false, function(v) Config.Misc.Noclip = v end)
makeSection(pMisc, "HUD")
makeToggle(pMisc, "Показувати FPS", true, function(v) Config.Misc.ShowFPS = v; FpsLabel.Visible = v end)
makeToggle(pMisc, "Показувати Ping", true, function(v) Config.Misc.ShowPing = v; PingLabel.Visible = v end)
makeToggle(pMisc, "Показувати Kills", true, function(v) Config.Misc.ShowKills = v; KillLabel.Visible = v end)
makeToggle(pMisc, "Показувати Таймер", true, function(v) Config.Misc.ShowTimer = v; TimeLabel.Visible = v end)
makeToggle(pMisc, "Watermark", true, function(v) Config.Misc.ShowWatermark = v; Watermark.Visible = v end)

-- ==========================================================
-- POTATO
-- ==========================================================
local function enablePotatoMode()
    pcall(function()
        Lighting.GlobalShadows = false; Lighting.Brightness = 0.5
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then v.Enabled = false end
        end
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            Terrain.WaterWaveSize = 0; Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0; Terrain.WaterTransparency = 1
        end
        task.spawn(function()
            local n = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire")
                    or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Beam") then
                    obj.Enabled = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                elseif obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0; obj.CastShadow = false
                end
                n += 1
                if n % 200 == 0 then task.wait() end
            end
        end)
        if setfpscap then pcall(function() setfpscap(60) end) end
    end)
end

local function enableExtremePotato()
    pcall(function()
        if setfflag then
            pcall(function() setfflag("FIntDebugForceMSAASamples", "0") end)
            pcall(function() setfflag("FIntFRMMinGrassDistance", "0") end)
            pcall(function() setfflag("FIntFRMMaxGrassDistance", "0") end)
            pcall(function() setfflag("FIntRenderGrassDetailStrands", "0") end)
            pcall(function() setfflag("FIntRenderShadowIntensity", "0") end)
            pcall(function() setfflag("FIntRenderLocalLightUpdatesMax", "1") end)
            pcall(function() setfflag("FIntRenderLocalLightUpdatesMin", "1") end)
            pcall(function() setfflag("FFlagDebugSkyGray", "true") end)
            pcall(function() setfflag("DFIntTaskSchedulerTargetFps", "60") end)
            pcall(function() setfflag("FFlagDisablePostFx", "true") end)
        end
        pcall(function() workspace.PhysicsSteppingMethod = Enum.PhysicsSteppingMethod.Adaptive end)
        pcall(function()
            for _, s in ipairs(game:GetService("SoundService"):GetDescendants()) do
                if s:IsA("Sound") then s.Volume = 0; if s.IsPlaying then s:Stop() end end
            end
        end)
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then
                    for _, obj in ipairs(p.Character:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            obj.CastShadow = false; obj.Material = Enum.Material.SmoothPlastic; obj.Reflectance = 0
                        end
                    end
                end
            end
        end)
    end)
end

makeSection(pMisc, "Продуктивність")
makeToggle(pMisc, "🥔 Картопляний режим", false, function(v)
    Config.Misc.PotatoMode = v
    if v then enablePotatoMode() end
end)
makeToggle(pMisc, "🥔🔥 Екстрим режим", false, function(v)
    Config.Misc.ExtremePotato = v
    if v then enableExtremePotato() end
end)

-- ==========================================================
-- ESP DRAWING
-- ==========================================================
local ESPData = {}
local hasDrawing = pcall(function() return Drawing.new("Line") end)

local function removeESP(player)
    local d = ESPData[player]
    if not d then return end
    for _, obj in pairs(d) do
        pcall(function()
            if type(obj) == "table" then
                for _, sub in pairs(obj) do
                    if sub and sub.Remove then sub:Remove() end
                end
            elseif obj and obj.Remove then obj:Remove() end
        end)
    end
    ESPData[player] = nil
end

local function createESP(player)
    if player == LocalPlayer or not hasDrawing then return end
    if ESPData[player] then removeESP(player) end
    local ok, d = pcall(function()
        local t = {}
        t.box = Drawing.new("Square")
        t.box.Thickness = Config.ESP.BoxThickness; t.box.Filled = false
        t.box.Color = Config.ESP.BoxColor; t.box.Visible = false; t.box.ZIndex = 2

        t.outline = Drawing.new("Square")
        t.outline.Thickness = Config.ESP.OutlineThickness; t.outline.Filled = false
        t.outline.Color = Config.ESP.OutlineColor; t.outline.Visible = false; t.outline.ZIndex = 1

        -- Corner box (4 кути)
        t.corners = {}
        for i = 1, 8 do
            t.corners[i] = Drawing.new("Line")
            t.corners[i].Thickness = Config.ESP.BoxThickness
            t.corners[i].Color = Config.ESP.BoxColor
            t.corners[i].Visible = false
            t.corners[i].ZIndex = 2
        end

        t.name = Drawing.new("Text"); t.name.Size = Config.ESP.TextSize; t.name.Center = true; t.name.Outline = true; t.name.Color = Config.ESP.NameColor; t.name.Visible = false; t.name.ZIndex = 3
        t.hpText = Drawing.new("Text"); t.hpText.Size = Config.ESP.TextSize - 1; t.hpText.Center = true; t.hpText.Outline = true; t.hpText.Color = Color3.fromRGB(80,255,120); t.hpText.Visible = false; t.hpText.ZIndex = 3
        t.distText = Drawing.new("Text"); t.distText.Size = Config.ESP.TextSize - 2; t.distText.Center = true; t.distText.Outline = true; t.distText.Color = Config.ESP.DistanceColor; t.distText.Visible = false; t.distText.ZIndex = 3
        t.tracer = Drawing.new("Line"); t.tracer.Thickness = Config.ESP.LineThickness; t.tracer.Color = Config.ESP.LineColor; t.tracer.Visible = false; t.tracer.ZIndex = 2
        t.hpBarBg = Drawing.new("Line"); t.hpBarBg.Thickness = 2; t.hpBarBg.Color = Color3.new(0,0,0); t.hpBarBg.Visible = false; t.hpBarBg.ZIndex = 2
        t.hpBar = Drawing.new("Line"); t.hpBar.Thickness = 2; t.hpBar.Color = Color3.fromRGB(80,255,120); t.hpBar.Visible = false; t.hpBar.ZIndex = 3
        t.headDot = Drawing.new("Circle"); t.headDot.Radius = 3; t.headDot.Filled = true; t.headDot.Color = Config.ESP.HeadDotColor; t.headDot.Visible = false; t.headDot.ZIndex = 3
        return t
    end)
    if ok and d then ESPData[player] = d end
end

local function hookCharacter(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.3)
        if ESPData[player] then removeESP(player) end
        createESP(player)
    end)
    player.CharacterRemoving:Connect(function()
        if ESPData[player] then removeESP(player) end
    end)
end

Players.PlayerAdded:Connect(function(p) hookCharacter(p); task.wait(0.5); createESP(p) end)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then hookCharacter(p); createESP(p) end
end

local fovCircle, targetLine
if hasDrawing then
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1.5; fovCircle.NumSides = 64; fovCircle.Filled = false
    fovCircle.Color = Config.Aimbot.FOVColor; fovCircle.Visible = false; fovCircle.ZIndex = 1

    targetLine = Drawing.new("Line")
    targetLine.Thickness = 1.5; targetLine.Color = Config.Aimbot.TargetLineColor
    targetLine.Visible = false; targetLine.ZIndex = 2
end

-- ==========================================================
-- HELPERS
-- ==========================================================
local function isTeammate(player)
    if not LocalTeam or not player.Team then return false end
    return player.Team == LocalTeam
end

local function getPart(char, partName)
    if not char then return nil end
    if partName == "Nearest" or partName == "Random" then
        local parts = {"Head","UpperTorso","Torso","HumanoidRootPart"}
        if partName == "Random" then return char:FindFirstChild(parts[math.random(1, #parts)]) end
        for _, n in ipairs(parts) do local p = char:FindFirstChild(n); if p then return p end end
    end
    local p = char:FindFirstChild(partName)
    if not p then
        for _, n in ipairs({"Head","UpperTorso","Torso","HumanoidRootPart"}) do
            p = char:FindFirstChild(n)
            if p then return p end
        end
    end
    return p
end

local function isVisible(part)
    local origin = Camera.CFrame.Position
    local dir = (part.Position - origin).Unit * (part.Position - origin).Magnitude
    local ray = Ray.new(origin, dir)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, part.Parent}, false, true)
    return hit == nil or hit:IsDescendantOf(part.Parent)
end

local function getHealthColor(hp, maxHp)
    local ratio = hp / math.max(maxHp, 1)
    if ratio > 0.6 then return Color3.fromRGB(80,255,120)
    elseif ratio > 0.3 then return Color3.fromRGB(255,200,80)
    else return Color3.fromRGB(255,80,100) end
end

local function findTarget(fov, partName, teamCheck, wallCheck, maxDist)
    local mousePos = UserInputService:GetMouseLocation()
    local closest, shortest = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local skip = false
                if teamCheck and isTeammate(p) then skip = true end
                if not skip then
                    local part = getPart(char, partName)
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    local dist3d = rootPart and (Camera.CFrame.Position - rootPart.Position).Magnitude or math.huge
                    if part and dist3d <= maxDist then
                        if not wallCheck or isVisible(part) then
                            local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen and sp.Z > 0 then
                                local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                                if d < shortest and d < fov then
                                    shortest = d
                                    closest = {part = part, char = char, player = p}
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function targetUnderCrosshair(teamCheck, wallCheck, maxDist)
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local skip = false
                if teamCheck and isTeammate(p) then skip = true end
                if not skip then
                    local part = getPart(char, "Head") or getPart(char, "Torso")
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    local dist3d = rootPart and (Camera.CFrame.Position - rootPart.Position).Magnitude or math.huge
                    if part and dist3d <= maxDist then
                        local sp, onScreen = Camera.WorldToViewportPoint(Camera, part.Position)
                        if onScreen and sp.Z > 0 then
                            local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if d < 30 then
                                if not wallCheck or isVisible(part) then
                                    return {part = part, char = char, player = p}
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- ==========================================================
-- MAIN LOOP
-- ==========================================================
local autoShootLast, triggerLast = 0, 0
local fpsClock, fpsCount = 0, 0
local sessionStart = tick()
local kills = 0
local hue = 0

RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.5) % 1

    -- FPS/Ping
    fpsCount = fpsCount + 1; fpsClock = fpsClock + dt
    if fpsClock >= 0.5 then
        if Config.Misc.ShowFPS then FpsLabel.Text = "FPS " .. math.floor(fpsCount / fpsClock) end
        if Config.Misc.ShowPing then
            local ok, ping = pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            PingLabel.Text = "Ping " .. (ok and ping or "--")
        end
        fpsCount = 0; fpsClock = 0
    end

    -- Timer
    if Config.Misc.ShowTimer then
        local elapsed = math.floor(tick() - sessionStart)
        local m = math.floor(elapsed / 60)
        local s = elapsed % 60
        TimeLabel.Text = string.format("⏱ %02d:%02d", m, s)
    end

    -- ESP
    if Config.ESP.Enabled and hasDrawing then
        for player, data in pairs(ESPData) do
            local ok = pcall(function()
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local head = char and char:FindFirstChild("Head")
                local hide = false
                if player == LocalPlayer then hide = true end
                if not hum or not root then hide = true end
                if hum and hum.Health <= 0 and not Config.ESP.DeadMark then hide = true end
                if Config.ESP.TeamCheck and isTeammate(player) then hide = true end

                if hide then
                    data.box.Visible=false; data.outline.Visible=false
                    data.name.Visible=false; data.hpText.Visible=false
                    data.distText.Visible=false; data.tracer.Visible=false
                    data.hpBarBg.Visible=false; data.hpBar.Visible=false
                    data.headDot.Visible=false
                    for _, c in ipairs(data.corners) do c.Visible = false end
                    return
                end

                local rootPos, rootOnScreen = Camera:WorldToViewportPoint(root.Position)
                local dist = (Camera.CFrame.Position - root.Position).Magnitude
                if not rootOnScreen or rootPos.Z <= 0 or dist > Config.ESP.MaxDistance then
                    data.box.Visible=false; data.outline.Visible=false
                    data.name.Visible=false; data.hpText.Visible=false
                    data.distText.Visible=false; data.tracer.Visible=false
                    data.hpBarBg.Visible=false; data.hpBar.Visible=false
                    data.headDot.Visible=false
                    for _, c in ipairs(data.corners) do c.Visible = false end
                    return
                end

                local headPos = head and Camera:WorldToViewportPoint(head.Position) or rootPos
                local topY, bottomY = headPos.Y - 20, rootPos.Y + 25
                local height = math.abs(bottomY - topY)
                local width = height * 0.55
                local leftX = rootPos.X - width/2
                local rightX = rootPos.X + width/2

                data.box.Thickness = Config.ESP.BoxThickness
                data.outline.Thickness = Config.ESP.OutlineThickness
                data.tracer.Thickness = Config.ESP.LineThickness
                data.name.Size = Config.ESP.TextSize
                data.hpText.Size = Config.ESP.TextSize - 1
                data.distText.Size = Config.ESP.TextSize - 2

                local isTeam = isTeammate(player)
                local col = isTeam and Config.ESP.TeamColor or Config.ESP.BoxColor
                if hum and hum.Health <= 0 and Config.ESP.DeadMark then col = Config.ESP.DeadColor end
                if Config.ESP.Gradient and hum and hum.Health > 0 then
                    col = getHealthColor(hum.Health, hum.MaxHealth)
                end

                -- Box (по стилю)
                if Config.ESP.Box then
                    if Config.ESP.BoxStyle == "Full" then
                        data.outline.Size = Vector2.new(width, height)
                        data.outline.Position = Vector2.new(leftX, topY)
                        data.outline.Visible = Config.ESP.Outline
                        data.box.Size = Vector2.new(width, height)
                        data.box.Position = Vector2.new(leftX, topY)
                        data.box.Color = col
                        data.box.Visible = true
                        for _, c in ipairs(data.corners) do c.Visible = false end
                    elseif Config.ESP.BoxStyle == "Corner" then
                        data.box.Visible = false
                        data.outline.Visible = false
                        local len = Config.ESP.CornerLength
                        -- TL
                        data.corners[1].From = Vector2.new(leftX, topY); data.corners[1].To = Vector2.new(leftX + len, topY)
                        data.corners[2].From = Vector2.new(leftX, topY); data.corners[2].To = Vector2.new(leftX, topY + len)
                        -- TR
                        data.corners[3].From = Vector2.new(rightX, topY); data.corners[3].To = Vector2.new(rightX - len, topY)
                        data.corners[4].From = Vector2.new(rightX, topY); data.corners[4].To = Vector2.new(rightX, topY + len)
                        -- BL
                        data.corners[5].From = Vector2.new(leftX, bottomY); data.corners[5].To = Vector2.new(leftX + len, bottomY)
                        data.corners[6].From = Vector2.new(leftX, bottomY); data.corners[6].To = Vector2.new(leftX, bottomY - len)
                        -- BR
                        data.corners[7].From = Vector2.new(rightX, bottomY); data.corners[7].To = Vector2.new(rightX - len, bottomY)
                        data.corners[8].From = Vector2.new(rightX, bottomY); data.corners[8].To = Vector2.new(rightX, bottomY - len)
                        for _, c in ipairs(data.corners) do
                            c.Color = col
                            c.Thickness = Config.ESP.BoxThickness
                            c.Visible = true
                        end
                    else -- Gradient
                        data.outline.Size = Vector2.new(width, height)
                        data.outline.Position = Vector2.new(leftX, topY)
                        data.outline.Visible = true
                        data.box.Size = Vector2.new(width, height)
                        data.box.Position = Vector2.new(leftX, topY)
                        data.box.Color = getHealthColor(hum.Health, hum.MaxHealth)
                        data.box.Visible = true
                        for _, c in ipairs(data.corners) do c.Visible = false end
                    end
                else
                    data.box.Visible=false; data.outline.Visible=false
                    for _, c in ipairs(data.corners) do c.Visible = false end
                end

                -- Lines
                if Config.ESP.Lines then
                    local from
                    if Config.ESP.LineFrom == "Bottom" then from = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    elseif Config.ESP.LineFrom == "Top" then from = Vector2.new(Camera.ViewportSize.X/2, 0)
                    else from = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) end
                    data.tracer.From = from
                    data.tracer.To = Vector2.new(rootPos.X, bottomY)
                    data.tracer.Color = col
                    data.tracer.Visible = true
                else data.tracer.Visible=false end

                if Config.ESP.Name then
                    data.name.Text = player.Name
                    data.name.Color = Config.ESP.NameColor
                    data.name.Position = Vector2.new(rootPos.X, topY - 16)
                    data.name.Visible = true
                else data.name.Visible=false end

                if Config.ESP.Health then
                    data.hpText.Text = "❤ " .. math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)
                    data.hpText.Color = getHealthColor(hum.Health, hum.MaxHealth)
                    data.hpText.Position = Vector2.new(rootPos.X, bottomY + 2)
                    data.hpText.Visible = true
                else data.hpText.Visible=false end

                if Config.ESP.HealthBar then
                    local barX = leftX - 8
                    local fill = (bottomY - topY) * (hum.Health / math.max(hum.MaxHealth, 1))
                    data.hpBarBg.From = Vector2.new(barX, topY)
                    data.hpBarBg.To = Vector2.new(barX, bottomY)
                    data.hpBarBg.Visible = true
                    data.hpBar.From = Vector2.new(barX, bottomY - fill)
                    data.hpBar.To = Vector2.new(barX, bottomY)
                    data.hpBar.Color = getHealthColor(hum.Health, hum.MaxHealth)
                    data.hpBar.Visible = true
                else data.hpBarBg.Visible=false; data.hpBar.Visible=false end

                if Config.ESP.Distance then
                    data.distText.Text = "[" .. math.floor(dist) .. "m]"
                    data.distText.Color = Config.ESP.DistanceColor
                    data.distText.Position = Vector2.new(rootPos.X, topY - 30)
                    data.distText.Visible = true
                else data.distText.Visible=false end

                if Config.ESP.HeadDot and head then
                    data.headDot.Position = Vector2.new(headPos.X, headPos.Y)
                    data.headDot.Color = Config.ESP.HeadDotColor
                    data.headDot.Visible = true
                else data.headDot.Visible=false end
            end)
            if not ok then
                removeESP(player)
                task.delay(0.5, function() createESP(player) end)
            end
        end
    else
        for _, data in pairs(ESPData) do
            pcall(function()
                data.box.Visible=false; data.outline.Visible=false
                data.name.Visible=false; data.hpText.Visible=false
                data.distText.Visible=false; data.tracer.Visible=false
                data.hpBarBg.Visible=false; data.hpBar.Visible=false
                data.headDot.Visible=false
                for _, c in ipairs(data.corners) do c.Visible = false end
            end)
        end
    end

    -- FOV
    if fovCircle then
        fovCircle.Radius = Config.Aimbot.FOV
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        fovCircle.Visible = Config.Aimbot.Enabled and Config.Aimbot.ShowFOV
        if Config.Aimbot.FOVRainbow then
            fovCircle.Color = Color3.fromHSV(hue, 1, 1)
        else
            fovCircle.Color = Config.Aimbot.FOVColor
        end
        fovCircle.Filled = Config.Aimbot.FOVFilled
    end

    -- AIMBOT
    local shouldAim = false
    if Config.Aimbot.Enabled then
        if Config.Aimbot.Mode == "Always" or Config.Aimbot.Mode == "Toggle" then
            shouldAim = true
        else
            if typeof(Config.Aimbot.Key) == "EnumItem" then
                if Config.Aimbot.Key.EnumType == Enum.UserInputType then
                    shouldAim = UserInputService:IsMouseButtonPressed(Config.Aimbot.Key)
                else
                    shouldAim = UserInputService:IsKeyDown(Config.Aimbot.Key)
                end
            end
        end
    end

    if shouldAim and LocalPlayer.Character then
        local t = findTarget(Config.Aimbot.FOV, Config.Aimbot.Part, Config.Aimbot.TeamCheck, Config.Aimbot.WallCheck, Config.Aimbot.MaxDistance)
        if t and t.part then
            -- Target line
            if targetLine and Config.Aimbot.ShowTargetLine then
                local sp = Camera:WorldToViewportPoint(t.part.Position)
                targetLine.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                targetLine.To = Vector2.new(sp.X, sp.Y)
                targetLine.Color = Config.Aimbot.TargetLineColor
                targetLine.Visible = true
            end

            local targetPos = t.part.Position
            if Config.Aimbot.Prediction then
                local vel = t.part.AssemblyLinearVelocity or Vector3.new()
                targetPos = targetPos + vel * Config.Aimbot.PredictionAmount
            end
            if Config.Aimbot.Method == "Mouse" then
                local sp = Camera:WorldToViewportPoint(targetPos)
                local mousePos = UserInputService:GetMouseLocation()
                local delta = Vector2.new(sp.X, sp.Y) - mousePos
                mousemoverel(delta.X * Config.Aimbot.Smoothness, delta.Y * Config.Aimbot.Smoothness)
            else
                local camCF = Camera.CFrame
                Camera.CFrame = camCF:Lerp(CFrame.new(camCF.Position, targetPos), math.clamp(Config.Aimbot.Smoothness, 0, 1))
            end
        else
            if targetLine then targetLine.Visible = false end
        end
    else
        if targetLine then targetLine.Visible = false end
    end

    -- AIM ON SHOOT
    if Config.AimOnShoot.Enabled and LocalPlayer.Character then
        local keyDown = false
        if typeof(Config.AimOnShoot.Key) == "EnumItem" then
            if Config.AimOnShoot.Key.EnumType == Enum.UserInputType then
                keyDown = UserInputService:IsMouseButtonPressed(Config.AimOnShoot.Key)
            else
                keyDown = UserInputService:IsKeyDown(Config.AimOnShoot.Key)
            end
        end
        if keyDown then
            local t = findTarget(Config.AimOnShoot.FOV, Config.AimOnShoot.Part, Config.AimOnShoot.TeamCheck, Config.AimOnShoot.WallCheck, 2000)
            if t and t.part then
                local camCF = Camera.CFrame
                Camera.CFrame = camCF:Lerp(CFrame.new(camCF.Position, t.part.Position), 0.5)
            end
        end
    end

    -- AUTO SHOOT
    if Config.AutoShoot.Enabled and LocalPlayer.Character then
        local aimActive = true
        if Config.AutoShoot.OnlyWhenAimActive and Config.Aimbot.Enabled then
            if Config.Aimbot.Mode == "Hold" and typeof(Config.Aimbot.Key) == "EnumItem" then
                if Config.Aimbot.Key.EnumType == Enum.UserInputType then
                    aimActive = UserInputService:IsMouseButtonPressed(Config.Aimbot.Key)
                else
                    aimActive = UserInputService:IsKeyDown(Config.Aimbot.Key)
                end
            end
        end
        if aimActive then
            local now = tick()
            if now - autoShootLast >= Config.AutoShoot.Cooldown then
                local t = findTarget(Config.Aimbot.FOV, "Head", Config.AutoShoot.TeamCheck, Config.AutoShoot.WallCheck, Config.AutoShoot.MaxDistance)
                if t then
                    autoShootLast = now
                    task.spawn(function()
                        task.wait(Config.AutoShoot.Delay)
                        pcall(function() mouse1click() end)
                    end)
                end
            end
        end
    end

    -- TRIGGER BOT
    if Config.TriggerBot.Enabled and LocalPlayer.Character then
        local now = tick()
        if now - triggerLast >= Config.TriggerBot.Delay then
            local t = targetUnderCrosshair(Config.TriggerBot.TeamCheck, Config.TriggerBot.WallCheck, Config.TriggerBot.MaxDistance)
            if t then
                triggerLast = now
                pcall(function() mouse1click() end)
            end
        end
    end

    -- NOCLIP
    if Config.Misc.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
            end
        end
    end

    updateMinimap()
end)

-- ==========================================================
-- КНОПКА МЕНЮ
-- ==========================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then
        if Main.Visible then
            TweenService:Create(Main, TweenInfo.new(0.15), {Size=UDim2.new(0,0,0,0)}):Play()
            task.wait(0.15); Main.Visible = false; Main.Size = UDim2.new(0, W, 0, H)
        else
            Main.Visible = true; Main.Size = UDim2.new(0,0,0,0)
            TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0, W, 0, H)}):Play()
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        task.wait(0.5)
        hum.WalkSpeed = Config.Misc.WalkSpeed
        hum.JumpPower = Config.Misc.JumpPower
        hum.UseJumpPower = true
    end
end)

pcall(function()
    game.StarterGui:SetCore("SendNotification", {Title = "✨ Neo Menu v8", Text = "Press K", Duration = 5})
end)
