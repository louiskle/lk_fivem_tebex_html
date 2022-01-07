

------- EVENT ESX + GET COINS AU LANCEMENT DU JEU 
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
		getcoin()
	end
end)


------ APPUYER SUR UNE TOUCHE POUR ACTIVER/DESACTIVER LE NUI
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, key_open) then
			getcoin()
			setdysplay(true)
		end
		if IsControlJustPressed(0, 167) then
			setdysplay(false)
		end
	end
end)




---------------------  PARTIE FONCTION ET EVENT NUI

--- Event qui désactive le nui
RegisterNUICallback('NUIFocusOff', function()
	setdysplay(false)
end)

--- Event reçois requête si joueur a cliquer
RegisterNUICallback('addbyitem', function(t)
	for k, v in pairs(config.item) do
		if v.i == t.item then
			if Pjoueur ~= nil and v.p > Pjoueur then
				ESX.ShowAdvancedNotification('Boutique', '', 'Vous n\'avez pas assez de coins.', CHAR_, 1)
			else
				if v.t == "arme" then 
					TriggerServerEvent('lk:ba', v.i, v.p)
					ESX.ShowAdvancedNotification('Boutique', '', "Vous avez acheter : "..v.i, CHAR_, 1)
				elseif v.t == "vehicle" then
					gv(v.i,v.p,v.i)
				end
			end
			getcoin()
		end
	end

end)
--TriggerServerEvent('lk:bv', t.item, t.p,vehiculepropertie,plate)

-- Active ou désactive le nui
function setdysplay(bool)
	SetNuiFocus(bool, bool)
	SendNUIMessage({type = 'ui', status = bool})
end


-------------------------------------- PARTIE FONCTION ET EVENT SCRIPT

function getcoin()
	TriggerServerEvent('lk:gc')
end


RegisterNetEvent('lk:sc')
AddEventHandler('lk:sc', function(c)
	SendNUIMessage({type = 'point', coin = c})
end)
AddEventHandler('lk:sc', function(c)
	Pjoueur = c
end)

function gv(item,p,veh)
	ESX.ShowAdvancedNotification('Boutique', '', 'Vous avez acheter : '..item, CHAR_, 1)
	local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
	local plate = GeneratePlate()
	Citizen.Wait(10)
	ESX.Game.SpawnVehicle(veh, { x = plyCoords.x+2 ,y = plyCoords.y, z = plyCoords.z-80 }, 313.4216, function (vehicle)
		if DoesEntityExist(vehicle) then 
			SetVehicleNumberPlateText(vehicle , plate )
			if curentvehicle_fcustom == true then
				FullVehicleBoost(vehicle)
			end
			vehiculepropertie = ESX.Game.GetVehicleProperties(vehicle)
			TriggerServerEvent('lk:bv', item, p,vehiculepropertie,plate)
		end
		
	end)
end

---------------------- GENERER PLAQUE VEHICULE(POUR RETIRER L'EXPORT DE esx_vehicleshop)

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(4) .. GetRandomNumber(4))

		ESX.TriggerServerCallback('lk:geneplate', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end
local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end