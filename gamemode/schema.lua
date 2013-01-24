CAKE.Schemas = {  }
CAKE.Schemafile = {  }

function CAKE.LoadSchema( schema )

	local path = "schemas/" .. schema .. ".lua"
	
	SCHEMA = {  }
	
	include( path )
	table.insert( CAKE.Schemas, SCHEMA )

	-- Load the base, first.

	if( SCHEMA.Base ) then
	
		CAKE.LoadSchema( SCHEMA.Base )
		
	end
	
	table.insert( CAKE.Schemafile, schema )
	CAKE.DayLog( "script.txt", "Loading schema " .. SCHEMA.Name .. " by " .. SCHEMA.Author .. " ( " .. SCHEMA.Description .. " )" )


	-- Use the new plugin system

	CAKE.LoadPlugin( schema )

	-- Load the items
	-- local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/items/*.lua" )
	local list = file.Find( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/items/*.lua", "LUA" )
	
	for k, v in pairs( list ) do 
	
		CAKE.LoadItem( schema, v )
		
	end

	-- Use the new plugin system

	CAKE.LoadPlugin( schema )
	
	-- Load right click files.
	
	-- local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua" ) or {}
	-- local list = file.Find( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua", "LUA" ) or {}
local files, folders = file.Find( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua", "LUA" )
	
	-- for k, v in pairs( list ) do
	for k, v in pairs( files ) do
	
		CAKE.LoadRClick( schema, v )
		
	end
	
end

--Makes schemas run their SetUp function
function CAKE.InitSchemas( )

	for _, SCHEMA in ipairs( CAKE.Schemas ) do
		-- if !file.Exists( CAKE.Name .. "/" .. SCHEMA.Name .. ".txt" ) then
		if ( !file.Exists( CAKE.Name .. "/" .. SCHEMA.Name .. ".txt", "DATA" ) ) then
			print( "Initializing " .. SCHEMA.Name )
			file.Write( CAKE.Name .. "/" .. SCHEMA.Name .. ".txt", "" )
			SCHEMA.SetUp( )
		end
	end
	
end