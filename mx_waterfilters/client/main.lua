local lista_filtros = {
	{prop = "prop_watercooler"},
	{prop = "prop_watercooler_dark"},
}

local waitAnim = false
RegisterCommand(''..'mxWaterFiltersKey_E', function()
    if not waitAnim then
        local ped = PlayerPedId()
        if #lista_filtros > 0 then
            local pos = GetEntityCoords(ped)
            for k,v in pairs(lista_filtros) do
                local ent, min = GetClosestObject(v.prop)
                if DoesEntityExist(ent) then
                    if min < 1.5 then
                        TriggerServerEvent("mxWaterFilters:checkPlayer")
                    end
                end
            end
        end
    end
end, false)
RegisterKeyMapping(''..'mxWaterFiltersKey_E', ''..'mxWaterFiltersKey_E', 'keyboard', 'e')

RegisterNetEvent("mxWaterFilters:actionPermiss", function()
    waitAnim = true

    local ped = PlayerPedId()
    PlayAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
    TaskPlayAnim(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer", 8.0, 8.0, -1, 31, 0, false, false, false)

    SetTimeout(3000, function()
        TriggerServerEvent("mxWaterFilters:giveWaterBottle")
        ClearPedTasks(ped)
        waitAnim = false
    end)
end)

function PlayAnim(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end

function GetClosestObject(model)
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)

    local hash = nil
    local objects = GetGamePool('CObject')
    
    local min = 9999.0
    local closest = -1

    if model then
        hash = GetHashKey(model)
    end        

    for i,k in pairs(objects) do
        local ent_coords = GetEntityCoords(k)

        local dist = #(ent_coords - coords)

        if dist < min then
            local obj_hash = GetEntityModel(k)

            if not hash or obj_hash == hash then
                min = dist
                closest = k
            end
        end
    end

    return closest, min
end