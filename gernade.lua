-- SCRIPT MADE BY s9gd + MODIFIED
-- 💣 BOMBER CENTRAL 💣 (SLAVE VERSION - For your friend to run)
-- This script listens for commands from ADMIN ID: 238548728
-- Commands: .nuke name, .fly on/off, .ban, .b (bring to admin)
-- Press V to rejoin | Press Right Shift to hide UI

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local running = true
local nuking = false
local uiVisible = true

local ADMIN_ID = 238548728  -- The main account that sends commands

-- ============== PREMIUM UI DESIGN ==============
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui
gui.Name = "BomberCentral"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 380)
frame.Position = UDim2.new(1, -400, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = gui
frame.Visible = uiVisible

-- Glass effect background
local glass = Instance.new("Frame")
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.95
glass.BorderSizePixel = 0
glass.Parent = frame

-- Gradient overlay
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 220))
})
gradient.Rotation = 45
gradient.Transparency = NumberSequence.new(0.95)
gradient.Parent = glass

-- Outer glow
local glow = Instance.new("ImageLabel")
glow.Size = UDim2.new(1, 40, 1, 40)
glow.Position = UDim2.new(0, -20, 0, -20)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://5028857084"
glow.ImageColor3 = Color3.fromRGB(255, 215, 0)
glow.ImageTransparency = 0.7
glow.ScaleType = Enum.ScaleType.Slice
glow.SliceCenter = Rect.new(20, 20, 20, 20)
glow.Parent = frame

-- Main corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = frame

-- Animated border
local border = Instance.new("Frame")
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 3
border.BorderColor3 = Color3.fromRGB(255, 215, 0)
border.Parent = frame

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 20)
borderCorner.Parent = border

-- Animate border
task.spawn(function()
    local t = 0
    while running do
        t = t + 0.016
        border.BorderColor3 = Color3.fromRGB(255, 215, 0):lerp(Color3.fromRGB(255, 255, 255), math.abs(math.sin(t * 2)))
        task.wait(0.05)
    end
end)

-- ============== HEADER SECTION ==============
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -20, 0, 70)
header.Position = UDim2.new(0, 10, 0, 10)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

local headerGlow = Instance.new("Frame")
headerGlow.Size = UDim2.new(1, 0, 1, 0)
headerGlow.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
headerGlow.BackgroundTransparency = 0.9
headerGlow.BorderSizePixel = 0
headerGlow.Parent = header

local headerGlowCorner = Instance.new("UICorner")
headerGlowCorner.CornerRadius = UDim.new(0, 15)
headerGlowCorner.Parent = headerGlow

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0.5, -25)
logo.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
logo.BackgroundTransparency = 0.8
logo.Text = "💣"
logo.TextColor3 = Color3.fromRGB(255, 215, 0)
logo.TextSize = 30
logo.Font = Enum.Font.GothamBold
logo.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logo

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 70, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "BOMBER CENTRAL"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -80, 0, 20)
subtitle.Position = UDim2.new(0, 70, 0, 40)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "SLAVE CLIENT"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 220)
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- Status indicator
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 12, 0, 12)
statusDot.Position = UDim2.new(1, -25, 0.5, -6)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
statusDot.BorderSizePixel = 0
statusDot.Parent = header

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = statusDot

-- Pulsing animation
task.spawn(function()
    while running do
        statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100):lerp(Color3.fromRGB(255, 215, 0), math.abs(math.sin(tick() * 3)))
        task.wait(0.1)
    end
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    uiVisible = false
end)

-- ============== CONTENT ROW ==============
local contentRow = Instance.new("Frame")
contentRow.Size = UDim2.new(1, -20, 0, 200)
contentRow.Position = UDim2.new(0, 10, 0, 90)
contentRow.BackgroundTransparency = 1
contentRow.Parent = frame

-- ============== LEFT PANEL (AVATAR) ==============
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 140, 1, 0)
leftPanel.Position = UDim2.new(0, 0, 0, 0)
leftPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
leftPanel.BackgroundTransparency = 0.2
leftPanel.BorderSizePixel = 0
leftPanel.Parent = contentRow

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 15)
leftCorner.Parent = leftPanel

-- Avatar with neon effect
local avatarContainer = Instance.new("Frame")
avatarContainer.Size = UDim2.new(0, 100, 0, 100)
avatarContainer.Position = UDim2.new(0.5, -50, 0, 15)
avatarContainer.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
avatarContainer.BackgroundTransparency = 0.3
avatarContainer.BorderSizePixel = 0
avatarContainer.Parent = leftPanel

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarContainer

