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
-- killer = es el jugador que esta matando.
-- killed = es el jugador que esta muerto.


--/ funciones de Player
--SendBroadcastMessage =  send a single player the menssage.
--SendAreaTriggerMessage = send a menssage in center how notify.
--/ funcion Global

--SendWorldMessage = Send World menssage all players
	
print("->LUA-Skript: Öffentliche Nachrichten über PvP-Kills...geladen!")

function pvp (event, killer, killed)
	if (killer:GetGUIDLow() == killed:GetGUIDLow()) then return false end

SendWorldMessage("[PVP]: "..killer:GetName().." ermordete "..killed:GetName().." in einem Kampf!")

end

RegisterPlayerEvent(6, pvp)