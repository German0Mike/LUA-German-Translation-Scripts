--[[
    German Translation by German0Mike https://github.com/German0Mike -> Credit to the original author, thanks for the nice script!
]]
print("->LUA-Skript: Wer kommt Online...geladen!")
local function OnEnterWorld(event, player)
    local isHorde = player:IsHorde()
    local playerName = player:GetName()
	
	local Class = { -- Class colors :) Prettier and easier than the elseif crap :) THESE ARE HEX COLORS!
    [1] = "C79C6E", -- Krieger
    [2] = "F58CBA", -- Paladin
    [3] = "ABD473", -- Jäger
    [4] = "FFF569", -- Schurke
    [5] = "FFFFFF", -- Priester
    [6] = "C41F3B", -- Todesritter
    [7] = "0070DE", -- Schamane
    [8] = "69CCF0", -- Magier
    [9] = "9482C9", -- Hexenmeister
    [11] = "FF7d0A" -- Druide
};

    if(player:IsGM()) then
        local t = table.concat({"|cff", Class[player:GetClass()], "|Hplayer:|h [" .. playerName .. "]|h|r - |cffDF01D7[Owner]|h|r ist nun Online."});
		SendWorldMessage(t);
    elseif(isHorde == true) then
        local t = table.concat({"|cff", Class[player:GetClass()], "|Hplayer:|h [" .. playerName .. "]|h|r - |cff610B0B[Horde]|h|r hat die Welt betreten."});
		SendWorldMessage(t);
    elseif(isHorde == false) then
        local t = table.concat({"|cff", Class[player:GetClass()], "|Hplayer:|h [" .. playerName .. "]|h|r - |cff0101DF[Allianz]|h|r hat die Welt betreten."});
		SendWorldMessage(t);
    end
end

local function OnExitWorld(event, player)
    local isHorde = player:IsHorde()
    local playerName = player:GetName()

    if(player:IsGM()) then
        SendWorldMessage("[" .. playerName .. " - GM] has logged out." )
    elseif(isHorde == true) then
        SendWorldMessage("[" .. playerName .. " - Horde] hat die Welt verlassen." )
    elseif(isHorde == false) then
        SendWorldMessage("[" .. playerName .. " - Allianz] hat die Welt verlassen." )
    end
end
    
RegisterPlayerEvent(3, OnEnterWorld)
RegisterPlayerEvent(4, OnExitWorld)