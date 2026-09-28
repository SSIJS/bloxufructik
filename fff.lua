-- =========================================================
-- HIGUT HUB V3 ULTIMATE | BLOX FRUITS EDITION
-- =========================================================
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Очистка предыдущих версий
if CoreGui:FindFirstChild("HigutHubV3UI") then CoreGui.HigutHubV3UI:Destroy() end
if Workspace:FindFirstChild("HigutSkyParticles") then Workspace.HigutSkyParticles:Destroy() end

-- Настройки и Флаги
local Flags = {
    AutoFarm = false,
    AutoQuest = false,
    FastAttack = true,
    SafeZoneFilter = true,
    Noclip = false,
    SkyParticles = true,
    MobESP = false,
    AutoStatMelee = false,
    AutoStatDefense = false,
    AutoStatSword = false,
    SafeHeight = 22
}

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HigutHubV3UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

---------------------------------------------------------
-- 1. СКАЙ-ЧАСТИЦЫ (НЕОН В НЕБЕ)
---------------------------------------------------------
local particleFolder = Instance.new("Folder", Workspace)
particleFolder.Name = "HigutSkyParticles"

local particlePart = Instance.new("Part", particleFolder)
particlePart.Name = "SkyEmitterPart"
particlePart.Anchored = true
particlePart.CanCollide = false
particlePart.Transparency = 1
particlePart.Size = Vector3.new(250, 10, 250)

local particleEmitter = Instance.new("ParticleEmitter", particlePart)
particleEmitter.Texture = "rbxassetid://243664672"
particleEmitter.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 30, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 255))
})
particleEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(0.5, 1.5), NumberSequenceKeypoint.new(1, 0)})
particleEmitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(0.5, 0.1), NumberSequenceKeypoint.new(1, 1)})
particleEmitter.Lifetime = NumberRange.new(3, 6)
particleEmitter.Rate = 35
particleEmitter.Speed = NumberRange.new(4, 8)
particleEmitter.SpreadAngle = Vector2.new(360, 360)

RunService.RenderStepped:Connect(function()
    if Flags.SkyParticles and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        particleEmitter.Enabled = true
        particlePart.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 40, 0)
    else
        particleEmitter.Enabled = false
    end
end)

---------------------------------------------------------
-- 2. КРАСИВОЕ ОКНО ЗАГРУЗКИ
---------------------------------------------------------
local LoadingFrame = Instance.new("Frame", ScreenGui)
LoadingFrame.Size = UDim2.new(0, 360, 0, 180)
LoadingFrame.Position = UDim2.new(0.5, -180, 0.5, -90)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
LoadingFrame.BorderSizePixel = 0

local LoadCorner = Instance.new("UICorner", LoadingFrame)
LoadCorner.CornerRadius = UDim.new(0, 12)

local LoadStroke = Instance.new("UIStroke", LoadingFrame)
LoadStroke.Color = Color3.fromRGB(120, 60, 255)
LoadStroke.Thickness = 1.5

local LoadTitle = Instance.new("TextLabel", LoadingFrame)
LoadTitle.Size = UDim2.new(1, 0, 0, 45)
LoadTitle.Position = UDim2.new(0, 0, 0, 10)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.Text = "HIGUT HUB V3 ULTIMATE"
LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadTitle.TextSize = 20

local LoadStatus = Instance.new("TextLabel", LoadingFrame)
LoadStatus.Size = UDim2.new(1, -40, 0, 25)
LoadStatus.Position = UDim2.new(0, 20, 0, 60)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Font = Enum.Font.Gotham
LoadStatus.Text = "Проверка Safe Zone..."
LoadStatus.TextColor3 = Color3.fromRGB(170, 170, 210)
LoadStatus.TextSize = 13

local BarBg = Instance.new("Frame", LoadingFrame)
BarBg.Size = UDim2.new(0.85, 0, 0, 10)
BarBg.Position = UDim2.new(0.075, 0, 0.72, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
BarBg.BorderSizePixel = 0
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(0, 5)

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
BarFill.BorderSizePixel = 0
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 5)

