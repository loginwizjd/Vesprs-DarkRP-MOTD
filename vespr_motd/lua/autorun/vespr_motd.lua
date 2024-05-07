
AddCSLuaFile()

if CLIENT then
    include("motd/motd.lua")
end

if SERVER then
    AddCSLuaFile("motd/motd.lua")
    util.AddNetworkString("showMOTD")
  
    local function sendMOTD(ply)
        net.Start("showMOTD")
        net.Send(ply)
    end
  
    local function checkChatCommand(player, text, teamChat, isDead)
        if string.lower(text) == "!motd" and IsValid(player) then
            sendMOTD(player)
        end
    end
  
    hook.Add("PlayerInitialSpawn", "ShowMOTDOnInitialSpawn", sendMOTD)
    hook.Add("OnPlayerChat", "MOTDCommand", checkChatCommand)
end
