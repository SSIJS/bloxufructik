if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Flags = {
    AutoFarm = false,
    AutoQuest = false,
    Particles = false,
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
local VisualTab = Window:CreateTab("Визуалы", 4483362458)

-- ==========================================
-- 1. АВТОКВЕСТ (УМНЫЙ)
-- ==========================================
local function HasActiveQuest()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if gui and gui:FindFirstChild("Main") then
        local questUI = gui.Main:FindFirstChild("Quest")
        if questUI and questUI.Visible then
            return true -- Квест уже выполняется, новый брать не нужно
        end
    end
    return false
end

local function AutoTakeQuest()
    if HasActiveQuest() then return end
    
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            local nearestNPC = nil
            local minDist = 500
            for _, npc in pairs(Workspace.NPCs:GetChildren()) do
                if string.find(npc.Name, "Quest") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - npc.WorldPivot.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearestNPC = npc
                        end
                    end
                end
            end
            if nearestNPC then
                -- Берем квесты в зависимости от фракции
                remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1) 
                remotes.CommF_:InvokeServer("StartQuest", "MarineQuest", 1)
            end
        end
    end)
end

-- ==========================================
-- 2. ИДЕАЛЬНЫЙ ВОЗДУШНЫЙ ФАРМ (БЕЗ КЛИКЕРА)
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

local farmPosition = nil

task.spawn(function()
    while task.wait(0.05) do
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
                    if not farmPosition then
                        farmPosition = targetHrp.CFrame * CFrame.new(0, Flags.SafeHeight, 0)
                    end
                    
                    hrp.CFrame = farmPosition
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in pairs(enemies:GetChildren()) do
                            local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                            local eHum = enemy:FindFirstChild("Humanoid")
                            if eHrp and eHum and eHum.Health > 0 then
                                if (eHrp.Position - hrp.Position).Magnitude < 350 then
                                    eHrp.CFrame = hrp.CFrame * CFrame.new(0, -6, -4)
                                    eHrp.Velocity = Vector3.new(0, 0, 0)
                                    eHrp.CanCollide = false
                                    eHum.WalkSpeed = 0
                                    eHum.JumpPower = 0
                                    eHum.Sit = true 
                                end
                            end
                        end
                    end
                    
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
                    
                    -- Удары оружием напрямую в движке, без эмуляции мышки
                    if tool then 
                        tool:Activate()
                    end
                end
            else
                farmPosition = nil
            end
        else
            farmPosition = nil
        end
    end
end)

-- ==========================================
-- 3. ПАРТИКЛЫ (КРУГЛЯШКИ)
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            if Flags.Particles then
                if not hrp:FindFirstChild("BossBubbles") then
                    local att = Instance.new("Attachment", hrp)
                    att.Name = "BossBubbles"
                    local pe = Instance.new("ParticleEmitter", att)
                    pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                    pe.Color = ColorSequence.new(Color3.fromRGB(160, 50, 255))
                    pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 0)})
                    pe.Rate = 15
                    pe.Speed = NumberRange.new(3, 5)
                    pe.Lifetime = NumberRange.new(1, 2.5)
                    pe.SpreadAngle = Vector2.new(360, 360) -- Разлетаются кругляшками во все стороны
                end
            else
                if hrp:FindFirstChild("BossBubbles") then
                    hrp.BossBubbles:Destroy()
                end
            end
        end
    end
end)

-- ==========================================
-- ИНТЕРФЕЙС
-- ==========================================

FarmTab:CreateToggle({
   Name = "1. Авто-Квест (Выполняет до конца)",
   CurrentValue = false,
   Flag = "Toggle_AutoQuest",
   Callback = function(Value)
       Flags.AutoQuest = Value
   end,
})

FarmTab:CreateToggle({
   Name = "2. Воздух + Стяжка + Удары (Без кликера)",
   CurrentValue = false,
   Flag = "Toggle_AutoFarm",
   Callback = function(Value)
       Flags.AutoFarm = Value
   end,
})

VisualTab:CreateToggle({
   Name = "1. Включить кругляшки (Партиклы)",
   CurrentValue = false,
   Flag = "Toggle_Particles",
   Callback = function(Value)
       Flags.Particles = Value
   end,
})

Rayfield:LoadConfiguration()
