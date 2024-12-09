local PrimaryItems = {}

local ItemsFolder = script.Parent.items

-- For each module in the items folder, require it and add it to the PrimaryItems table
for _, itemModule in ipairs(ItemsFolder:GetChildren()) do
    if itemModule:IsA("ModuleScript") then
        local item = require(itemModule)
        PrimaryItems[item.name] = item
    end
end

return PrimaryItems