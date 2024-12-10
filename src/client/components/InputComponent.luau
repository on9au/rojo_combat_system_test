-- # InputComponent
-- 
-- Attributes:
-- - `IsPrimaryButtonDown`: `boolean`
-- - `IsPrimaryButtonPressed`: `boolean`
-- - `IsPrimaryButtonReleased`: `boolean`
-- - `IsSecondaryButtonDown`: `boolean`
-- - `IsSecondaryButtonPressed`: `boolean`
-- - `IsSecondaryButtonReleased`: `boolean`

local InputComponent = {}
InputComponent.__index = InputComponent

-- Initialize the InputComponent for an entity
function InputComponent.init(entity)
    if not entity:GetAttribute("IsPrimaryButtonDown") then
        entity:SetAttribute("IsPrimaryButtonDown", false)
    end

    if not entity:GetAttribute("IsPrimaryButtonPressed") then
        entity:SetAttribute("IsPrimaryButtonPressed", false)
    end

    if not entity:GetAttribute("IsPrimaryButtonReleased") then
        entity:SetAttribute("IsPrimaryButtonReleased", false)
    end

    if not entity:GetAttribute("IsSecondaryButtonDown") then
        entity:SetAttribute("IsSecondaryButtonDown", false)
    end
    if not entity:GetAttribute("IsSecondaryButtonPressed") then
        entity:SetAttribute("IsSecondaryButtonPressed", false)
    end
    if not entity:GetAttribute("IsSecondaryButtonReleased") then
        entity:SetAttribute("IsSecondaryButtonReleased", false)
    end
end

return InputComponent