-- =========================================================
-- HIGUT HUB V4 ULTIMATE | QUEST FIX & PURPLE WORLD
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
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- Очистка прошлых интерфейсов
if CoreGui:FindFirstChild("HigutHubV4Final") then 
    CoreGui.HigutHubV4Final:Destroy() 
end

local Flags = {
    AutoFarm = false,
    AutoQuest = false,
    SafeZoneFilter = true,
    MobESP = false,
    PurpleWorld = true,
    SafeHeight = 22
}

---------------------------------------------------------
-- 1. ФИОЛЕТОВЫЙ МИР
---------------------------------------------------------
local ColorCorr = Lighting:FindFirstChild("HigutPurpleCC") or Instance.new("ColorCorrectionEffect")
ColorCorr.Name = "HigutPurpleCC"
ColorCorr.Parent = Lighting

local function ApplyPurpleWorld()
    if Flags.PurpleWorld then
        ColorCorr.Enabled = true
        ColorCorr.TintColor = Color3.fromRGB(200, 140, 255)
        ColorCorr.Saturation = 0.4
        ColorCorr.Contrast = 0.15
        
        Lighting.Ambient = Color3.fromRGB(130, 50, 190)
        Lighting.OutdoorAmbient = Color3.fromRGB(110, 30, 160)
        Lighting.FogColor = Color3.fromRGB(100, 20, 150)
        Lighting.FogEnd = 1500
    else
        ColorCorr.Enabled = false
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.FogColor = Color3.fromRGB(192, 224, 255)
        Lighting.FogEnd = 100000
    end
end
ApplyPurpleWorld()

---------------------------------------------------------
-- 2. СТРОГОЕ МЕНЮ (600x420, БЕЗ СМАЙЛИКОВ)
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HigutHubV4Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 420)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(130, 50, 220)
MainStroke.Thickness = 2

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 46)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 18, 28)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local TitleText = Instance.new("TextLabel", TopBar)
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 18, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "HIGUT HUB V4 | BLOX FRUITS"
TitleText.TextColor3 = Color3.fromRGB(245, 245, 255)
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(210, 40, 60)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

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

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, -46)
Sidebar.Position = UDim2.new(0, 0, 0, 46)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 16, 24)
Sidebar.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.Padding = UDim.new(0, 6)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -165, 1, -58)
Container.Position = UDim2.new(0, 158, 0, 52)
Container.BackgroundTransparency = 1

local Tabs = {}
local TabButtons = {}

local function CreateTab(name)
    local TabPage = Instance.new("ScrollingFrame", Container)
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 3
    TabPage.Visible = false
    
    local TabList = Instance.new("UIListLayout", TabPage)
    TabList.Padding = UDim.new(0, 8)
    
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.92, 0, 0, 40)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 23, 34)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(170, 170, 190)
    TabBtn.TextSize = 13
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(Tabs) do page.Visible = false end
        for _, btn in pairs(TabButtons) do 
            btn.BackgroundColor3 = Color3.fromRGB(25, 23, 34) 
            btn.TextColor3 = Color3.fromRGB(170, 170, 190)
        end
        TabPage.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(130, 50, 220)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    table.insert(Tabs, TabPage)
    table.insert(TabButtons, TabBtn)
    return TabPage
end

local function AddToggle(parent, text, flagName, callback)
    local ToggleFrame = Instance.new("Frame", parent)
    ToggleFrame.Size = UDim2.new(0.97, 0, 0, 44)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 20, 30)
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(1, -65, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 240)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Switch = Instance.new("TextButton", ToggleFrame)
    Switch.Size = UDim2.new(0, 46, 0, 22)
    Switch.Position = UDim2.new(1, -54, 0.5, -11)
    Switch.BackgroundColor3 = Flags[flagName] and Color3.fromRGB(130, 50, 220) or Color3.fromRGB(45, 45, 60)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    
    local Knob = Instance.new("Frame", Switch)
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = Flags[flagName] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    Switch.MouseButton1Click:Connect(function()
        Flags[flagName] = not Flags[flagName]
        local active = Flags[flagName]
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(130, 50, 220) or Color3.fromRGB(45, 45, 60)}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
        if callback then callback(active) end
    end)
