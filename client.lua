local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

-- local pogoda = false

-- ZMIENNE --
local prox = 10.0 -- Sets the Default Voice Distance
local isTalking = false
local showDayss = true
local playerJoin = false
local moveHud = false

local ind = {l = false, r = false}


AddEventHandler("playerSpawned", function()
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        NetworkSetFriendlyFireOption(true) -- Enable Friendly Fire
        SetCanAttackFriendly(ped, true, true) -- Enable Friendly Fire
        SetMaxWantedLevel(0) -- Set Max Wanted Level to 0
        --SetCreateRandomCops(0) -- Prevent AI Cop Creation
        --SetCreateRandomCopsNotOnScenarios(0) -- Prevent AI Cop Creation
        --SetCreateRandomCopsOnScenarios(0) -- Prevent AI Cop Creation
        SetPlayerHealthRechargeLimit(PlayerId(), 0) -- Disable Health Recharge
        SetPedSuffersCriticalHits(ped, false) -- Disable Critical Hits
        SetPedMinGroundTimeForStungun(ped, 6000) -- Time spent on ground after being tased (in ms)
        SetPedConfigFlag(ped, 184, true) -- Disable Seat Shuffle
        SetPedConfigFlag(ped, 35, false) -- Disable Automatic Bike Helmet
    end)
end)


 



local PlayerData              = {}

Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
 	PlayerData = ESX.GetPlayerData()
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)



RegisterCommand('record', function()
    StartRecording(1)
end)


RegisterCommand('save', function()
StopRecordingAndSaveClip()
end)

RegisterCommand('cancel', function()
    StopRecordingAndDiscardClip()
end)











Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		if isTalking == false then
			if NetworkIsPlayerTalking(PlayerId()) then
				isTalking = true
				SendNUIMessage({action = "setTalking", value = true})
			end
		else
			if NetworkIsPlayerTalking(PlayerId()) == false then
				isTalking = false
				SendNUIMessage({action = "setTalking", value = false})
			end
		end
	end
end)









RegisterKeyMapping('+bigmap', 'Duża minimapa w pojeździe', 'keyboard', 'LSHIFT')
RegisterCommand('+bigmap', function()
if IsPedInAnyVehicle(PlayerPedId()) then
SetBigmapActive(true)
end
end)

RegisterCommand('-bigmap', function()
SetBigmapActive(false)
end)

local useMph = false -- if false, it will display speed in kph
local wlaczony = false
RegisterKeyMapping('+tempomat', 'Tempomat', 'keyboard', 'F10')

local resetSpeedOnEnter 
RegisterCommand('+tempomat', function()
local playerPed = PlayerPedId()
local vehicle = GetVehiclePedIsIn(playerPed,false)
if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then
if  GetVehicleClass(vehicle) ~= 13 and GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 13 then
	if wlaczony == true  then
		resetSpeedOnEnter = true
		maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
SetEntityMaxSpeed(vehicle, maxSpeed)
exports.pNotify:SendNotification({text = "Tempomat wyłączony", type = "info", layout = "centerLeft", queue = "gej", timeout = 3000})
wlaczony = false
else
	cruise = GetEntitySpeed(vehicle)
SetEntityMaxSpeed(vehicle, cruise)
cruise = math.floor(cruise * 2.23694 + 0.5)
resetSpeedOnEnter = false
exports.pNotify:SendNotification({text = "Tempomat ustawiony na "..cruise.." mph </br> Naciśnij ponownie aby wyłączyć", type = "info", layout = "centerLeft", queue = "gej", timeout = 3000})
 Citizen.Wait(1000)
 wlaczony = true
	end
end
else
	resetSpeedOnEnter = true
end
end)






Citizen.CreateThread(function()
local resetSpeedOnEnter = true
while true do
local time = 1500
local playerPed = PlayerPedId()
local vehicle = GetVehiclePedIsIn(playerPed,false)
-- This should only happen on vehicle first entry to disable any old values
if vehicle ~= nil then
if resetSpeedOnEnter then
maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
SetEntityMaxSpeed(vehicle, maxSpeed)
resetSpeedOnEnter = false
else
end
end
Citizen.Wait(time)
end
end)


