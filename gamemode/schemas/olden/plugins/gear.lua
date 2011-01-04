PLUGIN.Name = "Gear"; -- What is the plugin name
PLUGIN.Author = "FNox/Big Bang"; -- Author of the plugin
PLUGIN.Description = "Handles the stuff that you stick on yourself"; -- The description or purpose of the plugin

--Thanks to the PAC team for this list.
local BoneList = {
	["pelvis"			] = "ValveBiped.Bip01_Pelvis"		,
	["stomach"			] = "ValveBiped.Bip01_Spine"		,
	["lower back"		] = "ValveBiped.Bip01_Spine1"		,
	["chest"			] = "ValveBiped.Bip01_Spine2"		,
	["upper back"		] = "ValveBiped.Bip01_Spine4"		,
	["neck"				] = "ValveBiped.Bip01_Neck1"		,
	["head"				] = "ValveBiped.Bip01_Head1"		,
	["right clavicle"	] = "ValveBiped.Bip01_R_Clavicle"	,
	["right upper arm"	] = "ValveBiped.Bip01_R_UpperArm"	,
	["right forearm"	] = "ValveBiped.Bip01_R_Forearm"	,
	["right hand"		] = "ValveBiped.Bip01_R_Hand"		,
	["left clavicle"	] = "ValveBiped.Bip01_L_Clavicle"	,
	["left upper arm"	] = "ValveBiped.Bip01_L_UpperArm"	,
	["left forearm"		] = "ValveBiped.Bip01_L_Forearm"	,
	["left hand"		] = "ValveBiped.Bip01_L_Hand"		,
	["right thigh"		] = "ValveBiped.Bip01_R_Thigh"		,
	["right calf"		] = "ValveBiped.Bip01_R_Calf"		,
	["right foot"		] = "ValveBiped.Bip01_R_Foot"		,
	["right toe"		] = "ValveBiped.Bip01_R_Toe0"		,
	["left thigh"		] = "ValveBiped.Bip01_L_Thigh"		,
	["left calf"		] = "ValveBiped.Bip01_L_Calf"		,
	["left foot"		] = "ValveBiped.Bip01_L_Foot"		,
	["left toe"			] = "ValveBiped.Bip01_L_Toe0"		
}

function CAKE.BoneShorttoFull( bone )
	return BoneList[ bone ]
end

function CAKE.BoneFulltoShort( bone )
	for k, v in pairs( BoneList ) do
		if v == bone then
			return k
		end
	end
end

function CAKE.HandleGear( ply, item, bone, offset, angle, scale, skin )
	
	if CAKE.ItemData[ item ] then
		local bone = bone or CAKE.ItemData[ item ].Bone or "head"
		
		if !ply.Gear then
			ply.Gear = {}
		end
		
		local id = #ply.Gear + 1
		local model = CAKE.ItemData[ item ].Model
		local offset = offset or CAKE.ItemData[ item ].Offset or Vector( 0, 0, 0 )
		local angle = angle or CAKE.ItemData[ item ].OffsetAngle or Angle( 0, 0, 0 )
		local scale = scale or CAKE.ItemData[ item ].Scale or Vector( 1, 1, 1 )
		local skin = skin or CAKE.ItemData[ item ].Skin or 0
		local bonemerge = true
		if CAKE.ItemData[ item ].WeaponType then
			bonemerge = false
		end
		
		ply.Gear[ id ] = ents.Create( "player_gear" )
		ply.Gear[ id ].bone = bone
		ply.Gear[ id ]:SetModel( model )
		ply.Gear[ id ]:SetParent( ply )
		ply.Gear[ id ]:SetPos( ply:GetPos() )
		ply.Gear[ id ]:SetAngles( ply:GetAngles() )
		ply.Gear[ id ]:SetDTInt( 1, ply:LookupBone( CAKE.BoneShorttoFull( bone ) ) )
		ply.Gear[ id ]:SetDTEntity( 1, ply )
		ply.Gear[ id ]:SetDTAngle( 1, angle )
		ply.Gear[ id ]:SetDTVector( 1, offset )
		ply.Gear[ id ]:SetDTVector( 2, scale )
		ply.Gear[ id ]:SetDTBool( 1, true )
		ply.Gear[ id ]:SetDTBool( 2, bonemerge )
		if ValidEntity( ply.Gear[ id ]:GetPhysicsObject( ) ) then
			ply.Gear[ id ]:GetPhysicsObject( ):EnableCollisions( false )
		end
		ply.Gear[ id ]:Spawn()
		ply.Gear[ id ]:SetSkin( skin )
		ply.Gear[ id ].item = item
	end
	
end

	
function CAKE.RemoveGear( ply, id )

	if ply.Gear[ id ] then
		ply.Gear[ id ]:SetParent()
		ply.Gear[ id ]:Remove()
		ply.Gear[ id ] = nil
	end
	
end
	
function CAKE.RemoveAllGear( ply )
	
	if ply.Gear then
		for k, v in pairs( ply.Gear ) do
			CAKE.RemoveGear( ply, k )
		end
	end
		
	ply.Gear = {}
end

function CAKE.RemoveGearItem( ply, item )

	if ply.Gear then
		for k, v in pairs( ply.Gear ) do
			if v.item == item then
				CAKE.RemoveGear( ply, k )
			end
			break
		end
	end
	
end

