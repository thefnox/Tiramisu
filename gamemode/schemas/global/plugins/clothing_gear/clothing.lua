PLUGIN.Name = "Clothing" -- What is the plugin name
PLUGIN.Author = "Big Bang" -- Author of the plugin
PLUGIN.Description = "Enables you to wear fucking clothes :D" -- The description or purpose of the plugin

--0: No bone resizing.
--1: Body only, no head nor hands.
--2: Head only.
--3: Hands only.
--4: Head and body.
--5: Hands and body.
--6: Head and hands.


CLOTHING_FULL = 0
CLOTHING_BODY = 1
CLOTHING_HEAD = 2
CLOTHING_HANDS = 3
CLOTHING_HEADANDBODY = 4
CLOTHING_BODYANDHANDS = 5
CLOTHING_HEADANDHANDS = 6


--Enums for the DTVars, they are the same than the DTVar unique ID
CLOTHING_TYPE = 1
CLOTHING_PARENTINDEX = 2 --The entity index of the parent.
CLOTHING_HEADRATIO = 1
CLOTHING_BODYRATIO = 2
CLOTHING_HANDRATIO = 3

hook.Add( "PlayerSetModel", "TiramisuSpawnClothing", function( ply )

	--This is a kinda ridiculous override I use for gear that uses bonemerge. It's the only way to allow gear with bones to be rendered manually.

	if ply:IsCharLoaded() then
		timer.Simple( 0.4, function() 
			TIRA.RestoreClothing( ply )
		end)
	end

	if !ValidEntity(ply.BonemergeGearEntity) or ply.BonemergeGearEntity:GetParent() != ply then
		ply.BonemergeGearEntity = ents.Create( "player_gearhandler" )
		ply.BonemergeGearEntity:SetPos( ply:GetPos() + ply:GetUp() * 80 )
		ply.BonemergeGearEntity:SetAngles( ply:GetAngles() )
		ply.BonemergeGearEntity:SetModel("models/gibs/agibs.mdl")
		ply.BonemergeGearEntity:SetParent( ply )
		ply.BonemergeGearEntity:SetMaterial("models/null")
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


end)

--Removes all of a player's clothing.
function TIRA.RemoveClothing( ply )

	if ply.Clothing then
		for k, v in pairs( ply.Clothing ) do
			if ValidEntity( v ) then
				v:Remove()
				v = nil
			end
		end
	end

	ply.Clothing = {}	

end

function TIRA.RemoveClothingID( ply, itemid )
	if ply.Clothing then
		for k, v in pairs( ply.Clothing ) do
			if ValidEntity( v ) and v.itemid == itemid then
				if string.match( v.item, "clothing_" ) then
					TIRA.SetCharField( ply,"clothing", "none" )
					TIRA.SetCharField( ply,"clothingid", "none" )
				elseif string.match( v.item, "helmet_" ) then
					TIRA.SetCharField( ply,"helmet", "none" )
					TIRA.SetCharField( ply,"helmetid", "none" )
				end
				TIRA.RestoreClothing( ply )
			end
		end
	end
end

--Removes only the helmet of a player, if wearing any.
function TIRA.RemoveHelmet( ply )
	
	TIRA.SetClothing( ply, TIRA.GetCharField( ply, "clothing" ), TIRA.GetCharField( ply, "clothingid" ) )
		
end
	
--Main function to set a player's clothing based on at least one item. Helmet is not a necessary argument.
function TIRA.SetClothing( ply, clothing, helmet, clothingid, helmetid )

	TIRA.RemoveClothing( ply )

	if ( clothing and ply:HasItem( clothing )) or helmet then
		local item
		if helmet and helmet != clothing then
			if (TIRA.GetUData( clothingid, "nogloves") or ply:ItemHasFlag( clothing, "nogloves" )) then --Head, body and hands are different
				TIRA.HandleClothing( ply, clothing, CLOTHING_BODY, clothingid )
				TIRA.HandleClothing( ply, helmet, CLOTHING_HEAD, helmetid )
				TIRA.HandleClothing( ply, "none", CLOTHING_HANDS )
			else --Head and hands are the same, so we just make the head and the body.
				TIRA.HandleClothing( ply, clothing , CLOTHING_BODYANDHANDS, clothingid )
				TIRA.HandleClothing( ply, helmet, CLOTHING_HEAD, helmetid )
			end
			item = helmet
		else
			if !helmet and !(TIRA.GetUData( clothingid, "nogloves") or ply:ItemHasFlag( clothing, "nogloves" )) then
				TIRA.HandleClothing( ply, clothing, CLOTHING_BODYANDHANDS, clothingid )
				TIRA.HandleClothing( ply, "none", CLOTHING_HEAD, helmetid )
			elseif !helmet and (TIRA.GetUData( clothingid, "nogloves") or ply:ItemHasFlag( clothing, "nogloves" )) then --If the head is the same as the body, you only have to make the hands.
				TIRA.HandleClothing( ply, clothing , CLOTHING_BODY, clothingid )
				TIRA.HandleClothing( ply, "none", CLOTHING_HEADANDHANDS )
			elseif helmet == clothing then --If body, head and hands are all the same, make a single clothing entity.
				TIRA.HandleClothing( ply, clothing , CLOTHING_FULL, clothingid )
			end
			item = clothing
		end

	elseif !clothing or clothing == "none" then

		TIRA.HandleClothing( ply, "none" , CLOTHING_FULL, "none" )

	end

	TIRA.ChangeClothingBodygroups( ply )
	TIRA.SendClothingToClient( ply )
		
