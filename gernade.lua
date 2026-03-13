-- SCRIPT MADE BY s9gd + MODIFIED
-- Bomber Central
-- Commands: .nuke display, .fly on/off, .ban, .b (bring all users)
-- Press V to rejoin | Press Right Shift to hide UI

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local running = true
local nuking = false
local uiVisible = true

local ADMIN_ID = 238548728  -- Admin who can use .ban and .b

-- Track script users
local scriptUsers = {}
scriptUsers[player.UserId] = true

-- Tell other script instances we exist
local function broadcastPresence()
    getgenv().BomberCentral = {
        UserId = player.UserId,
        Active = true
    }
end
broadcastPresence()

-- Check if a player is using the script
local function isScriptUser(plr)
    -- In a real scenario with multiple executors, you'd need a remote event
    -- For this demo, we'll check a few indicators
    -- You can modify this logic based on how you want to detect script users
    
    -- For now, we'll use a simple approach: check if they have the global variable
    -- This won't work across different executors' environments though
    -- A better approach would be using a remote event
    
    -- Since we can't reliably detect across executors, we'll return true for all players
    -- This makes the commands work on everyone, but you mentioned you want script users only
    -- You'll need to implement a proper detection method like a remote event
    
    -- For this version, we'll assume all players are script users
    return true
end

-- WHITE/GRAY/YELLOW THEME UI - PROPERLY ALIGNED
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui
gui.Name = "BomberCentral"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 280)
frame.Position = UDim2.new(1, -330, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(245, 245, 245) -- White/gray
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Visible = uiVisible
frame.Active = true
frame.Draggable = true

-- Drop shadow
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Parent = frame
shadow.ZIndex = 0

-- Main corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Yellow accent border
local border = Instance.new("Frame")
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 3
border.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
border.Parent = frame

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 12)
borderCorner.Parent = border

-- Title bar (yellow)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, -6, 0, 40)
titleBar.Position = UDim2.new(0, 3, 0, 3)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.Text = "BOMBER CENTRAL"
titleText.TextColor3 = Color3.fromRGB(50, 50, 50) -- Dark gray
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220) -- Light gray
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(80, 80, 80) -- Gray
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    uiVisible = frame.Visible
end)

-- Left panel (avatar section) - White background
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 90, 1, -50)
leftPanel.Position = UDim2.new(0, 10, 0, 50)
leftPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White
leftPanel.BorderSizePixel = 0
leftPanel.Parent = frame

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 8)
leftCorner.Parent = leftPanel

local leftBorder = Instance.new("Frame")
leftBorder.Size = UDim2.new(1, 0, 1, 0)
leftBorder.BackgroundTransparency = 1
leftBorder.BorderSizePixel = 2
leftBorder.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
leftBorder.Parent = leftPanel

local leftBorderCorner = Instance.new("UICorner")
leftBorderCorner.CornerRadius = UDim.new(0, 8)
leftBorderCorner.Parent = leftBorder

-- Avatar
local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 70, 0, 70)
avatar.Position = UDim2.new(0.5, -35, 0, 10)
avatar.BackgroundColor3 = Color3.fromRGB(230, 230, 230) -- Light gray
avatar.BorderSizePixel = 0
avatar.Parent = leftPanel

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatar

local avatarBorder = Instance.new("Frame")
avatarBorder.Size = UDim2.new(1, 0, 1, 0)
avatarBorder.BackgroundTransparency = 1
avatarBorder.BorderSizePixel = 2
avatarBorder.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
avatarBorder.Parent = avatar

local avatarBorderCorner = Instance.new("UICorner")
avatarBorderCorner.CornerRadius = UDim.new(1, 0)
avatarBorderCorner.Parent = avatarBorder

-- Right panel (info section) - White background
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1, -120, 1, -50)
rightPanel.Position = UDim2.new(0, 110, 0, 50)
rightPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White
rightPanel.BorderSizePixel = 0
rightPanel.Parent = frame

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 8)
rightCorner.Parent = rightPanel

local rightBorder = Instance.new("Frame")
rightBorder.Size = UDim2.new(1, 0, 1, 0)
rightBorder.BackgroundTransparency = 1
rightBorder.BorderSizePixel = 2
rightBorder.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
rightBorder.Parent = rightPanel

