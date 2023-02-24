LocalPlayer.state:set("carried", false, true)

AnimBusy = false
CurrentAnimation = {Dict = nil, Anim = nil, Duration = nil, Flag = nil}
Ped = PlayerPedId()

CreateThread(function()
    exports.ox_target:addGlobalPlayer(Actions.PlayerInteraction)
    exports.ox_target:addGlobalVehicle(Actions.VehicleInteraction)
    exports.ox_target:addGlobalPed(Actions.PedInteraction)
    exports.ox_target:addModel(Config.Dumpsters, Actions.BinInteraction)

    while true do
        local Ped = PlayerPedId()
        if AnimBusy and not IsEntityPlayingAnim(Ped, CurrentAnimation.Dict, CurrentAnimation.Anim, 3) then
            PlayAnim(CurrentAnimation.Dict, CurrentAnimation.Anim, CurrentAnimation.Duration, CurrentAnimation.Flag)
        end
        Wait(500)
    end
end)

---@param vehicle integer Player current vehicle
---@param seat integer Player current seat
StartDisablingShuff = function(vehicle, seat)
    SetPedConfigFlag(Ped, 184, true)
    CreateThread(function()
        local timeout = 100
        while timeout > 1 do
            if GetIsTaskActive(Ped, 165) then
                SetPedIntoVehicle(Ped, vehicle, seat)
                return
            end
            timeout = timeout - 1
            Wait(1)
        end
    end)
end

if Config.HandsUp.Enable then
    RegisterCommand(Config.HandsUp.Command, ToggleHandsUp)

    RegisterKeyMapping(Config.HandsUp.Command, 'Hands Up', 'keyboard', Config.HandsUp.DefaultKey)
end

if Config.Carry.Enable then
    RegisterCommand(Config.Carry.Command, function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 2.0 then return end

        TriggerServerEvent('glz_interaction:carryPlayer', GetPlayerServerId(closestPlayer))
    end)
end

AddEventHandler('esx:enteringVehicle', function()
    if AnimBusy then
        TaskLeaveAnyVehicle(Ped, 0, 0)
        SendNotification(TranslateCap('cant_drive_vehicle_in_anim'))
        return
    end
end)
AddEventHandler('esx:enteredVehicle', function(vehicle, _, seat)
    if AnimBusy then
        TaskLeaveAnyVehicle(Ped, 0, 16)
        SendNotification(TranslateCap('cant_drive_vehicle_in_anim'))
        return
    end
    if Config.Shuff.Enable and seat == 0 then
        StartDisablingShuff(vehicle, seat)
    end
end)
if Config.Shuff.Enable then
    AddEventHandler('esx:exitedVehicle', function(vehicle, _, seat)
        SetPedConfigFlag(Ped, 184, false)
    end)
    RegisterCommand(Config.Shuff.Command, function()
        if not IsPedInAnyVehicle(Ped, false) then return end

        local vehicle = GetVehiclePedIsIn(Ped, false)
        if GetVehicleMaxNumberOfPassengers(vehicle) < 1 then return end
        TaskShuffleToNextVehicleSeat(Ped, vehicle)

        if GetPedInVehicleSeat(vehicle, -1) == Ped and IsVehicleSeatFree(vehicle, 0) then
            SetPedConfigFlag(Ped, 184, true)
        end
    end)
end

CurrentCarry = nil
RegisterNetEvent('glz_interaction:carrySource', function(target)
    PlayAnim("missfinale_c2mcs_1", "fin_c2_mcs_1_camman", -1, 49)
    CurrentCarry = target
end)
RegisterNetEvent('glz_interaction:carryTarget', function(carrier)
    PlayAnim("nm", "firemans_carry", -1, 33)
    local carrierPed = GetPlayerPed(GetPlayerFromServerId(carrier))
    AttachEntityToEntity(Ped, carrierPed, 0, 0.27, 0.15, 0.63, 0.5, 0.5, 180, false, false, false, false, 2, false)
    LocalPlayer.state:set("carried", true, true)
end)
RegisterNetEvent('glz_interaction:carryOff', function()
    AnimBusy = false
    ClearPedTasks(Ped)

    CurrentCarry = nil

    if LocalPlayer.state.carried then
        DetachEntity(Ped, true, true)
        LocalPlayer.state:set("carried", false, true)
    end
end)

RegisterNetEvent('glz_interaction:put_in_vehicle', function(netId)
    local vehicle = NetToVeh(netId)
    for i = 0, GetVehicleMaxNumberOfPassengers(vehicle)-1 do
        if IsVehicleSeatFree(vehicle, i) then
            SetPedIntoVehicle(Ped, vehicle, i)
            break
        end
    end
end)