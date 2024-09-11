--[[
╔══════════════════════════════════════════╗
║   German Translation by Der_Wanderer     ║
╠══════════════════════════════════════════╣
║- <Der Wanderer>                          ║
║- https://github.com/German0Mike          ║
║- Status: 100 %                           ║
║- Discord: https://discord.gg/zmYUKrA33U  ║
║- Credit to the original author           ║
║- Thanks for the Script                   ║                                          
╚══════════════════════════════════════════╝
--]]
print("->LUA-Skript: Arenabestenliste...geladen!")
----------------------------------------------
-- TOP 5 per class                          //
-- Script by Renatokeys(emudevs)            //
-- http://emudevs.com                       //
----------------------------------------------
local NPC_ID = 700008

 local arena = {
	[2] = {"Bestenliste TOP 10 Arena - 2v2"},
	[3]	= {"Bestenliste TOP 10 Arena - 3v3"},
	[5] = {"Bestenliste TOP 10 Arena - 5v5"},	
};
	
 
function seleciona(event, plr, unit)
    	for k, v in pairs(arena) do
		plr:GossipMenuAddItem(0, v[1], 0, k)
	end
	plr:GossipSendMenu(1, unit)
end

function clica(event, plr, unit, arg2, intid)
    if (intid > 0) then
        local resultado = CharDBQuery("SELECT name,rating FROM arena_team WHERE type='"..intid.."' ORDER BY rating DESC LIMIT 10")
        repeat
        time = resultado:GetString(0);
        pontos = resultado:GetUInt32(1);
        plr:SendBroadcastMessage("|cFF33CCFFseit : |r ".. time .." ,  |cFF33CCFFRating : |r" .. pontos .. "  in der Arena ")
        until not resultado:NextRow()    
    end
end
RegisterCreatureGossipEvent(NPC_ID, 1, seleciona)
RegisterCreatureGossipEvent(NPC_ID, 2, clica)