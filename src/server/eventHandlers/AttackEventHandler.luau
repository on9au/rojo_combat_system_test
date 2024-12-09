-- src/server/eventHandlers/AttackEventHandler.luau

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AttackEvent = ReplicatedStorage:WaitForChild("AttackEvent")
local PrimaryItems = require(ReplicatedStorage.Shared.primaryItems.PrimaryItems)
local ComboComponent = require(script.Parent.Parent.components.ComboComponent)

AttackEvent.OnServerEvent:Connect(function(player, actionName, clientComboCount)
    print("Event received!", player.Name, actionName, clientComboCount)

    local currentTime = tick()
    local primaryActionItemName = player:GetAttribute("PrimaryActionItem") or "Punch"

    -- Validate action name
    if actionName ~= primaryActionItemName then
        warn("Invalid action attempted by", player.Name)
        return
    end

    local primaryActionItem = PrimaryItems[primaryActionItemName]
    if not primaryActionItem then
        warn("Invalid primary action item:", primaryActionItemName)
        return
    end

    -- Initialize ComboComponent
    ComboComponent.init(player)

    -- Server-side combo data
    local serverComboCount = player:GetAttribute("ServerComboCount") or 0
    local lastComboTime = player:GetAttribute("ServerLastComboTime") or 0
    local comboWindow = primaryActionItem.comboWindow
    local maxComboCount = primaryActionItem.maxComboCount

    -- Server-side combo logic
    if currentTime - lastComboTime <= comboWindow then
        serverComboCount = serverComboCount + 1
    else
        serverComboCount = 1
    end

    if serverComboCount > maxComboCount then
        serverComboCount = 1
    end

    -- Validate combo count
    if clientComboCount ~= serverComboCount then
        warn("Player", player.Name, "sent invalid combo count. Expected:", serverComboCount, "Received:", clientComboCount)
        return
    end

    -- Update combo attributes
    player:SetAttribute("ServerComboCount", serverComboCount)
    player:SetAttribute("ServerLastComboTime", currentTime)

    -- Set hitbox and damage attributes
    player:SetAttribute("HitboxSize", primaryActionItem.hitboxSize)
    player:SetAttribute("HitboxOffset", primaryActionItem.hitboxOffset)

    if serverComboCount == maxComboCount then
        player:SetAttribute("Damage", primaryActionItem.maxComboDamage)
        player:SetAttribute("Penetration", primaryActionItem.maxComboPenetration)
        player:SetAttribute("CooldownEndTime", currentTime + primaryActionItem.maxComboCooldownTime)
        player:SetAttribute("HitboxEndTime", currentTime + primaryActionItem.maxComboHitboxDuration)
    else
        player:SetAttribute("Damage", primaryActionItem.damage)
        player:SetAttribute("Penetration", primaryActionItem.penetration)
        player:SetAttribute("CooldownEndTime", currentTime + primaryActionItem.cooldownTime)
        player:SetAttribute("HitboxEndTime", currentTime + primaryActionItem.hitboxDuration)
    end

    player:SetAttribute("IsActive", true)
    player:SetAttribute("SpeedMultiplier", primaryActionItem.speedMultiplier)
end)

return nil