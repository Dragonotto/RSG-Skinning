RSGCore = exports['rsg-core']:GetCoreObject()

RegisterNetEvent('d-skinning:server:storepelt')
AddEventHandler('d-skinning:server:storepelt', function(rewarditem1, rewarditem2, rewarditem3)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if rewarditem1 ~= false then
        Player.Functions.AddItem(rewarditem1, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[rewarditem1], "add")
    end
    if rewarditem2 ~= false then
        Player.Functions.AddItem(rewarditem2, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[rewarditem2], "add")
    end
    if rewarditem3 ~= false then
        Player.Functions.AddItem(rewarditem3, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[rewarditem3], "add")
    end
end)


RegisterNetEvent('d-skinning:server:sellReward')
AddEventHandler('d-skinning:server:sellReward', function(amountPaid)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', 10)
end)


RegisterServerEvent('d-skinning:server:bulkgoods')
AddEventHandler('d-skinning:server:bulkgoods', function(playerItems, totalPayment)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    for itemName, itemCount in pairs(playerItems) do
        RSGCore.Functions.RemoveItem(itemName, itemCount)
    end

    Player.Functions.RemoveItem(itemName, itemCount)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'remove')
    Player.Functions.AddMoney('cash', itemPrice * itemCount)
end)