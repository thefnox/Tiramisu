PLUGIN.Name = "Clothing"; -- What is the plugin name
PLUGIN.Author = "Big Bang"; -- Author of the plugin
PLUGIN.Description = "Enables you to wear fucking clothes :D"; -- The description or purpose of the plugin

--0: No bone resizing
--1: Body only, no head nor hands
--2: Head only
--3: Hands only
--4: Head and body.
--5: Hands and body.


CLOTHING_FULL = 0
CLOTHING_BODY = 1
CLOTHING_HEAD = 2
CLOTHING_HANDS = 3
CLOTHING_HEADANDBODY = 4
CLOTHING_BODYANDHANDS = 5

--Removes a player's clothing on death
hook.Add( "PlayerDeath", "TiramisuRemoveClothingOnDeath", function( Victim, Inflictor, Attacker )

	if( Victim.Clothing ) then
		for k, v in pairs( Victim.Clothing ) do
			if( ValidEntity( v ) ) then
				if ValidEntity( Victim.deathrag ) then
					v:SetParent( Victim.deathrag )
				else
					v:SetParent( Victim:GetRagdollEntity() )
				end
				v:Initialize()
			end
		end
	end

end )

hook.Add( "PlayerSetModel", "TiramisuSpawnClothing", function( ply )

	--This is a kinda ridiculous override I use for gear that uses bonemerge. It's the only way to allow gear with bones to be rendered manually.
	if !ply.BonemergeGearEntity or ply.BonemergeGearEntity:GetParent() != ply then
		ply.BonemergeGearEntity = ents.Create( "player_gearhandler" )
		ply.BonemergeGearEntity:SetPos( ply:GetPos() + ply:GetUp() * 80 )
		ply.BonemergeGearEntity:SetAngles( ply:GetAngles() )
		ply.BonemergeGearEntity:SetModel("models/tiramisu/gearhandler.mdl")
		ply.BonemergeGearEntity:SetParent( ply )
		ply.BonemergeGearEntity:SetNoDraw( true )
		ply.BonemergeGearEntity:SetSolid( SOLID_NONE )
		ply.BonemergeGearEntity:Spawn()
		ply.BonemergeGearEntity:DrawShadow( false )
		ply.BonemergeGearEntity.Think = function()
			if ( ply.BonemergeGearEntity:IsOnFire() ) then
				ply.BonemergeGearEntity:Extinguish()
			end
		end
	end

	if ply:IsCharLoaded() then
		timer.Simple( 0.4, function() 
			CAKE.RestoreClothing( ply )
		end)
	end


end)

--Removes all of a player's clothing.
function CAKE.RemoveClothing( ply )

	if ply.Clothing then
		for k, v in pairs( ply.Clothing ) do
			if type( v ) != "table" then
				if ValidEntity( v ) then
					v:Remove()
					v = nil
				end
			end
		end
	end

	ply.Clothing = {}	

end

--Removes only the helmet of a player, if wearing any.
function CAKE.RemoveHelmet( ply )
	
	CAKE.SetClothing( ply, CAKE.GetCharField( ply, "clothing" ) )
		
end
	
