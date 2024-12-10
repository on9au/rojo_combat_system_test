local Players = game:GetService("Players")
local MovementComponent = require(script.Parent.Parent.components.MovementComponent)

-- # MovementSystem

local MovementSystem = {}

MovementSystem.name = "MovementSystem"
MovementSystem.dependencies = {}
MovementSystem.interval = 0 -- Update every Heartbeat

local DefaultWalkSpeed = 16
local DefaultJumpPower = 50

function MovementSystem.system(_deltaTime)
	for _, player in ipairs(Players:GetPlayers()) do
		MovementComponent.init(player)
		local character = player.Character or player.CharacterAdded:Wait()
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
                local currentTime = tick()
                if player:GetAttribute("Stunned") then
                    local stunEndTime = player:GetAttribute("StunEndTime") or 0
                    if currentTime >= stunEndTime then
                        -- End stun
                        player:SetAttribute("Stunned", false)
                        player:SetAttribute("SpeedMultiplier", 1)
						player:SetAttribute("JumpPowerMultiplier", 1)
                    else
                        -- Apply stun effects
                        humanoid.WalkSpeed = 0
						humanoid.JumpPower = 0
                    end
                else
                    -- Normal movement handling
                    local speedMultiplier = player:GetAttribute("SpeedMultiplier") or 1
					local jumpPowerMultiplier = player:GetAttribute("JumpPowerMultiplier") or 1
                    humanoid.WalkSpeed = DefaultWalkSpeed * speedMultiplier
					humanoid.JumpPower = DefaultJumpPower * jumpPowerMultiplier

                    -- Reset movement after cooldown
                    local cooldownEndTime = player:GetAttribute("CooldownEndTime") or 0
                    if currentTime >= cooldownEndTime then
                        player:SetAttribute("SpeedMultiplier", 1)
						player:SetAttribute("JumpPowerMultiplier", 1)
                    end
                end
			end
		end
	end
end

return MovementSystem
