local function SavePlayerData(data)
    if not data then
        print("SPDServer: No data received to save.")
        return
    end

    local strHeader, strData = "", ""
    local separator = ""

    -- Build the header and data rows
    for k, v in pairs(data) do
        if k ~= "skills" then
            separator = (strHeader ~= "") and ";" or ""
            strHeader = strHeader .. separator .. k
            strData = strData .. separator .. (type(v) == "string" and "\"" .. v .. "\"" or tostring(v))
        end
    end

    -- Add skill headers and levels
    for skill, level in pairs(data.skills) do
        strHeader = strHeader .. ";" .. skill
        strData = strData .. ";" .. tostring(level)
    end

    strHeader = strHeader .. "\n"

    -- Write CSV file
    local filePath = "/PlayerExportData/" .. data.charName .. "_data.csv"
    local dataFile = getFileWriter(filePath, true, false)
    dataFile:write(strHeader)
    dataFile:write(strData)
    dataFile:close()
    print("SPDServer: Data saved to file: " .. filePath)
end

local function onClientErrorReceived(module, command, player, args)
	if module == "PlayerExportData" and command == "SendError" then
			print("SPDServer: Client error received - " .. args.message)
	end
end

Events.OnClientCommand.Add(onClientErrorReceived)

-- Executed when a client(player) sends its information to the server
local function onPlayerDataReceived(module, command, player, args)
	if module == "PlayerExportData" and command == "SendPlayerData" then
			SavePlayerData(args)
	end
end

Events.OnClientCommand.Add(onPlayerDataReceived)
