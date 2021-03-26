function Notify(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function SpawnCarWithoutHeading(vehicle, x, y, z)
    local hashedVehicle = GetHashKey(vehicle)

    local car = nil
    Citizen.CreateThread(function()
        RequestModel(hashedVehicle)

        while not HasModelLoaded(hashedVehicle) do
            RequestModel(hashedVehicle)
            Citizen.Wait(0)
        end
    
    
        car = CreateVehicle(hashedVehicle, x, y, z, 
        0.00, true, false)
        SetEntityAsMissionEntity(car, true, true)
        table.insert(vehicles, car)
        Notify("~p~Spawned car: ~h~~g~" .. vehicle)
        print("Vehicle spawned: ", vehicle, "\tAt: ", x, y, z)
    end)
    return car
end

function SpawnCar(vehicle, x, y, z, heading)
    local hashedVehicle = GetHashKey(vehicle)

    RequestModel(hashedVehicle)

    while not HasModelLoaded(hashedVehicle) do
        RequestModel(hashedVehicle)
        Citizen.Wait(0)
    end
    
    
    local spawnedVehicle = CreateVehicle(hashedVehicle, x, y, z, 
    heading, true, false)
    SetEntityAsMissionEntity(spawnedVehicle, true, true)

    table.insert(vehicles, spawnedVehicle)
    Notify("~p~Spawned car: ~h~~g~" .. spawnedVehicle)
    print("Vehicle spawned: ", spawnedVehicle, "\tAt: ", x, y, z)
    print("Car created: ", spawnedVehicle)

    return spawnedVehicle
end

function LoadCarWithPeds(vehicle, pedTypes, 
    modelHashs, isNetworks, netMissionEntities)
    
        local seats = {-1,0,1,2}
        Notify("test")
        
        local size = GetVehicleMaxNumberOfPassengers(vehicle) + 1
        print(size)
        print("Vehicle", vehicle)
        print("Modelhashs", #modelHashs)
    
        for i = 1, size , 1 do
            local currentPed = CreatePedInsideVehicle(vehicle, pedTypes[i], 
            GetHashKey(modelHashs[i]), seats[i], isNetworks[i], netMissionEntities[i])
            
            GiveWeaponToPed(currentPed, GetHashKey("WEAPON_CARBINERIFLE"), 150, false, false)
            SetPedArmour(currentPed, 100)
            print("Index: ", i, "Current ped: ", currentPed, "Seat: ", seats[i], "Other: ",
                pedTypes[i], GetHashKey(modelHashs[i]))
            table.insert(peds, currentPed)
        end
    
        print("Ped in vehicle seat: ", GetPedInVehicleSeat(vehicle, -1))
end

function LoadCarWithPedsAtCoords(vehicle, pedTypes, 
    modelHashs, isNetworks, netMissionEntities)
    Citizen.CreateThread(function()
        local seats = {-1,0,1,2}
        Notify("test")
        for i = 1, #pedTypes, 1 do
            CreatePedInsideVehicle(vehicle, pedTypes[i], 
            GetHashKey(modelHashs[i]), seats[i], isNetworks[i])

            print("Index: ", i)
            print(GetPedInVehicleSeat(vehicle, seats[i]))
            print(seats[i])
            table.insert(peds, currentPed)
        end

        print("Ped in vehicle seat: ", GetPedInVehicleSeat(vehicle, -1))
    end)
end

function CallPolice(x,y,z)
    Citizen.CreateThread(function()
        print("callpolice command raised!")

        print("Police is coming!")
        local policeVehicle = GetRandomPoliceCar()
        local vehicle = SpawnCar(policeVehicle, 445.585, -1018.075, 30.1214, 90.00)
        
        print("Vehicle: ", vehicle)

        local randomPeds = GetRandomPedCop(policeVehicle)
        print("Peds: ", #randomPeds)
        LoadCarWithPeds(vehicle, 
        { 6,6,6,6,6,6 }, randomPeds,
        {true, true, true, true, true, true},
        {true, true, true, true, true, true})

        SetEntityInvincible(vehicle, true)
        SetEntityLights(vehicle, true)
        SetVehicleSiren(vehicle, true)
        TaskVehicleDriveToCoordLongrange(GetPedInVehicleSeat(vehicle, -1), 
        vehicle, x, y, z, 1000000.00, 2883621, 5.00)

        Citizen.Wait(15000)
        SetEntityInvincible(vehicle, false)
    end)
end

function RaisePolice()
    Citizen.CreateThread(function()

    end)
end

function GetMyPedCoords()
    local x,y,z = nil
    local castedCoords = nil

    x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    castedCoords = {tonumber(x),tonumber(y),tonumber(z)}
    print(tonumber(x),tonumber(y),tonumber(z))

    return castedCoords
end

function DeleteAllSpawned(vehicles, peds)
    Citizen.CreateThread(function()
        print("Vehicles spawned: ", #vehicles, "Peds spawned: ", #peds)

        for i = 1, #vehicles, 1 do
            SetEntityAsMissionEntity(vehicles[i], true, true)
            DeleteVehicle(vehicles[i])
        end

        for i = 1, #peds, 1 do
            x,y,z = table.unpack(GetEntityCoords(peds[i]))
            print("Ped: ", peds[i], "Coords: ", GetEntityCoords(peds[i]))
            print(tonumber(x), tonumber(y), tonumber(z))

            DeleteEntity(peds[i])
            --ClearAreaOfEverything(tonumber(x), tonumber(y), tonumber(z), 1, 
            --true, true, true, true)
        end

        print("Deleted all spawned!")
    end)
end

function GetRandomPedCop(currentCar)
    if currentCar == "FBI" or currentCar == "FBI2" then
        return { "s_m_y_swat_01", "s_m_y_swat_01", "s_m_y_swat_01", "s_m_y_swat_01", "s_m_y_swat_01", "s_m_y_swat_01" }
    elseif currentCar == "Police" or currentCar == "Police2" or currentCar == "Police3" or currentCar == "PoliceT" or currentCar == "Riot" then
        return { "s_m_y_cop_01", "s_m_y_cop_01", "s_m_y_cop_01", "s_m_y_cop_01", "s_m_y_cop_01", "s_m_y_cop_01" }
    else
        return { "s_m_y_sheriff_01", "s_m_y_sheriff_01", "s_m_y_sheriff_01", "s_m_y_sheriff_01", "s_m_y_sheriff_01", "s_m_y_sheriff_01" }
    end
end

function GetRandomPoliceCar()
    local cars = { "FBI", "FBI2", "Police", "Police2", "Police3", "PoliceT", "Riot", "Sheriff", "Sheriff2"}
    return cars[math.random(#cars)]
end

function SpawnVehicleAndSetMyPedIntoIt(x,y,z,vehicleName,seat)
    SpawnCar(vehicleName, x, y, z, 
    GetEntityHeading(GetPlayerPed(-1)))
    
    SetPedIntoVehicle(GetPlayerPed(-1), 
    vehicles[#vehicles], seat)
end