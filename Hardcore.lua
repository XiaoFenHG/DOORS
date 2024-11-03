local TextChatService = game:GetService("TextChatService")
local whitelist = {
    "Nys195",
}

local function isWhitelisted(username)
    for _, whitelistedUser in ipairs(whitelist) do
        if whitelistedUser == username then
            return true
        end
    end
    return false
end
local painters = 1
local paints = {
	[1] = {"rbxassetid://11881132074","Despair"},
	[2] = {"rbxassetid://11881132745","Odd feline Specimen"},
	[3] = {"rbxassetid://11881654771","A tryhard..."},
	[4] = {"rbxassetid://7084794697","him."},
    [5] = {"rbxassetid://18148044143","...."}
}
---
--- NEW PAINTINGS YOOOOOOOOOOOOOOOOOOOOO
game:GetService("ReplicatedStorage").GameData.LatestRoom.Changed:Connect(function()
	local room = workspace.CurrentRooms[game:GetService("ReplicatedStorage").GameData.LatestRoom.Value]
	if room:FindFirstChild("Assets") then
		local paintings = {}
		for i,painting in next,room:FindFirstChild("Assets"):GetChildren() do
			if painting.Name:find("Painting") then
				table.insert(paintings,painting)
			end
		end
		if #paintings > 0 then
			local currentpainting
			if paintings[#paintings] then
				painters = painters + 1
				currentpainting = paintings[#paintings]
			else
				currentpainting = paintings[1]
			end
			if currentpainting then
				if currentpainting:FindFirstChild("Canvas") then
					local selected = paints[math.random(1,#paints)]
					if currentpainting:FindFirstChild("InteractPrompt") then
						local cloning = currentpainting:FindFirstChild("InteractPrompt"):Clone() cloning.Name = "fakeInteract"
						cloning.Parent = currentpainting
						currentpainting:FindFirstChild("InteractPrompt"):Destroy()
						local t = cloning.Triggered:Connect(function()
							firesignal(game.ReplicatedStorage.EntityInfo.Caption.OnClientEvent,string.gsub("This painting is titled \"NAMEOFTHING\"","NAMEOFTHING",selected[2]))
						end)
					end
					currentpainting:FindFirstChild("Canvas"):FindFirstChildOfClass("SurfaceGui"):FindFirstChildOfClass("ImageLabel").Image = selected[1]
				end
			end
		end
	end
end)


TextChatService.OnIncomingMessage = function(msg)
    local p = Instance.new("TextChatMessageProperties")
    if msg.TextSource then
        local username = msg.TextSource.Name
        if isWhitelisted(username) then
            p.PrefixText = "<font color='#0000FF'>[Credit]</font> " .. msg.PrefixText
        end
    end
    return p
end

local function isSeekMusicPlaying()
    local seekMusic = game.ReplicatedStorage:FindFirstChild("FloorReplicated"):FindFirstChild("SeekMusic")
    return seekMusic and seekMusic.IsPlaying
end

coroutine.wrap(function()
    while true do
        if isSeekMusicPlaying() then return end
        wait(math.random(600,610))
        game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
        require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("???",true)
        loadstring(game:HttpGet("https://pastebin.com/raw/jTEPNkrV"))()
    end
end)()

coroutine.wrap(function()
    while true do
        if isSeekMusicPlaying() then return end
        wait(math.random(10,100))
        loadstring(game:HttpGet("https://github.com/XiaoFenHG/DOORS/blob/main/nah.lua?raw=true"))()
    end
end)()

coroutine.wrap(function()
    while true do
        if isSeekMusicPlaying() then return end
        wait(450)
        loadstring(game:HttpGet("https://github.com/XiaoFenHG/DOORS/blob/main/sug.lua?raw=true"))()
    end
end)()

coroutine.wrap(function()
    while true do
        if isSeekMusicPlaying() then return end
        wait(250)
        loadstring(game:HttpGet("https://github.com/XiaoFenHG/DOORS/blob/main/der.lua?raw=true"))()
    end
end)()

coroutine.wrap(function()
    while true do
        if isSeekMusicPlaying() then return end
        wait(175)
        loadstring(game:HttpGet("https://github.com/XiaoFenHG/DOORS/blob/main/reo.lua?raw=true"))()
    end
end)()

coroutine.wrap(function()
    while true do
        if isSeekMusicPlaying() then return end
        wait(350)
        loadstring(game:HttpGet("https://github.com/XiaoFenHG/DOORS/blob/main/reb.lua?raw=true"))()
    end
end)()

coroutine.wrap(function()
    while true do
        if isSeekMusicPlaying() then return end
        wait(560)
        loadstring(game:HttpGet("https://github.com/XiaoFenHG/DOORS/blob/main/sil.lua?raw=true"))()
    end
end)()
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local Parent = Player.PlayerGui

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local StaminaGui = Instance.new("ScreenGui")
StaminaGui.Name = "StaminaGui"
StaminaGui.Parent = Parent
StaminaGui.Enabled = true
StaminaGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Sprint Frame
local Sprint = Instance.new("Frame")
Sprint.Name = "Sprint"
Sprint.Parent = StaminaGui
Sprint.AnchorPoint = Vector2.new(1, 0.5) -- Anchor to the middle right
Sprint.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Sprint.BackgroundTransparency = 1
Sprint.Position = UDim2.new(1, -10, 0.5, -Sprint.Size.Y.Offset / 2) -- Middle right position
Sprint.Size = UDim2.new(0.3, 0, 0.05, 0)
Sprint.ZIndex = 1005

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Parent = Sprint
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 222, 189)
ImageLabel.Size = UDim2.new(1, 0, 1, 0)
ImageLabel.BackgroundTransparency = 1

local Bar = Instance.new("Frame")
Bar.Name = "Bar"
Bar.Parent = Sprint
Bar.BackgroundColor3 = Color3.fromRGB(56, 46, 39)
Bar.BackgroundTransparency = 0.7
Bar.Size = UDim2.new(1, 0, 1, 0)
Bar.ZIndex = 0

local Fill = Instance.new("Frame")
Fill.Name = "Fill"
Fill.Parent = Bar
Fill.BackgroundColor3 = Color3.fromRGB(213, 185, 158)
Fill.Size = UDim2.new(1, 0, 1, 0)
Fill.ZIndex = 2

local Button = Instance.new("TextButton")
Button.Name = "ConsumeStaminaButton"
Button.Parent = StaminaGui
Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Button.Size = UDim2.new(0.1, 0, 0.05, 0)

-- Align button with stamina bar below it
 -- 2% gap below the sprint frame
Button.Position = UDim2.new(1, -10, 0.5, 0)
Button.Text = "Sprint"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.SourceSans
Button.TextSize = 20

-- Stamina Variables
local maxStamina = 100
local currentStamina = maxStamina
local staminaDepletionRate = 10
local recoveryRate = 5
local staminaConsumptionActive = false

local function updateStaminaBar()
    local staminaRatio = currentStamina / maxStamina
    local targetSize = UDim2.new(staminaRatio, 0, 1, 0)

    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(Fill, tweenInfo, {Size = targetSize})

    tween:Play()
end

local function startConsumingStamina()
    staminaConsumptionActive = true
    Humanoid.WalkSpeed = 22 -- Set speed to 22 during consumption
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if staminaConsumptionActive and currentStamina > 0 then
            if currentStamina >= staminaDepletionRate then
                currentStamina = currentStamina - staminaDepletionRate * (1/60) -- Depletes stamina every frame
                updateStaminaBar()
            else
                currentStamina = 0
                updateStaminaBar()
                -- Play exhausted message and sound
                require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("You're exhausted.",true)
                local noStaminaSound = Instance.new("Sound", workspace)
                noStaminaSound.SoundId = "rbxassetid://8258601891"
                noStaminaSound.Volume = 0.8
                noStaminaSound:Play()
                noStaminaSound.Ended:Wait()
                noStaminaSound:Destroy()
                
                Humanoid.WalkSpeed = 16 -- Reset speed to default
                staminaConsumptionActive = false
            end
        end
    end)
end

local function stopConsumingStamina()
    staminaConsumptionActive = false
    Humanoid.WalkSpeed = 16 -- Reset speed to default
end

local function toggleStaminaConsumption()
    if staminaConsumptionActive then
        stopConsumingStamina()
    else
        startConsumingStamina()
    end
end

local function recoverStamina()
    while true do
        if not staminaConsumptionActive and currentStamina < maxStamina then
            currentStamina = math.min(currentStamina + recoveryRate * (1/60), maxStamina)
            updateStaminaBar()
        end
        RunService.Heartbeat:Wait()
    end
end

Button.MouseButton1Click:Connect(toggleStaminaConsumption)

-- Start the stamina recovery coroutine
coroutine.wrap(recoverStamina)()

-- Initial update
updateStaminaBar()
require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("Hardcore mode Initiated",true)
