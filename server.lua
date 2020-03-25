local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPclient = Tunnel.getInterface("vRP","vRP_Taxi")
vRP = Proxy.getInterface("vRP")

local menus = {
    ["City Hall"] = {-510.7067565918,-262.32275390625,35.467155456543},
    ["Police Station"]  = {408.8349609375,-991.72479248047,29.266630172729},
    ["Showroom"] = {-71.115264892578,-1105.4812011719,26.093151092529}
}

local taxi = {}

vRP.registerMenuBuilder({"main", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
		
        choices["Taxi App"] = {function(player,choice)	
            vRP.buildMenu({"Dispatch", {player = player}, function(menu)
                menu.name = "Locations"
                menu.css={top="75px",header_color="rgba(0,200,0,0.75)"}
                menu.onclose = function(player) vRP.closeMenu({player}) end

                for i,v in pairs(menus) do
                    menu[i] = {function(player, choice)
                        if taxi[user_id] == nil then
                            vRPclient.getPosition(player,{},function(x,y,z)
                                local pickup_pos = {x,y,z}
                                taxi[user_id] = v
                                TriggerClientEvent("bogdan:Creeaza_Masina",player,pickup_pos,taxi[user_id])
                                vRPclient.notify(player,{"~y~Dispatch ~w~| We sent a Taxi"})
                            end)
                        else
                            vRPclient.notify(player,{"~y~Dispatch ~w~| You already called!"})
                        end
                    end, "<span style = 'color: rgb(0,215,255);font-weight:bold;'></span>"}
                end

                vRP.openMenu({player,menu})
            end})
        end, "<span style = 'color: rgb(0,215,255);font-weight:bold;'></span>"}

	    add(choices)
    end
end})

RegisterServerEvent("bogdan:plata")
AddEventHandler(function(amount)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    if vRP.tryPayment({user_id,amount}) then
        vRPclient.notify(player,{"~y~Taxi~w~ | You paid "..amount.."$!"})
    else
        vRPclient.notify(player,{"~y~Driver~w~ | Good bye!"})
    end
    taxi[user_id] = nil
end)

RegisterServerEvent("bogdan:fail")
AddEventHandler(function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    vRPclient.notify(player,{"~y~Driver~w~ | What a fool, he's gone!"})
    taxi[user_id] = nil
end)
