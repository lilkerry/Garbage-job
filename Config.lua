Config = {}

-- Job Settings
Config.Job = 'garbage'
Config.Label = 'Garbage Collector'
Config.PayPerBin = 50
Config.RouteBonus = 500

-- Vehicle Settings
Config.VehicleModel = 'trash'
Config.VehicleSpawn = vector3(376.45, -977.85, 29.41)  -- SANCHEZ STATION
Config.VehicleHeading = 335.0

-- Garbage Routes
Config.Routes = {
    [1] = {
        name = 'Downtown',
        bins = {
            {x = 100.5, y = -200.3, z = 0.0},
            {x = 150.2, y = -180.5, z = 0.0},
            {x = 200.1, y = -210.8, z = 0.0},
            {x = 250.7, y = -190.2, z = 0.0},
            {x = 300.4, y = -220.1, z = 0.0},
        }
    },
    [2] = {
        name = 'Beach',
        bins = {
            {x = -1300.5, y = -1400.3, z = 5.0},
            {x = -1350.2, y = -1380.5, z = 5.0},
            {x = -1400.1, y = -1410.8, z = 5.0},
            {x = -1450.7, y = -1390.2, z = 5.0},
            {x = -1500.4, y = -1420.1, z = 5.0},
        }
    },
    [3] = {
        name = 'Vinewood',
        bins = {
            {x = 650.5, y = 100.3, z = 92.0},
            {x = 700.2, y = 120.5, z = 92.0},
            {x = 750.1, y = 80.8, z = 92.0},
            {x = 800.7, y = 110.2, z = 92.0},
            {x = 850.4, y = 90.1, z = 92.0},
        }
    },
}

-- Collection Settings
Config.CollectionDistance = 15.0
Config.CollectionDuration = 3000  -- milliseconds
Config.AnimDict = 'anim@amb@clubhouse@trash'
Config.AnimName = 'tra_cash_p_a_player'

-- Blip Settings
Config.BlipSprite = 227  -- Garbage truck icon
Config.BlipColor = 2  -- Green
Config.BlipScale = 0.8
Config.BlipRoute = true  -- Enable route blips

-- Payment
Config.PaymentMethod = 'cash'  -- 'cash', 'bank', or 'both'

-- Debug Mode
Config.Debug = false
