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

local function PlayCustomSound(GithubSnd, SoundName, Volume, shouldPlay)
    local SoundId = GetGitSoundID(GithubSnd, SoundName)
    local soundInstance = Instance.new("Sound")
    soundInstance.SoundId = SoundId
    soundInstance.Volume = Volume or 1
    soundInstance.Parent = workspace
    if shouldPlay then
        soundInstance:Play()
    end
    return soundInstance
end

return {
    GetGitSoundID = GetGitSoundID,
    PlayCustomSound = PlayCustomSound,
    SelfModules = SelfModules
}
