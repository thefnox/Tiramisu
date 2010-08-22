PLUGIN.Name = "Sitting"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles the process of putting your ass on top of something"; -- The description or purpose of the plugin

CAKE.Chairs = {
	[ "models/props_c17/furniturecouch001a.mdl" ] = {
			{ ["pos"] = Vector( 0, 0, 0 ), ["angles"] = Vector( 0, 0, 0 ) },
			{ ["pos"] = Vector( 0, 0, 0 ), ["angles"] = Vector( 0, 0, 0 ) }
		}
}

function CAKE.IsChair( ent )
	if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_static" then
		for k, v in pairs( CAKE.Chairs ) do
			if string.lower( ent:GetModel() ) == string.lower( k ) then
				print( "yep, it's chair." )
				return true
			end
		end
	end
	return false
end

local function ccSitDown( ply, cmd, args )
	local trace = ply:GetEyeTrace( )
	local ent = trace.Entity
	local sitnum
	local sitpos
	local sitang
	local hassit = false
	local newposition, newangles
	local tbl
	
	if  ValidEntity( ent ) then
		print( ent:GetClass() )
	end
	
	if ValidEntity( ent ) and CAKE.IsChair( ent ) and !ply:GetNWBool( "sittingchair", false ) and !ply:GetNWBool( "sittingground", false ) then		
		if !ent.PeopleSitting then
			ent.PeopleSitting = {}
		end
		tbl = CAKE.Chairs[ string.lower( ent:GetModel() ) ]
		sitnum = #tbl
		for i=1, sitnum do
			if !ent.PeopleSitting[ i ] then
				ent.PeopleSitting[ i ] = ply
				ply.SitSpot = i
				hassit = true
				newposition, newangles = LocalToWorld( CAKE.Chairs[ ent:GetModel() ][i]["pos"],CAKE.Chairs[ ent:GetModel() ][i]["angles"], ent:GetPos(), ent:GetAngles() )
				ply:SetPos(newposition)
				ply:SetAngles(newangles)
			end
		end
		if hassit then
			ply:SetNWBool( "sittingchair", true )
			ply:Freeze( true )
			ply:SetParent( ent )
			CAKE.SendChat( ply, "Use !stand to get back on your feet." )
		else
			CAKE.SendChat( ply, "No room to sit here." )
		end
	else
		ply:SetNWBool( "sittingground", true )
		ply:Freeze( true )
		CAKE.SendChat( ply, "Use !stand to get back on your feet." )
	end
	
end
concommand.Add( "rp_sit", ccSitDown )

local function ccStandUp( ply, cmd, args )
	if ply:GetNWBool( "sittingchair", false ) then
		ply:GetParent().PeopleSitting[ ply.SitSpot ] = nil
		ply:SetNWBool( "sittingchair", false )
	elseif ply:GetNWBool( "sittingground", false ) then
		ply:SetNWBool( "sittingground", false )
	end
	ply:SetParent()
	ply:SetPos( ply:GetPos() + Vector( 0, 0, 10 )  )
	ply:Freeze( false )
end
concommand.Add( "rp_stand", ccStandUp )

local function ccEditSit( ply, cmd, args )
	
	local vec = Vector( 0, 0, 0 )
	local ang = Angle( 0, 0, 0 )
	
	if ply:GetNWBool( "sittingchair", false ) then
		if args[1] and args[1] == "none" then
			local exp = string.Explode( ",", args[1] )
			vec = Vector( tonumber( exp[1] ), tonumber( exp[2] ), tonumber( exp[3] ) )
		end
		if args[2] and args[2] == "none" then
			local exp = string.Explode( ",", args[2] )
			ang = Angle( tonumber( exp[1] ), tonumber( exp[2]), tonumber( exp[3]) )
		end
		umsg.Start( "editsit", ply )
			umsg.Vector( vec )
			umsg.Angle( ang )
		umsg.End()
	end
	
end
concommand.Add( "rp_editsit", ccEditSit )

function PLUGIN.Init()

	
end