if isServer() then return end

local function safeGet(itemName, func)
	local status, result = pcall(func)
	if status then
			return result or "null"
	else
			local errorMessage = "SPDClient: Error retrieving " .. itemName .. " - " .. tostring(result)
			print(errorMessage)
			sendClientCommand(getPlayer(), "PlayerExportData", "SendError", { message = errorMessage })
			return "null"
	end
end

local function SendPlayerData()
    local player = getPlayer()
    local descriptor = player:getDescriptor()
    local username = player:getUsername()
    local playerData = {
        username = username,
        steamID = safeGet("steamID", function() return getSteamIDFromUsername(username) end),
        charName = safeGet("charName", function() return (descriptor:getForename() and descriptor:getSurname()) and (descriptor:getForename() .. " " .. descriptor:getSurname()) end),
        profession = safeGet("profession", function() return descriptor:getProfession() end),
        isAlive = safeGet("isAlive", function() return player:isAlive() end),
        zombieKills = safeGet("zombieKills", function() return player:getZombieKills() end),
        survivorKills = safeGet("survivorKills", function() return player:getSurvivorKills() end),
        hoursSurvived = safeGet("hoursSurvived", function() return player:getHoursSurvived() end),
        health = safeGet("health", function() return player:getHealth() end),
        hunger = safeGet("hunger", function() return player:getStats():getHunger() end),
        thirst = safeGet("thirst", function() return player:getStats():getThirst() end),
        endurance = safeGet("endurance", function() return player:getStats():getEndurance() end),
        fatigue = safeGet("fatigue", function() return player:getStats():getFatigue() end),
				boredom = safeGet("boredom", function() return player:getStats():getBoredom() end),
				panic = safeGet("panic", function() return player:getStats():getPanic() end),
				stress = safeGet("stress", function() return player:getStats():getStress() end),
				weight = safeGet("weight", function() return player:getNutrition():getWeight() end),
				calories = safeGet("calories", function() return player:getNutrition():getCalories() end),
				carbs = safeGet("carbs", function() return player:getNutrition():getCarbohydrates() end),
				lipids = safeGet("lipids", function() return player:getNutrition():getLipids() end),
				proteins = safeGet("proteins", function() return player:getNutrition():getProteins() end),
				x = safeGet("x", function() return player:getX() end),
				y = safeGet("y", function() return player:getY() end),
				z = safeGet("z", function() return player:getZ() end),
				direction = safeGet("direction", function() return player:getDir() end),
				bodyDamage = safeGet("bodyDamage", function() return player:getBodyDamage():getOverallBodyHealth() end),
				temperature = safeGet("temperature", function() return player:getBodyDamage():getTemperature() end),
				wetness = safeGet("wetness", function() return player:getBodyDamage():getWetness() end),
				infectionLevel = safeGet("infectionLevel", function() return player:getBodyDamage():getInfectionLevel() end),
        skills = {}
    }

    for i = 0, PerkFactory.PerkList:size() - 1 do
        local perk = PerkFactory.PerkList:get(i)
        playerData.skills[perk:getName()] = safeGet("skill " .. perk:getName(), function() return player:getPerkLevel(perk) end)
    end

    print("SPDClient: Sending " .. username .. " data to server!")
    sendClientCommand(player, "PlayerExportData", "SendPlayerData", playerData)
end

Events.EveryTenMinutes.Add(SendPlayerData)
Events.OnPlayerDeath.Add(SendPlayerData)
