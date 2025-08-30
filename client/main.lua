local QBCore = exports['qb-core']:GetCoreObject()
local isSentenced = false
local communityServiceFinished = false
local actionsRemaining = 0
local availableActions = {}
local disable_actions = false
local vassoumodel = "prop_tool_broom"
local vassour_net = nil
local spatulamodel = "bkr_prop_coke_spatula_04"
local spatula_net = nil
local PlayerData = {}

local function Round(input, decimalPlaces)
    return tonumber(string.format("%." .. (decimalPlaces or 0) .. "f", input))
end

function FillActionTable(last_action)
	while #availableActions < 5 do
		local service_does_not_exist = true
		local random_selection = Config.ServiceLocations[math.random(1,#Config.ServiceLocations)]
		for i = 1, #availableActions do
			if random_selection.coords.x == availableActions[i].coords.x and random_selection.coords.y == availableActions[i].coords.y and random_selection.coords.z == availableActions[i].coords.z then
				service_does_not_exist = false
			end
		end
		if last_action ~= nil and random_selection.coords.x == last_action.coords.x and random_selection.coords.y == last_action.coords.y and random_selection.coords.z == last_action.coords.z then
			service_does_not_exist = false
		end
		if service_does_not_exist then
			table.insert(availableActions, random_selection)
		end
	end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    PlayerData = data
end)

RegisterNetEvent('mh-communityservice:client:opencomserv')
AddEventHandler('mh-communityservice:client:opencomserv', function(source)
	local comserv_menu = exports["qb-input"]:ShowInput({
		header = "Community Service",
		submitText = "Sent to Comm-Serv",
		inputs = {
			{
				text = "Citizen ID",
				name = "id",
				type = "number",
				isRequired = true
			},
			{
				text = "How many (Actions)",
				name = "amount",
				type = "number",
				isRequired = true
			},
		}
	})
	if comserv_menu then
		if not comserv_menu.id or not comserv_menu.amount then
			return
		else
			TriggerServerEvent('mh-communityservice:sendToCommunityService', tonumber(comserv_menu.id), tonumber(comserv_menu.amount))
		end
	end
end)

RegisterNetEvent('mh-communityservice:inCommunityService')
AddEventHandler('mh-communityservice:inCommunityService', function(actions_remaining)
	local playerPed = PlayerPedId()
	if isSentenced then return end
	actionsRemaining = actions_remaining
	FillActionTable()
	print(":: Available Actions: " .. #availableActions)
	ApplyPrisonerSkin()
	SetEntityCoords(playerPed, Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z, false, false, false, true)

	isSentenced = true
	communityServiceFinished = false
	while actionsRemaining > 0 and communityServiceFinished ~= true do
		if IsPedInAnyVehicle(playerPed, false) then
			ClearPedTasksImmediately(playerPed)
		end
		Citizen.Wait(20000)
		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z) > 45 then
			SetEntityCoords(playerPed, Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z, false, false, false, true)
			TriggerServerEvent('mh-communityservice:extendService')
			actionsRemaining = actionsRemaining + Config.ServiceExtensionOnEscape
			QBCore.Functions.Notify(Lang:t('info.escape_attempt',{amount = Config.ServiceExtensionOnEscape}), 'error')
		end
	end
	TriggerServerEvent('mh-communityservice:finishCommunityService', -1)
	SetEntityCoords(playerPed, Config.ReleaseLocation.x, Config.ReleaseLocation.y, Config.ReleaseLocation.z, false, false, false, true)
	isSentenced = false
	TriggerServerEvent('qb-clothes:loadPlayerSkin')
end)

RegisterNetEvent('mh-communityservice:finishCommunityService')
AddEventHandler('mh-communityservice:finishCommunityService', function(source)
	communityServiceFinished = true
	isSentenced = false
	actionsRemaining = 0
end)

CreateThread(function()
	while true do
		:: start_over ::
		Citizen.Wait(1)
		if actionsRemaining > 0 and isSentenced then
			draw2dText( Lang:t('info.remaining_msg', {remaining = actionsRemaining} ), { 0.375, 0.955 } )
			DrawAvailableActions()
			DisableViolentActions()
			local pCoords = GetEntityCoords(PlayerPedId())
			for i = 1, #availableActions do
				local distance = GetDistanceBetweenCoords(pCoords, availableActions[i].coords, true)
				if distance < 1.5 then
					DisplayHelpText(Lang:t('info.press_to_start'))
					if (IsControlJustReleased(1, 38)) then
						tmp_action = availableActions[i]
						RemoveAction(tmp_action)
						FillActionTable(tmp_action)
						disable_actions = true
						TriggerServerEvent('mh-communityservice:completeService')
						actionsRemaining = actionsRemaining - 1
						if (tmp_action.type == "cleaning") then
							local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							local vassouspawn = CreateObject(GetHashKey(vassoumodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							local netid = ObjToNet(vassouspawn)
							RequestAnimDict("amb@world_human_janitor@male@idle_a")
							while not HasAnimDictLoaded("amb@world_human_janitor@male@idle_a") do
								Citizen.Wait(1000)
							end
							TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
							AttachEntityToEntity(vassouspawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
							vassour_net = netid
							SetTimeout(10000, function()
								disable_actions = false
								DetachEntity(NetToObj(vassour_net), 1, 1)
								DeleteEntity(NetToObj(vassour_net))
								vassour_net = nil
								ClearPedTasks(PlayerPedId())
							end)
						end

						if (tmp_action.type == "gardening") then
							local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							local spatulaspawn = CreateObject(GetHashKey(spatulamodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							local netid = ObjToNet(spatulaspawn)
							TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, false)
							AttachEntityToEntity(spatulaspawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,190.0,190.0,-50.0,1,1,0,1,0,1)
							spatula_net = netid
							SetTimeout(14000, function()
								disable_actions = false
								DetachEntity(NetToObj(spatula_net), 1, 1)
								DeleteEntity(NetToObj(spatula_net))
								spatula_net = nil
								ClearPedTasks(PlayerPedId())
							end)
						end
						goto start_over
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

CreateThread(function()
	while not LocalPlayer.state.isLoggedIn do Wait(10) end
	if LocalPlayer.state.isLoggedIn then
		Wait(2000) --Wait for mysql-async
		TriggerServerEvent('mh-communityservice:checkIfSentenced')
	end
end)

function RemoveAction(action)
	local action_pos = -1
	for i=1, #availableActions do
		if action.coords.x == availableActions[i].coords.x and action.coords.y == availableActions[i].coords.y and action.coords.z == availableActions[i].coords.z then
			action_pos = i
		end
	end
	if action_pos ~= -1 then
		table.remove(availableActions, action_pos)
	else
		print("User tried to remove an unavailable action")
	end
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawAvailableActions()
	for i = 1, #availableActions do
		--DrawMarker(21, Config.ServiceLocations[i].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, true, false, false, true)
		DrawMarker(20, availableActions[i].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
		--DrawMarker(20, Config.ServiceLocations[i].coords, -1, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 162, 250, 80, true, true, 2, 0, 0, 0, 0)
	end
end

function DisableViolentActions()
	local playerPed = PlayerPedId()
	if disable_actions == true then
		DisableAllControlActions(0)
	end
	RemoveAllPedWeapons(playerPed, true)
	DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
	DisablePlayerFiring(playerPed,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
    DisableControlAction(0, 106, true) -- Disable in-game mouse controls
    DisableControlAction(0, 140, true)
	DisableControlAction(0, 141, true)
	DisableControlAction(0, 142, true)
	if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
		SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
	end
	if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
		SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true) -- If they click it will set them to unarmed
	end
end

function ApplyPrisonerSkin()
	local playerPed = PlayerPedId()
	if DoesEntityExist(playerPed) then
		Citizen.CreateThread(function()
			local gender = QBCore.Functions.GetPlayerData().charinfo.gender
			if gender == 0 then
				TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms.male)
			else
				TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms.female)
			end
			SetPedArmour(playerPed, 0)
			ClearPedBloodDamage(playerPed)
			ResetPedVisibleDamage(playerPed)
			ClearPedLastWeaponDamage(playerPed)
			ResetPedMovementClipset(playerPed, 0)
		end)
	end
end

function draw2dText(text, pos)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(table.unpack(pos))
end
