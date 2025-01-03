local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 加载模块
local vynixuModules = {
    Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
}
local assets = {
    Repentance = vynixuModules.Functions.LoadCustomInstance("https://github.com/RegularVynixu/Utilities/blob/main/Doors/Entity%20Spawner/Assets/Repentance.rbxm?raw=true")
}

_G.EntitySpawner = {}

-- 加载模型并获取对象
function _G.EntitySpawner:LoadModelAndGetObject(params)
    -- 加载模型
    local asset = params.Asset
    local success, entityModel

    if typeof(asset) == "Instance" and asset:IsA("Model") then
        success, entityModel = true, asset

    elseif typeof(asset) == "string" then
        success, entityModel = pcall(function()
            local m = vynixuModules.Functions.LoadCustomInstance(asset)
            if m then
                if m.ClassName ~= "Model" then
                    warn("Entity asset is not a model, returning.")
                    return
                end
            else
                warn("Failed to load entity asset, returning.")
                return
            end
            return m
        end)

    elseif typeof(asset) == "number" then
        success, entityModel = pcall(function()
            return game:GetObjects("rbxassetid://" .. asset)[1]
        end)

    else
        warn("Invalid entity asset type, returning.")
        return
    end

    -- Construct and return entityTable
    if success and entityModel then
        local root = entityModel.PrimaryPart or entityModel:FindFirstChildWhichIsA("BasePart")
        if root then
            root.Anchored = true
            entityModel.PrimaryPart = root

            -- Entity custom name
            local c = params
            if c.Name and c.Name ~= "" then
                entityModel.Name = c.Name
            end

            -- Entity default attributes
            for name, value in pairs(params.DefaultAttributes or {}) do
                entityModel:SetAttribute(name, value)
            end

            _G.entity = entityModel
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

-- -- 查找房间入口
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
        -- 只移动 x 和 z 轴，不移动 y 轴
        local targetCFrame = CFrame.new(cframe.Position.X, _G.entity.PrimaryPart.Position.Y, cframe.Position.Z)
        -- 移动到路径节点
        self:MoveTo(targetCFrame, speed)

        -- 在移动时检查范围内是否有玩家
        self:CheckForPlayers(speed, targetCFrame)

        if i == #nodes then
            -- 移动到出口
            self:MoveTo(CFrame.new(_G.positions.exitPos.Position.X, _G.entity.PrimaryPart.Position.Y, _G.positions.exitPos.Position.Z), speed)
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
    if (cframe.Position - _G.positions.exitPos.Position).Magnitude < 1 then
        -- 播放下坠动画并消失
        self:PlayFallAnimation()
        _G.entity:Destroy()
    elseif _G.params.Rebound and type(_G.params.Rebound) == "number" and _G.params.Rebound > 0 then
        _G.params.Rebound = _G.params.Rebound - 1
        self:FindEntrance()  -- 找回入口
        self:MoveAlongPath(_G.params.MoveSpeed)  -- 重新沿路径移动
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

    -- 路径更新逻辑，始终保持更新
    coroutine.wrap(function()
        while true do
            ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function(v)
                local room = Workspace.CurrentRooms[v]
                local nextRoom = Workspace.CurrentRooms[tostring(v + 1)]
                for _, r in pairs({room, nextRoom}) do
                    if r then
                        local nodes = r:FindFirstChild("PathfindNodes")
                        if nodes then
                            nodes = nodes:Clone()
                            nodes.Parent = r
                            nodes.Name = 'Nodes'
                        end
                    end
                end
            end)
            wait(0.1)  -- 添加一个短暂的等待时间以防止过度频繁的更新
        end
    end)()

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
