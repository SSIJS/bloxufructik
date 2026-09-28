if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Flags = {
    AutoFarm = false,
    AutoQuest = false,
    FruitESP = false,
    SafeHeight = 35 -- Высота над мобами (в студах)
}

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Higut Hub PRO | Blox Fruits",
   LoadingTitle = "Загрузка модулей...",
   LoadingSubtitle = "Версия для босса",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local FarmTab = Window:CreateTab("Автофарм (PRO)", 4483362458)

-- ==========================================
-- 1. СИСТЕМА АВТОКВЕСТОВ (Универсальная)
-- ==========================================
local function AutoTakeQuest()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            -- Ищем ближайшего NPC с квестами
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
            
            -- Если квестовик рядом, отправляем запрос на взятие квеста
            if nearestNPC then
                -- Взламываем диалог с NPC (берем верхний квест по умолчанию)
                remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1) 
                -- Примечание: Для идеального Автоквеста на 2550 уровней нужна база всех имен квестов.
                -- Этот метод будет пытаться взять квест у ближайшего NPC.
            end
        end
    end)
end

-- ==========================================
-- 2. SAFE ZONE ФАРМ (ВОЗДУХ + СТЯЖКА + ХИТБОКС)
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

task.spawn(function()
    while task.wait(0.1) do
        if Flags.AutoQuest then
            AutoTakeQuest()
        end
        
        if Flags.AutoFarm then
            local char = LocalPlayer.Character
            local mainTarget = GetNearestEnemy()
            
            if char and char:FindFirstChild("HumanoidRootPart") and mainTarget then
                local hrp = char.HumanoidRootPart
                local targetHrp = mainTarget:FindFirstChild("HumanoidRootPart")
                
                if targetHrp then
                    -- 1. ПОДВЕСИТЬ ИГРОКА В ВОЗДУХЕ
                    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, Flags.SafeHeight, 0)
                    
                    -- Сброс скорости падения (анти-гравитация)
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    -- 2. СТЯЖКА МОБОВ И УВЕЛИЧЕНИЕ ХИТБОКСА
                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in pairs(enemies:GetChildren()) do
                            local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                            local eHum = enemy:FindFirstChild("Humanoid")
                            if eHrp and eHum and eHum.Health > 0 then
                                -- Если моб в радиусе прорисовки
                                if (eHrp.Position - hrp.Position).Magnitude < 300 then
                                    -- Оставляем их на земле прямо под нами
                                    eHrp.CFrame = hrp.CFrame * CFrame.new(0, -Flags.SafeHeight, 0)
                                    
                                    -- ГИГАНТСКИЙ ХИТБОКС (чтобы доставать ударами сверху)
                                    eHrp.Size = Vector3.new(60, 60, 60)
                                    eHrp.CanCollide = false
                                    
                                    -- Замораживаем их, чтобы не разбегались
                                    eHum.WalkSpeed = 0
                                    eHum.JumpPower = 0
                                end
                            end
                        end
                    end
                    
                    -- 3. АВТОАТАКА
                    local tool = char:FindFirstChildOfClass("Tool")
                    if not tool then
                        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if item:IsA("Tool") and (item.ToolTip:find("Melee") or item.ToolTip:find("Sword")) then
                                item.Parent = char
                                break
                            end
                        end
                    end
                    if tool then 
                        tool:Activate() 
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- ИНТЕРФЕЙС (GUI)
-- ==========================================

FarmTab:CreateToggle({
   Name = "1. Авто-Квест (Ближайший NPC)",
   CurrentValue = false,
   Flag = "Toggle_AutoQuest",
   Callback = function(Value)
        Flags.AutoQuest = Value
   end,
})

FarmTab:CreateToggle({
   Name = "2. Safe Zone Farm (Воздух + Стяжка)",
   CurrentValue = false,
   Flag = "Toggle_AutoFarm",
   Callback = function(Value)
        Flags.AutoFarm = Value
   end,
})

Rayfield:LoadConfiguration()
