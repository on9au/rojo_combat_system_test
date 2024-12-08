local InputComponent = require(script.Parent.Parent.components.InputComponent)
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")

-- # InputSystem
-- 
-- This system is responsible for handling all input events and updating the game state accordingly.
local InputSystem = {}

InputSystem.name = "InputSystem"

InputSystem.dependencies = {}

InputSystem.interval = 0 -- Update every Heartbeat

-- Store the previous state of the button for each entity
local previousState = {}

function InputSystem.system()
    -- Loop through all entities with the "Player" tag
    for _, entity in ipairs(CollectionService:GetTagged("LocalPlayer")) do
        -- Get or create the InputComponent (Attribute) for the entity
        InputComponent.init(entity)

        -- Detect left-click (or key press) for punching
        local isLeftClickDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

        -- Get the previous state of the button
        local prevState = previousState[entity] or false

        -- Update the IsPrimaryButtonDown attribute based on the left-click state
        entity:SetAttribute("IsPrimaryButtonDown", isLeftClickDown)

        -- Update the IsPrimaryButtonPressed attribute
        if isLeftClickDown and not prevState then
            entity:SetAttribute("IsPrimaryButtonPressed", true)
        else
            entity:SetAttribute("IsPrimaryButtonPressed", false)
        end

        -- Update the IsPrimaryButtonReleased attribute
        if not isLeftClickDown and prevState then
            entity:SetAttribute("IsPrimaryButtonReleased", true)
        else
            entity:SetAttribute("IsPrimaryButtonReleased", false)
        end

        -- Store the current state as the previous state for the next frame
        previousState[entity] = isLeftClickDown
    end
end

return InputSystem