-- Services
local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local Players = game:GetService("Players")

-- Helper Module
local module = {}

local function timestampToMillis(timestamp)
    return (typeof(timestamp) == "string" and DateTime.fromIsoDate(timestamp).UnixTimestampMillis)
           or (typeof(timestamp) == "number" and timestamp)
           or timestamp.UnixTimestampMillis
end

module.LoadCustomAsset = function(url)
    if getcustomasset then
        if url:lower():sub(1, 4) == "http" then
            local fileName = "temp_" .. tick() .. ".txt"
            writefile(fileName, game:HttpGet(url))
            local result = getcustomasset(fileName)
            delfile(fileName)
            return result
        elseif isfile(url) then
            return getcustomasset(url)
        end
    else
        warn("Executor doesn't support 'getcustomasset', rbxassetid only.")
    end
    if url:find("rbxassetid") or tonumber(url) then
        return "rbxassetid://"..url:match("%d+")
    end
    error(debug.traceback("Failed to load custom asset for:\n"..url))
end

module.LoadCustomInstance = function(url)
    local success, result = pcall(function()
        return game:GetObjects(module.LoadCustomAsset(url))[1]
    end)
    if success then
        return result
    end
end

module.GetGameLastUpdate = function()
    return DateTime.fromIsoDate(MarketplaceService:GetProductInfo(game.PlaceId).Updated)
end

module.HasGameUpdated = function(timestamp)
    local millis = timestampToMillis(timestamp)
    if millis then
        return millis < module.GetGameLastUpdate().UnixTimestampMillis
    end
    return false
end

module.GetGitLastUpdate = function(owner, repo, filePath)
    local url = "https://api.github.com/repos/"..owner.."/"..repo.."/commits?per_page=1&path="..filePath
    local success, result = pcall(HttpService.JSONDecode, HttpService, game:HttpGet(url))
    if not success then
        error(debug.traceback("Failed to get last commit for:\n"..url))
    end
    return DateTime.fromIsoDate(result[1].commit.committer.date)
end

module.HasGitUpdated = function(owner, repo, filePath, timestamp)
    local millis = timestampToMillis(timestamp)
    if millis then
        return millis < module.GetGitLastUpdate(owner, repo, filePath).UnixTimestampMillis
    end
    return false
end

module.TruncateNumber = function(num, decimals)
    local shift = 10 ^ (decimals and math.max(decimals, 0) or 0)
    return num * shift // 1 / shift
end

-- Expose functions globally
for name, func in pairs(module) do
    if typeof(func) == "function" then
        getgenv()[name] = func
    end
end

