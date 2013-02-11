CAKE.Plugins = {  }

function CAKE.LoadRClick( schema, filename, global )

	local path = "schemas/" .. schema .. "/rclick/" .. filename
	if global then path = CAKE.Name .. "/gamemode/rclick/" .. filename end
	AddResource("lua", path)
	
end

--Plugins on Tiramisu are really no different from a regular lua file. It is automatically included, and doesn't stop the loading of all other plugins if an error is detected in one. The file prefix is important, a cl_ file will be sent to the player, while a sh_ file will be included both client and serverside

function CAKE.LoadPlugin( schema, filename, global )

	local filename = filename or ""
	local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/" .. filename
	if global then path = CAKE.Name .. "/gamemode/plugins/" .. filename end
	-- local list = file.FindInLua( path .. "*" ) or {}
	-- local list = file.Find( path .. "*", "LUA" ) or {}
	local files, folders = file.Find( path .. "*", "LUA" )

	-- for k, v in pairs( list ) do
	for k, v in pairs( files ) do
		PLUGIN = {}
		if v:sub( 1, 3 ) == "cl_" then --It's a clientside file, send it to the client
			if global then
				AddResource("lua", "plugins/" .. filename .. v )
			else
				AddResource("lua", "schemas/" .. schema .. "/plugins/" .. filename .. v )
			end
		elseif v:sub( 1,3 ) == "sh_" then --It's a shared file, so we add it and include it serverside.
			if global then
				AddResource("lua", "plugins/" .. filename .. v )
				CAKE.DayLog( "script.txt", "Loading Shared File: plugins/" .. filename .. v )
				include( "plugins/" .. filename .. v )
			else
				AddResource("lua", "schemas/" .. schema .. "/plugins/" .. filename .. v )
				CAKE.DayLog( "script.txt", "Loading Shared File: " .. schema .. "/plugins/" .. filename .. v )
				include( "schemas/" .. schema .. "/plugins/" .. filename .. v )
			end
		else --It doesn't have a prefix so we default it to be serverside only
			if global then
				CAKE.DayLog( "script.txt", "Loading Serverside File: plugins/" .. filename .. v )
				include( "plugins/" .. filename .. v )
			else
				CAKE.DayLog( "script.txt", "Loading Serverside File: " .. schema .. "/plugins/" .. filename .. v )
				include( "schemas/" .. schema .. "/plugins/" .. filename .. v )
			end
		end
		table.insert( CAKE.Plugins, PLUGIN )
	end

	for k, v in pairs( folders or {} ) do
		if v != "entities" then
			CAKE.LoadPlugin( schema, filename .. v .. "/", global )
		end
	end

	// Entity Loading
	local dir1 = path .. "entities/"

	local entityfiles, entitydirs = file.Find(dir1 .. "entities/*", "LUA")

	for k, v in pairs(entityfiles) do
		
		CAKE.AddEntity(dir1 .. "entities/" .. v)
		
	end

	for k, v in pairs(entitydirs) do
		
		CAKE.AddEntity(dir1 .. "entities/" .. v .. "/")
		
	end

	local weaponfiles, weapondirs = file.Find(dir1 .. "weapons/*", "LUA")

	for k, v in pairs(weaponfiles) do
		
		CAKE.AddWeapon(dir1 .. "weapons/" .. v)
		
	end

	for k, v in pairs(weapondirs) do
		
		CAKE.AddWeapon(dir1 .. "weapons/" .. v .. "/")
		
	end

	local _, effectdirs = file.Find(dir1 .. "effects/*", "LUA")

	for k, v in pairs(effectdirs) do

		CAKE.AddEffect(dir1 .. "effects/" .. V .. "/init.lua")
			
	end

end

--Initializes plugins. This is the equivalent of hooking something to the Initialize hook
function CAKE.InitPlugins( )

	for _, PLUGIN in pairs( CAKE.Plugins ) do
		
		PLUGIN.Name = PLUGIN.Name or "Unnamed Plugin-" .. SysTime()

		CAKE.DayLog("script.txt", "Initializing " .. PLUGIN.Name )
		
		if PLUGIN.Init then
			PLUGIN.Init()
		elseif PLUGIN.Initialize then
			PLUGIN.Initialize()
		end
		
	end
	
end