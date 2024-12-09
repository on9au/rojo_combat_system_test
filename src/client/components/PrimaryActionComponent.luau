-- # PrimaryActionComponent
-- 
-- Attributes:
-- - `PrimaryActionItem`: `string` - The name of the primary action item.
local PrimaryActionComponent = {}
PrimaryActionComponent.__index = PrimaryActionComponent

-- Initialize the PrimaryActionComponent for an entity
function PrimaryActionComponent.init(entity)
    if not entity:GetAttribute("PrimaryActionItem") then
        entity:SetAttribute("PrimaryActionItem", nil)  -- Default to nil, meaning no item held
    end
end

return PrimaryActionComponent