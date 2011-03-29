
function AddResource( res_type, path )

	if( string.lower( res_type ) == "lua" ) then
	
		AddCSLuaFile( path );
		CAKE.DayLog( "script.txt", "Added clientside lua file '" .. path .. "'" )
		
	else
	
		resource.AddFile( path )
		CAKE.DayLog( "script.txt", "Added file '" .. path .. "'" )
		
	end
	
end

local function AddContentFolder( filepath )


	filepath = filepath or "gamemodes/" .. CAKE.Name .. "/content/*"
	local exp
	local list = file.Find( filepath, true )
	for k, v in pairs( list ) do
		if !file.IsDir( v, true ) then
			exp = string.Explode( ".", v )
			AddResource( exp[2] or "file", v )
		else
			AddContentFolder( filepath .. "*" )
		end
	end

end
/*
hook.Add( "Initialize", "TiramisuAddContent", function()
	
	AddContentFolder()

end)
*/
-- LUA Files
AddResource( "lua", "shared.lua" ); -- Shared Functions
AddResource( "lua", "cl_binds.lua" ); -- Binds
AddResource( "lua", "cl_init.lua"); -- The initialization of clientside gamemode
AddResource( "lua", "animations.lua"); -- Animations