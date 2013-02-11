
function CAKE.LoadGlobalSchema()
	CAKE.AddSchemaEntities("global", true)
	CAKE.AddRightClicks("global", true)
	CAKE.AddClientsidePlugins("global", nil, true)
	CAKE.AddItems("global", true)
	CAKE.AddSchemaEntities("global")
	CAKE.AddRightClicks("global")
	CAKE.AddClientsidePlugins("global")
	CAKE.AddItems("global")
end

RclickTable = {}

function CAKE.AddRightClicks(schema, global)

	if !global then
		local files, folders = file.Find( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua", "LUA" )
		
		for k,v in pairs( files ) do
			local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/" .. v
			RCLICK = { }
			MsgN( "Loading " .. path )
			include( path )
			table.insert(RclickTable, RCLICK)
		end
	else
		local files, folders = file.Find( CAKE.Name .. "/gamemode/rclick/*.lua", "LUA" )
		
		for k,v in pairs( files ) do
			local path = CAKE.Name .. "/gamemode/rclick/" .. v
			RCLICK = { }
			MsgN( "Loading " .. path )
			include( path )
			table.insert(RclickTable, RCLICK)
		end
	end
end

CAKE.CLPlugin = {}

function CAKE.AddClientsidePlugins( schema, filename, global )

	local filename = filename or ""
	local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/" .. filename
	if global then
		path = CAKE.Name .. "/gamemode/plugins/" .. filename
	end
	local files, folders = file.Find( path .. "*", "LUA" )

	for k, v in pairs( files ) do
		if v:sub( 1, 3 ) == "cl_" or v:sub( 1,3 ) == "sh_" then --Filters out serverside files that may have got sent
			PLUGIN = {} -- Support for shared plugins. 
			CLPLUGIN = {}
			MsgN( "Loading " .. path ..v )
			include( path .. v )
			CLPLUGIN.Name = CLPLUGIN.Name or schema .. "/plugins/" .. filename .. v
			CAKE.CLPlugin[CLPLUGIN.Name] = {}
			if CLPLUGIN and CLPLUGIN.Init then
				CAKE.CLPlugin[CLPLUGIN.Name].Init = CLPLUGIN.Init or function() end
				CAKE.CLPlugin[CLPLUGIN.Name].Init()
			end
		end
	end

	for k, v in pairs( folders ) do

		if v != "entities" then

			CAKE.AddClientsidePlugins( schema, filename .. v .. "/", global )

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

		CAKE.AddEffect(dir1 .. "effects/" .. v .. "/init.lua")
			
	end

end