--Main function to set a player's clothing based on at least one item. Helmet is not a necessary argument.
function CAKE.SetClothing( ply, clothing, helmet )

	CAKE.RemoveClothing( ply )

	if ( clothing and ply:HasItem( clothing )) or helmet then
		print(clothing, helmet)
		local item
		if helmet and helmet != clothing then
			if ply:ItemHasFlag( clothing, "nogloves" ) then --Head, body and hands are 
				CAKE.HandleClothing( ply, clothing, CLOTHING_BODY )
				CAKE.HandleClothing( ply, helmet, CLOTHING_HEAD )
				CAKE.HandleClothing( ply, "none", CLOTHING_HANDS )
			else --Head and hands are the same, so we just make the head and the body.
				CAKE.HandleClothing( ply, clothing , CLOTHING_BODYANDHANDS )
				CAKE.HandleClothing( ply, helmet, CLOTHING_HEAD )
			end
			item = helmet
		else
			if !helmet then
				CAKE.HandleClothing( ply, clothing, CLOTHING_BODY )
				CAKE.HandleClothing( ply, "none", CLOTHING_HEAD )
				CAKE.HandleClothing( ply, "none", CLOTHING_HANDS )
			elseif ply:ItemHasFlag( clothing, "nogloves" ) then --If the head is the same as the body, you only have to make the hands.
				CAKE.HandleClothing( ply, clothing , CLOTHING_HEADANDBODY )
				CAKE.HandleClothing( ply, "none", CLOTHING_HANDS )
			else --If body, head and hands are all the same, make a single clothing entity.
				
				CAKE.HandleClothing( ply, clothing , CLOTHING_FULL )
			end
			item = clothing
		end

		if CAKE.ItemData[ item ] then
			if ply:GetGender() == "Female" and CAKE.ItemData[ item ].FemaleModel then
				ply:SetNWString( "model", CAKE.ItemData[ item ].FemaleModel )
			else
				ply:SetNWString( "model", CAKE.ItemData[ item ].Model )
			end
		else
			ply:SetNWString( "model", CAKE.GetCharField( ply, "model" ) )
		end

	elseif !clothing or clothing == "none" then

		CAKE.HandleClothing( ply, "none" , CLOTHING_FULL )
		ply:SetNWString( "model", CAKE.GetCharField( ply, "model" ) )

	end
	
	CAKE.SendClothingToClient( ply )
		
end

--Allows you to try a set of clothes without actually owning the item.
function CAKE.TestClothing( ply, model, clothing, helmet)

	CAKE.RemoveClothing( ply )

	if ( clothing and clothing != "none" ) or helmet then
		local item
		if helmet and helmet != clothing then
			if ply:ItemHasFlag( clothing, "nogloves" ) then --Head, body and hands are 
				CAKE.HandleClothing( ply, clothing, CLOTHING_BODY, model )
				CAKE.HandleClothing( ply, helmet, CLOTHING_HEAD, model )
				CAKE.HandleClothing( ply, "none", CLOTHING_HANDS, model )
			else --Head and hands are the same, so we just make the head and the body.
				CAKE.HandleClothing( ply, clothing , CLOTHING_BODYANDHANDS, model )
				CAKE.HandleClothing( ply, helmet, CLOTHING_HEAD, model)
			end
			item = helmet
		else
			if !helmet then
				CAKE.HandleClothing( ply, clothing, CLOTHING_BODY )
				CAKE.HandleClothing( ply, "none", CLOTHING_HEAD )
				CAKE.HandleClothing( ply, "none", CLOTHING_HANDS )
			elseif ply:ItemHasFlag( clothing, "nogloves" ) then --If the head is the same as the body, you only have to make the hands.
				CAKE.HandleClothing( ply, clothing , CLOTHING_HEADANDBODY, model )
				CAKE.HandleClothing( ply, "none", CLOTHING_HANDS , model )
			else --If body, head and hands are all the same, make a single clothing entity.
				CAKE.HandleClothing( ply, clothing , CLOTHING_FULL, model)
			end
			item = clothing
		end

		if CAKE.ItemData[ item ] then
			if ply:GetGender() == "Female" and CAKE.ItemData[ item ].FemaleModel then
				ply:SetNWString( "model", CAKE.ItemData[ item ].FemaleModel )
			else
				ply:SetNWString( "model", CAKE.ItemData[ item ].Model )
			end
		else
			ply:SetNWString( "model", model )
		end
			
	elseif !clothing or clothing == "none" then

		CAKE.HandleClothing( ply, "none" , CLOTHING_FULL, model )
		ply:SetNWString( "model", model )

	end


	CAKE.SendClothingToClient( ply )
		
end

