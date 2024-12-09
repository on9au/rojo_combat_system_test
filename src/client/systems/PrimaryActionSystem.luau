local InputSystem = require(script.Parent.InputSystem)
local ComboComponent = require(script.Parent.Parent.components.ComboComponent)
local AnimationComponent = require(script.Parent.Parent.components.AnimationComponent)
local CooldownComponent = require(script.Parent.Parent.components.CooldownComponent)
local PrimaryActionComponent = require(script.Parent.Parent.components.PrimaryActionComponent)
local PrimaryActionItems = require(game:GetService("ReplicatedStorage").Shared.primaryItems.PrimaryItems)
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AttackEvent = ReplicatedStorage:WaitForChild("AttackEvent")
-- # PrimaryActionSystem
--
-- Manages the primary action of the player in this combat system.
local PrimaryActionSystem = {}

PrimaryActionSystem.name = "PrimaryActionSystem"

PrimaryActionSystem.dependencies = {
	InputSystem.system,
}

PrimaryActionSystem.interval = 0 -- Update every Heartbeat

function PrimaryActionSystem.system(_deltaTime)
	local currentTime = tick()
	for _, entity in ipairs(CollectionService:GetTagged("LocalPlayer")) do
		-- Initialize components
		ComboComponent.init(entity)
		AnimationComponent.init(entity)
		CooldownComponent.init(entity)
		PrimaryActionComponent.init(entity)

		-- Get the primary action item
		local primaryActionItemName = entity:GetAttribute("PrimaryActionItem") or "Punch"
		local primaryActionItem = PrimaryActionItems[primaryActionItemName]

		-- Check for punching state using an attribute
		local isPrimaryButtonPressed = entity:GetAttribute("IsPrimaryButtonPressed")
		local comboCount = entity:GetAttribute("ComboCount")
		local lastComboTime = entity:GetAttribute("LastComboTime")
		local cooldownTime = entity:GetAttribute("CooldownTime")
		local lastActionTime = entity:GetAttribute("LastActionTime")
		local maxComboCount = primaryActionItem.maxComboCount
		local comboWindow = primaryActionItem.comboWindow

		if isPrimaryButtonPressed then
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
				local action = primaryActionItemName
				local animationName = action .. comboCount
				entity:SetAttribute("CurrentAnimation", animationName)

				-- Update cooldown attributes
				local cooldownDuration
				if comboCount == maxComboCount then
					cooldownDuration = primaryActionItem.thirdCooldownTime
				else
					cooldownDuration = primaryActionItem.cooldownTime
				end
				entity:SetAttribute("CooldownTime", cooldownDuration)
				entity:SetAttribute("LastActionTime", currentTime)
				entity:SetAttribute("CooldownEndTime", currentTime + cooldownDuration)

				-- -- Handle movement adjustments
				-- entity:SetAttribute("SpeedMultiplier", 0.5) -- Slow down the player
				-- entity:SetAttribute("MoveForward", true) -- Move the player forward

				-- Handle action logic here
				print(entity.Name .. " is performing " .. action .. " with combo " .. comboCount .. "!")
				print("Combo: " .. comboCount .. "/" .. maxComboCount)
				if comboCount == maxComboCount then
					print("Damage: " .. primaryActionItem.maxComboDamage .. " (Third combo damage)")
				else
					print("Damage: " .. primaryActionItem.damage)
				end

				-- Send attack data to the server
				AttackEvent:FireServer(primaryActionItemName, comboCount)
			end
		end
	end
end

return PrimaryActionSystem