end

--Scales individual body parts.
function TIRA.ScaleClothing( ply, headratio, bodyratio, handratio )
	headratio, bodyratio, handratio = headratio or TIRA.GetCharField( ply, "headratio" ), bodyratio or TIRA.GetCharField( ply, "bodyratio" ), handratio or TIRA.GetCharField( ply, "handratio" )
	for _, ent in pairs( ply.Clothing ) do
		if ValidEntity( ent ) then
			ent:SetDTFloat( CLOTHING_HEADRATIO, headratio )
			ent:SetDTFloat( CLOTHING_BODYRATIO, bodyratio )
			ent:SetDTFloat( CLOTHING_HANDRATIO, handratio )
		end
	end
	TIRA.SetCharField( ply, "headratio", headratio )
	TIRA.SetCharField( ply, "bodyratio", bodyratio )
	TIRA.SetCharField( ply, "handratio", handratio )
end

function TIRA.ChangeClothingBodygroups( ply, bodygroup1, bodygroup2, bodygroup3 )
	bodygroup1, bodygroup2, bodygroup3 = bodygroup1 or TIRA.GetCharField( ply, "bodygroup1" ), bodygroup2 or TIRA.GetCharField( ply, "bodygroup2" ), bodygroup3 or TIRA.GetCharField( ply, "bodygroup3" )
	local skin = TIRA.GetCharField( ply, "skin" )
	for _, ent in pairs( ply.Clothing ) do
		if ValidEntity( ent ) and ent:GetModel() == TIRA.GetCharField( ply, "model" ) then
			ent:SetBodygroup( 1, bodygroup1 )
			ent:SetBodygroup( 2, bodygroup2 )
			ent:SetBodygroup( 3, bodygroup3 )
			ent:SetSkin( skin )
		end
	end
	TIRA.SetCharField( ply, "bodygroup1", bodygroup1 )
	TIRA.SetCharField( ply, "bodygroup2", bodygroup2 )
	TIRA.SetCharField( ply, "bodygroup3", bodygroup3 )
end

