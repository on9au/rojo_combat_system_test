--!native

-- # neoECS-Scheduler
-- Part of the neoECS (Entity Component System) series.
-- The neoECSScheduler is a module that allows you to schedule events to run at specific times.
-- It is designed to work with the neoECS framework, but can be used on its own.
local neoECSScheduler = {}
neoECSScheduler.__index = neoECSScheduler

-- Define the types for the system and dependencies
type System = () -> ()  -- System is a function that takes no arguments and returns nothing
type SystemData = {name: string, system: System, interval: number, lastRun: number}

-- Create a new neoECSScheduler
function neoECSScheduler.new()
    local self = setmetatable({}, neoECSScheduler)
    self.systems = {}   -- Table to hold all systems (Array of SystemData)
    self.dependencies = {}  -- Store system dependencies (system -> list of dependencies)
    self.executed = {}  -- Track which systems have been executed
    return self
end

-- Helper function to detect cycles using DFS
local function hasCycle(system, dependencies, visited, stack)
    visited[system] = true
    stack[system] = true

    for _, dependency in ipairs(dependencies[system] or {}) do
        if not visited[dependency] and hasCycle(dependency, dependencies, visited, stack) then
            return true
        elseif stack[dependency] then
            return true
        end
    end

    stack[system] = false
    return false
end

-- Register a system and its dependencies
function neoECSScheduler:RegisterSystem(name: string, system: System, interval: number, dependencies: {System}?)
    dependencies = dependencies or {}
    self.dependencies[system] = dependencies

    -- Check for cyclic dependencies
    local visited = {}
    local stack = {}
    if hasCycle(system, self.dependencies, visited, stack) then
        error("Cyclic dependency detected for system: " .. tostring(system))
    end

    table.insert(self.systems, {name = name, system = system, interval = interval, lastRun = 0})
    self.executed[system] = false
end

-- Execute systems in order of dependencies
function neoECSScheduler:Update(deltaTime: number)
    for _, sys in ipairs(self.systems) do
        local system = sys.system
        if not self.executed[system] then
            local dependenciesMet = true
            for _, dependency in ipairs(self.dependencies[system]) do
                if not self.executed[dependency] then
                    dependenciesMet = false
                    break
                end
            end

            if dependenciesMet then
                sys.lastRun = sys.lastRun + deltaTime
                if sys.lastRun >= sys.interval then
                    system()  -- Execute the system's function
                    sys.lastRun = 0  -- Reset the timer
                    self.executed[system] = true  -- Mark the system as executed
                    print(sys.name .. " executed.")
                end
            end
        end
    end
end

return neoECSScheduler
