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
local cmd = "resetid"
print("->LUA-Skript: Instanzen zuruecksetzen (.resetid)...geladen!")

local function OnCommand(event, player, command)
    if command == cmd then
        if not player:IsInCombat() then
        player:UnbindAllInstances()
	    player:SendBroadcastMessage("Deine Instanz-ID wurde zurückgesetzt.")
        end
        return false
    end
end
RegisterPlayerEvent(42, OnCommand)