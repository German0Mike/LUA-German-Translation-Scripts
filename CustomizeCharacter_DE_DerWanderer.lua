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
print("->LUA-Skript: Charaktertools...geladen!")
local NPC_ID = 700005

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Neues Aussehen", 0, 1)
    player:GossipMenuAddItem(0, "Rasse wechseln", 0, 4)
    player:GossipMenuAddItem(0, "Fraktion wechseln", 0, 7)
    player:GossipSendMenu(1, object, NPC_ID)
end

local function OnGossipSelect(event, player, object, sender, intid, code)
    if (intid == 1) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "Ja ich möchte mein Aussehen verändern.", 0, 2)
        player:GossipMenuAddItem(0, "Nein, abbrechen!", 0, 3)
        player:GossipSendMenu(1, object, NPC_ID)
    elseif (intid == 2) then
        local name = player:GetName()
        player:SendBroadcastMessage("Customization option selected. Please log out and back in.")
        player:SetAtLoginFlag(8) -- Set the "Customize Character" flag
        player:GossipComplete()
    elseif (intid == 3) then
        player:SendBroadcastMessage("Neues aussehen abgebrochen.")
        player:GossipComplete()
    elseif (intid == 4) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "Ja ich möchte die Rasse wechseln", 0, 5)
        player:GossipMenuAddItem(0, "Nein, abbrechen!", 0, 6)
        player:GossipSendMenu(1, object, NPC_ID)
    elseif (intid == 5) then
        local name = player:GetName()
        player:SendBroadcastMessage("Rassenwechseln wurde aktiviert. Einmal ausloggen bitte!")
        player:SetAtLoginFlag(128) -- Set the "Change Race" flag
        player:GossipComplete()
    elseif (intid == 6) then
        player:SendBroadcastMessage("Rassenwechsel abgebrochen.")
        player:GossipComplete()
    elseif (intid == 7) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "Ja ich möchte die Fraktion wechseln", 0, 8)
        player:GossipMenuAddItem(0, "Nein, abbrechen!", 0, 9)
        player:GossipSendMenu(1, object, NPC_ID)
    elseif (intid == 8) then
        local name = player:GetName()
        player:SendBroadcastMessage("Fraktionswechsel wurde aktiviert. Einmal ausloggen bitte!")
        player:SetAtLoginFlag(64) -- Set the "Change Faction" flag
        player:GossipComplete()
    elseif (intid == 9) then
        player:SendBroadcastMessage("Fraktionswechsel abgebrochen.")
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(NPC_ID, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)
