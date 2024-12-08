-- # InputComponent
-- 
-- Attributes:
-- - `IsPunching`: `boolean` - Indicates whether the player is currently punching.
local InputComponent = {}
InputComponent.__index = InputComponent

-- Initialize the InputComponent for an entity
function InputComponent.init(entity)
    if not entity:GetAttribute("IsPunching") then
        entity:SetAttribute("IsPunching", false)
    end
end

return InputComponent