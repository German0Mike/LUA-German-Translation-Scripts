IndividualProgression = {}

local SELECT_SQL = "SELECT data FROM character_settings WHERE guid = %d AND source = 'mod-individual-progression'"
local UPSERT_SQL = "INSERT INTO character_settings (guid, source, data) VALUES (%d, 'mod-individual-progression', '%u') ON DUPLICATE KEY UPDATE data = VALUES(data)"
local DELETE_SQL = "DELETE FROM character_settings WHERE guid = %d AND source = 'mod-individual-progression'"

IndividualProgression.RestrictBeyondVanilla = false -- Set to false to allow progression beyond Vanilla
IndividualProgression.RestrictBeyondTBC = false     -- Set to false to allow progression beyond TBC


IndividualProgression.npcId = 50000
IndividualProgression.PlayerChangedTierKey = 1001
IndividualProgression.mainMenu = "|TInterface\\icons\\inv_helmet_74:45:45:-40|t|cff00008bEinstellung für altes WoW |r"
IndividualProgression.options = {
  "|TInterface\\icons\\achievement_boss_ragnaros:45:45:-40|t|cff8b0000Phase 1 (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_onyxia:45:45:-40|t|cff8b0000Phase 2 (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_nefarion:45:45:-40|t|cff8b0000Phase 3 (Level 60)|r",
  "|TInterface\\icons\\achievement_zone_silithus_01:45:45:-40|t|cff8b0000Phase 4 (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_cthun:45:45:-40|t|cff8b0000Phase 5 (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_kelthuzad_01:45:45:-40|t|cff8b0000Phase 6 (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_princemalchezaar_02:45:45:-40|t|cff006400Phase 7 (Level 70)|r",
  "|TInterface\\icons\\achievement_character_bloodelf_male:45:45:-40|t|cff006400Phase 8 (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_illidan:45:45:-40|t|cff006400Phase 9 (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_zuljin:45:45:-40|t|cff006400Phase 10 (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_kiljaedan:45:45:-40|t|cff006400Phase 11 (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_kelthuzad_01:45:45:-40|t|cff00008bPhase 12 (Level 80)|r",
  "|TInterface\\icons\\achievement_boss_algalon_01:45:45:-40|t|cff00008bPhase 13 (Level 80)|r",
  "|TInterface\\icons\\achievement_reputation_argentcrusader:45:45:-40|t|cff00008bPhase 14 (Level 80)|r",
  "|TInterface\\icons\\achievement_boss_lichking:45:45:-40|t|cff00008bPhase 15 (Level 80)|r",
  "|TInterface\\icons\\spell_shadow_twilight:45:45:-40|t|cff00008bPhase 16  (Level 80)"
}

IndividualProgression.optionsWithoutIcon = {
  "Phase 1 - Molten Core (Level 60)",
  "Phase 2 - Onyxia (Level 60)",
  "Phase 3 - Blackwing Lair (Level 60)",
  "Phase 4 - Pre-AQ (Level 60)",
  "Phase 5 - Anh'qiraj (Level 60)",
  "Phase 6 - Naxxramas (Level 60)",
  "Phase 7 - Karazhan, Gruul's Lair, Magtheridon's Lair (Level 70)",
  "Phase 8 - Serpentshrine Cavern, Tempest Keep (Level 70)",
  "Phase 9 - Hyjal Summit and Black Temple (Level 70)",
  "Phase 10 - Zul'Aman (Level 70)",
  "Phase 11 - Sunwell Plateau (Level 70)",
  "Phase 12 - Naxxramas WotLK, Eye of Eternity, Obsidian Sanctum (Level 80)",
  "Phase 13 - Ulduar (Level 80)",
  "Phase 14 - Trial of the Crusader",
  "Phase 15 - Icecrown Citadel (Level 80)",
  "Phase 16 - Ruby Sanctum (Level 80)"
}

function IndividualProgression.getTextWithoutIcon(option)
  local textStart = option:find("|r") + 2
  return option:sub(textStart)
end

function IndividualProgression.OnGossipHello(event, player, object)
  player:GossipMenuAddItem(0, IndividualProgression.mainMenu, 0, 1)
  player:GossipMenuAddItem(0, "|TInterface\\icons\\inv_scroll_03:45:45:-40|t |cff00008bWas ist gemeint mit <altes WoW>?|r", 0, 200)
  player:GossipSendMenu(1, object)
  object:SetEquipmentSlots(32262, 33755, 0)
  object:SendUnitSay("Sprich mit mir um darüber mehr zu erfahren.", 0)

  local guid = player:GetGUIDLow()
  local query = CharDBQuery(string.format(SELECT_SQL, guid))
  
  if query then
    local playerProgressionTier = query:GetString(0)
    if playerProgressionTier then  -- Check if the value is not nil
      playerProgressionTier = tonumber(playerProgressionTier)
      object:SendUnitWhisper("Deine aktuelle Phase ist: " .. IndividualProgression.optionsWithoutIcon[playerProgressionTier + 1], 0, player)
    end
  else
    CharDBExecute(string.format(INSERT_SQL, guid, 0))
    object:SendUnitWhisper("Du hast nichts eingestellt. Erfrage einen GM nach Hilfe.", 0, player)
  end
