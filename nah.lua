local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local cam = workspace.CurrentCamera
local offsetgyat = 10
local TweenService = game:GetService("TweenService")

-- Define a customizable entity name
local entityName = "Shocker"  -- Change this to whatever name you want
local entity = game:GetObjects("rbxassetid://11547803978")[1]
entity.Name = entityName  -- Set the entity's name
entity.Parent = workspace
local primary_part = entity:FindFirstChildWhichIsA("BasePart") or entity:FindFirstChildWhichIsA("Part")
entity.PrimaryPart = primary_part

if not entity.PrimaryPart then return end

entity:SetPrimaryPartCFrame(chr.HumanoidRootPart.CFrame * CFrame.new(0, 0, -offsetgyat))
entity.PrimaryPart.Anchored = true

local playerTookDamage = false  -- Track if the player took damage

local function resetDamageFlag()
    wait(2)  -- Wait for 2 seconds
    playerTookDamage = false  -- Reset the flag
end

local function damageblud()
    local hum = chr:FindFirstChild("Humanoid")
    if hum then
        local dmg = math.random(15, 25)
        hum:TakeDamage(dmg)

        playerTookDamage = true  -- Player has taken damage
        spawn(resetDamageFlag)  -- Start the reset flag coroutine

        -- Check if the player is dead
        if hum.Health <= 0 then
            DEATHMESSAGE("You were defeated by " .. entity.Name .. "!", entity.Name)
        end
    end
end

local function check()
    local direction = (entity.PrimaryPart.Position - cam.CFrame.Position).unit
    local dot_product = direction:Dot(cam.CFrame.LookVector)
    return dot_product > 0.95
end

local function move(target, dur)
    local tween_info = TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(entity.PrimaryPart, tween_info, {CFrame = target})
    tween:Play()
    tween.Completed:Wait()
end

entity.PrimaryPart.Anchored = false
wait(1.5)

if check() then
    move(chr.HumanoidRootPart.CFrame, 0.5)
    damageblud()
end

local fallframe = entity.PrimaryPart.CFrame * CFrame.new(0, -100, 0)
local falldur = 1

move(fallframe, falldur)

entity.PrimaryPart.Anchored = false
entity.PrimaryPart.CanCollide = false

wait(10)
entity:Destroy()

-- Function to display the death message and handle achievements
local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()

function DEATHMESSAGE(message, who)
    if not message or not who then return end

    -- Get the player stats
    local playerName = game.Players.LocalPlayer.Name
    local playerStats = game:GetService("ReplicatedStorage").GameStats["Player_"..playerName]

    if playerStats then
        -- Update the death cause once
        playerStats.Total.DeathCause.Value = who
        
        -- Find the connection to the DeathHint event
        local connection = getconnections(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent)[1]
        
        if connection and connection.Function then
            -- Update the death hint message
            debug.setupvalue(connection.Function, 1, message, 'Blue')
        end
    else
        warn("Player stats not found for: " .. playerName)
    end

    -- Achievement logic
    if playerTookDamage then
        -- Player took damage, do not grant achievement
        print("Achievement not granted due to damage taken.")
    else
        -- Grant achievement if no damage was taken
        achievementGiver({
            Title = "Survivor",
            Desc = "You survived the encounter without taking damage!",
            Reason = "No damage taken from the entity.",
            Image = "rbxassetid://12309073114"
        })
        print("Achievement granted: Survivor")
    end
end
