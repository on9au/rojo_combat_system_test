-- # AnimationComponent
-- 
-- Attributes:
-- - `CurrentAnimation`: `string` - The name of the current animation.
local AnimationComponent = {}
AnimationComponent.__index = AnimationComponent

-- Initialize the AnimationComponent for an entity
function AnimationComponent.init(entity)
    if not entity:GetAttribute("CurrentAnimation") then
        entity:SetAttribute("CurrentAnimation", "")
    end
end

return AnimationComponent