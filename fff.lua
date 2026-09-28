-- language: Luau, file: bloxfruits_hub.lua, target: Roblox / Executor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

pcall(function()
    if PlayerGui:FindFirstChild("BloxFruitsHub_Main") then PlayerGui.BloxFruitsHub_Main:Destroy() end
    if PlayerGui:FindFirstChild("BloxFruitsHub_Watermark") then PlayerGui.BloxFruitsHub_Watermark:Destroy() end
    if PlayerGui:FindFirstChild("BloxFruitsHub_KeySystem") then PlayerGui.BloxFruitsHub_KeySystem:Destroy() end
end)

-- =========================================================================
-- СИСТЕМА КЛЮЧА
-- =========================================================================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "BloxFruitsHub_KeySystem"
KeyGui.ResetOnSpawn = false
KeyGui.DisplayOrder = 999999
KeyGui.Parent = PlayerGui

local KeyCanvas = Instance.new("CanvasGroup")
KeyCanvas.Size = UDim2.new(0, 360, 0, 220)
KeyCanvas.Position = UDim2.new(0.5, -180, 0.5, -110)
KeyCanvas.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
KeyCanvas.BorderSizePixel = 0
KeyCanvas.GroupTransparency = 1
KeyCanvas.Parent = KeyGui
Instance.new("UICorner", KeyCanvas).CornerRadius = UDim.new(0, 12)

TweenService:Create(KeyCanvas, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -40, 0, 30)
KeyTitle.Position = UDim2.new(0, 20, 0, 20)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
KeyTitle.Text = "Blox Fruits Hub - Key System"
KeyTitle.Parent = KeyCanvas

local KeyDesc = Instance.new("TextLabel")
KeyDesc.Size = UDim2.new(1, -40, 0, 20)
KeyDesc.Position = UDim2.new(0, 20, 0, 50)
KeyDesc.BackgroundTransparency = 1
KeyDesc.Font = Enum.Font.Gotham
KeyDesc.TextSize = 12
KeyDesc.TextColor3 = Color3.fromRGB(150, 150, 165)
KeyDesc.TextXAlignment = Enum.TextXAlignment.Left
KeyDesc.Text = "Enter access key (Hint: 2026)"
KeyDesc.Parent = KeyCanvas

local TextBoxBg = Instance.new("Frame")
TextBoxBg.Size = UDim2.new(1, -40, 0, 42)
TextBoxBg.Position = UDim2.new(0, 20, 0, 85)
TextBoxBg.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
TextBoxBg.BorderSizePixel = 0
TextBoxBg.Parent = KeyCanvas
Instance.new("UICorner", TextBoxBg).CornerRadius = UDim.new(0, 8)

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Size = UDim2.new(1, -20, 1, 0)
KeyTextBox.Position = UDim2.new(0, 10, 0, 0)
KeyTextBox.BackgroundTransparency = 1
KeyTextBox.Font = Enum.Font.GothamMedium
KeyTextBox.PlaceholderText = "Enter key here..."
KeyTextBox.Text = ""
KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 115)
KeyTextBox.TextSize = 13
KeyTextBox.TextXAlignment = Enum.TextXAlignment.Left
KeyTextBox.Parent = TextBoxBg

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -40, 0, 40)
SubmitBtn.Position = UDim2.new(0, 20, 0, 145)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Text = "SUBMIT KEY"
SubmitBtn.TextColor3 = Color3.fromRGB(200, 200, 215)
SubmitBtn.TextSize = 13
SubmitBtn.Parent = KeyCanvas
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

