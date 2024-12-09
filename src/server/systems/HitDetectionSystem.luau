local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local HitboxComponent = require(script.Parent.Parent.components.HitboxComponent)
local HealthComponent = require(game:GetService("ReplicatedStorage").Shared.components.HealthComponent)

-- # HitDetectionSystem

local HitDetectionSystem = {}

HitDetectionSystem.name = "HitDetectionSystem"
HitDetectionSystem.dependencies = {}
HitDetectionSystem.interval = 0 -- Update every Heartbeat

function HitDetectionSystem.system(_deltaTime)
	for _, player in ipairs(Players:GetPlayers()) do
		HitboxComponent.init(player)
		local isActive = player:GetAttribute("IsActive")
		local currentTime = tick()

        -- Check if the hitbox is active and within the hitbox time
		if currentTime >= player:GetAttribute("HitboxEndTime") then
			player:SetAttribute("IsActive", false)
            continue -- Skip the rest of the loop
		end
		if isActive then
			local character = player.Character
			if character then
				local rootPart = character:FindFirstChild("HumanoidRootPart")
				if rootPart then
					local hitboxSize = player:GetAttribute("HitboxSize")
					local hitboxOffset = player:GetAttribute("HitboxOffset")
					local damage = player:GetAttribute("Damage")
                    local penetration = player:GetAttribute("Penetration")

					local hitboxCFrame = rootPart.CFrame * CFrame.new(hitboxOffset)
					-- local halfSize = hitboxSize / 2
					-- local origin = hitboxCFrame.Position
					-- local orientation = hitboxCFrame - hitboxCFrame.Position

					-- Debug hitbox
					-- local hitbox = Instance.new("Part")
					-- hitbox.Size = hitboxSize
					-- hitbox.Anchored = true
					-- hitbox.CanCollide = false
					-- hitbox.Transparency = 0.5
					-- hitbox.CFrame = hitboxCFrame
					-- hitbox.Parent = workspace

					-- Create an overlap params to ignore the player's character
					local overlapParams = OverlapParams.new()
					overlapParams.FilterType = Enum.RaycastFilterType.Exclude
					overlapParams.FilterDescendantsInstances = { character }

					-- Get parts in the hitbox using GetPartsInPart or GetPartBoundsInBox
					local parts = workspace:GetPartBoundsInBox(hitboxCFrame, hitboxSize, overlapParams)

					local hitEntities = {}
					for _, part in ipairs(parts) do
						local hitEntity = part:FindFirstAncestorWhichIsA("Model")
						if hitEntity and hitEntity ~= character and not hitEntities[hitEntity] then
							if CollectionService:HasTag(hitEntity, "Damageable") then
								-- Initialize HealthComponent if not already done
								HealthComponent.init(hitEntity)
								local health = hitEntity:GetAttribute("Health")
                                local defense = hitEntity:GetAttribute("Defense")
								if health > 0 then
                                    -- Calculate new damage and defense
                                    -- where penetration is the percentage of damage that ignores defense
                                    local newDefense = defense - (damage * (1 - penetration))

                                    print("Defense:", defense, "New Defense:", newDefense)

									local newHealth = math.max(0, health - (damage * penetration))

                                    print("Health:", health, "New Health:", newHealth)

                                    if newDefense < 0 then
                                        -- If defense is negative after penetration, deal the remaining damage to health
                                        newHealth = newHealth + newDefense -- using + since newDefense is negative
                                        newDefense = 0
                                        print("New Health after Defense:", newHealth)
                                    end

									hitEntity:SetAttribute("Health", newHealth)
                                    hitEntity:SetAttribute("Defense", newDefense)
									print("Dealt", damage, "damage to", hitEntity.Name, "H:", newHealth, "D:", newDefense)
									-- Optionally, handle entity destruction if health <= 0
									if newHealth <= 0 then
										print(hitEntity.Name .. " has been destroyed!")
										-- Add destruction logic here
									end
									-- Disable the hitbox after hitting
									player:SetAttribute("IsActive", false)
									hitEntities[hitEntity] = true
								end
							end
						end
					end
				end
			end
		end
	end
end

return HitDetectionSystem
