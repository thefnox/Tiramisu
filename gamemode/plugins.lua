-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- plugins.lua
-- Loads and handles the plugins.
-------------------------------


CAKE.Plugins = {  };
CAKE.CurrencyData = {  };

function CAKE.LoadCurrency( schema, filename )

	local path = "schemas/" .. schema .. "/currency/" .. filename;
	
	CURRENCY = {  };
	
	include( path );
	
	CAKE.CurrencyData[ CURRENCY.Name ] = CURRENCY;
	
end

function CAKE.LoadRClick( schema, filename )

	local path = "schemas/" .. schema .. "/rclick/" .. filename;
	print( path )
	AddResource("lua", path)
	
end


function CAKE.LoadPlugin( schema, filename )
	
	CAKE.CallHook( "LoadPlugin", schema, filename );
	
	local path = "schemas/" .. schema .. "/plugins/" .. filename;
	
	PLUGIN = {  };
	
	include( path );
	
	CAKE.DayLog( "script.txt", "Loading plugin " .. PLUGIN.Name .. " by " .. PLUGIN.Author .. " ( " .. PLUGIN.Description .. " )" );
	
	table.insert( CAKE.Plugins, PLUGIN );
	
end

function CAKE.ReRoute( )

	for k, v in pairs( CAKE ) do
	
		if( type( v ) == "function" ) then
		
			GM[ k ] = CAKE[ k ];
			
		end
		
	end
	
end

function CAKE.LoadClPlugin( schema, filename )

	local path = "schemas/" .. schema .. "/clplugin/" .. filename;
	AddResource("lua", path)
	
end
	

function CAKE.InitPlugins( )

	for _, PLUGIN in pairs( CAKE.Plugins ) do
		
		CAKE.CallHook( "InitPlugin", _, PLUGIN );
		CAKE.DayLog("script.txt", "Initializing " .. PLUGIN.Name);
		
		if(PLUGIN.Init) then
			PLUGIN.Init( );
		end
		
	end
	
end
