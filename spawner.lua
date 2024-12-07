local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

_G.EntitySpawner = {}

-- 加载模型并获取对象
function _G.EntitySpawner:LoadModelAndGetObject(params)
    -- 加载模型
    local model = game:GetObjects("rbxassetid://" .. params.Asset)[1]
    if model then
        _G.entity = model
        _G.entity.Name = params.DeathCause  -- 设置实体的名字为 DeathCause

        -- 确保模型有 PrimaryPart
        if not _G.entity.PrimaryPart then
            _G.entity.PrimaryPart = _G.entity:FindFirstChildWhichIsA("BasePart") or _G.entity:FindFirstChildWhichIsA("MeshPart")
        end

        _G.entity.PrimaryPart.Anchored = true
        _G.entity.PrimaryPart.CanCollide = false  -- 确保碰撞检测关闭
        _G.entity.Parent = Workspace

        -- 获取入口位置
        self:FindEntrance()

        -- 将实体位置设定在入口位置
        if _G.positions and _G.positions.entrancePos then
            _G.entity:SetPrimaryPartCFrame(_G.positions.entrancePos)
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

-- 查找房间入口
function _G.EntitySpawner:FindEntrance()
    local entrance = nil

    for _, room in pairs(Workspace.CurrentRooms:GetChildren()) do
        local roomEntrance = room:FindFirstChild("RoomEntrance")
        if roomEntrance then
            entrance = roomEntrance.CFrame
            break  -- 假设只有一个入口，找到后立即退出循环
        end
    end

    if entrance then
        _G.positions = {entrancePos = entrance}
    else
        error("No RoomEntrance found in currentRooms.")
    end
end

-- 查找最远的出口
function _G.EntitySpawner:FindFarthestExit()
    local farthestDistance = 0
    local exit = nil

    for _, room in pairs(Workspace.CurrentRooms:GetChildren()) do
        local roomExit = room:FindFirstChild("RoomExit")
        if roomExit then
            local distance = (roomExit.CFrame.Position - _G.positions.entrancePos.Position).Magnitude
            if distance > farthestDistance then
                farthestDistance = distance
                exit = roomExit.CFrame
            end
        end
    end

    if exit then
        _G.positions.exitPos = exit
    else
        error("No RoomExit found in currentRooms.")
    end
end

-- 获取路径节点并按顺序移动
function _G.EntitySpawner:MoveAlongPath(speed)
    local nodes = {}
    local latestRoom = ReplicatedStorage.GameData.LatestRoom.Value

    for i = 1, latestRoom do
        local room = Workspace.CurrentRooms:FindFirstChild(tostring(i))
        if room then
            local pathNodes = room:FindFirstChild("Nodes") or room:FindFirstChild("PathfindNodes")
            if pathNodes then
                for _, part in pairs(pathNodes:GetChildren()) do
                    if part:IsA("BasePart") then
                        table.insert(nodes, part.CFrame)
                    end
                end
            end
        end
    end

    table.sort(nodes, function(a, b)
        return (a.Position - _G.positions.entrancePos.Position).Magnitude < (b.Position - _G.positions.entrancePos.Position).Magnitude
    end)

    for i, cframe in ipairs(nodes) do
        -- 移动到路径节点
        self:MoveTo(cframe, speed)

        -- 在移动时检查范围内是否有玩家
        self:CheckForPlayers(speed, cframe)

        if i == #nodes then
            -- 移动到出口
            self:MoveTo(_G.positions.exitPos, speed)
        end
    end
end

-- 移动实体
function _G.EntitySpawner:MoveTo(cframe, speed)
    local primaryPart = _G.entity.PrimaryPart
    primaryPart.Anchored = true
    primaryPart.CanCollide = false  -- 确保碰撞检测关闭

    -- 确保直线移动
    local distance = (primaryPart.Position - cframe.Position).Magnitude
    local moveTime = distance / speed
    local tweenInfo = TweenInfo.new(moveTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tweenGoal = {CFrame = cframe}
    local tween = TweenService:Create(primaryPart, tweenInfo, tweenGoal)
    tween:Play()
    tween.Completed:Wait()

    -- 检查是否到达出口
    if cframe == _G.positions.exitPos then
        if _G.params.Rebound and _G.params.Rebound > 0 then
            _G.params.Rebound = _G.params.Rebound - 1
            self:FindEntrance()  -- 找回入口
            self:MoveAlongPath(_G.params.MoveSpeed)  -- 重新沿路径移动
        else
            -- 播放下坠动画并消失
            self:PlayFallAnimation()
            _G.entity:Destroy()
        end
    end
end

-- 导航逻辑
function _G.EntitySpawner:NavigateToRoom(params)
    -- 设置全局参数
    _G.params = params

    -- 确保入口和出口位置已设置
    if not _G.positions or not _G.positions.entrancePos then
        error("Entrance position not set.")
    end

    -- 查找最远的出口位置
    self:FindFarthestExit()

    -- 将实体位置设定在入口位置
    _G.entity:SetPrimaryPartCFrame(_G.positions.entrancePos)

    -- 路径更新逻辑
    ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function(v)
        local room = Workspace.CurrentRooms[v]
        local nodes = room:FindFirstChild("PathfindNodes")
        if nodes then
            nodes = nodes:Clone()
            nodes.Parent = room
            nodes.Name = 'Nodes'
        end
    end)

    -- 移动前等待时间
    wait(params.WaitBeforeMove or 0)

    -- 按路径节点移动
    self:MoveAlongPath(params.MoveSpeed)

    -- 检测范围内是否有玩家
    self:CheckForPlayers(params.DetectionRange)
end

-- 播放下坠动画
function _G.EntitySpawner:PlayFallAnimation()
    local primaryPart = _G.entity.PrimaryPart
    primaryPart.Anchored = false
    primaryPart.CanCollide = false
    for i = 1, 100 do
        primaryPart.CFrame = primaryPart.CFrame * CFrame.new(0, -0.1, 0)
        RunService.Heartbeat:Wait()
    end
end

-- 检测范围内是否有玩家
function _G.EntitySpawner:CheckForPlayers(speed, cframe)
    local primaryPart = _G.entity.PrimaryPart
    for _, player in pairs(Players:GetPlayers()) do
        local character = player.Character
        if character and character.PrimaryPart then
            local distance = (character.PrimaryPart.Position - primaryPart.Position).Magnitude
            if distance <= _G.params.DetectionRange and not character:GetAttribute("Hiding") then
                -- 触发伤害逻辑
                local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    humanoid:TakeDamage(humanoid.MaxHealth)  -- 造成最大伤害
                end
                -- 发送死亡消息，并将 Cause 设置为实体名字
                self:SendDeathMessage(_G.params.DeathMessage, _G.entity.Name)
                game:GetService("ReplicatedStorage").GameStats["Player_".. player.Name].Total.DeathCause.Value = _G.entity.Name
                -- 执行jumpscare（如果启用）
                if _G.params.EnableJumpscare then
                    self:Jumpscare(_G.params.JumpscareImageID, _G.params.JumpscareAudioID)
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
