local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AttackEvent = ReplicatedStorage:WaitForChild("AttackEvent")
local PrimaryItems = require(ReplicatedStorage.Shared.primaryItems.PrimaryItems)

AttackEvent.OnServerEvent:Connect(function(player, actionName, comboCount)
    print("Event received!", player, actionName, comboCount)
    if actionName ~= player:GetAttribute("PrimaryActionItem") or "punch" then
        warn("Client sent an invalid item name! Is client and server in sync?")
        return
    end
    local primaryActionItem = PrimaryItems[actionName]
    if primaryActionItem then
        -- Set hitbox attributes
        player:SetAttribute("HitboxSize", primaryActionItem.hitboxSize)
        player:SetAttribute("HitboxOffset", primaryActionItem.hitboxOffset)
        if comboCount == primaryActionItem.maxComboCount then
            player:SetAttribute("Damage", primaryActionItem.maxComboDamage)
            player:SetAttribute("Penetration", primaryActionItem.maxComboPenetration)
            player:SetAttribute("CooldownEndTime", tick() + primaryActionItem.maxComboCooldownTime)
            player:SetAttribute("HitboxEndTime", tick() + primaryActionItem.maxComboHitboxDuration)
        else
            player:SetAttribute("Damage", primaryActionItem.damage)
            player:SetAttribute("Penetration", primaryActionItem.penetration)
            player:SetAttribute("CooldownEndTime", tick() + primaryActionItem.cooldownTime)
            player:SetAttribute("HitboxEndTime", tick() + primaryActionItem.hitboxDuration)
        end
        player:SetAttribute("IsActive", true)


        -- Set movement adjustments
        player:SetAttribute("SpeedMultiplier", 0.5)
    end
end)

return nil