---------------------------------------------------------
-- 3. ОСНОВНОЕ МЕНЮ С ВКЛАДКАМИ
---------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 460, 0, 290)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -145)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(80, 65, 130)
MainStroke.Thickness = 1.5

-- Шапка
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local TitleText = Instance.new("TextLabel", TopBar)
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "👑 HIGUT HUB V3 | Blox Fruits"
TitleText.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleText.TextSize = 15
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Драг окна
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Левая панель вкладок (Sidebar)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 120, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Sidebar.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.Padding = UDim.new(0, 5)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -130, 1, -52)
Container.Position = UDim2.new(0, 125, 0, 47)
Container.BackgroundTransparency = 1

local Tabs = {}
local TabButtons = {}

local function CreateTab(name, icon)
    local TabPage = Instance.new("ScrollingFrame", Container)
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 3
    TabPage.Visible = false
    
    local TabList = Instance.new("UIListLayout", TabPage)
    TabList.Padding = UDim.new(0, 6)
    
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 36)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = icon .. " " .. name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    TabBtn.TextSize = 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(Tabs) do page.Visible = false end
        for _, btn in pairs(TabButtons) do 
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42) 
            btn.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
        TabPage.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 255)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    table.insert(Tabs, TabPage)
    table.insert(TabButtons, TabBtn)
    return TabPage
end

-- Конструктор тумблеров
local function AddToggle(parent, text, flagName, callback)
    local ToggleFrame = Instance.new("Frame", parent)
    ToggleFrame.Size = UDim2.new(0.96, 0, 0, 38)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(1, -55, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 240)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Switch = Instance.new("TextButton", ToggleFrame)
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -46, 0.5, -10)
    Switch.BackgroundColor3 = Flags[flagName] and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(55, 55, 75)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    
    local Knob = Instance.new("Frame", Switch)
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = Flags[flagName] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    Switch.MouseButton1Click:Connect(function()
        Flags[flagName] = not Flags[flagName]
        local active = Flags[flagName]
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(55, 55, 75)}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        if callback then callback(active) end
    end)
end

-- Создание вкладок
local FarmPage = CreateTab("Фарм", "🌾")
local StatsPage = CreateTab("Статы", "📊")
local PlayerPage = CreateTab("Игрок", "⚡")
local VisualsPage = CreateTab("Визуалы", "👁️")

-- Активация первой вкладки
Tabs[1].Visible = true
TabButtons[1].BackgroundColor3 = Color3.fromRGB(120, 50, 255)
TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Элементы управления
AddToggle(FarmPage, "Авто-Квест (Ближайший)", "AutoQuest")
AddToggle(FarmPage, "Воздух + Стяжка + Атака", "AutoFarm")
AddToggle(FarmPage, "Фильтр Safe Zone (Без бессмертных)", "SafeZoneFilter")
AddToggle(FarmPage, "Fast Attack (Быстрый урон)", "FastAttack")

AddToggle(StatsPage, "Авто-Стат: Ближний бой", "AutoStatMelee")
AddToggle(StatsPage, "Авто-Стат: Защита", "AutoStatDefense")
AddToggle(StatsPage, "Авто-Stat: Меч", "AutoStatSword")

AddToggle(PlayerPage, "Noclip (Сквозь стены)", "Noclip", function(v)
    if not v and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end)

AddToggle(VisualsPage, "Космические Частицы в Небе", "SkyParticles")
AddToggle(VisualsPage, "ESP Подсветка Мобов", "MobESP")

