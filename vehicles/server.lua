RegisterServerEvent("vehicles:call_police")
AddEventHandler("vehicles:call_police", function(x,y,z)
    TriggerClientEvent("vehicles:create_police", -1, x,y,z)
end)