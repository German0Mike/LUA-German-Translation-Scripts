--[[
    German Translation by German0Mike https://github.com/German0Mike -> Credit to the original author, thanks for the nice script!
]]
print("->LUA-Skript: Wer hat welchen Boss getoetet?...geladen!")
local enabled = true

local function AnnounceBossKilled (event, killer, killed)
	if (killed:IsWorldBoss() == true) then 
		if (killer:GetGender() == 0) then 
			local message = "|CFF7BBEF7[Boss Information]|r:|cffff0000 "..killer:GetName().."|r und seine Gruppe haben den Weltboss getötet |CFF18BE00["..killed:GetName().."]|r !!!"
			SendWorldMessage(message)
		else
			local message = "|CFF7BBEF7[Boss Information]|r:|cffff0000 "..killer:GetName().."|r und seine Gruppe haben den Weltboss getötet |CFF18BE00["..killed:GetName().."]|r !!!"
			SendWorldMessage(message)
		end
	end
end
if enabled then
RegisterPlayerEvent(7, AnnounceBossKilled)
end