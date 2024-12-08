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
    self.systems_by_function = {}  -- Store systems by function for quick lookup
    self.dependencies = {}  -- Store system dependencies (system -> list of dependencies)
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

-- Helper function to perform topological sort
local function topologicalSort(systems, systems_by_function)
    local visited = {}
    local order = {}

    local function visit(systemData)
        local system = systemData.system
        if not visited[system] then
            visited[system] = true
            for _, dependency in ipairs(systems_by_function[system] or {}) do
                visit(dependency)
            end
            table.insert(order, systemData)
        end
    end

    for _, system in ipairs(systems) do
        visit(system)
    end

    print("Execution order:")
    for i, systemData in ipairs(order) do
        print(i, systemData.name)
    end

    return order
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
    self.systems_by_function[system] = self.systems[#self.systems]

    -- Update execution order by sorting systems
    self.systems = topologicalSort(self.systems, self.systems_by_function)
end

-- Execute systems in precomputed order
function neoECSScheduler:Update(deltaTime: number)
    -- print("Updating scheduler")
    -- print("Delta time: " .. deltaTime)
    -- print("Systems to execute:")
    -- for _, sysData in ipairs(self.systems) do
    --     print(sysData.name)
    -- end
    for _, sysData in ipairs(self.systems) do
        if sysData.interval == 0 then
            sysData.system()  -- Execute the system's function immediately if interval is 0
            -- print(sysData.name .. " executed immediately")
        else
            sysData.lastRun = sysData.lastRun + deltaTime
            if sysData.lastRun >= sysData.interval then
                sysData.system()  -- Execute the system's function
                -- print(sysData.name .. " executed after " .. sysData.lastRun .. " seconds")
                sysData.lastRun = sysData.lastRun - sysData.interval  -- Adjust the timer instead of resetting to handle missed intervals
            end
        end
    end
    -- print("Scheduler updated")
end

return neoECSScheduler
