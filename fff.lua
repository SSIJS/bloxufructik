-- ==========================================================
-- Blox Fruits Fully Functional Script Hub (Luau)
-- Standalone UI + Complete Functional Core
-- ==========================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
-- ==========================================================
-- 1. ГЛОБАЛЬНЫЕ НАСТРОЙКИ И ФЛАГИ
-- ==========================================================
local Settings = {
AutoFarm = false,
FastAttack = true,
BringMobs = true,
AutoChests = false,
FruitESP = false,
AutoStoreFruit = false,
AutoStats = false,
SelectedStat = "Melee", -- "Melee", "Defense", "Sword", "Gun", "Demon Fruit"
StatPoints = 3,
AntiAFK = true,
Noclip = false,
TweenSpeed = 300
}
-- ==========================================================
-- 2. ВАСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ И СЕТЕВОЙ СЛОЙ
-- ==========================================================
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local function GetCharacter()
local char = LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
return char, char.HumanoidRootPart, char.Humanoid
end
return nil, nil, nil
end
local currentTween = nil
local function TweenTo(cframe)
local char, hrp = GetCharacter()
if not hrp then return end
local distance = (hrp.Position - cframe.Position).Magnitude
local duration = distance / Settings.TweenSpeed

local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
currentTween = TweenService:Create(hrp, info, {CFrame = cframe})
currentTween:Play()
return currentTween


end
local function StopTween()
if currentTween then
currentTween:Cancel()
currentTween = nil
end
end
local function EquipWeapon()
local char = GetCharacter()
if not char then return end
for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
    if tool:IsA("Tool") then
        if tool.ToolTip == "Melee" or tool:FindFirstChild("Combat") or tool.Name:find("Combat") or tool.Name:find("Dark Step") or tool.Name:find("Electro") then
            char.Humanoid:EquipTool(tool)
            break
        end
    end
end


end
-- ==========================================================
-- 3. БАЗА ДАННЫХ КВЕСТОВ И УРОВНЕЙ
-- ==========================================================
local QuestData = {
{MinLevel = 1, MaxLevel = 9, QuestName = "BanditQuest1", QuestLevel = 1, MobName = "Bandit", MobCFrame = CFrame.new(1145, 17, 1634), QuestCFrame = CFrame.new(1059, 17, 1546)},
{MinLevel = 10, MaxLevel = 14, QuestName = "JungleQuest", QuestLevel = 1, MobName = "Monkey", MobCFrame = CFrame.new(-1496, 37, 36, 0), QuestCFrame = CFrame.new(-1598, 37, 153)},
{MinLevel = 15, MaxLevel = 29, QuestName = "JungleQuest", QuestLevel = 2, MobName = "Gorilla", MobCFrame = CFrame.new(-1237, 6, -486), QuestCFrame = CFrame.new(-1598, 37, 153)},
{MinLevel = 30, MaxLevel = 39, QuestName = "PirateQuest", QuestLevel = 1, MobName = "Pirate", MobCFrame = CFrame.new(-1115, 14, 3938), QuestCFrame = CFrame.new(-1140, 4, 3828)},
{MinLevel = 40, MaxLevel = 59, QuestName = "PirateQuest", QuestLevel = 2, MobName = "Brute", MobCFrame = CFrame.new(-1145, 15, 4308), QuestCFrame = CFrame.new(-1140, 4, 3828)},
{MinLevel = 60, MaxLevel = 89, QuestName = "DesertQuest", QuestLevel = 1, MobName = "Desert Bandit", MobCFrame = CFrame.new(932, 7, 4484), QuestCFrame = CFrame.new(896, 7, 4390)},
{MinLevel = 90, MaxLevel = 119, QuestName = "SnowQuest", QuestLevel = 1, MobName = "Snow Bandit", MobCFrame = CFrame.new(1287, 87, -1297), QuestCFrame = CFrame.new(1385, 87, -1298)},
{MinLevel = 120, MaxLevel = 149, QuestName = "MarineQuest2", QuestLevel = 1, MobName = "Chief Petty Officer", MobCFrame = CFrame.new(-4855, 21, 4308), QuestCFrame = CFrame.new(-5035, 29, 4325)}
}
local function GetCurrentQuest()
local level = LocalPlayer.Data.Level.Value
for _, q in ipairs(QuestData) do
if level >= q.MinLevel and level <= q.MaxLevel then
return q
end
end
return QuestData[1]
end
-- ==========================================================
-- 4. РАБОЧИЕ ИСПОЛНИТЕЛЬНЫЕ ПОТОКИ (LOGIC CYCLES)
-- ==========================================================
-- 4.1 Auto Farm Level Loop
task.spawn(function()
while task.wait(0.1) do
if Settings.AutoFarm then
pcall(function()
local char, hrp, hum = GetCharacter()
if not char then return end
            local currentQuest = GetCurrentQuest()
            local questTitle = LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
            
            -- Если квест не взят — берем
            if not questTitle:find(currentQuest.MobName) then
                StopTween()
                hrp.CFrame = currentQuest.QuestCFrame
                task.wait(0.3)
                CommF:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestLevel)
                task.wait(0.5)
            else
                -- Ищем моба
                local targetMob = nil
                local enemies = Workspace:FindFirstChild("Enemies") or Workspace
                
                for _, enemy in ipairs(enemies:GetChildren()) do
                    if enemy.Name == currentQuest.MobName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                        targetMob = enemy
                        break
                    end
                end
                
                if targetMob then
                    local mobHrp = targetMob.HumanoidRootPart
                    -- Зависаем прямо над мобом для безопасности
                    hrp.CFrame = mobHrp.CFrame * CFrame.new(0, 11, 0)
                    
                    -- Стягивание соседних мобов
                    if Settings.BringMobs then
                        for _, enemy in ipairs(enemies:GetChildren()) do
                            if enemy.Name == currentQuest.MobName and enemy ~= targetMob and enemy:FindFirstChild("HumanoidRootPart") then
                                if (enemy.HumanoidRootPart.Position - mobHrp.Position).Magnitude < 200 then
                                    enemy.HumanoidRootPart.CFrame = mobHrp.CFrame
                                    enemy.HumanoidRootPart.CanCollide = false
                                end
                            end
                        end
                    end
                    
                    EquipWeapon()
                    
                    -- Атака
                    if Settings.FastAttack then
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    end
                else
                    -- Летим к спавну мобов
                    hrp.CFrame = currentQuest.MobCFrame
                end
            end
        end)
    end
