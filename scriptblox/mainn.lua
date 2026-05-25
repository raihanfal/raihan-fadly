--// Raihan Hub V2.1 - Enhanced
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

--// Fly Variables
local FlyToggle = false
local FlySpeed = 50
local BodyVelocity
local BodyGyro

--// Setup GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RaihanHub"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 320)
Main.Position = UDim2.new(0.5, -150, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Native draggable support
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

--// UI Helper Function
local function createButton(name, pos, color, text)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0, 260, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

--// Fly Logic
local function ToggleFly()
    FlyToggle = not FlyToggle
    if FlyToggle then
        BodyVelocity = Instance.new("BodyVelocity", RootPart)
        BodyVelocity.Velocity = Vector3.new(0,0,0)
        BodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        BodyGyro = Instance.new("BodyGyro", RootPart)
        BodyGyro.P = 9000
        BodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
        BodyGyro.CFrame = RootPart.CFrame
    else
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
    end
end

RunService.RenderStepped:Connect(function()
    if FlyToggle and Character and RootPart then
        local moveDir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
        BodyVelocity.Velocity = moveDir * FlySpeed
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end
    
    --// Fix Jump: Gunakan keduanya agar support semua game
    if Humanoid then
        Humanoid.UseJumpPower = true 
    end
end)

--// UI Creation
local SpeedBtn = createButton("Speed", UDim2.new(0, 20, 0, 60), Color3.fromRGB(60, 60, 60), "Toggle Speed (16)")
local JumpBtn = createButton("Jump", UDim2.new(0, 20, 0, 110), Color3.fromRGB(60, 60, 60), "Toggle Jump (50)")
local FlyBtn = createButton("Fly", UDim2.new(0, 20, 0, 160), Color3.fromRGB(60, 60, 60), "Toggle Fly (OFF)")

--// Click Events
SpeedBtn.MouseButton1Click:Connect(function()
    Humanoid.WalkSpeed = (Humanoid.WalkSpeed == 16) and 50 or 16
    SpeedBtn.Text = "Speed: " .. Humanoid.WalkSpeed
end)

JumpBtn.MouseButton1Click:Connect(function()
    Humanoid.JumpPower = (Humanoid.JumpPower == 50) and 100 or 50
    JumpBtn.Text = "Jump: " .. Humanoid.JumpPower
end)

FlyBtn.MouseButton1Click:Connect(function()
    ToggleFly()
    FlyBtn.Text = FlyToggle and "Fly: ON" or "Fly: OFF"
    FlyBtn.BackgroundColor3 = FlyToggle and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
end)
