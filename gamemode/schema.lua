CAKE.Schemas = {  };
CAKE.Schemafile = {  };

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
	CAKE.DayLog( "script.txt", "Loading schema " .. SCHEMA.Name .. " by " .. SCHEMA.Author .. " ( " .. SCHEMA.Description .. " )" );


	-- Use the new plugin system

	CAKE.LoadPlugin( schema )

	-- Load the items
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/items/*.lua" );
	
	for k, v in pairs( list ) do 
	
		CAKE.LoadItem( schema, v );
		
	end

	-- Use the new plugin system

	CAKE.LoadPlugin( schema )
	
	-- Load right click files.
	
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua" ) or {}
	
	for k, v in pairs( list ) do
	
		CAKE.LoadRClick( schema, v );
		
	end
	
end

--Makes schemas run their SetUp function
function CAKE.InitSchemas( )

	for _, SCHEMA in ipairs( CAKE.Schemas ) do

		SCHEMA.SetUp( );
		
	end
	
end