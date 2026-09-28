-- HIGUT HUB PRO MAX | Blox Fruits Edition
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Очистка старых копий интерфейса
if CoreGui:FindFirstChild("HigutHubProUI") then
    CoreGui.HigutHubProUI:Destroy()
end
if Workspace:FindFirstChild("HigutSkyParticles") then
    Workspace.HigutSkyParticles:Destroy()
end

local Flags = {
    AutoFarm = false,
    AutoQuest = false,
    SkyParticles = true,
    SafeHeight = 25
}

-- Главный ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HigutHubProUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

---------------------------------------------------------
-- 1. СКАЙ-ЧАСТИЦЫ (НЕОНОВЫЕ ЭФФЕКТЫ В НЕБЕ)
---------------------------------------------------------
local particleFolder = Instance.new("Folder")
particleFolder.Name = "HigutSkyParticles"
particleFolder.Parent = Workspace

local particlePart = Instance.new("Part")
particlePart.Name = "SkyEmitterPart"
particlePart.Anchored = true
particlePart.CanCollide = false
particlePart.Transparency = 1
particlePart.Size = Vector3.new(200, 10, 200)
particlePart.Parent = particleFolder

local particleEmitter = Instance.new("ParticleEmitter")
particleEmitter.Texture = "rbxassetid://243664672"
particleEmitter.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
})
particleEmitter.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.6),
    NumberSequenceKeypoint.new(0.5, 1.4),
    NumberSequenceKeypoint.new(1, 0)
})
particleEmitter.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.8),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(1, 1)
})
particleEmitter.Lifetime = NumberRange.new(4, 7)
particleEmitter.Rate = 40
particleEmitter.Speed = NumberRange.new(3, 7)
particleEmitter.SpreadAngle = Vector2.new(360, 360)
particleEmitter.Parent = particlePart

RunService.RenderStepped:Connect(function()
    if Flags.SkyParticles then
        particleEmitter.Enabled = true
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            particlePart.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 45, 0)
        end
    else
        particleEmitter.Enabled = false
    end
end)

---------------------------------------------------------
-- 2. АНИМИРОВАННОЕ ОКНО ЗАГРУЗКИ
---------------------------------------------------------
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 340, 0, 170)
LoadingFrame.Position = UDim2.new(0.5, -170, 0.5, -85)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 14)
LoadingCorner.Parent = LoadingFrame

local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Color = Color3.fromRGB(130, 80, 255)
LoadingStroke.Thickness = 1.5
LoadingStroke.Parent = LoadingFrame

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 40)
LoadingTitle.Position = UDim2.new(0, 0, 0, 15)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.Text = "HIGUT HUB PRO MAX"
LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingTitle.TextSize = 20
LoadingTitle.Parent = LoadingFrame

local LoadingStatus = Instance.new("TextLabel")
LoadingStatus.Size = UDim2.new(1, -40, 0, 25)
LoadingStatus.Position = UDim2.new(0, 20, 0, 55)
LoadingStatus.BackgroundTransparency = 1
LoadingStatus.Font = Enum.Font.Gotham
LoadingStatus.Text = "Инициализация..."
LoadingStatus.TextColor3 = Color3.fromRGB(170, 170, 200)
LoadingStatus.TextSize = 13
LoadingStatus.Parent = LoadingFrame

local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(0.85, 0, 0, 10)
BarBackground.Position = UDim2.new(0.075, 0, 0.72, 0)
BarBackground.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = LoadingFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 5)
BarCorner.Parent = BarBackground

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(140, 60, 255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 5)
FillCorner.Parent = BarFill

local FillGradient = Instance.new("UIGradient")
FillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 50, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 255))
})
FillGradient.Parent = BarFill

---------------------------------------------------------
-- 3. КРАСИВОЕ ОСНОВНОЕ МЕНЮ
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 235)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -117)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(90, 75, 140)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Шапка (Top Bar)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 14)
TopBarCorner.Parent = TopBar

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -60, 1, 0)
HeaderTitle.Position = UDim2.new(0, 15, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.Text = "⚡ HIGUT HUB PRO | Blox Fruits"
HeaderTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
HeaderTitle.TextSize = 15
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = TopBar

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Перетаскивание меню мышкой
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Контейнер для кнопок
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -52)
ContentFrame.Position = UDim2.new(0, 10, 0, 48)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.Parent = ContentFrame

