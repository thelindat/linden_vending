local Items = {
	water = {'water'},
	soda = {'cola'}
}

RegisterNetEvent('linden_vending:purchase')
AddEventHandler('linden_vending:purchase', function(type)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local max = 0
		if xPlayer.getAccount('money').money >= 5 then
			for k, v in pairs(Items[type]) do max = max+1 end
			local item = Items[type][math.random(1, max)]
			if xPlayer.canCarryItem(item, 1) then
				xPlayer.addInventoryItem(item, 1)
				xPlayer.removeAccountMoney('money', 5)
				xPlayer.showNotification('You purchased 1x '..ESX.GetItemLabel(item))
			else xPlayer.showNotification('You\'re unable to carry any more') end
		else xPlayer.showNotification('You do not have enough money') end
	 end
end)
