-- # HitboxComponent
--
-- Attributes:
-- - `HitboxSize`: `Vector3` - The size of the hitbox.
-- - `HitboxOffset`: `Vector3` - The offset of the hitbox from the entity's position.
-- - `Damage`: `number` - The damage to deal.
-- - `Penetration`: `number` - The penetration coefficient.
-- - `IsActive`: `boolean` - Whether the hitbox is active.
-- - `HitboxEndTime`: `number` - The time when the hitbox ends.

local HitboxComponent = {}
HitboxComponent.__index = HitboxComponent

function HitboxComponent.init(entity)
    if not entity:GetAttribute("HitboxSize") then
        entity:SetAttribute("HitboxSize", Vector3.new(0, 0, 0))
    end

    if not entity:GetAttribute("HitboxOffset") then
        entity:SetAttribute("HitboxOffset", Vector3.new(0, 0, 0))
    end

    if not entity:GetAttribute("Damage") then
        entity:SetAttribute("Damage", 0)
    end

    if not entity:GetAttribute("Penetration") then
        entity:SetAttribute("Penetration", 0)
    end

    if not entity:GetAttribute("IsActive") then
        entity:SetAttribute("IsActive", false)
    end

    if not entity:GetAttribute("HitboxEndTime") then
        entity:SetAttribute("HitboxEndTime", 0)
    end
end

return HitboxComponent