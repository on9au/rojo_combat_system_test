local ParryComponent = require(script.Parent.Parent.components.ParryComponent)
local InputSystem = require(script.Parent.InputSystem)
local CooldownComponent = require(script.Parent.Parent.components.CooldownComponent)
-- local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ParryEvent = ReplicatedStorage:WaitForChild("ParryEvent")

local entity = game.Players.LocalPlayer

-- # ParrySystem

local ParrySystem = {}

ParrySystem.name = "ParrySystem"
ParrySystem.dependencies = {
	InputSystem.system,
}
ParrySystem.interval = 0 -- Update every Heartbeat

function ParrySystem.system(_deltaTime)
	local currentTime = tick()
	ParryComponent.init(entity)
	CooldownComponent.init(entity)

	-- Get the primary action item
	local primaryActionItemName = entity:GetAttribute("PrimaryActionItem") or "Punch"

	local isParrying = entity:GetAttribute("IsParrying")
	local isSecondaryButtonPressed = entity:GetAttribute("IsSecondaryButtonPressed")

	local lastActionTime = entity:GetAttribute("LastActionTime")

	-- Parry parameters
	local parryDuration = 0.2 -- Duration of the parry window
	local parryCooldown = 0.22 -- Cooldown after parry

	if isSecondaryButtonPressed and currentTime - lastActionTime >= parryCooldown then
		-- Start parry
		entity:SetAttribute("IsParrying", true)
		entity:SetAttribute("ParryEndTime", currentTime + parryDuration)
		entity:SetAttribute("LastActionTime", currentTime)

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

return ParrySystem