local function ccSetGear( ply, cmd, args )
	
	local item = args[1]
	local bone = args[2] or CAKE.ItemData[ item ].Bone or "head"
	local offset
	local angle
	local scale
	
	if args[3] then
		offset = Vector( tonumber( args[3] ), tonumber( args[4] ), tonumber( args[5] ) )
	else
		offset = CAKE.ItemData[ item ].Offset or Vector( 0, 0, 0 )
	end
	
	if args[6] then
		angle = Angle( tonumber( args[6] ), tonumber( args[7] ), tonumber( args[8] ) )
	else
		angle = CAKE.ItemData[ item ].OffsetAngle or Angle( 0, 0, 0 )
	end
	
	if args[9] then
		scale = Vector( tonumber( args[9] ), tonumber( args[10] ), tonumber( args[11] ) )
	else
		scale = CAKE.ItemData[ item ].Scale or Vector( 1, 1, 1 )
	end
	
	
	CAKE.RemoveGear( ply, bone )
	CAKE.HandleGear( ply, item, bone, offset, angle, scale )
	CAKE.SaveGear( ply )
	datastream.StreamToClients( ply, "recievegear",  ply.Gear )

end
concommand.Add( "rp_setgear", ccSetGear )

local function ccRemoveGear( ply, cmd, args )
	
	if( args[1] ) then
		CAKE.RemoveGear( ply, args[1] )
	else
		CAKE.RemoveAllGear( ply )
	end
	CAKE.SaveGear( ply )
	datastream.StreamToClients( ply, "recievegear",  ply.Gear )

end
concommand.Add( "rp_removegear", ccRemoveGear )

local function ccEditGear( ply, cmd, args )

	local bone = tonumber( args[1] )
	local offset
	local angle
	local scale
	local visible
	local skin
	
	if args[2] and args[2] != "none" then
		local exp = string.Explode( ",", args[2] )
		offset = Vector( exp[1], exp[2], exp[3] )
	else
		offset = ply.Gear[ bone ]:GetDTVector( 1 )
	end
	
	if args[3] and args[3] != "none" then
		local exp = string.Explode( ",", args[3] )
		angle = Angle( exp[1], exp[2], exp[3] )
	else
		angle = ply.Gear[ bone ]:GetDTAngle( 1 )
	end
	
	if args[4] and args[4] != "none" then
		local exp = string.Explode( ",", args[4] )
		scale = Vector( exp[1], exp[2], exp[3] )
	else
		scale = ply.Gear[ bone ]:GetDTVector( 2 )
	end
	
	if args[5] and args[5] != "none" then
		visible = util.tobool( args[5] )
	else
		visible = ply.Gear[ bone ]:GetDTBool( 1 )
	end
	
	if args[6] and args[6] != "none" then
		skin = math.Clamp( tonumber( args[6] ), 0, ply.Gear[ bone ]:SkinCount() )
	else
		skin = ply.Gear[ bone ]:GetSkin()
	end
	
	ply.Gear[ bone ]:SetDTVector( 1, offset )
	ply.Gear[ bone ]:SetDTVector( 2, scale )
	ply.Gear[ bone ]:SetDTAngle( 1, angle )
	ply.Gear[ bone ]:SetDTBool( 1, visible )
	ply.Gear[ bone ]:SetSkin( skin )
	
	CAKE.SaveGear( ply )
	datastream.StreamToClients( ply, "recievegear",  ply.Gear )

end
concommand.Add( "rp_editgear", ccEditGear )

local meta = FindMetaTable( "Player" )

function meta:HideActiveWeapon()
	
	local wep = self:GetActiveWeapon()
	if ValidEntity( wep ) and !self:GetNWBool( "observe" ) then
		local class = wep:GetClass()
		if self.Gear then
			for k, v in pairs( self.Gear ) do
				if ValidEntity( v ) then
					if v.item == class and v:GetParent() == self then
						v:SetDTBool( 1, false )
					else
						v:SetDTBool( 1, true)
					end
				end
			end
		end
	end

end

function CAKE.SaveGear( ply )

	local tbl = {}
	
	if ply.Gear then
		for k, v in pairs( ply.Gear ) do
			tbl[ k ] = {}
			tbl[ k ][ "offset"] = v:GetDTVector( 1 )
			tbl[ k ][ "angle" ] = v:GetDTAngle( 1 )
			tbl[ k ][ "scale" ] = v:GetDTVector( 2 )
			tbl[ k ][ "skin" ] = v:GetSkin()
			tbl[ k ][ "item" ] = v.item
			tbl[ k ][ "bone" ] = v.bone
		end
	end
	
	CAKE.SetCharField( ply, "gear", tbl )
	
	
end

function CAKE.RestoreGear( ply )
	
	if ply:IsCharLoaded() then
		local tbl = CAKE.GetCharField( ply, "gear" )
		for k, v in pairs( tbl ) do
			CAKE.HandleGear( ply, tbl[ k ][ "item" ], tbl[ k ][ "bone" ], tbl[ k ][ "offset" ], tbl[ k ][ "angle" ], tbl[ k ][ "scale" ], tbl[ k ][ "skin" ] )
		end
		datastream.StreamToClients( ply, "recievegear",  ply.Gear )
	end
	
	timer.Create( ply:SteamID() .. "sendgear", 1, 0, function()
		datastream.StreamToClients( ply, "recievegear",  ply.Gear )
	end)
	
end

local function GearSpawnHook( ply )
	timer.Create( ply:SteamID() .. "gunchecktimer", 0.1, 0, function() --Please not, this solution is horrid, but there are no other hooks for this.
		ply:HideActiveWeapon()
	end)
end
hook.Add( "PlayerSpawn", "TiramisuGearSpawnHook", GearSpawnHook )

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "gear", {} ); --Whatever the fuck else you're wearing.
	
end