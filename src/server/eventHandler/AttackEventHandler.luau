-- src/server/AttackEventHandler.luau

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AttackEvent = ReplicatedStorage:WaitForChild("AttackEvent")
local PrimaryItems = require(ReplicatedStorage.Shared.primaryItems.PrimaryItems)

AttackEvent.OnServerEvent:Connect(function(player, actionName, comboCount)
    print(player, actionName, comboCount)
    local primaryActionItem = PrimaryItems[actionName]
    if primaryActionItem then
        -- Set hitbox attributes
        player:SetAttribute("HitboxSize", primaryActionItem.hitboxSize)
        player:SetAttribute("HitboxOffset", primaryActionItem.hitboxOffset)
        if comboCount == primaryActionItem.maxComboCount then
            player:SetAttribute("Damage", primaryActionItem.maxComboDamage)
            player:SetAttribute("CooldownEndTime", tick() + primaryActionItem.maxComboCooldownTime)
        else
            player:SetAttribute("Damage", primaryActionItem.damage)
            player:SetAttribute("CooldownEndTime", tick() + primaryActionItem.cooldownTime)
        end
        player:SetAttribute("IsActive", true)
        player:SetAttribute("MoveForward", primaryActionItem.moveForward)

        -- Set movement adjustments
        player:SetAttribute("SpeedMultiplier", 0.5)
    end
end)