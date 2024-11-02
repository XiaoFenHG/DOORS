local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local AimRadius = 100 -- 瞄准半径
local AimSmoothness = 0.2 -- 瞄准平滑度
local AimbotEnabled = false -- 自瞄开关
local TeamCheckEnabled = false -- 团队检测开关

-- 创建UI圆圈
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local function createRainbowCircle(parent, radius)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0, radius * 2, 0, radius * 2)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 1

    local uiGradient = Instance.new("UIGradient", frame)
    uiGradient.Rotation = 90
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 127, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(148, 0, 211))
    })

    return frame
end

local AimCircle = createRainbowCircle(ScreenGui, AimRadius)
AimCircle.Position = UDim2.new(0.1, 0, 0.5, 0)

-- 创建目标信息显示
local TargetInfo = Instance.new("TextLabel", ScreenGui)
TargetInfo.Size = UDim2.new(0, 200, 0, 50)
TargetInfo.Position = UDim2.new(0.1, 0, 0.5, -25)
TargetInfo.BackgroundTransparency = 1
TargetInfo.TextColor3 = Color3.new(1, 1, 1)
TargetInfo.TextScaled = true

-- 创建启用开关按钮
local EnableButton = Instance.new("TextButton", ScreenGui)
EnableButton.Size = UDim2.new(0, 200, 0, 50)
EnableButton.Position = UDim2.new(0.1, 0, 0.5, 35)
EnableButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
EnableButton.TextColor3 = Color3.new(1, 1, 1)
EnableButton.TextScaled = true
EnableButton.Text = "Enable Aimbot"

-- 创建团队检测开关按钮
local TeamCheckButton = Instance.new("TextButton", ScreenGui)
TeamCheckButton.Size = UDim2.new(0, 200, 0, 50)
TeamCheckButton.Position = UDim2.new(0.1, 0, 0.5, 95)
TeamCheckButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TeamCheckButton.TextColor3 = Color3.new(1, 1, 1)
TeamCheckButton.TextScaled = true
TeamCheckButton.Text = "Enable Team Check"

-- 获取最近的目标
local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = AimRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if not TeamCheckEnabled or player.Team ~= LocalPlayer.Team then
                local head = player.Character.Head
                local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)).magnitude

                if distance < shortestDistance then
                    closestTarget = player
                    shortestDistance = distance
                end
            end
        end
    end

    return closestTarget
end

-- 瞄准函数
local function AimAt(target)
    local targetPosition = workspace.CurrentCamera:WorldToScreenPoint(target.Character.Head.Position)
    local mousePosition = UserInputService:GetMouseLocation()
    UserInputService.InputBegan:Fire({
        Position = Vector3.new((targetPosition.X - mousePosition.X) * AimSmoothness, (targetPosition.Y - mousePosition.Y) * AimSmoothness, 0),
        UserInputType = Enum.UserInputType.Touch
    })
end

-- 高亮ESP函数
local function HighlightTarget(target)
    for _, part in pairs(target.Character:GetChildren()) do
        if part:IsA("BasePart") then
            local highlight = Instance.new("BoxHandleAdornment")
            highlight.Adornee = part
            highlight.Size = part.Size
            highlight.Color3 = Color3.new(1, 0, 0)
            highlight.Transparency = 0.5
            highlight.AlwaysOnTop = true
            highlight.ZIndex = 10
            highlight.Parent = part
        end
    end
end

-- 主循环
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = GetClosestTarget()
        if target then
            AimAt(target)
            TargetInfo.Text = "Name: " .. target.Name .. "\nHealth: " .. target.Character.Humanoid.Health
            HighlightTarget(target)
        else
            TargetInfo.Text = ""
        end
    end
end)

-- 更新圆圈位置
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        AimCircle.Position = UDim2.new(0, input.Position.X - AimRadius, 0, input.Position.Y - AimRadius)
    end
end)

-- 切换自瞄开关
-- 切换自瞄开关
EnableButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    EnableButton.Text = AimbotEnabled and "Disable Aimbot" or "Enable Aimbot"
end)

-- 切换团队检测开关
TeamCheckButton.MouseButton1Click:Connect(function()
    TeamCheckEnabled = not TeamCheckEnabled
    TeamCheckButton.Text = TeamCheckEnabled and "Disable Team Check" or "Enable Team Check"
end)
