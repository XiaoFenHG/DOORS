function a90()
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = game.Players.LocalPlayer
    local UI = game.Players.LocalPlayer.PlayerGui.MainUI
    local Jumpscare_A90 = UI.Jumpscare.Jumpscare_A90
    local A90Module = UI.Initiator.Main_Game.RemoteListener.Modules.A90
    local MainGame = require(UI.Initiator.Main_Game)

    local Attacking = true
    local Moved = false
    local LookVector4 = MainGame.cam.CFrame.LookVector

    game.SoundService.Main.Volume = 0

    Jumpscare_A90.Face.Image = "http://www.roblox.com/asset/?id=12635832722"
    Jumpscare_A90.FaceAngry.Image = "http://www.roblox.com/asset/?id=12635955412"

    A90Module.Spawn:Play()

    Jumpscare_A90.BackgroundTransparency = 1
    Jumpscare_A90.Face.Visible = true
    Jumpscare_A90.FaceAngry.Visible = false
    Jumpscare_A90.Static.Visible = true
    Jumpscare_A90.Static2.Visible = true
    Jumpscare_A90.Static.ImageTransparency = 1
    Jumpscare_A90.Static2.ImageTransparency = 1

    Jumpscare_A90.Face.ImageColor3 = Color3.new(0, 0, 0)
    Jumpscare_A90.Face.Rotation = Random.new():NextNumber(-5, 5)
    Jumpscare_A90.Face.Position = UDim2.new(Random.new():NextNumber(10, 90) / 100, 0, Random.new():NextNumber(10, 90) / 100, 0)
    Jumpscare_A90.Visible = true

    task.wait(0.03)
    Jumpscare_A90.Face.ImageColor3 = Color3.new(1, 1, 1)
    task.wait(0.28)

    Jumpscare_A90.BackgroundTransparency = 0
    Jumpscare_A90.Face.Rotation = 0
    Jumpscare_A90.Face.Position = UDim2.new(0.5, 0, 0.49, 0)
    task.wait(0.03)

    Jumpscare_A90.StopIcon.Visible = true
    Jumpscare_A90.BackgroundColor3 = Color3.new(0, 0, 0)
    Jumpscare_A90.BackgroundTransparency = 1
    Jumpscare_A90.Static.ImageTransparency = 0.8
    Jumpscare_A90.Static2.ImageTransparency = 0.8

    task.delay(0.2, function()
        Jumpscare_A90.StopIcon.Visible = false

        while Attacking do
            local MathRandom = math.random(0, 1)
            local BaseValue = 100

            task.wait(0.03)

            Jumpscare_A90.Static.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
            Jumpscare_A90.Static.Rotation = math.random(0, 1) * 180
            Jumpscare_A90.Static2.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
            Jumpscare_A90.Static2.Rotation = math.random(0, 1) * 180
            Jumpscare_A90.Face.Position = UDim2.new(0.5, 0, 0.49, math.random(-1, 1))
            Jumpscare_A90.FaceAngry.Position = UDim2.new(0.5 + Random.new():NextNumber(-BaseValue, BaseValue) / 50000, 0, 0.49 + Random.new():NextNumber(-BaseValue, BaseValue) / 30000, math.random(-1, 1))

            Jumpscare_A90.FaceAngry.Rotation = Random.new():NextNumber(-1, 1) * 0.0015
            Jumpscare_A90.FaceAngry.ImageColor3 = Color3.new(1, MathRandom, MathRandom)

            if not Moved then
                if (LookVector4 - MainGame.cam.CFrame.LookVector).Magnitude > 0.4 then
                    Moved = true
                elseif MainGame.hum.MoveDirection.Magnitude > 0.4 then
                    Moved = true
                end
            end
        end
    end)

    task.wait(0.3)

    Jumpscare_A90.BackgroundColor3 = Color3.new(0, 0, 0)
    Jumpscare_A90.BackgroundTransparency = 0
    Jumpscare_A90.Static.ImageTransparency = 0
    Jumpscare_A90.Static2.ImageTransparency = 0.5
    task.wait(0.03)
    Jumpscare_A90.Face.ImageColor3 = Color3.new(1, 0, 0)
    task.wait(0.03)
    Jumpscare_A90.Visible = false
    task.wait(0.08)

    if Moved then
        Jumpscare_A90.Visible = true
        A90Module.Hit:Play()
        task.wait(0.03)
        Jumpscare_A90.Face.ImageColor3 = Color3.new(1, 1, 1)
        task.wait(0.03)
        Jumpscare_A90.BackgroundTransparency = 0
        Jumpscare_A90.Static.ImageTransparency = 0
        Jumpscare_A90.Static2.ImageTransparency = 0.5
        task.wait(0.067)
        Jumpscare_A90.FaceAngry.Size = UDim2.new(0.8, 0, 0.8, 0)
        Jumpscare_A90.FaceAngry.Rotation = 0
        Jumpscare_A90.FaceAngry.ImageTransparency = 0
        Jumpscare_A90.FaceAngry.ImageColor3 = Color3.new(1, 0, 0)
        Jumpscare_A90.FaceAngry.Visible = true
        task.wait(0.067)
        Jumpscare_A90.FaceAngry.ImageColor3 = Color3.new(1, 1, 1)
        Jumpscare_A90.Face.Visible = false
        task.wait(0.75)
        LocalPlayer.Character.Humanoid.Health -= 70
        firesignal(game.ReplicatedStorage.EntityInfo.DeathHint.OnClientEvent, {"You died to an entity designated as A-90...", "As long as you don't make a move, it won't harm you...", "React fast and don't move a muscle!"}, "Blue")
        task.wait(0.1)
        Jumpscare_A90.FaceAngry.Visible = false
        Jumpscare_A90.BackgroundColor3 = Color3.new(1, 1, 1)
        Jumpscare_A90.Static.ImageTransparency = 1
        Jumpscare_A90.Static2.ImageTransparency = 1
        task.wait(0.067)
        Jumpscare_A90.BackgroundColor3 = Color3.new(1, 0, 0)
        task.wait(0.067)
        Jumpscare_A90.BackgroundColor3 = Color3.new(0, 0, 0)
        task.wait(0.067)
        Attacking = false
        task.wait(0.03)
        A90Module.Spawn:Stop()
        Jumpscare_A90.BackgroundTransparency = 1
        Jumpscare_A90.Static.ImageTransparency = 0.5
        Jumpscare_A90.Static2.ImageTransparency = 0.5
        TweenService:Create(Jumpscare_A90.Static, TweenInfo.new(20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 1,
        }):Play()
        TweenService:Create(Jumpscare_A90.Static2, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 1,
        }):Play()
        local SizeRandomizer = Random.new():NextNumber(2, 3)
        Jumpscare_A90.FaceAngry.Rotation = Random.new():NextNumber(-3, 3)
        Jumpscare_A90.FaceAngry.Visible = true
        Jumpscare_A90.FaceAngry.ImageColor3 = Color3.new(1, 0, 0)
        Jumpscare_A90.FaceAngry.Size = UDim2.new(SizeRandomizer, 0, SizeRandomizer, 0)
        TweenService:Create(Jumpscare_A90.FaceAngry, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 1,
        }):Play()
        game.SoundService.Main.Volume = 0
        game.SoundService.Main.EqualizerSoundEffect.Enabled = true
        game.SoundService.Main.EqualizerSoundEffect.HighGain = -50
        game.SoundService.Main.EqualizerSoundEffect.LowGain = 10
        game.SoundService.Main.EqualizerSoundEffect.MidGain = -50
        TweenService:Create(game.SoundService.Main.EqualizerSoundEffect, TweenInfo.new(15, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
            LowGain = 0,
            HighGain = 0,
            MidGain = 0,
        }):Play()
        TweenService:Create(game.SoundService.Main, TweenInfo.new(5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Volume = 1,
        }):Play()
    else
        A90Module.Spawn:Stop()
        Jumpscare_A90.BackgroundTransparency = 1
        Jumpscare_A90.Visible = false
        Attacking = false
        game.SoundService.Main.Volume = 1
    end
end
