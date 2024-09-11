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
print("->LUA-Skript: Spielermenu (.menu)...geladen!")
local enabled = true
local command = "menu"
local hirenpcbots = true -- True is for when server uses NPC_Bots from trickerer https://github.com/trickerer/Trinity-Bots

local GMonly = false  --.menu only opens for GM
--If GMonly is true then the options below don't matter
local GMonlymail = false -- if true Only GM can Open Mail
local GMonlybank = false -- if true Only GM can Open Bank
local GMonlyah = false  -- if true Only GM can Open Auction
local GMonlyfly = true  -- if true Only GM can learn to Fly on Azeroth
--Teleports to starter areas
local TeleGMonly = false  -- if true Only GM can access teleports to starting areas
--Heirloom
local GMonlyLoom = true --Only GM get Heirloom
local morphcost = 1 --cost of morphs in Gold

local OLDLOOMSQL = [[ DROP TABLE IF EXISTS acore_world.heirloom_list;]]
WorldDBExecute(OLDLOOMSQL)

local LOOMSQL = [[ CREATE TABLE IF NOT EXISTS acore_world.heirlooms_list ( `CharID` int(10) unsigned, `CharName` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL);]]
WorldDBExecute(LOOMSQL)

local T = {
--  [classId] = {item1, item2, item3m, ...}
	[0] = {},
    [1] = {42943, 48718, 42991, 48716, 42949, 48685, 50255, 51980, 51978, 51982, 51981}, -- Warrior
    [2] = {44100, 48685, 44092, 42992, 50255, 48716, 51980, 51978, 51982, 51981}, -- Paladin
    [3] = {42946, 50255, 48677, 42991, 42950, 42944, 51965, 51964, 51963, 51962}, -- Hunter
    [4] = {42944, 48689, 42952, 42991, 50255, 51965, 51964, 51963, 51962}, -- Rogue
    [5] = {42947, 48691, 44107, 42992, 50255, 51973, 51968, 51967, 51972}, -- Priest
    [6] = {42943, 48685, 42949, 42991, 50255, 51987, 51995, 51985, 51993}, -- Death Knight
    [7] = {48716, 48716, 42992, 48677, 42950, 42951, 48683, 50255, 51965, 51964, 51963, 51962}, -- Shaman
    [8] = {42947, 48691, 44107, 42992, 50255, 51973, 51968, 51967, 51972}, -- Mage
    [9] = {42947, 48691, 44107, 42992, 50255, 51973, 51968, 51967, 51972}, -- Warlock
    [11] = {42947, 48718, 42952, 42991, 44107, 48691, 48689, 50255, 51965, 51964, 51963, 51962}, -- Druid

}


local function SKULY(eventid, delay, repeats, player)

local mingmrank = 3
local IsGM = (player:GetGMRank() >= mingmrank)

if not GMonly or IsGM then
    player:SendBroadcastMessage("|cff3399FF Du kannst auch Extrabefehle ausführen. Mit|cff00cc00 .menu |cff3399FF öffnest du ein Extramenü. Für mehr Sammelberufeloot(Z.b. Bergbau) gebe folgendes ein |cff00cc00 .ga 1 oder 2 |cff3399FF Um in dem Communitychat zu schreiben |cff00cc00 .welt Nachricht |cff3399FF ")
	end
end

local firstlogin = false

local function OnFirstLogin(event, player)
	if event == 30 then
	firstlogin = true
	end
	
	player:RegisterEvent(SKULY, 60000, 1, player)
end

local function OnLogin(event, player)
	if not firstlogin then
	player:RegisterEvent(SKULY, 20000, 1, player)
	else
	firstlogin = false
	end
end


local function getPlayerCharacterGUID(player)
    local query = CharDBQuery(string.format("SELECT guid FROM characters WHERE name='%s'", player:GetName()))

    if query then 
      local row = query:GetRow()

      return tonumber(row["guid"])
    end

    return nil
  end


  

