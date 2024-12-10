-- # StunComponent
--
-- Attributes:
-- - `Stunned`: `boolean`
-- - `StunEndTime`: `number`

local StunComponent = {}
StunComponent.__index = StunComponent

function StunComponent.init(player)
    if not player:GetAttribute("Stunned") then
        player:SetAttribute("Stunned", false)
    end
    if not player:GetAttribute("StunEndTime") then
        player:SetAttribute("StunEndTime", 0)
    end
end

return StunComponent