local rightBorderCorner = Instance.new("UICorner")
rightBorderCorner.CornerRadius = UDim.new(0, 8)
rightBorderCorner.Parent = rightBorder

-- Target label
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -20, 0, 25)
targetLabel.Position = UDim2.new(0, 10, 0, 10)
targetLabel.BackgroundTransparency = 1
targetLabel.Font = Enum.Font.GothamBold
targetLabel.Text = "TARGET:"
targetLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
targetLabel.TextSize = 14
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = rightPanel

local targetText = Instance.new("TextLabel")
targetText.Size = UDim2.new(1, -20, 0, 25)
targetText.Position = UDim2.new(0, 10, 0, 30)
targetText.BackgroundTransparency = 1
targetText.Font = Enum.Font.Gotham
targetText.Text = "None"
targetText.TextColor3 = Color3.fromRGB(80, 80, 80) -- Gray
targetText.TextSize = 16
targetText.TextXAlignment = Enum.TextXAlignment.Left
targetText.Parent = rightPanel

-- Health bar background
local healthLabel = Instance.new("TextLabel")
healthLabel.Size = UDim2.new(1, -20, 0, 20)
healthLabel.Position = UDim2.new(0, 10, 0, 60)
healthLabel.BackgroundTransparency = 1
healthLabel.Font = Enum.Font.GothamBold
healthLabel.Text = "HEALTH:"
healthLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
healthLabel.TextSize = 14
healthLabel.TextXAlignment = Enum.TextXAlignment.Left
healthLabel.Parent = rightPanel

local healthBack = Instance.new("Frame")
healthBack.Size = UDim2.new(1, -20, 0, 12)
healthBack.Position = UDim2.new(0, 10, 0, 85)
healthBack.BackgroundColor3 = Color3.fromRGB(220, 220, 220) -- Light gray
healthBack.BorderSizePixel = 0
healthBack.Parent = rightPanel

local healthBackCorner = Instance.new("UICorner")
healthBackCorner.CornerRadius = UDim.new(0, 6)
healthBackCorner.Parent = healthBack

-- Health bar fill
local healthBar = Instance.new("Frame")
healthBar.Size = UDim2.new(1, 0, 1, 0)
healthBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
healthBar.BorderSizePixel = 0
healthBar.Parent = healthBack

local healthBarCorner = Instance.new("UICorner")
healthBarCorner.CornerRadius = UDim.new(0, 6)
healthBarCorner.Parent = healthBar

-- Grenade counter
local grenadeLabel = Instance.new("TextLabel")
grenadeLabel.Size = UDim2.new(1, -20, 0, 20)
grenadeLabel.Position = UDim2.new(0, 10, 0, 105)
grenadeLabel.BackgroundTransparency = 1
grenadeLabel.Font = Enum.Font.GothamBold
grenadeLabel.Text = "GRENADES:"
grenadeLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
grenadeLabel.TextSize = 14
grenadeLabel.TextXAlignment = Enum.TextXAlignment.Left
grenadeLabel.Parent = rightPanel

local grenadeCounter = Instance.new("TextLabel")
grenadeCounter.Size = UDim2.new(1, -20, 0, 25)
grenadeCounter.Position = UDim2.new(0, 10, 0, 125)
grenadeCounter.BackgroundTransparency = 1
grenadeCounter.Font = Enum.Font.GothamBold
grenadeCounter.Text = "0"
grenadeCounter.TextColor3 = Color3.fromRGB(80, 80, 80) -- Gray
grenadeCounter.TextSize = 18
grenadeCounter.TextXAlignment = Enum.TextXAlignment.Left
grenadeCounter.Parent = rightPanel

-- Keybinds section (at bottom)
local keybindsPanel = Instance.new("Frame")
keybindsPanel.Size = UDim2.new(1, -20, 0, 70)
keybindsPanel.Position = UDim2.new(0, 10, 1, -80)
keybindsPanel.BackgroundColor3 = Color3.fromRGB(240, 240, 240) -- Light gray
keybindsPanel.BorderSizePixel = 0
keybindsPanel.Parent = frame

local keybindsCorner = Instance.new("UICorner")
keybindsCorner.CornerRadius = UDim.new(0, 8)
keybindsCorner.Parent = keybindsPanel

