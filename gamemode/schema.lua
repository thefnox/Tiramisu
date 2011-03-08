-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- schema.lua
-- Loads and configures the schema
-------------------------------

CAKE.Schemas = {  };
CAKE.Schemafile = {  };

function CAKE.LoadSchema( schema )

	local path = "schemas/" .. schema .. ".lua";
	
	table.insert( CAKE.Schemafile, schema )
	
	SCHEMA = {  };
	
	include( path );
	
	CAKE.DayLog( "script.txt", "Loading schema " .. SCHEMA.Name .. " by " .. SCHEMA.Author .. " ( " .. SCHEMA.Description .. " )" );
	
	table.insert( CAKE.Schemas, SCHEMA );
	
	-- Load the plugins
	
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/*.lua" );
	
	for k, v in pairs( list ) do
	
		CAKE.LoadPlugin( schema, v );
		
	end
	
	-- Load right click files.
	
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua" );
	
	for k, v in pairs( list ) do
	
		CAKE.LoadRClick( schema, v );
		
	end
	
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/clplugin/*.lua" );
	
	for k, v in pairs( list ) do
	
		CAKE.LoadClPlugin( schema, v );
		
	end
	
	
	-- Load the items
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/items/*.lua" );
	
	for k, v in pairs( list ) do
	
		CAKE.LoadItem( schema, v );
		
	end
	
	if( SCHEMA.Base != nil ) then
	
		CAKE.LoadSchema( SCHEMA.Base )
		
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
