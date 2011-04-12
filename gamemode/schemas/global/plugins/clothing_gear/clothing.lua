PLUGIN.Name = "Clothing"; -- What is the plugin name
PLUGIN.Author = "Big Bang"; -- Author of the plugin
PLUGIN.Description = "Enables you to wear fucking clothes :D"; -- The description or purpose of the plugin

--Removes a player's clothing on death
local function PlayerDeath( Victim, Inflictor, Attacker )

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
	   

end

hook.Add( "PlayerDeath", "PlayerRemoveClothing", PlayerDeath )


local meta = FindMetaTable( "Player" );
	
--Main function to set a player's clothing based on at least one item. Helmet and gloves are not necessary arguments.
function CAKE.SetClothing( ply, body, helmet, glove )

	if resourcex then
		if CAKE.ItemData[ body ] and CAKE.ItemData[ body ].Content then
			for k, v in ipairs( CAKE.ItemData[ body ].Content ) do
				print( "Adding " .. v )
				resourcex.AddFile( v, true )
			end
		end
		if CAKE.ItemData[ helmet ] and CAKE.ItemData[ helmet ].Content then
			for k, v in ipairs( CAKE.ItemData[ helmet ].Content ) do
				print( "Adding " .. v )
				resourcex.AddFile( v, true )
			end
		end
	end
	
	if !ply:ItemHasFlag( body, "nogloves" ) then
		glove = body
	else
		glove = "none"
	end
	if !ply:HasItem( helmet ) or helmet == "none" then
		helmet = CAKE.GetCharField( ply, "model" )
	else
		helmet = CAKE.ItemData[ helmet ].Model
	end
	if !ply:HasItem( glove ) or glove == "none" then
		glove = CAKE.GetCharField( ply, "model" )
	else
		glove = CAKE.ItemData[ glove ].Model
	end
	if !ply:HasItem( body ) or body == "none" then
		body = CAKE.GetCharField( ply, "model" )
	else
		body = CAKE.ItemData[ body ].Model
	end
	
	ply:SetNWString( "model", helmet )
	
	helmet = helmet or body
	glove = glove or body
	
	if body == helmet or body == glove then
		if body == helmet and body != glove then --If the same model is used for the head but not for the hands
			CAKE.HandleClothing( ply, body , 4 )
			CAKE.HandleClothing( ply, glove, 3 )
		elseif body != helmet and body == glove then
			CAKE.HandleClothing( ply, body , 5 )
			CAKE.HandleClothing( ply, helmet, 2 )
		elseif body == helmet and body == glove then
			CAKE.HandleClothing( ply, body , 0 )
		end
	else
		CAKE.HandleClothing( ply, body , 1 )
		CAKE.HandleClothing( ply, helmet, 2 )
		CAKE.HandleClothing( ply, glove, 3 )
	end
	
	CAKE.CalculateEncumberment( ply )
	CAKE.SendClothingToClient( ply )
		
end

--Allows you to try a set of clothes without actually owning the item.
function CAKE.TestClothing( ply, model, body, helmet, glove )

	ply:RemoveClothing()
	
	if resourcex then
		if body and CAKE.ItemData[ body ] and CAKE.ItemData[ body ].Content then
			for k, v in ipairs( CAKE.ItemData[ body ].Content ) do
				print( "Adding " .. v )
				resourcex.AddFile( v, true )
			end
		end
		if helmet and CAKE.ItemData[ helmet ] and CAKE.ItemData[ helmet ].Content then
			for k, v in ipairs( CAKE.ItemData[ helmet ].Content ) do
				print( "Adding " .. v )
				resourcex.AddFile( v, true )
			end
		end
	end
	
	if !ply:ItemHasFlag( body, "nogloves" ) then
		glove = body
	end
	if !helmet or helmet == "none" then
		helmet = model
	else
		helmet = CAKE.ItemData[ helmet ].Model
	end
	if !glove or glove == "none" then
		glove = model
	else
		glove = CAKE.ItemData[ glove ].Model
	end
	if !body or body == "none" then
		body = model
	else
		body = CAKE.ItemData[ body ].Model
	end
	
	ply:SetNWString( "model", helmet )
	
	helmet = helmet or body
	glove = glove or body
	
	if body == helmet or body == glove then
		if body == helmet and body != glove then --If the same model is used for the head but not for the hands
			CAKE.HandleClothing( ply, body , 4 )
			CAKE.HandleClothing( ply, glove, 3 )
		elseif body != helmet and body == glove then
			CAKE.HandleClothing( ply, body , 5 )
			CAKE.HandleClothing( ply, helmet, 2 )
		elseif body == helmet and body == glove then
			CAKE.HandleClothing( ply, body , 0 )
		end
	else
		CAKE.HandleClothing( ply, body , 1 )
		CAKE.HandleClothing( ply, helmet, 2 )
		CAKE.HandleClothing( ply, glove, 3 )
	end

	CAKE.SendClothingToClient( ply )
		
