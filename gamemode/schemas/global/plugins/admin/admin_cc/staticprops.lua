CAKE.PermaProps = {}

--Adds a permanent prop to the CAKE.PermaProps table. This is for storage only.
function CAKE.AddPermaProp( mdl, pos, ang )

	if !CAKE.PermaProps[ game.GetMap( ) ] then
		CAKE.PermaProps[ game.GetMap( ) ] = {}
	end
	
	local tbl = {}
	tbl[ "model" ] = mdl
	tbl[ "position" ] = pos
	tbl[ "angles" ] = ang
	
	table.insert( CAKE.PermaProps[ game.GetMap( ) ], tbl )  
	
	CAKE.SavePermaProps()

end

--Removes permaprop status from an entity.
function CAKE.RemovePermaProp( ent )

	if !CAKE.PermaProps[ game.GetMap( ) ] then
		CAKE.PermaProps[ game.GetMap( ) ] = {}
	end
	
	local id = ent.PermaID or 0
	
	if CAKE.PermaProps[ game.GetMap( ) ][ id ] then
		CAKE.PermaProps[ game.GetMap( ) ][ id ] = nil
	end

	ent.PermaProp = false
	
	CAKE.SavePermaProps()
	
end

--Creates a new permaprop on the map based on it's ID on the CAKE.PermaProps table
function CAKE.CreatePermaProp( id )
	if CAKE.PermaProps[ game.GetMap( ) ][ id ] then
		local prop = ents.Create( "prop_physics" )
		prop:SetModel( CAKE.PermaProps[ game.GetMap( ) ][ id ][ "model" ] )
		prop:SetPos( CAKE.PermaProps[ game.GetMap( ) ][ id ][ "position" ] )
		prop:SetAngles( CAKE.PermaProps[ game.GetMap( ) ][ id ][ "angles" ] )
		prop:SetUnFreezable( false )
		prop:SetMoveType( MOVETYPE_NONE )
		prop.PermaID = id
		prop.PermaProp = true
		prop:Spawn()
		local phys = prop:GetPhysicsObject()	 
		if phys and phys:IsValid() then
			phys:EnableMotion(false) -- Freezes the object in place.
		end
	end
end

--Saves all permaprops to file.
function CAKE.SavePermaProps()

	local keys = glon.encode(CAKE.PermaProps[ game.GetMap( ) ]);
	file.Write( CAKE.Name .. "/PermaProps/" .. CAKE.ConVars[ "Schema" ] .. "/" .. game.GetMap( ) .. ".txt" , keys);

end

--Loads all permaprops on initialization.
function CAKE.LoadPermaProps()
	local map = game.GetMap()
	if file.Exists( CAKE.Name .. "/PermaProps/" .. CAKE.ConVars[ "Schema" ] .. "/" .. map .. ".txt" ) then
		CAKE.PermaProps[ map ] = glon.decode(file.Read( CAKE.Name .. "/PermaProps/" .. CAKE.ConVars[ "Schema" ] .. "/" .. map .. ".txt" ))
		local time = 0
		for k, v in ipairs( CAKE.PermaProps[ map ] ) do
			timer.Simple( time + 0.1, function()
				CAKE.CreatePermaProp( k )
			end)
		end
	end
end

hook.Add( "InitPostEntity", "TiramisuPermaProps", function()
	CAKE.LoadPermaProps()
end)

--rp_admin addpermaprop. Must be looking at the entity you want to make permanent.
local function Admin_AddPermaProp( ply, cmd, args )

	local tr = ply:GetEyeTrace()
	local trent = tr.Entity;
	CAKE.AddPermaProp( trent:GetModel(), trent:GetPos(), trent:GetAngles() )

end

--rp_admin removepermaprop. Removes permaprop status from an entity you're looking at.
local function Admin_RemovePermaProp( ply, cmd, args )
	
	local tr = ply:GetEyeTrace()
	local trent = tr.Entity;
	CAKE.RemovePermaProp( trent )
	
end

hook.Add("OnPhysgunFreeze", "TiramisuPhysgunPermapropProtection", function(weapon, phys, ent, ply)
	if ent.PermaProp then
		return false
	end
end)

hook.Add("CanTool", "TiramisuToolPermapropProtection", function(ply, tr, toolmode)
	if ValidEntity( tr.Entity ) and tr.Entity.PermaProp then
		return false
	end
end)

function PLUGIN.Init()
	CAKE.AdminCommand( "addpermaprop", Admin_AddPermaProp, "Add a permanent prop", true, true, 2 );
	CAKE.AdminCommand( "removepermaprop", Admin_RemovePermaProp, "Remove a permanent prop", true, true, 2 );
end