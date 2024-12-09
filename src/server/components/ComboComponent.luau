-- # ComboComponent
--
-- Used for server sided validation of combo actions.
--
-- Attributes:
-- - `ServerComboCount`: `number` - The current combo count.
-- - `ServerLastComboTime`: `number` - The time when the last combo action was performed.

local ComboComponent = {}
ComboComponent.__index = ComboComponent

function ComboComponent.init(player)
    if not player:GetAttribute("ServerComboCount") then
        player:SetAttribute("ServerComboCount", 0)
    end
    if not player:GetAttribute("ServerLastComboTime") then
        player:SetAttribute("ServerLastComboTime", 0)
    end
end

return ComboComponent