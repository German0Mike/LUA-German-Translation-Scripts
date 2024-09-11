--[[
Author : Jafferwaffer
Core : Trinity Core with Eluna 3.3.5a (Latest Rev)
Script name : GroupCmds
Huge thanks to the Emu Devs, especially Rochet2 for great support!
Please ask if you wish to repost by PM on emudevs.com
Also PM with any bugs.
Thank you, enjoy!
]]
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
print("->LUA-Skript: Gruppenbeschwörungen (.ghelp)...geladen!")

local GroupSummon = "galle" -- .gsummon
local GroupAppear = "gdu" -- .gappear
local GroupHelp = "ghilfe" -- .ghelp

--Getting position
local function getMapDetails(player)
	return player:GetLocation();
end
local function getZoneId(player)
	return player:GetZoneId();
end
local function getMapId(player)
	return player:GetMapId();
end

--Checking if player and target are in the same group
--Returns true if they are false otherwise.
local function checkForGroup(player,target)
	if(player:IsInGroup()) then
			local group = player:GetGroup();
			local tarGUID = target:GetGUID();
		if	(group:IsMember(tarGUID)) then
			return true;
		else
			return false;
		end	
	else
		return false;
	end	
end

--Handle .gappear command
local function CmdAppear(player, target)
	if (target:IsAlive()) then
		local x, y, z, o = getMapDetails(target);
		player:Teleport(getMapId(target), x, y, z, o);
		player:SendBroadcastMessage("Du beschwörst dich zu "..target:GetName().."'s Standort.");
	else
		player:SendBroadcastMessage("Ihr Ziel muss am Leben sein, um es zu beschwören");
	end
end

--Handle .gsummon command
local function CmdSummon(player, target)
	local x, y, z, o = getMapDetails(player);
	player:SummonPlayer(target, getMapId(player), x, y, z, getZoneId(player));
	player:SendBroadcastMessage("Beschwöre "..target:GetName().." zu deinem Standort.");
end

--Handle .gsummon all command
local function CmdSummon_all(player)
	if(player:IsInGroup()) then
		--Get map details for the summoning player
		local x, y, z, o = getMapDetails(player);
		local plrMapId = getMapId(player);
		local plrZoneId = getZoneId(player);
		--Get the group & each member in group of the player
		local playerGroup = player:GetGroup();
		local groupPlayers = playerGroup:GetMembers();
		player:SendBroadcastMessage("Beschwöre die ganze Gruppe zu dir.");
		for i,v in ipairs(groupPlayers) do
			if(v ~= player) then
				player:SummonPlayer(v, plrMapId, x, y, z, plrZoneId);
			end
		end
	else
		player:SendBroadcastMessage("Du musst in einer Gruppe sein.");
	end	
end
--Handle #help command
local function CmdHelp(player)
	player:SendBroadcastMessage("Die folgenden Befehle sind verfügbar, sofern du in einer Gruppe bist: ");
	player:SendBroadcastMessage(".gdu ~ Syntax : .gappear [Spielername] ~ Beschwöre dich zum gewählten Spieler");
	player:SendBroadcastMessage(".galle ~ Syntax : .gsummon [Spielername] ~ Beschwöre den gewählten Spieler zu dir");
	player:SendBroadcastMessage(".gsalle all ~ Alle deine Gruppenmitglieder werden zu dir beschworen.");
	player:SendBroadcastMessage(".ghilfe ~ Schaue diese Hilfe an");
end

--Gets the player's target: Either their selection or through text.
--Selection has priority over text.
local function GetTarget(player, msg, lang)
	if (player:GetSelection() ~= nil) then
		local target = player:GetSelection();
		return target;
	elseif (string.len(msg) > 8) then
		local playerName = string.match(msg,"%s(.-)%s*$"); --Match with any text after fisrt space, and trim first space.
		if (playerName == "all") then
			return playerName
		else	
			local target = GetPlayerByName(playerName);
			--print(playerName); Used for Debug
			--print(target);
			return target;
		end	
	else
		player:SendBroadcastMessage("Du musst ein Ziel auswählen");
		--print("Fail"); --Debug
		return nil;
	end	
end	

--Handles player event.
local function CmdAction(event, player, msg, lang)
	if	(msg:find(GroupSummon) == 1) then --If typed .gsummon
		local target = GetTarget(player, msg, lang); --Returns Player Obj or string "all"
		if(target == "all") then
			CmdSummon_all(player);
			return false;
		else	
			if(target ~= nil) then --Check for target
				if (checkForGroup(player, target)) then --Check for group
					CmdSummon(player, target);
					return false;
				else
					player:SendBroadcastMessage("Das Ziel muss sich in deiner Gruppe befinden");
					return false;
				end
			else
				return false;
			end
		end	
	elseif(msg:find(GroupAppear) == 1) then --If typed .gappear
		local target = GetTarget(player, msg, lang); --Returns Player Obj
		if(target ~= nil) then --Check for target
			if (checkForGroup(player, target)) then
				CmdAppear(player, target);
				return false;
			else
				player:SendBroadcastMessage("Das Ziel muss sich in deiner Gruppe befinden");
				return false;
			end
		else
			return false;
		end	
	elseif(msg:find(GroupHelp) == 1) then
		CmdHelp(player);
		return false;
	end		

end

RegisterPlayerEvent(42, CmdAction) --Upon player use command check for prefix