end

local FarmPage = CreateTab("Автофарм")
local VisualsPage = CreateTab("Визуалы")

Tabs[1].Visible = true
TabButtons[1].BackgroundColor3 = Color3.fromRGB(130, 50, 220)
TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)

AddToggle(FarmPage, "Авто-Квест (Умный)", "AutoQuest")
AddToggle(FarmPage, "Воздух + Стяжка + Автокликер", "AutoFarm")
AddToggle(FarmPage, "Фильтр Safe Zone", "SafeZoneFilter")

AddToggle(VisualsPage, "Фиолетовый Мир", "PurpleWorld", function() ApplyPurpleWorld() end)
AddToggle(VisualsPage, "ESP Подсветка Мобов", "MobESP")

---------------------------------------------------------
-- 3. ESP СИСТЕМА
---------------------------------------------------------
local function CreateESP(enemy)
    if enemy:FindFirstChild("HigutESP") then return end
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local hl = Instance.new("Highlight")
    hl.Name = "HigutESP"
    hl.FillColor = Color3.fromRGB(160, 32, 240)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = enemy
    hl.Parent = enemy
    
    local bgui = Instance.new("BillboardGui")
    bgui.Name = "HigutTextESP"
    bgui.Adornee = hrp
    bgui.Size = UDim2.new(0, 100, 0, 30)
    bgui.StudsOffset = Vector3.new(0, 3, 0)
    bgui.AlwaysOnTop = true
    bgui.Parent = enemy
    
    local lbl = Instance.new("TextLabel", bgui)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = enemy.Name
    lbl.TextColor3 = Color3.fromRGB(220, 150, 255)
    lbl.TextSize = 11
    lbl.TextStrokeTransparency = 0
end

local function RemoveESP(enemy)
    if enemy:FindFirstChild("HigutESP") then enemy.HigutESP:Destroy() end
    if enemy:FindFirstChild("HigutTextESP") then enemy.HigutTextESP:Destroy() end
end

task.spawn(function()
    while task.wait(0.4) do
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, enemy in pairs(enemies:GetChildren()) do
                if Flags.MobESP then
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        CreateESP(enemy)
                    else
                        RemoveESP(enemy)
                    end
                else
                    RemoveESP(enemy)
                end
            end
        end
    end
end)

---------------------------------------------------------
-- 4. ИСПРАВЛЕННЫЙ АВТОКВЕСТ И ФАРМ
---------------------------------------------------------
local function AutoTakeQuest()
    pcall(function()
        -- Проверка: висит ли уже квест на экране. Если да - пропускаем (защита от бага сервера)
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui and playerGui:FindFirstChild("Main") then
            local questUI = playerGui.Main:FindFirstChild("Quest")
            if questUI and questUI.Visible then
                return 
            end
        end
        
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            -- Добавлен MarineQuest для Морпехов и BanditQuest1 для Пиратов
            remotes.CommF_:InvokeServer("StartQuest", "MarineQuest", 1)
            remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1) 
        end
    end)
end

local function IsMobInSafeZone(mobHrp)
    if not Flags.SafeZoneFilter then return false end
    if Workspace:FindFirstChild("NPCs") then
        for _, npc in pairs(Workspace.NPCs:GetChildren()) do
            -- Радиус уменьшен до 55, чтобы не задевать боевых мобов рядом с зоной
            if (npc.WorldPivot.Position - mobHrp.Position).Magnitude < 55 then
                return true
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
            
            -- Убрана жесткая блокировка Trainee. Теперь он просто проверяет, жив ли моб и не в сейф-зоне ли он.
            if hrp and hum and hum.Health > 0 then
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
        VirtualInputManager:SendMouseButtonEvent(600, 600, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(600, 600, 0, false, game, 0)
    end
end

local farmPosition = nil

task.spawn(function()
    while task.wait(0.02) do
        if Flags.AutoQuest then AutoTakeQuest() end
        
        if Flags.AutoFarm then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            
            local hrp = char.HumanoidRootPart
            local mainTarget = GetValidEnemy()
            
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
                farmPosition = nil
            end
        else
            farmPosition = nil
        end
    end
end)
