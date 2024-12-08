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

function InputSystem.system()
    -- Loop through all entities with the "Player" tag
    for _, entity in ipairs(CollectionService:GetTagged("LocalPlayer")) do
        -- Get or create the InputComponent (Attribute) for the entity
        InputComponent.init(entity)

        -- Detect left-click (or key press) for punching
        local isLeftClickDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

        -- Get IsPrimaryButtonDown attribute from the entity
        local wasLeftClickDown = entity:GetAttribute("IsPrimaryButtonDown")

        if isLeftClickDown and not wasLeftClickDown then
            -- The player has clicked the Primary Attack button
            -- Update the IsPrimaryButtonPressed attribute
            entity:SetAttribute("IsPrimaryButtonPressed", true)
        elseif not isLeftClickDown and wasLeftClickDown then
            -- The player has released the Primary Attack button
            -- Update the IsPrimaryButtonReleased attribute
            entity:SetAttribute("IsPrimaryButtonReleased", true)
        elseif not isLeftClickDown and not wasLeftClickDown then
            -- The player has not clicked the Primary Attack button
            -- Reset the IsPrimaryButtonPressed and IsPrimaryButtonReleased attributes
            entity:SetAttribute("IsPrimaryButtonPressed", false)
            entity:SetAttribute("IsPrimaryButtonReleased", false)
        end

        -- Update the IsPrimaryButtonDown attribute based on the left-click state
        entity:SetAttribute("IsPrimaryButtonDown", isLeftClickDown)
    end
end

return InputSystem