local ind = {l = false, r = false}
--[[ KIERUNKOWSKAZY LEWO PRAWO
Citizen.CreateThread(function()
	while true do
		local time = 1000
		if IsPedSittingInAnyVehicle(PlayerPedId()) then
			if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
				time = 5
				if IsControlJustPressed(1, 190) then -- l
					ind.l = not ind.l
					SetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()), 0, ind.l)
				end
				if IsControlJustPressed(1, 189) then --r
					ind.r = not ind.r
					SetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()), 1, ind.r)
				end
			end
		end
		Citizen.Wait(time)
	end
end) --]]



function GetPlayers()
    local players = {}

    for i = 0, 256 do -- jeśli 64 sloty 255;
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end


-- TE POJEBANE NAPISY OBOK VOICE --
-- LOKALIZACJA --
local zones = { ['AIRP'] = "Lotnisko LS", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "Klub Golfowy", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port LS", ['ZQ_UAR'] = "Davis Quartz" }
local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', }
local streetText = ''
-- local pogodaHash = ''

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local pos = GetEntityCoords(PlayerPedId())
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		local current_zone = zones[GetNameOfZone(pos.x, pos.y, pos.z)]

		for k,v in pairs(directions)do
			direction = GetEntityHeading(PlayerPedId())
			if(math.abs(direction - k) < 22.5)then
				direction = v
				break;
			end
		end

		if(GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z)) then
			if(zones[GetNameOfZone(pos.x, pos.y, pos.z)] and tostring(GetStreetNameFromHashKey(var1))) then
				streetText = direction..' | '..tostring(GetStreetNameFromHashKey(var1))
				SendNUIMessage({
					showStreet = true,
					locationn = streetText
				})
			end
		end
	end
end)



local toggle = false
RegisterCommand('+hud', function()
	toggle = not toggle
	TriggerEvent('esx_society:toggleSocietyHud', not toggle)
	if toggle then
	  SendNUIMessage({
			wylaczhud = true
		})
	else
		SendNUIMessage({
			wylaczhud = false
		})
	end
  end, false)
  
  RegisterKeyMapping('+hud', 'HUD Toggle', 'keyboard', 'F9')



    
  RegisterKeyMapping('+hud', 'Przełączanie HUD~', 'keyboard', 'F9')


  function DisabledHUD()
	return toggle
  end

  exports('DisabledHUD', DisabledHUD)
  

-- LICZNIK VLIFE 2.0 --

Citizen.CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local time = 1000
		if(IsPedInAnyVehicle(Ped)) then
			time = 200
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar  then

				-- Speed
				carSpeed = math.ceil(GetEntitySpeed(PedCar) * 2.23694)
				SendNUIMessage({
					showhud = true,
					speed = carSpeed
				})



			else
				SendNUIMessage({
					showhud = false
				})
			end
		else
			SendNUIMessage({
				showhud = false
			})
		end

		Citizen.Wait(time)
	end
end)

-- WAŻNE STATYSTYKI KURWA --

