-- # CooldownComponent
-- 
-- Attributes:
-- - `CooldownTime`: `number` - The cooldown time for the primary action.
-- - `LastActionTime`: `number` - The time when the last action was performed.
local CooldownComponent = {}
CooldownComponent.__index = CooldownComponent

-- Initialize the CooldownComponent for an entity
function CooldownComponent.init(entity)
    if not entity:GetAttribute("CooldownTime") then
        entity:SetAttribute("CooldownTime", 0.25)  -- Default cooldown time of 1 second
    end

    if not entity:GetAttribute("LastActionTime") then
        entity:SetAttribute("LastActionTime", 0)
    end
end

return CooldownComponent