end


end)
-- 4.2 Auto Farm Chests
task.spawn(function()
while task.wait(0.3) do
if Settings.AutoChests and not Settings.AutoFarm then
local char, hrp = GetCharacter()
if hrp then
for _, v in ipairs(Workspace:GetChildren()) do
if not Settings.AutoChests then break end
if v.Name:find("Chest") and v:IsA("BasePart") then
TweenTo(v.CFrame)
task.wait(0.5)
end
end
end
end
end
end)
-- 4.3 Fruit ESP & Auto Store
local fruitHighlights = {}
task.spawn(function()
while task.wait(1.5) do
if Settings.FruitESP then
for _, obj in ipairs(Workspace:GetChildren()) do
if obj:IsA("Tool") or obj.Name:find("Fruit") then
if not fruitHighlights[obj] then
local hl = Instance.new("Highlight")
hl.FillColor = Color3.fromRGB(0, 255, 150)
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.Parent = obj
fruitHighlights[obj] = hl
                    if Settings.AutoStoreFruit and obj:IsA("Tool") then
                        CommF:InvokeServer("StoreFruit", obj.Name, obj)
                    end
                end
            end
        end
    else
        for obj, hl in pairs(fruitHighlights) do
            if hl then hl:Destroy() end
        end
        table.clear(fruitHighlights)
    end
end


end)
-- 4.4 Auto Stats Allocator
task.spawn(function()
while task.wait(1) do
if Settings.AutoStats then
pcall(function()
CommF:InvokeServer("AddPoint", Settings.SelectedStat, Settings.StatPoints)
end)
end
end
end)
-- 4.5 Anti-AFK Kick Bypass
LocalPlayer.Idled:Connect(function()
if Settings.AntiAFK then
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end
end)
-- 4.6 Noclip Loop
RunService.Stepped:Connect(function()
if Settings.Noclip or Settings.AutoFarm or Settings.AutoChests then
local char = GetCharacter()
if char then
for _, part in ipairs(char:GetChildren()) do
if part:IsA("BasePart") then
part.CanCollide = false
end
end
end
end
end)
-- ==========================================================
-- 5. СОЗДАНИЕ ГРАФИЧЕСКОГО ИНТЕРФЕЙСА (UI ENGINE)
-- ==========================================================
local function BuildUI()
local existingUI = CoreGui:FindFirstChild("BloxFruitsHubUI")
if existingUI then existingUI:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Header / Title
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "  Blox Fruits Hub — Functional Core v2.5"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container for Options
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = Container

-- Helper to create working Toggles
local function AddToggle(text, defaultState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ToggleFrame.Parent = Container

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = ToggleFrame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 80, 0, 26)
    Button.Position = UDim2.new(1, -90, 0.5, -13)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.Parent = ToggleFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    local state = defaultState
    local function UpdateState()
        if state then
            Button.Text = "ON"
            Button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Button.Text = "OFF"
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            Button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        callback(state)
    end

    Button.MouseButton1Click:Connect(function()
        state = not state
        UpdateState()
    end)

    UpdateState()
end

-- Добавление элементов управления в интерфейс
AddToggle("Auto Farm Level & Quests", Settings.AutoFarm, function(st) Settings.AutoFarm = st end)
AddToggle("Fast Attack (No Cooldown)", Settings.FastAttack, function(st) Settings.FastAttack = st end)
AddToggle("Bring Mobs to Player", Settings.BringMobs, function(st) Settings.BringMobs = st end)
AddToggle("Auto Farm Chests", Settings.AutoChests, function(st) Settings.AutoChests = st end)
AddToggle("Fruit ESP & Highlight", Settings.FruitESP, function(st) Settings.FruitESP = st end)
AddToggle("Auto Store Found Fruits", Settings.AutoStoreFruit, function(st) Settings.AutoStoreFruit = st end)
AddToggle("Auto Stats Allocator (Melee)", Settings.AutoStats, function(st) Settings.AutoStats = st end)
AddToggle("Anti-AFK Protection", Settings.AntiAFK, function(st) Settings.AntiAFK = st end)
AddToggle("Noclip Mode", Settings.Noclip, function(st) Settings.Noclip = st end)

Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)


end
-- Запуск UI
BuildUI()
print("[Blox Fruits Hub]: Fully Functional Engine Loaded Successfully.")