local avatarGlow = Instance.new("Frame")
avatarGlow.Size = UDim2.new(1, 8, 1, 8)
avatarGlow.Position = UDim2.new(0, -4, 0, -4)
avatarGlow.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
avatarGlow.BackgroundTransparency = 0.7
avatarGlow.BorderSizePixel = 0
avatarGlow.Parent = avatarContainer

local avatarGlowCorner = Instance.new("UICorner")
avatarGlowCorner.CornerRadius = UDim.new(1, 0)
avatarGlowCorner.Parent = avatarGlow

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(1, -4, 1, -4)
avatar.Position = UDim2.new(0, 2, 0, 2)
avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
avatar.BorderSizePixel = 0
avatar.Parent = avatarContainer

local avatarImageCorner = Instance.new("UICorner")
avatarImageCorner.CornerRadius = UDim.new(1, 0)
avatarImageCorner.Parent = avatar

-- User info
local userName = Instance.new("TextLabel")
userName.Size = UDim2.new(1, -20, 0, 25)
userName.Position = UDim2.new(0, 10, 0, 125)
userName.BackgroundTransparency = 1
userName.Font = Enum.Font.GothamBold
userName.Text = player.Name
userName.TextColor3 = Color3.fromRGB(255, 255, 255)
userName.TextSize = 14
userName.TextXAlignment = Enum.TextXAlignment.Center
userName.Parent = leftPanel

local userStatus = Instance.new("TextLabel")
userStatus.Size = UDim2.new(1, -20, 0, 20)
userStatus.Position = UDim2.new(0, 10, 0, 150)
userStatus.BackgroundTransparency = 1
userStatus.Font = Enum.Font.Gotham
userStatus.Text = "● LISTENING FOR ADMIN"
userStatus.TextColor3 = Color3.fromRGB(255, 215, 0)
userStatus.TextSize = 10
userStatus.TextXAlignment = Enum.TextXAlignment.Center
userStatus.Parent = leftPanel

-- ============== RIGHT PANEL (TARGET INFO) ==============
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1, -160, 1, 0)
rightPanel.Position = UDim2.new(0, 150, 0, 0)
rightPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
rightPanel.BackgroundTransparency = 0.2
rightPanel.BorderSizePixel = 0
rightPanel.Parent = contentRow

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 15)
rightCorner.Parent = rightPanel

-- Target section
local targetHeader = Instance.new("Frame")
targetHeader.Size = UDim2.new(1, -20, 0, 30)
targetHeader.Position = UDim2.new(0, 10, 0, 10)
targetHeader.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
targetHeader.BackgroundTransparency = 0.8
targetHeader.BorderSizePixel = 0
targetHeader.Parent = rightPanel

local targetHeaderCorner = Instance.new("UICorner")
targetHeaderCorner.CornerRadius = UDim.new(0, 10)
targetHeaderCorner.Parent = targetHeader

