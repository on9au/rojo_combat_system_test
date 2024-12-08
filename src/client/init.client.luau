local ReplicatedStorage = game:GetService("ReplicatedStorage")
local neoECSScheduler = require(ReplicatedStorage.Shared:FindFirstChild("neoECS-Scheduler"))

-- Setup the neoECS-Scheduler

local scheduler = neoECSScheduler.new()

-- Register the systems with the scheduler
-- Systems are found in script.Parent.systems
-- Each system has a `system` function, `interval` number, and `dependencies` table
for _, systemModule in script.systems:GetChildren() do
    print("Registering system: " .. systemModule.Name)
    if systemModule:IsA("ModuleScript") then
        local system = require(systemModule)
        scheduler:RegisterSystem(system.name, system.system, system.interval, system.dependencies)
    else 
        warn("System module is not a ModuleScript: " .. systemModule)
    end
end

-- Update the scheduler every frame
game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
    scheduler:Update(deltaTime)
end)