local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ParryEvent = ReplicatedStorage:WaitForChild("ParryEvent")
local ParryValidationComponent = require(script.Parent.Parent.components.ParryValidationComponent)
local ServerCooldownComponent = require(script.Parent.Parent.components.ServerCooldownComponent)

ParryEvent.OnServerEvent:Connect(function(player)
    local currentTime = tick()

    -- Initialize ParryComponent
    ParryValidationComponent.init(player)
    ServerCooldownComponent.init(player)

    local ServerLastActionTime = player:GetAttribute("ServerLastActionTime") or 0

    -- Parry parameters (should match client)
    local parryDuration = 0.2 -- Duration of the parry window
	local parryCooldown = 0.22 -- Cooldown after parry

    if currentTime - ServerLastActionTime >= parryCooldown - 0.02 then -- Allow for a 20ms margin of error
        -- Start parry
        player:SetAttribute("IsParrying", true)
        player:SetAttribute("ServerParryEndTime", currentTime + parryDuration)
        player:SetAttribute("ParryCooldownEndTime", currentTime + parryCooldown)

        player:SetAttribute("ServerLastActionTime", currentTime)
    else
        warn(player.Name .. " tried to parry during cooldown.")
    end
end)

return nil