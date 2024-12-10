-- # ParryComponent
--
-- Attributes:
-- - `IsParrying`: `boolean` - Is the player currently in a parry state?
-- - `ParryEndTime`: `number` - Time when the parry state ends.
-- - `ParryCooldownEndTime`: `number` - Time when the parry cooldown ends.

local ParryComponent = {}
ParryComponent.__index = ParryComponent

function ParryComponent.init(entity)
    if not entity:GetAttribute("IsParrying") then
        entity:SetAttribute("IsParrying", false)
    end
    if not entity:GetAttribute("ParryEndTime") then
        entity:SetAttribute("ParryEndTime", 0)
    end
    if not entity:GetAttribute("ParryCooldownEndTime") then
        entity:SetAttribute("ParryCooldownEndTime", 0)
    end
end

return ParryComponent