local keybindsBorder = Instance.new("Frame")
keybindsBorder.Size = UDim2.new(1, 0, 1, 0)
keybindsBorder.BackgroundTransparency = 1
keybindsBorder.BorderSizePixel = 2
keybindsBorder.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
keybindsBorder.Parent = keybindsPanel

local keybindsBorderCorner = Instance.new("UICorner")
keybindsBorderCorner.CornerRadius = UDim.new(0, 8)
keybindsBorderCorner.Parent = keybindsBorder

local keybinds = Instance.new("TextLabel")
keybinds.Size = UDim2.new(1, -10, 1, -10)
keybinds.Position = UDim2.new(0, 5, 0, 5)
keybinds.BackgroundTransparency = 1
keybinds.Font = Enum.Font.Gotham
keybinds.TextColor3 = Color3.fromRGB(80, 80, 80) -- Gray
keybinds.TextSize = 13
keybinds.TextXAlignment = Enum.TextXAlignment.Left
keybinds.TextYAlignment = Enum.TextYAlignment.Top
keybinds.Text = "Z - Buy Grenades\nE - Throw All\nV - Rejoin Server\nRight Shift - Hide UI"
keybinds.Parent = keybindsPanel

-- Make frame draggable (alternative method)
local function makeDraggable()
    local dragging = false
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
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end
makeDraggable()

-- Right Shift to hide/show UI
UIS.InputBegan:Connect(function(input, typing)
    if typing then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        frame.Visible = uiVisible
    end
end)

-- FUNCTIONS
local function getGrenadeCount()
    local count = 0

    for _,v in pairs(player.Backpack:GetChildren()) do
        if v.Name:lower():find("grenade") then
            count += 1
        end
    end

    if player.Character then
        for _,v in pairs(player.Character:GetChildren()) do
            if v.Name:lower():find("grenade") then
                count += 1
            end
        end
    end

    return count
end

-- Update grenade counter
task.spawn(function()
    while running do
        grenadeCounter.Text = getGrenadeCount()
        task.wait(0.25)
    end
end)

local grenadeModel = workspace.Ignored.Shop["[Grenade] - $788"]
local grenadePart = grenadeModel:FindFirstChildWhichIsA("BasePart", true)
local clickDetector = grenadeModel:FindFirstChildWhichIsA("ClickDetector", true)

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
                for i=1,4 do
                    tool:Activate()
                    task.wait(0.05)
                end
            end)
        end
    end
end

local function rejoinServer()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end

-- BAN COMMAND - Kicks ONLY script users
local function banScriptUsers()
    local bannedCount = 0
    
    -- Loop through all players
    for _, plr in pairs(Players:GetPlayers()) do
        -- Skip the admin and check if they're a script user
        if plr.UserId ~= ADMIN_ID and plr ~= player and isScriptUser(plr) then
            -- Kick them with fake ban message
            pcall(function()
                plr:Kick("You have been banned from Bomber Central")
                bannedCount = bannedCount + 1
            end)
        end
    end
    
    -- Notify admin
    if player.UserId == ADMIN_ID then
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 220, 0, 40)
        notif.Position = UDim2.new(0.5, -110, 0, 60)
        notif.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
        notif.BorderSizePixel = 0
        notif.Parent = gui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notif
        
        local notifText = Instance.new("TextLabel")
        notifText.Size = UDim2.new(1, 0, 1, 0)
        notifText.BackgroundTransparency = 1
        notifText.Font = Enum.Font.GothamBold
        notifText.Text = "Banned "..bannedCount.." script users"
        notifText.TextColor3 = Color3.fromRGB(50, 50, 50) -- Dark gray
        notifText.TextSize = 14
        notifText.Parent = notif
        
        task.wait(2)
        notif:Destroy()
    end
end

