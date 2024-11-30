local LightReplaceModel = game:GetObjects("rbxassetid://12543866876")[1] or nil

-- Function to change the light model in a room
function ChangeLightModel(room)
    for i, v in pairs(room.Assets.Light_Fixtures:GetDescendants()) do
        if v.Name == "LightStand" then
            if game.ReplicatedStorage.GameData.LatestRoom.Value < 100 then
                local torch = LightReplaceModel:Clone()
                torch.Parent = room.Assets.Light_Fixtures
                torch.LightFixture.PointLight.Changed:Connect(function()
                    torch.LightFixture.Neon.atachm["Ok you cannot tell me this isnt good"].Enabled = torch.LightFixture.PointLight.Enabled
                    torch.LightFixture.Neon["Bright sh idfk"].ParticleEmitter.Enabled = torch.LightFixture.PointLight.Enabled
                    torch.LightFixture:WaitForChild('Dust').ParticleEmitter.Enabled = torch.LightFixture.PointLight.Enabled
                end)
                torch:PivotTo(v:GetPivot())
                v:Destroy()
            else
                v:Destroy()
            end
        end
    end
end
-- Function to change the fog settings
    -- Get services
local playingSounds = {} -- Table to keep track of currently playing sounds

local function applySoundEffects(sound)
    -- Decrease sound volume
    sound.Volume = 1 -- Set to low volume

    -- Create and configure reverb effect
    local reverb = Instance.new("ReverbSoundEffect")
    reverb.Density = 0.8 -- Increase reverb density
    reverb.DecayTime = 5 -- Increase reverb decay time
    reverb.Parent = sound

    -- Create and configure echo effect with increased delay
    local echo = Instance.new("EchoSoundEffect")
    echo.Delay = 2.5 -- Increase echo delay to 2.5 seconds
    echo.WetLevel = 0.9 -- Increase echo wet level
    echo.Parent = sound

    -- Create and configure equalizer
    local equalizer = Instance.new("EqualizerSoundEffect")
    equalizer.LowGain = 2.5 -- Boost low frequencies
    equalizer.MidGain = 1.5 -- Boost mid frequencies
    equalizer.HighGain = 1.5 -- Boost high frequencies
    equalizer.Parent = sound

    -- Create and configure compressor
    local compressor = Instance.new("CompressorSoundEffect")
    compressor.Threshold = -15 -- Set threshold
    compressor.Ratio = 3 -- Compression ratio
    compressor.Attack = 0.02 -- Attack time
    compressor.Release = 0.2 -- Release time
    compressor.Parent = sound

    -- Manage sound playback state
    sound.Ended:Connect(function()
        playingSounds[sound] = nil -- Remove the sound from the table when it finishes playing
    end)
end

-- Function to stop sound after echo effect ends, considering non-looping sounds
local function stopSoundAfterEcho(sound)
    if sound.Looped then return end -- Skip if the sound is set to loop

    local totalDuration = sound.TimeLength + 2.5 -- Add 2.5 seconds for the echo delay
    task.delay(totalDuration + 3, function() -- Include additional time for the echo effect
        if sound and sound:IsA("Sound") then -- Check if sound is valid before stopping
            pcall(function()
                sound:Stop()
                playingSounds[sound] = nil -- Remove the sound from the table
            end)
        end
    end)
end

-- Recursive function to apply effects to all descendants
local function applyEffectsToAllDescendants(parent, maxPerFrame)
    local processed = 0
    for _, obj in ipairs(parent:GetDescendants()) do
        if processed >= maxPerFrame then
            break
        end
        pcall(function()
            if obj:IsA("Sound") then
                if playingSounds[obj] then
                    obj:Stop() -- Stop the sound if it's already playing
                end
                applySoundEffects(obj)
                stopSoundAfterEcho(obj) -- Stop sound after echo effect ends
                playingSounds[obj] = true -- Mark the sound as playing
                processed = processed + 1
            elseif obj:IsA("BasePart") then
                applyHiddenLight(obj) -- Assuming applyHiddenLight is defined elsewhere
                processed = processed + 1
            end
        end)
    end
    return processed
end

-- Apply effects to newly created objects
workspace.DescendantAdded:Connect(function(obj)
    pcall(function()
        if obj:IsA("Sound") then
            if playingSounds[obj] then
                obj:Stop() -- Stop the sound if it's already playing
            end
            applySoundEffects(obj)
            stopSoundAfterEcho(obj) -- Stop sound after echo effect ends
            playingSounds[obj] = true -- Mark the sound as playing
        elseif obj:IsA("BasePart") then
            applyHiddenLight(obj) -- Assuming applyHiddenLight is defined elsewhere
        end
    end)
end)

-- Function to apply sound effects to the character
local function applyCharacterSoundEffects(character)
    for _, sound in ipairs(character:GetDescendants()) do
        if sound:IsA("Sound") then
            applySoundEffects(sound)
            stopSoundAfterEcho(sound)
            playingSounds[sound] = true
        end
    end
end

-- Apply sound effects to the player's character
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function(character)
    applyCharacterSoundEffects(character)
end)
if player.Character then
    applyCharacterSoundEffects(player.Character)
end
-- Change the light model in the latest room
local latestroom = game.ReplicatedStorage.GameData.LatestRoom.Value
local roomlatestworkspace = workspace.CurrentRooms[latestroom]
ChangeLightModel(roomlatestworkspace)

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
coroutine.wrap(function()
    while true do
        if isSeekMusicPlaying() then return end
        wait(1600)
        loadstring(game:HttpGet("https://github.com/XiaoFenHG/DOORS/blob/main/a60.lua?raw=true"))()
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

local shut = game.Players.LocalPlayer.PlayerGui.MainUI.MainFrame.IntroText
local intro = shut:Clone()
intro.Parent = game.Players.LocalPlayer.PlayerGui.MainUI
intro.Name = "IntroTextPleaseThankYou"
intro.Visible = true
intro.Text = "Hardcore Dread OUT"
intro.TextTransparency = 0
local underline = UDim2.new(1.1, 0, 0.015, 6)
game.TweenService:Create(intro.Underline, TweenInfo.new(3), {Size = underline}):Play()
wait(7)
game.TweenService:Create(intro.Underline, TweenInfo.new(1.3), {Size = UDim2.new(0.95, 0, 0.015, 6)}):Play()
wait(1)
game.TweenService:Create(intro.Underline, TweenInfo.new(2), {ImageTransparency = 1}):Play()
game.TweenService:Create(intro, TweenInfo.new(2), {TextTransparency = 1}):Play()
game.TweenService:Create(intro.Underline, TweenInfo.new(7), {Size = UDim2.new(0, 0, 0.015, 6)}):Play()
wait(2.3)
intro.Visible = false
wait(5)
intro:Destroy()
