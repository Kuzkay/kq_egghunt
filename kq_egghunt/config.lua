Config = {}

--- READ <!>
--- To safely restart the script, use the command `kq_egghunt_restart`.
--- Do not simply `restart kq_egghunt` or `ensure kq_egghunt` to restart it. This will cause the game to crash due to the custom models being unloaded

Config.debug = false

-------------------------------------------------
--- FRAMEWORK SETTINGS
-------------------------------------------------
Config.esxSettings = {
    enabled = true,
    -- Whether or not to use the new ESX export method
    useNewESXExport = true,

    -- Money account used when picking up cash or selling off items
    moneyAccount = 'money',
}

Config.qbSettings = {
    enabled = false,
    -- Whether or not to use the new QBCore export method
    useNewQBExport = true,

    -- Money account used when picking up cash or selling off items
    moneyAccount = 'cash',
}


Config.target = {
    enabled = false,
    system = 'ox_target' -- 'qtarget' or 'qb-target' or 'ox_target'  (Other systems might work as well)
}


--- Egg hunt areas
--- coords = vector3 / coordinates of the center of the zone
--- radius = float / radius of the egg hunt zone
--- amount = int / amount of eggs that should spawn in the zone
--- respawnTime / int / time in seconds, delay for the eggs to respawn after being picked up (in a new random position within the zone)
Config.areas = {
    { -- Up north
        coords = vector3(165.18, 6881.2, 40.0),
        radius = 150.0,
        amount = 30,
        respawnTime = 30,
    },
    { -- Legion square
        coords = vector3(199.59, -932.9, 40.0),
        radius = 90.0,
        amount = 10,
        respawnTime = 30,
    },
    { -- LS Skate park
        coords = vector3(-920.26, -764.9, 30.0),
        radius = 80.0,
        amount = 10,
        respawnTime = 30,
    },
    { -- Park up north
        coords = vector3(776.9, -277.10, 66.35),
        radius = 80.0,
        amount = 8,
        respawnTime = 30,
    },
    { -- Golf course
        coords = vector3(-1177.15, 57.0, 54.4),
        radius = 150.0,
        amount = 40,
        respawnTime = 30,
    }
}

Config.selling = {
    {
        location = vector3(2518.75, 4404.71, 37.37),
        heading = 250.0,

        duration = 2000, -- selling duration in ms
        
        item = 'kq_easteregg',

        price = 150,

        showBlip = true, -- whether or not to show the easter egg selling location blip on the map
    },
}

----------------------------------------------------------------------------------------------
--- KEYBINDS
----------------------------------------------------------------------------------------------
-- https://docs.fivem.net/docs/game-references/controls/
-- Use the input index for the "input" value
Config.keybinds = {
    interact = {
        label = 'E',
        input = 38,
    },
}
