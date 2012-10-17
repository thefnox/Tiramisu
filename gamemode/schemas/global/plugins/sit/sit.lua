PLUGIN.Name = "Sitting" -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC" -- Author of the plugin
PLUGIN.Description = "Handles the process of putting your ass on top of something" -- The description or purpose of the plugin

TIRA.Chairs = {
	[ "models/props_c17/furniturecouch001a.mdl" ] = {
			{ ["pos"] = Vector( 23, 14, -18 ), ["angles"] = Angle( 0, 0, 0 ) },
			{ ["pos"] = Vector( 23, -14, -18 ), ["angles"] = Angle( 0, 0, 0 ) }
		},
	[ "models/props_c17/furniturecouch002a.mdl" ] = {
			{ ["pos"] = Vector( 23, 14, -18 ), ["angles"] = Angle( 0, 0, 0 ) },
			{ ["pos"] = Vector( 23, -14, -18 ), ["angles"] = Angle( 0, 0, 0 ) }
		},
	[ "models/props_c17/furniturechair001a.mdl" ] = {
			{ ["pos"] = Vector(18, 0, -20 ), ["angles"] = Angle( 0.000, 0.000, 0) }
		},
	[ "models/props_c17/furniture_chair01a.mdl" ] = {
			{ ["pos"] = Vector(18, 0, -20 ), ["angles"] = Angle( 0.000, 0.000, 0) }
		},
	[ "models/props_c17/furniture_chair03a.mdl" ] = {
			{ ["pos"] = Vector(18, 0, -20 ), ["angles"] = Angle( 0.000, 0.000, 0) }
		},
	[ "models/props_c17/chair_stool01a.mdl" ] = {
			{ ["pos"] = Vector(18.0000, 0.0000, 17.0000 ), ["angles"] = Angle( 0.000, 0.000, 0.000) }
		}
}
--Add all chairs to this file.

--Edits a chair's coordinates based on a table.
function TIRA.EditChair( mdl, tbl )
	if TIRA.Chairs then
		for k, v in pairs( TIRA.Chairs ) do
			if k == mdl then
				TIRA.Chairs[ mdl ] = tbl
			end
		end
	end
end

--Saves all chairs to file
function TIRA.SaveChairs()
	local keys = TIRA.Serialize(TIRA.Chairs)
	file.Write( TIRA.Name .. "/chairs.txt", keys )
end

--Fetches all chairs from file
function TIRA.LoadChairs()
	if file.Exists( TIRA.Name .. "/chairs.txt" ) then
		TIRA.Chairs = TIRA.Deserialize(file.Read( TIRA.Name .. "/chairs.txt" ))
	end
end

local function LoadChairs()
	TIRA.LoadChairs()
end
hook.Add( "InitPostEntity", "TiramisuLoadChairs", LoadChairs )

--Returns true if the entity in question is an available chair.
function TIRA.IsChair( ent )
	if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_static" then
		for k, v in pairs( TIRA.Chairs ) do
			if string.lower( ent:GetModel() ) == string.lower( k ) then
				return true
			end
		end
	end
	return false
end

local newpos
local newang

local function ccSitDown( ply, cmd, args )

	local trace = ply:GetEyeTrace( )
	local distance = ply:GetPos():Distance( trace.HitPos )
	local ent = trace.Entity
	local sitnum
	local sitpos
	local sitang
	local hassit = false
	local newposition, newangles
	local tbl
	
	if ValidEntity( ent ) and TIRA.IsChair( ent ) and !ply:GetNWBool( "sittingchair", false ) and !ply:GetNWBool( "sittingground", false ) and !ply.SitTimer and distance < 180 then		
		if !ent.PeopleSitting then
			ent.PeopleSitting = {}
		end
		tbl = TIRA.Chairs[ string.lower( ent:GetModel() ) ] 
		sitnum = #tbl
		for i=1, sitnum do
			if !ent.PeopleSitting[ i ] then
				ent.PeopleSitting[ i ] = ply
				ply.SitSpot = i
				print( tostring( i ))
				hassit = true
				ply:Freeze( true )
				ply:SetParent( ent )
				ply:SetLocalPos(TIRA.Chairs[ ent:GetModel() ][i]["pos"])
				ply:SetLocalAngles(TIRA.Chairs[ ent:GetModel() ][i]["angles"])
				ply:SnapEyeAngles( ply:GetLocalAngles() )
				print( tostring( ply:GetPos() ) .. tostring( ply:GetAngles() ) )
				ply:SetNWBool( "sittingchair", true )
				break
				--ply.Clothing[1]:SetParent( ent )
				--ply.Clothing[1]:SetLocalPos(TIRA.Chairs[ ent:GetModel() ][i]["pos"])
				--ply.Clothing[1]:SetLocalAngles(TIRA.Chairs[ ent:GetModel() ][i]["angles"])
			end
		end
		if hassit then
			umsg.Start( "Tiramisu.Freescroll", ply )
				umsg.Bool( true )
			umsg.End()
			TIRA.SendChat( ply, "Use !stand, or right click yourself in thirdperson mode to get back on your feet." )
		else
			TIRA.SendChat( ply, "No room to sit here." )
		end
	elseif !ply.SitTimer then
		if ply:OnGround() then
			umsg.Start( "Tiramisu.Freescroll", ply )
				umsg.Bool( true )
			umsg.End()
			ply:SetNWBool( "sittingground", true )
			ply:Freeze( true )
			--ply.Clothing[1]:SetParent( ply )
			TIRA.SendChat( ply, "Use !stand, or right click yourself in thirdperson mode to get back on your feet." )
		end
	else
		TIRA.SendChat( ply, "Wait at least 2 seconds between sitting!")
	end
	
