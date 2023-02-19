PlayAnim = function(dict, anim, duration, flag)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(1)
        end
    end
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, duration, flag, 0, false, false, false)
    RemoveAnimDict(dict)
end

ToggleHandsUp = function()
    local ped = PlayerPedId()
    if IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3) then
        ClearPedTasks(ped)
    elseif IsPedOnFoot(ped) then
        PlayAnim('missminuteman_1ig_2', 'handsup_enter', -1, 50)
    end
end

RevivePlayer = function(closestPlayer)
	local dict, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'

	PlayAnim(dict, anim, -1, 1)

	SetTimeout(Config.ReviveTime, function()
		TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
		if ESX.PlayerData.job.name == 'ambulance' then
			TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
		else
			TriggerServerEvent('glz_interaction:revivePlayer', GetPlayerServerId(closestPlayer))
		end
		ClearPedTasks(PlayerPedId())
	end)
end

StealPed = function(entity)
    local success = lib.skillCheck('easy')
    if not success then
        if not IsPedDeadOrDying(entity) then
            ClearPedTasksImmediately(entity)
            TaskReactAndFleePed(entity, cache.ped)
            TriggerServerEvent('someEventThatHandlePoliceNotifications')
            lib.notify({
                title = TranslateCap('police_notify_sent'),
                duration = 5000,
                position = 'top',
                style = {
                    backgroundColor = '#141517',
                    color = '#909296'
                },
                icon = 'shield-halved',
                iconColor = '#C53030'
            })
        end
        return
    end
    if not NetworkGetEntityIsNetworked(entity) then
        NetworkRegisterEntityAsNetworked(entity)
    end
    local netId = NetworkGetNetworkIdFromEntity(entity)
	exports.ox_inventory:openInventory('glz:loot', lib.callback.await('glz_interaction:getLoot', false, 'Peds', netId))
    if not IsPedDeadOrDying(entity) then
        ClearPedTasksImmediately(entity)
        TaskReactAndFleePed(entity, cache.ped)
        TriggerServerEvent('someEventThatHandlePoliceNotifications')
        lib.notify({
            title = TranslateCap('police_notify_sent'),
            duration = 5000,
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#909296'
            },
            icon = 'shield-halved',
            iconColor = '#C53030'
        })
    end
end

SearchDumpster = function(entity)
    local success = lib.skillCheck('easy')
    if not success then return end
    if not NetworkGetEntityIsNetworked(entity) then
        NetworkRegisterEntityAsNetworked(entity)
    end
    local netId = NetworkGetNetworkIdFromEntity(entity)
	exports.ox_inventory:openInventory('glz:loot', lib.callback.await('glz_interaction:getLoot', false, 'Bins', netId))
end