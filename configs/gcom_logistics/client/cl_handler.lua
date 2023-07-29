local interiorId = GetInteriorAtCoords(Config['logistics'].InteriorCoords.x, Config['logistics'].InteriorCoords.y, Config['logistics'].InteriorCoords.z)
local lastIpl

RegisterNetEvent('SyncLastIpl')
AddEventHandler('SyncLastIpl', function(ipl)
    if lastIpl and lastIpl ~= ipl then
        UnloadGarageEntities(lastIpl)
    end
    lastIpl = ipl
    LoadGarageEntities()
end)

Citizen.CreateThread(function()
    local resource = GetCurrentResourceName()
    local lastIplFile = LoadResourceFile(resource, 'last_ipl.json')
    if lastIplFile then
        SaveResourceFile(resource, 'last_ipl.json', '{"logistics-lastIpl": "'..Config['logistics'].DefaultEntitySet..'"}', -1)
    end

    TriggerServerEvent('RequestLastIpl')
end)


RegisterNetEvent('ManLoadGarageEntities')
AddEventHandler('ManLoadGarageEntities', function(ipl)
    RequestIpl(ipl)
    if interiorId ~= 0 then
        ActivateInteriorEntitySet(interiorId, ipl)
        RefreshInterior(interiorId)
    else
        print("Interior not found at specified coordinates.")
    end
end)

RegisterNetEvent('UnLoadGarageEntities')
AddEventHandler('UnLoadGarageEntities', function(ipl)
    UnloadGarageEntities(ipl)
end)

function LoadGarageEntities()
    RequestIpl(lastIpl or GetDefaultIpl())
    if interiorId ~= 0 then
        ActivateInteriorEntitySet(interiorId, lastIpl or GetDefaultIpl())
        RefreshInterior(interiorId)
    else
        print("Interior not found at specified coordinates.")
    end
end

function UnloadGarageEntities(ipl)
    if interiorId ~= 0 then
        RemoveIpl(ipl)
        DeactivateInteriorEntitySet(interiorId, ipl)
        RefreshInterior(interiorId)
    else
        print("Interior not found at specified coordinates.")
    end
end
