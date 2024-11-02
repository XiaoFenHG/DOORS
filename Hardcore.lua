local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

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

-- Other coroutine functions remain unchanged

coroutine.wrap(function()
    while true do
        wait(math.random(600,610))
        game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
        require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("???",true)
        loadstring(game.HttpGet("https://pastebin.com/raw/jTEPNkrV"))()
    end
end)()

coroutine.wrap(function()
    while true do
        wait(math.random(10,100))
        loadstring(game.HttpGet("https://github.com/XiaoFenHG/DOORS/blob/main/nah.lua?raw=true"))()
    end
end)()

coroutine.wrap(function()
    while true do
        wait(450)
        loadstring(game.HttpGet("https://github.com/XiaoFenHG/DOORS/blob/main/sug.lua?raw=true"))()
    end
end)()

coroutine.wrap(function()
    while true do
        wait(250)
        loadstring(game.HttpGet("https://github.com/XiaoFenHG/DOORS/blob/main/der.lua?raw=true"))()
    end
end)()

require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("Hardcore mode Initiated",true)
