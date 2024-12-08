local InputComponent = require(script.Parent.Parent.components.InputComponent)
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")

-- # InputSystem
-- 
-- This system is responsible for handling all input events and updating the game state accordingly.
local InputSystem = {}

InputSystem.dependencies = {}

InputSystem.interval = 0 -- Update every Heartbeat

function InputSystem.system()
    -- Loop through all entities with the "Player" tag
    for _, entity in ipairs(CollectionService:GetTagged("Player")) do
        -- Get or create the InputComponent (Attribute) for the entity
        InputComponent.init(entity)

        -- Detect left-click (or key press) for punching
        local isLeftClick = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

        -- Update the IsPunching attribute based on the left-click state
        entity:SetAttribute("IsPunching", isLeftClick)
    end
end

return InputSystem