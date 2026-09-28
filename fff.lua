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

-- ==========================================
-- 1. ЖЕЛЕЗОБЕТОННЫЙ ИНТЕРФЕЙС (БЕЗ ИНТЕРНЕТА)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local QuestBtn = Instance.new("TextButton")
local FarmBtn = Instance.new("TextButton")

ScreenGui.Name = "BossNativeHub"
ScreenGui.Parent = game.CoreGui

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Можно двигать по экрану

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "HIGUT HUB (Native)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

QuestBtn.Parent = MainFrame
QuestBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
QuestBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
QuestBtn.Size = UDim2.new(0.9, 0, 0, 40)
QuestBtn.Font = Enum.Font.SourceSansBold
QuestBtn.Text = "Авто-Квест: OFF"
QuestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
QuestBtn.TextSize = 16

FarmBtn.Parent = MainFrame
FarmBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
FarmBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
FarmBtn.Size = UDim2.new(0.9, 0, 0, 40)
FarmBtn.Font = Enum.Font.SourceSansBold
FarmBtn.Text = "Воздух-Фарм: OFF"
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.TextSize = 16

QuestBtn.MouseButton1Click:Connect(function()
    Flags.AutoQuest = not Flags.AutoQuest
    if Flags.AutoQuest then
        QuestBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        QuestBtn.Text = "Авто-Квест: ON"
    else
        QuestBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        QuestBtn.Text = "Авто-Квест: OFF"
    end
end)

FarmBtn.MouseButton1Click:Connect(function()
    Flags.AutoFarm = not Flags.AutoFarm
    if Flags.AutoFarm then
        FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        FarmBtn.Text = "Воздух-Фарм: ON"
    else
        FarmBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        FarmBtn.Text = "Воздух-Фарм: OFF"
    end
end)

-- ==========================================
-- 2. ЛОГИКА ФАРМА И КВЕСТОВ
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
