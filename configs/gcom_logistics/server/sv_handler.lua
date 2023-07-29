local lastIpl

function GetLastIpl()
    local data = LoadLastIplData()
    if data and data['logistics-lastIpl'] then
        return data['logistics-lastIpl']
    else
        return Config['logistics'].DefaultEntitySet
    end
end

function SetLastIpl(ipl)
    local data = { ['logistics-lastIpl'] = ipl }
    SaveLastIplData(data)
end

function LoadLastIplData()
    local data = LoadResourceFile(GetCurrentResourceName(), 'last_ipl.json')
    if data then
        return json.decode(data)
    else
        return nil
    end
end

function SaveLastIplData(data)
    SaveResourceFile(GetCurrentResourceName(), 'last_ipl.json', json.encode(data), -1)
end

RegisterServerEvent('RequestLastIpl')
AddEventHandler('RequestLastIpl', function()
    local lastIpl = GetLastIpl()
    TriggerClientEvent('SyncLastIpl', source, lastIpl)
end)

function TriggerManLoadGarageEntities(ipl)
    TriggerClientEvent("ManLoadGarageEntities", -1, ipl)
end

function TriggerUnLoadGarageEntities(ipl)
    TriggerClientEvent("UnLoadGarageEntities", -1, ipl)
end

RegisterNetEvent('SyncEnableUsers')
AddEventHandler('SyncEnableUsers', function(ipl)
    if lastIpl and lastIpl ~= ipl then
        TriggerUnLoadGarageEntities(lastIpl)
    end
    lastIpl = ipl
    SetLastIpl(lastIpl)
    TriggerManLoadGarageEntities(ipl)
end)

RegisterNetEvent('SyncDisableUsers')
AddEventHandler('SyncDisableUsers', function()
    if lastIpl and lastIpl ~= Config['logistics'].DefaultEntitySet then
        TriggerUnLoadGarageEntities(lastIpl)
        lastIpl = Config['logistics'].DefaultEntitySet
        SetLastIpl(lastIpl)
    end
end)

RegisterCommand(Config['logistics'].ComamndName, function(source, args, raw)
    local iplName = Config['logistics'].EntitySetBaseName .. args[1]
    TriggerEvent("SyncDisableUsers")
    TriggerEvent("SyncEnableUsers", iplName)
end, false)