--Allows you to try a set of clothes without actually owning the item.
function TIRA.TestClothing( ply, model, clothing, helmet, headratio, bodyratio, handratio, clothingid, helmetid, bodygroup1, bodygroup2, bodygroup3, skin )

	TIRA.RemoveClothing( ply )

	if ( clothing and clothing != "none" ) or helmet then
		local item
		if helmet and helmet != clothing then
			if (TIRA.GetUData( clothingid, "nogloves") or ply:ItemHasFlag( clothing, "nogloves" )) then --Head, body and hands are all different 
				TIRA.HandleClothing( ply, clothing, CLOTHING_BODY, clothingid, model )
				TIRA.HandleClothing( ply, helmet, CLOTHING_HEAD, helmetid, model )
				TIRA.HandleClothing( ply, "none", CLOTHING_HANDS, "none", model )
			else --Head and hands are the same, so we just make the head and the body.
				TIRA.HandleClothing( ply, clothing , CLOTHING_BODYANDHANDS, clothingid, model )
				TIRA.HandleClothing( ply, helmet, CLOTHING_HEAD, helmetid, model)
			end
			item = helmet
		else
			if !helmet then
				TIRA.HandleClothing( ply, clothing, CLOTHING_BODYANDHANDS, clothingid, model )
				TIRA.HandleClothing( ply, "none", CLOTHING_HEAD, "none", model )
			elseif !helmet and (TIRA.GetUData( clothingid, "nogloves") or ply:ItemHasFlag( clothing, "nogloves" )) then --If the head is the same as the body, you only have to make the hands.
				TIRA.HandleClothing( ply, clothing , CLOTHING_BODY, clothingid, model )
				TIRA.HandleClothing( ply, "none", CLOTHING_HEADANDHANDS, "none", model )
			else --If body, head and hands are all the same, make a single clothing entity.
				
				TIRA.HandleClothing( ply, clothing , CLOTHING_FULL, clothingid, model )
			end
			item = clothing
		end

		if TIRA.ItemData[ item ] then
			if ply:GetGender() == "Female" and TIRA.ItemData[ item ].FemaleModel then
				ply:SetNWString( "model", TIRA.GetUData( clothingid, "model") or TIRA.ItemData[ item ].FemaleModel )
			else
				ply:SetNWString( "model", TIRA.GetUData( clothingid, "model") or TIRA.ItemData[ item ].Model )
			end
		else
			ply:SetNWString( "model", model )
		end
			
	elseif !clothing or clothing == "none" then

		TIRA.HandleClothing( ply, "none" , CLOTHING_FULL, "none", model )
		ply:SetNWString( "model", model )

	end

	headratio, bodyratio, handratio = headratio or 1, bodyratio or 1, handratio or 1
	bodygroup1, bodygroup2, bodygroup3 = bodygroup1 or 0, bodygroup2 or 0, bodygroup3 or 0
	skin = skin or 0

	for _, ent in pairs( ply.Clothing ) do
		if ValidEntity( ent ) then
			if ent:GetModel() == model then
				ent:SetBodygroup( 1, bodygroup1 )
				ent:SetBodygroup( 2, bodygroup2 )
				ent:SetBodygroup( 3, bodygroup3 )
				ent:SetSkin( skin )
			end
			ent:SetDTFloat( CLOTHING_HEADRATIO, headratio )
			ent:SetDTFloat( CLOTHING_BODYRATIO, bodyratio )
			ent:SetDTFloat( CLOTHING_HANDRATIO, handratio )
		end
	end

	TIRA.SendClothingToClient( ply )
		
end

--Internal function to handle clothing creation.
function TIRA.HandleClothing( ply, item, ctype, itemid, modeloverride )

	local model

	if TIRA.ItemData[ item ] then
		if ply:GetGender() == "Female" and TIRA.ItemData[ item ].FemaleModel then
			model = TIRA.GetUData( itemid, "model") or TIRA.ItemData[ item ].FemaleModel
		else
			model = TIRA.GetUData( itemid, "model") or TIRA.ItemData[ item ].Model
		end
	else
		model = modeloverride or TIRA.GetCharField( ply, "model" )
	end



	if !ply.Clothing then
		ply.Clothing = {}
	end
		
	if ValidEntity( ply.Clothing[ ctype ] ) and ply.Clothing[ tcype ]:GetParent() == ply then
		ply.Clothing[ ctype ]:Remove()
	end
	
	ply.Clothing[ ctype ] = ents.Create( "player_part" )
	ply.Clothing[ ctype ]:SetDTInt( CLOTHING_TYPE, ctype )
	ply.Clothing[ ctype ]:SetDTInt( CLOTHING_PARENTINDEX, ply:EntIndex() )
	ply.Clothing[ ctype ]:SetDTFloat( CLOTHING_HEADRATIO, TIRA.GetCharField( ply, "headratio" ) )
	ply.Clothing[ ctype ]:SetDTFloat( CLOTHING_BODYRATIO, TIRA.GetCharField( ply, "bodyratio" ) )
	ply.Clothing[ ctype ]:SetDTFloat( CLOTHING_HANDRATIO, TIRA.GetCharField( ply, "handratio" ) )
	ply.Clothing[ ctype ]:SetModel( model )
	ply.Clothing[ ctype ]:SetParent( ply )
	ply.Clothing[ ctype ]:SetPos( ply:GetPos() )
	ply.Clothing[ ctype ]:SetAngles( ply:GetAngles() )
	if ValidEntity( ply.Clothing[ ctype ]:GetPhysicsObject( ) ) then
		ply.Clothing[ ctype ]:GetPhysicsObject( ):EnableCollisions( false )
	end
	ply.Clothing[ ctype ]:Spawn()
	ply.Clothing[ ctype ].item = item
	ply.Clothing[ ctype ].itemid = itemid or "none"
	
		
end

