
----------------------------------------
--- EGG HUNT AREAS
----------------------------------------

function CreateAreas()
    for k, area in pairs(Config.areas) do

        local eggHuntArea = {
            name = L('Egg hunt area'),
            renderDistance = 50.0,
            coords = area.coords,
            radius = area.radius,
            amount = area.amount,
            regrowTime = area.respawnTime or 30,

            blip = {
                blipVisible = true,
                areaVisible = true,
                icon = 621,
                color = 48,
                scale = 0.9,
            },
            items = {
                {
                    item = 'kq_easteregg',
                    chance = 100,
                    amount = {
                        min = 1,
                        max = 1,
                    },
                }
            },
            props = {
                {
                    hash = 'kq_egg_1',
                    textureVariation = 0,
                    minimumDistanceBetween = 0.25,
                    offset = {
                        x = 0.0, y = 0.0, z = 0.05,
                    },
                    animation = {
                        duration = 1, -- in seconds
                        dict = 'mp_take_money_mg',
                        anim = 'put_cash_into_bag_loop',
                        flag = 1,
                    },
                    labelSingular = L('Easter egg'),
                    labelPlurar = L('easter eggs'),
                    collectMessage = L('Collect the easter egg'),
                    icon = 'fas fa-egg',
                },
                {
                    hash = 'kq_egg_2',
                    textureVariation = 0,
                    minimumDistanceBetween = 0.25,
                    offset = {
                        x = 0.0, y = 0.0, z = 0.05,
                    },
                    animation = {
                        duration = 1, -- in seconds
                        dict = 'mp_take_money_mg',
                        anim = 'put_cash_into_bag_loop',
                        flag = 1,
                    },
                    labelSingular = L('Easter egg'),
                    labelPlurar = L('easter eggs'),
                    collectMessage = L('Collect the easter egg'),
                    icon = 'fas fa-egg',
                },
                {
                    hash = 'kq_egg_3',
                    textureVariation = 0,
                    minimumDistanceBetween = 0.25,
                    offset = {
                        x = 0.0, y = 0.0, z = 0.05,
                    },
                    animation = {
                        duration = 1, -- in seconds
                        dict = 'mp_take_money_mg',
                        anim = 'put_cash_into_bag_loop',
                        flag = 1,
                    },
                    labelSingular = L('Easter egg'),
                    labelPlurar = L('easter eggs'),
                    collectMessage = L('Collect the easter egg'),
                    icon = 'fas fa-egg',
                },
            },
        }

        exports['kq_lootareas']:CreateArea('kq_egghunt_area_' .. k, eggHuntArea)
    end
end

RegisterServerEvent('kq_egghunt:server:sell')
AddEventHandler('kq_egghunt:server:sell', function(sellingKey)
    local _source = source
    local selling = Config.selling[sellingKey]
    
    if not DoesPlayerHaveItem(_source, selling.item) then
        TriggerClientEvent('kq_egghunt:client:notify', _source, L('~r~You do not have any easter eggs to deliver'))
        return
    end
    
    local amount = GetPlayerItemAmount(_source, selling.item)
    
    RemovePlayerItem(_source, selling.item, amount)
    local reward = amount * selling.price
    AddPlayerMoney(_source, reward)
    TriggerClientEvent('kq_egghunt:client:notify', _source, L('~q~You delivered {AMOUNT} easter eggs. You received ${MONEY} as a reward'):gsub('{AMOUNT}', amount):gsub('{MONEY}', reward))
end)


RegisterCommand('kq_egghunt_restart', function(source)
    local _source = source
    for k, area in pairs(Config.areas) do
        exports['kq_lootareas']:DeleteArea('kq_egghunt_area_' .. k)
    end

    Citizen.Wait(1000)
    TriggerClientEvent('kq_egghunt:client:safeRestart', -1, _source)
end, true)


function Debug(message)
    if Config.debug then
        print(message)
    end
end

function L(text)
    if Locale and Locale[text] then
        return Locale[text]
    end

    return text
end

CreateAreas()