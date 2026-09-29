-- =========================================================
-- VORTEX HUB | CLASSIC UI + WATERMARK + PARTICLES
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
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- Очистка старых версий
if CoreGui:FindFirstChild("VortexHub") then CoreGui.VortexHub:Destroy() end
if CoreGui:FindFirstChild("VortexWatermark") then CoreGui.VortexWatermark:Destroy() end

local Flags = {
    AutoFarm = false,
    AutoQuest = false,
    AutoHaki = false,
    SafeZoneFilter = true,
    MobESP = false,
    PurpleWorld = true,
    SafeHeight = 25
}

---------------------------------------------------------
-- 1. WATERMARK (ВАТЕРМАРКА)
---------------------------------------------------------
local WMGui = Instance.new("ScreenGui", CoreGui)
WMGui.Name = "VortexWatermark"
WMGui.ResetOnSpawn = false

local WMFrame = Instance.new("Frame", WMGui)
WMFrame.Size = UDim2.new(0, 320, 0, 30)
WMFrame.Position = UDim2.new(0.5, -160, 0, 15)
WMFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
WMFrame.BorderSizePixel = 0
Instance.new("UICorner", WMFrame).CornerRadius = UDim.new(0, 6)
local WMStroke = Instance.new("UIStroke", WMFrame)
WMStroke.Color = Color3.fromRGB(130, 50, 220)
WMStroke.Thickness = 1

local WMLayout = Instance.new("UIListLayout", WMFrame)
WMLayout.FillDirection = Enum.FillDirection.Horizontal
WMLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
WMLayout.VerticalAlignment = Enum.VerticalAlignment.Center
WMLayout.Padding = UDim.new(0, 10)

local function createWMLabel(text, font)
    local lbl = Instance.new("TextLabel", WMFrame)
    lbl.BackgroundTransparency = 1
    lbl.Font = font or Enum.Font.GothamMedium
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 13
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.Size = UDim2.new(0, 0, 1, 0)
    return lbl
end

local LogoLbl = createWMLabel("VORTEX", Enum.Font.GothamBlack)
Instance.new("Frame", WMFrame).Size = UDim2.new(0, 1, 0, 14) -- Разделитель
local NameLbl = createWMLabel(LocalPlayer.Name)
Instance.new("Frame", WMFrame).Size = UDim2.new(0, 1, 0, 14)
local FPSLbl = createWMLabel("FPS: 0")
Instance.new("Frame", WMFrame).Size = UDim2.new(0, 1, 0, 14)
local PingLbl = createWMLabel("Ping: 0ms")

-- Обновление ватермарки
RunService.RenderStepped:Connect(function(deltaTime)
    local fps = math.floor(1 / deltaTime)
    local ping = "0"
    pcall(function() ping = string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1] end)
    
    FPSLbl.Text = "FPS: " .. tostring(fps)
    PingLbl.Text = "Ping: " .. tostring(ping) .. "ms"
    LogoLbl.TextColor3 = Color3.fromHSV(tick() % 4 / 4, 0.8, 1) -- Живое RGB лого
end)

---------------------------------------------------------
-- 2. КЛАССИЧЕСКИЙ СТРОГИЙ UI
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "VortexHub"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 420)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(130, 50, 220)
MainStroke.Thickness = 1

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 18, 28)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local TitleText = Instance.new("TextLabel", TopBar)
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "VORTEX HUB | BLOX FRUITS"
TitleText.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() WMGui:Destroy() end)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging, dragStart, startPos = true, input.Position, MainFrame.Position end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 16, 24)
Sidebar.BorderSizePixel = 0
local SideList = Instance.new("UIListLayout", Sidebar)
SideList.Padding = UDim.new(0, 5)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -165, 1, -50)
Container.Position = UDim2.new(0, 158, 0, 45)
Container.BackgroundTransparency = 1

local Tabs, TabButtons = {}, {}

local function CreateTab(name)
    local TabPage = Instance.new("ScrollingFrame", Container)
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 2
    TabPage.Visible = false
    local TabList = Instance.new("UIListLayout", TabPage)
    TabList.Padding = UDim.new(0, 8)
    
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 36)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 23, 34)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(170, 170, 190)
    TabBtn.TextSize = 13
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(Tabs) do page.Visible = false end
        for _, btn in pairs(TabButtons) do btn.BackgroundColor3 = Color3.fromRGB(25, 23, 34) btn.TextColor3 = Color3.fromRGB(170, 170, 190) end
        TabPage.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(130, 50, 220)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    table.insert(Tabs, TabPage) table.insert(TabButtons, TabBtn)
    return TabPage
end

local function AddToggle(parent, text, flagName)
    local TglFrame = Instance.new("Frame", parent)
    TglFrame.Size = UDim2.new(0.98, 0, 0, 40)
    TglFrame.BackgroundColor3 = Color3.fromRGB(22, 20, 30)
    Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 6)
    
    local Lbl = Instance.new("TextLabel", TglFrame)
    Lbl.Size = UDim2.new(1, -60, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.Text = text
    Lbl.TextColor3 = Color3.fromRGB(220, 220, 240)
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local Btn = Instance.new("TextButton", TglFrame)
    Btn.Size = UDim2.new(0, 42, 0, 20)
    Btn.Position = UDim2.new(1, -50, 0.5, -10)
    Btn.BackgroundColor3 = Flags[flagName] and Color3.fromRGB(130, 50, 220) or Color3.fromRGB(45, 45, 60)
    Btn.Text = ""
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    
    local Knob = Instance.new("Frame", Btn)
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = Flags[flagName] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    Btn.MouseButton1Click:Connect(function()
        Flags[flagName] = not Flags[flagName]
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Flags[flagName] and Color3.fromRGB(130, 50, 220) or Color3.fromRGB(45, 45, 60)}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = Flags[flagName] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
    end)
