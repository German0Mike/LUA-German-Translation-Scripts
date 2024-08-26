--[[
    German Translation by German0Mike https://github.com/German0Mike -> Credit to the original author, thanks for the nice script!
]]
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