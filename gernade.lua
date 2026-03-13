-- SCRIPT MADE BY s9gd + MODIFIED
-- Commands: .nuke display, .fly on/off,
-- Press V to rejoin server

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local running = true
local nuking = false

local ADMIN_ID = 238548728  -- Admin who can use .ban

local grenadeModel = workspace.Ignored.Shop["[Grenade] - $788"]
local grenadePart = grenadeModel:FindFirstChildWhichIsA("BasePart", true)
local clickDetector = grenadeModel:FindFirstChildWhichIsA("ClickDetector", true)

-- BETTER UI DESIGN
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui
gui.Name = "NukeUI"

-- Main frame with gradient
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,280,0,220)
frame.Position = UDim2.new(1,-290,0.45,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Gradient effect
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,35)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,15))
})
gradient.Parent = frame

-- Corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = frame

-- Stroke/border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255,70,70)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,35)
titleBar.BackgroundColor3 = Color3.fromRGB(255,70,70)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0,12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,0,1,0)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.Text = "NUKE CONTROLLER"
titleText.TextColor3 = Color3.new(1,1,1)
titleText.TextSize = 18
titleText.Parent = titleBar

-- Avatar
local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0,50,0,50)
avatar.Position = UDim2.new(0,15,0,50)
avatar.BackgroundColor3 = Color3.fromRGB(30,30,40)
avatar.BackgroundTransparency = 0.5
avatar.Parent = frame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1,0)
avatarCorner.Parent = avatar

-- Target info
local targetText = Instance.new("TextLabel")
targetText.Size = UDim2.new(1,-80,0,25)
targetText.Position = UDim2.new(0,75,0,55)
targetText.BackgroundTransparency = 1
targetText.Font = Enum.Font.GothamBold
targetText.TextColor3 = Color3.fromRGB(255,100,100)
targetText.TextSize = 16
targetText.TextXAlignment = Enum.TextXAlignment.Left
targetText.Text = "Target: None"
targetText.Parent = frame

-- Health bar background
local healthBack = Instance.new("Frame")
healthBack.Size = UDim2.new(1,-80,0,12)
healthBack.Position = UDim2.new(0,75,0,85)
healthBack.BackgroundColor3 = Color3.fromRGB(40,40,50)
healthBack.BorderSizePixel = 0
healthBack.Parent = frame

local healthCorner = Instance.new("UICorner")
healthCorner.CornerRadius = UDim.new(0,6)
healthCorner.Parent = healthBack

-- Health bar fill
local healthBar = Instance.new("Frame")
healthBar.Size = UDim2.new(1,0,1,0)
healthBar.BackgroundColor3 = Color3.fromRGB(80,255,120)
healthBar.BorderSizePixel = 0
healthBar.Parent = healthBack

local healthFillCorner = Instance.new("UICorner")
healthFillCorner.CornerRadius = UDim.new(0,6)
healthFillCorner.Parent = healthBar

-- Grenade counter
local grenadeCounter = Instance.new("TextLabel")
grenadeCounter.Size = UDim2.new(1,-30,0,25)
grenadeCounter.Position = UDim2.new(0,15,0,115)
grenadeCounter.BackgroundTransparency = 1
grenadeCounter.Font = Enum.Font.Gotham
grenadeCounter.TextColor3 = Color3.new(1,1,1)
grenadeCounter.TextSize = 14
grenadeCounter.TextXAlignment = Enum.TextXAlignment.Left
grenadeCounter.Text = "💣 Grenades: 0"
grenadeCounter.Parent = frame

-- Keybinds
local keybinds = Instance.new("TextLabel")
keybinds.Size = UDim2.new(1,-30,0,60)
keybinds.Position = UDim2.new(0,15,0,145)
keybinds.BackgroundTransparency = 1
keybinds.Font = Enum.Font.Gotham
keybinds.TextColor3 = Color3.fromRGB(180,180,200)
keybinds.TextSize = 13
keybinds.TextXAlignment = Enum.TextXAlignment.Left
keybinds.Text = "⚡ Z: Buy Grenades\n⚡ E: Throw All\n⚡ V: Rejoin Server"
keybinds.Parent = frame

-- Close button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-30,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,70,70)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1,0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
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
		grenadeCounter.Text = "💣 Grenades: "..getGrenadeCount()
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

-- BAN COMMAND - Kicks everyone except admin
local function banAllExceptAdmin()
	-- Loop through all players
	for _, plr in pairs(Players:GetPlayers()) do
		-- Skip the admin (238548728) and LocalPlayer
		if plr.UserId ~= ADMIN_ID and plr ~= player then
			-- Kick them with fake ban message
			plr:Kick("You have been banned")
		end
	end
end

local targetHum

local function setTarget(plr)
	if not plr then
		targetText.Text = "Target: None"
		avatar.Image = ""
		healthBar.Size = UDim2.new(1,0,1,0)
		return
	end

	targetText.Text = "Target: "..plr.Name

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
		
	-- .ban command (ADMIN ONLY - 238548728)
	elseif text:sub(1,4) == ".ban" then
		if plr.UserId == ADMIN_ID then
			banAllExceptAdmin()
		end
	end
end

-- Notify loaded
local notification = Instance.new("Frame")
notification.Size = UDim2.new(0,200,0,50)
notification.Position = UDim2.new(0.5,-100,0,10)
notification.BackgroundColor3 = Color3.fromRGB(255,70,70)
notification.BackgroundTransparency = 0.2
notification.Parent = gui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0,8)
notifCorner.Parent = notification

local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1,0,1,0)
notifText.BackgroundTransparency = 1
notifText.Font = Enum.Font.GothamBold
notifText.Text = "✅ Script Loaded!"
notifText.TextColor3 = Color3.new(1,1,1)
notifText.TextSize = 16
notifText.Parent = notification

task.wait(2)
notification:Destroy()
