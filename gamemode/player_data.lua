-- Define the table of player information.
CAKE.PlayerData = {  }

-- This is to be used only by the main player table.
CAKE.PlayerDataFields = {  }

-- This is to be used only by the characters table.
CAKE.CharacterDataFields = {  }

local meta = FindMetaTable( "Player" )

function CAKE.FormatCharString( ply )
	
	return ply:SteamID( ) .. "-" .. ply:GetNWString( "uid" )
	
end

-- When fieldtype is 1, it adds it to the player table.
-- When it is 2, it adds it to the character table.function CAKE.AddDataField( fieldtype, fieldname, default )
function CAKE.AddDataField( fieldtype, fieldname, default )
	
	if( fieldtype == 1 ) then
	
		CAKE.DayLog( "script.txt", "Adding player data field " .. fieldname .. " with default value of " .. tostring( default ) )
		CAKE.PlayerDataFields[ fieldname ] = CAKE.ReferenceFix(default)
		
	elseif( fieldtype == 2 ) then
	
		CAKE.DayLog( "script.txt", "Adding character data field " .. fieldname .. " with default value of " .. tostring( default ) )
		CAKE.CharacterDataFields[ fieldname ] = CAKE.ReferenceFix(default)
		
		if( type( default ) == "table" ) then
			default = table.concat( default, "," )
		end
		
		if( type( default ) == "string" ) then
			default = "'" .. default .. "'"
		end
		
	end

end

function CAKE.HasSavedData( ply )

	if( file.Exists( CAKE.Name .. "/playerdata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. CAKE.FormatText( ply:SteamID() ) .. ".txt" ) ) then
		return true
	end
		
	return false
	
end

-- Load a player's data
function CAKE.LoadPlayerDataFile( ply )

	local SteamID = CAKE.FormatText( ply:SteamID( ) )
	
	CAKE.PlayerData[ SteamID ]  = {  }
	
	if( CAKE.HasSavedData( ply ) ) then	
		
		CAKE.DayLog( "script.txt", "Loading player data file for " .. ply:SteamID( ) )
		
		-- Read the data from their data file
		local Data_Raw = file.Read( CAKE.Name .. "/playerdata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. CAKE.FormatText( ply:SteamID() ) .. ".txt" )
		
		-- Convert the data into a table
		local Data_Table = CAKE.NilFix(glon.decode( Data_Raw ), { })
		
		-- Insert the table into the data table
		CAKE.PlayerData[ SteamID ] = Data_Table
		
		-- Retrieve the data table for easier access
		local PlayerTable = CAKE.PlayerData[ SteamID ]
		local CharTable = CAKE.PlayerData[ SteamID ][ "characters" ]

		-- If any values were loaded and they aren't in the DataFields table, delete them from the player.
		for _, v in pairs( PlayerTable ) do
			
			if( CAKE.PlayerDataFields[ _ ] == nil ) then
			
				CAKE.DayLog( "script.txt", "Invalid player data field '" .. tostring( _ ) .. "' in " .. ply:SteamID( ) .. ", removing." )
				CAKE.PlayerData[ SteamID ][ _ ] = nil
				
			end
			
		end
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for fieldname, default in pairs( CAKE.PlayerDataFields ) do
			
			if( PlayerTable[ fieldname ] == nil ) then
			
				CAKE.DayLog( "script.txt", "Missing player data field '" .. tostring( fieldname ) .. "' in " .. ply:SteamID( ) .. ", inserting with default value of '" .. tostring(default) .. "'" )
				CAKE.PlayerData[ SteamID ][ fieldname ] = CAKE.ReferenceFix(default)
				
			end
			
		end
		
		-- If any values were loaded and they aren't in the DataFields table, delete them from the character.
		for _, char in pairs( CharTable ) do
		
			for k, v in pairs( char["inventory"] ) do
				if type(v) == "string" then
					char["inventory"][k] = {v, CAKE.CreateItemID()}
				else
					break
				end
			end

			for k, v in pairs( char ) do

				if( CAKE.CharacterDataFields[ k ] == nil ) then
				
					CAKE.DayLog( "script.txt", "Invalid character data field '" .. tostring( _ ) .. "' in character " .. ply:SteamID( ) .. "-" .. _ .. ", removing." )
					CAKE.PlayerData[ SteamID ][ "characters" ][ _ ][ k ] = nil
					
				end
				
			end
			
		end
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for _, char in pairs( CharTable ) do
			
			for fieldname, default in pairs( CAKE.CharacterDataFields ) do
			
				if( char[ fieldname ] == nil ) then
				
					CAKE.DayLog( "script.txt", "Missing character data field '" .. tostring( fieldname ) .. "' in character " .. ply:SteamID( ) .. "-" .. _ .. ", inserting with default value of '" .. tostring(default) .. "'" )
					CAKE.PlayerData[ SteamID ][ "characters" ][ _ ][ fieldname ] = CAKE.ReferenceFix(default)
					
				end
				
			end
			
		end
		
		CAKE.SavePlayerData(ply)
		
	else
		
		-- Seems they don't have a player table. Let's create a default one for them.
		
		CAKE.DayLog( "script.txt", "Creating new data file for " .. ply:SteamID( ) )
		
		CAKE.PlayerData[ SteamID ] = {  }
		
		-- Let's get the default fields and add them to the table.
		for fieldname, default in pairs( CAKE.PlayerDataFields ) do
			
			if( CAKE.PlayerData[ fieldname ] == nil ) then
			
				CAKE.PlayerData[ SteamID ][ fieldname ] = CAKE.ReferenceFix(default)
				
			end
			
		end

		-- In case someone wants to make a quiz later on.
		ply.FirstTimeJoining = true
		
		-- We won't make a character, obviously. That is done later.
		CAKE.SavePlayerData(ply)
		
	end
	
end

function CAKE.ResendCharData( ply ) -- Network all of the player's character data

	local SteamID = CAKE.FormatText( ply:SteamID() )
	
	if( CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ] == nil ) then
		return
	end

	ply:SetNWString( "name", CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ "name" ] or "" )
	ply:SetNWString( "title", CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ "title" ] or "" )
	-- ply:SetNWInt( "money", tonumber( CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ "money" ] ) or 0 )

	umsg.Start("ClearReceivedChars", ply)
	umsg.End()
	for k, v in pairs( CAKE.PlayerData[ SteamID ][ "characters" ] ) do -- Send them all their characters for selection
		if v then
			umsg.Start( "ReceiveChar", ply )
				umsg.Long( tonumber(k) )
				umsg.String( v[ "name" ] )
				umsg.String( v[ "model" ] )
				umsg.String( v[ "title" ] )
			umsg.End( )
		end
	end

	umsg.Start( "DisplayCharacterList" , ply )
	umsg.End()
	
