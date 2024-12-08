-- # InputComponent
-- 
-- Attributes:
-- - `IsPrimaryButtonDown`: `boolean` - Indicates whether the player is currently holding down their Primary Attack button.
local InputComponent = {}
InputComponent.__index = InputComponent

-- Initialize the InputComponent for an entity
function InputComponent.init(entity)
    -- IsPrimaryButtonDown: Indicates whether the player is currently punching
    if not entity:GetAttribute("IsPrimaryButtonDown") then
        entity:SetAttribute("IsPrimaryButtonDown", false)
    end

    -- IsPrimaryButtonPressed: Indicates whether the player has clicked the Primary Attack button once.
    -- Behaviour: The instant the player clicks the Primary Attack button, this attribute is set to `true`.
    -- After the next frame, it is set back to `false`.
    if not entity:GetAttribute("IsPrimaryButtonPressed") then
        entity:SetAttribute("IsPrimaryButtonPressed", false)
    end

    -- IsPrimaryButtonReleased: Indicates whether the player has released the Primary Attack button.
    -- Behaviour: The instant the player releases the Primary Attack button, this attribute is set to `true`.
    -- After the next frame, it is set back to `false`.
    if not entity:GetAttribute("IsPrimaryButtonReleased") then
        entity:SetAttribute("IsPrimaryButtonReleased", false)
    end
end

return InputComponent