local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animations = require(ReplicatedStorage.Shared.animations.Animations)
-- local CollectionService = game:GetService("CollectionService")

local entity = game.Players.LocalPlayer
local Character = entity.Character or entity.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- # AnimationSystem
--
-- This system is responsible for playing animations on entities.
local AnimationSystem = {}

AnimationSystem.name = "AnimationSystem"

AnimationSystem.dependencies = {}

AnimationSystem.interval = 0 -- Update every Heartbeat

function AnimationSystem.system(_deltaTime)
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

return AnimationSystem
