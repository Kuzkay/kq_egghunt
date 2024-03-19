local deleteEntities = {}

Citizen.CreateThread(function()
    Citizen.Wait(1000)

    for k, selling in pairs(Config.selling) do
        local model = 'mp_m_freemode_01'
        local loc = selling.location
        DoRequestModel(model)

        local ped = CreatePed(0, model, vector3(loc.x, loc.y, loc.z - 1.0), selling.heading, false, false)
        table.insert(deleteEntities, ped)

        SetModelAsNoLongerNeeded(model)

        Config.selling[k].ped = ped
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)

        -- mask
        SetPedComponentVariation(ped, 1, 165, 0, 1)
        -- top
        SetPedComponentVariation(ped, 11, 15, 0, 1)
        -- tshirt
        SetPedComponentVariation(ped, 8, 15, 0, 1)
        -- arms
        SetPedComponentVariation(ped, 3, 15, 0, 1)
        -- shoes
        SetPedComponentVariation(ped, 6, 34, 0, 1)
        -- pants
        SetPedComponentVariation(ped, 4, 90, 4, 0)

        PlayAnim('anim@heists@box_carry@', 'idle', 1, ped)

        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanUseAutoConversationLookat(ped, true)
        TaskLookAtEntity(ped, PlayerPedId(), -1, 2048, 3)
        SetEntityAsMissionEntity(ped, true, true)

        AddEntityToTargeting(ped, 'selling_' .. ped, L('Deliver easter eggs'), 'kq_egghunt:target:sell', k)

        SetPedSize(ped)

        PutBasketInArms(ped)

        if selling.showBlip then
            CreateBlip(loc, 621, 34, 255, 1.0, L('Easter bunny'))
        end
    end
end)

function PutBasketInArms(ped)
    local model = 'prop_fruit_basket'
    DoRequestModel(model)

    local coords = GetEntityCoords(ped)
    local basket = CreateObject(model, coords, 0, 1, 0)

    local handBone = 0
    local handBoneIndex = GetPedBoneIndex(ped, handBone)
    local offsetCoords = vector3(-0.05, 0.4, 0.3)
    local offsetRot = vector3(0.0, 0.0, 0.0)
    AttachEntityToEntity(basket, ped, handBoneIndex, offsetCoords, offsetRot, true, false, false, false, 2, true)

    table.insert(deleteEntities, basket)

    Citizen.Wait(10)
    SpawnBasketEggs(basket)
end

function SpawnBasketEggs(basket)
    local eggs = {
        { vector3(0.0, 0.0, -0.17), vector3(0.0, 0.0, 0.0), 'kq_egg_1' },
        { vector3(0.15, 0.05, -0.17), vector3(30.0, 20.0, 0.0), 'kq_egg_2' },
        { vector3(-0.14, -0.05, -0.17), vector3(70.0, 40.0, 0.0), 'kq_egg_3' },
        { vector3(0.12, -0.07, -0.17), vector3(0.0, 325.0, 0.0), 'kq_egg_3' },
        { vector3(0.2, 0.11, -0.07), vector3(0.0, 40.0, 40.0), 'kq_egg_1' },
        { vector3(-0.12, 0.1, -0.17), vector3(0.0, 88.0, 0.0), 'kq_egg_3' },
        { vector3(0.01, -0.08, -0.06), vector3(30.0, 35.0, 30.0), 'kq_egg_2' },
    }

    for k, egg in pairs(eggs) do
        local coords = GetEntityCoords(basket)
        local eggObj = CreateObject(egg[3], coords, 0, 1, 0)

        local handBone = 0
        local handBoneIndex = GetPedBoneIndex(basket, handBone)
        AttachEntityToEntity(eggObj, basket, handBoneIndex, egg[1], egg[2], true, false, false, false, 2, true)
        table.insert(deleteEntities, eggObj)
    end
end

if not Config.target.enabled then
    Citizen.CreateThread(function()
        while true do
            local sleep = 4000

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            for k, selling in pairs(Config.selling) do
                local loc = selling.location
                local distance = GetDistanceBetweenCoords(playerCoords, loc.x, loc.y, loc.z, 1)
                if distance < 20 then
                    sleep = 1000
                    if distance < 2 then
                        local text = L('Press ~q~[~w~{KEYBIND}~q~]~w~ to deliver the easter eggs'):gsub('{KEYBIND}', Config.keybinds.interact.label)
                        Draw3DText(GetOffsetFromEntityInWorldCoords(selling.ped, vector3(0.0, 0.4, 0.35)), text, 0.035)

                        sleep = 1
                        if IsControlJustReleased(0, Config.keybinds.interact.input) then
                            SellItem(k)
                        end
                    end
                end
            end

            Citizen.Wait(sleep)
        end
    end)
end


function SellItem(sellingKey)
    local playerPed = PlayerPedId()
    RemoveHandWeapons()

    local sellingPed = Config.selling[sellingKey].ped
    TaskTurnPedToFaceEntity(playerPed, sellingPed, 1000)
    Citizen.Wait(1000)

    PlayAnim('mp_common', 'givetake1_a')

    Citizen.Wait(Config.selling[sellingKey].duration)

    ClearPedTasks(playerPed)
    SetPedSize(sellingPed)
    TriggerServerEvent('kq_egghunt:server:sell', sellingKey)
end

--- SAFE RESTART FUNCTIONALITY
RegisterNetEvent('kq_egghunt:client:safeRestart')
AddEventHandler('kq_egghunt:client:safeRestart', function(caller)
    for k, entity in pairs(deleteEntities) do
        DeleteEntity(entity)
    end

    if caller == GetPlayerServerId(PlayerId()) then
        Citizen.Wait(2000)
        ExecuteCommand('ensure kq_egghunt')
    end
end)
