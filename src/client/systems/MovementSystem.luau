local MovementComponent = require(script.Parent.Parent.components.MovementComponent)
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- # MovementSystem
--
-- This system is responsible for applying movement changes to entities.
local MovementSystem = {}

MovementSystem.name = "MovementSystem"

MovementSystem.dependencies = {}

MovementSystem.interval = 0 -- Update every Heartbeat

local normalWalkSpeed = Humanoid.WalkSpeed

function MovementSystem.system(deltaTime)
    local currentTime = tick()
    for _, entity in ipairs(CollectionService:GetTagged("LocalPlayer")) do
        MovementComponent.init(entity)
        local speedMultiplier = entity:GetAttribute("SpeedMultiplier")
        local moveForward = entity:GetAttribute("MoveForward")
        local cooldownEndTime = entity:GetAttribute("CooldownEndTime")

        -- Apply speed multiplier
        Humanoid.WalkSpeed = normalWalkSpeed * speedMultiplier

        -- Move the character forward
        if moveForward then
            local rootPart = Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -1 * deltaTime) -- Move forward slightly
            end
        end

        -- Reset movement attributes after cooldown
        if currentTime >= cooldownEndTime then
            entity:SetAttribute("SpeedMultiplier", 1)
            entity:SetAttribute("MoveForward", false)
        end
    end
end

return MovementSystem