end

function IndividualProgression.ShowIndividualProgressionExplanation(player, object)
  player:GossipMenuAddItem(0, "Das <alte WoW> simuliert das alte WoW, wie es ursprünglich veröffentlich wurde. Es gab eine Reihe von sogenannten <Content Ptches>, welches die jeweiligen Bosse, Quest und diverses andere veröffentlich wurden nacheinander. Wenn du das originale WoW-Gefühl erleben möchtest und viel mehr Quest machen möchtest, solltest du diese Einstellung wählen. Aber beachte es kann auch schwerer sein, als du es gewohnt bist.", 0, 201)
  player:GossipMenuAddItem(0, "|TInterface\\icons\\achievement_guildperk_massresurrection:45:45:-40|t Zurück", 0, 100)
  player:GossipSendMenu(1, object)
end

IndividualProgression.PlayerTierKey = 1000

function BroadcastTimer(eventId, delay, repeats, playerGUID, secondsLeft)
  local player = GetPlayerByGUID(playerGUID)
  if player then
    if secondsLeft > 0 then
      player:SendBroadcastMessage("Du wirst ausgeloggt in " .. secondsLeft .. " Sekunden.")
    else
      player:SendBroadcastMessage("Wir sehen uns gleich wieder!")
    end
  end
end

function KickPlayerDelayed(eventId, delay, repeats, playerGUID)
  local player = GetPlayerByGUID(playerGUID)
  if player then
    player:KickPlayer()
  end
end

function IndividualProgression.OnGossipSelect(event, player, object, sender, intid, code)
  if intid == 1 then
    for i, option in ipairs(IndividualProgression.options) do
      player:GossipMenuAddItem(0, option, 0, i + 1)
    end
    player:GossipMenuAddItem(0, "|TInterface\\icons\\achievement_guildperk_massresurrection:45:45:-40|t Zurück", 0, 100)
    player:GossipSendMenu(1, object)
  elseif intid == 100 then
    player:GossipMenuAddItem(0, IndividualProgression.mainMenu, 0, 1)
    player:GossipMenuAddItem(0, "|TInterface\\icons\\inv_scroll_03:45:45:-40|t Was ist gemeint mit <altes WoW>?", 0, 200) 
    player:GossipSendMenu(1, object)
  elseif intid == 200 then
    IndividualProgression.ShowIndividualProgressionExplanation(player, object) 
  else
    local tier = intid - 2
    if tier >= 0 then
      -- Check if trying to progress beyond allowed content and if it's restricted
      local isGM = player:IsGM() -- Check if the player is a Game Master
      if not isGM then
        if IndividualProgression.RestrictBeyondVanilla and tier > 5 then
          player:SendBroadcastMessage("ERROR VANILLA.")
          player:GossipComplete()
          return
        elseif IndividualProgression.RestrictBeyondTBC and tier > 10 then
          player:SendBroadcastMessage("ERROR TBC.")
          player:GossipComplete()
          return
        end
      end
      
      player:SetUInt32Value(IndividualProgression.PlayerTierKey, tier)
      player:SetUInt32Value(IndividualProgression.PlayerChangedTierKey, 1)  
      player:GossipComplete()
      player:SendBroadcastMessage("Deine Phase wurde eingestellt auf " .. IndividualProgression.optionsWithoutIcon[intid - 1] .. " es folgt ein Logout.")
      
      local playerGUID = player:GetGUID()
      
      for i = 5, 0, -1 do
        CreateLuaEvent(function(eventId, delay, repeats) BroadcastTimer(eventId, delay, repeats, playerGUID, i) end, (5 - i) * 1000, 1)
      end
      player:SendBroadcastMessage("Du wirst in 5 Sekunden ausgeloggt, damit die Einstellungen wirksam werden.")
      CreateLuaEvent(function(eventId, delay, repeats) KickPlayerDelayed(eventId, delay, repeats, playerGUID) end, 6000, 1)
    end
  end
end

function IndividualProgression.DelayedDatabaseUpdate(eventId, delay, repeats, playerData)
  if playerData.tier >= 0 and playerData.tierChanged == 1 then
    CharDBExecute(string.format(UPSERT_SQL, playerData.guid, playerData.tier))
  end
end

function IndividualProgression.Individual_OnPlayerLogout(event, player)
    local tier = player:GetUInt32Value(IndividualProgression.PlayerTierKey)
    local tierChanged = player:GetUInt32Value(IndividualProgression.PlayerChangedTierKey)
    local guid = player:GetGUIDLow()
    local playerData = {
        tier = tier,
        tierChanged = tierChanged,
        guid = guid
    }
    CreateLuaEvent(function(eventId, delay, repeats) IndividualProgression.DelayedDatabaseUpdate(eventId, delay, repeats, playerData) end, 700, 1)
end

RegisterCreatureGossipEvent(IndividualProgression.npcId, 1, IndividualProgression.OnGossipHello)
RegisterCreatureGossipEvent(IndividualProgression.npcId, 2, IndividualProgression.OnGossipSelect)
RegisterPlayerEvent(4, IndividualProgression.Individual_OnPlayerLogout)
