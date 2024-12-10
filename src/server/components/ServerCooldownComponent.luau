-- # ServerCooldownComponent
--
-- Attributes:
-- 
-- - `ServerCooldownEndTime`: `number` - Time when the cooldown ends.

local ServerCooldownComponent = {}
ServerCooldownComponent.__index = ServerCooldownComponent

function ServerCooldownComponent.init(entity)
    if not entity:GetAttribute("ServerCooldownEndTime") then
        entity:SetAttribute("ServerCooldownEndTime", 0)
    end
end

return ServerCooldownComponent