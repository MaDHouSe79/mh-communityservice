local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add(Config.Command.start, Lang:t('command.start'), {}, true, function(source, args)
    if args[1] and tonumber(args[2]) then
        TriggerEvent('mh-communityservice:sendToCommunityService', source, tonumber(args[1]), tonumber(args[2]))
    end
end,'admin')

QBCore.Commands.Add(Config.Command.ending, Lang:t('command.end'), {}, true, function(source, args)
    local staffID = source
    local staffDiscord, staffName = nil, nil
    local PlayerStaff = QBCore.Functions.GetPlayer(staffID)
    if PlayerStaff then
        staffName = PlayerStaff.PlayerData.charinfo.firstname..' '..PlayerStaff.PlayerData.charinfo.lastname
    end
    for k, v in ipairs(GetPlayerIdentifiers(staffID)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            staffDiscord = string.gsub(v, "discord:", "")
            break
        end
    end
    if args[1] then
        if GetPlayerName(args[1]) ~= nil then
            staffReleaseFromCommunityService(tonumber(args[1]), staffName, staffID, staffDiscord)
        end
    else
        staffReleaseFromCommunityService(source, staffName, staffID, staffDiscord)
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
AddEventHandler('mh-communityservice:sendToCommunityService', function(source, target, actions_count)
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

    local staffMember = QBCore.Functions.GetPlayer(source)
    local staffName = staffMember.PlayerData.charinfo.firstname..' '..staffMember.PlayerData.charinfo.lastname
    local staffID = source
    local staffDiscord = nil
    for k, v in ipairs(GetPlayerIdentifiers(staffID)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            staffDiscord = string.gsub(v, "discord:", "")
            break
        end
    end

    local targetPlayer = QBCore.Functions.GetPlayer(_target)
    local targetName = targetPlayer.PlayerData.charinfo.firstname..' '..targetPlayer.PlayerData.charinfo.lastname
    local targetID = _target
    local targetDiscord = nil
    for k, v in ipairs(GetPlayerIdentifiers(targetID)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            targetDiscord = string.gsub(v, "discord:", "")
            break
        end
    end

    discordLog(staffName, staffID, staffDiscord, targetName, targetID, targetDiscord, actions_count)
    TriggerClientEvent('QBCore:Notify', -1, Lang:t('info.comserv_msg',{user = targetName, amount = actions_count}), "success")
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


function staffReleaseFromCommunityService(target, staffID, staffName, staffDiscord)
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
    local PlayerRecipient = QBCore.Functions.GetPlayer(_target)
    local recipientName, recipientDiscord = nil, nil
    if PlayerRecipient then
        recipientName = PlayerRecipient.PlayerData.charinfo.firstname..' '..PlayerRecipient.PlayerData.charinfo.lastname
    end
    for k, v in ipairs(GetPlayerIdentifiers(_target)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            recipientDiscord = string.gsub(v, "discord:", "")
            break
        end
    end
    TriggerClientEvent('mh-communityservice:finishCommunityService', _target)
    TriggerClientEvent('QBCore:Notify', -1, Lang:t('info.comserv_finished',{user = recipientName}), "success")
    sendDiscordWebhook(staffID, staffName, staffDiscord, _target, recipientName, recipientDiscord)
end



--endcomserv log
function sendDiscordWebhook(staffName, staffID, staffDiscord, recipientName, recipientID, recipientDiscord)
    local discord_webhook = "YOUR_WEBHOOK_HERE"
    local embed = {
        {
            ["color"]=16711680, -- You can change the color of the embed here.
            ["title"]="Community Service Ended",
			["description"]= string.format("Staff name: **%s**\nStaff ID: **%s**\nStaff Discord: <@%s>\n\nManually ended comserv of\n\nTarget Name: **%s**\nTarget ID: **%s**\nTarget Discord: <@%s>", staffName, staffID, staffDiscord, recipientID, recipientName, recipientDiscord),
			["footer"]= {
				["text"]= os.date('%c'),
            },
        }
    }
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json'})
end



-- send to comserv logs
local webhookurl = "YOUR_WEBHOOK_HERE"

function discordLog(staffName, staffID, staffDiscord, targetName, targetID, targetDiscord, actions_count)
    local embed = {
        {
            ["color"] = 16777215,
            ["title"] = "Community Service Logs",
			["description"] = string.format("Staff name: %s\nStaff ID: %s\nStaff Discord: <@%s>\n\nAssigned **%s** actions of comserv to:\n\nTarget Name: %s\nTarget ID: %s\nTarget Discord: <@%s>", staffName, staffID, staffDiscord, actions_count, targetName, targetID, targetDiscord),
            ["footer"] = {
                ["text"] = os.date('%c'),
            },
        }
    }
    PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = staffName, embeds = embed}), { ['Content-Type'] = 'application/json' })
end