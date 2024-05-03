if Config.FRAMEWORK == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.FRAMEWORK == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterNetEvent("mxWaterFilters:checkPlayer", function()
    local src = source
    local player, license = dataFramework(src)

    if Config.FRAMEWORK == 'ESX' then
        if player.hasItem(Config.ITEM_WATER_BOTTLE_EMPTY) then
            TriggerClientEvent("mxWaterFilters:actionPermiss", src)
        else
            player.showNotification(translate.NO_HAVE_WATER_BOTTLE_EMPTY, 'error')
        end
    elseif Config.FRAMEWORK == 'QBCore' then
        local itemName = ''
        for i , k in pairs(player.Functions.GetItemsByName(Config.ITEM_WATER_BOTTLE_EMPTY)) do
            itemName = k.name
        end

        if itemName ~= '' then
            TriggerClientEvent("mxWaterFilters:actionPermiss", src)
        else
            TriggerClientEvent('QBCore:Notify', src, translate.NO_HAVE_WATER_BOTTLE_EMPTY, 'error', 3000)
        end
    end
end)

RegisterNetEvent("mxWaterFilters:giveWaterBottle", function()
    local src = source
    local player, license = dataFramework(src)

    if hasWeight(src, Config.ITEM_WATER_BOTTLE, 1) then
        if Config.FRAMEWORK == 'ESX' then
            player.removeInventoryItem(Config.ITEM_WATER_BOTTLE_EMPTY, 1)
            player.addInventoryItem(Config.ITEM_WATER_BOTTLE, 1)
        elseif Config.FRAMEWORK == 'QBCore' then
            TriggerClientEvent('QBCore:Notify', src, translate.RECEIVED_WATER_BOTTLE, 'success', 3000)
            player.Functions.RemoveItem(Config.ITEM_WATER_BOTTLE_EMPTY, 1)
        end
    else
        if Config.FRAMEWORK == 'ESX' then
            player.showNotification(translate.NO_WEIGHT, 'error')
        elseif Config.FRAMEWORK == 'QBCore' then
            TriggerClientEvent('QBCore:Notify', src, translate.NO_WEIGHT, 'error', 3000)
        end
    end
end)

function hasWeight(src, item, qty)
    if Config.FRAMEWORK == 'ESX' then
        if Config.ESX_FINAL and checkWeightEsxFinal(src, item, qty) then
            return true
        elseif not Config.ESX_FINAL and checkWeight(src, item, qty) then
            return true
        end
    elseif Config.FRAMEWORK == 'QBCore' then
        if canCarryItemQBCore(src, item, qty) then
            return true
        end
    end
    return false
end

-- Somente QBCore
function canCarryItemQBCore(src, item, _amount)
    local xPlayer = QBCore.Functions.GetPlayer(src)
    return xPlayer.Functions.AddItem(item, _amount)
end

-- Somente Esx
-- Check if the player has weight
function checkWeightEsxFinal(src, item, amount)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        return xPlayer.canCarryItem(item, amount)
    end 
end

-- Check if the player has limit
function checkWeight(src, item, amount)
    local xPlayer = ESX.GetPlayerFromId(src)
    local targetItem = xPlayer.getInventoryItem(item)

    if amount > 0 then
        if targetItem then
            if targetItem.limit ~= -1 and (targetItem.count + amount) > targetItem.limit then
                return false
            else
                return true
            end
        else
            return true
        end
    end
    return false
end

function dataFramework(src)
    local player = 0
    local identifier = 0
    
    if Config.FRAMEWORK == "QBCore" then
        player = QBCore.Functions.GetPlayer(src)
        identifier = player.PlayerData.citizenid 
    elseif Config.FRAMEWORK == "ESX" then
        player = ESX.GetPlayerFromId(src)
        identifier = player.getIdentifier()
    end
    return player, identifier
end

function GetLicenseFiveM(source)
    local licenca = GetPlayerIdentifiers(source)
    for _, v in pairs(licenca) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            licenca = v
            break
        end
    end 
    return licenca
end