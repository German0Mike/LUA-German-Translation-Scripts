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
print("->LUA-Skript: Verzauberin...geladen!")
--[[ fixed gold cost
added menu to showup before enchant displaying cost of enchant

]]
-- npcid -- You can change this to any id as you pleased!
-- price = 5 * 10000 -- 5 gold this will change for the price that show up aswell for accept or cancel enc


local enchanterG = {
    npcid = 700004,
    price = 50 * 10000
}

local GOSSIP_EVENT_ON_HELLO = 1
local GOSSIP_EVENT_ON_SELECT = 2

local T = {
    ["Menu"] = {
        {"Kopf", 0},
        {"Schulter", 2},
        {"Rüstung", 4},
        {"Beine", 6},
        {"Schuhe", 7},
        {"Armschienen", 8},
        {"Handschuhe", 9},
        {"Umhang", 14},
        {"Haupthandwaffe", 15},
        {"Zweihandwaffe", 151},
        {"Zweithandwaffe", 16},
        {"Schild", 161},
        {"Fernkampfwaffe", 171}
    },
    [0] = {
        -- Headpiece
        {"Arkanum der brennenden Mysterien", 3820, false},
        {"Arkanum der glückseligen Besserung", 3819, false},
        {"Arkanum des tapferen Beschützers", 3818, false},
        {"Arkanum der Qualen", 3817, false},
        {"Arkanum des grausamen Gladiators", 3842, false},
        {"Arkanum des Triumphs", 3795, false},
        {"Arkanum der Dominanz", 3797, false}
    },
    [2] = {
        -- Shoulders
        {"Inschrift des Triumphs", 3793, false},
        {"Inschrift der Vorherrschaft", 3794, false},
        {"Große Inschrift des Gladiators", 3852, false},
        {"Große Inschrift der Axt", 3808, false},
        {"Große Inschrift des Fels", 3809, false},
        {"Große Inschrift des Turms", 3811, false},
        {"Große Inschrift der Stürme", 3810, false}
    },
    [4] = {
        -- Chest
        {"Formel: Brust - Gewaltige Werte", 3832, false},
        {"Formel: Brust - Super Gesundheit", 3297, false},
        {"Formel: Brust - Gewaltige Manaregenation", 2381, false},
        {"Formel: Brust - Außergewöhnliche Abhärtung", 3245, false},
        {"Formel: Brust - Riesen Verteidigung", 1953, false}
    },
    [6] = {
        -- Legs
        {"Irdene Beinrüstung", 3853, false},
        {"Frostbalgbeinrüstung", 3822, false},
        {"Eisschuppenbeinrüstung", 3823, false},
        {"Glänzender Zauberfaden", 3719, false},
        {"Saphirfarbener Zauberfaden", 3721, false}
    },
    [7] = {
        -- Boots
        {"Großer Sturmangriff", 1597, false},
        {"Vitalität der Tuskarr", 3232, false},
        {"Überragende Beweglichkeit", 983, false},
        {"Große Seelenstärke", 1147, false},
        {"Größere Ausdauer", 3244, false},
        {"Eiswanderer", 3826, false},
        {"Große Seelenstärke", 1075, false}
    },
    [8] = {
        -- Bracers
        {"Erhebliche Ausdauer", 3850, false},
        {"Erhebliche Zauberkraft", 2332, false},
        {"Großer Sturmangriff", 3845, false},
        {"Erhebliche Willenskraft", 1147, false},
        {"Waffenkunde", 3231, false},
        {"Großer Sturmangriff", 2661, false},
        {"Außergewöhnliche Intelligenz", 1119, false}
    },
    [9] = {
        -- Gloves
        {"Handschuhe - Große Sprengkraft", 3249, false},
        {"Handschuhe - Waffenmeister", 3253, false},
        {"Handschuhe - Zermalmer", 1603, false},
        {"Handschuhe - Beweglichkeit", 3222, false},
        {"Handschuhe - Präzision", 3234, false},
        {"Handschuhe - Waffenkundee", 3231, false},
        {"Handschuhe - Außergewöhnliche Zaubermacht", 3246, false}
    },
    [14] = {
        -- Cloak
        {"Umhang - Schattenrüstung", 3256, false},
        {"Umhang - Weisheit", 3296, false},
        {"Umhang - Titangewebe", 1951, false},
        {"Umhang - Großes Tempo", 3831, false},
        {"Umhang - Mächtige Rüstung", 3294, false},
        {"Umhang - Erhebliche Beweglichkeit", 1099, false},
        {"Umhang - Zauberstoß", 1262, false}
    },
    [15] = {
        -- Main Hand
        {"Waffe - Titanwächter", 3851, false},
        {"Waffe - Präzision", 3788, false},
        {"Waffe - Berserker", 3789, false},
        {"Waffe - Schwarzmagie", 3790, false},
        {"Waffe - Mächtige Zaubermacht", 3834, false},
        {"Waffe - Überragende Potenz", 3833, false},
        {"Waffe - Eisbrecher", 3239, false},
        {"Waffe - Lebensschutz", 3241, false},
        {"Waffe - Blutsauger", 3870, false},
        {"Waffe - Klingenbarrikade", 3869, false},
        {"Waffe - Außergewöhnliche Beweglichkeit", 1103, false},
        {"Waffe - Außergewöhnliche Willenskraft", 3844, false},
        {"Waffe - Scharfrichter", 3225, false},
        {"Waffe - Mungo", 2673, false}, -- Two-Handed
        {"Zweihandwaffe - Massaker", 3827, true},
        {"Zweihandwaffe - Geißelbann", 3247, true},
        {"Zweihandwaffe - Vernichter", 3251, true},
        {"Stab: Große Zaubermacht", 3854, true}
    },
    [16] = {
        -- Offhand
        {"Waffe - Titanwächter", 3851, false},
        {"Waffe - Präzision", 3788, false},
        {"Waffe - Berserker", 3789, false},
        {"Waffe - Schwarzmagie", 3790, false},
        {"Waffe - Mächtige Zaubermacht", 3834, false},
        {"Waffe - Überragende Potenz", 3833, false},
        {"Waffe - Eisbrecher", 3239, false},
        {"Waffe - Lebensschutz", 3241, false},
        {"Waffe - Blutsauger", 3870, false},
        {"Waffe - Klingenbarrikade", 3869, false},
        {"Waffe - Außergewöhnliche Beweglichkeit", 1103, false},
        {"Waffe - Außergewöhnliche Willenskraft", 3844, false},
        {"Waffe - Scharfrichter", 3225, false},
        {"Waffe - Mungo", 2673, false}, -- Two-Handed
        {"Schild - Verteidigung", 1952, true},
        {"Schild - Große Intelligenz", 1128, true},
        {"Schild - Schildblock", 2655, true},
        {"Schild - Abhärtung", 3229, true},
        {"Schild - Erhebliche Ausdaue", 1071, true},
        {"Schild - Reflektschild", 2653, true}
    },
    [17] = {
        -- Ranged
        {"Diamantgeschliffenes Linsenzielfernrohr", 3843, true},
        {"Sonnenfernrohr", 3607, true},
        {"Herzsucherfernrohr", 3608, true} -- {"Khorium Scope", 2723, false}
    }
}
local pVar = {}