--Internal function to handle clothing creation.
function CAKE.HandleClothing( ply, item, ctype, modeloverride )
	
	local model

	if CAKE.ItemData[ item ] then
		if ply:GetGender() == "Female" and CAKE.ItemData[ item ].FemaleModel then
			model = CAKE.ItemData[ item ].FemaleModel
		else
			model = CAKE.ItemData[ item ].Model
		end
	else
		model = modeloverride or CAKE.GetCharField( ply, "model" )
	end

	if !ply.Clothing then
		ply.Clothing = {}
	end
		
	if ValidEntity( ply.Clothing[ ctype ] ) and ply.Clothing[ tcype ]:GetParent() == ply then
		ply.Clothing[ ctype ]:Remove()
	end
	
	ply.Clothing[ ctype ] = ents.Create( "player_part" )
	ply.Clothing[ ctype ]:SetDTInt( 1, ctype )
	ply.Clothing[ ctype ]:SetDTInt( 2, ply:EntIndex() )
	ply.Clothing[ ctype ]:SetDTInt( 3, 1 )
	ply.Clothing[ ctype ]:SetModel( model )
	ply.Clothing[ ctype ]:SetParent( ply )
	ply.Clothing[ ctype ]:SetPos( ply:GetPos() )
	ply.Clothing[ ctype ]:SetAngles( ply:GetAngles() )
	if ValidEntity( ply.Clothing[ ctype ]:GetPhysicsObject( ) ) then
		ply.Clothing[ ctype ]:GetPhysicsObject( ):EnableCollisions( false )
	end
	ply.Clothing[ ctype ]:Spawn()
	ply.Clothing[ ctype ].item = item
	
		
end

--Restores a character's clothing based on it's clothing, helmet and gloves fields. Also handles if the player is using a special model.
function CAKE.RestoreClothing( ply )

	CAKE.RemoveClothing( ply )

	local clothes = CAKE.GetCharField( ply, "clothing" )
	if !ply:HasItem( clothes ) then
		CAKE.SetCharField( ply, "clothing", "none" )
		clothes = none
	end

	local helmet = CAKE.GetCharField( ply, "helmet" )
	if !ply:HasItem( helmet ) then
		CAKE.SetCharField( ply, "helmet", "none" )
		helmet = none
	end

	local gloves = CAKE.GetCharField( ply, "gloves" )
	local special = CAKE.GetCharField( ply, "specialmodel" )

	if special == "none" or special == "" then
		ply:SetNWBool( "specialmodel", false )
		CAKE.SetClothing( ply, clothes, helmet, gloves )
	else
		ply:SetNWBool( "specialmodel", true )
		ply:SetNWString( "model", tostring( special ) )
		ply:SetModel( tostring( special ) )
	end

end

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
	
	CAKE.SetClothing( ply, body, helmet )
	CAKE.SetCharField( ply, "clothing", body )
	CAKE.SetCharField( ply, "helmet", helmet )

end
concommand.Add( "rp_setclothing", ccSetClothing );

--Sends the clothing entity indexes, in order to use them clientside.
function CAKE.SendClothingToClient( ply )
	
	if ply.Clothing then
		umsg.Start( "clearclothing", ply )
		umsg.End()
		timer.Simple( ply:Ping() / 100 + 0.5, function()
			for k, v in pairs( ply.Clothing ) do
				if ValidEntity( v ) then
					umsg.Start( "addclothing", ply )
						umsg.Short( v:EntIndex() )
						umsg.String( v.item or "none" )
					umsg.End()
				end
			end
		end)
	end

end

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "gloves", "none" ); --What you're wearing on your hands
	CAKE.AddDataField( 2, "clothing", "none" ); --What you're wearing on your body
	CAKE.AddDataField( 2, "helmet", "none" ); --What you're wearing on your head
	CAKE.AddDataField( 2, "headratio", 1 ); --for those bighead guys.
	CAKE.AddDataField( 2, "specialmodel", "none" );
	
end