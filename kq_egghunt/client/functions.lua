
function CreateBlip(coords, sprite, color, alpha, scale, message)
    local blip = AddBlipForCoord(coords)
    
    SetBlipSprite(blip, sprite)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, color)
    SetBlipAlpha(blip, alpha)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(message)
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)
    
    return blip
end

function PlayAnim(dict, anim, flag, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    TaskPlayAnim(ped or PlayerPedId(), dict, anim, 8.0, 8.0, 5.0, flag or 1, 0, true, true, false)
    RemoveAnimDict(dict)
end

function SetPedSize(ped)
    local forwardVector, rightVector, upVector, position = GetEntityMatrix(ped)

    local multiplier = 0.75

    local changed = false
    if not changed then
        if multiplier > 1.0 then
            changed = upVector.z <= 1.0
        end
        if multiplier < 1.0 then
            changed = upVector.z >= 1.0
        end
    end

    if changed then
        position = position + vector3(0.0, 0.0, multiplier - 1)

        forwardVector = forwardVector * multiplier
        rightVector = rightVector * multiplier
        upVector = upVector * multiplier
    end

    SetEntityMatrix(ped, forwardVector, rightVector, upVector, position)
end

--This function is responsible for drawing all the 3d texts
function Draw3DText(coords, textInput, scaleX)
    scaleX = scaleX * (Config.textScale or 1.0)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, coords, true)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(scaleX * scale, scaleX * scale)
    SetTextFont(Config.textFont or 4)
    SetTextProportional(1)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end


RegisterNetEvent('kq_egghunt:client:notify')
AddEventHandler('kq_egghunt:client:notify', function(message)
    ShowTooltip(message)
end)

-- This function is responsible for all the tooltips displayed on top right of the screen, you could
-- replace it with a custom notification etc.
function ShowTooltip(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 0, 4000)
end

function RemoveHandWeapons()
    SetCurrentPedWeapon(PlayerPedId(), -1569615261, true)
end

function DoRequestModel(model)
    local hash = GetHashKey(model)
    if HasModelLoaded(hash) then
        return
    end

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(100)
    end
end


function Contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

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
