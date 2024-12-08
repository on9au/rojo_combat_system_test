local InputSystem = require(script.Parent.InputSystem)
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")

-- # PrimaryActionSystem
--
-- Manages the primary action of the player in this combat system.
local PrimaryActionSystem = {}

PrimaryActionSystem.dependencies = {
    InputSystem.system
}

PrimaryActionSystem.interval = 0 -- Update every Heartbeat

local function IsPunchButtonClicked(input, gameProcessedEvent)
    if gameProcessedEvent then return end -- Ignore input if it was processed by another system
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        PrimaryActionSystem.system()
    end
end

-- local PUNCH_COOLDOWN = 1 -- Cooldown time in seconds

function PrimaryActionSystem.system()
    for _, entity in ipairs(CollectionService:GetTagged("Player")) do
        -- Check for punching state using an attribute
        local isPunching = entity:GetAttribute("IsPunching")
        
        if isPunching then
            -- Handle punching logic here
            print(entity.name .. " is punching!")
        end
    end
end

UserInputService.InputBegan:Connect(IsPunchButtonClicked)

return PrimaryActionSystem