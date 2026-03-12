-- SCRIPT MADE BY s9gd
-- commands are .nuke display & .fly on / press x to turn fly off





local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local running = true
local nuking = false

local AUTH_IDS = {
	[238548728] = true,
	[418081816] = true
}

local FLY_ADMIN = 238548728

local grenadeModel = workspace.Ignored.Shop["[Grenade] - $788"]
local grenadePart = grenadeModel:FindFirstChildWhichIsA("BasePart", true)
local clickDetector = grenadeModel:FindFirstChildWhichIsA("ClickDetector", true)

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,260,0,200)
frame.Position = UDim2.new(1,-270,0.45,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,10)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0,60,0,60)
avatar.Position = UDim2.new(0,10,0,10)
avatar.BackgroundTransparency = 1
avatar.Parent = frame

local targetText = Instance.new("TextLabel")
targetText.Size = UDim2.new(1,-90,0,30)
targetText.Position = UDim2.new(0,80,0,15)
targetText.BackgroundTransparency = 1
targetText.Font = Enum.Font.GothamBold
targetText.TextColor3 = Color3.fromRGB(255,90,90)
targetText.TextScaled = true
targetText.TextXAlignment = Enum.TextXAlignment.Left
targetText.Text = "Target: None"
targetText.Parent = frame

local healthBack = Instance.new("Frame")
healthBack.Size = UDim2.new(1,-90,0,12)
healthBack.Position = UDim2.new(0,80,0,50)
healthBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
healthBack.BorderSizePixel = 0
healthBack.Parent = frame

Instance.new("UICorner",healthBack).CornerRadius = UDim.new(0,6)

local healthBar = Instance.new("Frame")
healthBar.Size = UDim2.new(1,0,1,0)
healthBar.BackgroundColor3 = Color3.fromRGB(80,255,120)
healthBar.BorderSizePixel = 0
healthBar.Parent = healthBack

Instance.new("UICorner",healthBar).CornerRadius = UDim.new(0,6)

local grenadeCounter = Instance.new("TextLabel")
grenadeCounter.Size = UDim2.new(1,-20,0,30)
grenadeCounter.Position = UDim2.new(0,10,0,85)
grenadeCounter.BackgroundTransparency = 1
grenadeCounter.Font = Enum.Font.GothamBold
grenadeCounter.TextColor3 = Color3.new(1,1,1)
grenadeCounter.TextScaled = true
grenadeCounter.Text = "Grenades: 0"
grenadeCounter.Parent = frame

local keybinds = Instance.new("TextLabel")
keybinds.Size = UDim2.new(1,-20,0,60)
keybinds.Position = UDim2.new(0,10,0,130)
keybinds.BackgroundTransparency = 1
keybinds.Font = Enum.Font.Gotham
keybinds.TextColor3 = Color3.fromRGB(200,200,200)
keybinds.TextScaled = true
keybinds.TextXAlignment = Enum.TextXAlignment.Left
keybinds.Text =
"Z = Buy Grenades\nE = Throw Grenades\nV = Stop Script"
keybinds.Parent = frame

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

task.spawn(function()
	while running do
		grenadeCounter.Text = "Grenades: "..getGrenadeCount()
		task.wait(0.25)
	end
end)

local function buyGrenades(amount)

	local root = player.Character.HumanoidRootPart
	local old = root.CFrame

	root.CFrame = grenadePart.CFrame + Vector3.new(0,3,0)

	task.wait(0.4)

	while getGrenadeCount() < amount do
		fireclickdetector(clickDetector)
		task.wait(0.05)
	end

	root.CFrame = old
end

local function throwAll()

	local char = player.Character

	for _,tool in pairs(player.Backpack:GetChildren()) do
		if tool.Name:lower():find("grenade") then

			tool.Parent = char

			task.spawn(function()
				for i=1,4 do
					tool:Activate()
				end
			end)

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

	local img = Players:GetUserThumbnailAsync(
		plr.UserId,
		Enum.ThumbnailType.HeadShot,
		Enum.ThumbnailSize.Size150x150
	)

	avatar.Image = img

	local char = plr.Character
	if char then
		targetHum = char:FindFirstChildOfClass("Humanoid")
	end
end

task.spawn(function()

	while running do

		if targetHum then
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

	local root = player.Character.HumanoidRootPart
	local targetRoot = target.Character.HumanoidRootPart

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

	local root = player.Character.HumanoidRootPart

	for _,v in pairs(root:GetChildren()) do
		if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
			v:Destroy()
		end
	end

	flyEnabled = false

end

TextChatService.OnIncomingMessage = function(msg)

	local src = msg.TextSource
	if not src then return end

	local plr = Players:GetPlayerByUserId(src.UserId)
	if not plr then return end

	if not AUTH_IDS[plr.UserId] then return end

	local text = msg.Text:lower()

	if text:sub(1,5) == ".nuke" then

		local name = msg.Text:sub(7)
		local target = findPlayer(name)

		if target then
			executeNuke(target)
		end

	elseif text:sub(1,4) == ".fly" then

		if plr.UserId ~= FLY_ADMIN then return end

		local arg = text:sub(6)

		if arg == "on" then
			flyOn()
		elseif arg == "off" then
			flyOff()
		end

	end

end

UIS.InputBegan:Connect(function(input,typing)

	if typing then return end

	if input.KeyCode == Enum.KeyCode.Z then
		buyGrenades(10)
	end

	if input.KeyCode == Enum.KeyCode.E then
		throwAll()
	end

	if input.KeyCode == Enum.KeyCode.V then
		running = false
		gui:Destroy()
	end

end)
