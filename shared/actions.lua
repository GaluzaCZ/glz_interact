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
            canInteract = function(entity)
                return not IsPedDeadOrDying(entity)
            end,
            onSelect = function(data)
                TriggerServerEvent('esx_policejob:handcuffAnim', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
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
    PedInteraction = {
        {
            name = 'steal_ped',
            label = TranslateCap('steal_ped'),
            icon = 'fas fa-user-secret',
            distance = 2.0,
            canInteract = function(entity)
                return GetPedType(entity) ~= "PED_TYPE_ANIMAL"
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
            onSelect = function(data)
                SearchDumpster(data.entity)
            end
        },
    },
}