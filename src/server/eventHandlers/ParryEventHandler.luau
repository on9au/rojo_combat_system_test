local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ParryEvent = ReplicatedStorage:WaitForChild("ParryEvent")
local ParryValidationComponent = require(script.Parent.Parent.components.ParryValidationComponent)

ParryEvent.OnServerEvent:Connect(function(player)
    local currentTime = tick()

    -- Initialize ParryComponent
    ParryValidationComponent.init(player)

    local parryCooldownEndTime = player:GetAttribute("ParryCooldownEndTime") or 0

    -- Parry parameters (should match client)
    local parryDuration = 0.5
    local parryCooldown = 1.5

    if currentTime >= parryCooldownEndTime then
        -- Start parry
        player:SetAttribute("IsParrying", true)
        player:SetAttribute("ParryEndTime", currentTime + parryDuration)
        player:SetAttribute("ParryCooldownEndTime", currentTime + parryCooldown)
    else
        warn(player.Name .. " tried to parry during cooldown.")
    end
end)