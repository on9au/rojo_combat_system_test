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
local previousPrimaryState = {}
local previousSecondaryState = {}

function InputSystem.system(_deltaTime)
    for _, entity in ipairs(CollectionService:GetTagged("LocalPlayer")) do
        -- Initialize InputComponent
        InputComponent.init(entity)

        -- Detect left-click (primary attack)
        local isLeftClickDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        local prevPrimaryState = previousPrimaryState[entity] or false

        -- Update attributes for primary attack
        entity:SetAttribute("IsPrimaryButtonDown", isLeftClickDown)
        if isLeftClickDown and not prevPrimaryState then
            entity:SetAttribute("IsPrimaryButtonPressed", true)
        else
            entity:SetAttribute("IsPrimaryButtonPressed", false)
        end
        if not isLeftClickDown and prevPrimaryState then
            entity:SetAttribute("IsPrimaryButtonReleased", true)
        else
            entity:SetAttribute("IsPrimaryButtonReleased", false)
        end
        previousPrimaryState[entity] = isLeftClickDown

        -- Detect right-click (parry)
        local isRightClickDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        local prevSecondaryState = previousSecondaryState[entity] or false

        -- Update attributes for parry
        entity:SetAttribute("IsSecondaryButtonDown", isRightClickDown)
        if isRightClickDown and not prevSecondaryState then
            entity:SetAttribute("IsSecondaryButtonPressed", true)
        else
            entity:SetAttribute("IsSecondaryButtonPressed", false)
        end
        if not isRightClickDown and prevSecondaryState then
            entity:SetAttribute("IsSecondaryButtonReleased", true)
        else
            entity:SetAttribute("IsSecondaryButtonReleased", false)
        end
        previousSecondaryState[entity] = isRightClickDown
    end
end

return InputSystem