local function Hello(event, player)
local query = WorldDBQuery(string.format("SELECT * FROM heirlooms_list WHERE CharID='%i' AND CharName='%s'", getPlayerCharacterGUID(player), player:GetName()))
player:GossipClearMenu()

	level = player:GetLevel()
	local mingmrank = 3
	local IsGM = (player:GetGMRank() >= mingmrank)
	local NotGM = (player:GetGMRank() < mingmrank)
	if not query then
	WorldDBQuery(string.format("DELETE FROM heirlooms_list WHERE CharName='%s'", player:GetName()))
	WorldDBQuery(string.format("DELETE FROM heirlooms_list WHERE CharID='%i'", getPlayerCharacterGUID(player)))
	end

	if not player:HasSpell(31700) then
	if (GMonlyfly and NotGM) then
	else
	player:GossipMenuAddItem(0, "[Flying Mount]", 0, 14)
	end
	end
	
	if (TeleGMonly and NotGM) then
	else
	player:GossipMenuAddItem(0, "Startergebiete", 0, 18)
	end
	
	if (GMonlyLoom and NotGM) or query then
	else
	player:GossipMenuAddItem(0, "Erbstücke", 0, 49)
	end

	if (NotGM and GMonlymail and GMonlybank and GMonlyah) then
	
	else
	player:GossipMenuAddItem(0, "Briefkasten und Bank", 0, 78)
	end

	player:GossipMenuAddItem(0, "Temporären NPC herbeirufen", 0, 82)
	
	if IsGM then -- 3 is GM
	player:GossipMenuAddItem(0, "GM Menu", 0, 999)
	end
	
	player:GossipMenuAddItem(0, "[Verlassen]", 0, 99)
	


player:GossipSendMenu(1, player, 100)
end