function enchanterG.CanBuy(event, player)
    -- local coinage = player:GetCoinage()
    -- local setCoin player:SetCoinage( copperAmt )
    --get player coinage if dont have send message if they have it then remove it
    local coinage = player:GetCoinage()
    if coinage < enchanterG.price then
        player:SendBroadcastMessage("Das kannst du dir nicht leisten.")
        return false
    else
        player:SetCoinage(coinage - enchanterG.price)
        return true
    end
end

function enchanterG.Enchanter(event, player, object)
    pVar[player:GetName()] = nil
    for event, v in ipairs(T["Menu"]) do
        player:GossipMenuAddItem(10, "|cff182799Verzaubere:|r " .. v[1] .. ".", 0, v[2])
    end
    player:GossipSendMenu(700000, object)
end

function enchanterG.EnchanterSelect(event, player, object, sender, intid, code, menu_id)
    if (intid < 500) then
        local ID = intid
        local f
        if (intid == 161 or intid == 151 or intid == 171) then
            ID = math.floor(intid / 10)
            f = true
        end
        pVar[player:GetName()] = intid
        if (T[ID]) then
            for i, v in ipairs(T[ID]) do
                if ((not f and not v[3]) or (f and v[3])) then
                    player:GossipMenuAddItem(
                        10,
                        "|cff182799" .. v[1] .. ".",
                        0,
                        v[2],
                        nil,
                        v[1] , enchanterG.price)
                end
            end
        end
        player:GossipMenuAddItem(10, "[Zurück]", 0, 500)
        player:GossipSendMenu(700000, object)
    elseif (intid == 500) then
        enchanterG.Enchanter(event, player, object)
    elseif (intid >= 900) then
        local ID = pVar[player:GetName()]
        if (ID == 161 or ID == 151 or ID == 171) then
            ID = math.floor(ID / 10)
        end
        for k, v in pairs(T[ID]) do
            if v[2] == intid then
                local item = player:GetEquippedItemBySlot(ID)
                if item then
                    if (enchanterG.CanBuy(event, player)) then
                        if v[3] then
                            local WType = item:GetSubClass()
                            if pVar[player:GetName()] == 151 then
                                if (WType == 1 or WType == 5 or WType == 6 or WType == 8 or WType == 10) then
                                    item:ClearEnchantment(0, 0)
                                    item:SetEnchantment(intid, 0, 0)
                                else
                                    player:SendAreaTriggerMessage("Du hast keine Zweihandwaffe ausgerüstet!")
                                end
                            elseif pVar[player:GetName()] == 161 then
                                if (WType == 6) then
                                    item:ClearEnchantment(0, 0)
                                    item:SetEnchantment(intid, 0, 0)
                                else
                                    player:SendAreaTriggerMessage("Du hast kein Schild ausgerüstet!")
                                end
                            elseif pVar[player:GetName()] == 171 then
                                if (WType == 2 or WType == 3 or WType == 18) then
                                    item:ClearEnchantment(0, 0)
                                    item:SetEnchantment(intid, 0, 0)
                                else
                                    player:SendAreaTriggerMessage("Du hast keine Fernkampfwaffe ausgerüstet!")
                                end
                            end
                        else -- if not v[3]
                            item:ClearEnchantment(0)
                            item:SetEnchantment(intid, 0)
                            player:SendAreaTriggerMessage(
                                "|Cffff0000[Verzauberung]|r: " .. item:GetItemLink(0) .. " ist erfolgreich verzaubert!"
                            )
                        end
                    else -- if CanBuy(event, player)
                        player:SendAreaTriggerMessage(
                            "|Cffff0000[Verzauberung]|r: Du hast nicht genug Geld um dieses Item zu verzaubern."
                        )
                    end
                else -- if item
                    player:SendAreaTriggerMessage(
                        "|Cffff0000[Verzauberung]|r: Du hast nichts zu verzauberen in dem ausgewählten Slot!"
                    )
                end
            end
        end
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(enchanterG.npcid, 1, enchanterG.Enchanter)
RegisterCreatureGossipEvent(enchanterG.npcid, 2, enchanterG.EnchanterSelect)