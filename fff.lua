-- Дожидаемся загрузки игры
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Глобальные переключатели
local Flags = {
    AutoFarm = false,
    BringMobs = false,
    FruitESP = false,
    FastAttack = false
}

-- Загружаем UI библиотеку Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Higut Hub | Blox Fruits",
   LoadingTitle = "Загрузка интерфейса...",
   LoadingSubtitle = "Инжект успешен",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Создаем вкладки
local FarmTab = Window:CreateTab("Автофарм", 4483362458)
local ESPTab = Window:CreateTab("ESP & Фрукты", 4483362458)

-- ==========================================
-- ЛОГИКА ФУНКЦИЙ
-- ==========================================

-- Функция поиска ближайшего моба
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

-- Поток Автофарма
task.spawn(function()
    while task.wait(0.1) do
        if Flags.AutoFarm then
            local char = LocalPlayer.Character
            local enemy = GetNearestEnemy()
            
            if char and char:FindFirstChild("HumanoidRootPart") and enemy then
                local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
                if enemyHrp then
                    -- Зависаем над мобом, чтобы он не бил в ответ
                    char.HumanoidRootPart.CFrame = enemyHrp.CFrame * CFrame.new(0, 10, 0)
                    
                    -- Автоматически достаем оружие
                    local tool = char:FindFirstChildOfClass("Tool")
                    if not tool then
                        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if item:IsA("Tool") and (item.ToolTip:find("Melee") or item.ToolTip:find("Sword")) then
                                item.Parent = char
                                break
                            end
                        end
                    end
                    
                    -- Бьем
                    if tool then tool:Activate() end
                end
            end
        end
    end
end)

-- Поток притягивания мобов (Bring Mobs)
task.spawn(function()
    while task.wait(0.2) do
        if Flags.BringMobs then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local enemies = Workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, enemy in pairs(enemies:GetChildren()) do
                        local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                        local eHum = enemy:FindFirstChild("Humanoid")
                        if eHrp and eHum and eHum.Health > 0 then
                            -- Если моб в радиусе 300 студов, телепортируем его к себе
                            if (hrp.Position - eHrp.Position).Magnitude < 300 then
                                eHrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -5)
                                eHrp.CanCollide = false
                                eHrp.Size = Vector3.new(10, 10, 10) -- Увеличиваем хитбокс
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Поток Fruit ESP
local espBox = {}
task.spawn(function()
    while task.wait(1) do
        if Flags.FruitESP then
            for _, item in pairs(Workspace:GetChildren()) do
                if item:IsA("Tool") or string.find(item.Name, "Fruit") then
                    if not espBox[item] then
                        local hl = Instance.new("Highlight")
                        hl.Parent = item
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        espBox[item] = hl
                    end
                end
            end
        else
            for item, hl in pairs(espBox) do
                if hl then hl:Destroy() end
            end
            table.clear(espBox)
        end
    end
end)

-- ==========================================
-- ИНТЕРФЕЙС (КНОПКИ)
-- ==========================================

FarmTab:CreateToggle({
   Name = "Включить Auto Farm",
   CurrentValue = false,
   Flag = "Toggle_AutoFarm",
   Callback = function(Value)
        Flags.AutoFarm = Value
   end,
})

FarmTab:CreateToggle({
   Name = "Стягивать мобов (Bring Mobs)",
   CurrentValue = false,
   Flag = "Toggle_BringMobs",
   Callback = function(Value)
        Flags.BringMobs = Value
   end,
})

ESPTab:CreateToggle({
   Name = "ESP на Фрукты (Подсветка)",
   CurrentValue = false,
   Flag = "Toggle_FruitESP",
   Callback = function(Value)
        Flags.FruitESP = Value
   end,
})

Rayfield:LoadConfiguration()
