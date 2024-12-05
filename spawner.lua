local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

_G.EntitySpawner = {}

-- 加载模型并获取对象
function _G.EntitySpawner:LoadModelAndGetObject(params)
    -- 加载模型
    local model = game:GetObjects("rbxassetid://" .. params.Asset)[1]
    if model then
        _G.entity = model

        -- 确保模型有 PrimaryPart
        if not _G.entity.PrimaryPart then
            _G.entity.PrimaryPart = _G.entity:FindFirstChildWhichIsA("BasePart") or _G.entity:FindFirstChildWhichIsA("MeshPart")
        end

        _G.entity.PrimaryPart.Anchored = true
        _G.entity.PrimaryPart.CanCollide = false  -- 确保碰撞检测关闭
        _G.entity.Parent = Workspace

        -- 获取指定房间的入口和出口
        self:FindFarthestRoomExit()
        
        -- 将实体位置设定在入口位置
        if _G.positions and _G.positions.entrancePos then
            _G.entity:SetPrimaryPartCFrame(CFrame.new(_G.positions.entrancePos))
        else
            error("Entrance position not found.")
        end

        -- 自定义颜色
        if params.EnableCustomColor then
            self:PlaceColor(params.CustomColor)
        end
    else
        error("Model not found in asset")
    end
end

-- 自定义颜色
function _G.EntitySpawner:PlaceColor(color)
    local tweenInfo = TweenInfo.new(3)
    local colorInfo = {Color = color}
    for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
        if v:IsA("Light") then
            TweenService:Create(v, tweenInfo, colorInfo):Play()
            if v.Parent.Name == "LightFixture" then
                TweenService:Create(v.Parent, tweenInfo, colorInfo):Play()
            end
        end
    end
end

-- 查找最远的RoomExit
function _G.EntitySpawner:FindFarthestRoomExit()
    local farthestDistance = 0
    local farthestExit = nil
    for _, room in pairs(Workspace.CurrentRooms:GetChildren()) do
        local roomExit = room:FindFirstChild("RoomExit")
        if roomExit then
            local distance = (roomExit.Position - _G.entity.PrimaryPart.Position).Magnitude
            if distance > farthestDistance then
                farthestDistance = distance
                farthestExit = roomExit
            end
        end
    end

    if farthestExit then
        _G.positions = {entrancePos = _G.entity.PrimaryPart.Position, exitPos = farthestExit.Position}
    else
        error("No RoomExit found in currentRooms.")
    end
end

-- 动画移动实体
function _G.EntitySpawner:MoveTo(position, speed)
    local primaryPart = _G.entity.PrimaryPart
    primaryPart.Anchored = true
    primaryPart.CanCollide = false  -- 确保碰撞检测关闭

    -- 动画移动
    local tweenInfo = TweenInfo.new((primaryPart.Position - position).Magnitude / speed)
    local tweenGoal = {CFrame = CFrame.new(position)}
    local tween = TweenService:Create(primaryPart, tweenInfo, tweenGoal)
    tween:Play()
    tween.Completed:Wait()
end

-- 震动效果
function _G.EntitySpawner:Shake(duration, intensity)
    -- 确保玩家的相机跟随他们的角色
    local player = Players.LocalPlayer
    local character = player.Character
    local camera = Workspace.CurrentCamera
    camera.CameraSubject = character and character:FindFirstChildWhichIsA("Humanoid")

    -- 震动效果
    for i = 1, duration * 60 do
        -- 使相机同步震动
        if camera then
            camera.CFrame = camera.CFrame * CFrame.new(
                math.random() * intensity - intensity / 2,
                math.random() * intensity - intensity / 2,
                math.random() * intensity - intensity / 2
            )
        end

        RunService.Heartbeat:Wait()
    end
end

-- 反弹逻辑
function _G.EntitySpawner:Rebound(minRebounds, maxRebounds, waitSeconds, moveSpeed)
    local reboundTimes = math.random(minRebounds, maxRebounds)
    for i = 1, reboundTimes do
        self:MoveTo(_G.positions.exitPos, moveSpeed)
        self:Shake(1, 0.2)  -- 震动效果
        wait(waitSeconds)
        self:MoveTo(_G.positions.entrancePos, moveSpeed)
        self:Shake(1, 0.2)  -- 震动效果
        wait(waitSeconds)
    end
end

-- 播放下坠动画
function _G.EntitySpawner:PlayFallAnimation()
    local primaryPart = _G.entity.PrimaryPart
    primaryPart.Anchored = true
    primaryPart.CanCollide = false
    for i = 1, 100 do
        primaryPart.Position = primaryPart.Position - Vector3.new(0, 0.1, 0)
        RunService.Heartbeat:Wait()
    end
end

-- 检测范围内是否有玩家
function _G.EntitySpawner:CheckForPlayers(range)
    local primaryPart = _G.entity.PrimaryPart
    for _, player in pairs(Players:GetPlayers()) do
        local character = player.Character
        if character and character.PrimaryPart then
            local distance = (character.PrimaryPart.Position - primaryPart.Position).magnitude
            if distance <= range and not character:GetAttribute("Hiding") then
                -- 触发伤害逻辑
                local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    humanoid:TakeDamage(humanoid.MaxHealth)  -- 造成最大伤害
                end
                -- 发送死亡消息
                self:SendDeathMessage(_G.deathMessage, _G.entity.Name)
                -- 执行jumpscare（如果启用）
                if _G.enableJumpscare then
                    self:Jumpscare(_G.jumpscareImageID, _G.jumpscareAudioID)
                end
            end
        end
    end
end

-- 发送死亡消息
function _G.EntitySpawner:SendDeathMessage(message, who)
    spawn(function()
        for i = 1, 50 do 
            wait()
            game:GetService("ReplicatedStorage").GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = who
            debug.setupvalue(getconnections(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent)[1].Function, 1, message, 'Blue')
        end
    end)
end

-- 执行jumpscare
function _G.EntitySpawner:Jumpscare(imageID, audioID)
    local jumpscare = loadstring(game:HttpGet("https://raw.githubusercontent.com/munciseek/NIDO-HUD/main/Custom-jumpscare/Source"))()
    local JS = jumpscare.Create({
        image = {
            Asset = "rbxassetid://" .. imageID
        },
        Audio = {
            Asset = "rbxassetid://" .. audioID,
            AC = false -- Play full audio
        }
    })
    JS:Run()
end

-- 导航逻辑
function _G.EntitySpawner:NavigateToRoom(params)
    if not _G.positions.entrancePos or not _G.positions.exitPos then return end

    -- 移动前等待时间
    wait(params.WaitBeforeMove or 0)

    _G.entity:SetPrimaryPartCFrame(CFrame.new(_G.positions.entrancePos))
    self:MoveTo(_G.positions.exitPos, params.MoveSpeed)
    wait(params.waitsecond)

    if params.Rebound then
        self:Rebound(params.Min, params.Max, params.waitsecond, params.MoveSpeed)
    end

    -- 检测范围内是否有玩家
    self:CheckForPlayers(params.DetectionRange)
end
