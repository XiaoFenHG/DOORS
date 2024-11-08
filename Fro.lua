local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function DEATHMESSAGE(message, who)
    spawn(function()
        for i = 1, 50 do 
            wait()
            game:GetService("ReplicatedStorage").GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = who
            debug.setupvalue(getconnections(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent)[1].Function, 1, message, 'Blue')
        end
    end)
end

local function spawnFrostbite()
    local frostbiteModel = game:GetObjects("rbxassetid://12272255258")[1] -- Frostbite的模型ID
    frostbiteModel.PrimaryPart = frostbiteModel:FindFirstChild("HumanoidRootPart") or frostbiteModel:FindFirstChildWhichIsA("Part")
    frostbiteModel.Parent = Workspace

    local currentLoadedRoom = Workspace.CurrentRooms[game:GetService("ReplicatedStorage").GameData.LatestRoom.Value]
    local nodes = currentLoadedRoom:FindFirstChild("Nodes")

    -- 确保 Nodes 存在且不为空
    if nodes and #nodes:GetChildren() > 0 then
        local num = math.floor(#nodes:GetChildren() / 2)
        local targetPosition = (nodes:GetChildren()[num]) and nodes[num].CFrame or currentLoadedRoom.CFrame
        frostbiteModel:SetPrimaryPartCFrame(targetPosition + Vector3.new(0, 11, 0))
    else
        -- 设置默认位置，假设当前房间有一个中心位置
        local roomCenter = currentLoadedRoom:FindFirstChild("Base") or currentLoadedRoom:FindFirstChildWhichIsA("Part")
        if roomCenter then
            frostbiteModel:SetPrimaryPartCFrame(roomCenter.CFrame + Vector3.new(0, 11, 0))
        else
            -- 如果房间中没有找到 Base 或其他部件，则设置为世界中心（示例位置）
            frostbiteModel:SetPrimaryPartCFrame(CFrame.new(0, 11, 0))
        end
    end

    return frostbiteModel
end

local frostbiteModel = spawnFrostbite()

local function checkForLighter()
    local hum = character:FindFirstChildOfClass("Humanoid")
    local lighter = character:FindFirstChild("Lighter")
    if hum then
        if lighter then
            local EfH = lighter:FindFirstChild("EffectsHolder")
            if EfH then
                local asdasdasd = EfH.AttachOn
                if asdasdasd:FindFirstChildWhichIsA("ParticleEmitter").Enabled == false then
                    hum:TakeDamage(5)
                end
            end
        else
            hum:TakeDamage(5)
        end
    end
end

game.ReplicatedStorage.GameData.LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health < 10 then
        DEATHMESSAGE({"You died to who you call Frostbite...", "He will freeze you if you don't have a lighter!"}, "Frostbite")
    end

    -- 删除Frostbite模型
    if frostbiteModel then
        frostbiteModel:Destroy()
        frostbiteModel = nil
    end
end)

while true do
    wait(1)
    checkForLighter()
end

local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()

if not hasBeenHurt then
    achievementGiver({
        Title = "Frosty Experience",
        Desc = "Survived Frostbite without getting hurt.",
        Reason = "Encounter Frostbite.",
        Image = "rbxassetid://17857830685"
    })
end
