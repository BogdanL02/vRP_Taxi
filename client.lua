RegisterNetEvent("bogdan:Creeaza_Masina")
AddEventHandler("bogdan:Creeaza_Masina",function(pickup_pos,goto_pos)
    local px,py,pz = table.unpack(pickup_pos)
    local x,y,z = table.unpack(goto_pos)

    local mhash = GetHashKey("ig_car3guy1")
    RequestModel(mhash)
    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
        Citizen.Wait(10)
        i = i+1
    end
    
    local mhash = GetHashKey("taxi")
    RequestModel(mhash)
    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
        Citizen.Wait(10)
        i = i+1
    end

    local distance = math.floor(CalculateTravelDistanceBetweenPoints(px,py,pz,x,y,z)*3.6)
    local price = distance*1.5
    local vehicle = CreateVehicle("taxi",128.84048461914,-1069.2651367188,29.192348480225,0.0,true,false)
    SetEntityInvincible(vehicle,true)
    local ped = CreatePedInsideVehicle(vehicle,4,"ig_car3guy1",-1,true,false)
    TaskVehicleDriveToCoord(ped, vehicle, px,py,pz, 70.0,0.0,mhash, 786603, 20.0,true)
    local blip = AddBlipForEntity(vehicle)
    SetBlipSprite(blip, 198)
    SetBlipAsShortRange(blip, false)
    SetBlipColour(blip,5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Taxi Cab")
    EndTextCommandSetBlipName(blip)
    local blip_whereto = AddBlipForCoord(px,py,pz)
    SetBlipSprite(blip_whereto, 1)
    SetBlipAsShortRange(blip_whereto, false)
    SetBlipColour(blip_whereto,55)
    SetBlipScale(blip_whereto,1.5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Meeting Point")
    EndTextCommandSetBlipName(blip_whereto)
    while true do
        Wait(0)
        if Vdist(GetEntityCoords(vehicle),px,py,pz) < 40.0 then
            TaskVehiclePark(ped, vehicle, px,py,pz, 0.0, 0, 25.0, true)
            Wait(5000)
            if Vdist(GetEntityCoords(vehicle),GetEntityCoords(GetPlayerPed(-1))) < 25.0 then
                TaskEnterVehicle(GetPlayerPed(-1), vehicle, 10000, math.random(0,2), 1.0, 1, 0)
                RemoveBlip(blip_whereto)
                Wait(15000)
                TaskVehicleDriveToCoord(ped, vehicle, x,y,z, 70.0,0.0,mhash, 786603, 20.0,true)
                while true do
                    Wait(0)
                    if not IsPedInAnyVehicle(GetPlayerPed(-1),false) then
                        Wait(7500)
                        TriggerServerEvent("bogdan:plata",price)
                        SetVehicleDoorsLockedForAllPlayers(vehicle,true)
                        TaskVehicleDriveToCoord(ped, vehicle, 937.43975830078,-171.13888549805,74.481132507324, 70.0,0.0,mhash, 786603, 20.0,true)
                        RemoveBlip(blip_whereto)
                        RemoveBlip(blip)
                        break
                    end
                    if Vdist(x,y,z,GetEntityCoords(vehicle)) < 20.0 then
                        TaskLeaveVehicle(GetPlayerPed(-1),vehicle,0)
                        TriggerServerEvent("bogdan:plata",price)
                        Wait(5000)
                        TaskVehicleDriveToCoord(ped, vehicle, 937.43975830078,-171.13888549805,74.481132507324, 70.0,0.0,mhash, 786603, 20.0,true)
                        RemoveBlip(blip)
                        break
                    end
                end
            else
                TaskVehicleDriveToCoord(ped, vehicle, 937.43975830078,-171.13888549805,74.481132507324, 70.0,0.0,mhash, 786603, 20.0,true)
                TriggerServerEvent("bogdan:fail")
                RemoveBlip(blip_whereto)
                RemoveBlip(blip)
                DeleteVehicle(vehicle)
            end
            break
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        print(GetEntityHeading(GetPlayerPed(-1)))
    end
end)
