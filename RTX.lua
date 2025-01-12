local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- 禁用内置的光影效果
Lighting.Brightness = 0.2
Lighting.Ambient = Color3.new(0, 0, 0)
Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
Lighting.GlobalShadows = false
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- 等待玩家角色加载
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- 设置太阳方向和颜色
local sunDirection = Vector3.new(1, -1, 1).Unit
local sunColor = Color3.fromRGB(255, 255, 224)
local sunIntensity = 100

-- 设置天空颜色和强度
local skyColor = Color3.fromRGB(135, 206, 235)
local skyIntensity = 0.5

-- 设置光影参数
local maxDistance = 50000
local gammaCorrection = 10
local maxRays = 100000
local minRays = 10000
local lodDistance = 200

-- 错误处理函数
local function safeCall(func, ...)
    local success, result = pcall(func, ...)
    return success, result
end
-- 计算反射方向
local function computeReflection(ray, hitNormal)
    return ray.Direction - 2 * ray.Direction:Dot(hitNormal) * hitNormal
end

-- 检查是否在阴影中
local function isInShadow(ray, distance)
    local hit, hitPosition = Workspace:FindPartOnRay(ray, nil)
    if hit and (hitPosition - ray.Origin).Magnitude < distance then
        return true
    end
    return false
end

-- 获取表面法向量
local function getSurfaceNormal(part, position)
    if part:IsA("MeshPart") or part:IsA("UnionOperation") then
        -- 估计MeshParts和Unions的法向量
        local normal = (position - part.Position).Unit
        return normal
    else
        local relativePosition = part.CFrame:PointToObjectSpace(position)
        local halfSize = part.Size / 2
        local normals = {
            Vector3.new(1, 0, 0),
            Vector3.new(-1, 0, 0),
            Vector3.new(0, 1, 0),
            Vector3.new(0, -1, 0),
            Vector3.new(0, 0, 1),
            Vector3.new(0, 0, -1)
        }
        local distances = {
            math.abs(halfSize.X - relativePosition.X),
            math.abs(-halfSize.X - relativePosition.X),
            math.abs(halfSize.Y - relativePosition.Y),
            math.abs(-halfSize.Y - relativePosition.Y),
            math.abs(halfSize.Z - relativePosition.Z),
            math.abs(-halfSize.Z - relativePosition.Z)
        }
        local minDistance = math.huge
        local normal = Vector3.new(0, 1, 0)
        for i = 1, 6 do
            if distances[i] < minDistance then
                minDistance = distances[i]
                normal = normals[i]
            end
        end
        return part.CFrame:VectorToWorldSpace(normal)
    end
end

-- 计算光照函数
local function computeLightingForPoint(part, position)
    local accumulatedColor = Color3.new(0, 0, 0)
    local surfaceNormalSuccess, surfaceNormal = safeCall(getSurfaceNormal, part, position) -- 添加错误处理
    if not surfaceNormalSuccess then
        return accumulatedColor -- 如果发生错误，返回默认颜色
    end
    local offsetPosition = position + surfaceNormal * 0.01
    local distanceFromCamera = (camera.CFrame.Position - position).Magnitude
    local numRays = maxRays
    if distanceFromCamera > lodDistance then
        numRays = math.max(minRays, math.floor(maxRays * (lodDistance / distanceFromCamera)))
    end

    -- 检查太阳光是否被遮挡
    local sunRay = Ray.new(offsetPosition, sunDirection * maxDistance)
    if not safeCall(isInShadow, sunRay, maxDistance) then
        accumulatedColor = accumulatedColor + sunColor * sunIntensity
    end

    -- 累积来自天空的光
    local skyLight = skyColor * skyIntensity
    accumulatedColor = accumulatedColor + skyLight

    -- 模拟光线追踪和反射
    for i = 1, numRays do
        local randomDirection = Vector3.new(math.random(), math.random(), math.random()).Unit
        local ray = Ray.new(offsetPosition, randomDirection * maxDistance)
        local success, hit, hitPosition, hitNormal = safeCall(Workspace.FindPartOnRay, Workspace, ray, part)
        if success and hit then
            local reflectedDirection = computeReflection(ray, hitNormal)
            local reflectedRay = Ray.new(hitPosition, reflectedDirection * maxDistance)
            local reflectedSuccess, reflectedHit, reflectedHitPosition = safeCall(Workspace.FindPartOnRay, Workspace, reflectedRay, part)
            if reflectedSuccess and reflectedHit then
                local reflectedLight = (sunColor * sunIntensity + skyColor * skyIntensity) * math.max(0, hitNormal:Dot(reflectedDirection))
                accumulatedColor = accumulatedColor + reflectedLight
            end
        end
    end

    return accumulatedColor
end

-- 在RunService的RenderStepped中调用计算光照函数
-- 在RunService的RenderStepped中调用计算光照函数
RunService.RenderStepped:Connect(function(deltaTime)
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
            safeCall(function()
                local color = computeLightingForPoint(part, part.Position)
                part.Color = color
            end)
        end
    end
end)
