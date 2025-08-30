local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add(Config.Command.start, Lang:t('command.start'), {}, true, function(source, args)
	if args[1] and tonumber(args[2]) then
		TriggerEvent('mh-communityservice:sendToCommunityService', tonumber(args[1]), tonumber(args[2]))
	end
end, 'admin')

QBCore.Commands.Add(Config.Command.ending, Lang:t('command.end'), {}, true, function(source, args)
	if args[1] then
		if GetPlayerName(args[1]) ~= nil then
			TriggerEvent('mh-communityservice:endCommunityServiceCommand', tonumber(args[1]))
		end
	else
		TriggerEvent('mh-communityservice:endCommunityServiceCommand', source)
	end
end, 'admin')

RegisterServerEvent('mh-communityservice:endCommunityServiceCommand')
AddEventHandler('mh-communityservice:endCommunityServiceCommand', function(source)
	if source ~= nil then
		releaseFromCommunityService(source)
	end
end)

-- unjail after time served
RegisterServerEvent('mh-communityservice:finishCommunityService')
AddEventHandler('mh-communityservice:finishCommunityService', function()
	releaseFromCommunityService(source)
end)

RegisterServerEvent('mh-communityservice:completeService')
AddEventHandler('mh-communityservice:completeService', function()
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]
	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining - 1 WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
		else
			print ("mh-communityservice :: Problem matching player citizenid in database to reduce actions.")
		end
	end)
end)

RegisterServerEvent('mh-communityservice:extendService')
AddEventHandler('mh-communityservice:extendService', function()
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]
	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining + @extension_value WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@extension_value'] = Config.ServiceExtensionOnEscape
			})
		else
			print ("mh-communityservice :: Problem matching player citizenid in database to reduce actions.")
		end
	end)
end)


RegisterServerEvent('mh-communityservice:sendToCommunityService')
AddEventHandler('mh-communityservice:sendToCommunityService', function(target, actions_count)
	local _target = target
	local identifier = GetPlayerIdentifiers(_target)[1]
	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = @actions_remaining WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@actions_remaining'] = actions_count
			})
		else
			MySQL.Async.execute('INSERT INTO communityservice (identifier, actions_remaining) VALUES (@identifier, @actions_remaining)', {
				['@identifier'] = identifier,
				['@actions_remaining'] = actions_count
			})
		end
	end)
	TriggerClientEvent('mh-communityservice:inCommunityService', _target, actions_count)
	local Player = QBCore.Functions.GetPlayer(_target)
	local tmpName = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
	TriggerClientEvent('QBCore:Notify', -1, Lang:t('info.comserv_msg',{user = tmpName, amount = actions_count}), "success")
end)

RegisterServerEvent('mh-communityservice:checkIfSentenced')
AddEventHandler('mh-communityservice:checkIfSentenced', function()
	local _source = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(_source)[1]
	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] ~= nil and result[1].actions_remaining > 0 then
			TriggerClientEvent('mh-communityservice:inCommunityService', _source, tonumber(result[1].actions_remaining))
		end
	end)
end)

function releaseFromCommunityService(target)
	local _target = target
	local identifier = GetPlayerIdentifiers(_target)[1]
	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('DELETE from communityservice WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
		end
	end)
	local Player = QBCore.Functions.GetPlayer(_target)
	local tmpName = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
	TriggerClientEvent('mh-communityservice:finishCommunityService', _target)
	TriggerClientEvent('QBCore:Notify', -1, Lang:t('info.comserv_finished',{user = tmpName}), "success")
end
