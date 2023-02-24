---@param name string
---@return Action|nil
GetAction = function(name)
    for i = 1, #Actions.PlayerInteraction do
        if Actions.PlayerInteraction[i].name == name then
            return Actions.PlayerInteraction[i]
        end
    end
end

RandomLoot = function(loot)
	local items = {}

	for i = 1, #loot do
		local item = loot[i]
		if math.random(1, 100) <= (item[4] or 80) then
			local count = math.random(item[2], item[3])
			if count > 0 then
				local slot = #items+1
				item = exports.ox_inventory:Items(item[1])
				if item then
					item.count = count
					item.slot = slot
					items[slot] = item
				end
			end
		end
	end

	return items
end


---@param msg string
---@param source? integer
SendNotification = function(msg, source)
	if IsDuplicityVersion() then
		TriggerClientEvent('esx:showNotification', source, msg)
	else
		ESX.ShowNotification(msg)
	end
end