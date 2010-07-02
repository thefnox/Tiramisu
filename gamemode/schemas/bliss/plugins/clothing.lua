PLUGIN.Name = "Clothing"; -- What is the plugin name
PLUGIN.Author = "Big Bang"; -- Author of the plugin
PLUGIN.Description = "Enables you to wear fucking clothes :D"; -- The description or purpose of the plugin


--This list is taken from PAC, thanks to the PAC development team.
local BoneList, EditorBone = {
	["pelvis"			] = "ValveBiped.Bip01_Pelvis"		,
	["spine 1"			] = "ValveBiped.Bip01_Spine"		,
	["spine 2"			] = "ValveBiped.Bip01_Spine1"		,
	["spine 3"			] = "ValveBiped.Bip01_Spine2"		,
	["spine 4"			] = "ValveBiped.Bip01_Spine4"		,
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

local function BoneTranslate( bone )
	return BoneList[string.lower(bone)]
end

local function PlayerDeath( Victim, Inflictor, Attacker )

		if( Victim.Clothing ) then
			for k, v in pairs( Victim.Clothing ) do
				if( ValidEntity( v ) ) then
					v:SetParent( Victim:GetRagdollEntity() )
					v:Initialize()
				end
			end
		end
	   

end

hook.Add( "PlayerDeath", "PlayerRemoveClothing", PlayerDeath )


	local meta = FindMetaTable( "Player" );
	
	function CAKE.SetClothing( ply, body, helmet, glove )
		
		local usegloves = false
		local usearmor = false
		if body and body != "none" then
			CAKE.CalculateShields( ply, body )
			if ply:HasItem( body ) then
				if CAKE.ItemData[ body ].Flags then
					if ply:ItemHasFlag( body, "nogloves" ) then
						usegloves = true
						glove = "none"
					end
				end
				body = CAKE.ItemData[ body ].Model
			end
		else
			body = CAKE.GetCharField( ply, "model" )
		end
		
		if !helmet or helmet == "none" or !ply:HasItem( helmet ) then
			helmet = CAKE.GetCharField( ply, "model" )
		else
			helmet = CAKE.ItemData[ helmet ].Model
		end
		
		if usegloves then
			if !glove or glove == "none" then
				if CAKE.GetCharField( ply, "gloves" ) != "none" then
					glove = CAKE.GetCharField( ply, "gloves" )
				else
					glove = CAKE.GetCharField( ply, "model" )
				end
			end
		else
			glove = body
		end
		
		CAKE.HandleClothing( ply, body, 1 )
		CAKE.HandleClothing( ply, helmet or body, 2 )
		CAKE.HandleClothing( ply, glove or body, 3 )
		--ply:SetRenderMode( RENDERMODE_NONE )
		
	end
	
	function meta:RemoveClothing()
		if self.Clothing then
			CAKE.RemoveAllGear( self )
		
			for k, v in pairs( self.Clothing ) do
				if type( v ) != "table" then
					if ValidEntity( v ) then
						v:Remove()
						v = nil
					end
				end
			end
		end
		
		self.Clothing = {}
		
	end
	
	function CAKE.HandleClothing( ply, model, type )
		
		if !ply.Clothing then
			ply.Clothing = {}
		end
		
		ply.Clothing[ type ] = ents.Create( "player_part" )
		ply.Clothing[ type ]:SetDTInt( 1, type )
		ply.Clothing[ type ]:SetDTInt( 2, ply:EntIndex() )
		ply.Clothing[ type ]:SetDTInt( 3, CAKE.GetCharField( ply, "headratio" ) or 1 )
		ply.Clothing[ type ]:SetModel( model )
		ply.Clothing[ type ]:SetParent( ply )
		ply.Clothing[ type ]:SetPos( ply:GetPos() )
		ply.Clothing[ type ]:SetAngles( ply:GetAngles() )
		ply.Clothing[ type ]:Spawn()
		
	end
	
	function CAKE.HandleGear( ply, model, bone, offset, angle )
	
		if !ply.Clothing then
			ply.Clothing = {}
		end
		
		if !ply.Clothing.Gear then
			ply.Clothing.Gear = {}
		end
		
		if !ply.Clothing.Gear[ bone ] then
			ply.Clothing.Gear[ bone ] = {}
		end
		
		local index = #ply.Clothing.Gear + 1
		
		ply.Clothing.Gear[ bone ][ index ] = ents.Create( "player_gear" )
		ply.Clothing.Gear[ bone ][ index ]:SetDTInt( 1, ply:LookupBone( bone ) )
		ply.Clothing.Gear[ bone ][ index ]:SetDTEntity( 2, ply )
		ply.Clothing.Gear[ bone ][ index ]:SetDTAngle( 3, angle )
		ply.Clothing.Gear[ bone ][ index ]:SetDTVector( 4, offset )
		ply.Clothing.Gear[ bone ][ index ]:SetModel( model )
		ply.Clothing.Gear[ bone ][ index ]:SetParent( ply )
		ply.Clothing.Gear[ bone ][ index ]:SetPos( ply:GetPos() )
		ply.Clothing.Gear[ bone ][ index ]:SetAngles( ply:GetAngles() )
		--ply.Clothing.Gear[ index ]:SetModelScale( scale )
		ply.Clothing.Gear[ bone ][ index ]:Spawn()
		
		print( " WHOA WHOA! SETTING YOUR SHIT TO THE FOLLOWING! BONEID:" .. tostring( ply.Clothing.Gear[ bone ][ index ]:GetDTInt( 1 ) )
		.. ", ENTITY:" .. tostring( ply.Clothing.Gear[ bone ][ index ]:GetDTEntity( 2 ):Nick() )
		.. ", ANGLE:" .. tostring( ply.Clothing.Gear[ bone ][ index ]:GetDTAngle( 3 ) )
		.. ", VECTOR:" .. tostring( ply.Clothing.Gear[ bone ][ index ]:GetDTVector( 4 ) )
		.. ", ENTITY ID:" .. tostring( ply.Clothing.Gear[ bone ][ index ]:EntIndex() ) .. "!" )
	end
	
function CAKE.RemoveGear( ply, bone, index )
		if index then
		ply.Clothing.Gear[ bone ][ index ]:Remove()
		ply.Clothing.Gear[ bone ][ index ] = nil
	else
		for k, v in pairs( ply.Clothing.Gear[ bone ] ) do
			v:Remove()
			v = nil
		end
		ply.Clothing.Gear[ bone ] = {}
	end
end
	
function CAKE.RemoveAllGear( ply )
	if ply.Clothing.Gear then
		for k, v in pairs( ply.Clothing.Gear ) do
			for k2, v2 in pairs( ply.Clothing.Gear[ v ] ) do
				if ValidEntity( v2 ) then
					v2:Remove()
					v2 = nil		
				end
			end
			ply.Clothing.Gear[ v ] = {}
		end
	end
		
	ply.Clothing.Gear = {}
end
	
local function SpawnClothingHook( ply )
	if ply:IsCharLoaded() then
		timer.Simple( 0.4, function()
			ply:RemoveClothing()
			local clothes = CAKE.GetCharField( ply, "clothing" )
			local helmet = CAKE.GetCharField( ply, "helmet" )
			ply:SetNWString( "model", clothes )
			CAKE.SetClothing( ply, clothes, helmet, "none" )
			CAKE.SetCharField( ply, "clothing", clothes )
			CAKE.SetCharField( ply, "helmet", helmet )
			CAKE.SendConsole( ply, "Clothing set to:" .. clothes );
			CAKE.SendConsole( ply, "Helmet set to:" .. helmet );
		end)
	end
end
hook.Add( "PlayerSpawn", "PlayerSpawnClothing", SpawnClothingHook )

local function ccSetClothing( ply, cmd, args )
	
	local body = ""
	local helmet = ""
	local gloves = ""
	
	if( args[1] == "" or args[1] == "none" )then
		body = "none"
	else
		body = args[1]
	end
	
	if( args[2] == "" or args[2] == "none" )then
		helmet = "none"
	else
		helmet = args[2]
	end
	
	if args[3] then
		if( args[3] == "" or args[3] == "none" )then
			gloves = "none"
		else
			gloves = args[3]
		end
	else
		gloves = body
	end
	
	ply:RemoveClothing()
	
	CAKE.SetClothing( ply, body, helmet, gloves )
	CAKE.SetCharField( ply, "clothing", body )
	CAKE.SetCharField( ply, "helmet", helmet )

end
concommand.Add( "rp_setclothing", ccSetClothing );

local function ccSetGear( ply, cmd, args )
	
	local model = args[1]
	local bone = args[2]
	local offset = Vector( tonumber( args[3] ), tonumber( args[4] ), tonumber( args[5] ) )
	local angle = Angle( tonumber( args[6] ), tonumber( args[7] ), tonumber( args[8] ) )
	
	CAKE.HandleGear( ply, model, bone, offset, angle )

end
concommand.Add( "rp_setgear", ccSetGear )

local function ccRemoveGear( ply, cmd, args )
	
	if( args[2] and args[2] != "" ) then
		CAKE.RemoveGear( ply, args[1], tonumber( args[2] ))
	elseif( args[1] and args[1] != "" ) then
		CAKE.RemoveGear( ply, args[1] )
	else
		CAKE.RemoveAllGear( ply )
	end

end
concommand.Add( "rp_removegear", ccRemoveGear )

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "gloves", "none" ); --What you're wearing on your hands
	CAKE.AddDataField( 2, "clothing", "none" ); --What you're wearing on your body
	CAKE.AddDataField( 2, "helmet", "none" ); --What you're wearing on your head
	CAKE.AddDataField( 2, "headratio", 1 ); --for those bighead guys.
	CAKE.AddDataField( 2, "gear", {} ); --Whatever the fuck else you're wearing.
	
end