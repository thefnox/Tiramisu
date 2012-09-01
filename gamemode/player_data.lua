-- Define the table of player information. This is not used anymore, and it's here for completion.
CAKE.PlayerData = {  }

-- This is to be used only by the main player table.
CAKE.PlayerDataFields = {  }
CAKE.PlayerDataFieldTypes = {  }

-- This is to be used only by the characters table.
CAKE.CharacterDataFields = {  }
CAKE.CharacterDataFieldTypes = {  }

local meta = FindMetaTable( "Player" )

function CAKE.FormatCharString( ply )
	
	return ply:SteamID( ) .. "-" .. ply:GetNWString( "uid" )
	
end

function CAKE.CreateNewChar()
	local fieldstr = ""
	local defaultstr = ""
		-- Let's get the default fields and add them to the table.
	for fieldname, default in pairs( CAKE.PlayerDataFields ) do
		fieldstr = fieldstr .. fieldname .. ","
		defaulstr = defaultstr .. defaultstr .. ","
	end
	fieldstr = string.sub(fieldstr, 1, string.len(fieldstr) - 1 ) --Removing the last comma
	defaulstr = string.sub(defaulstr, 1, string.len(defaulstr) - 1 ) --Removing the last comma

	CAKE.Query("INSERT INTO tiramisu_chars (".. fieldstr .. ") VALUES (" .. defaultstr .. ")")
	return CAKE.GetTableMaxID("tiramisu_chars")
end

function CAKE.CharExists( uid )
	if CAKE.Query("SELECT * FROM tiramisu_chars WHERE id = "..uid ) then
		return true
	end
		
	return false
end

function CAKE.GetNextCharID()
	return CAKE.GetTableNextID("tiramisu_chars") or 1
end

-- When fieldtype is 1, it adds it to the player table.
-- When it is 2, it adds it to the character table.function CAKE.AddDataField( fieldtype, fieldname, default )
function CAKE.AddDataField( fieldtype, fieldname, default, mysqltype )
	
	if( fieldtype == 1 ) then
	
		CAKE.DayLog( "script.txt", "Adding player data field " .. fieldname .. " with default value of " .. tostring( default ) )
		CAKE.PlayerDataFields[ fieldname ] = default
		if mysqltype then CAKE.PlayerDataFieldTypes[ fieldname ] = mysqltype end

	elseif( fieldtype == 2 ) then
	
		CAKE.DayLog( "script.txt", "Adding character data field " .. fieldname .. " with default value of " .. tostring( default ) )
		CAKE.CharacterDataFields[ fieldname ] = default
		if mysqltype then CAKE.CharacterDataFieldTypes[ fieldname ] = mysqltype end

	end

end

function CAKE.HasSavedData( ply )

	if CAKE.Query("SELECT * FROM tiramisu_players WHERE steamid = '"..ply:SteamID().."'") then
		return true
	end
		
	return false
	
end

-- Load a player's data
function CAKE.LoadPlayerDataFile( ply )

	local SteamID = CAKE.FormatText( ply:SteamID( ) )
	
	CAKE.PlayerData[ SteamID ]  = {  }
	
	if( CAKE.HasSavedData( ply ) ) then	
		
		CAKE.DayLog( "script.txt", "Loading player data for " .. ply:SteamID( ) )
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for fieldname, default in pairs( CAKE.PlayerDataFields ) do
			if type(default) != "boolean" and !CAKE.GetPlayerField(ply, fieldname) then
				CAKE.DayLog( "script.txt", "Missing player data field '" .. tostring( fieldname ) .. "' in " .. ply:SteamID( ) .. ", inserting with default value of '" .. tostring(default) .. "'" )
				CAKE.SetPlayerField(ply, fieldname, default)
			end
		end
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for _, char in pairs( CAKE.GetPlayerField(ply, "characters") ) do
			for fieldname, default in pairs( CAKE.CharacterDataFields ) do
				if type(default) != "boolean" and !CAKE.GetCharField(ply, fieldname, char) then
					CAKE.DayLog( "script.txt", "Missing character data field '" .. tostring( fieldname ) .. "' in character " .. ply:SteamID( ) .. "-" .. _ .. ", inserting with default value of '" .. tostring(default) .. "'" )
					CAKE.GetCharField(ply, fieldname, default, char)
				end
			end
		end
		
	else
		
		-- Seems they don't have data. Let's create a default one for them.
		
		CAKE.DayLog( "script.txt", "Creating new data for " .. ply:SteamID( ) )
		local fieldstr = ""
		local defaultstr = ""
		
		-- Let's get the default fields and add them to the table.
		for fieldname, default in pairs( CAKE.PlayerDataFields ) do
			fieldstr = fieldstr .. fieldname .. ","
			defaulstr = defaultstr .. defaultstr .. ","
		end
		fieldstr = string.sub(fieldstr, 1, string.len(fieldstr) - 1 ) --Removing the last comma
		defaulstr = string.sub(defaulstr, 1, string.len(defaulstr) - 1 ) --Removing the last comma

		CAKE.Query("INSERT INTO tiramisu_players (".. fieldstr .. ") VALUES (" .. defaultstr .. ")")

		-- In case someone wants to make a quiz later on.
		ply.FirstTimeJoining = true
		
	end

	hook.Call( "TiramisuPostPlayerLoaded", GAMEMODE, ply, ply.FirstTimeJoining )
	
