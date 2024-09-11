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
print("->LUA-Skript: Bankscript (.bank)...geladen!")
local command = "bank"

function OnEvents(event, player, message, type, language)

    if (message == command) then
		
       player:SendBroadcastMessage("|cff00cc00Deine Persöhnliche Bank|cff00ffff ["..player:GetName().."]|r")
	   player:SendShowBank(player)
	   return false;
    end
end

RegisterPlayerEvent(42, OnEvents)