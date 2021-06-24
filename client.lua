local entity = 0

local FloatingHelpText = function(coords, text, sound, force)
	text:gsub('~.-~', '')
	AddTextEntry(GetCurrentResourceName(), text)
	BeginTextCommandDisplayHelp(GetCurrentResourceName())
	EndTextCommandDisplayHelp(2, false, false, -1)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
end

local RayCast = function(playerPed, playerCoords)
	local plyOffset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 2.0, 0.0)
	local ret, hit, coords, surfacenormal, entity = GetShapeTestResult(StartShapeTestRay(playerCoords.x, playerCoords.y, playerCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, -1, ESX.PlayerData.ped, 0))
	return hit, coords, entity
end

local Props = {}
local FindVendingMachine = function()
	while true do
		local sleep = 800
		local playerCoords = GetEntityCoords(ESX.PlayerData.ped)
		local result, coords, object = RayCast(ESX.PlayerData.ped, playerCoords)
		if object > 0 then
			if #(playerCoords - coords) < 1.5 then
				local hash = GetEntityModel(object)
				for k,v in pairs(Props) do
					if entity == 0 then
						if k == hash then
							local pos = GetEntityCoords(object)
							entity = object
							Citizen.CreateThread(function()
								while entity > 0 do
									playerCoords = GetEntityCoords(ESX.PlayerData.ped)
									local result, coords, object = RayCast(ESX.PlayerData.ped, playerCoords)
									if object ~= entity then entity = 0 end
									Citizen.Wait(100)
								end
							end)

							while entity > 0 do
								Citizen.Wait(5)
								if IsControlJustPressed(0, 38) then
									TriggerServerEvent('linden_vending:purchase', v)
									entity = 0
								end
								FloatingHelpText(vector3(pos.x, pos.y, coords.z), '~g~ E')
							end
							sleep = 20
						end
					end
				end
			else sleep = sleep - 400 end
		end
		Citizen.Wait(sleep)
	end
end

for k,v in pairs(Config.types) do
	for key,val in pairs(v) do
		Props[val] = k
	end
end

SetTimeout(500, FindVendingMachine)
