local MODULE_NAME = "Eluna playerAnnounce"
local MODULE_VERSION = '1.0.1'
local MODULE_AUTHOR = "Mpromptu Gaming"
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
print("->LUA-Skript: Wer geht offline...geladen!")

local function getTeamColor(player)
    if player:GetTeam() == 0 then
        return "CFF00B4FF"
    else
        return "CFFFF9900"
    end
end

local function getTeamName(player)
    if player:GetTeam() == 0 then
        return "Allianz"
    else
        return "Horde"
    end
end

local function announce(player, action)
    msg = getTeamName(player).." Charakter "..player:GetName().." hat "..action.."."
    print("["..MODULE_NAME.."]: "..msg)
    SendWorldMessage("|"..getTeamColor(player)..msg.."|r")
end

local function listPlayers(player)
    player:SendBroadcastMessage("|CFF99E472Ist jetzt online:|r")
    allPlayers = GetPlayersInWorld(2)
    for k, v in pairs(allPlayers) do
        player:SendBroadcastMessage("|"..
            getTeamColor(v)..
            v:GetName()..
            " [Stufe: "..v:GetLevel()..
            " "..v:GetClassAsString().." - "..
            getTeamName(v).." - "..
            v:GetMap():GetName().."]|r")
    end
end

local function onChatMessage(event, player, msg, _, lang)
    if (msg:find('#who') == 1) then
        listPlayers(player)
        return false
    end
end

local function onLogin(event, player)
    announce(player, "die Welt betreten")
    listPlayers(player)
end

local function onLogout(event, player)
    announce(player, "die Welt verlassen")
end

RegisterPlayerEvent(18, onChatMessage)
RegisterPlayerEvent(3, onLogin)
RegisterPlayerEvent(4, onLogout)
