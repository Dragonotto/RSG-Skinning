local RSGCore = exports['rsg-core']:GetCoreObject()

local function CheckAnimalHash(pelthash, Config)
    local indices = {}
    for i, peltsEntry in ipairs(Config.Pelts) do
        local animalModelName = GetHashKey(peltsEntry.animalname)
        if pelthash == animalModelName then
            table.insert(indices, i)  -- Add the index of the matching animal to the list
        end
    end
    return indices
end

local function DeleteThis(holding)
    NetworkRequestControlOfEntity(holding)
    SetEntityAsMissionEntity(holding, true, true)
    Wait(100)
    DeleteEntity(holding)
    Wait(500)
    local entitycheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
    local holdingcheck = GetPedType(entitycheck)
    if holdingcheck == 0 then
        return true
    else
        return false
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        --local nearestAnimal = GetClosestEntity('CPed', 'dead', 'any', 'inlos', false, nil)
        local coords = GetEntityCoords(PlayerPedId())
        local nearestAnimal, distance = RSGCore.Functions.GetClosestPed(coords)
        if distance <= 3 then

        
            if nearestAnimal ~= -1 then
                local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
                local holdingpelt = GetEntityModel(holding)
                local pelthash = GetEntityModel(nearestAnimal)
                local animaloutfit = Citizen.InvokeNative(0x30569F348D126A5A, nearestAnimal)
                local debug = Config.Debug
                local checkedanimal_indices = CheckAnimalHash(pelthash, Config)

                if debug then
                    print("holding: " .. tostring(holding))
                    print("pelthash: " .. tostring(pelthash))
                    print("nearestDeadAnimal: " .. nearestAnimal)
                    print("animaloutfit1: " .. tostring(animaloutfit))
                    print("holdingpelt: " .. tostring(holdingpelt))
                    print("checkedanimal_index: " ..tostring(checkedanimal_index))
                    print("animalModelName: " ..tostring(animalModelName))
                end

                for _, checkedanimal_index in ipairs(checkedanimal_indices) do
                    local animalconfig = Config.Pelts[checkedanimal_index]
                    if holdingpelt == pelthash then
                        print("makesholding=pelt")
                        if holding ~= false then
                            if animalconfig.issmall then
                                print("makesismall")
                                if checkedanimal_index and animaloutfit == animalconfig.outfit then
                                    print('makescheckedanimal')
                                    local name = animalconfig.animallabel
                                    local rewarditem1 = animalconfig.rewarditem1
                                    local rewarditem2 = animalconfig.rewarditem2
                                    local rewarditem3 = animalconfig.rewarditem3
                                    Wait(2000)
                                    local deleted = DeleteThis(holding) and DeleteThis(nearestAnimal)
                                    
                                    if deleted and animalconfig.isbird then
                                        print("makesdelete")
                                        RSGCore.Functions.Notify(name .. ' Plucked', 'primary')
                                        TriggerServerEvent('d-skinning:server:storepelt', rewarditem1, rewarditem2, rewarditem3)
                                    else
                                        RSGCore.Functions.Notify(name .. ' Skinned', 'primary')
                                        TriggerServerEvent('d-skinning:server:storepelt', rewarditem1, rewarditem2, rewarditem3)
                                    end
                                end
                            end
                        end
                    elseif holdingpelt ~= pelthash then
                        if holding ~= false then
                            if checkedanimal_index then
                                if animaloutfit == animalconfig.outfit then
                                    local name = animalconfig.animallabel
                                    local rewarditem1 = animalconfig.rewarditem1
                                    local rewarditem2 = animalconfig.rewarditem2
                                    local rewarditem3 = animalconfig.rewarditem3
                                    Wait(1000)
                                    local deleted = DeleteThis(holding) and DeleteThis(nearestAnimal)
                                    
                                    if deleted and animalconfig.isbird then
                                        RSGCore.Functions.Notify(name .. ' Plucked', 'primary')
                                        TriggerServerEvent('d-skinning:server:storepelt', rewarditem1, rewarditem2, rewarditem3)
                                    else
                                        RSGCore.Functions.Notify(name .. ' Skinned', 'primary')
                                        TriggerServerEvent('d-skinning:server:storepelt', rewarditem1, rewarditem2, rewarditem3)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)



---Trapper


local model = 'amsp_robsdgunsmith_males_01'

while not HasModelLoaded(model) do
    Wait(1)
    RequestModel(model)
end

