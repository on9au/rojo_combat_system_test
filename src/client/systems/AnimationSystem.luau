local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animations = require(ReplicatedStorage.Shared.animations.Animations)
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- # AnimationSystem
--
-- This system is responsible for playing animations on entities.
local AnimationSystem = {}

AnimationSystem.name = "AnimationSystem"

AnimationSystem.dependencies = {}

AnimationSystem.interval = 0 -- Update every Heartbeat

function AnimationSystem.system(_deltaTime)
    for _, entity in ipairs(CollectionService:GetTagged("LocalPlayer")) do
        local animator = Humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = Humanoid
        end

        -- Get the current animation
        local currentAnimation = entity:GetAttribute("CurrentAnimation")
        local animations = Animations
        if currentAnimation and currentAnimation ~= "" and animations[currentAnimation] then
            -- Load and play the animation
            local animation = Instance.new("Animation")
            animation.AnimationId = animations[currentAnimation]
            local animationTrack = animator:LoadAnimation(animation)
            animationTrack:Play()

            -- Clear the current animation attribute
            entity:SetAttribute("CurrentAnimation", "")
        end
    end
end

return AnimationSystem