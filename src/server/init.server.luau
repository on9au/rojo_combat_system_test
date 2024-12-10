local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local neoECSScheduler = require(ReplicatedStorage.Shared:FindFirstChild("neoECS-Scheduler"))
local PrimaryActionItemComponent = require(script.components.PrimaryActionItemComponent)
local ComboComponent = require(script.components.ComboComponent)
local ParryValidationComponent = require(script.components.ParryValidationComponent)

-- RemoteEvents Setup

local Events = ReplicatedStorage.Shared.events

for _, eventModule in Events:GetChildren() do
    if eventModule:IsA("ModuleScript") then
        require(eventModule)
    end
end

-- Server Event Handlers Setup

local eventHandlersFolder = script:WaitForChild("eventHandlers")

for _, eventHandlerModule in eventHandlersFolder:GetChildren() do
    if eventHandlerModule:IsA("ModuleScript") then
        require(eventHandlerModule)
    end
end

-- Inital Player Setup

-- Initialize PrimaryActionComponent for existing players
for _, player in ipairs(Players:GetPlayers()) do
    PrimaryActionItemComponent.init(player)
    ComboComponent.init(player)
    ParryValidationComponent.init(player)
end

-- Initialize PrimaryActionComponent when new players join
Players.PlayerAdded:Connect(function(player)
    PrimaryActionItemComponent.init(player)
    ComboComponent.init(player)
    ParryValidationComponent.init(player)
end)

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