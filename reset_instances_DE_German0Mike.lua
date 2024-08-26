--[[
    German Translation by German0Mike https://github.com/German0Mike -> Credit to the original author, thanks for the nice script!
]]
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