--Restores a character's clothing based on it's clothing, helmet and gloves fields. Also handles if the player is using a special model.
function TIRA.RestoreClothing( ply )

	TIRA.RemoveClothing( ply )

	if !ply:GetNWBool( "specialmodel" ) then
		local clothes = TIRA.GetCharField( ply, "clothing" )
		local clothingid = TIRA.GetCharField(ply,"clothingid")
		if clothingid then
			if !ply:HasItemID( clothingid ) then
				TIRA.SetCharField( ply, "clothing", "none" )
				TIRA.SetCharField( ply, "clothingid", "none" )
				clothes = "none"
			end
		else
			if !ply.HasItem("clothing") then
				TIRA.SetCharField( ply, "clothing", "none" )
				TIRA.SetCharField( ply, "clothingid", "none" )
				clothes = "none"
			end
		end

		local helmet = TIRA.GetCharField( ply, "helmet" )
		local helmetid = TIRA.GetCharField(ply,"helmetid")
		if helmetid then 
			if !ply:HasItemID( helmetid ) then
				TIRA.SetCharField( ply, "helmet", "none" )
				TIRA.SetCharField( ply, "helmetid", "none" )
				helmet = "none"
			end
		else
			if !ply:HasItem( helmet ) then
				TIRA.SetCharField( ply, "helmet", "none" )
				TIRA.SetCharField( ply, "helmetid", "none" )
				helmet = "none"
			end
		end
		TIRA.SetClothing( ply, clothes, helmet, clothingid, helmetid )
	end
end

concommand.Add( "rp_setclothing", function( ply, cmd, args )
	local body = ""
	local helmet = ""
	local clothingid, helmetid = args[3], args[4]
	
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
	
	TIRA.SetClothing( ply, body, helmet, clothingid, helmetid )
	TIRA.SetCharField( ply, "clothing", body )
	TIRA.SetCharField( ply, "helmet", helmet )
	TIRA.SetCharField( ply, "clothingid", clothingid )
	TIRA.SetCharField( ply, "helmetid", helmetid )
	if TIRA.ConVars[ "AllowRescaling" ] then
		TIRA.ScaleClothing( ply, 1, 1, 1 )
	end

end)

concommand.Add( "rp_scaleclothing", function( ply, cmd, args )
	if TIRA.ConVars[ "AllowRescaling" ] then
		local headratio, bodyratio, handratio = math.Clamp(tonumber(args[1] or 1),0.5,1.2), math.Clamp(tonumber(args[2] or 1),0.5,1.2), math.Clamp(tonumber(args[3] or 1),0.5,1.2)
		TIRA.ScaleClothing( ply, headratio, bodyratio, handratio )
	end
end)

concommand.Add( "rp_bodygroupsclothing", function( ply, cmd, args )
	if TIRA.ConVars[ "AllowBodygroups" ] then
		local bod1, bod2, bod3 = math.Clamp(tonumber(args[1] or 1),0,10), math.Clamp(tonumber(args[2] or 1),0,10), math.Clamp(tonumber(args[3] or 1),0,10)
		TIRA.ChangeClothingBodygroups( ply, bod1, bod2, bod3 )
	end
end)

concommand.Add( "rp_setplayerskin", function( ply, cmd, args )
	if TIRA.ConVars[ "AllowBodygroups" ] then
		TIRA.SetCharField( ply, "skin", tonumber(args[1] or 0))
	end
end)

--Sends the clothing entity indexes, in order to use them clientside.
function TIRA.SendClothingToClient( ply )
	
	if ply.Clothing then
		umsg.Start( "clearclothing", ply )
		umsg.End()
		timer.Simple( ply:Ping() / 100 + 0.5, function()
			if ply.Clothing then
				for k, v in pairs( ply.Clothing ) do
					if ValidEntity( v ) then
						umsg.Start( "addclothing", ply )
							umsg.Short( v:EntIndex() )
							umsg.String( v.item or "none" )
							umsg.String( v.itemid or "none" )
						umsg.End()
					end
				end
			end
		end)
	end

end

function PLUGIN.Init()
	
	TIRA.AddDataField( 2, "gloves", "none" ) --What you're wearing on your hands
	TIRA.AddDataField( 2, "clothing", "none" ) --What you're wearing on your body
	TIRA.AddDataField( 2, "clothingid", "none" ) -- the item id of your clothing item
	TIRA.AddDataField( 2, "helmetid", "none" ) -- the item id of your helmet
	TIRA.AddDataField( 2, "helmet", "none" ) --What you're wearing on your head
	TIRA.AddDataField( 2, "headratio", 1 ) --for those bighead guys.
	TIRA.AddDataField( 2, "bodyratio", 1 ) --Thick bones, or maybe you're just fat.
	TIRA.AddDataField( 2, "handratio", 1 ) --You know what they say about big hands.
	TIRA.AddDataField( 2, "bodygroup1", 0 ) --Bodygroup 1
	TIRA.AddDataField( 2, "bodygroup2", 0 ) --Bodygroup 2
	TIRA.AddDataField( 2, "bodygroup3", 0 ) --Bodygroup 3
	TIRA.AddDataField( 2, "skin", 0, "INT" )
	TIRA.AddDataField( 2, "specialmodel", "none" )
	
end