-- Utility functions for Garbage Job

Utils = {}

-- Load animation
function Utils.loadAnimDict(dict)
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 1000 do
        Wait(10)
        timeout = timeout + 1
    end
    return HasAnimDictLoaded(dict)
end

-- Play animation
function Utils.playAnim(dict, name, duration)
    if Utils.loadAnimDict(dict) then
        TaskPlayAnim(PlayerPedId(), dict, name, 8.0, -8.0, duration / 1000, 1, 0, false, false, false)
        return true
    end
    return false
end

-- Load model
function Utils.loadModel(model)
    if type(model) == 'string' then
        model = GetHashKey(model)
    end
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 1000 do
        Wait(10)
        timeout = timeout + 1
    end
    return HasModelLoaded(model)
end

-- Spawn vehicle
function Utils.spawnVehicle(modelName, coords, heading)
    if not Utils.loadModel(modelName) then
        return nil
    end
    
    local vehicle = CreateVehicle(GetHashKey(modelName), coords.x, coords.y, coords.z, heading, true, false)
    SetVehicleOnGroundProperly(vehicle)
    return vehicle
end

-- Delete vehicle
function Utils.deleteVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
        return true
    end
    return false
end

-- Notify player
function Utils.notify(title, message, type)
    type = type or 'info'
    TriggerEvent('chat:addMessage', {
        args = {title},
        msg = message
    })
end

-- Draw 3D text
function Utils.draw3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        BeginTextCommandDisplayText("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Get player position
function Utils.getPlayerCoords()
    return GetEntityCoords(PlayerPedId())
end

-- Distance between two points
function Utils.distance(p1, p2)
    return #(p1 - p2)
end

-- Create blip
function Utils.createBlip(coords, sprite, color, scale, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    if label then
        BeginTextCommandCreateBlip("STRING")
        AddTextComponentString(label)
        EndTextCommandCreateBlip(blip)
    end
    return blip
end

-- Remove blip
function Utils.removeBlip(blip)
    if blip and DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end

return Utils
