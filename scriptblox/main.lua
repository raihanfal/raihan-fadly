--// Raihan Hub V3
--// Fixed Jump + Fly System
--// Mobile Support + Draggable + Better UI

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
end)

--====================================================
-- GUI
--====================================================

if game.CoreGui:FindFirstChild("RaihanHubV3") then
	game.CoreGui.RaihanHubV3:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RaihanHubV3"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,360,0,420)
Main.Position = UDim2.new(0.5,-180,0.5,-210)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Main.Active = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

local Gradient = Instance.new("UIGradient")
Gradient.Parent = Main
Gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(45,45,45))
}
Gradient.Rotation = 90

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Thickness = 3

-- Rainbow Border

task.spawn(function()
	while true do
		for i = 0,1,0.01 do
			Stroke.Color = Color3.fromHSV(i,1,1)
			task.wait()
		end
	end
end)

--====================================================
-- TITLE
--====================================================

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundTransparency = 1
Title.Text = "RAIHAN HUB V3"
Title.Font = Enum.Font.GothamBlack
Title.TextScaled = true
Title.TextColor3 = Color3.new(1,1,1)

--====================================================
-- MINIMIZE
--====================================================

local Minimize = Instance.new("TextButton")
Minimize.Parent = Main
Minimize.Size = UDim2.new(0,35,0,35)
Minimize.Position = UDim2.new(1,-45,0,5)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextScaled = true
Minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
Minimize.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", Minimize)

local OpenButton = Instance.new("TextButton")
OpenButton.Parent = ScreenGui
OpenButton.Size = UDim2.new(0,130,0,45)
OpenButton.Position = UDim2.new(0,20,0.5,0)
OpenButton.Text = "Open Hub"
OpenButton.Visible = false
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextScaled = true
OpenButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
OpenButton.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", OpenButton)

Minimize.MouseButton1Click:Connect(function()
	Main.Visible = false
	OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
	Main.Visible = true
	OpenButton.Visible = false
end)

--====================================================
-- DRAGGABLE
--====================================================

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart

	Main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		update(input)
	end
end)

--====================================================
-- UI HELPER
--====================================================

local function CreateSection(text, posY)
	local Label = Instance.new("TextLabel")
	Label.Parent = Main
	Label.Position = UDim2.new(0,15,0,posY)
	Label.Size = UDim2.new(1,-30,0,25)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.Font = Enum.Font.GothamBold
	Label.TextScaled = true
	Label.TextColor3 = Color3.new(1,1,1)

	local Slider = Instance.new("TextButton")
	Slider.Parent = Main
	Slider.Position = UDim2.new(0,15,0,posY + 30)
	Slider.Size = UDim2.new(0,240,0,20)
	Slider.Text = ""
	Slider.BackgroundColor3 = Color3.fromRGB(55,55,55)

	Instance.new("UICorner", Slider)

	local Fill = Instance.new("Frame")
	Fill.Parent = Slider
	Fill.Size = UDim2.new(0.2,0,1,0)
	Fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

	Instance.new("UICorner", Fill)

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Parent = Main
	ValueLabel.Position = UDim2.new(0,265,0,posY + 22)
	ValueLabel.Size = UDim2.new(0,70,0,35)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.TextScaled = true
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.TextColor3 = Color3.new(1,1,1)

	local Toggle = Instance.new("TextButton")
	Toggle.Parent = Main
	Toggle.Position = UDim2.new(0,15,0,posY + 60)
	Toggle.Size = UDim2.new(1,-30,0,35)
	Toggle.BackgroundColor3 = Color3.fromRGB(120,0,0)
	Toggle.TextColor3 = Color3.new(1,1,1)
	Toggle.Font = Enum.Font.GothamBold
	Toggle.TextScaled = true

	Instance.new("UICorner", Toggle)

	return Slider, Fill, ValueLabel, Toggle
end

--====================================================
-- SPEED
--====================================================

local SpeedEnabled = false
local SpeedValue = 16

local SpeedSlider, SpeedFill, SpeedLabel, SpeedToggle = CreateSection("Speed Hack", 55)
SpeedLabel.Text = "16"
SpeedToggle.Text = "Speed: OFF"

--====================================================
-- JUMP
--====================================================

local JumpEnabled = false
local JumpValue = 50