---------------------------------------------------------
-- 4. АНИМАЦИЯ ЗАГРУЗКИ
---------------------------------------------------------
task.spawn(function()
    local steps = {"Подключение обхода...", "Фильтрация SafeZone...", "Финализация..."}
    for i, txt in ipairs(steps) do
        LoadStatus.Text = txt
        TweenService:Create(BarFill, TweenInfo.new(0.3), {Size = UDim2.new(i / #steps, 0, 1, 0)}):Play()
        task.wait(0.35)
    end
    LoadingFrame:Destroy()
    MainFrame.Visible = true
end)

---------------------------------------------------------
-- 5. ЛОГИКА ФАРМА (С ПОЛНОЙ ИЗОЛЯЦИЕЙ SAFE ZONE)
---------------------------------------------------------
local function AutoTakeQuest()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1) 
        end
    end)
end

-- Проверка: находится ли моб в Safe Zone (город)
local function IsMobInSafeZone(mobHrp)
    if not Flags.SafeZoneFilter then return false end
    -- Если моб слишком близко к городским квестовикам или спавну
    if Workspace:FindFirstChild("NPCs") then
        for _, npc in pairs(Workspace.NPCs:GetChildren()) do
            if (npc.WorldPivot.Position - mobHrp.Position).Magnitude < 90 then
                return true -- Внутри города (бессмертный!)
            end
        end
    end
    return false
end

local function GetValidEnemy()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local nearest = nil
    local minDist = math.huge
    local enemies = Workspace:FindFirstChild("Enemies")
    
    if enemies then
        for _, enemy in pairs(enemies:GetChildren()) do
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            local hum = enemy:FindFirstChild("Humanoid")
            -- Фильтр: Исключаем Trainee и бессмертных в Safe Zone
            if hrp and hum and hum.Health > 0 and not string.find(enemy.Name, "Trainee") then
                if not IsMobInSafeZone(hrp) then
                    local dist = (char.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = enemy
                    end
                end
            end
        end
    end
    return nearest
end

-- Быстрая атака
local function ExecuteAttack(char)
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") and (item.ToolTip:find("Melee") or item.ToolTip:find("Sword")) then
                item.Parent = char
                tool = item
                break
            end
        end
    end
    
    if tool then
        tool:Activate()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(600, 600))
        if Flags.FastAttack then
            VirtualInputManager:SendMouseButtonEvent(600, 600, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(600, 600, 0, false, game, 0)
        end
    end
end

local farmPosition = nil

-- Главный цикл фарма
task.spawn(function()
    while task.wait(0.03) do
        if Flags.AutoQuest then AutoTakeQuest() end
        
        if Flags.AutoFarm then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            
            local hrp = char.HumanoidRootPart
            local mainTarget = GetValidEnemy()
            
            if mainTarget then
                local targetHrp = mainTarget:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    -- Фиксируем позицию над мобом В ПОЛЕ (вдали от Safe Zone)
                    if not farmPosition then
                        farmPosition = targetHrp.CFrame * CFrame.new(0, Flags.SafeHeight, 0)
                    end
                    
                    hrp.CFrame = farmPosition
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    -- Стягиваем только ДОПУСТИМЫХ мобов в чистом поле
                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in pairs(enemies:GetChildren()) do
                            local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                            local eHum = enemy:FindFirstChild("Humanoid")
                            if eHrp and eHum and eHum.Health > 0 and not string.find(enemy.Name, "Trainee") then
                                if not IsMobInSafeZone(eHrp) and (eHrp.Position - hrp.Position).Magnitude < 300 then
                                    eHrp.CFrame = hrp.CFrame * CFrame.new(0, -4, -2)
                                    eHrp.Velocity = Vector3.new(0, 0, 0)
                                    eHrp.CanCollide = false
                                    eHum.WalkSpeed = 0
                                    eHum.Sit = true 
                                end
                            end
                        end
                    end
                    
                    ExecuteAttack(char)
                end
            else
                farmPosition = nil -- Поиск новой пачки
            end
        else
            farmPosition = nil
        end
    end
end)

-- Фоновый процесс: Noclip + Auto Stats
RunService.Stepped:Connect(function()
    if Flags.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            if Flags.AutoStatMelee then remotes.CommF_:InvokeServer("AddPoint", "Melee", 1) end
            if Flags.AutoStatDefense then remotes.CommF_:InvokeServer("AddPoint", "Defense", 1) end
            if Flags.AutoStatSword then remotes.CommF_:InvokeServer("AddPoint", "Sword", 1) end
        end
    end
end)
