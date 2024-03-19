if Config.esxSettings.enabled then
    ESX = nil

    if Config.esxSettings.useNewESXExport then
        ESX = exports['es_extended']:getSharedObject()
    else
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end

    function AddPlayerMoney(player, amount, account)
        local xPlayer = ESX.GetPlayerFromId(player)
        if not xPlayer then
            return false
        end

        xPlayer.addAccountMoney(account or Config.esxSettings.moneyAccount, amount)
    end

    function RemovePlayerItem(player, item, amount)
        local xPlayer = ESX.GetPlayerFromId(tonumber(player))
        xPlayer.removeInventoryItem(item, amount or 1)
    end

    function GetPlayerItemAmount(player, item)
        local xPlayer = ESX.GetPlayerFromId(player)

        return xPlayer.getInventoryItem(item).count or xPlayer.getInventoryItem(item).amount
    end
    
    function DoesPlayerHaveItem(player, item, amount)
        return GetPlayerItemAmount(player, item) >= (amount or 1)
    end
end
