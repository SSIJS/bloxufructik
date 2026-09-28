if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local Flags = {
    AutoFarm = false,
    AutoQuest = false,
    SafeHeight = 30
}

-- Загружаем самую стабильную библиотеку ORION
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Higut Hub | FIX ВЕРСИЯ", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "Загрузка для Босса..."
})

local FarmTab = Window:MakeTab({
    Name = "Автофарм",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

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
                remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1) 
            end
        end
    end)
end

-- ==========================================
-- 2. БОЕВОЙ ЦИКЛ (С ОБХОДОМ SAFE ZONE)
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
                    -- Вылетаем из Safe Zone к мобу
                    if not farmPosition then
                        farmPosition = targetHrp.CFrame * CFrame.new(0, Flags.SafeHeight, 0)
                    end
                    
                    hrp.CFrame = farmPosition
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    -- Стягиваем остальных
                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in pairs(enemies:GetChildren()) do
                            local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                            local eHum = enemy:FindFirstChild("Humanoid")
                            if eHrp and eHum and eHum.Health > 0 then
                                if (eHrp.Position - hrp.Position).Magnitude < 350 then
                                    eHrp.CFrame = hrp.CFrame * CFrame.new(0, -7, -3)
                                    eHrp.Velocity = Vector3.new(0, 0, 0)
                                    eHrp.CanCollide = false
                                    
                                    eHum.WalkSpeed = 0
                                    eHum.JumpPower = 0
                                    eHum.Sit = true 
                                end
                            end
                        end
                    end
                    
                    -- Достаем оружие
                    local tool = char:FindFirstChildOfClass("Tool")
                    if not tool then
                        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if item:IsA("Tool") and (item.ToolTip:find("Melee") or item.ToolTip:find("Sword")) then
                                item.Parent = char
                                break
                            end
                        end
                    end
                    
                    -- Атака
                    if tool then 
                        tool:Activate()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new()) 
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
-- ИНТЕРФЕЙС
-- ==========================================

FarmTab:AddToggle({
    Name = "1. Авто-Квест (Ближайший)",
    Default = false,
    Callback = function(Value)
        Flags.AutoQuest = Value
    end    
})

FarmTab:AddToggle({
    Name = "2. Воздух + Стяжка + Автоатака",
    Default = false,
    Callback = function(Value)
        Flags.AutoFarm = Value
    end    
})

-- Инициализация Orion
OrionLib:Init()
