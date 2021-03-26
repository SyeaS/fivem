Citizen.CreateThread(function()
    local f1_key = 289
    local policeVehicle = "Police"
    
    while true do
        Citizen.Wait(1)
        if IsControlJustReleased(1, f1_key) then
            local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
            local heading = GetEntityHeading(GetPlayerPed(-1))
            print("x: ", x, "y: ", y, "z: ", z, "Heading: ", heading)
        end
    end
end)