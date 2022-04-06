ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('kx-bank:server:GetPlayerName', function(source, cb)
	local _char = ESX.GetPlayerFromId(source)
	local _charname = _char.getName()
	cb(_charname)
end)

RegisterServerEvent('kx-bank:server:depositvb')
AddEventHandler('kx-bank:server:depositvb', function(amount, inMenu)
	local _src = source
	local _char = ESX.GetPlayerFromId(_src)
	amount = tonumber(amount)
	Citizen.Wait(50)
	if amount == nil or amount <= 0 or amount > _char.getMoney() then
		TriggerClientEvent('chatMessage', _src, "Cantidad Inválida.")
	else
		_char.removeMoney(amount)
		_char.addAccountMoney('bank', tonumber(amount))
		_char.showNotification("Has ingresado $"..amount)
	end
end)

RegisterServerEvent('kx-bank:server:withdrawvb')
AddEventHandler('kx-bank:server:withdrawvb', function(amount, inMenu)
	local _src = source
	local _char = ESX.GetPlayerFromId(_src)
	local _base = 0
	amount = tonumber(amount)
	_base = _char.getAccount('bank').money
	Citizen.Wait(100)
	if amount == nil or amount <= 0 or amount > _base then
		TriggerClientEvent('chatMessage', _src, "Cantidad Inválida")
	else
		_char.removeAccountMoney('bank', amount)
		_char.addMoney(amount)
		_char.showNotification("Has retirado $"..amount)
	end
end)

RegisterServerEvent('kx-bank:server:balance')
AddEventHandler('kx-bank:server:balance', function(inMenu)
	local _src = source
	local _char = ESX.GetPlayerFromId(_src)
	local balance = _char.getAccount('bank').money
	TriggerClientEvent('kx-bank:client:refreshbalance', _src, balance)
end)

RegisterServerEvent('kx-bank:server:transfervb')
AddEventHandler('kx-bank:server:transfervb', function(to, amountt, inMenu)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(tonumber(to))
	local balance = 0
	if zPlayer ~= nil then
		balance = xPlayer.getAccount('bank').money
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('chatMessage', _source, "No te puedes transferir dinero a ti mismo")	
		else
			if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
				TriggerClientEvent('chatMessage', _source, "No tienes suficiente dinero en el banco.")
			else
				xPlayer.removeAccountMoney('bank', tonumber(amountt))
				zPlayer.addAccountMoney('bank', tonumber(amountt))
				zPlayer.showNotification("Te han enviado una transferencia de "..amountt.."$ por parte de la ID: ".._source)
				xPlayer.showNotification("Has enviado una transferencia de "..amountt.."$ a la ID: "..to)
			end
		end
	else
		TriggerClientEvent('chatMessage', _source, "ese numero de cuenta no e")
	end
end)
