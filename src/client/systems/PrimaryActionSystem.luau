local InputSystem = require(script.Parent.InputSystem)
local ComboComponent = require(script.Parent.Parent.components.ComboComponent)
local AnimationComponent = require(script.Parent.Parent.components.AnimationComponent)
local CooldownComponent = require(script.Parent.Parent.components.CooldownComponent)
local CollectionService = game:GetService("CollectionService")

-- # PrimaryActionSystem
--
-- Manages the primary action of the player in this combat system.
local PrimaryActionSystem = {}

PrimaryActionSystem.name = "PrimaryActionSystem"

PrimaryActionSystem.dependencies = {
    InputSystem.system
}

PrimaryActionSystem.interval = 0 -- Update every Heartbeat

function PrimaryActionSystem.system()
    local currentTime = tick()
    for _, entity in ipairs(CollectionService:GetTagged("LocalPlayer")) do
        -- Initialize components
        ComboComponent.init(entity)
        AnimationComponent.init(entity)
        CooldownComponent.init(entity)

        -- Check for punching state using an attribute
        local isPunching = entity:GetAttribute("IsPrimaryButtonPressed")
        -- local isKicking = entity:GetAttribute("IsPrimaryButtonPressed") -- Replace with actual kick detection logic
        local comboCount = entity:GetAttribute("ComboCount")
        local lastComboTime = entity:GetAttribute("LastComboTime")
        local cooldownTime = entity:GetAttribute("CooldownTime")
        local lastActionTime = entity:GetAttribute("LastActionTime")
        local maxComboCount = entity:GetAttribute("MaxComboCount")
        local comboWindow = entity:GetAttribute("ComboWindow")

        if isPunching then
            -- Check cooldown
            if currentTime - lastActionTime >= cooldownTime then
                -- Handle combo logic
                if currentTime - lastComboTime <= comboWindow then
                    comboCount = comboCount + 1
                else
                    comboCount = 1
                end

                -- Cap the combo count at the maximum combo count
                if comboCount > maxComboCount then
                    comboCount = 1
                end

                -- Update combo attributes
                entity:SetAttribute("ComboCount", comboCount)
                entity:SetAttribute("LastComboTime", currentTime)

                -- Determine the action and set the animation
                local action = isPunching and "Punch"
                local animationName = action .. comboCount
                entity:SetAttribute("CurrentAnimation", animationName)

                -- Update cooldown attributes
                if comboCount == maxComboCount then
                    entity:SetAttribute("CooldownTime", 0.5)  -- Third combo has a cooldown of 0.5 seconds
                else
                    entity:SetAttribute("CooldownTime", 0.25)  -- Other combos have a cooldown of 0.25 seconds
                end
                entity:SetAttribute("LastActionTime", currentTime)

                -- Handle action logic here
                print(entity.Name .. " is performing " .. action .. " with combo " .. comboCount .. "!")
            end
        end
    end
end

return PrimaryActionSystem