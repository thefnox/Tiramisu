CAKE.Plugins = {  };
CAKE.CurrencyData = {  };

function CAKE.RegisterCurrency( currency )
	
	CAKE.CurrencyData[ currency.Name ] = currency
	
end

function CAKE.LoadRClick( schema, filename )

	local path = "schemas/" .. schema .. "/rclick/" .. filename;
	AddResource("lua", path)
	
end

function CAKE.LoadPlugin( schema, filename )

	local path = "gamemodes/" .. CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/" .. filename
	local list = file.Find( path .. "/*", true ) or {}

	for k, v in pairs( list ) do
		if string.GetExtensionFromFilename( path .. "/" .. v ) and string.GetExtensionFromFilename( path .. "/" .. v ) == "lua" then
			--It's a lua file! So it's time to include it according to what it actually is.
			PLUGIN = {}
			if v:sub( 1, 3 ) == "cl_" then --It's a clientside file
				AddResource("lua", "schemas/" .. schema .. "/plugins/" .. filename .. "/" .. v )
				CAKE.DayLog( "script.txt", "Loading clientside plugin " .. filename .. "/" .. v );
			elseif v:sub( 1,3 ) == "sh_" then --It's a shared file
				AddResource("lua", "schemas/" .. schema .. "/plugins/" .. filename .. "/" .. v )
				CAKE.DayLog( "script.txt", "Loading shared plugin " .. filename .. "/" .. v );
				include( "schemas/" .. schema .. "/plugins/" .. filename .. "/" .. v  )
			else --It doesn't have a prefix so we default it to be serverside only
				CAKE.DayLog( "script.txt", "Loading serverside plugin " .. filename .. "/" .. v );
				include( "schemas/" .. schema .. "/plugins/" .. filename .. "/" .. v  )
				table.insert( CAKE.Plugins, PLUGIN );
			end
		else --It's a directory
			CAKE.LoadPlugin( schema, path .. "/" .. v ) -- So we recursively make it add all it's files
		end
	end
	
end

function CAKE.OldLoadPlugin( schema, filename )
	
	local path = "schemas/" .. schema .. "/plugins/" .. filename;
	
	PLUGIN = {  };
	
	include( path );
	
	CAKE.DayLog( "script.txt", "Loading plugin " .. PLUGIN.Name or "" .. " by " .. PLUGIN.Author or "None" .. " ( " .. PLUGIN.Description or "N/A" .. " )" );
	
	table.insert( CAKE.Plugins, PLUGIN );
	
end

function CAKE.ReRoute( )

	for k, v in pairs( CAKE ) do
	
		if( type( v ) == "function" ) then
		
			GM[ k ] = CAKE[ k ];
			
		end
		
	end
	
end

function CAKE.OldLoadClPlugin( schema, filename )

	local path = "schemas/" .. schema .. "/clplugin/" .. filename;
	AddResource("lua", path)
	
end
	

function CAKE.InitPlugins( )

	for _, PLUGIN in pairs( CAKE.Plugins ) do
		
		PLUGIN.Name = PLUGIN.Name or ""

		CAKE.DayLog("script.txt", "Initializing " .. PLUGIN.Name );
		
		if(PLUGIN.Init) then
			PLUGIN.Init( );
		end
		
	end
	
end
