local Players = game:GetService("Players")
local MovementComponent = require(script.Parent.Parent.components.MovementComponent)

-- # MovementSystem

local MovementSystem = {}

MovementSystem.name = "MovementSystem"
MovementSystem.dependencies = {}
MovementSystem.interval = 0 -- Update every Heartbeat

function MovementSystem.system()
    for _, player in ipairs(Players:GetPlayers()) do
        MovementComponent.init(player)
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local speedMultiplier = player:GetAttribute("SpeedMultiplier")
                humanoid.WalkSpeed = 16 * speedMultiplier
                -- Reset SpeedMultiplier after applying
                player:SetAttribute("SpeedMultiplier", 1)
            end
        end
    end
end

return MovementSystem