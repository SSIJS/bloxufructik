if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local Flags = {
    AutoFarm = false,
    AutoQuest = false,
    SafeHeight = 35
}

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Higut Hub PRO MAX | Blox Fruits",
   LoadingTitle = "Загрузка модулей...",
   LoadingSubtitle = "Версия для босса - Исправленная",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local FarmTab = Window:CreateTab("Автофарм", 4483362458)

-- ==========================================
-- 1. АВТОКВЕСТ
-- ==========================================
local function AutoTakeQuest()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            local nearestNPC = nil
            local minDist = 500
            for _, npc in pairs(Workspace.NPCs:GetChildren()) do
                if string.find(npc.Name, "Quest") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - npc.WorldPivot.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearestNPC = npc
                    end
                end
            end
            if nearestNPC then
                -- Пытаемся взять квест (BanditQuest1 как базовый шаблон)
                remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1) 
            end
        end
    end)
end

-- ==========================================
-- 2. ИДЕАЛЬНЫЙ ВОЗДУШНЫЙ ФАРМ С КЛИКЕРОМ
-- ==========================================
local function GetNearestEnemy()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local nearest = nil
    local minDist = math.huge
    local enemies = Workspace:FindFirstChild("Enemies")
    
    if enemies then
        for _, enemy in pairs(enemies:GetChildren()) do
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            local hum = enemy:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist = (char.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = enemy
                end
            end
        end
    end
    return nearest
end

local farmPosition = nil -- Фиксированная точка в воздухе, чтобы не улетать в космос

task.spawn(function()
    while task.wait(0.05) do -- Ускорили цикл для плавности
        if Flags.AutoQuest then
            AutoTakeQuest()
        end
        
        if Flags.AutoFarm then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            
            local hrp = char.HumanoidRootPart
            local mainTarget = GetNearestEnemy()
            
            if mainTarget then
                local targetHrp = mainTarget:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    -- 1. Фиксируем позицию фарма в воздухе ТОЛЬКО один раз на пачку мобов
                    if not farmPosition then
                        farmPosition = targetHrp.CFrame * CFrame.new(0, Flags.SafeHeight, 0)
                    end
                    
                    -- Держим игрока в воздухе
                    hrp.CFrame = farmPosition
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    -- 2. Стяжка мобов прямо к нам в воздух (чуть ниже и спереди)
                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in pairs(enemies:GetChildren()) do
                            local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                            local eHum = enemy:FindFirstChild("Humanoid")
                            if eHrp and eHum and eHum.Health > 0 then
                                if (eHrp.Position - hrp.Position).Magnitude < 350 then
                                    -- Телепортируем моба к себе в небо (на 6 студов ниже, на 4 вперед)
                                    eHrp.CFrame = hrp.CFrame * CFrame.new(0, -6, -4)
                                    eHrp.Velocity = Vector3.new(0, 0, 0)
                                    eHrp.CanCollide = false
                                    
                                    -- Оглушаем моба
                                    eHum.WalkSpeed = 0
                                    eHum.JumpPower = 0
                                    eHum.Sit = true 
                                end
                            end
                        end
                    end
                    
                    -- 3. Достаем оружие
                    local tool = char:FindFirstChildOfClass("Tool")
                    if not tool then
                        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if item:IsA("Tool") and (item.ToolTip:find("Melee") or item.ToolTip:find("Sword")) then
                                item.Parent = char
                                break
                            end
                        end
                    end
                    
                    -- 4. Имитация реального клика (VirtualUser бьет 100%)
                    if tool then 
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new()) 
                    end
                end
            else
                -- Если мобов нет, сбрасываем позицию
                farmPosition = nil
            end
        else
            farmPosition = nil
        end
    end
end)

-- ==========================================
-- ИНТЕРФЕЙС
-- ==========================================

FarmTab:CreateToggle({
   Name = "1. Авто-Квест (Ближайший)",
   CurrentValue = false,
   Flag = "Toggle_AutoQuest",
   Callback = function(Value)
        Flags.AutoQuest = Value
   end,
})

FarmTab:CreateToggle({
   Name = "2. Воздух + Стяжка + Автоатака",
   CurrentValue = false,
   Flag = "Toggle_AutoFarm",
   Callback = function(Value)
        Flags.AutoFarm = Value
   end,
})

Rayfield:LoadConfiguration()
