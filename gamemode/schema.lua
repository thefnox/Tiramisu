CAKE.Schemas = {  };
CAKE.Schemafile = {  };

function CAKE.LoadSchema( schema )

	local path = "schemas/" .. schema .. ".lua";
	
	SCHEMA = {  };
	
	include( path );

	-- Load the base, first.

	if( SCHEMA.Base ) then
	
		CAKE.LoadSchema( SCHEMA.Base )
		
	end
	
	table.insert( CAKE.Schemafile, schema )

	CAKE.DayLog( "script.txt", "Loading schema " .. SCHEMA.Name .. " by " .. SCHEMA.Author .. " ( " .. SCHEMA.Description .. " )" );
	
	table.insert( CAKE.Schemas, SCHEMA );

	-- Use the new plugin system

	local list = file.FindDir( "gamemodes/" .. CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/*", true) or {}

	for k, v in pairs( list ) do

		CAKE.LoadPlugin( schema, v )

	end
	
	-- Load the plugins using the old system
	
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/*.lua" ) or {}
	
	for k, v in pairs( list ) do
	
		CAKE.OldLoadPlugin( schema, v );
		
	end
	
	-- Load right click files.
	
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua" ) or {}
	
	for k, v in pairs( list ) do
	
		CAKE.LoadRClick( schema, v );
		
	end
	
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/clplugin/*.lua" ) or {}
	
	for k, v in pairs( list ) do
	
		CAKE.OldLoadClPlugin( schema, v );
		
	end
	
	
	-- Load the items
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/items/*.lua" );
	
	for k, v in pairs( list ) do 
	
		CAKE.LoadItem( schema, v );
		
	end
	
end

function CAKE.InitSchemas( )

	for _, SCHEMA in ipairs( CAKE.Schemas ) do

		SCHEMA.SetUp( );
		
	end
	
end

CAKE.ValidModels = {};

function CAKE.AddModels(mdls)

	if(type(mdls) == "table") then
	
		for k, v in pairs(mdls) do
		
			table.insert(CAKE.ValidModels, v)
			
		end
		
	else
	
		table.insert(CAKE.ValidModels, mdls)
		
	end
	
end
