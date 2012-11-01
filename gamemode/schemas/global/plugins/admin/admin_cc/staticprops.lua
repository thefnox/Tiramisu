TIRA.PermaProps = {}

--Adds a permanent prop to the TIRA.PermaProps table. This is for storage only.
function TIRA.AddPermaProp( mdl, pos, ang, containerid )

	if !TIRA.PermaProps[ game.GetMap( ) ] then
		TIRA.PermaProps[ game.GetMap( ) ] = {}
	end
	
	local tbl = {}
	tbl[ "model" ] = mdl
	tbl[ "position" ] = pos
	tbl[ "angles" ] = ang
	if containerid then
		tbl[ "container" ] = containerid
	end
	
	table.insert( TIRA.PermaProps[ game.GetMap( ) ], tbl )  
	
	TIRA.SavePermaProps()

end

--Removes permaprop status from an entity.
function TIRA.RemovePermaProp( ent )

	if !TIRA.PermaProps[ game.GetMap( ) ] then
		TIRA.PermaProps[ game.GetMap( ) ] = {}
	end
	
	local id = ent.PermaID or 0
	
	if TIRA.PermaProps[ game.GetMap( ) ][ id ] then
		TIRA.PermaProps[ game.GetMap( ) ][ id ] = nil
	end

	ent:SetNWBool("permaprop", false)
	
	TIRA.SavePermaProps()
	
end

--Creates a new permaprop on the map based on it's ID on the TIRA.PermaProps table
function TIRA.CreatePermaProp( id )
	if TIRA.PermaProps[ game.GetMap( ) ][ id ] then
		local prop = ents.Create( "prop_physics" )
		prop:SetModel( TIRA.PermaProps[ game.GetMap( ) ][ id ][ "model" ] )
		prop:SetPos( TIRA.PermaProps[ game.GetMap( ) ][ id ][ "position" ] )
		prop:SetAngles( TIRA.PermaProps[ game.GetMap( ) ][ id ][ "angles" ] )
		if TIRA.PermaProps[ game.GetMap( ) ][ id ][ "container" ] then
			prop:SetNWString("container", TIRA.PermaProps[ game.GetMap( ) ][ id ][ "container" ])
		end
		prop:SetUnFreezable( false )
		prop:SetMoveType( MOVETYPE_NONE )
		prop.PermaID = id
		prop:SetNWBool("permaprop", true)
		prop:Spawn()
		local phys = prop:GetPhysicsObject()	 
		if phys and phys:IsValid() then
			phys:EnableMotion(false) -- Freezes the object in place.
		end
	end
end

--Saves all permaprops to file.
function TIRA.SavePermaProps()

	local keys = TIRA.Serialize(TIRA.PermaProps[ game.GetMap( ) ])
	file.Write( TIRA.Name .. "/PermaProps/" .. TIRA.ConVars[ "Schema" ] .. "/" .. game.GetMap( ) .. ".txt" , keys)

end

--Loads all permaprops on initialization.
function TIRA.LoadPermaProps()
	local map = game.GetMap()
	if file.Exists( TIRA.Name .. "/PermaProps/" .. TIRA.ConVars[ "Schema" ] .. "/" .. map .. ".txt", "DATA" ) then
		TIRA.PermaProps[ map ] = TIRA.Deserialize(file.Read( TIRA.Name .. "/PermaProps/" .. TIRA.ConVars[ "Schema" ] .. "/" .. map .. ".txt" , "DATA"))
		local time = 0
		for k, v in ipairs( TIRA.PermaProps[ map ] ) do
			timer.Simple( time + 0.1, function()
				TIRA.CreatePermaProp( k )
			end)
			time = time + 0.1
		end
	end
end

hook.Add( "InitPostEntity", "TiramisuPermaProps", function()
	TIRA.LoadPermaProps()
end)

--rp_admin addpermaprop. Right click an entity to make it permanent
local function Admin_AddPermaProp( ply, cmd, args )

	local ent = ents.GetByIndex(tonumber(args[1]))
	ent:SetNWBool("permaprop", true)
	ent:SetUnFreezable( false )
	ent:SetMoveType( MOVETYPE_NONE )
	TIRA.AddPermaProp( ent:GetModel(), ent:GetPos(), ent:GetAngles() )

end

--rp_admin removepermaprop. Removes permaprop status from a prop you right clicked
local function Admin_RemovePermaProp( ply, cmd, args )
	
	local ent = ents.GetByIndex(tonumber(args[1]))
	TIRA.RemovePermaProp( ent )
	
end

hook.Add("OnPhysgunFreeze", "TiramisuPhysgunPermapropProtection", function(weapon, phys, ent, ply)
	if ent:GetNWBool("permaprop", false) then
		return false
	end
end)

hook.Add("CanTool", "TiramisuToolPermapropProtection", function(ply, tr, toolmode)
	if ValidEntity( tr.Entity ) and tr.Entity:GetNWBool("permaprop", false) then
		return false
	end
end)

function PLUGIN.Init()
	TIRA.AdminCommand( "addpermaprop", Admin_AddPermaProp, "Add a permanent prop", true, true, 1 )
	TIRA.AdminCommand( "removepermaprop", Admin_RemovePermaProp, "Remove a permanent prop", true, true, 1 )
end