local function OnSelect(event, player, _, sender, intid, code)
player:GossipClearMenu()
		local x = player:GetX()
		local y = player:GetY()
		local z = player:GetZ()
		local o = player:GetO()
		local level = player:GetLevel()
		local currentgold = player:GetCoinage()
		local mingmrank = 3
		local IsGM = (player:GetGMRank() >= mingmrank)
		local NotGM = (player:GetGMRank() < mingmrank)
		local class = player:GetClass()
		local gold = 10000
		local map = player:GetMap()
		local mapID = map:GetMapId()
		local areaId = map:GetAreaId( x, y, z )
		local faction = player:GetFaction()
		local Target = player:GetSelection()
		local typeID
		
		if Target == nil then
		Target = player:GetSelection()
		end
		
		if Target ~= nil then
		typeID = Target:GetTypeId()
		end
		
	if(intid == 999) then	
	
	player:GossipMenuAddItem(0, "Give Gold", 0, 97, true, "You want some gold?")
	
	player:GossipMenuAddItem(0, "Spawn NPC (20 Seconds) (Zombie = 1501)", 0, 101, true, "What is the NPC ID?")
	player:GossipMenuAddItem(0, "Add Item", 0, 102, true, "What is the Item ID?")
	player:GossipMenuAddItem(0, "Set Level", 0, 103, true, "What level?")
	if level < 80 then
	player:GossipMenuAddItem(0, "Give XP", 0, 104, true, "How Much XP?")
	end
	
	player:GossipMenuAddItem(0, "Add Quest by ID", 0, 105, true, "Quest ID?")
	player:GossipMenuAddItem(0, "Complete Quest by ID", 0, 106, true, "Quest ID?")
	player:GossipMenuAddItem(0, "Summon your Class Trainer", 0, 107)
	player:GossipMenuAddItem(0, "Learn Spell", 0, 108, true, "What is the Spell ID?")
	player:GossipMenuAddItem(0, "Summon Taxi", 0, 109)
	player:GossipMenuAddItem(0, "Max All Skills", 0, 110)
	if player:HasAura( 15007 ) then
	player:GossipMenuAddItem(0, "Remove Resurrection Sickness", 0, 111)
	end
	player:GossipMenuAddItem(0, "Set Hearthstone", 0, 112)
	player:GossipMenuAddItem(0, "Set movement speed", 0, 113, true, "How fast?")
	if player:HasSpellCooldown( 8690 ) then
	player:GossipMenuAddItem(0, "Reset Hearthstone Cooldown", 0, 114)
	end
	player:GossipMenuAddItem(0, "Reset ALL Cooldowns", 0, 115)
	player:GossipMenuAddItem(0, "Back", 0, 59)
	
		player:GossipSendMenu(1, player, 100)
	end	
		
		
		
		
	if(intid == 1) then	
	player:GossipMenuAddItem(0, "[Morph by Name- "..morphcost.." Gold]", 0, 2, true, "Enter the name of the NPC")
	player:GossipMenuAddItem(0, "[Morph by NPC ID#- "..morphcost.." Gold]", 0, 3, true, "Enter the ID of the NPC")
	player:GossipMenuAddItem(0, "[Random Morph - "..morphcost.." Gold]", 0, 4)
	player:GossipMenuAddItem(0, "[Remove Morph]", 0, 13)
	player:GossipMenuAddItem(0, "Back", 0, 59)
	player:GossipSendMenu(1, player, 100)
	end
		
	if(intid == 11) then
	player:DurabilityRepairAll(false,100)
	player:SendBroadcastMessage("|cff00cc00 All of your items have been repaired!|r")
	Hello(event, player)
		return false
	end
	
	if(intid == 4) then
	local curentmodel = player:GetDisplayId()
	local defaultdisplayId = player:GetNativeDisplayId()
	local randmodel = WorldDBQuery(string.format("SELECT modelid1 FROM creature_template ORDER BY RAND() LIMIT 1"))
	
	if randmodel ~= nil then 
      local row = randmodel:GetRow()

     randmodelnumber = tonumber(row["modelid1"])
    end

	--local rand = math.random(20000,30000)
		if (currentgold >= gold*morphcost) then
			if player:GetDisplayId() ~= randmodelnumber then
            player:SetDisplayId(randmodelnumber)
			player:ModifyMoney( -gold*morphcost )
			else
			player:SetDisplayId(randmodelnumber)
			player:ModifyMoney( -gold*morphcost )
			end
			
		player:GossipComplete()

	end
	end
	
	
	if(intid == 2) then
	if code ~= nil then
	local name = code:gsub("'", "''")

	local modelname = WorldDBQuery(string.format("SELECT modelid1 FROM creature_template WHERE name='%s'", tostring(name)))
	local modelnamenum = nil
	
    if modelname ~= nil then 
      local row = modelname:GetRow()

     modelnamenum = tonumber(row["modelid1"])
    end
	
	
	if modelnamenum ~= nil then
	if (currentgold >= gold*morphcost) then
	if player:GetDisplayId() ~= modelnamenum then
	player:SetDisplayId(modelnamenum)
	player:ModifyMoney( -gold*morphcost )
	else
	player:SendAreaTriggerMessage("You are already using the "..code.." model")
	end
	else
	player:SendAreaTriggerMessage("You don't have enough gold!")
	end
	else
	player:SendAreaTriggerMessage("Invalid NPC name")
	end
	end
	player:GossipComplete()
	end
	
	if(intid == 3) then
	local getmodelid = WorldDBQuery(string.format("SELECT modelid1 FROM creature_template WHERE entry='%s'", tonumber(code)))
	local getmodelname = WorldDBQuery(string.format("SELECT name FROM creature_template WHERE entry='%s'", tonumber(code)))
	local themodelid = nil
	local themodelname = nil
	
	if code ~= nil then
	if getmodelid ~= nil then 
      local rowid = getmodelid:GetRow()
     themodelid = tonumber(rowid["modelid1"])
    end
	
	if getmodelname ~= nil then 
      local rowname = getmodelname:GetRow()

	 themodelname = tostring(rowname["name"])
    end
	
	if themodelid  ~= nil then
	if (currentgold >= gold*morphcost) then
	if player:GetDisplayId() ~= themodelid then
	player:SetDisplayId(themodelid)
	player:ModifyMoney( -gold*morphcost )
	else
	player:SendAreaTriggerMessage("You are already using the "..themodelname.." model")

	end
	else
	player:SendAreaTriggerMessage("You don't have enough gold!")
	end
	else
	player:SendAreaTriggerMessage("Invalid NPC ID #")
	end
	end
	player:GossipComplete()
	end
	
	
	
	if(intid == 13) then
	local defaultdisplayId = player:GetNativeDisplayId()
             player:SetDisplayId(defaultdisplayId)
			 Hello(event, player)
			 player:GossipComplete()
		return false
	end

	if(intid == 14) then
	--player:RemoveSpell(31700)
	--player:AddItem(987654, 1)
	
	player:LearnSpell(31700)
	
	Hello(event, player)
		return false
	end
	
	if(intid== 15) then 
		local pgid = getPlayerCharacterGUID(player)
		player:SendShowMailBox( pgid )
	end
	
	if(intid== 16) then 
	player:SendShowBank( player )
	end
	
	--[[
	if(intid== 17) then 
	player:SendAuctionMenu( player )
	end
	]]
	
	if(intid == 99) then
		player:SendAreaTriggerMessage("Good Bye!")
		player:GossipComplete()
	end
	
	
	if(intid== 18) then
	
	if IsGM then
	player:GossipMenuAddItem(0, "Tauren", 0, 69)
	player:GossipMenuAddItem(0, "Untote", 0, 70)
	player:GossipMenuAddItem(0, "Blutelfen", 0, 71)
	player:GossipMenuAddItem(0, "Orks und Trolle", 0, 72)
	player:GossipMenuAddItem(0, "Zwerge und Gnome", 0, 73)
	player:GossipMenuAddItem(0, "Nachtelfen", 0, 74)
	player:GossipMenuAddItem(0, "Draenei", 0, 75)
	player:GossipMenuAddItem(0, "Menschen", 0, 76)
	else
	
	if player:IsHorde() then
	player:GossipMenuAddItem(0, "Tauren", 0, 69)
	player:GossipMenuAddItem(0, "Untote", 0, 70)
	player:GossipMenuAddItem(0, "Blutelfen", 0, 71)
	player:GossipMenuAddItem(0, "Orks und Trolle", 0, 72)
	else
	player:GossipMenuAddItem(0, "Zwerge und Gnome", 0, 73)
	player:GossipMenuAddItem(0, "Nachtelfen", 0, 74)
	player:GossipMenuAddItem(0, "Draenei", 0, 75)
	player:GossipMenuAddItem(0, "Menschen", 0, 76)
	end
	end
	
	player:GossipMenuAddItem(0, "Zurück", 0, 59)
	player:GossipSendMenu(1, player, 100)

	end
	
	if(intid == 69) then
		player:Teleport( 1, -2921, -244, 53.33, 4.62 )
		player:GossipComplete()
	end

	if(intid == 70) then
		player:Teleport( 0, 1662, 1663, 141.89, 6.26 )
		player:GossipComplete()
	end
	if(intid == 71) then
		player:Teleport( 530, 10345, -6372, 35.89, 1.40 )
		player:GossipComplete()
	end
	
	if(intid == 72) then
		player:Teleport( 1, -601, -4266, 39, 1.79 )
		player:GossipComplete()
	end
	if(intid == 73) then
		player:Teleport( 0, -6240, 342, 383.22, 5.36 )
		player:GossipComplete()
	end
	
	
	if(intid == 74) then
		player:Teleport( 1, 10311.30, 831.46, 1326.41, 5.48 )
		player:GossipComplete()
	end
	if(intid == 75) then
		player:Teleport( 530, -3963, -13934, 100.26, 1.64 )
		player:GossipComplete()
	end
	
	if(intid == 76) then
		player:Teleport( 0, -8950, -132.50, 83.53, 0 )
		player:GossipComplete()
	end
	if(intid == 59) then
		Hello(event, player)
		return false
	end
	
