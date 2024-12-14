-- 定义函数来获取自定义音效ID
local function GetGitSoundID(GithubSnd, SoundName)
    SoundName = tostring(SoundName)
    local url = GithubSnd
    local FileName = SoundName
    writefile("customObject_Sound_"..FileName..".mp3", game:HttpGet(url))
    return (getcustomasset or getsynasset)("customObject_Sound_"..FileName..".mp3")
end

local SelfModules = {
    Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))(),
}
