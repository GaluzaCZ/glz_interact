---@class Action
---@field name string
---@field label string
---@field distance number
---@field icon? string
---@field groups? string | string[] | table<string, integer>
---@field items? string | string[] | table<string, number>
---@field canInteract? fun(entity: integer, distance: number, coords: vector3, name: string, bone: integer): boolean
---@field onSelect? fun(data: table)

---@type table<string, Action[]>
Actions = {
    PlayerInteraction = {
        {
            name = 'handcuff',
            label = TranslateCap('handcuff'),
            icon = 'fas fa-handcuffs',
            distance = 2.0,
            items = 'handcuffs',
            canInteract = function()
                return not AnimBusy and not IsPedDeadOrDying(entity)
            end,
            onSelect = function(data)
                TriggerServerEvent('esx_policejob:handcuffAnim', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
            end
        },
        {
            name = 'carry',
            label = TranslateCap('carry'),
            icon = 'fas fa-hands-holding-child',
            distance = 2.0,
            canInteract = function()
                return not AnimBusy
            end,
            onSelect = function(data)
                TriggerServerEvent('glz_interaction:carryPlayer', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
            end
        },
        {
            name = 'search',
            label = TranslateCap('search'),
            icon = 'fas fa-magnifying-glass',
            distance = 2.0,
            canInteract = function(entity)
                return IsPedDeadOrDying(entity) or IsPedCuffed(entity) or IsEntityPlayingAnim(entity, 'missminuteman_1ig_2', 'handsup_enter', 3)
            end,
            onSelect = function(data)
                exports.ox_inventory:openInventory('player', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
            end
        },
        {
            name = 'revive',
            label = TranslateCap('revive'),
            icon = 'fas fa-suitcase-medical',
            distance = 2.0,
            items = 'medikit',
            canInteract = function(entity)
                return IsPedDeadOrDying(entity)
            end,
            onSelect = function(data)
                RevivePlayer(NetworkGetPlayerIndexFromPed(data.entity))
            end
        },
    },
    VehicleInteraction = {
        {
            name = 'put_in_vehicle',
            label = TranslateCap('put_in_vehicle'),
            icon = 'fas fa-handshake-angle',
            distance = 2.0,
            canInteract = function(entity)
                for i = 0, GetVehicleMaxNumberOfPassengers(entity)-1 do
                    if IsVehicleSeatFree(entity, i) then
                        return CurrentCarry
                    end
                end
                return false
            end,
            onSelect = function(data)
                TriggerServerEvent('glz_interaction:put_in_vehicle', CurrentCarry, VehToNet(data.entity))
            end
        },
        {
            name = 'take_out_vehicle',
            label = TranslateCap('take_out_vehicle'),
            icon = 'fas fa-handshake-angle',
            distance = 2.0,
            canInteract = function(entity)
                for i = GetVehicleMaxNumberOfPassengers(entity)-1, 0, -1 do
                    if not IsVehicleSeatFree(entity, i) and IsPedAPlayer(GetPedInVehicleSeat(entity, i)) then
                        return true
                    end
                end
                return false
            end,
            onSelect = function(data)
                for i = GetVehicleMaxNumberOfPassengers(data.entity)-1, 0, -1 do
                    if not IsVehicleSeatFree(data.entity, i) and IsPedAPlayer(GetPedInVehicleSeat(data.entity, i)) then
                        return TriggerServerEvent('glz_interaction:take_out_vehicle', GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(data.entity, i))), VehToNet(data.entity))
                    end
                end
            end
        },
    },
    PedInteraction = {
        {
            name = 'steal_ped',
            label = TranslateCap('steal_ped'),
            icon = 'fas fa-user-secret',
            distance = 2.0,
            canInteract = function(entity)
                return GetPedType(entity) ~= "PED_TYPE_ANIMAL" and not IsEntityAMissionEntity(entity)
            end,
            onSelect = function(data)
                StealPed(data.entity)
            end
        },
    },
    BinInteraction = {
        {
            name = 'search_bin',
            label = TranslateCap('search_bin'),
            icon = 'fas fa-trash-can',
            distance = 2.0,
            canInteract = function(entity)
                return not IsEntityAMissionEntity(entity)
            end,
            onSelect = function(data)
                SearchDumpster(data.entity)
            end
        },
    },
}