butcherped = CreatePed(model, -3842.74, -3475.16, 58.34, - 1.0, 100, true, false, 0, 0)
Citizen.InvokeNative(0x283978A15512B2FE, butcherped, true)
FreezeEntityPosition(butcherped, true)
SetEntityInvincible(butcherped, true)
SetBlockingOfNonTemporaryEvents(butcherped, true)
Citizen.InvokeNative(0x24C82EF607105FAA, butcherped, timid)
Wait(1)


exports['rsg-target']:AddTargetEntity(butcherped, {
    options = {
        {
            label = 'Sell Animal',
            icon = 'fas fa-dollars',
            action = function()
                TriggerEvent('d-skinning:client:sellAnimal')
                print('sellanimal')
            end
        },
        {
            label = 'Menu',
            icon = 'fas fa-dollars',
            action = function()
                TriggerEvent('d-skinning:client:menu')
            end
        }
    }
})


RegisterNetEvent('d-skinning:client:sellAnimal')
AddEventHandler('d-skinning:client:sellAnimal', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local nearestAnimal, distance = RSGCore.Functions.GetClosestPed(coords)
    local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
    local holdingpelt = GetEntityModel(holding)
    local pelthash = GetEntityModel(nearestAnimal)
    local animaloutfit = Citizen.InvokeNative(0x30569F348D126A5A, nearestAnimal)
    local debug = Config.Debug
    local checkedanimal_indices = CheckAnimalHash(pelthash, Config)

    if debug then
        print("holding: " .. tostring(holding))
        print("pelthash: " .. tostring(pelthash))
        print("nearestDeadAnimal: " .. nearestAnimal)
        print("animaloutfit1: " .. tostring(animaloutfit))
        print("holdingpelt: " .. tostring(holdingpelt))
        print("checkedanimal_index: " ..tostring(checkedanimal_index))
        print("animalModelName: " ..tostring(animalModelName))
    end

    for _, checkedanimal_index in ipairs(checkedanimal_indices) do
        local animalconfig = Config.Pelts[checkedanimal_index]
        if checkedanimal_index and animaloutfit == animalconfig.outfit then
            print('makescheckedanimal')
            local name = animalconfig.animallabel
            local amountPaid = animalconfig.price
            local deleted = DeleteThis(holding) and DeleteThis(nearestAnimal)
            
            if deleted then
                print("sold")
                TriggerServerEvent('d-skinning:server:sellReward')
            end
        end
    end
end)


RegisterNetEvent('d-skinning:client:menu', function()
    local MenuTelegram = {
        {
            title = "Bulk Goods",
            icon = "fa-solid fa-book",
            description = 'Sell Bulk Items',
            event = "d-skinning:client:bulkgoods",
            args = {}
        },
        {
            title = "Read Messages",
            icon = "fa-solid fa-file-contract",
            description = 'Read my messages',
            event = "rsg-telegram:client:ReadMessages",
            args = {}
        },
        {
            title = "Send Messages",
            icon = "fa-solid fa-pen-to-square",
            description = 'Send a telegram to another player',
            event = "rsg-telegram:client:WriteMessagePostOffice",
            args = {}
        },
    }
    lib.registerContext({
        id = "butcher_menu",
        title = "Butcher Menu",
        options = MenuTelegram
    })
    lib.showContext("butcher_menu")
end)


RegisterNetEvent('d-skinning:client:bulkgoods')
AddEventHandler('d-skinning:client:bulkgoods', function()
    local src = source
    local totalPayment = 0
    local playerItems = {}
    for _, item in pairs(Config.Bulkitems) do
        local itemName = item.name
        local itemPrice = item.price
        print(itemName, itemPrice)
        print("source:" .. tostring(src))
        
        if RSGCore.Functions.HasItem(itemName) then
            -- Retrieve the item from the player's inventory
            local itemInfo = GetItemsByName(src, itemName)
            
            
            if itemInfo then
                local itemCount = itemInfo.amount  -- Retrieve the amount of the item

                -- Add the item and its quantity to the playerItems table
                playerItems[itemName] = itemCount
                
                -- Calculate the total price for this item and add it to the total payment
                local itemTotalPrice = itemCount * itemPrice
                totalPayment = totalPayment + itemTotalPrice
            end
        else
            --RSGCore.Functions.Notify('You don\'t have ' .. RSGCore.Shared.Items[itemName].label .. '!', 'error', 3000)
        end
    end

    -- If the player has sold any items
    if totalPayment > 0 then
        -- Pay the total price back to the player
        RSGCore.Functions.Notify('You sold bulk goods for $' .. totalPayment, 'success')
        -- Optionally, you can trigger a server event to log the transaction or perform other actions
    else
        -- Notify the player that they have no items to sell
        RSGCore.Functions.Notify('You don\'t have any items to sell!', 'error', 3000)
    end
end)
