--================================================================================================
--==                      kx-bank BY VISIBAIT (BASED OFF NEW_BANKING)                        ==
--================================================================================================

ESX                         = nil
local inMenu = false
local atbank = false

--
-- MAIN THREAD
--

Citizen.CreateThread(function()

  while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

  while true do
    local _sleep = true
    Citizen.Wait(0)
    if nearBankorATM() then
      _sleep = false
      DisplayHelpText("Presiona ~INPUT_PICKUP~ pour acceder a votre compte ~b~")
      if IsControlJustPressed(1, 38) then
        inMenu = true
        TriggerEvent("kx-atm:Open")
        SetNuiFocus(true, true)
        TriggerServerEvent('kx-bank:server:balance', inMenu)
      end
      if IsControlPressed(1, 322) then
        inMenu = false
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'close'})
      end
    end
    if _sleep then Citizen.Wait(1000) end
  end
end)


RegisterNetEvent("kx-atm:Open")
AddEventHandler("kx-atm:Open", function()
	local dict = 'anim@amb@prop_human_atm@interior@male@enter'
  local anim = 'enter'
	local ped = GetPlayerPed(-1)
  local time = 2500

	RequestAnimDict(dict)

  while not HasAnimDictLoaded(dict) do
    Citizen.Wait(7)
  end

  TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
	exports['progressBars']:startUI(time, "Insertion de la carte...")
  Citizen.Wait(time)
  ClearPedTasks(ped)

	ESX.TriggerServerCallback('esx:getPlayerData', function(data)
    SendNUIMessage({type = 'openGeneral', banco = atbank})
	end)

end)
--
-- BLIPS
--

Citizen.CreateThread(function()
  for k,v in ipairs(Config.Zonas["banks"])do
  local blip = AddBlipForCoord(v.x, v.y, v.z)
  SetBlipSprite(blip, v.id)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.8)
  SetBlipColour (blip, 2)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(tostring(v.name))
  EndTextCommandSetBlipName(blip)
  end
end)

--
-- EVENTS
--

RegisterNetEvent('kx-bank:client:refreshbalance')
AddEventHandler('kx-bank:client:refreshbalance', function(balance)
  local _streetcoords = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(PlayerPedId()))))
  local _pid = GetPlayerServerId(PlayerId())
  ESX.TriggerServerCallback('kx-bank:server:GetPlayerName', function(playerName)
    SendNUIMessage({
      type = "balanceHUD",
      balance = balance,
      player = playerName,
      address = _streetcoords,
      playerid = _pid
    })
  end)
end)


-- NUI CALLBACKS
--

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('kx-bank:server:depositvb', tonumber(data.amount), inMenu)
	TriggerServerEvent('kx-bank:server:balance', inMenu)
end)

RegisterNUICallback('withdraw', function(data)
	TriggerServerEvent('kx-bank:server:withdrawvb', tonumber(data.amountw), inMenu)
	TriggerServerEvent('kx-bank:server:balance', inMenu)
end)

RegisterNUICallback('balance', function()
	TriggerServerEvent('kx-bank:server:balance', inMenu)
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end) 

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('kx-bank:server:transfervb', data.to, data.amountt, inMenu)
	TriggerServerEvent('kx-bank:server:balance', inMenu)
end)

RegisterNetEvent('kx-bank:result')
AddEventHandler('kx-bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false)
	menuIsShowed = false
	SendNUIMessage({
		hideAll = true
	})
	local dict = 'anim@amb@prop_human_atm@interior@male@exit'
  local anim = 'exit'
  local ped = GetPlayerPed(-1)
  local time = 1800
	RequestAnimDict(dict)

  while not HasAnimDictLoaded(dict) do
    Citizen.Wait(7)
  end

  SetNuiFocus(false, false)
  SendNUIMessage({type = 'closeAll'})
  TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
  exports['progressBars']:startUI(time, "Retirer la carte...")
  Citizen.Wait(time)
  ClearPedTasks(ped)
end)

--
-- FUNCS
--

nearBankorATM = function()
    local _ped = PlayerPedId()
    local _pcoords = GetEntityCoords(_ped)
    local _toreturn = false
    for _, search in pairs(Config.Zonas["banks"]) do
    local distance = #(vector3(search.x, search.y, search.z) - vector3(_pcoords))
    if distance <= 3 then
        atbank = true
        toreturn = true
        DrawText3D(search.x, search.y, search.z, 'Appuyer sur  ~y~E~w~~r~~w~ Pour ouvrir')
        DrawMarker(2,search.x, search.y, search.z, 0.0, 0.0, 0.0, 300.0, 0.0, 0.0, 0.25, 0.25, 0.05, 0, 100, 255, 255, false, true, 2, false, false, false, false)
        end
    end
    for _, search in pairs(Config.Zonas["atms"]) do
    local distance = #(vector3(search.x, search.y, search.z) - vector3(_pcoords))
    if distance <= 2 then
        atbank = false
            _toreturn = true
        end
    end
    return _toreturn
end

DisplayHelpText = function(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

DrawText3D = function(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
