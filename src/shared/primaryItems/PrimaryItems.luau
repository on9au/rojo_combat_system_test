-- An example item:
--[[
    local Punch = {
        -- The name of the item
        name = "Punch",

        -- The time it takes for the cooldown to end
        cooldownTime = 0.27,

        -- The time it takes for the max combo cooldown to end
        maxComboCooldownTime = 0.5,

        -- The maximum number of combos
        maxComboCount = 3,

        -- The time window for a combo
        comboWindow = 0.5,

        -- The damage dealt by the item
        damage = 10,

        -- The penetration coefficient dealt by the item
        -- Basically, how much damage is dealt to the enemy's health and shield
        -- Example: 0.5 means 50% of the damage is dealt to the enemy's health and 50% to the shield
        -- Assuming enemy's health is 100 and shield is 100
        -- The enemy's health is reduced by 5 and the shield is reduced by 5
        -- If enemy's health is 100 and shield is 4
        -- The enemy's health is reduced by 6 and the shield is reduced by 4 (the remaining 1 damage is dealt to the health)
        penetration = 0,

        -- The penetration coefficient dealt by the max combo
        maxComboPenetration = 0,

        -- The damage dealt by the max combo
        maxComboDamage = 20,

        -- The size of the hitbox
        hitboxSize = Vector3.new(4, 5, 3),

        -- The offset of the hitbox from the entity's position
        hitboxOffset = Vector3.new(0, 0, -2),

        -- The duration of the hitbox
        hitboxDuration = 0.27,

        -- The duration of the max combo hitbox
        maxComboHitboxDuration = 0.4,
    }

    return Punch
]]

local PrimaryItems = {}

local ItemsFolder = script.Parent.items

-- For each module in the items folder, require it and add it to the PrimaryItems table
for _, itemModule in ipairs(ItemsFolder:GetChildren()) do
	if itemModule:IsA("ModuleScript") then
		local item = require(itemModule)
		PrimaryItems[item.name] = item
	end
end

return PrimaryItems