local targetIcon = Instance.new("TextLabel")
targetIcon.Size = UDim2.new(0, 30, 1, 0)
targetIcon.BackgroundTransparency = 1
targetIcon.Font = Enum.Font.GothamBold
targetIcon.Text = "🎯"
targetIcon.TextColor3 = Color3.fromRGB(255, 215, 0)
targetIcon.TextSize = 18
targetIcon.Parent = targetHeader

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -40, 1, 0)
targetLabel.Position = UDim2.new(0, 30, 0, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.Font = Enum.Font.GothamBold
targetLabel.Text = "CURRENT TARGET"
targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
targetLabel.TextSize = 14
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = targetHeader

local targetText = Instance.new("TextLabel")
targetText.Size = UDim2.new(1, -20, 0, 30)
targetText.Position = UDim2.new(0, 10, 0, 45)
targetText.BackgroundTransparency = 1
targetText.Font = Enum.Font.GothamBold
targetText.Text = "None"
targetText.TextColor3 = Color3.fromRGB(255, 215, 0)
targetText.TextSize = 20
targetText.TextXAlignment = Enum.TextXAlignment.Left
targetText.Parent = rightPanel

-- Health section
local healthHeader = Instance.new("Frame")
healthHeader.Size = UDim2.new(1, -20, 0, 25)
healthHeader.Position = UDim2.new(0, 10, 0, 85)
healthHeader.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
healthHeader.BackgroundTransparency = 0.85
healthHeader.BorderSizePixel = 0
healthHeader.Parent = rightPanel

local healthHeaderCorner = Instance.new("UICorner")
healthHeaderCorner.CornerRadius = UDim.new(0, 8)
healthHeaderCorner.Parent = healthHeader

local healthIcon = Instance.new("TextLabel")
healthIcon.Size = UDim2.new(0, 25, 1, 0)
healthIcon.BackgroundTransparency = 1
healthIcon.Font = Enum.Font.GothamBold
healthIcon.Text = "❤️"
healthIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
healthIcon.TextSize = 14
healthIcon.Parent = healthHeader

local healthLabel = Instance.new("TextLabel")
healthLabel.Size = UDim2.new(1, -35, 1, 0)
healthLabel.Position = UDim2.new(0, 25, 0, 0)
healthLabel.BackgroundTransparency = 1
healthLabel.Font = Enum.Font.Gotham
healthLabel.Text = "HEALTH"
healthLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
healthLabel.TextSize = 12
healthLabel.TextXAlignment = Enum.TextXAlignment.Left
healthLabel.Parent = healthHeader

local healthBack = Instance.new("Frame")
healthBack.Size = UDim2.new(1, -20, 0, 12)
healthBack.Position = UDim2.new(0, 10, 0, 115)
healthBack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
healthBack.BorderSizePixel = 0
healthBack.Parent = rightPanel

local healthBackCorner = Instance.new("UICorner")
healthBackCorner.CornerRadius = UDim.new(0, 6)
healthBackCorner.Parent = healthBack

local healthBar = Instance.new("Frame")
healthBar.Size = UDim2.new(1, 0, 1, 0)
healthBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
healthBar.BorderSizePixel = 0
healthBar.Parent = healthBack

local healthBarCorner = Instance.new("UICorner")
healthBarCorner.CornerRadius = UDim.new(0, 6)
healthBarCorner.Parent = healthBar

-- Grenade section
local grenadeHeader = Instance.new("Frame")
grenadeHeader.Size = UDim2.new(1, -20, 0, 25)
grenadeHeader.Position = UDim2.new(0, 10, 0, 140)
grenadeHeader.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
grenadeHeader.BackgroundTransparency = 0.85
grenadeHeader.BorderSizePixel = 0
grenadeHeader.Parent = rightPanel

local grenadeHeaderCorner = Instance.new("UICorner")
grenadeHeaderCorner.CornerRadius = UDim.new(0, 8)
grenadeHeaderCorner.Parent = grenadeHeader

local grenadeIcon = Instance.new("TextLabel")
grenadeIcon.Size = UDim2.new(0, 25, 1, 0)
grenadeIcon.BackgroundTransparency = 1
grenadeIcon.Font = Enum.Font.GothamBold
grenadeIcon.Text = "💣"
grenadeIcon.TextColor3 = Color3.fromRGB(255, 215, 0)
grenadeIcon.TextSize = 14
grenadeIcon.Parent = grenadeHeader

local grenadeLabel = Instance.new("TextLabel")
grenadeLabel.Size = UDim2.new(1, -35, 1, 0)
grenadeLabel.Position = UDim2.new(0, 25, 0, 0)
grenadeLabel.BackgroundTransparency = 1
grenadeLabel.Font = Enum.Font.Gotham
grenadeLabel.Text = "GRENADES"
grenadeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
grenadeLabel.TextSize = 12
grenadeLabel.TextXAlignment = Enum.TextXAlignment.Left
grenadeLabel.Parent = grenadeHeader

local grenadeCount = Instance.new("TextLabel")
grenadeCount.Size = UDim2.new(1, -20, 0, 30)
grenadeCount.Position = UDim2.new(0, 10, 0, 165)
grenadeCount.BackgroundTransparency = 1
grenadeCount.Font = Enum.Font.GothamBold
grenadeCount.Text = "0"
grenadeCount.TextColor3 = Color3.fromRGB(255, 215, 0)
grenadeCount.TextSize = 24
grenadeCount.TextXAlignment = Enum.TextXAlignment.Left
grenadeCount.Parent = rightPanel

-- ============== BOTTOM PANEL (KEYBINDS INFO) ==============
local bottomPanel = Instance.new("Frame")
bottomPanel.Size = UDim2.new(1, -20, 0, 60)
bottomPanel.Position = UDim2.new(0, 10, 1, -70)
bottomPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
bottomPanel.BackgroundTransparency = 0.1
bottomPanel.BorderSizePixel = 0
bottomPanel.Parent = frame

local bottomCorner = Instance.new("UICorner")
bottomCorner.CornerRadius = UDim.new(0, 15)
bottomCorner.Parent = bottomPanel

local bottomGlow = Instance.new("Frame")
bottomGlow.Size = UDim2.new(1, 0, 1, 0)
bottomGlow.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
bottomGlow.BackgroundTransparency = 0.95
bottomGlow.BorderSizePixel = 0
bottomGlow.Parent = bottomPanel

local bottomGlowCorner = Instance.new("UICorner")
bottomGlowCorner.CornerRadius = UDim.new(0, 15)
bottomGlowCorner.Parent = bottomGlow

-- Keybinds text
local keybindsText = Instance.new("TextLabel")
keybindsText.Size = UDim2.new(1, -20, 1, 0)
keybindsText.Position = UDim2.new(0, 10, 0, 0)
keybindsText.BackgroundTransparency = 1
keybindsText.Font = Enum.Font.Gotham
keybindsText.TextColor3 = Color3.fromRGB(200, 200, 220)
keybindsText.TextSize = 14
keybindsText.TextXAlignment = Enum.TextXAlignment.Left
keybindsText.Text = "Z - Buy Grenades   |   E - Throw All   |   V - Rejoin   |   Right Shift - Hide"
keybindsText.Parent = bottomPanel

-- Admin info
local adminLabel = Instance.new("TextLabel")
adminLabel.Size = UDim2.new(1, -20, 0, 20)
adminLabel.Position = UDim2.new(0, 10, 0, 30)
adminLabel.BackgroundTransparency = 1
adminLabel.Font = Enum.Font.Gotham
adminLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
adminLabel.TextSize = 12
adminLabel.TextXAlignment = Enum.TextXAlignment.Left
adminLabel.Text = "👑 Listening for Admin ID: 238548728"
adminLabel.Parent = bottomPanel

-- Make frame draggable
local dragging = false
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Right Shift to hide/show UI
UIS.InputBegan:Connect(function(input, typing)
    if typing then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        frame.Visible = uiVisible
    end
end)

-- ============== SCRIPT FUNCTIONALITY ==============
local grenadeModel = workspace.Ignored.Shop["[Grenade] - $788"]
local grenadePart = grenadeModel:FindFirstChildWhichIsA("BasePart", true)
local clickDetector = grenadeModel:FindFirstChildWhichIsA("ClickDetector", true)

local function getGrenadeCount()
    local count = 0
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v.Name:lower():find("grenade") then count += 1 end
    end
    if player.Character then
        for _,v in pairs(player.Character:GetChildren()) do
            if v.Name:lower():find("grenade") then count += 1 end
        end
    end
    return count
end

-- Update grenade counter
task.spawn(function()
    while running do
        grenadeCount.Text = getGrenadeCount()
        task.wait(0.25)
    end
end)

local function buyGrenades(amount)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local old = root.CFrame
    root.CFrame = grenadePart.CFrame + Vector3.new(0,3,0)
    task.wait(0.2)
    while getGrenadeCount() < amount do
        fireclickdetector(clickDetector)
        task.wait(0.1)
    end
    root.CFrame = old
end

local function throwAll()
    local char = player.Character
    if not char then return end
    for _,tool in pairs(player.Backpack:GetChildren()) do
        if tool.Name:lower():find("grenade") then
            tool.Parent = char
            task.spawn(function()
                for i=1,4 do tool:Activate(); task.wait(0.05) end
            end)
        end
    end
end

local function rejoinServer()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end

-- COMMAND FUNCTIONS (what happens when admin speaks)
local function bringToAdmin(adminPlayer)
    if not adminPlayer then return end
    
    local adminChar = adminPlayer.Character
    if not adminChar then return end
    
    local adminRoot = adminChar:FindFirstChild("HumanoidRootPart")
    if not adminRoot then return end
    
    local myChar = player.Character
    if not myChar then return end
    
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    -- Teleport to admin
    myRoot.CFrame = adminRoot.CFrame * CFrame.new(0, 0, -3)
    
    -- Show notification
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 200, 0, 40)
    notif.Position = UDim2.new(0.5, -100, 0, 100)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    notif.BorderSizePixel = 0
    notif.Parent = gui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, 0, 1, 0)
    notifText.BackgroundTransparency = 1
    notifText.Font = Enum.Font.GothamBold
    notifText.Text = "🚀 TELEPORTED TO ADMIN"
    notifText.TextColor3 = Color3.fromRGB(255, 215, 0)
    notifText.TextSize = 12
    notifText.Parent = notif
    
    task.wait(2)
    notif:Destroy()