end

function CAKE.SetPlayerField( ply, fieldname, data )

	local SteamID = CAKE.FormatText( ply:SteamID() )
	-- Check to see if this is a valid field
	if( CAKE.PlayerDataFields[ fieldname ] ) then
	
		CAKE.PlayerData[ SteamID ][ fieldname ] = data
		CAKE.SavePlayerData(ply)
	
	else

		return ""
	
	end
		
	
end
	
function CAKE.GetPlayerField( ply, fieldname )

	local SteamID = CAKE.FormatText( ply:SteamID() )
	
		-- Check to see if this is a valid field
		if( CAKE.PlayerDataFields[ fieldname ] ) then
		
			return CAKE.NilFix(CAKE.PlayerData[ SteamID ][ fieldname ], "")
		
		else
	
			return ""
		
		end
end

function CAKE.SetCharField( ply, fieldname, data )

	local SteamID = CAKE.FormatText( ply:SteamID() )
	-- Check to see if this is a valid field
	if( CAKE.CharacterDataFields[ fieldname ] ) then

		CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] = data
		CAKE.SavePlayerData(ply)
		
	else

		return ""
	
	end
		
end
	
function CAKE.GetCharField( ply, fieldname )
	-- Check to see if this is a valid field
	if( CAKE.CharacterDataFields[ fieldname ] ) then
		if CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ] and CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ] and CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ][ ply:GetNWString( "uid", "" ) ] then
			if CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ][ ply:GetNWString( "uid", "" ) ][ fieldname ] then
				return CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ][ ply:GetNWString( "uid", "" ) ][ fieldname ]
			else
				--Field is not yet set.
				CAKE.SetCharField( ply, fieldname, CAKE.CharacterDataFields[ fieldname ])
				return CAKE.CharacterDataFields[ fieldname ]
			end
		else
			--Character not loaded, return default
			return CAKE.CharacterDataFields[ fieldname ]
		end
	else
		return false
	end
end

function CAKE.SavePlayerData( ply )
	if ValidEntity( ply ) then
		local keys = glon.encode(CAKE.PlayerData[CAKE.FormatText( ply:SteamID() )])
		file.Write( CAKE.Name .. "/playerdata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. CAKE.FormatText( ply:SteamID() ) .. ".txt" , keys)
	end
end

function CAKE.RemoveCharacter( ply, id )
	local SteamID = CAKE.FormatText( ply:SteamID() )
	table.Empty( CAKE.PlayerData[ SteamID ][ "characters" ][ id ] )
	CAKE.PlayerData[ SteamID ][ "characters" ][ id ] = nil
	CAKE.SavePlayerData( ply )
	CAKE.ResendCharData( ply )
end