end

--Removes all of a player's clothing.
function meta:RemoveClothing()
		if self.Clothing then
		
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

--Removes only the helmet of a player, if wearing any.
function meta:RemoveHelmet()
	
		local body = CAKE.GetCharField( self, "clothing" )
		local face = CAKE.GetCharField( self, "model" )
		local gloves = CAKE.GetCharField( self, "gloves" )
		CAKE.SetClothing( self, body, face, gloves )
		
end

--Internal function to handle clothing creation.
function CAKE.HandleClothing( ply, model, type )
		
		if !ply.Clothing then
			ply.Clothing = {}
		end
		
		if ValidEntity( ply.Clothing[ type ] ) and ply.Clothing[ type ]:GetParent() == ply then
			ply.Clothing[ type ]:Remove()
		end
		
		ply.Clothing[ type ] = ents.Create( "player_part" )
		ply.Clothing[ type ]:SetDTInt( 1, type )
		ply.Clothing[ type ]:SetDTInt( 2, ply:EntIndex() )
		ply.Clothing[ type ]:SetDTInt( 3, 1 )
		ply.Clothing[ type ]:SetModel( model )
		ply.Clothing[ type ]:SetParent( ply )
		ply.Clothing[ type ]:SetPos( ply:GetPos() )
		ply.Clothing[ type ]:SetAngles( ply:GetAngles() )
		if ValidEntity( ply.Clothing[ type ]:GetPhysicsObject( ) ) then
			ply.Clothing[ type ]:GetPhysicsObject( ):EnableCollisions( false )
		end
		ply.Clothing[ type ]:Spawn()
		
		
end

--Restores a character's clothing based on it's clothing, helmet and gloves fields. Also handles if the player is using a special model.
function CAKE.RestoreClothing( ply )
		ply:RemoveClothing()
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
	
local function SpawnClothingHook( ply )

	--This is a kinda ridiculous override I use for gear that uses bonemerge. It's the only way to allow gear with bones to be rendered manually.
	if !ply.BonemergeGearEntity or ply.BonemergeGearEntity:GetParent() != ply then
		ply.BonemergeGearEntity = ents.Create( "prop_physics" )
		ply.BonemergeGearEntity:SetPos( ply:GetPos() + Vector( 0, 0, 80 ) )
		ply.BonemergeGearEntity:SetAngles( ply:GetAngles() )
		ply.BonemergeGearEntity:SetModel("models/Tiramisu/gearhandler.mdl")
		ply.BonemergeGearEntity:SetParent( ply )
		ply.BonemergeGearEntity:SetNoDraw( true )
		ply.BonemergeGearEntity:SetSolid( SOLID_NONE )
		ply.BonemergeGearEntity:Spawn()
		ply.BonemergeGearEntity:DrawShadow( false )
	end

	if ply:IsCharLoaded() then
		timer.Simple( 0.4, function() 
			CAKE.RestoreClothing( ply )
		end)
	end

end
hook.Add( "PlayerSetModel", "TiramisuSpawnClothing", SpawnClothingHook )

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