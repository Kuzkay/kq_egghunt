if Config.qbSettings.enabled then

    if Config.qbSettings.useNewQBExport then
        QBCore = exports['qb-core']:GetCoreObject()
    end

    function AddPlayerMoney(player, amount, account)
        local xPlayer = QBCore.Functions.GetPlayer(player)

        if not xPlayer then
            return false
        end

        xPlayer.Functions.AddMoney(account or Config.qbSettings.moneyAccount, amount)
    end
    
    function RemovePlayerItem(player, item, amount)
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(player))
        xPlayer.Functions.RemoveItem(item, amount or 1)
    end

    function GetPlayerItemAmount(player, item)
        local xPlayer = QBCore.Functions.GetPlayer(player)

        return xPlayer.Functions.GetItemByName(item).amount or xPlayer.Functions.GetItemByName(item).count
    end
    
    function DoesPlayerHaveItem(player, item, amount)
        local xPlayer = QBCore.Functions.GetPlayer(player)

        return xPlayer.Functions.GetItemByName(item) and GetPlayerItemAmount(player, item) >= (amount or 1)
    end
end
