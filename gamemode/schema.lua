CAKE.Schemas = {  }
CAKE.Schemafile = {  }

//We're now making the global schema load outside the schema folder

function CAKE.LoadGlobalSchema()

	CAKE.DayLog( "script.txt", "Loading global schema" )

	-- Load the entities
	CAKE.AddSchemaEntities("global", nil, true)

	-- Use the new plugin system

	CAKE.LoadPlugin( "global", nil, true )

	-- Load the items
	-- local list = file.FindInLua( CAKE.Name .. "/gamemode/items/*.lua" )
	local list = file.Find( CAKE.Name .. "/gamemode/items/*.lua", "LUA" )
	
	for k, v in pairs( list ) do 
	
		CAKE.LoadItem( "global", v, true )
		
	end
	
	-- Load right click files.
	local files, folders = file.Find( CAKE.Name .. "/gamemode/rclick/*.lua", "LUA" )
	
	-- for k, v in pairs( list ) do
	for k, v in pairs( files ) do
	
		CAKE.LoadRClick( "global", v, true )
		
	end

	//Legacy support here
	if file.Exists(CAKE.Name .. "/gamemode/schemas/global.lua", "LUA") then
		SCHEMA = {  }
		
		include( "schemas/global.lua"  )
	
		CAKE.DayLog( "script.txt", "Loading schema " .. SCHEMA.Name .. " by " .. SCHEMA.Author .. " ( " .. SCHEMA.Description .. " )" )
		
		local path = CAKE.Name .. "/gamemode/schemas/global/configuration.lua"
		
		if file.Exists( path, "LUA" ) then
			
			AddCSLuaFile(path)
			include(path)
			
		end

		-- Load the entities
		CAKE.AddSchemaEntities("global")


		-- Use the new plugin system
		CAKE.LoadPlugin( "global" )
	
		-- Load the items
		local list = file.Find( CAKE.Name .. "/gamemode/schemas/global/items/*.lua", "LUA" )
		
		for k, v in pairs( list ) do 
		
			CAKE.LoadItem( "global", v )
			
		end
		
		-- Load right click files.

		local files, folders = file.Find( CAKE.Name .. "/gamemode/schemas/global/rclick/*.lua", "LUA" )
		
		-- for k, v in pairs( list ) do
		for k, v in pairs( files ) do
		
			CAKE.LoadRClick( "global", v )
			
		end
	end

end

function CAKE.LoadSchema( schema )

	if schema == "global" then
		CAKE.LoadGlobalSchema()
		return
	end

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
	
	local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/configuration.lua"
	
	if file.Exists( path, "LUA" ) then
		
		AddCSLuaFile(path)
		include(path)
		
	end
	
	-- Load the entities
	CAKE.AddSchemaEntities(schema)

	-- Use the new plugin system

	CAKE.LoadPlugin( schema )

	-- Load the items
	-- local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/items/*.lua" )
	local list = file.Find( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/items/*.lua", "LUA" )
	
	for k, v in pairs( list ) do 
	
		CAKE.LoadItem( schema, v )
		
	end
	
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