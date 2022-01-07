TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




RegisterServerEvent('lk:gc')
AddEventHandler('lk:gc', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local license = ESX.GetIdentifierFromId(source)

	MySQL.Async.fetchAll('SELECT `lk_points` FROM `users` WHERE `identifier` = @licence', {
        ['@licence'] = license
	}, function(data)
		data[1].lk_points = data[1].lk_points or 0 
		if data[1].lk_points ~= nil then
			TriggerClientEvent('lk:sc', _source, data[1].lk_points)
		end
	end)
end)




RegisterServerEvent('lk:ba')
AddEventHandler('lk:ba', function(a, c)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function (result)
		local newpoint = result[1].lk_points - c
		MySQL.Async.execute("UPDATE `users` SET `lk_points`= '".. newpoint .."' WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function() end) 
		xPlayer.addWeapon(a, 200)
	end)
end)

RegisterServerEvent('lk:bv')
AddEventHandler('lk:bv', function(a, c, v, p)
	local xPlayer = ESX.GetPlayerFromId(source)
    local license = ESX.GetIdentifierFromId(source)
	MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function (result)
		local newpoint = result[1].lk_points - c
		MySQL.Async.execute("UPDATE `users` SET `lk_points`= '".. newpoint .."' WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function() end) 
		v.plate = p
		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, state) VALUES (@owner, @plate, @vehicle ,@state)', {
			['@owner']   = license,
			['@plate']   = p,
			['@vehicle'] = json.encode(v),
			['@state'] = true
		}, function(rowsChange)
		end)
	end)
end)


ESX.RegisterServerCallback('lk:geneplate', function(source, cb, plate)
	local _source = source
TriggerEvent('lk:geneplate', _source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

RegisterCommand("gp", function(source, args)
    if source == 0 then
        if args[1] ~= nil and args[2] == nil then
            MySQL.Async.fetchAll("SELECT * FROM users WHERE phone_number = @id", {["@id"] = args[1]}, function(result)
                print("^1[Coins] ^0Le code boutique "..args[1].." à "..result[1].lk_points.." Coins.")
            end)
        end
        if args[1] == "give" then
            MySQL.Async.execute("UPDATE users SET lk_points = lk_points + @coins WHERE phone_number = @id", {["@id"] = args[2], ["@coins"] = args[3]}, function()
            end)
            print('Coins give - Boutique')
        elseif args[1] == "remove" then
            MySQL.Async.execute("UPDATE users SET lk_points = lk_points - @coins WHERE phone_number = @id", {["@id"] = args[2], ["@coins"] = args[3]}, function()
            end)
        elseif args[1] == "transfer" then
            MySQL.Async.fetchAll("SELECT * FROM users WHERE phone_number = @id", {["@id"] = args[2]}, function (result)
                if args[4] > result[1].lk_points then
                    print("^1[Coins] ^0Cette personne n'a pas assez de coins.")
                else
                    print("^1[Coins] ^0Vous avez transféré "..args[4].." Coins de "..args[2].." à "..args[3]..".")
                    MySQL.Async.execute("UPDATE users SET lk_points = lk_points + @coins WHERE phone_number = @id", {["@coins"] = args[4], ["@id"] = args[3]}, function() end)
                    MySQL.Async.execute("UPDATE users SET lk_points = lk_points - @coins WHERE phone_number = @id", {["@coins"] = args[4], ["@id"] = args[2]}, function() end)
                end
            end)
        end
    end
end, false)





