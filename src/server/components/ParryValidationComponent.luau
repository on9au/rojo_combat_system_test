-- # ParryValidationComponent
--
-- Attributes:
-- - `ServerIsParrying`: `boolean` - Is the player currently in a parry state?
-- - `ServerParryEndTime`: `number` - Time when the parry state ends.
-- - `ServerParryCooldownEndTime`: `number` - Time when the parry cooldown ends.

local ParryValidationComponent = {}
ParryValidationComponent.__index = ParryValidationComponent

function ParryValidationComponent.init(entity)
    if not entity:GetAttribute("ServerIsParrying") then
        entity:SetAttribute("ServerIsParrying", false)
    end
    if not entity:GetAttribute("ServerParryEndTime") then
        entity:SetAttribute("ServerParryEndTime", 0)
    end
    if not entity:GetAttribute("ServerParryCooldownEndTime") then
        entity:SetAttribute("ServerParryCooldownEndTime", 0)
    end
end

return ParryValidationComponent