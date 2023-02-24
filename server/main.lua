RegisterNetEvent('glz_interaction:revivePlayer', function(target)
    local source = source
    local sourcePed, targetPed = GetPlayerPed(source), GetPlayerPed(target)
    if not target or targetPed <= 0 or source == target then return end -- Invalid argument

    local sourcePos, targetPos = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)
    if not action or #(sourcePos - targetPos) < 5.0 then return end -- Maybe exploit

    TriggerClientEvent('esx_ambulancejob:revive', target)
end)

RegisterNetEvent('glz_interaction:carryPlayer', function(target)
	local source = source
	local sourceCoords = GetEntityCoords(GetPlayerPed(source))
	local targetCoords = GetEntityCoords(GetPlayerPed(target))
	local sourceState = Player(source).state
	local targetState = Player(target).state

	if #(sourceCoords - targetCoords) > 2.0 or source == target or sourceState.carried then return end

	if targetState.carried then
		TriggerClientEvent('glz_interaction:carryOff', source)
		TriggerClientEvent('glz_interaction:carryOff', target)
	else
		TriggerClientEvent('glz_interaction:carrySource', source, target)
		TriggerClientEvent('glz_interaction:carryTarget', target, source)
	end
end)

RegisterNetEvent('glz_interaction:put_in_vehicle', function(target, netId)
    local source = source
    if not Player(target).state.carried then return end
    TriggerClientEvent('glz_interaction:carryOff', target)
    TriggerClientEvent('glz_interaction:carryOff', source)
    TriggerClientEvent('glz_interaction:put_in_vehicle', target, netId)
end)
RegisterNetEvent('glz_interaction:take_out_vehicle', function(target, netId)
    TaskLeaveVehicle(GetPlayerPed(target), NetworkGetEntityFromNetworkId(netId), 0)
end)


Loots = {}
local Inventory = exports.ox_inventory:GetInventory()

lib.callback.register('glz_interaction:getLoot', function(source, type, netId)
    if not Loots[netId] then
        local items = RandomLoot(Config.Loot[type])
        local name = 'glz:loot'..netId
        local label = type == 'Peds' and 'Ped loot' or type == 'Bins' and 'Bin loot' or 'Loot'
        Inventory.Create(name, label, 'glz:loot', 20, 0, 0, false, items)
        Loots[netId] = name
    end

    return Loots[netId]
end)

AddEventHandler('entityRemoved', function(entity)
    local netId = NetworkGetNetworkIdFromEntity(entity)
    if Loots[netId] then
        Inventory.Remove(Loots[netId])
        Loots[netId] = nil
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for netId, inv in pairs(Loots) do
            Inventory.Remove(inv)
        end
    end
end)