end
concommand.Add( "rp_sit", ccSitDown )

--Makes a player exit any sitting position
function TIRA.StandUp( ply )
	if ply:GetNWBool( "sittingchair", false ) or ply:GetNWBool( "sittingground", false ) then
		ply.SitTimer = true
		timer.Simple(1.3, function() ply:Freeze( false ) ply.SitTimer = false end)
		if ply:GetNWBool( "sittingchair", false ) then
			if ply:GetParent() and ply:GetParent().PeopleSitting then
				ply:GetParent().PeopleSitting[ ply.SitSpot ] = nil
			end
			ply:SetNWBool( "sittingchair", false )
		elseif ply:GetNWBool( "sittingground", false ) then
			ply:SetNWBool( "sittingground", false )
		end
		umsg.Start( "Tiramisu.Freescroll", ply )
			umsg.Bool( false )
		umsg.End()
		ply:SetParent()
		ply:SetPos( ply:GetPos() + Vector( 0, 0, 30 )  )
	end
end

local function ccStandUp( ply, cmd, args )
	TIRA.StandUp( ply )
end
concommand.Add( "rp_stand", ccStandUp )

local function ccEditSit( ply, cmd, args )
	
	local mdl = ""
	local seat = 1
	local vec = Vector( 0, 0, 0 )
	local ang = Angle( 0, 0, 0 )
	local tbl = {}
	
	if args[1] then
		mdl = string.lower( args[1] )
	end
	if args[2] and args[2] != "none" then
		seat = tonumber( args[2] )
	end
	if args[3] and args[3] != "none" then
		local sep = string.Explode( ",", args[3] )
		vec = Vector( tonumber(sep[1]),tonumber(sep[2]),tonumber(sep[3]) )
	else
		if TIRA.Chairs and TIRA.Chairs[ mdl ] and TIRA.Chairs[ mdl ][ seat ] then
			vec = TIRA.Chairs[ mdl ][ seat ][ "pos" ]
		end
	end
	if args[4] and args[4] != "none" then
		local sep = string.Explode( ",", args[4] )
		ang = Angle( tonumber(sep[1]),tonumber(sep[2]),tonumber(sep[3]) )
	else
		if TIRA.Chairs and TIRA.Chairs[ mdl ] and TIRA.Chairs[ mdl ][ seat ] then
			ang = TIRA.Chairs[ mdl ][ seat ][ "angles" ]
		end
	end
	
	tbl = {
		["pos"] = vec,
		["angles"] = ang
	}
	
	if TIRA.Chairs and TIRA.Chairs[ mdl ] and TIRA.Chairs[ mdl ] then
		TIRA.Chairs[ mdl ][ seat ] = tbl
	end
	
	TIRA.SaveChairs()
	
end

local function ccCreateSit( ply, cmd, args )
	
	local mdl = string.lower( args[1] )
	if TIRA.Chairs and !TIRA.Chairs[ mdl ] then
		TIRA.Chairs[ mdl ] = {}
		TIRA.Chairs[ mdl ][ 1 ] = { ["pos"] = Vector( 0, 0, 0 ), ["angles"] = Vector( 0, 0, 0 ) }
	end
	
	TIRA.SaveChairs()
	
end

hook.Add( "PlayerSpawn", "TiramisuStandOnSpawn", function( ply )

	if ply:IsCharLoaded() then
		TIRA.StandUp( ply )
	end

end)

function PLUGIN.Init()
	TIRA.AdminCommand( "createchair", ccCreateSit, "Add a chair", true, true, 2 )
	TIRA.AdminCommand( "editchair", ccEditSit, "Edit a chair's coordinates", true, true, 2 )
end