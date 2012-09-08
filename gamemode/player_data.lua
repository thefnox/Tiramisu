-- Define the table of player information. This is not used anymore, and it's here for completion.
TIRA.PlayerData = {  }

-- This is to be used only by the main player table.
TIRA.PlayerDataFields = {  }
TIRA.PlayerDataFieldTypes = {  }

-- This is to be used only by the characters table.
TIRA.CharacterDataFields = {  }
TIRA.CharacterDataFieldTypes = {  }

local meta = FindMetaTable( "Player" )

function TIRA.FormatCharString( ply )
	
	return ply:SteamID( ) .. "-" .. ply:GetNWString( "uid" )
	
end

function TIRA.CreateNewChar()
	local fieldstr = ""
	local defaultstr = ""
		-- Let's get the default fields and add them to the table.
	for fieldname, default in pairs( TIRA.PlayerDataFields ) do
		fieldstr = fieldstr .. fieldname .. ","
		defaulstr = defaultstr .. defaultstr .. ","
	end
	fieldstr = string.sub(fieldstr, 1, string.len(fieldstr) - 1 ) --Removing the last comma
	defaulstr = string.sub(defaulstr, 1, string.len(defaulstr) - 1 ) --Removing the last comma

	TIRA.Query("INSERT INTO tiramisu_chars (".. fieldstr .. ") VALUES (" .. defaultstr .. ")")
	return TIRA.GetTableMaxID("tiramisu_chars")
end

function TIRA.CharExists( uid )
	if TIRA.Query("SELECT * FROM tiramisu_chars WHERE id = "..uid ) then
		return true
	end
		
	return false
end

function TIRA.GetNextCharID()
	return TIRA.GetTableNextID("tiramisu_chars") or 1
end

-- When fieldtype is 1, it adds it to the player table.
-- When it is 2, it adds it to the character table.function TIRA.AddDataField( fieldtype, fieldname, default )
function TIRA.AddDataField( fieldtype, fieldname, default, mysqltype )
	
	if( fieldtype == 1 ) then
	
		TIRA.DayLog( "script.txt", "Adding player data field " .. fieldname .. " with default value of " .. tostring( default ) )
		TIRA.PlayerDataFields[ fieldname ] = default
		if mysqltype then TIRA.PlayerDataFieldTypes[ fieldname ] = mysqltype end

	elseif( fieldtype == 2 ) then
	
		TIRA.DayLog( "script.txt", "Adding character data field " .. fieldname .. " with default value of " .. tostring( default ) )
		TIRA.CharacterDataFields[ fieldname ] = default
		if mysqltype then TIRA.CharacterDataFieldTypes[ fieldname ] = mysqltype end

	end

end

function TIRA.HasSavedData( ply )

	if TIRA.Query("SELECT * FROM tiramisu_players WHERE steamid = '"..ply:SteamID().."'") then
		return true
	end
		
	return false
	
end

-- Load a player's data
function TIRA.LoadPlayerDataFile( ply )

	local SteamID = TIRA.FormatText( ply:SteamID( ) )
	
	TIRA.PlayerData[ SteamID ]  = {  }
	
	if( TIRA.HasSavedData( ply ) ) then	
		
		TIRA.DayLog( "script.txt", "Loading player data for " .. ply:SteamID( ) )
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for fieldname, default in pairs( TIRA.PlayerDataFields ) do
			if type(default) != "boolean" and !TIRA.GetPlayerField(ply, fieldname) then
				TIRA.DayLog( "script.txt", "Missing player data field '" .. tostring( fieldname ) .. "' in " .. ply:SteamID( ) .. ", inserting with default value of '" .. tostring(default) .. "'" )
				TIRA.SetPlayerField(ply, fieldname, default)
			end
		end
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for _, char in pairs( TIRA.GetPlayerField(ply, "characters") ) do
			for fieldname, default in pairs( TIRA.CharacterDataFields ) do
				if type(default) != "boolean" and !TIRA.GetCharField(ply, fieldname, char) then
					TIRA.DayLog( "script.txt", "Missing character data field '" .. tostring( fieldname ) .. "' in character " .. ply:SteamID( ) .. "-" .. _ .. ", inserting with default value of '" .. tostring(default) .. "'" )
					TIRA.GetCharField(ply, fieldname, default, char)
				end
			end
		end
		
	else
		
		-- Seems they don't have data. Let's create a default one for them.
		
		TIRA.DayLog( "script.txt", "Creating new data for " .. ply:SteamID( ) )
		local fieldstr = ""
		local defaultstr = ""
		
		-- Let's get the default fields and add them to the table.
		for fieldname, default in pairs( TIRA.PlayerDataFields ) do
			fieldstr = fieldstr .. fieldname .. ","
			defaulstr = defaultstr .. defaultstr .. ","
		end
		fieldstr = string.sub(fieldstr, 1, string.len(fieldstr) - 1 ) --Removing the last comma
		defaulstr = string.sub(defaulstr, 1, string.len(defaulstr) - 1 ) --Removing the last comma

		TIRA.Query("INSERT INTO tiramisu_players (".. fieldstr .. ") VALUES (" .. defaultstr .. ")")

		-- In case someone wants to make a quiz later on.
		ply.FirstTimeJoining = true
		
	end

	hook.Call( "TiramisuPostPlayerLoaded", GAMEMODE, ply, ply.FirstTimeJoining )
	