if(intid== 49) then
	local bag1 = player:GetItemByPos(255, 19)
	local bag2 = player:GetItemByPos(255, 20)
	local bag3 = player:GetItemByPos(255, 21)
	local bag4 = player:GetItemByPos(255, 22)
	
	if class == 3 and bag1 ~= nil then
	player:AddItem(41600, 1)
	player:AddItem(2512, 1800)
	end
	
	
	player:LearnSpell(34091)
	player:LearnSpell(73324)
	if (class == 3) then
	player:LearnSpell(5300)
	player:LearnSpell(1579)
	end
	
		if bag1 == nil then
		player:EquipItem( 41600, 19 )
		end
		if bag2 == nil then
		player:EquipItem( 41600, 20 )
		end
		if bag3 == nil then
		player:EquipItem( 41600, 21 )
		end
		if bag4 == nil then
		player:EquipItem( 41600, 22 )
		end
		
		player:AddItem(51996, 1)
		player:AddItem(51992, 1)
		player:AddItem(51994, 1)
	
	

	for _,v in ipairs(T[class]) do
			player:RemoveItem(v, 9)
			if v == 42992 or v == 42991 or v == 42944 then
            player:AddItem(v, 2)
			else
			player:AddItem(v, 1)
			end
        end
	WorldDBExecute(string.format("INSERT INTO acore_world.heirlooms_list (CharID, CharName) VALUES ('%i', '%s')", getPlayerCharacterGUID(player), player:GetName()))
	player:GossipComplete()
	end
	
	if player:HasSpell(71342) then
	player:RemoveItem(50250, 1)
	end

	
	if(intid== 67) then
	local JunkNPCnear = player:GetNearestCreature( 80, 1669 )
	local spawnedJunk
	if JunkNPCnear == nil then
	spawnedJunk = player:SpawnCreature( 1669, x+1, y+1, z+0.5, o-3.5, 1, 140000 )
	else
	player:SendAreaTriggerMessage("NPC herbeigerufen")
	end
	player:GossipComplete()
	end
	
	if(intid== 78) then
	if (GMonlymail and NotGM) then
	else
	player:GossipMenuAddItem(0, "[Öffne Briefkasten]", 0, 15)
	end
	if (GMonlybank and NotGM) then
	else
	player:GossipMenuAddItem(0, "[Öffne Bank]", 0, 16)
	end
	--[[
	if not (GMonlyah andNotGM) then
	else
	player:GossipMenuAddItem(0, "[Open Auction House]", 0, 17)
	end
	]]
	player:GossipMenuAddItem(0, "Zurück", 0, 59)
	player:GossipSendMenu(1, player, 100)

	end
	
	
	if(intid== 98) then
	local HireNPCnear = player:GetNearestCreature( 80, 70000 )
	local spawnedHire
	if HireNPCnear == nil then
	spawnedHire = player:SpawnCreature( 70000, x+1, y+1, z+0.5, o-3.5, 1, 60000 )
	else
	player:SendAreaTriggerMessage("Botmeister")
	end
	player:GossipComplete()
	end
	
	
	
	if(intid== 117) then
	local ProfessionNPCnear = player:GetNearestCreature( 80, 8661 )
	local spawnedProfessionNPC
	if ProfessionNPCnear == nil then
	spawnedProfessionNPC = player:SpawnCreature( 8661, x+1, y+1, z+0.5, o-3.5, 1, 160000 )
	else
	player:SendAreaTriggerMessage("Auktionator")
	end
	player:GossipComplete()
	end
	
	
	
	if(intid== 119) then
	local Beastmasternear = player:GetNearestCreature( 80, 601026 )
	local spawnedBeastmasterNPC
	if Beastmasternear == nil then
	spawnedBeastmasterNPC = player:SpawnCreature( 601026, x+1, y+1, z+0.5, o-3.5, 1, 60000 )
	else
	player:SendAreaTriggerMessage("Jägermeister [Pet]")
	end
	player:GossipComplete()
	end
	
	if(intid== 120) then
	local Racialnear = player:GetNearestCreature( 80, 190000 )
	local spawnedRacialNPC
	if Racialnear == nil then
	spawnedRacialNPC = player:SpawnCreature( 190000, x+1, y+1, z+0.5, o-3.5, 1, 60000 )
	else
	player:SendAreaTriggerMessage("Teleportermeister")
	end
	player:GossipComplete()
	end
	
	if(intid== 121) then
	local Transmognear = player:GetNearestCreature( 80, 190010 )
	local spawnedTransmogNPC
	if Transmognear == nil then
	spawnedTransmogNPC = player:SpawnCreature( 190010, x+1, y+1, z+0.5, o-3.5, 1, 60000 )
	else
	player:SendAreaTriggerMessage("Transmogmeister")
	end
	player:GossipComplete()
	end
	
	
	
	if(intid== 82) then
	if hirenpcbots then
	player:GossipMenuAddItem(0, "Botmeister herbeirufen", 0, 98)
	else
	end
	player:GossipMenuAddItem(0, "Verkäufer herbeirufen ", 0, 67)
	player:GossipMenuAddItem(0, "Auktionsmeister herbeirufen", 0, 117)
	player:GossipMenuAddItem(0, "Jägermeister herbeirufen", 0, 119)
	player:GossipMenuAddItem(0, "Teleportmeister herbeirufen", 0, 120)
	player:GossipMenuAddItem(0, "Transmoger herbeirufen", 0, 121)

	
	player:GossipMenuAddItem(0, "Zurück", 0, 59)
	player:GossipSendMenu(1, player, 100)
	end
	
	
	
	if(intid== 97) then
	if code ~= nil then
	local isnum = tonumber(code)
	
	if typeID == 4 then
	if isnum then
		if isnum >= -214748 and isnum <= 214748 then
	    Target:ModifyMoney( gold*isnum )
		else
		if isnum <= -214748 then 
		player:SendAreaTriggerMessage("Value must be greater than -214748")
		end
		if isnum >= 214748 then 
		player:SendAreaTriggerMessage("Value must be less than 214748")
		end
		end
	else
	    player:SendAreaTriggerMessage(""..tostring(code).." is not a number.")
	end
	else
	player:SendAreaTriggerMessage("Target is not a Player!!")

	end
	
	end
	player:GossipComplete()
	end
	
	if(intid== 101) then
	local r = math.random(1,3)
	local spawnedCreature
	local spawnlevel = level

	spawnedCreature = player:SpawnCreature( code, x+r, y+r, z+0.6, o-3.5, 1, 15000  )
	spawnedCreature:SetLevel( spawnlevel )

	player:GossipComplete()
	end
	

	if(intid == 102) then
	if typeID == 4 then
		Target:AddItem( code, 1 )
		else
	player:SendAreaTriggerMessage("Target is not a Player!!")	
	end
		player:GossipComplete()
	end
	
	if (intid== 103) then
	Target:SetLevel( code )
	player:GossipComplete()
	end
	
	if (intid== 104) then
	if typeID == 4 then
	Target:GiveXP( code )
	else
	player:SendAreaTriggerMessage("Target is not a Player!!")	
	end
	player:GossipComplete()
	end
	
	if(intid == 105) then
	if typeID == 4 then
		Target:AddQuest( code )
	else
	player:SendAreaTriggerMessage("Target is not a Player!!")	
	end
		player:GossipComplete()
	end
	
	if(intid == 106) then
	if typeID == 4 then
		Target:CompleteQuest( code )
	else
	player:SendAreaTriggerMessage("Target is not a Player!!")	
	end
		player:GossipComplete()
	end
	
	if(intid== 107) then

	if class == 1 then
	player:SpawnCreature( 26332, x+1, y+1, z+0.5, o-3.5, 1, 120000 )
	end
	
	if class == 2 then
	player:SpawnCreature( 26327, x+1, y+1, z+0.5, o-3.5, 1, 120000 )
	end
	
	if class == 3 then
	player:SpawnCreature( 26325, x+1, y+1, z+0.5, o-3.5, 1, 120000 )
	end
	
	if class == 4 then
	player:SpawnCreature( 26329, x+1, y+1, z+0.5, o-3.5, 1, 120000 )
	end
	
	if class == 5 then
	player:SpawnCreature( 26328, x+1, y+1, z+0.5, o-3.5, 1, 120000 )
	end
	
	
	if class == 6 then
	player:SpawnCreature( 33251, x+1, y+1, z+0.5, o-3.5, 1, 120000 )
	end
	
	if class == 7 then
	player:SpawnCreature( 26330, x+1, y+1, z+0.5, o-3.5, 1, 120000 )
	end
	
	if class == 8 then
	player:SpawnCreature( 26326, x+1, y+1, z+0.5, o-3.5, 1, 120000 )
	end
	
	if class == 9 then
	player:SpawnCreature( 26331, x+1, y+1, z+0.5, o-3.5, 1, 120000 )
	end
	
	if class == 11 then
	player:SpawnCreature( 26324, x+1, y+1, z+0.5, o-3.5, 1, 120000 )
	end

	end
	
	if(intid == 108) then
	if typeID == 4 then
		Target:LearnSpell( code )
	else
	player:SendAreaTriggerMessage("Target is not a Player!!")	
	end
		player:GossipComplete()
	end

	if(intid == 109) then
		player:SpawnCreature( 37888, x+1, y+1, z+0.5, o-3.5, 1, 20000 )
		player:GossipComplete()
	end
	
	if(intid == 110) then
	if typeID == 4 then
		Target:AdvanceSkillsToMax()
	else
	player:SendAreaTriggerMessage("Target is not a Player!!")	
	end
		player:GossipComplete()
	end	
	
	if(intid == 111) then
		player:RemoveAura( 15007 )
		player:GossipComplete()
	end

	if(intid == 112) then
		player:SetBindPoint( x, y, z, map:GetMapId(), areaId )
		player:SendAreaTriggerMessage("This is your new home location!")
		player:ResetSpellCooldown( 8690, true ) --Hearthstone return spell ID 8690
		player:GossipComplete()
	end
	
	if(intid == 113) then
	if typeID == 4 then
		Target:SetSpeed( 1, code, true )
	else
	player:SendAreaTriggerMessage("Target is not a Player!!")	
	end
		player:GossipComplete()
	end
	
	if(intid == 114) then
		player:ResetSpellCooldown( 8690, true ) --Hearthstone return spell ID 8690
		player:GossipComplete()
	end
	
	if(intid == 115) then
	if typeID == 4 then
		player:ResetAllCooldowns()
	else
	player:SendAreaTriggerMessage("Target is not a Player!!")	
	end
		player:GossipComplete()
	end
	
	
	

end


local function PlrMenu(event, player, message, Type, lang)
	
	local mingmrank = 3
	
	if player ~= nil then
	local IsGM = (player:GetGMRank() >= mingmrank)
	local NotGM = (player:GetGMRank() < mingmrank)
	end
	
	if (message:lower() == command) then
		local mingmrank = 3
		if (GMonly and NotGM) then
		player:SendBroadcastMessage("|cff5af304Only a GM can use this command.|r")
		return false
		else
		Hello(event, player)
		return false
	end
	end
end


if enabled then
RegisterPlayerEvent(30, OnFirstLogin)
RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(42, PlrMenu)
RegisterPlayerGossipEvent(100, 2, OnSelect)
end
