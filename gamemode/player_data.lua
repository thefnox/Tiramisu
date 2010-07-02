-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- player_data.lua
-- Handles player data and such.
-------------------------------

-- Define the table of player information.
CAKE.PlayerData = {  };

-- This is to be used only by the main player table.
CAKE.PlayerDataFields = {  };

-- This is to be used only by the characters table.
CAKE.CharacterDataFields = {  };

local meta = FindMetaTable( "Player" );

function CAKE.FormatCharString( ply )
	
	return ply:SteamID( ) .. "-" .. ply:GetNWString( "uid" );
	
end

-- This formats a player's SteamID for things such as data file names
-- For example, STEAM_0:1:5947214 would turn into 015947214
function CAKE.FormatSteamID( SteamID )

	local SteamID = CAKE.NilFix(SteamID, "STEAM_0:0:0");

	s = string.gsub( SteamID,"STEAM","" );
	s = string.gsub( s,":","" );
	s = string.gsub( s,"_","" );
	
	return s;
	
end

-- When fieldtype is 1, it adds it to the player table.
-- When it is 2, it adds it to the character table.function CAKE.AddDataField( fieldtype, fieldname, default )
function CAKE.AddDataField( fieldtype, fieldname, default )
	local mysqltype = ""
	local delay = 1
	
	if( fieldtype == 1 ) then
	
		CAKE.DayLog( "script.txt", "Adding player data field " .. fieldname .. " with default value of " .. tostring( default ) );
		CAKE.PlayerDataFields[ fieldname ] = CAKE.ReferenceFix(default);
		if( CAKE.MySQLSelfBuild and CAKE.UseMySQL ) then
		
			if( type( default ) == "number" or "integer" or "float" or "int" ) then
				mysqltype = "INT(11)"		
			end
			
			if( type( default ) == "table" ) then
		
				mysqltype = "TEXT" 
				
			end
			
			if( type( default ) == "string" ) then
			
					mysqltype = "VARCHAR(64)"
		
			end
			
			timer.Simple( CAKE.MySQLAutoBuildDelay, MySQLQuery, "ALTER TABLE ti_users ADD COLUMN " .. mysql.escape( CAKE.DB, fieldname ) .. " " .. mysqltype )
		end
		
		if( CAKE.UseMySQL and fieldname ~= "characters" ) then
		
			if( type( default ) == "table" ) then
				default = table.concat( default, "," )
			end
		
			if( type( default ) == "string" ) then
				default = "'" .. default .. "'"
			end
			
			if( default == "" ) then
				default = "' '"
			end
			
			--This is so we don't have to call a for loop every time we want to fetch all the columns and all the values in a single string.
			table.insert( CAKE.MySQLPlayerColumns, "'" .. tostring( fieldname ) .. "'" )
			table.insert( CAKE.MySQLDefaultPlayerValues, tostring( default ) )
			
		end
		
	elseif( fieldtype == 2 ) then
	
		CAKE.DayLog( "script.txt", "Adding character data field " .. fieldname .. " with default value of " .. tostring( default ) );
		CAKE.CharacterDataFields[ fieldname ] = CAKE.ReferenceFix(default);
		if( CAKE.MySQLSelfBuild and CAKE.UseMySQL ) then
			if( type( default ) == "number" or "integer" or "float" or "int" ) then
				mysqltype = "INT(11)"		
			end
			
			if( type( default ) == "table" ) then
		
				mysqltype = "TEXT" 
				
			end	
			
			
			if( type( default ) == "string" ) then
			
				mysqltype = "VARCHAR(64)"
		
			end
			
			timer.Simple( CAKE.MySQLAutoBuildDelay , MySQLQuery, "ALTER TABLE ti_chars ADD COLUMN " .. mysql.escape( CAKE.DB, fieldname ) .. " " .. mysqltype )
		end
		
		if( type( default ) == "table" ) then
			default = table.concat( default, "," )
		end
		
		if( type( default ) == "string" ) then
			default = "'" .. default .. "'"
		end
		
			table.insert( CAKE.MySQLCharColumns, tostring( fieldname ) )
			table.insert( CAKE.MySQLDefaultCharValues, tostring( default ) )
		
	end
	CAKE.MySQLAutoBuildDelay  = CAKE.MySQLAutoBuildDelay  + 1
end

function CAKE.HasSavedData( ply )

	if( file.Exists( CAKE.Name .. "/PlayerData/" .. CAKE.ConVars[ "Schema" ] .. "/" .. CAKE.FormatSteamID( ply:SteamID() ) .. ".txt" ) ) then
		return true
	end
		
	return false
	
end

