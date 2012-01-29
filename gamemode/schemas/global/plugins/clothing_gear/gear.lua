PLUGIN.Name = "Gear" -- What is the plugin name
PLUGIN.Author = "FNox/Big Bang" -- Author of the plugin
PLUGIN.Description = "Handles the stuff that you stick on yourself" -- The description or purpose of the plugin

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

--Converts a bone's name from it's shortened version to the full skeleton bone's name.
function CAKE.BoneShorttoFull( bone )
	return BoneList[ bone ]
end

--Does the opposite of the above.
function CAKE.BoneFulltoShort( bone )
	for k, v in pairs( BoneList ) do
		if v == bone then
			return k
		end
	end
end

--Internal function used to create gear entities.
function CAKE.HandleGear( ply, item, bone, itemid, offset, angle, scale, skin )
	
	if CAKE.ItemData[ item ] then
		local bone = bone or CAKE.ItemData[ item ].Bone or "pelvis"
		
		if !ply.Gear then
			ply.Gear = {}
		end
		
		local id =  #ply.Gear + 1 
		local model = CAKE.GetUData(itemid, "model") or CAKE.ItemData[ item ].Model
		local offset = offset or CAKE.GetUData(itemid, "offset") or CAKE.ItemData[ item ].Offset or Vector( 0, 0, 0 )
		local angle = angle or CAKE.GetUData(itemid, "angle") or CAKE.ItemData[ item ].OffsetAngle or Angle( 0, 0, 0 )
		local scale = scale or CAKE.GetUData(itemid, "scale") or CAKE.ItemData[ item ].Scale or Vector( 1, 1, 1 )
		local skin = skin or CAKE.GetUData(itemid, "skin") or CAKE.ItemData[ item ].Skin or 0
		local bonemerge = true

		if itemid then
			CAKE.SetUData( itemid, "bone", bone )
		end

		if CAKE.ItemData[ item ].WeaponType then
			bonemerge = false
		end
		
		ply.Gear[ id ] = ents.Create( "player_gear" )
		ply.Gear[ id ].bone = bone
		ply.Gear[ id ]:SetModel( model )
		if bonemerge then
			ply.Gear[ id ]:SetParent( ply )
		else
			if ply.BonemergeGearEntity then
				ply.Gear[ id ]:SetParent( ply.BonemergeGearEntity )
			end
		end
		--ply.Gear[ id ]:SetParent( ply )
		ply.Gear[ id ]:SetPos( ply:GetPos() )
		ply.Gear[ id ]:SetAngles( ply:GetAngles() )
		ply.Gear[ id ]:SetDTInt( 1, ply:LookupBone( CAKE.BoneShorttoFull( bone ) ) )
		ply.Gear[ id ]:SetDTEntity( 1, ply )
		ply.Gear[ id ]:SetDTAngle( 1, angle )
		ply.Gear[ id ]:SetDTVector( 1, offset )
		ply.Gear[ id ]:SetDTVector( 2, scale )
		ply.Gear[ id ]:SetDTBool( 1, true )
		ply.Gear[ id ]:SetDTBool( 2, true )
		if ValidEntity( ply.Gear[ id ]:GetPhysicsObject( ) ) then
			ply.Gear[ id ]:GetPhysicsObject( ):EnableCollisions( false )
		end
		ply.Gear[ id ]:Spawn()
		ply.Gear[ id ]:SetSkin( skin )
		ply.Gear[ id ].item = item
		ply.Gear[ id ].itemid = itemid
		ply.Gear[ id ].name = CAKE.GetUData(itemid, "name") or CAKE.ItemData[ item ].Name or CAKE.ItemData[ item ].Class

		return ply.Gear[ id ]

	end
	
end

--Removes one gear piece based on it's entity index.	
function CAKE.RemoveGear( ply, id )

	if ply.Gear[ id ] then
		ply.Gear[ id ]:SetParent()
		ply.Gear[ id ]:Remove()
		ply.Gear[ id ] = nil
	end
	
end

--Removes all gear that player is wearing.
function CAKE.RemoveAllGear( ply )
	
	if ply.Gear then
		for k, v in pairs( ply.Gear ) do
			CAKE.RemoveGear( ply, k )
		end
	end
		
	ply.Gear = {}

end

--Removes one gear piece of the same item type.
function CAKE.RemoveGearItem( ply, item )

	if ply.Gear then
		for k, v in pairs( ply.Gear ) do
			if ValidEntity( v ) and v.item == item then
				CAKE.RemoveGear( ply, k )
				CAKE.SaveGear( ply )
				return true
			end
		end
	end
		
	return false

end

--Removes one gear piece based on it's item ID.
function CAKE.RemoveGearItemID( ply, itemid )

	if ply.Gear then
		for k, v in pairs( ply.Gear ) do
			if ValidEntity( v ) and v.itemid == itemid then
				CAKE.RemoveGear( ply, k )
				CAKE.SaveGear( ply )
				return true
			end
		end
	end
		
	return false
	
end

local function ccSetGear( ply, cmd, args )
	
	local item = args[1]
	local bone = string.lower( args[2] ) or CAKE.ItemData[ item ].Bone or "pelvis"
	local itemid = args[3]
	local entity = CAKE.HandleGear( ply, item, bone, itemid )
	local tbl = {}
	timer.Simple( 1, function()
		umsg.Start( "editgear", ply )
			umsg.Short( entity:EntIndex() )
			umsg.String( item )
			umsg.String( bone )
			umsg.String( itemid )
			umsg.String( CAKE.GetUData( itemid, "name" ) or item )
		umsg.End( )
	end)

	CAKE.SaveGear( ply )
	CAKE.SendGearToClient( ply )

