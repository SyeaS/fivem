vehicles = {}
peds = {}
currentVehicle = nil

Citizen.CreateThread(function()
    local f1_key = 288
    
    while true do
        Citizen.Wait(1)
        if IsControlJustReleased(1, f1_key) then
            Notify("The police have been alerted!")
            local x,y,z = table.unpack(GetMyPedCoords())
            TriggerServerEvent("vehicles:call_police", x,y,z)
        end
    end
end)
-- 2883621 --ignore lights
RegisterCommand("teleport", function(source, args, rawCommand)
-- /help 5 --> hlep args[0] 5 args[1]
    x,y,z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    print("Teleporting to: ", x, y, z)
    SetEntityCoords(PlayerPedId(), x, y, z , false, false, false, true)
    DoScreenFadeIn(3000)
end, false)
RegisterCommand("spawnvehicle", function(source, args, rawCommand)
    -- /help 5 --> hlep args[0] 5 args[1]
    Citizen.CreateThread(function()
        local x,y,z = table.unpack(GetMyPedCoords())
        x = x + 5
        y = y + 5
        z = z + 2
    
        SpawnVehicleAndSetMyPedIntoIt(x,y,z, args[1],-1)
         -- 443, -1020, 29
    end)
end, false)
RegisterCommand("callpolice", function()
        -- /help 5 --> hlep args[0] 5 args[1]
        --Notify("The police have been alerted!")
        --TriggerServerEvent("vehicles:call_police", GetPlayerPed(-1))
        local x,y,z = table.unpack(GetMyPedCoords())
        --TriggerServerEvent("vehicles:call_police", x,y,z)
        CallPolice(x,y,z)
        end, false)

RegisterCommand("spawnpolice", function(source, args, rawCommand)
    Citizen.CreateThread(function()
    local x = tonumber(args[1])
    local y = tonumber(args[2])
    local z = tonumber(args[3])
    
    local currentCar = GetRandomPoliceCar()
    local peds = GetRandomPedCop(currentCar)

    print("Current car: ", currentCar)

    
    print(#peds)
    print(x,y,z)
    local vehicle = SpawnCar(currentCar, x, y, z, 95.075)
    LoadCarWithPeds(vehicle, { 6,6,6,6,6,6 }, peds,
            {true, true, true, true, true, true},
            {true, true, true, true, true, true})
    end)
end, false)

RegisterCommand("giveweapon", function(source, args, rawCommand)
    GiveWeaponToPed(GetPlayerPed(-1), "WEAPON_CARBINERIFLE", 10000, false, false)
end, false)

RegisterCommand("delete_all_spawned", function()
    Citizen.CreateThread(function()
        DeleteAllSpawned(vehicles, peds)
    end)
end, false)

RegisterNetEvent("vehicles:create_police")
AddEventHandler("vehicles:create_police", function(x,y,z)
    print("Police called!")
    CallPolice(x,y,z)
end)