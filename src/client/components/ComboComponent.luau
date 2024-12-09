-- # ComboComponent
-- 
-- Attributes:
-- - `ComboCount`: `number` - The current combo count.
-- - `LastComboTime`: `number` - The time when the last combo action was performed.
local ComboComponent = {}
ComboComponent.__index = ComboComponent

-- Initialize the ComboComponent for an entity
function ComboComponent.init(entity)
    if not entity:GetAttribute("ComboCount") then
        entity:SetAttribute("ComboCount", 0)
    end

    if not entity:GetAttribute("LastComboTime") then
        entity:SetAttribute("LastComboTime", 0)
    end

    -- if not entity:GetAttribute("ComboWindow") then
    --     entity:SetAttribute("ComboWindow", 0.5)  -- Default combo window of 0.5 second
    -- end

    -- if not entity:GetAttribute("MaxComboCount") then
    --     entity:SetAttribute("MaxComboCount", 3)  -- Default maximum combo count of 3
    -- end
end

return ComboComponent