local JumpSlider, JumpFill, JumpLabel, JumpToggle = CreateSection("Jump Hack", 165)
JumpLabel.Text = "50"
JumpToggle.Text = "Jump: OFF"

--====================================================
-- FLY
--====================================================

local FlyEnabled = false
local FlySpeed = 50

local FlySlider, FlyFill, FlyLabel, FlyToggle = CreateSection("Fly Hack", 275)
FlyLabel.Text = "50"
FlyToggle.Text = "Fly: OFF"

--====================================================
-- SLIDER FUNCTION
--====================================================

local function MakeSlider(slider, fill, min, max, callback)
	local draggingSlider = false

	local function updateSlider(input)
		local sizeX = math.clamp(
			(input.Position.X - slider.AbsolutePosition.X)
			/ slider.AbsoluteSize.X,
			0,
			1
		)

		fill.Size = UDim2.new(sizeX,0,1,0)

		local value = math.floor(min + ((max - min) * sizeX))
		callback(value)
	end

	slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			draggingSlider = true
			updateSlider(input)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if draggingSlider and (
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		) then
			updateSlider(input)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end)
end

--====================================================
-- SLIDERS
--====================================================

MakeSlider(SpeedSlider, SpeedFill, 16, 200, function(val)
	SpeedValue = val
	SpeedLabel.Text = tostring(val)
end)

MakeSlider(JumpSlider, JumpFill, 50, 250, function(val)
	JumpValue = val
	JumpLabel.Text = tostring(val)
end)

MakeSlider(FlySlider, FlyFill, 20, 300, function(val)
	FlySpeed = val
	FlyLabel.Text = tostring(val)
end)

--====================================================
-- TOGGLES
--====================================================

SpeedToggle.MouseButton1Click:Connect(function()
	SpeedEnabled = not SpeedEnabled

	if SpeedEnabled then
		SpeedToggle.Text = "Speed: ON"
		SpeedToggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		SpeedToggle.Text = "Speed: OFF"
		SpeedToggle.BackgroundColor3 = Color3.fromRGB(120,0,0)

		if Humanoid then
			Humanoid.WalkSpeed = 16
		end
	end
end)

JumpToggle.MouseButton1Click:Connect(function()
	JumpEnabled = not JumpEnabled

	if JumpEnabled then
		JumpToggle.Text = "Jump: ON"
		JumpToggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		JumpToggle.Text = "Jump: OFF"
		JumpToggle.BackgroundColor3 = Color3.fromRGB(120,0,0)

		if Humanoid then
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = 50
		end
	end
end)

FlyToggle.MouseButton1Click:Connect(function()
	FlyEnabled = not FlyEnabled

	if FlyEnabled then
		FlyToggle.Text = "Fly: ON"
		FlyToggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		FlyToggle.Text = "Fly: OFF"
		FlyToggle.BackgroundColor3 = Color3.fromRGB(120,0,0)

		if RootPart then
			RootPart.AssemblyLinearVelocity = Vector3.zero
		end
	end
end)

--====================================================
-- FLY CONTROL
--====================================================

local FlyDirection = Vector3.zero

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.W then
		FlyDirection = Vector3.new(0,0,-1)
	elseif input.KeyCode == Enum.KeyCode.S then
		FlyDirection = Vector3.new(0,0,1)
	elseif input.KeyCode == Enum.KeyCode.A then
		FlyDirection = Vector3.new(-1,0,0)
	elseif input.KeyCode == Enum.KeyCode.D then
		FlyDirection = Vector3.new(1,0,0)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W
	or input.KeyCode == Enum.KeyCode.S
	or input.KeyCode == Enum.KeyCode.A
	or input.KeyCode == Enum.KeyCode.D then
		FlyDirection = Vector3.zero
	end
end)

--====================================================
-- MAIN LOOP
--====================================================

RunService.RenderStepped:Connect(function()

	if Humanoid then

		if SpeedEnabled then
			Humanoid.WalkSpeed = SpeedValue
		end

		if JumpEnabled then
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = JumpValue
		end

		if FlyEnabled and RootPart then
			Humanoid.PlatformStand = true

			local cam = workspace.CurrentCamera
			local moveVector = cam.CFrame:VectorToWorldSpace(FlyDirection)

			RootPart.AssemblyLinearVelocity = moveVector * FlySpeed
		else
			Humanoid.PlatformStand = false
		end

	end

end)