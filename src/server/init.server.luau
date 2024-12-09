local ReplicatedStorage = game:GetService("ReplicatedStorage")
local neoECSScheduler = require(ReplicatedStorage.Shared:FindFirstChild("neoECS-Scheduler"))

-- Events Setup

local Events = ReplicatedStorage.Shared.events

for _, eventModule in Events:GetChildren() do
    if eventModule:IsA("ModuleScript") then
        require(eventModule)
    end
end

-- Scheduler Setup

local scheduler = neoECSScheduler.new()

-- Register server systems
local systemsFolder = script:WaitForChild("systems")

for _, systemModule in systemsFolder:GetChildren() do
    if systemModule:IsA("ModuleScript") then
        local system = require(systemModule)
        scheduler:RegisterSystem(system.name, system.system, system.interval, system.dependencies)
    end
end

game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
    scheduler:Update(deltaTime)
end)