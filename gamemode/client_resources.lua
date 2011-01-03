-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- client_resources.lua
-- This will tell the server what needs to be downloaded to the client and log it.
-- This will NOT tell the client what needs to be included, though.
-------------------------------

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
AddResource( "lua", "cl_charactercreate.lua" ); -- Character Creation functions
AddResource( "lua", "cl_hud.lua"); -- The HUD
AddResource( "lua", "cl_init.lua"); -- The initialization of clientside gamemode
AddResource( "lua", "cl_playermenu.lua"); -- The F1 playermenu
AddResource( "lua", "player_shared.lua"); -- Shared player functions
AddResource( "lua", "animations.lua"); -- Animations
AddResource( "lua", "cl_usermessages.lua")
AddResource( "lua", "cl_skin.lua")
AddResource( "lua", "boneanimlib/cl_boneanimlib.lua")
AddResource( "lua", "boneanimlib/sh_boneanimlib.lua")
AddResource( "lua", "achat.lua")
AddResource( "lua", "lua_animations.lua")
AddResource( "lua", "overv_3d2d_lib.lua")