--Reminder, this is a FUCKING mess, rewrite as soon as possible.


--All here thanks to GDatabase. Coded by MC Badass
--NOTICE, DON'T TOUCH ANYTHING HERE, EVERYTHING THAT IS HERE IS SIMPLY UTILITIES.
CAKE.UseMySQL = false --Enables MySQL saving. If set to false, everything is saved to text files
CAKE.MySQLServerIP = "127.0.0.1" --IP to your MySQL database
CAKE.MySQLUsername = "root" --Username
CAKE.MySQLPassword = "poop" --Password
CAKE.UseGDatabase = true
-- Because "steamid" isn't a field put in by Cakescript, but it is created upon table creation
CAKE.MySQLPlayerColumns = { }
CAKE.MySQLCharColumns = {}
-- This is so you can concatinate the player's steam ID later, without having to manually add the comma
CAKE.MySQLDefaultPlayerValues = {}  
CAKE.MySQLDefaultCharValues = {} --Hello if you're reading this it means you stole this gamemode, congratulations.
CAKE.MySQLAutoBuildDelay = 1 -- No touchy
CAKE.MySQLSelfBuild = false --Set this to true if you want MySQL to automatically create itself, this takes approximately 60 seconds, you should reset your server afterwards.
CAKE.GDatabaseConfig = {} --Don't touch
CAKE.GDatabaseConfig["reconnectrate"] = 10 --The amount of seconds it will take to attempt reconnection if the connection goes down
CAKE.GDatabaseConfig["concurrentthreads"] = 1 --The amount of threads processed at a single time. I recommend to not set it over 3, it affects the speed of the processing of queries, higher number means more speed, but at higher numbers it gets unstable and might crash the server.
CAKE.GDatabaseConfig["maxqueuesize"] = 100 --Amount of threads that can be listed. Increase this if you have a big server.
CAKE.GDatabaseConfig["debug"] = true --Use this if you want to see when is a thread ran and the like
if CAKE.UseMySQL then
	if CAKE.UseGDatabase then
		CAKE.DB = gdatabase.MakeConnection( CAKE.MySQLServerIP, CAKE.MySQLUsername, CAKE.MySQLPassword, "", CAKE.GDatabaseConfig )
		CAKE.MySQLRunning = gdatabase.CheckForConnection(CAKE.DB)
	else
		CAKE.DB = mysql.connect( CAKE.MySQLServerIP, CAKE.MySQLUsername, CAKE.MySQLPassword, CAKE.MySQLDatabaseName )
		CAKE.MySQLRunning = true
	end
end

local function PrintData(query, strTitleText)
	if (query == 0) then
		print("QUERY FAILED!!!")
		return
	end
	
	print(strTitleText)
	PrintTable(query)
end

function MySQLQuery( query )
	if CAKE.UseGDatabase then
			if( !string.find( query, "SELECT" ) )then --In case the results don't need to be returned, like when fetching a field. GDatabase allows for setting a callback for it, but I'll do that later.	
				gdatabase.ThreadedQuery( query, CAKE.DB, PrintData, query )
				return "";
			else
				local tbl = gdatabase.Query( query, CAKE.DB )
				return tbl;
			end	
	else
		local tbl, succ, err = mysql.query( CAKE.DB, query )
		if( !tbl )then
				return succ;
			else
				return tbl;
		end
	end
end


function CAKE.SaveMySQLPlayerData( ply )
	local fields = { }
	local SteamID = CAKE.FormatSteamID( ply:SteamID() )
	for k, v in pairs( CAKE.PlayerData[ SteamID ] ) do
		if( k == "characters" ) then
		local newtable = {}
			for n, m in pairs( CAKE.PlayerData[ SteamID ][ "characters" ] ) do -- We don't need the fields for each character saved on the player table, we just need the names.
				table.insert( newtable, CAKE.PlayerData[ SteamID ][ "characters" ][ n ][ "name" ] )
			end
			table.insert( fields, "characters = '" .. table.concat( newtable, "," ) .. "'" )
		else
			if( type( v ) == "string" ) then
				table.insert( fields, k .. "='" .. v .. "'" )
			else
				table.insert( fields, k .. "=" .. v )
			end
		end
	end
	PrintTable( fields )
	PrintTable( values )
	
	MySQLQuery( "UPDATE `ti_users` SET " .. table.concat( fields, ", " ) .. " WHERE steamid = '" .. ply:SteamID() "'" ) 
end

function CAKE.LoadMySQLPlayerData( ply )
	local stuff = MySQLQuery( "SELECT steamid," .. table.concat( CAKE.MySQLPlayerColumns, "," ) .. " WHERE steamid = '" .. ply:SteamID() .. "'" )
	print( "HEY ASSHOLE, OVER HERE!" )
	PrintTable( stuff )
end

function CAKE.SaveMySQLCharData( ply, id )
	local fields = { "'steamid'" }
	local values = { ply:SteamID() }
	local SteamID = CAKE.FormatSteamID( ply:SteamID() )
	for k, v in pairs( CAKE.PlayerData[ SteamID ][ "characters" ] ) do
		table.insert( fields, "'" .. k .. "'" )
		if( type( v ) == "table" ) then
			table.insert( values, "'" .. table.concat( v, "," ) .. "'" )
		else
			table.insert( values, "'" .. v .. "'" )
		end
	end
	PrintTable( fields )
	PrintTable( values )
end

function CAKE.CreateMySQLPlayerData( ply ) -- Whoo, more alias functions.
	MySQLQuery( "INSERT INTO ti_users( " .. "steamid," .. table.concat( CAKE.MySQLPlayerColumns, "," ) .. ") VALUES( '" .. ply:SteamID() .. "'," .. table.concat( CAKE.MySQLDefaultPlayerValues, "," ) .. ")" )
end