-- Функция создания стильных тумблеров
local function CreateToggle(name, default, callback)
    local ToggleBg = Instance.new("Frame")
    ToggleBg.Size = UDim2.new(1, 0, 0, 44)
    ToggleBg.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    ToggleBg.Parent = ContentFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleBg
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Font = Enum.Font.GothamMedium
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleBg
    
    local SwitchTrack = Instance.new("TextButton")
    SwitchTrack.Size = UDim2.new(0, 46, 0, 24)
    SwitchTrack.Position = UDim2.new(1, -56, 0.5, -12)
    SwitchTrack.BackgroundColor3 = default and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(60, 60, 80)
    SwitchTrack.Text = ""
    SwitchTrack.Parent = ToggleBg
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = SwitchTrack
    
    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Size = UDim2.new(0, 18, 0, 18)
    SwitchKnob.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SwitchKnob.Parent = SwitchTrack
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SwitchKnob
    
    local state = default
    
    SwitchTrack.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(60, 60, 80)
        local targetPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        
        TweenService:Create(SwitchTrack, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = targetPos}):Play()
        
        callback(state)
    end)
end

-- Создаем тумблеры
CreateToggle("1. Авто-Квест (Ближайший NPC)", Flags.AutoQuest, function(v) Flags.AutoQuest = v end)
CreateToggle("2. Воздух + Стяжка + Автоатака", Flags.AutoFarm, function(v) Flags.AutoFarm = v end)
CreateToggle("3. Космические Частицы в Небе", Flags.SkyParticles, function(v) Flags.SkyParticles = v end)

---------------------------------------------------------
-- 4. АНИМАЦИЯ ПООЧЕРЕДНОЙ ЗАГРУЗКИ
---------------------------------------------------------
task.spawn(function()
    local steps = {
        {0.25, "Загрузка ядра Higut Engine..."},
        {0.55, "Создание частиц в небе..."},
        {0.85, "Активация Fast Attack..."},
        {1.00, "Успешно запущен!"}
    }
    
    for _, step in ipairs(steps) do
        TweenService:Create(BarFill, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(step[1], 0, 1, 0)}):Play()
        LoadingStatus.Text = step[2]
        task.wait(0.4)
    end
    
    task.wait(0.2)
    TweenService:Create(LoadingFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, 340, 0, 0), Transparency = 1}):Play()
    task.wait(0.25)
    LoadingFrame:Destroy()
    
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 380, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 380, 0, 235)}):Play()
end)

---------------------------------------------------------
-- 5. МОЩНАЯ АВТОАТАКА И СТЯЖКА
---------------------------------------------------------
local function AutoTakeQuest()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            local nearestNPC = nil
            local minDist = 600
            if Workspace:FindFirstChild("NPCs") then
                for _, npc in pairs(Workspace.NPCs:GetChildren()) do
                    if string.find(npc.Name, "Quest") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - npc.WorldPivot.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearestNPC = npc
                        end
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

-- Атакующий комплекс
local function ExecuteCombo(char)
    -- Достаем оружие
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") and (item.ToolTip:find("Melee") or item.ToolTip:find("Sword") or item.ToolTip:find("Blox Fruit")) then
                item.Parent = char
                tool = item
                break
            end
        end
    end
    
    if tool then
        tool:Activate()
        
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(500, 500))
            VirtualUser:Button1Up(Vector2.new(500, 500))
            
            VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 0)
        end)
    end
end

local farmPosition = nil

task.spawn(function()
    while task.wait(0.03) do
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

                    -- Стягивание прямо под ударной зоной персонажа (-4 по Y, -2 по Z)
                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in pairs(enemies:GetChildren()) do
                            local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                            local eHum = enemy:FindFirstChild("Humanoid")
                            if eHrp and eHum and eHum.Health > 0 then
                                if (eHrp.Position - hrp.Position).Magnitude < 350 then
                                    eHrp.CFrame = hrp.CFrame * CFrame.new(0, -4, -2)
                                    eHrp.Velocity = Vector3.new(0, 0, 0)
                                    eHrp.CanCollide = false
                                    
                                    eHum.WalkSpeed = 0
                                    eHum.JumpPower = 0
                                    eHum.Sit = true 
                                end
                            end
                        end
                    end
                    
                    -- Удар
                    ExecuteCombo(char)
                end
            else
                farmPosition = nil
            end
        else
            farmPosition = nil
        end
    end
end)
