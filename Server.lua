local QBCore = exports['qbx_core']:GetCoreObject()

-- Collect bin payment
RegisterServerEvent('garbage:collectBin')
AddEventHandler('garbage:collectBin', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    if Config.PaymentMethod == 'cash' or Config.PaymentMethod == 'both' then
        Player.Functions.AddMoney('cash', amount)
    end
    
    if Config.PaymentMethod == 'bank' or Config.PaymentMethod == 'both' then
        Player.Functions.AddMoney('bank', amount)
    end
    
    if Config.Debug then
        print('^2[GarbageJob]^7 Player ' .. Player.PlayerData.charinfo.firstname .. ' collected $' .. amount)
    end
end)

-- Complete route payment
RegisterServerEvent('garbage:completeRoute')
AddEventHandler('garbage:completeRoute', function(bonus)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    if Config.PaymentMethod == 'cash' or Config.PaymentMethod == 'both' then
        Player.Functions.AddMoney('cash', bonus)
    end
    
    if Config.PaymentMethod == 'bank' or Config.PaymentMethod == 'both' then
        Player.Functions.AddMoney('bank', bonus)
    end
    
    if Config.Debug then
        print('^2[GarbageJob]^7 Player ' .. Player.PlayerData.charinfo.firstname .. ' completed route and earned $' .. bonus)
    end
end)

-- Player left event - cleanup
AddEventHandler('playerDropped', function(reason)
    local src = source
    -- Cleanup if needed
end)
