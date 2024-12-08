local ReplicatedStorage = game:GetService("ReplicatedStorage")
local neoECSScheduler = ReplicatedStorage.Shared:FindFirstChild("neoECS-Scheduler")

-- Setup the neoECS-Scheduler

local scheduler = neoECSScheduler.new()

-- Register the systems with the scheduler
-- Systems are found in script.Parent.systems
-- Each system has a `system` function, `interval` number, and `dependencies` table
for _, system in ipairs(script.Parent.systems:GetChildren()) do
    scheduler:RegisterSystem(system.system, system.interval, system.dependencies)
end

-- Update the scheduler every frame
game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
    scheduler:Update(deltaTime)
end)