local function startMainHub()
    TweenService:Create(KeyCanvas, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        GroupTransparency = 1,
        Size = UDim2.new(0, 360, 0, 0),
        Position = UDim2.new(0.5, -180, 0.5, 0)
    }):Play()
    task.wait(0.3)
    KeyGui:Destroy()

    -- =========================================================================
    -- ВАТЕРМАРКА
    -- =========================================================================
    local WatermarkGui = Instance.new("ScreenGui")
    WatermarkGui.Name = "BloxFruitsHub_Watermark"
    WatermarkGui.ResetOnSpawn = false
    WatermarkGui.DisplayOrder = 999998
    WatermarkGui.Parent = PlayerGui

    local WatermarkFrame = Instance.new("Frame")
    WatermarkFrame.Size = UDim2.new(0, 160, 0, 30)
    WatermarkFrame.Position = UDim2.new(0, 15, 0, 15)
    WatermarkFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    WatermarkFrame.BorderSizePixel = 0
    WatermarkFrame.Parent = WatermarkGui
    Instance.new("UICorner", WatermarkFrame).CornerRadius = UDim.new(0, 6)

    local WatermarkText = Instance.new("TextLabel")
    WatermarkText.Size = UDim2.new(1, 0, 1, 0)
    WatermarkText.BackgroundTransparency = 1
    WatermarkText.Font = Enum.Font.GothamBold
    WatermarkText.TextSize = 12
    WatermarkText.TextColor3 = Color3.fromRGB(200, 200, 220)
    WatermarkText.Text = "Blox Fruits Hub"
    WatermarkText.Parent = WatermarkFrame

    -- =========================================================================
    -- ГЛАВНОЕ МЕНЮ
    -- =========================================================================
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "BloxFruitsHub_Main"
    MainGui.ResetOnSpawn = false
    MainGui.DisplayOrder = 999999
    MainGui.Parent = PlayerGui

    local MainCanvas = Instance.new("CanvasGroup")
    MainCanvas.Size = UDim2.new(0, 880, 0, 520)
    MainCanvas.Position = UDim2.new(0.5, -440, 0.5, -260)
    MainCanvas.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
    MainCanvas.BorderSizePixel = 0
    MainCanvas.GroupTransparency = 1
    MainCanvas.Parent = MainGui
    Instance.new("UICorner", MainCanvas).CornerRadius = UDim.new(0, 12)

    TweenService:Create(MainCanvas, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()

    -- Перетаскивание
    local DragFrame = Instance.new("Frame")
    DragFrame.Size = UDim2.new(1, 0, 0, 45)
    DragFrame.BackgroundTransparency = 1
    DragFrame.Active = true
    DragFrame.Parent = MainCanvas

    local dragging, dragInput, dragStart, startPos
    DragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainCanvas.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    DragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainCanvas.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Сайдбар
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 220, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainCanvas

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, 0, 0, 0)
    SidebarLine.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar

    local LogoText = Instance.new("TextLabel")
    LogoText.Size = UDim2.new(0, 180, 0, 26)
    LogoText.Position = UDim2.new(0, 20, 0, 20)
    LogoText.BackgroundTransparency = 1
    LogoText.Font = Enum.Font.GothamBold
    LogoText.TextSize = 16
    LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoText.TextXAlignment = Enum.TextXAlignment.Left
    LogoText.Text = "Blox Fruits Hub"
    LogoText.Parent = Sidebar

    local NavList = Instance.new("ScrollingFrame")
    NavList.Size = UDim2.new(1, 0, 1, -85)
    NavList.Position = UDim2.new(0, 0, 0, 75)
    NavList.BackgroundTransparency = 1
    NavList.CanvasSize = UDim2.new(0, 0, 0, 500)
    NavList.ScrollBarThickness = 0
    NavList.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Padding = UDim.new(0, 4)
    NavLayout.Parent = NavList

    -- Кнопки управления окном
    local TopControls = Instance.new("Frame")
    TopControls.Size = UDim2.new(0, 100, 0, 45)
    TopControls.Position = UDim2.new(1, -110, 0, 0)
    TopControls.BackgroundTransparency = 1
    TopControls.Parent = MainCanvas

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 165)
    CloseBtn.TextSize, CloseBtn.Font = 14, Enum.Font.GothamBold
    CloseBtn.Parent = TopControls

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainCanvas, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {GroupTransparency = 1}):Play()
        task.wait(0.25)
        MainGui:Destroy()
        WatermarkGui:Destroy()
    end)

    local ContainerWrapper = Instance.new("Frame")
    ContainerWrapper.Size = UDim2.new(1, -220, 1, -45)
    ContainerWrapper.Position = UDim2.new(0, 220, 0, 45)
    ContainerWrapper.BackgroundTransparency = 1
    ContainerWrapper.Parent = MainCanvas

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    MinimizeBtn.Position = UDim2.new(1, -68, 0.5, -14)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(150, 150, 165)
    MinimizeBtn.TextSize, MinimizeBtn.Font = 14, Enum.Font.GothamBold
    MinimizeBtn.Parent = TopControls

    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            ContainerWrapper.Visible = false
            Sidebar.Visible = false
            TweenService:Create(MainCanvas, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 880, 0, 45)
            }):Play()
            MinimizeBtn.Text = "+"
        else
            TweenService:Create(MainCanvas, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 880, 0, 520)
            }):Play()
            task.wait(0.15)
            Sidebar.Visible = true
            ContainerWrapper.Visible = true
            MinimizeBtn.Text = "-"
        end
    end)

    -- Страницы
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -20, 1, -15)
    ContentArea.Position = UDim2.new(0, 10, 0, 10)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = ContainerWrapper

    local pages = {}
    local activePage = nil

    local function createPage(name)
        local page = Instance.new("ScrollingFrame")
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.CanvasSize = UDim2.new(0, 0, 0, 1400)
        page.ScrollBarThickness = 3
        page.Visible = false
        page.Parent = ContentArea

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 10)
        layout.Parent = page

        pages[name] = page
        return page
    end

    local farmPage = createPage("Farm")
    local tpPage = createPage("Teleport")
    local bossPage = createPage("Bosses")
    local fruitPage = createPage("Fruits")
    local seaPage = createPage("Sea")
    local charPage = createPage("Character")
    local pvpPage = createPage("PvP")
    local miscPage = createPage("Misc")

    local function switchPage(targetPage)
        if activePage == targetPage then return end
        for _, p in pairs(pages) do p.Visible = false end
        activePage = targetPage
        targetPage.Visible = true
    end

    local function createTab(displayName, targetPage)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -16, 0, 38)
        btn.Position = UDim2.new(0, 8, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        btn.BackgroundTransparency = 1
        btn.Text = "   " .. displayName
        btn.TextColor3 = Color3.fromRGB(150, 150, 165)
        btn.TextSize, btn.Font = 13, Enum.Font.GothamMedium
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = NavList
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        btn.MouseButton1Click:Connect(function()
            for _, b in ipairs(NavList:GetChildren()) do
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(b, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 165)}):Play()
                end
            end
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            switchPage(targetPage)
        end)
    end

    createTab("Auto Farm", farmPage)
    createTab("Teleport", tpPage)
    createTab("Bosses & Raids", bossPage)
    createTab("Devil Fruits", fruitPage)
    createTab("Sea Events", seaPage)
    createTab("Character", charPage)
    createTab("PvP & Combat", pvpPage)
    createTab("Misc & Server", miscPage)

    farmPage.Visible = true
    activePage = farmPage

    local function createCard(page, titleText, descText)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -10, 0, 85)
        card.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        card.BorderSizePixel = 0
        card.Parent = page
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -30, 0, 22)
        title.Position = UDim2.new(0, 16, 0, 14)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Text = titleText
        title.Parent = card

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -30, 0, 20)
        desc.Position = UDim2.new(0, 16, 0, 40)
        desc.BackgroundTransparency = 1
        desc.Font = Enum.Font.Gotham
        desc.TextSize, desc.TextColor3 = 12, Color3.fromRGB(140, 140, 155)
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Text = descText
        desc.Parent = card

        return card
    end

    local function createToggle(page, text, desc, callback)
        local card = createCard(page, text, desc)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 90, 0, 32)
        btn.Position = UDim2.new(1, -105, 0.5, -16)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        btn.Text = "OFF"
        btn.TextColor3 = Color3.fromRGB(180, 180, 195)
        btn.TextSize, btn.Font = 12, Enum.Font.GothamBold
        btn.Parent = card
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = state and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(30, 30, 40),
                TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 195)
            }):Play()
            btn.Text = state and "ON" or "OFF"
            callback(state)
        end)
    end

    -- =========================================================================
    -- КАТЕГОРИЯ 1: АВТОМАТИЧЕСКИЙ ФАРМ
    -- =========================================================================
    createToggle(farmPage, "1. Auto Farm Level", "Checks level, gets quests, teleports, and kills mobs automatically.", function(st) end)
    createToggle(farmPage, "2. Auto Farm Mastery (Sword/Gun)", "Attacks enemies and finishes them with selected weapon skill.", function(st) end)
    createToggle(farmPage, "3. Auto Farm Mastery (Devil Fruit)", "Uses fruit abilities against groups of mobs to unlock Z, X, C, V, F.", function(st) end)
    createToggle(farmPage, "4. Bring Mobs / Aggro Mobs", "Brings all mobs in radius directly to character position.", function(st) end)
    createToggle(farmPage, "5. Fast Attack (No CoolDown)", "Removes attack animations and delays for ultra-fast striking.", function(st) end)
    createToggle(farmPage, "6. Auto Farm Bones", "Farms skeletons on Cursed Ship in Third Sea for bones.", function(st) end)
    createToggle(farmPage, "7. Auto Farm Candy / Cocoa", "Collects event items like cocoa beans on Chocolate Island.", function(st) end)
    createToggle(farmPage, "8. Auto Elite Hunter", "Finds Elite Pirates, takes quest, teleports and defeats them.", function(st) end)
    createToggle(farmPage, "9. Auto Cake Prince / Dough King", "Kills 500 mobs on Cake Island and defeats spawned boss.", function(st) end)
    createToggle(farmPage, "10. Auto Third Sea / Second Sea Quest", "Automates world transition quests.", function(st) end)

    -- =========================================================================
    -- КАТЕГОРИЯ 2: ТЕЛЕПОРТАЦИЯ И НАВИГАЦИЯ
    -- =========================================================================
    createToggle(tpPage, "1. Teleport to Islands", "Instant teleportation to any selected island in current sea.", function(st) end)
    createToggle(tpPage, "2. Teleport to NPCs", "Teleports to specific merchants, quest givers, or trainers.", function(st) end)
    createToggle(tpPage, "3. Safe Teleport (Tween)", "Smooth high-speed movement through textures to bypass anti-cheat.", function(st) end)
    createToggle(tpPage, "4. Bypass Anti-Cheat Teleport", "Special movement algorithm with micro-pauses.", function(st) end)
    createToggle(tpPage, "5. Teleport to Sea 1 / 2 / 3", "Direct server travel between First, Second, and Third Seas.", function(st) end)

    -- =========================================================================
    -- КАТЕГОРИЯ 3: БОССЫ И РЕЙДЫ
    -- =========================================================================
    createToggle(bossPage, "1. Auto Kill All Bosses", "Scans server for live bosses, teleports and kills them.", function(st) end)
    createToggle(bossPage, "2. Auto Saber Expert", "Completes Saber sword quest in First Sea automatically.", function(st) end)
    createToggle(bossPage, "3. Auto Bartilo Quest", "Completes Bartilo quest in Second Sea for Coliseum access.", function(st) end)
    createToggle(bossPage, "4. Auto Raid (Law / Order)", "Buys chip, runs Law raid and defeats him quickly.", function(st) end)
    createToggle(bossPage, "5. Auto Fully Awaken Fruit", "Runs standard raids, farms fragments, and buys awakenings.", function(st) end)
    createToggle(bossPage, "6. Auto Rengoku / Yama / Tushita", "Automates conditions for legendary swords.", function(st) end)
    createToggle(bossPage, "7. Auto Cursed Dual Katana (CDK)", "Completes heavy scrolls and quests for CDK.", function(st) end)
    createToggle(bossPage, "8. Auto Soul Guitar", "Completes nighttime candle and puzzle quest in Third Sea.", function(st) end)

    -- =========================================================================
    -- КАТЕГОРИЯ 4: УПРАВЛЕНИЕ ДЬЯВОЛЬСКИМИ ФРУКТАМИ
    -- =========================================================================
    createToggle(fruitPage, "1. Fruit Sniper (Auto Buy)", "Monitors fruit shop and buys selected fruit for beli.", function(st) end)
    createToggle(fruitPage, "2. Auto Random Fruit (Gacha)", "Buys random fruit from Gacha every 2 hours.", function(st) end)
    createToggle(fruitPage, "3. Fruit Finder / Tracker", "Scans map for spawned fruits and highlights them.", function(st) end)
    createToggle(fruitPage, "4. Auto Bring Fruits", "Collects all dropped fruits on server directly to hands.", function(st) end)
    createToggle(fruitPage, "5. Auto Store Fruits", "Stores all held fruits into permanent inventory storage.", function(st) end)

    -- =========================================================================
    -- КАТЕГОРИЯ 5: МОРСКИЕ АКТИВНОСТИ И ИВЕНТЫ
    -- =========================================================================
    createToggle(seaPage, "1. Auto Sea Beast (SB) Farm", "Waits for Sea Beasts and destroys them for beli and fragments.", function(st) end)
    createToggle(seaPage, "2. Auto Ship Raid", "Finds and destroys attacking pirate ships in open sea.", function(st) end)
    createToggle(seaPage, "3. Auto Leviathan", "Finds Frozen Dimension, summons Leviathan, and destroys segments.", function(st) end)
    createToggle(seaPage, "4. Auto Mirage Island Hunter", "Finds Mirage Island in fog and activates moon look mechanic.", function(st) end)
    createToggle(seaPage, "5. Auto Chest Mirage", "Instant collection of all chests on Mirage Island.", function(st) end)

    -- =========================================================================
    -- КАТЕГОРИЯ 6: АВТОМАТИЗАЦИЯ ПЕРСОНАЖА
    -- =========================================================================
    createToggle(charPage, "1. Auto Stats Distribution", "Automatically distributes stat points by priority.", function(st) end)
    createToggle(charPage, "2. Auto Buy Fighting Styles", "Buys new fighting styles when requirements are met.", function(st) end)
    createToggle(charPage, "3. Auto Ken Haki / Buso Haki Train", "Trains Observation and Buso Haki to maximum level.", function(st) end)
    createToggle(charPage, "4. Auto Observation V2", "Completes quests on Turtle Island to upgrade Observation Haki.", function(st) end)
    createToggle(charPage, "5. Auto Race V2 / V3 / V4", "Automates flowers, boss kills, and Time Temple trials.", function(st) end)

    -- =========================================================================
    -- КАТЕГОРИЯ 7: PVP И ТЮНИНГ БОЯ
    -- =========================================================================
    createToggle(pvpPage, "1. Aimbot Skill / Gun", "Aims skills and guns automatically at players or mobs.", function(st) end)
    createToggle(pvpPage, "2. Player ESP / Wallhack", "Highlights player silhouettes, health, distance, and fruit.", function(st) end)
    createToggle(pvpPage, "3. Auto Bounty Farm", "Teleports to players, uses combos, and kills for bounty.", function(st) end)
    createToggle(pvpPage, "4. No Clip", "Disables collision to walk through walls and mountains.", function(st) end)
    createToggle(pvpPage, "5. Infinite Geppo (Skyjump)", "Allows infinite mid-air jumps without energy cost.", function(st) end)
    createToggle(pvpPage, "6. Infinite Energy", "Freezes energy meter for endless dashes and heavy attacks.", function(st) end)
    createToggle(pvpPage, "7. Walk on Water / Jesus Fly", "Allows walking or flying over water without taking damage.", function(st) end)

    -- =========================================================================
    -- КАТЕГОРИЯ 8: УТИЛИТЫ И СЕРВЕР
    -- =========================================================================
    createToggle(miscPage, "1. Auto Farm Chests", "Teleports to all chest spawn points for starter capital.", function(st) end)
    createToggle(miscPage, "2. Server Hop (Low Player / Fruit)", "Switches to another server with low player count.", function(st) end)
    createToggle(miscPage, "3. Rejoin Server", "Instantly reloads and reconnects to the exact same server.", function(st) end)
    createToggle(miscPage, "4. White Screen / CPU Optimizer", "Disables 3D rendering to reduce CPU and GPU load.", function(st) end)
    createToggle(miscPage, "5. Anti-AFK Kick", "Simulates micro-movements to prevent AFK disconnection.", function(st) end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            MainCanvas.Visible = not MainCanvas.Visible
        end
    end)
end

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyTextBox.Text == "2026" then
        SubmitBtn.Text = "SUCCESS!"
        SubmitBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
        task.wait(0.5)
        startMainHub()
    else
        SubmitBtn.Text = "INVALID KEY!"
        SubmitBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
        task.wait(1)
        SubmitBtn.Text = "SUBMIT KEY"
        SubmitBtn.TextColor3 = Color3.fromRGB(200, 200, 215)
    end
end)
