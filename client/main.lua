CreateThread(function()
    exports.ox_target:addGlobalPlayer(Actions.PlayerInteraction)
    exports.ox_target:addGlobalPed(Actions.PedInteraction)
    exports.ox_target:addModel(Config.Dumpsters, Actions.BinInteraction)
end)

if Config.HandsUp.Enable then
    RegisterCommand(Config.HandsUp.Command, ToggleHandsUp)

    RegisterKeyMapping(Config.HandsUp.Command, 'Hands Up', 'keyboard', Config.HandsUp.DefaultKey)
end