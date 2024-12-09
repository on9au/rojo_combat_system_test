local Players = game:GetService("Players")
local MovementComponent = require(script.Parent.Parent.components.MovementComponent)

-- # MovementSystem

local MovementSystem = {}

MovementSystem.name = "MovementSystem"
MovementSystem.dependencies = {}
MovementSystem.interval = 0 -- Update every Heartbeat

local DefaultWalkSpeed = 16

function MovementSystem.system(_deltaTime)
	for _, player in ipairs(Players:GetPlayers()) do
		MovementComponent.init(player)
		local character = player.Character or player.CharacterAdded:Wait()
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
                local currentTime = tick()
                local cooldownEndTime = player:GetAttribute("CooldownEndTime")
				local speedMultiplier = player:GetAttribute("SpeedMultiplier")

				-- Apply speed multiplier
				humanoid.WalkSpeed = DefaultWalkSpeed * speedMultiplier

				-- Reset movement attributes after cooldown
				if currentTime >= cooldownEndTime then
					player:SetAttribute("SpeedMultiplier", 1)
					player:SetAttribute("MoveForward", false)
				end
			end
		end
	end
end

return MovementSystem