end

local FarmPage = CreateTab("Автофарм")
local VisualsPage = CreateTab("Визуалы")
Tabs[1].Visible = true
TabButtons[1].BackgroundColor3 = Color3.fromRGB(130, 50, 220)
TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)

AddToggle(FarmPage, "Умный Авто-Квест", "AutoQuest")
AddToggle(FarmPage, "Авто-Воля (Haki)", "AutoHaki")
AddToggle(FarmPage, "Автокликер + Стяжка", "AutoFarm")
AddToggle(FarmPage, "Safe Zone Фильтр", "SafeZoneFilter")

AddToggle(VisualsPage, "Vortex Мир (Небо + Партиклы)", "PurpleWorld")
AddToggle(VisualsPage, "ESP Мобов", "MobESP")

---------------------------------------------------------
-- 3. VORTEX WORLD (НЕБО + ПАРТИКЛЫ)
---------------------------------------------------------
local ColorCorr = Lighting:FindFirstChild("VortexCC") or Instance.new("ColorCorrectionEffect")
ColorCorr.Name = "VortexCC"
ColorCorr.Parent = Lighting

local function ManageParticles(char)
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if Flags.PurpleWorld then
        if not hrp:FindFirstChild("VortexAura") then
            local att = Instance.new("Attachment", hrp)
            att.Name = "VortexAura"
            local pe = Instance.new("ParticleEmitter", att)
            pe.Color = ColorSequence.new(Color3.fromRGB(150, 0, 255))
            pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 0)})
            pe.Texture = "rbxassetid://243660364"
            pe.EmissionDirection = Enum.NormalId.Top
            pe.Rate = 25
            pe.Speed = NumberRange.new(3, 6)
            pe.Lifetime = NumberRange.new(1, 2)
        end
    else
        if hrp:FindFirstChild("VortexAura") then hrp.VortexAura:Destroy() end
    end
end

-- Жесткий фикс освещения (перебиваем скрипты игры)
RunService.RenderStepped:Connect(function()
    if Flags.PurpleWorld then
        ColorCorr.Enabled = true
        ColorCorr.TintColor = Color3.fromRGB(180, 130, 255)
        ColorCorr.Saturation = 0.5
        Lighting.Ambient = Color3.fromRGB(130, 50, 190)
        Lighting.OutdoorAmbient = Color3.fromRGB(110, 30, 160)
        Lighting.FogColor = Color3.fromRGB(80, 10, 120)
    else
        ColorCorr.Enabled = false
    end
    ManageParticles(LocalPlayer.Character)
end)

---------------------------------------------------------
-- 4. SMART QUEST LOGIC & FARMING
---------------------------------------------------------
local function HasActiveQuest()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    return gui and gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Quest") and gui.Main.Quest.Visible
end

local function SmartTakeQuest()
    if HasActiveQuest() then return end
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            remotes.CommF_:InvokeServer("StartQuest", "MarineQuest", 1)
            remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
        end
    end)
end

local function IsMobInSafeZone(mobHrp)
    if not Flags.SafeZoneFilter then return false end
    if Workspace:FindFirstChild("NPCs") then
        for _, npc in pairs(Workspace.NPCs:GetChildren()) do
            if (npc.WorldPivot.Position - mobHrp.Position).Magnitude < 55 then return true end
        end
    end
    return false
end

local farmPosition = nil
task.spawn(function()
    while task.wait(0.01) do
        if Flags.AutoHaki and LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("HasBuso") then
            pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso") end)
        end

        if Flags.AutoQuest then SmartTakeQuest() end
        
        if Flags.AutoFarm then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            local hrp = char.HumanoidRootPart
            
            local nearest, minDist = nil, math.huge
            if Workspace:FindFirstChild("Enemies") then
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    local eHrp, eHum = enemy:FindFirstChild("HumanoidRootPart"), enemy:FindFirstChild("Humanoid")
                    if eHrp and eHum and eHum.Health > 0 and not IsMobInSafeZone(eHrp) then
                        local dist = (hrp.Position - eHrp.Position).Magnitude
                        if dist < minDist then minDist, nearest = dist, enemy end
                    end
                end
            end
            
            if nearest then
                local targetHrp = nearest:FindFirstChild("HumanoidRootPart")
                if not farmPosition then farmPosition = targetHrp.CFrame * CFrame.new(0, Flags.SafeHeight, 0) end
                hrp.CFrame = farmPosition
                hrp.Velocity = Vector3.new(0,0,0)

                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    local eHrp, eHum = enemy:FindFirstChild("HumanoidRootPart"), enemy:FindFirstChild("Humanoid")
                    if eHrp and eHum and eHum.Health > 0 and not IsMobInSafeZone(eHrp) and (eHrp.Position - hrp.Position).Magnitude < 250 then
                        eHrp.CFrame = hrp.CFrame * CFrame.new(0, -5, -3)
                        eHrp.Velocity = Vector3.new(0,0,0)
                        eHrp.CanCollide = false
                        eHum.WalkSpeed, eHum.Sit = 0, true 
                    end
                end

                local tool = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                if tool then
                    tool.Parent = char
                    tool:Activate()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0, 0))
                end
            else
                farmPosition = nil
            end
        else
            farmPosition = nil
        end
    end
end)
