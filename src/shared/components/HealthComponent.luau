-- # HealthComponent
--
-- Attributes:
-- - `Health`: `number` - The current health of the entity.
-- - `MaxHealth`: `number` - The maximum health of the entity.
-- - `Shield`: `number` - The shield of the entity.
local HealthComponent = {}
HealthComponent.__index = HealthComponent

function HealthComponent.init(entity)
    if not entity:GetAttribute("Health") then
        entity:SetAttribute("Health", 100)  -- Default health
    end

    if not entity:GetAttribute("MaxHealth") then
        entity:SetAttribute("MaxHealth", 100)  -- Default max health
    end

    if not entity:GetAttribute("Shield") then
        entity:SetAttribute("Shield", 0)  -- Default defense
    end
end

return HealthComponent