end
concommand.Add( "rp_setgear", ccSetGear )

local function ccRemoveGear( ply, cmd, args )

	if( args[1] ) then
		local ent = ents.GetByIndex( tonumber( args[ 1 ] ) )
		for k, v in pairs( ply.Gear ) do
			if v == ent then
				CAKE.RemoveGear( ply, k )
				break
			end
		end
	else
		CAKE.RemoveAllGear( ply )
	end
	CAKE.SaveGear( ply )
	CAKE.SendGearToClient( ply )
end
concommand.Add( "rp_removegear", ccRemoveGear )

datastream.Hook( "Tiramisu.GetEditGear", function(ply, handler, id, encoded, decoded)
	local ent = decoded.entity
	if ValidEntity( ent ) and ent:GetDTEntity( 1 ) == ply then
		CAKE.SetUData(ent.itemid, "offset", decoded.offset)
		CAKE.SetUData(ent.itemid, "scale", decoded.scale)
		CAKE.SetUData(ent.itemid, "angle", decoded.angle)
		CAKE.SetUData(ent.itemid, "skin", decoded.skin)
		CAKE.SetUData(ent.itemid, "name", decoded.name)
		ent:SetDTVector( 1, decoded.offset )
		ent:SetDTVector( 2, decoded.scale )
		ent:SetDTAngle( 1, decoded.angle )
		ent:SetSkin( decoded.skin )
		CAKE.SaveGear( ply )
		ply:RefreshInventory( )
		CAKE.SendGearToClient( ply )
	end
end)

local meta = FindMetaTable( "Player" )

--Internal used to hide weapons when unholstered.
function meta:HideActiveWeapon()
	
	if ValidEntity( self ) then
		local wep = self:GetActiveWeapon()
		if ValidEntity( wep ) and !self:GetNWBool( "observe" ) then
			local class = wep:GetClass()
			if self.Gear then
				for k, v in pairs( self.Gear ) do
					if ValidEntity( v ) then
						if (v.item == class or CAKE.GetUData( v.itemid, "weaponclass") == class) and v:GetDTEntity( 1 ) == self then
							v:SetDTBool( 1, false )
						else
							v:SetDTBool( 1, true)
						end
					end
				end
			end
		end
	end
end

--Saves gear to the character's table.
function CAKE.SaveGear( ply )

	local savedgear = {}
	local tbl = {}

	if ply:IsCharLoaded() and ply.Gear then
		for k, v in pairs( ply.Gear ) do
			if ValidEntity( v ) then
				tbl = {}
				tbl["offset"] = v:GetDTVector(1)
				tbl["item"] = v.item
				tbl["name"] = v.name
				tbl["itemid"] = v.itemid
				tbl["bone"] = v.bone
				tbl["scale"] = v:GetDTVector(2)
				tbl["skin"] = v:GetSkin()
				tbl["angle"] = v:GetDTAngle(1)
				table.insert( savedgear, tbl )
			end
		end
	end

	CAKE.SetCharField( ply, "gear", savedgear )

end

--Restores all gear on spawn.
function CAKE.RestoreGear( ply )
	
	if ply:IsCharLoaded() then
		local tbl = CAKE.GetCharField( ply, "gear" )
		CAKE.RemoveAllGear( ply )
		for k, v in pairs( tbl ) do
			if ply:HasItem( v["item"] ) then
				CAKE.HandleGear( ply, v[ "item" ], v[ "bone" ], v[ "itemid" ], v[ "offset" ], v[ "angle" ], v[ "scale" ], v[ "skin" ] )
			end
		end
		CAKE.SendGearToClient( ply )
	end
	
end

--Allows a player to wear a gear piece without having it's item.
function CAKE.TestGear( ply, tbl )

	CAKE.RemoveAllGear( ply )
	for k, v in pairs( tbl ) do
		CAKE.HandleGear( ply, v[ "item" ], v[ "bone" ], v[ "itemid" ], v[ "offset" ], v[ "angle" ], v[ "scale" ], v[ "skin" ] )
		timer.Simple( 1, function()
			if resourcex and CAKE.ItemData[ v["item"] ].Content then
				for k, v in ipairs( CAKE.ItemData[ v["item"] ].Content ) do
					resourcex.AddFile( v, true )
				end
			end
		end)
	end
	
	CAKE.SendGearToClient( ply )
	
end

--Sends all gear entities to the client.
function CAKE.SendGearToClient( ply )
	
	local newtable = {}
	local num
	if ply.Gear then
		timer.Simple( ply:Ping() / 100 + 0.5, function()
			if ply.Gear then
				umsg.Start( "cleargear", ply )
				umsg.End()
				for k, v in pairs( ply.Gear ) do
					if ValidEntity( v ) then
						umsg.Start( "addgear", ply )
							umsg.Short( v:EntIndex() )
							umsg.String( v.item )
							umsg.String( v.bone )
							umsg.String( v.name or v.item )
							umsg.String( v.itemid or "none" )
						umsg.End( )
					end
				end
			end
		end)
	end

end

local function GearSpawnHook( ply )
	timer.Create( ply:SteamID() .. "gunchecktimer", 1, 0, function()
		ply:HideActiveWeapon()
	end)
	timer.Simple( 2, function() 
		CAKE.RestoreGear( ply )
	end)
end
hook.Add( "PlayerSpawn", "TiramisuGearSpawnHook", GearSpawnHook )