end

function CAKE.SetPlayerField( ply, fieldname, data )

	-- Check to see if this is a valid field
	if CAKE.PlayerDataFields[ fieldname ] then
		if type(CAKE.PlayerDataFields[ fieldname ]) == "table" then data = "'" .. von.serialize(data) .. "'" end
		if type(CAKE.PlayerDataFields[ fieldname ]) == "string" then data = "'" .. data .. "'" end
		if type(CAKE.PlayerDataFields[ fieldname ]) == "number" then data = tostring(data) end
		if type(CAKE.PlayerDataFields[ fieldname ]) == "boolean" then
			if data then data = 1
			else data = 0 end
		end
		CAKE.Query("UPDATE tiramisu_players SET " .. fieldname .. "=" .. data .. " WHERE steamid = '"..ply:SteamID().."'")
	end
		
end
	
function CAKE.GetPlayerField( ply, fieldname )
	
	-- Check to see if this is a valid field
	if( CAKE.PlayerDataFields[ fieldname ] ) then
		
		local query = CAKE.Query("SELECT " .. fieldname .. " FROM tiramisu_players WHERE steamid = '"..ply:SteamID().."'")
		if query then
			if type(CAKE.PlayerDataFields[ fieldname ]) == "table" then return von.deserialize(query[1]) end
			if type(CAKE.PlayerDataFields[ fieldname ]) == "string" then return tostring(query[1]) end
			if type(CAKE.PlayerDataFields[ fieldname ]) == "number" then return tonumber(query[1]) end
			if type(CAKE.PlayerDataFields[ fieldname ]) == "boolean" then return util.tobool(query[1]) end
		end 
	
	end

	return false

end

function CAKE.SetCharField( ply, fieldname, data, uid )

	if CAKE.PlayerDataFields[ fieldname ] then
		if type(CAKE.PlayerDataFields[ fieldname ]) == "table" then data = "'" .. von.serialize(data) .. "'" end
		if type(CAKE.PlayerDataFields[ fieldname ]) == "string" then data = "'" .. data .. "'" end
		if type(CAKE.PlayerDataFields[ fieldname ]) == "number" then data = tostring(data) end
		if type(CAKE.PlayerDataFields[ fieldname ]) == "boolean" then
			if data then data = 1
			else data = 0 end
		end
		CAKE.Query("UPDATE tiramisu_chars SET " .. fieldname .. "=" .. data .. " WHERE id = '".. uid or ply:GetNWString( "uid" ).."'")
	end
	
end
	
function CAKE.GetCharField( ply, fieldname, uid )
	-- Check to see if this is a valid field
	if( CAKE.PlayerDataFields[ fieldname ] ) then
		
		local query = CAKE.Query("SELECT " .. fieldname .. " FROM tiramisu_chars WHERE steamid = '".. uid or ply:GetNWString( "uid" ) .."'")
		if query then
			if type(CAKE.PlayerDataFields[ fieldname ]) == "table" then return von.deserialize(query[1]) end
			if type(CAKE.PlayerDataFields[ fieldname ]) == "string" then return tostring(query[1]) end
			if type(CAKE.PlayerDataFields[ fieldname ]) == "number" then return tonumber(query[1]) end
			if type(CAKE.PlayerDataFields[ fieldname ]) == "boolean" then return util.tobool(query[1]) end
		end 
	
	end

	return false

end

function CAKE.ResendCharData( ply ) -- Network all of the player's necessary character data
	
	ply:SetNWString( "name", CAKE.GetCharField( ply, "name" ) or "" )
	ply:SetNWString( "title", CAKE.GetCharField( ply, "title" ) or ""  )
	ply:SetNWInt( "money", CAKE.GetCharField( ply, "money" ) or 0 )

end

function CAKE.SavePlayerData( ply )
	--This function has been deprecated
end

function CAKE.RemoveCharacter( ply, id ) --Eliminates a character from the player's character list
	local characters = CAKE.GetPlayerField(ply, "characters")
	if table.HasValue(character, id) then
		for k, v in pairs(characters) do
			if v == id then table.remove(characters, k) end
		end
	end
	CAKE.SetPlayerField(ply, "characters", characters)
end

function CAKE.AddCharacter( ply, id ) --Adds a character from the player's character list
	local characters = CAKE.GetPlayerField(ply, "characters")
	if !table.HasValue(character, id) then
		table.insert(characters, id)
	end
	CAKE.SetPlayerField(ply, "characters", characters)
end