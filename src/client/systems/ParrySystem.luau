local ParryComponent = require(script.Parent.Parent.components.ParryComponent)
local InputSystem = require(script.Parent.InputSystem)
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ParryEvent = ReplicatedStorage:WaitForChild("ParryEvent")

-- # ParrySystem

local ParrySystem = {}

ParrySystem.name = "ParrySystem"
ParrySystem.dependencies = {
	InputSystem.system,
}
ParrySystem.interval = 0 -- Update every Heartbeat

function ParrySystem.system(_deltaTime)
	local currentTime = tick()
	for _, entity in ipairs(CollectionService:GetTagged("LocalPlayer")) do
		ParryComponent.init(entity)

        -- Get the primary action item
		local primaryActionItemName = entity:GetAttribute("PrimaryActionItem") or "Punch"

		local isParrying = entity:GetAttribute("IsParrying")
		local parryCooldownEndTime = entity:GetAttribute("ParryCooldownEndTime")
		local isSecondaryButtonPressed = entity:GetAttribute("IsSecondaryButtonPressed")

		-- Parry parameters
		local parryDuration = 0.5 -- Duration of the parry window
		local parryCooldown = 1.5 -- Cooldown after parry

		if isSecondaryButtonPressed and currentTime >= parryCooldownEndTime then
			-- Start parry
			entity:SetAttribute("IsParrying", true)
			entity:SetAttribute("ParryEndTime", currentTime + parryDuration)
			entity:SetAttribute("ParryCooldownEndTime", currentTime + parryCooldown)

            print("Parrying!")

			-- Determine the action and set the animation
			local action = primaryActionItemName
			local animationName = action .. "Parry" .. math.random(1, 3)
			entity:SetAttribute("CurrentAnimation", animationName)

			-- Send parry event to server
			ParryEvent:FireServer()
		end

		if isParrying and currentTime >= entity:GetAttribute("ParryEndTime") then
			-- End parry
			entity:SetAttribute("IsParrying", false)
		end
	end
end

return ParrySystem
