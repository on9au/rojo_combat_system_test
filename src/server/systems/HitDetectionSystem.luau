local Players = game:GetService("Players")
local HitboxComponent = require(script.Parent.Parent.components.HitboxComponent)

-- # HitDetectionSystem

local HitDetectionSystem = {}

HitDetectionSystem.name = "HitDetectionSystem"
HitDetectionSystem.dependencies = {}
HitDetectionSystem.interval = 0 -- Update every Heartbeat

function HitDetectionSystem.system(_deltaTime)
    for _, player in ipairs(Players:GetPlayers()) do
        HitboxComponent.init(player)
        local isActive = player:GetAttribute("IsActive")
        if isActive then
            local character = player.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local hitboxSize = player:GetAttribute("HitboxSize")
                    local hitboxOffset = player:GetAttribute("HitboxOffset")
                    local damage = player:GetAttribute("Damage")

                    local hitboxCFrame = rootPart.CFrame * CFrame.new(hitboxOffset)
                    local region = Region3.new(
                        hitboxCFrame.Position - (hitboxSize / 2),
                        hitboxCFrame.Position + (hitboxSize / 2)
                    )

                    local parts = workspace:GetPartBoundsInBox(region, {character}, 100)
                    for _, part in ipairs(parts) do
                        local hitCharacter = part:FindFirstAncestorOfClass("Model")
                        if hitCharacter and hitCharacter ~= character then
                            local humanoid = hitCharacter:FindFirstChildOfClass("Humanoid")
                            if humanoid and humanoid.Health > 0 then
                                humanoid:TakeDamage(damage)
                                print("Dealt", damage, "damage to", hitCharacter.Name)
                                -- Disable the hitbox after hitting
                                player:SetAttribute("IsActive", false)
                            end
                        end
                    end
                end
            end
        end
    end
end

return HitDetectionSystem