Citizen.CreateThread(function()
	while true do
		local czas = 2500
		local ped = PlayerPedId()
     	local health = GetEntityHealth(ped) - 100
		 local armor = GetPedArmour(ped)
		 local vehicle = GetVehiclePedIsIn(ped)
		 local lockStatus = GetVehicleDoorLockStatus(vehicle)
		 if IsPedInAnyVehicle(ped) then
		 	czas = 1000
			local fuel =  GetVehicleFuelLevel(GetVehiclePedIsIn(ped))
			local car =  GetVehicleEngineHealth(GetVehiclePedIsIn(ped)) / 10

     		if GetVehicleClass(vehicle) == 8 then
     			SetPedHelmet(ped, false)
     			RemovePedHelmet(ped, true)
			
        SetPedConfigFlag(ped, 35, false) -- Disable Automatic Bike Helmet
     		end
			SendNUIMessage({action = "updateCar", value = car})
			SendNUIMessage({action = "updateFuel", value = fuel})
			if GetIsVehicleEngineRunning(vehicle) == false then
				SendNUIMessage({action = "engineSwitch", status = false})
			else
				SendNUIMessage({action = "engineSwitch", status = true})
			end
			if lockStatus == 1 then
				SendNUIMessage({action = "unlocked", value = true})
			elseif lockStatus == 2 then
				SendNUIMessage({action = "unlocked", value = false})
			end
         end
         Citizen.Wait(czas)
	end
end)
local voiceCoords = 6.0
RegisterNetEvent('esx_customui:talking')
AddEventHandler('esx_customui:talking', function(prox, coords)
    SendNUIMessage({action = "setProximity", value = prox})
	voiceCoords = coords
end)

function CurrentVoiceCoords()

return voiceCoords
end

exports('CurrentVoiceCoords', CurrentVoiceCoords)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local ped = PlayerPedId()
		 if not IsPedInAnyVehicle(ped) then
			SendNUIMessage({action = "hideFuel"})
			SendNUIMessage({action = "hideLock"})
		 else
			SendNUIMessage({action = "showFuel"})
			SendNUIMessage({action = "showLock"})
         end
         if GetPedArmour(ped) > 0 then
            SendNUIMessage({action = "showArmor"})
            local ped = PlayerPedId()
         local armor = GetPedArmour(ped)
            SendNUIMessage({action = "updateArmor", value = armor})
         else
            SendNUIMessage({action = "hideArmor"})
         end
            if IsPedSwimmingUnderWater(PlayerPedId())then
            local ped = PlayerPedId()
        	local water = math.ceil(GetPlayerUnderwaterTimeRemaining(PlayerId())) * 4
        	SendNUIMessage({action = "showWater"})
        	SendNUIMessage({action = "updateWater", value = water})
            SendNUIMessage({action = "showWater", value = water})
         else
            SendNUIMessage({action = "hideWater"})
         end
	end
end)

-- DZIEŃ I GODZINA --
local dayText = ''

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		local dayInt = GetClockDayOfWeek()
		local day = ''

		if dayInt == 0 then
			day = 'Niedziela'
		elseif dayInt == 1 then
			day = 'Poniedziałek'
		elseif dayInt == 2 then
			day = 'Wtorek'
		elseif dayInt == 3 then
			day = 'Środa'
		elseif dayInt == 4 then
			day = 'Czwartek'
		elseif dayInt == 5 then
			day = 'Piątek'
		elseif dayInt == 6 then
			day = 'Sobota'
		end

		local hourInt = GetClockHours()
		local hour = ''
		if string.len(tostring(hourInt)) == 1 then
			hour = '0'..hourInt
		else
			hour = hourInt
		end

		local minuteInt = GetClockMinutes()
		local minute = ''
		if string.len(tostring(minuteInt)) == 1 then
			minute = '0'..minuteInt
		else
			minute = minuteInt
		end

			dayText = hour..':'..minute..' | '..day

		SendNUIMessage({
			showDay = true,
			days = dayText
		})
	end
end)





function TurnRadar(on)

	if on then
		if moveHud == false then
			moveHud = true
			SendNUIMessage({
				action = "moveHudd",
				show = true
			})
		end
    if not toggle then
      DisplayRadar(true)
      end
	else
		if moveHud == true then
			moveHud = false
			SendNUIMessage({
				action = "moveHudd",
				show = false
			})
		end
    if not toggle then
		DisplayRadar(false)
    end
	end
  if toggle then
    DisplayRadar(false)
  end
end


RegisterNetEvent('hud:moveUI')
AddEventHandler('hud:moveUI', function(czas)
SendNUIMessage({
                action = "moveHudd",
                show = true
            })
Citizen.Wait(czas)
SendNUIMessage({
                action = "moveHudd",
                show = false
            })

end)
