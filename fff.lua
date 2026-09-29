-- =========================================================
-- HIGUT HUB V5 PREMIUM | SMART LOGIC & FLUENT UI
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

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

if CoreGui:FindFirstChild("HigutHubV5") then 
    CoreGui.HigutHubV5:Destroy() 
end

local Flags = {
    AutoFarm = false,
    AutoQuest = false,
    AutoHaki = false,
    SafeZoneFilter = true,
    MobESP = false,
    PurpleWorld = true,
    InfJump = false,
    SafeHeight = 25
}

---------------------------------------------------------
-- 1. PREMIUM UI (FLUENT DESIGN)
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HigutHubV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 650, 0, 450)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Shadow = Instance.new("UIStroke", MainFrame)
Shadow.Color = Color3.fromRGB(140, 60, 255)
Shadow.Thickness = 2
Shadow.Transparency = 0.3

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
TopBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel", TopBar)
TitleText.Size = UDim2.new(1, -70, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBlack
TitleText.Text = "HIGUT HUB V5 PREMIUM"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local TitleGradient = Instance.new("UIGradient", TitleText)
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -44, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 110)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 80)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 160, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Sidebar.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.Padding = UDim.new(0, 8)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -170, 1, -60)
Container.Position = UDim2.new(0, 165, 0, 55)
Container.BackgroundTransparency = 1

local Tabs, TabButtons = {}, {}

local function CreateTab(name)
    local TabPage = Instance.new("ScrollingFrame", Container)
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 2
    TabPage.Visible = false
    
    local TabList = Instance.new("UIListLayout", TabPage)
    TabList.Padding = UDim.new(0, 10)
    
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 42)
    TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
    TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(Tabs) do page.Visible = false end
        for _, btn in pairs(TabButtons) do 
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 30), TextColor3 = Color3.fromRGB(160, 160, 180)}):Play()
        end
        TabPage.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(140, 60, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    table.insert(Tabs, TabPage)
    table.insert(TabButtons, TabBtn)
    return TabPage
end

local function AddToggle(parent, text, flagName, callback)
    local ToggleFrame = Instance.new("Frame", parent)
    ToggleFrame.Size = UDim2.new(0.98, 0, 0, 48)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 10)
    
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230, 230, 240)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Switch = Instance.new("TextButton", ToggleFrame)
    Switch.Size = UDim2.new(0, 48, 0, 24)
    Switch.Position = UDim2.new(1, -60, 0.5, -12)
    Switch.BackgroundColor3 = Flags[flagName] and Color3.fromRGB(140, 60, 255) or Color3.fromRGB(40, 40, 55)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    
    local Knob = Instance.new("Frame", Switch)
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = Flags[flagName] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    Switch.MouseButton1Click:Connect(function()
        Flags[flagName] = not Flags[flagName]
        local active = Flags[flagName]
        TweenService:Create(Switch, TweenInfo.new(0.25), {BackgroundColor3 = active and Color3.fromRGB(140, 60, 255) or Color3.fromRGB(40, 40, 55)}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.25), {Position = active and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
        if callback then callback(active) end
    end)
end

local function AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(0.98, 0, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    Btn.Font = Enum.Font.GothamMedium
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(140, 60, 255)}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 42)}):Play()
        if callback then callback() end
    end)
end

local FarmPage = CreateTab("Автофарм")
local PlayerPage = CreateTab("Игрок")
local VisualsPage = CreateTab("Визуалы")

Tabs[1].Visible = true
TabButtons[1].BackgroundColor3 = Color3.fromRGB(140, 60, 255)
TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Вкладка Фарм
AddToggle(FarmPage, "Умный Авто-Квест", "AutoQuest")
AddToggle(FarmPage, "Воздух + Стяжка + Автокликер", "AutoFarm")
AddToggle(FarmPage, "Фильтр Safe Zone", "SafeZoneFilter")
AddToggle(FarmPage, "Авто-Воля (Buso Haki)", "AutoHaki")

-- Вкладка Игрок
AddToggle(PlayerPage, "Бесконечные Прыжки", "InfJump")
AddButton(PlayerPage, "Скорость x2 (WalkSpeed)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 32
    end
end)
AddButton(PlayerPage, "Прыжок x2 (JumpPower)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end)

-- Вкладка Визуалы
AddToggle(VisualsPage, "Фиолетовый Мир", "PurpleWorld")
AddToggle(VisualsPage, "ESP Подсветка Мобов", "MobESP")

---------------------------------------------------------
-- 2. ФУНКЦИОНАЛ: INF JUMP & HAKI
---------------------------------------------------------
UserInputService.JumpRequest:Connect(function()
    if Flags.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

task.spawn(function()
    while task.wait(2) do
        if Flags.AutoHaki and LocalPlayer.Character then
            if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes and remotes:FindFirstChild("CommF_") then
                    remotes.CommF_:InvokeServer("Buso")
                end
            end
        end
    end
end)

---------------------------------------------------------
-- 3. SMART QUEST LOGIC & FARMING
---------------------------------------------------------
local function HasActiveQuest()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if gui and gui:FindFirstChild("Main") then
        local questUI = gui.Main:FindFirstChild("Quest")
        if questUI and questUI.Visible then
            return true
        end
    end
    return false
end

local function SmartTakeQuest()
    if HasActiveQuest() then return end
    
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            local myLevel = LocalPlayer.Data.Level.Value
            if myLevel >= 1 then
                -- Отправляем запросы на стартовые квесты. Возьмется только доступный для фракции.
                remotes.CommF_:InvokeServer("StartQuest", "MarineQuest", 1)
                remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
            end
        end
    end)
end

local function IsMobInSafeZone(mobHrp)
    if not Flags.SafeZoneFilter then return false end
    if Workspace:FindFirstChild("NPCs") then
        for _, npc in pairs(Workspace.NPCs:GetChildren()) do
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
        VirtualUser:ClickButton1(Vector2.new(0, 0))
    end
end

local farmPosition = nil

task.spawn(function()
    while task.wait(0.01) do
        if Flags.AutoQuest then 
            SmartTakeQuest() 
        end
        
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
                                if not IsMobInSafeZone(eHrp) and (eHrp.Position - hrp.Position).Magnitude < 250 then
                                    eHrp.CFrame = hrp.CFrame * CFrame.new(0, -5, -3)
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