-- Load a player's data
function CAKE.LoadPlayerDataFile( ply )

	local SteamID = CAKE.FormatSteamID( ply:SteamID( ) );
	
	CAKE.PlayerData[ SteamID ]  = {  };
	
	if( CAKE.HasSavedData( ply ) ) then	
	
		if( CAKE.UseMySQL ) then
			CAKE.LoadMySQLPlayerData( ply )
		end
	
		CAKE.CallHook( "LoadPlayerDataFile", ply );
		
		CAKE.DayLog( "script.txt", "Loading player data file for " .. ply:SteamID( ) );
		
		-- Read the data from their data file
		local Data_Raw = file.Read( CAKE.Name .. "/PlayerData/" .. CAKE.ConVars[ "Schema" ] .. "/" .. CAKE.FormatSteamID( ply:SteamID() ) .. ".txt" );
		
		-- Convert the data into a table
		local Data_Table = CAKE.NilFix(glon.decode( Data_Raw ), { });
		
		-- Insert the table into the data table
		CAKE.PlayerData[ SteamID ] = Data_Table;
		
		-- Retrieve the data table for easier access
		local PlayerTable = CAKE.PlayerData[ SteamID ];
		local CharTable = CAKE.PlayerData[ SteamID ][ "characters" ];

		-- If any values were loaded and they aren't in the DataFields table, delete them from the player.
		for _, v in pairs( PlayerTable ) do
			
			if( CAKE.PlayerDataFields[ _ ] == nil ) then
			
				CAKE.DayLog( "script.txt", "Invalid player data field '" .. tostring( _ ) .. "' in " .. ply:SteamID( ) .. ", removing." );
				CAKE.PlayerData[ SteamID ][ _ ] = nil;
				
			end
			
		end
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for fieldname, default in pairs( CAKE.PlayerDataFields ) do
			
			if( PlayerTable[ fieldname ] == nil ) then
			
				CAKE.DayLog( "script.txt", "Missing player data field '" .. tostring( fieldname ) .. "' in " .. ply:SteamID( ) .. ", inserting with default value of '" .. tostring(default) .. "'" );
				CAKE.PlayerData[ SteamID ][ fieldname ] = CAKE.ReferenceFix(default);
				
			end
			
		end
		
		-- If any values were loaded and they aren't in the DataFields table, delete them from the character.
		for _, char in pairs( CharTable ) do
		
			for k, v in pairs( char ) do
			
				if( CAKE.CharacterDataFields[ k ] == nil ) then
				
					CAKE.DayLog( "script.txt", "Invalid character data field '" .. tostring( _ ) .. "' in character " .. ply:SteamID( ) .. "-" .. _ .. ", removing." );
					CAKE.PlayerData[ SteamID ][ "characters" ][ _ ][ k ] = nil;
					
				end
				
			end
			
		end
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for _, char in pairs( CharTable ) do
			
			for fieldname, default in pairs( CAKE.CharacterDataFields ) do
			
				if( char[ fieldname ] == nil ) then
				
					CAKE.DayLog( "script.txt", "Missing character data field '" .. tostring( fieldname ) .. "' in character " .. ply:SteamID( ) .. "-" .. _ .. ", inserting with default value of '" .. tostring(default) .. "'" );
					CAKE.PlayerData[ SteamID ][ "characters" ][ _ ][ fieldname ] = CAKE.ReferenceFix(default);
					
				end
				
			end
			
		end
		
		CAKE.SavePlayerData(ply);
		
		CAKE.CallHook( "LoadedPlayerDataFile", ply, Data_Table );
		
	else
		
		-- Seems they don't have a player table. Let's create a default one for them.
		
		CAKE.DayLog( "script.txt", "Creating new data file for " .. ply:SteamID( ) );
		
		CAKE.PlayerData[ SteamID ] = {  };
		
		-- Let's get the default fields and add them to the table.
		for fieldname, default in pairs( CAKE.PlayerDataFields ) do
			
			if( CAKE.PlayerData[ fieldname ] == nil ) then
			
				CAKE.PlayerData[ SteamID ][ fieldname ] = CAKE.ReferenceFix(default);
				
			end
			
		end
		
		-- We won't make a character, obviously. That is done later.
		
		if( CAKE.UseMySQL ) then
			CAKE.CreateMySQLPlayerData( ply )
		end
		
		CAKE.SavePlayerData(ply);
		
		-- Technically, we didn't load it, but the data is now there.
		CAKE.CallHook( "LoadedPlayerDataFile", ply, Data_Table );
		
	end
	
end

function CAKE.ResendCharData( ply ) -- Network all of the player's character data

	local SteamID = CAKE.FormatSteamID( ply:SteamID() );
	
		if( CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ] == nil ) then
			return;
		end
	
		for fieldname, data in pairs( CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ] ) do
		
			if( type( data ) != "table" ) then
			
				ply:SetNWString( fieldname, tostring( data ) );
			
			end

		end
	