end

function TIRA.SetPlayerField( ply, fieldname, data )

	-- Check to see if this is a valid field
	if TIRA.PlayerDataFields[ fieldname ] then
		if type(TIRA.PlayerDataFields[ fieldname ]) == "table" then data = "'" .. von.serialize(data) .. "'" end
		if type(TIRA.PlayerDataFields[ fieldname ]) == "string" then data = "'" .. data .. "'" end
		if type(TIRA.PlayerDataFields[ fieldname ]) == "number" then data = tostring(data) end
		if type(TIRA.PlayerDataFields[ fieldname ]) == "boolean" then
			if data then data = 1
			else data = 0 end
		end
		TIRA.Query("UPDATE tiramisu_players SET " .. fieldname .. "=" .. data .. " WHERE steamid = '"..ply:SteamID().."'")
	end
		
end
	
function TIRA.GetPlayerField( ply, fieldname )
	
	-- Check to see if this is a valid field
	if( TIRA.PlayerDataFields[ fieldname ] ) then
		
		local query = TIRA.Query("SELECT " .. fieldname .. " FROM tiramisu_players WHERE steamid = '"..ply:SteamID().."'")
		if query then
			if type(TIRA.PlayerDataFields[ fieldname ]) == "table" then return von.deserialize(query[1]) end
			if type(TIRA.PlayerDataFields[ fieldname ]) == "string" then return tostring(query[1]) end
			if type(TIRA.PlayerDataFields[ fieldname ]) == "number" then return tonumber(query[1]) end
			if type(TIRA.PlayerDataFields[ fieldname ]) == "boolean" then return util.tobool(query[1]) end
		end 
	
	end

	return false

end

function TIRA.SetCharField( ply, fieldname, data, uid )

	if TIRA.PlayerDataFields[ fieldname ] then
		if type(TIRA.PlayerDataFields[ fieldname ]) == "table" then data = "'" .. von.serialize(data) .. "'" end
		if type(TIRA.PlayerDataFields[ fieldname ]) == "string" then data = "'" .. data .. "'" end
		if type(TIRA.PlayerDataFields[ fieldname ]) == "number" then data = tostring(data) end
		if type(TIRA.PlayerDataFields[ fieldname ]) == "boolean" then
			if data then data = 1
			else data = 0 end
		end
		TIRA.Query("UPDATE tiramisu_chars SET " .. fieldname .. "=" .. data .. " WHERE id = '".. uid or ply:GetNWString( "uid" ).."'")
	end
	
end
	
function TIRA.GetCharField( ply, fieldname, uid )
	-- Check to see if this is a valid field
	if( TIRA.PlayerDataFields[ fieldname ] ) then
		
		local query = TIRA.Query("SELECT " .. fieldname .. " FROM tiramisu_chars WHERE steamid = '".. uid or ply:GetNWString( "uid" ) .."'")
		if query then
			if type(TIRA.PlayerDataFields[ fieldname ]) == "table" then return von.deserialize(query[1]) end
			if type(TIRA.PlayerDataFields[ fieldname ]) == "string" then return tostring(query[1]) end
			if type(TIRA.PlayerDataFields[ fieldname ]) == "number" then return tonumber(query[1]) end
			if type(TIRA.PlayerDataFields[ fieldname ]) == "boolean" then return util.tobool(query[1]) end
		end 
	
	end

	return false

end

function TIRA.ResendCharData( ply ) -- Network all of the player's necessary character data
	
	ply:SetNWString( "name", TIRA.GetCharField( ply, "name" ) or "" )
	ply:SetNWString( "title", TIRA.GetCharField( ply, "title" ) or ""  )
	ply:SetNWInt( "money", TIRA.GetCharField( ply, "money" ) or 0 )

end

function TIRA.SavePlayerData( ply )
	--This function has been deprecated
end

function TIRA.RemoveCharacter( ply, id ) --Eliminates a character from the player's character list
	local characters = TIRA.GetPlayerField(ply, "characters")
	if table.HasValue(character, id) then
		for k, v in pairs(characters) do
			if v == id then table.remove(characters, k) end
		end
	end
	TIRA.SetPlayerField(ply, "characters", characters)
end

function TIRA.AddCharacter( ply, id ) --Adds a character from the player's character list
	local characters = TIRA.GetPlayerField(ply, "characters")
	if !table.HasValue(character, id) then
		table.insert(characters, id)
	end
	TIRA.SetPlayerField(ply, "characters", characters)
end