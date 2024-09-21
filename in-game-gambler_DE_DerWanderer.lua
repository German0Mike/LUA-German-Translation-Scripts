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
--[[
Script Name: In-Game Gamble 
Made By: PrivateDonut
Website: wowemulation.com
Based off JadaDevs Gambling Script
]] --
print("->LUA-Skript: Lotterie...geladen!")

local npcid = 700014 -- Creature entry ID
local cost = 10000 -- Cost to gamble in copper(10000 = 1 gold, 100000 = 10 gold, 1000000 = 100 gold,)
local minamount = 1 -- Minimum amount of gold allowed
local maxamount = 100 -- Maximum amount of gold allowed
local rng = 10 -- Lower number = lower chance of winning, higher number = higher chance of winning
local multiplier = 2 -- Multiple the amount bet by 2

-- DO NOT EDIT BELOW THIS LINE, UNLESS YOU KNOW WHAT YOU'RE DOING.
local function OnGossipHello(event, player, npc)
    player:GossipMenuAddItem(
        0,
        "|TInterface\\icons\\INV_Misc_Coin_01:30:30:-20|tSpiele um Gold|r",
        0,
        1,
        "",
        "|cffffffffLotterie \n Mindestmenge : |cff00ff00 " .. minamount .. "|cffffff00  Gold\n |cffffffffMaximalmenge : |cffff0000 " .. maxamount .. "|cffffff00  Gold\n|cffffffffBenötigt diese Menge um zu spielen. : |r",
        cost
    )
    player:GossipMenuAddItem(1, "|TInterface\\icons\\Mail_GMIcon:30:30:-20|tGewinnchance : |cff3e16fa".. rng .. "%|r", 0, 3)
    player:GossipMenuAddItem(2, "|TInterface\\icons\\Spell_Shadow_SacrificialShield:30:30:-20|tLieber nicht...|r", 0, 2)
    player:GossipSendMenu(1, npc)
end

local function OnGossipSelect(event, player, npc, sender, intid, code)
    if intid == 1 then
        if tonumber(code) then
        else
            player:GossipComplete()
            return;
        end
        local bet_amount = tonumber(code) * 10000
        local max = maxamount * 10000
        local low = minamount * 10000
        player:ModifyMoney(-cost)
        if bet_amount > player:GetCoinage() then
            player:SendBroadcastMessage("Ähm, du hast nicht genug Gold, verschwinde.")
            player:GossipComplete()
        elseif bet_amount < minamount then
            player:SendBroadcastMessage("Nein, dein Gebot ist zu niedrig Die Mindestmege ist:" .. minamount .. "")
            player:GossipComplete()
        elseif bet_amount > max then
            player:SendBroadcastMessage("Dein Gebot ist viel zu hoch! Die maximale Menge ist:" .. maxamount .. "")
            player:GossipComplete()
        else
            player:ModifyMoney(-bet_amount)
            local rngwonorlost = math.random(1, 100)
            if rngwonorlost <= rng then 
                rngcolor = "|cff00ff00"
            else
                rngcolor = "|cffff0000"
            end    
            player:SendBroadcastMessage("Ziehung : " .. rngcolor .. rngwonorlost)
            if rngwonorlost <= rng then
                local amountWon = bet_amount * multiplier
                local gold = amountWon / 10000
                local currentGold = player:GetCoinage()
                local goldCap = 2147483646
                local goldCapCheck = currentGold + amountWon
                local mailSubject = "Herzlichen Glückwunsch, hier ist dein Gewinn!"
                local mailMessage = "Du hast deine Gold Kapazität erreicht, so senden wir es an dein Postfach!"
                local playerGUID = player:GetGUIDLow()
                if goldCapCheck > goldCap then
                    player:SendBroadcastMessage(
                        "|cffffff00Herzlichen Glückwunsch dein Gewinn ist |cff00ff00" .. gold .. "|cffffff00 Gold, Bitte überprüfe deine Post.|r"
                    )
                    SendMail(mailSubject, mailMessage, playerGUID, playerGUID, 61, 0, gold, 0, 0)
                elseif goldCapCheck < goldCap then
                    player:SendBroadcastMessage(string.format("|cffffff00Du hast |cff00ff00%d|cffffff00 Gold gewonnen!|r", gold))
                    player:ModifyMoney(amountWon)
                    player:GossipComplete()
                end
            elseif rngwonorlost > rng then
                player:GossipComplete()
                local lost_amount = bet_amount / 10000
                player:SendBroadcastMessage(
                    "|cffffff00Schade... Du hast die Wette verloren! Demnach werden |cffff0000" .. lost_amount .. "|cffffff00 Gold aus deiner Brieftasche entfernt.|r"
                )
            end
        end
    elseif intid == 2 then
        player:GossipComplete()
    elseif intid == 3 then
        OnGossipHello(event, player, npc)
    end
end

RegisterCreatureGossipEvent(npcid, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcid, 2, OnGossipSelect)