end

local function banMe()
    player:Kick("You have been banned by admin")
end

local targetHum

local function setTarget(plr)
    if not plr then
        targetText.Text = "None"
        avatar.Image = ""
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        return
    end
    targetText.Text = plr.Name
    local success, img = pcall(function()
        return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    if success then avatar.Image = img end
    local char = plr.Character
    if char then targetHum = char:FindFirstChildOfClass("Humanoid") end
end

task.spawn(function()
    while running do
        if targetHum and targetHum.Parent then
            local hp = targetHum.Health
            local max = targetHum.MaxHealth
            healthBar.Size = UDim2.new(hp/max, 0, 1, 0)
        end
        task.wait(0.1)
    end
end)

local function executeNuke(target)
    if nuking then return end
    nuking = true
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    setTarget(target)
    if getGrenadeCount() < 10 then buyGrenades(10) end
    local old = root.CFrame
    root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
    task.wait(0.15)
    throwAll()
    task.wait(0.4)
    root.CFrame = old
    setTarget(nil)
    nuking = false
end

local function findPlayer(str)
    str = str:lower()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(str) or plr.DisplayName:lower():find(str) then
            return plr
        end
    end
end

local flyEnabled = false
local function flyOn()
    if flyEnabled then return end
    flyEnabled = true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Not-Kyle/Dahood-scripts/refs/heads/main/Fly.lua"))()
end
local function flyOff()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        for _, v in pairs(root:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
        end
    end
    flyEnabled = false
end

-- Keybinds
UIS.InputBegan:Connect(function(input, typing)
    if typing then return end
    if input.KeyCode == Enum.KeyCode.Z then buyGrenades(10) end
    if input.KeyCode == Enum.KeyCode.E then throwAll() end
    if input.KeyCode == Enum.KeyCode.V then running = false; rejoinServer() end
end)

-- LISTEN FOR ADMIN COMMANDS IN CHAT
TextChatService.OnIncomingMessage = function(msg)
    local src = msg.TextSource
    if not src then return end
    
    local plr = Players:GetPlayerByUserId(src.UserId)
    if not plr then return end
    
    -- ONLY LISTEN TO THE ADMIN (ID: 238548728)
    if plr.UserId ~= ADMIN_ID then return end
    
    local text = msg.Text:lower()
    print("ADMIN COMMAND DETECTED:", text) -- For debugging

    -- .nuke command
    if text:sub(1, 5) == ".nuke" then
        local name = msg.Text:sub(7)
        local target = findPlayer(name)
        if target then 
            print("NUKING:", target.Name)
            executeNuke(target) 
        end
        
    -- .fly command
    elseif text:sub(1, 4) == ".fly" then
        local arg = text:sub(6)
        if arg == "on" then 
            print("FLY ON")
            flyOn() 
        elseif arg == "off" then 
            print("FLY OFF")
            flyOff() 
        end
        
    -- .ban command - KICK THIS PLAYER
    elseif text:sub(1, 4) == ".ban" then
        print("BANNED BY ADMIN")
        banMe()
        
    -- .b command - BRING THIS PLAYER TO ADMIN
    elseif text:sub(1, 2) == ".b" and #text == 2 then
        print("TELEPORTING TO ADMIN")
        bringToAdmin(plr)
    end
end

-- Notify loaded
local notify = Instance.new("Frame")
notify.Size = UDim2.new(0, 300, 0, 60)
notify.Position = UDim2.new(0.5, -150, 0, -100)
notify.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
notify.BorderSizePixel = 0
notify.Parent = gui

local notifyCorner = Instance.new("UICorner")
notifyCorner.CornerRadius = UDim.new(0, 15)
notifyCorner.Parent = notify

local notifyText = Instance.new("TextLabel")
notifyText.Size = UDim2.new(1, 0, 1, 0)
notifyText.BackgroundTransparency = 1
notifyText.Font = Enum.Font.GothamBold
notifyText.Text = "💣 BOMBER CENTRAL - LISTENING FOR ADMIN"
notifyText.TextColor3 = Color3.fromRGB(255, 215, 0)
notifyText.TextSize = 14
notifyText.Parent = notify

-- Animate notification
local goal = {Position = UDim2.new(0.5, -150, 0, 20)}
local tween = TweenService:Create(notify, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), goal)
tween:Play()
task.wait(2)
local hideGoal = {Position = UDim2.new(0.5, -150, 0, -100)}
local hideTween = TweenService:Create(notify, TweenInfo.new(0.3), hideGoal)
hideTween:Play()
task.wait(0.3)
notify:Destroy()