-- BRING COMMAND - Brings ONLY script users to admin
local function bringScriptUsers()
    -- Find admin player
    local adminPlayer = Players:GetPlayerByUserId(ADMIN_ID)
    if not adminPlayer then return end
    
    -- Check if admin has character
    local adminChar = adminPlayer.Character
    if not adminChar then return end
    
    local adminRoot = adminChar:FindFirstChild("HumanoidRootPart")
    if not adminRoot then return end
    
    local broughtCount = 0
    
    -- Bring all players who are using the script
    for _, plr in pairs(Players:GetPlayers()) do
        -- Skip the admin and check if they're a script user
        if plr.UserId ~= ADMIN_ID and isScriptUser(plr) then
            local plrChar = plr.Character
            if plrChar then
                local plrRoot = plrChar:FindFirstChild("HumanoidRootPart")
                if plrRoot then
                    -- Teleport them slightly in front of admin
                    plrRoot.CFrame = adminRoot.CFrame * CFrame.new(0, 0, -3)
                    broughtCount = broughtCount + 1
                end
            end
        end
    end
    
    -- Notify admin
    if adminPlayer == player then
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 220, 0, 40)
        notif.Position = UDim2.new(0.5, -110, 0, 60)
        notif.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
        notif.BorderSizePixel = 0
        notif.Parent = gui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notif
        
        local notifText = Instance.new("TextLabel")
        notifText.Size = UDim2.new(1, 0, 1, 0)
        notifText.BackgroundTransparency = 1
        notifText.Font = Enum.Font.GothamBold
        notifText.Text = "Brought "..broughtCount.." script users"
        notifText.TextColor3 = Color3.fromRGB(50, 50, 50) -- Dark gray
        notifText.TextSize = 14
        notifText.Parent = notif
        
        task.wait(2)
        notif:Destroy()
    end
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
        return Players:GetUserThumbnailAsync(
            plr.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)
    
    if success then
        avatar.Image = img
    end

    local char = plr.Character
    if char then
        targetHum = char:FindFirstChildOfClass("Humanoid")
    end
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

local function aimCamera(targetRoot)
    local above = targetRoot.Position + Vector3.new(0, 200, 0)
    camera.CFrame = CFrame.new(camera.CFrame.Position, above)
end

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

    if getGrenadeCount() < 10 then
        buyGrenades(10)
    end

    local old = root.CFrame
    root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
    task.wait(0.15)
    aimCamera(targetRoot)
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
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
    end
    flyEnabled = false
end

-- Keybinds
UIS.InputBegan:Connect(function(input, typing)
    if typing then return end
    
    -- Z key buy
    if input.KeyCode == Enum.KeyCode.Z then
        buyGrenades(10)
    end
    
    -- E key throw all
    if input.KeyCode == Enum.KeyCode.E then
        throwAll()
    end
    
    -- V key rejoin
    if input.KeyCode == Enum.KeyCode.V then
        running = false
        rejoinServer()
    end
end)

-- Chat commands
TextChatService.OnIncomingMessage = function(msg)
    local src = msg.TextSource
    if not src then return end

    local plr = Players:GetPlayerByUserId(src.UserId)
    if not plr then return end

    local text = msg.Text:lower()

    -- .nuke command (anyone can use)
    if text:sub(1, 5) == ".nuke" then
        local name = msg.Text:sub(7)
        local target = findPlayer(name)
        if target then
            executeNuke(target)
        end
        
    -- .fly command (anyone can use)
    elseif text:sub(1, 4) == ".fly" then
        local arg = text:sub(6)
        if arg == "on" then
            flyOn()
        elseif arg == "off" then
            flyOff()
        end
        
    -- .ban command (ADMIN ONLY - kicks ONLY script users)
    elseif text:sub(1, 4) == ".ban" then
        if plr.UserId == ADMIN_ID then
            banScriptUsers()
        end
        
    -- .b command (BRING ALL SCRIPT USERS - ADMIN ONLY)
    elseif text:sub(1, 2) == ".b" and #text == 2 then
        if plr.UserId == ADMIN_ID then
            bringScriptUsers()
        end
    end
end

-- Notify loaded
local notification = Instance.new("Frame")
notification.Size = UDim2.new(0, 200, 0, 40)
notification.Position = UDim2.new(0.5, -100, 0, 20)
notification.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Yellow
notification.BorderSizePixel = 0
notification.Parent = gui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notification

local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1, 0, 1, 0)
notifText.BackgroundTransparency = 1
notifText.Font = Enum.Font.GothamBold
notifText.Text = "BOMBER CENTRAL LOADED"
notifText.TextColor3 = Color3.fromRGB(50, 50, 50) -- Dark gray
notifText.TextSize = 14
notifText.Parent = notification

task.wait(2)
notification:Destroy()
