local QBCore = exports['qbx_core']:GetCoreObject()
local Utils = require('client.utils')

local jobActive = false
local currentRoute = nil
local currentBin = 1
local garbageTruck = nil
local routeBlips = {}
local inProgress = false

-- Start garbage job
local function startGarbageJob(routeId)
    if jobActive then
        Utils.notify('Garbage Job', 'You already have an active garbage job!', 'error')
        return
    end
    
    if not Config.Routes[routeId] then
        Utils.notify('Garbage Job', 'Invalid route ID!', 'error')
        return
    end
    
    jobActive = true
    currentRoute = Config.Routes[routeId]
    currentBin = 1
    inProgress = false
    
    -- Spawn vehicle
    garbageTruck = Utils.spawnVehicle(Config.VehicleModel, Config.VehicleSpawn, Config.VehicleHeading)
    
    if not garbageTruck then
        Utils.notify('Garbage Job', 'Failed to spawn truck!', 'error')
        jobActive = false
        return
    end
    
    -- Set player into vehicle
    local ped = PlayerPedId()
    TaskWarpPedIntoVehicle(ped, garbageTruck, -1)
    
    Utils.notify('Garbage Job', 'Route started: ' .. currentRoute.name .. ' (' .. #currentRoute.bins .. ' bins)', 'success')
    
    -- Create blips for route
    for i, bin in ipairs(currentRoute.bins) do
        local blip = Utils.createBlip(vector3(bin.x, bin.y, bin.z), Config.BlipSprite, Config.BlipColor, Config.BlipScale, 'Bin #' .. i)
        table.insert(routeBlips, blip)
    end
end

-- Stop garbage job
local function stopGarbageJob()
    if not jobActive then
        Utils.notify('Garbage Job', 'No active garbage job!', 'error')
        return
    end
    
    jobActive = false
    currentRoute = nil
    currentBin = 1
    inProgress = false
    
    -- Remove vehicle
    if garbageTruck then
        Utils.deleteVehicle(garbageTruck)
        garbageTruck = nil
    end
    
    -- Remove blips
    for _, blip in ipairs(routeBlips) do
        Utils.removeBlip(blip)
    end
    routeBlips = {}
    
    Utils.notify('Garbage Job', 'Route ended!', 'info')
end

-- Check if job is active
local function isJobActive()
    return jobActive
end

-- Collect garbage at bin
local function collectGarbage(binIndex)
    if inProgress then
        Utils.notify('Garbage Job', 'Already collecting garbage!', 'error')
        return
    end
    
    inProgress = true
    local ped = PlayerPedId()
    
    -- Play collection animation
    Utils.playAnim(Config.AnimDict, Config.AnimName, Config.CollectionDuration)
    
    -- Show progress
    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < Config.CollectionDuration do
        Wait(100)
        DrawText3D(GetEntityCoords(ped), 'Collecting garbage...')
    end
    
    inProgress = false
    Utils.notify('Garbage Job', 'Collected bin #' .. binIndex, 'success')
    
    -- Trigger server event for payment
    TriggerServerEvent('garbage:collectBin', Config.PayPerBin)
end

-- Main job loop
Citizen.CreateThread(function()
    while true do
        Wait(100)
        
        if jobActive and currentRoute then
            local playerCoords = Utils.getPlayerCoords()
            local bin = currentRoute.bins[currentBin]
            local binCoords = vector3(bin.x, bin.y, bin.z)
            local distance = Utils.distance(playerCoords, binCoords)
            
            if distance < Config.CollectionDistance then
                -- Draw prompt
                DrawText3D(bin.x, bin.y, bin.z, '[~g~E~s~] Collect Garbage')
                
                if IsControlJustReleased(0, 38) then  -- E key
                    collectGarbage(currentBin)
                    
                    -- Move to next bin
                    if currentBin < #currentRoute.bins then
                        currentBin = currentBin + 1
                    else
                        -- Route complete
                        TriggerServerEvent('garbage:completeRoute', Config.RouteBonus)
                        Utils.notify('Garbage Job', 'Route completed! Earned $' .. Config.RouteBonus .. ' bonus!', 'success')
                        stopGarbageJob()
                    end
                end
            end
        end
    end
end)

-- Helper function to draw 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        BeginTextCommandDisplayText('STRING')
        SetTextFont(4)
        SetTextScale(0.0, 0.35)
        SetTextColour(255, 255, 255, 215)
        AddTextComponentString(text)
        DrawText(_x - GetTextWidth(text) * 0.5, _y)
    end
end

-- Commands
RegisterCommand('startgarbage', function(source, args, rawCommand)
    local routeId = tonumber(args[1]) or 1
    startGarbageJob(routeId)
end, false)

RegisterCommand('stopgarbage', function(source, args, rawCommand)
    stopGarbageJob()
end, false)

-- Exports
exports('startGarbageJob', startGarbageJob)
exports('stopGarbageJob', stopGarbageJob)
exports('isJobActive', isJobActive)
