-- Exploit Aimbot Client with Auto Shoot, ESP using Highlight, and View Adjustment

local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Left"

local Window = Library:CreateWindow({
	Title = 'Exploit Aimbot Client',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})

local Tabs = {
	Main = Window:AddTab('Main'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Aim Settings')

LeftGroupBox:AddToggle('AimToggle', {
	Text = 'Enable Aimbot',
	Tooltip = 'Toggle the aimbot on or off',
	Default = false
}):AddColorPicker('AimColor', {
	Default = Color3.new(1, 0, 0),
	Title = 'Aimbot Target Color',
	Transparency = 0
})

LeftGroupBox:AddToggle('AutoShootToggle', {
	Text = 'Enable Auto Shoot',
	Tooltip = 'Automatically shoots when aiming at a target',
	Default = false
})

LeftGroupBox:AddToggle('ESPToggle', {
	Text = 'Enable ESP',
	Tooltip = 'Show player positions and health',
	Default = false
})

LeftGroupBox:AddSlider('AimSensitivity', {
	Text = 'Aim Sensitivity',
	Default = 50,
	Min = 1,
	Max = 100,
	Rounding = 1,
	Compact = false
})

local StatsGroupBox = Tabs.Main:AddRightGroupbox('Statistics')
StatsGroupBox:AddLabel('Kills: 0')
StatsGroupBox:AddLabel('Deaths: 0')
StatsGroupBox:AddLabel('Accuracy: 0%')
StatsGroupBox:AddLabel('Position: (0, 0, 0)')
StatsGroupBox:AddLabel('Target: None')
StatsGroupBox:AddLabel('Target Health: N/A')

local killCount = 0
local deathCount = 0
local accuracy = 0
local totalShots = 0
local hitShots = 0

local function updateStats()
	local player = game.Players.LocalPlayer
	StatsGroupBox:Label('Kills').Text = 'Kills: ' .. killCount
	StatsGroupBox:Label('Deaths').Text = 'Deaths: ' .. deathCount
	accuracy = totalShots > 0 and (hitShots / totalShots * 100) or 0
	StatsGroupBox:Label('Accuracy').Text = 'Accuracy: ' .. string.format("%.2f", accuracy) .. '%'
	StatsGroupBox:Label('Position').Text = 'Position: (' .. math.floor(player.Character.Head.Position.X) .. ', ' .. math.floor(player.Character.Head.Position.Y) .. ', ' .. math.floor(player.Character.Head.Position.Z) .. ')'
end

local function updateTargetStats(target)
	if target and target.Character and target.Character:FindFirstChild('Humanoid') then
		local health = target.Character.Humanoid.Health
		StatsGroupBox:Label('Target').Text = 'Target: ' .. target.Name .. ' (' .. math.floor(target.Character.Head.Position.X) .. ', ' .. math.floor(target.Character.Head.Position.Y) .. ', ' .. math.floor(target.Character.Head.Position.Z) .. ')'
		StatsGroupBox:Label('Target Health').Text = 'Target Health: ' .. math.floor(health)
	else
		StatsGroupBox:Label('Target').Text = 'Target: None'
		StatsGroupBox:Label('Target Health').Text = 'Target Health: N/A'
	end
end

local function getClosestPlayer()
	local player = game.Players.LocalPlayer
	local shortestDistance = math.huge
	local closestPlayer = nil

	for _, otherPlayer in pairs(game.Players:GetPlayers()) do
		if otherPlayer ~= player then
			local character = otherPlayer.Character
			if character and character:FindFirstChild('Head') then
				local distance = (character.Head.Position - player.Character.Head.Position).Magnitude
				if distance < shortestDistance then
					closestPlayer = otherPlayer
					shortestDistance = distance
				end
			end
		end
	end

	return closestPlayer
end

local currentESPPlayer = nil

game:GetService('RunService').RenderStepped:Connect(function()
    safeCall(function()
        if Toggles.AimToggle.Value then
            local closestPlayer = getClosestPlayer()
            if closestPlayer then
                local aimPart = closestPlayer.Character and closestPlayer.Character:FindFirstChild('Head')
                if aimPart then
                    -- 调整视角到最近玩家的头部
                    local player = game.Players.LocalPlayer
                    local camera = workspace.CurrentCamera
                    camera.CFrame = CFrame.new(camera.CFrame.Position, aimPart.Position)

                    StatsGroupBox:Label('Target').Text = 'Target: ' .. closestPlayer.Name .. ' (' .. math.floor(aimPart.Position.X) .. ', ' .. math.floor(aimPart.Position.Y) .. ', ' .. math.floor(aimPart.Position.Z) .. ')'

                    local health = closestPlayer.Character:FindFirstChildOfClass('Humanoid').Health
                    StatsGroupBox:Label('Target Health').Text = 'Target Health: ' .. tostring(math.floor(health))

                    if Toggles.AutoShootToggle.Value then
                        mouse1click() -- 触发射击动作
                        totalShots = totalShots + 1
                        hitShots = hitShots + 1 -- 假设每次点击都命中
                        updateStats()
                    end
                end
            end
        end
    end)
end)

game:GetService('RunService').RenderStepped:Connect(function()
    safeCall(function()
        if Toggles.ESPToggle.Value then
            local closestPlayer = getClosestPlayer()
            if closestPlayer and closestPlayer.Character then
                if currentESPPlayer and currentESPPlayer ~= closestPlayer then
                    -- 移除当前ESP玩家的高亮
                    local highlight = currentESPPlayer.Character:FindFirstChildOfClass('Highlight')
                    if highlight then
                        highlight:Destroy()
                    end
                end

                -- 为新的目标玩家增加高亮
                if not closestPlayer.Character:FindFirstChildOfClass('Highlight') then
                    local highlight = Instance.new('Highlight')
                    highlight.FillColor = Color3.new(1, 0, 0) -- 内部高亮颜色
                    highlight.OutlineColor = Color3.new(0, 1, 0) -- 外部高亮颜色
                    highlight.Parent = closestPlayer.Character
                end

                currentESPPlayer = closestPlayer
            elseif not closestPlayer and currentESPPlayer then
                -- 如果没有最近玩家，则移除原来的高亮
                local highlight = currentESPPlayer.Character:FindFirstChildOfClass('Highlight')
                if highlight then
                    highlight:Destroy()
                end
                currentESPPlayer = nil
            end
        end
    end)
end)
