-- 定义函数来获取自定义音效ID
local function GetGitSoundID(GithubSnd, SoundName)
    SoundName = tostring(SoundName)
    local url = GithubSnd
    local FileName = SoundName
    writefile("customObject_Sound_"..FileName..".mp3", game:HttpGet(url))
    return (getcustomasset or getsynasset)("customObject_Sound_"..FileName..".mp3")
end

-- 定义播放自定义音效的函数
local function PlayCustomSound(GithubSnd, SoundName, Volume)
    local SoundId = GetGitSoundID(GithubSnd, SoundName)
    local soundInstance = Instance.new("Sound")
    soundInstance.SoundId = SoundId
    soundInstance.Volume = Volume or 1
    soundInstance.Parent = workspace
    soundInstance:Play()
    return soundInstance
end

-- 创建一个函数来循环检查音效是否正在播放
local function EnsureSoundIsPlaying(soundInstance)
    while true do
        wait(0.0001)
        if not soundInstance.IsPlaying then
            soundInstance:Play()
        end
    end
end

