if isServer() then return end

local function SendPlayerData()
    local player = getPlayer()
    local descriptor = player:getDescriptor()
    local username = player:getUsername()
    local playerData = {
        username = username,
        steamID = getSteamIDFromUsername(username),
        charName = descriptor:getForename() .. " " .. descriptor:getSurname(),
        profession = descriptor:getProfession(),
        isAlive = player:isAlive(),
        zombieKills = player:getZombieKills(),
        survivorKills = player:getSurvivorKills(),
        hoursSurvived = player:getHoursSurvived(),
        skills = {}
    }

    for i = 0, PerkFactory.PerkList:size() - 1 do
        local perk = PerkFactory.PerkList:get(i)
        playerData.skills[perk:getName()] = player:getPerkLevel(perk)
    end

    print("SPDClient: Sending " .. username .. " data to server!")
    sendClientCommand(player, "PlayerExportData", "SendPlayerData", playerData)
end

Events.EveryTenMinutes.Add(SendPlayerData)
Events.OnPlayerDeath.Add(SendPlayerData) 
