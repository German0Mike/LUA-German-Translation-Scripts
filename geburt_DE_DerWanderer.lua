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
print("->LUA-Skript: Geburt eines Helden...geladen!")
local Races = {
	[1]  = "Mensch",
	[2]  = "Ork",
	[3]  = "Zwerg",
	[4]  = "Nachtelf",
	[5]  = "Untod",
	[6]  = "Taure",
	[7]  = "Gnom",
	[8]  = "Troll",
	[9]  = "",
	[10] = "Blutelf",
	[11] = "Draenei",
}

local Genders = {
	[0] = "männlich",
	[1] = "weiblich",
}

local Classes = {
	[1]  = "inv_sword_27",
	[2]  = "ability_thunderbolt",
	[3]  = "inv_weapon_bow_07",
	[4]  = "inv_throwingknife_04",
	[5]  = "inv_staff_30",
	[6]  = "spell_deathknight_classicon",
	[7]  = "inv_jewelry_talisman_04",
	[8]  = "inv_staff_13",
	[9]  = "spell_nature_faeriefire",
	[10] = "",
	[11] = "inv_misc_monsterclaw_04",
}

local Factions = {
	[0] = "inv_bannerpvp_02",
	[1] = "inv_bannerpvp_01",
}

local Colors = { "|cff66FCF1", "|cffEE4C7C", "|cffF13C20", "|cff4056A1", "|cffFF652F", "|cffFFE400", "|cff14A76C", "|cffF76C6C", "|cffA64AC9", "|cff86C232", "|cff08F7FE", "|cff09FBD3", "|cffFE53BB", "|cffF5D300" }

local function getIcons(player)
	local stringIcons = "|TInterface\\icons\\"..Factions[player:GetTeam()]..":15|t".."|TInterface\\icons\\"..Classes[player:GetClass()]..":15|t".."|TInterface\\icons\\Achievement_character_"..Races[player:GetRace()].."_"..Genders[player:GetGender()]..":15|t"
	return stringIcons
end

local function OnLogin(_, player)
	local icons = getIcons(player)
	local Color = Colors[math.random(1,#Colors)]
	SendWorldMessage(Color.."Neuer Charakter |cff34e5eb|Hplayer:"..player:GetName().."|h"..player:GetName().."|h"..Color.." ["..icons.."]".." hat das Licht er Welt erblickt!|r")
end 
RegisterPlayerEvent(30, OnLogin)