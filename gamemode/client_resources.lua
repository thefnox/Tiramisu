--Adds a resource file. It accepts lua files and regular data.
function AddResource( res_type, path )

	if( string.lower( res_type ) == "lua" ) then
	
		AddCSLuaFile( path )
		CAKE.DayLog( "script.txt", "Added clientside lua file '" .. path .. "'" )
		
	else
	
		resource.AddFile( path )
		CAKE.DayLog( "script.txt", "Added file '" .. path .. "'" )
		
	end
	
end

local function AddContentFolder( filepath ) --Adds all of the files on the content folder to resource downloading.


	local filepath = filepath or ""
	local list = file.Find( "gamemodes/" .. CAKE.Name .. "/content" .. filepath  .. "/*", true ) or {}
	for k, v in pairs( list ) do
		if string.GetExtensionFromFilename(v) and string.GetExtensionFromFilename(v) != "dll" then
			AddResource( string.GetExtensionFromFilename(v), string.sub( filepath .. "/" .. v, 2 ) ) --Starting from char 2 since char one is a slash.
		else
			if v:len() > 2 then --Filters out ".." and "." which are special folder names
				AddContentFolder( filepath .. "/" .. v )
			end
		end
	end

end

hook.Add( "Initialize", "TiramisuAddContent", function()
	
	AddContentFolder()

end)

-- LUA Files
AddResource( "lua", "configuration.lua" ) --Tiramisu's configuration file.
AddResource( "lua", "shared.lua" ) -- Shared Functions
AddResource( "lua", "cl_binds.lua" ) -- Binds
AddResource( "lua", "cl_init.lua") -- The initialization of clientside gamemode
AddResource( "lua", "sh_animations.lua") -- Animations
AddResource( "lua", "sh_anim_tables.lua") -- Animations
AddResource( "lua", "cl_skin.lua" ) --The skin