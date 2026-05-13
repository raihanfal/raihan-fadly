--// Raihan Hub V2
--// UI Speed + Jump Controller
--// Mobile Support + Draggable + Minimize + Rainbow

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

Player.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
end)

--========================
-- GUI
--========================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RaihanHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,320,0,260)
Main.Position = UDim2.new(0.5,-160,0.5,-130)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Active = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- Rainbow Border
local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Thickness = 3

task.spawn(function()
	while true do
		for i = 0,1,0.01 do
			Stroke.Color = Color3.fromHSV(i,1,1)
			task.wait()
		end
	end
end)

--========================
-- TITLE
--========================

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "RAIHAN HUB"
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1,1,1)

--========================
-- MINIMIZE BUTTON
--========================

local Minimize = Instance.new("TextButton")
Minimize.Parent = Main
Minimize.Size = UDim2.new(0,35,0,35)
Minimize.Position = UDim2.new(1,-40,0,5)
Minimize.Text = "-"
Minimize.TextScaled = true
Minimize.Font = Enum.Font.GothamBold
Minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
Minimize.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", Minimize)

local OpenButton = Instance.new("TextButton")
OpenButton.Parent = ScreenGui
OpenButton.Size = UDim2.new(0,120,0,40)
OpenButton.Position = UDim2.new(0,20,0.5,0)
OpenButton.Text = "Open Hub"
OpenButton.Visible = false
OpenButton.TextScaled = true
OpenButton.Font = Enum.Font.GothamBold
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

--========================
-- DRAGGABLE
--========================

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
	if input == dragInput and dragging then
		update(input)
	end
end)

--========================
-- SPEED SECTION
--========================

local SpeedToggle = false

local SpeedText = Instance.new("TextLabel")
SpeedText.Parent = Main
SpeedText.Position = UDim2.new(0,15,0,50)
SpeedText.Size = UDim2.new(1,-30,0,25)
SpeedText.BackgroundTransparency = 1
SpeedText.Text = "Speed Hack"
SpeedText.TextScaled = true
SpeedText.Font = Enum.Font.GothamBold
SpeedText.TextColor3 = Color3.new(1,1,1)

local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Parent = Main
SpeedSlider.Position = UDim2.new(0,15,0,80)
SpeedSlider.Size = UDim2.new(0,220,0,20)
SpeedSlider.Text = ""
SpeedSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)

Instance.new("UICorner", SpeedSlider)

local SpeedFill = Instance.new("Frame")
SpeedFill.Parent = SpeedSlider
SpeedFill.Size = UDim2.new(0.2,0,1,0)
SpeedFill.BackgroundColor3 = Color3.fromRGB(0,170,255)

Instance.new("UICorner", SpeedFill)

local SpeedValue = 16

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = Main
SpeedLabel.Position = UDim2.new(0,245,0,73)
SpeedLabel.Size = UDim2.new(0,60,0,35)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = tostring(SpeedValue)
SpeedLabel.TextScaled = true
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextColor3 = Color3.new(1,1,1)

local SpeedToggleBtn = Instance.new("TextButton")
SpeedToggleBtn.Parent = Main
SpeedToggleBtn.Position = UDim2.new(0,15,0,110)
SpeedToggleBtn.Size = UDim2.new(1,-30,0,35)
SpeedToggleBtn.Text = "Speed: OFF"
SpeedToggleBtn.TextScaled = true
SpeedToggleBtn.Font = Enum.Font.GothamBold
SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
SpeedToggleBtn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", SpeedToggleBtn)

--========================
-- JUMP SECTION
--========================

local JumpToggle = false

local JumpText = Instance.new("TextLabel")
JumpText.Parent = Main
JumpText.Position = UDim2.new(0,15,0,155)
JumpText.Size = UDim2.new(1,-30,0,25)
JumpText.BackgroundTransparency = 1
JumpText.Text = "Jump Hack"
JumpText.TextScaled = true
JumpText.Font = Enum.Font.GothamBold
JumpText.TextColor3 = Color3.new(1,1,1)

local JumpSlider = Instance.new("TextButton")
JumpSlider.Parent = Main
JumpSlider.Position = UDim2.new(0,15,0,185)
JumpSlider.Size = UDim2.new(0,220,0,20)
JumpSlider.Text = ""
JumpSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)

Instance.new("UICorner", JumpSlider)

local JumpFill = Instance.new("Frame")
JumpFill.Parent = JumpSlider
JumpFill.Size = UDim2.new(0.25,0,1,0)
JumpFill.BackgroundColor3 = Color3.fromRGB(0,255,120)

Instance.new("UICorner", JumpFill)

local JumpValue = 50

local JumpLabel = Instance.new("TextLabel")
JumpLabel.Parent = Main
JumpLabel.Position = UDim2.new(0,245,0,178)
JumpLabel.Size = UDim2.new(0,60,0,35)
JumpLabel.BackgroundTransparency = 1
JumpLabel.Text = tostring(JumpValue)
JumpLabel.TextScaled = true
JumpLabel.Font = Enum.Font.GothamBold
JumpLabel.TextColor3 = Color3.new(1,1,1)

local JumpToggleBtn = Instance.new("TextButton")
JumpToggleBtn.Parent = Main
JumpToggleBtn.Position = UDim2.new(0,15,0,215)
JumpToggleBtn.Size = UDim2.new(1,-30,0,35)
JumpToggleBtn.Text = "Jump: OFF"
JumpToggleBtn.TextScaled = true
JumpToggleBtn.Font = Enum.Font.GothamBold
JumpToggleBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
JumpToggleBtn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", JumpToggleBtn)

--========================
-- SLIDER FUNCTION
--========================

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

		local value = math.floor((min + (max-min)*sizeX))
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

-- SPEED SLIDER
MakeSlider(SpeedSlider, SpeedFill, 16, 200, function(val)
	SpeedValue = val
	SpeedLabel.Text = tostring(val)
end)

-- JUMP SLIDER
MakeSlider(JumpSlider, JumpFill, 50, 250, function(val)
	JumpValue = val
	JumpLabel.Text = tostring(val)
end)

--========================
-- TOGGLES
--========================

SpeedToggleBtn.MouseButton1Click:Connect(function()
	SpeedToggle = not SpeedToggle

	if SpeedToggle then
		SpeedToggleBtn.Text = "Speed: ON"
		SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		SpeedToggleBtn.Text = "Speed: OFF"
		SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)

		if Humanoid then
			Humanoid.WalkSpeed = 16
		end
	end
end)

JumpToggleBtn.MouseButton1Click:Connect(function()
	JumpToggle = not JumpToggle

	if JumpToggle then
		JumpToggleBtn.Text = "Jump: ON"
		JumpToggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		JumpToggleBtn.Text = "Jump: OFF"
		JumpToggleBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)

		if Humanoid then
			Humanoid.JumpPower = 50
		end
	end
end)

--========================
-- LOOP
--========================

RunService.RenderStepped:Connect(function()

	if Humanoid then

		if SpeedToggle then
			Humanoid.WalkSpeed = SpeedValue
		end

		if JumpToggle then
			Humanoid.JumpPower = JumpValue
		end

	end

end)
