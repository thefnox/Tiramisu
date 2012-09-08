TIRA.Schemas = {  }
TIRA.Schemafile = {  }

function TIRA.LoadSchema( schema )

	local path = "schemas/" .. schema .. ".lua"
	
	SCHEMA = {  }
	
	include( path )
	table.insert( TIRA.Schemas, SCHEMA )

	-- Load the base, first.

	if( SCHEMA.Base ) then
	
		TIRA.LoadSchema( SCHEMA.Base )
		
	end
	
	table.insert( TIRA.Schemafile, schema )
	TIRA.DayLog( "script.txt", "Loading schema " .. SCHEMA.Name .. " by " .. SCHEMA.Author .. " ( " .. SCHEMA.Description .. " )" )


	-- Use the new plugin system

	TIRA.LoadPlugin( schema )

	-- Load the items
	local list = file.FindInLua( TIRA.Name .. "/gamemode/schemas/" .. schema .. "/items/*.lua" )
	
	for k, v in pairs( list ) do 
	
		TIRA.LoadItem( schema, v )
		
	end

	-- Use the new plugin system

	TIRA.LoadPlugin( schema )
	
	-- Load right click files.
	
	local list = file.FindInLua( TIRA.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua" ) or {}
	
	for k, v in pairs( list ) do
	
		TIRA.LoadRClick( schema, v )
		
	end
	
end

--Makes schemas run their SetUp function
function TIRA.InitSchemas( )

	for _, SCHEMA in ipairs( TIRA.Schemas ) do
		if !file.Exists( TIRA.Name .. "/" .. SCHEMA.Name .. ".txt" ) then
			print( "Initializing " .. SCHEMA.Name )
			file.Write( TIRA.Name .. "/" .. SCHEMA.Name .. ".txt", "" )
			SCHEMA.SetUp( )
		end
	end
	
end