-- UI Elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptEditorGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5, 0, 0.7, 0)
frame.Position = UDim2.new(0.25, 0, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Script Editor"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSans
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local codeEditorFrame = Instance.new("ScrollingFrame")
codeEditorFrame.Size = UDim2.new(1, -10, 0.4, 0)
codeEditorFrame.Position = UDim2.new(0.5, -codeEditorFrame.Size.X.Offset / 2, 0.15, 0)
codeEditorFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
codeEditorFrame.BorderSizePixel = 1
codeEditorFrame.ScrollBarThickness = 8
codeEditorFrame.Parent = frame

local codeEditor = Instance.new("TextBox")
codeEditor.Size = UDim2.new(1, -10, 1, 0)
codeEditor.Position = UDim2.new(0, 5, 0, 0)
codeEditor.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
codeEditor.TextColor3 = Color3.fromRGB(255, 255, 255)
codeEditor.Font = Enum.Font.Code
codeEditor.TextSize = 18
codeEditor.TextXAlignment = Enum.TextXAlignment.Left
codeEditor.TextYAlignment = Enum.TextYAlignment.Top
codeEditor.ClearTextOnFocus = false
codeEditor.MultiLine = true
codeEditor.TextWrapped = true
codeEditor.Parent = codeEditorFrame

local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(1, -10, 0.2, 0)
logFrame.Position = UDim2.new(0.5, -logFrame.Size.X.Offset / 2, 0.6, 0)
logFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
logFrame.BorderSizePixel = 1
logFrame.ScrollBarThickness = 8
logFrame.Parent = frame

local logText = Instance.new("TextLabel")
logText.Size = UDim2.new(1, -10, 1, 0)
logText.Position = UDim2.new(0, 5, 0, 0)
logText.BackgroundTransparency = 1
logText.TextColor3 = Color3.fromRGB(255, 255, 255)
logText.Font = Enum.Font.Code
logText.TextSize = 18
logText.TextXAlignment = Enum.TextXAlignment.Left
logText.TextYAlignment = Enum.TextYAlignment.Top
logText.TextWrapped = true
logText.Text = "Logs:\n"
logText.Parent = logFrame

local functionFrame = Instance.new("Frame")
functionFrame.Size = UDim2.new(1, -10, 0.1, 0)
functionFrame.Position = UDim2.new(0.5, -functionFrame.Size.X.Offset / 2, 0.75, 0)
functionFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
functionFrame.Visible = false
functionFrame.Parent = frame

local runButton = Instance.new("TextButton")
runButton.Text = "Run"
runButton.Size = UDim2.new(0.2, 0, 1, 0)
runButton.Position = UDim2.new(0.4, 0, 0, 0)
runButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
runButton.TextColor3 = Color3.fromRGB(255, 255, 255)
runButton.Font = Enum.Font.SourceSans
runButton.TextSize = 24
runButton.Parent = functionFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Text = "Show/Hide Functions"
toggleButton.Size = UDim2.new(0.3, 0, 0.1, 0)
toggleButton.Position = UDim2.new(0.35, 0, 0.85, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 24
toggleButton.Parent = frame

local urlInput = Instance.new("TextBox")
urlInput.Size = UDim2.new(0.6, 0, 0.1, 0)
urlInput.Position = UDim2.new(0.05, 0, 0.85, 0)
urlInput.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
urlInput.TextColor3 = Color3.fromRGB(255, 255, 255)
urlInput.Font = Enum.Font.Code
urlInput.TextSize = 18
urlInput.PlaceholderText = "Enter URL to fetch script..."
urlInput.Parent = frame

local fetchButton = Instance.new("TextButton")
fetchButton.Text = "Fetch Script"
fetchButton.Size = UDim2.new(0.3, 0, 0.1, 0)
fetchButton.Position = UDim2.new(0.7, 0, 0.85, 0)
fetchButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fetchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fetchButton.Font = Enum.Font.SourceSans
fetchButton.TextSize = 24
fetchButton.Parent = frame

-- Fetch Button Click Event
fetchButton.MouseButton1Click:Connect(function()
    local url = urlInput.Text
    if url ~= "" then
        local success, response = pcall(function()
            return HttpService:GetAsync(url)
        end)
        if success then
            codeEditor.Text = response
            logText.Text = logText.Text .. "\n[INFO] Script fetched successfully from " .. url
        else
            logText.Text = logText.Text .. "\n[ERROR] Failed to fetch script from " .. url
        end
    else
        logText.Text = logText.Text .. "\n[ERROR] URL cannot be empty."
    end
end)

-- Toggle Button Click Event
toggleButton.MouseButton1Click:Connect(function()
    functionFrame.Visible = not functionFrame.Visible
end)

-- Log Service
LogService.MessageOut:Connect(function(message, messageType)
    if messageType == Enum.MessageType.MessageOutput then
        logText.Text = logText.Text .. "\n[INFO] " .. message
    elseif messageType == Enum.MessageType.MessageWarning then
        logText.Text = logText.Text .. "\n[WARNING] " .. message
    elseif messageType == Enum.MessageType.MessageError then
        logText.Text = logText.Text .. "\n[ERROR] " .. message
    end
end)

-- Run Button Click Event
runButton.MouseButton1Click:Connect(function()
    local code = codeEditor.Text
    local func, err = loadstring(code)
    if func then
        local success, result = pcall(func)
        if success then
            print("[INFO] Script executed successfully")
        else
            warn("[ERROR] Execution error: " .. result)
        end
    else
        warn("[ERROR] Load error: " .. err)
    end
end)