end

function CAKE.SetPlayerField( ply, fieldname, data )

	local SteamID = CAKE.FormatSteamID( ply:SteamID() );
	if !CAKE.UseMySQL then
		-- Check to see if this is a valid field
		if( CAKE.PlayerDataFields[ fieldname ] ) then
		
			CAKE.PlayerData[ SteamID ][ fieldname ] = data;
			CAKE.SavePlayerData(ply);
		
		else
	
			return "";
		
		end
		
	else
	
		if( CAKE.PlayerDataFields[ fieldname ] ) then
			gdatabase.ThreadedQuery( "UPDATE `ti_users` SET `" .. fieldname .. "` = '" .. gdatabase.CleanString( CAKE.DB, data ) .. "' WHERE `steamid` = '" .. SteamID .. "'", CAKE.DB )
			CAKE.PlayerData[ SteamID ][ fieldname ] = data;
			CAKE.SavePlayerData(ply);
		
		else
		
			return "";
		
		end
	end
	
end
	
function CAKE.GetPlayerField( ply, fieldname )

	local SteamID = CAKE.FormatSteamID( ply:SteamID() );
	
	if( !CAKE.UseMySQL ) then
		-- Check to see if this is a valid field
		if( CAKE.PlayerDataFields[ fieldname ] ) then
		
			return CAKE.NilFix(CAKE.PlayerData[ SteamID ][ fieldname ], "");
		
		else
	
			return "";
		
		end
	else
		if( CAKE.PlayerDataFields[ fieldname ] ) then
		local field = gdatabase.ThreadedQuery( "SELECT " .. fieldname .. " FROM ti_users WHERE 'steamid' = '" .. SteamID .. "'", CAKE.DB )
	
			return CAKE.NilFix( field , "");
		 
		else
	
			return "";
		
		end
	
	end
end

function CAKE.SetCharField( ply, fieldname, data )

	local SteamID = CAKE.FormatSteamID( ply:SteamID() );
	
	if !CAKE.UseMySQL then
		-- Check to see if this is a valid field
		if( CAKE.CharacterDataFields[ fieldname ] ) then
	
			CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] = data;
			CAKE.SavePlayerData(ply);
			
		else
	
			return "";
		
		end
	else
		if( CAKE.CharacterDataFields[ fieldname ] ) then
		
			gdatabase.ThreadedQuery( "UPDATE `ti_chars` SET `" .. fieldname .. "` = '" .. gdatabase.CleanString( CAKE.DB, data ) .. "' WHERE `steamid` = '" .. SteamID .. "' AND `name` = '" .. gdatabase.CleanString( CAKE.DB, ply:GetNWString( "name" ) ) .. "'", CAKE.DB )
			CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] = data;
			CAKE.SavePlayerData(ply);
			
		else
		
			return "";
			
		end
	end
end
	
function CAKE.GetCharField( ply, fieldname )

	local SteamID = CAKE.FormatSteamID( ply:SteamID() );
	
	if ( !CAKE.UseMySQL ) then
		-- Check to see if this is a valid field
		if( CAKE.CharacterDataFields[ fieldname ] ) then
	
			return CAKE.NilFix(CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ], "");
		 
		else
	
			return "";
		
		end
	else
		if( CAKE.CharacterDataFields[ fieldname ] ) then
		local field = gdatabase.ThreadedQuery( "SELECT " .. fieldname .. " FROM ti_chars WHERE 'steamid' = '" .. SteamID .. "'", CAKE.DB )
	
			return CAKE.NilFix( field , "");
		 
		else
	
			return "";
		
		end
	end
end

function CAKE.SavePlayerData( ply )
	if CAKE.UseMySQL then
		CAKE.SaveMySQLPlayerData( ply )
		CAKE.SaveMySQLCharData( ply, ply:GetNWString( "uid" ) )
	else
		local keys = glon.encode(CAKE.PlayerData[CAKE.FormatSteamID( ply:SteamID() )]);
		file.Write( CAKE.Name .. "/PlayerData/" .. CAKE.ConVars[ "Schema" ] .. "/" .. CAKE.FormatSteamID( ply:SteamID() ) .. ".txt" , keys);
	end
end

function CAKE.RemoveCharacter( ply, id )
	local SteamID = CAKE.FormatSteamID( ply:SteamID() );
	table.Empty( CAKE.PlayerData[ SteamID ][ "characters" ][ id ] )
	CAKE.PlayerData[ SteamID ][ "characters" ][ id ] = nil;
	CAKE.SavePlayerData( ply )
	CAKE.ResendCharData( ply )
	umsg.Start( "RemoveChar", ply )
		umsg.Long( tonumber( id ) )
	umsg.End()
end
