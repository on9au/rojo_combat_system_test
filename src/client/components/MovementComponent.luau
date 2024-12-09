-- # MovementComponent
-- 
-- Attributes:
-- - `SpeedMultiplier`: `number` - The multiplier for the player's speed.
-- - `MoveForward`: `boolean` - Indicates whether the player should move forward during the attack.
-- - `CooldownEndTime`: `number` - The time when the cooldown ends.
local MovementComponent = {}
MovementComponent.__index = MovementComponent

-- Initialize the MovementComponent for an entity
function MovementComponent.init(entity)
    if not entity:GetAttribute("SpeedMultiplier") then
        entity:SetAttribute("SpeedMultiplier", 1)  -- Default speed multiplier
    end

    if not entity:GetAttribute("MoveForward") then
        entity:SetAttribute("MoveForward", false)  -- Default to not moving forward
    end

    if not entity:GetAttribute("CooldownEndTime") then
        entity:SetAttribute("CooldownEndTime", 0)  -- Default to 0, meaning no cooldown
    end
end

return MovementComponent