---====== Load spawner ======---

local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

---====== Create entity ======---

local entity = spawner.Create({
    Entity = {
        Name = "Deer God",
        Asset = "rbxassetid://12263106166",
        HeightOffset = 0
    },
    Lights = {
        Flicker = {
            Enabled = true,
            Duration = 1
        },
        Shatter = true,
        Repair = false
    },
    Earthquake = {
        Enabled = false
    },
    CameraShake = {
        Enabled = true,
        Range = 100,
        Values = {1.5, 20, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
    },
    Movement = {
        Speed = 350,
        Delay = 5,
        Reversed = false
    },
    Rebounding = {
        Enabled = true,
        Type = "Ambush", -- "Blitz"
        Min = 1,
        Max = 5,
        Delay = 0
    },
    Damage = {
        Enabled = true,
        Range = 75,
        Amount = 500
    },
    Crucifixion = {
        Enabled = true,
        Range = 40,
        Resist = false,
        Break = true
    },
    Death = {
        Type = "Guiding", -- "Curious"
        Hints = {"You die", ".", "..", ".."},
        Cause = "A60"
    }
})

---====== Debug entity ======---
entity:SetCallback("OnSpawned", function()
    print("spawned")
end)

entity:SetCallback("OnStartMoving", function()
    print("a")
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    if firstTime == true then
        print("Entity has entered room: ".. room.Name.. " for the first time")
    else
        print("Entity has entered room: ".. room.Name.. " again")
    end
end)

entity:SetCallback("OnLookAt", function(lineOfSight)
    if lineOfSight == true then
        print("Player is looking at entity")
    else
        print("Player view is obstructed by something")
    end
end)

entity:SetCallback("OnRebounding", function(startOfRebound)
    if startOfRebound == true then
        print("Entity has started rebounding")
    else
        print("Entity has finished rebounding")
    end
end)

entity:SetCallback("OnDespawning", function()
    print("Entity is despawning")
end)

entity:SetCallback("OnDespawned", function()
    print("Entity has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
    if newHealth == 0 then
        print("Entity has killed the player")
    else
        print("Entity has damaged the player")
    end
end)

--[[

DEVELOPER NOTE:
By overwriting 'CrucifixionOverwrite' the default crucifixion callback will be replaced with your custom callback.

entity:SetCallback("CrucifixionOverwrite", function()
    print("Custom crucifixion callback")
end)

]]--

---====== Run entity ======---

entity:Run()
