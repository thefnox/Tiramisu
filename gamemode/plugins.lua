CAKE.Plugins = {  };
CAKE.CurrencyData = {  };

function CAKE.RegisterCurrency( currency )
	
	CAKE.CurrencyData[ currency.Name ] = currency
	
end

function CAKE.LoadRClick( schema, filename )

	local path = "schemas/" .. schema .. "/rclick/" .. filename;
	AddResource("lua", path)
	
end

--Plugins on Tiramisu are really no different from a regular lua file. It is automatically included, and doesn't stop the loading of all other plugins if an error is detected in one. The file prefix is important, a cl_ file will be sent to the player, while a sh_ file will be included both client and serverside

function CAKE.LoadPlugin( schema, filename )

	local filename = filename or ""
	local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/" .. filename
	local list = file.FindInLua( path .. "/*.lua" ) or {}

	for k, v in pairs( list ) do
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
	end
	
end

--Initializes plugins. This is the equivalent of hooking something to the Initialize hook
function CAKE.InitPlugins( )

	for _, PLUGIN in pairs( CAKE.Plugins ) do
		
		PLUGIN.Name = PLUGIN.Name or ""

		CAKE.DayLog("script.txt", "Initializing " .. PLUGIN.Name );
		
		if(PLUGIN.Init) then
			PLUGIN.Init( );
		end
		
	end
	
end
