PLUGIN.Name = "Clothing"; -- What is the plugin name
PLUGIN.Author = "Big Bang"; -- Author of the plugin
PLUGIN.Description = "Enables you to wear fucking clothes :D"; -- The description or purpose of the plugin


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
	
function CAKE.SetClothing( ply, body, helmet, glove )
	
	if body == "none" then
		body = CAKE.GetCharField( ply, "model" )
	end
	if helmet == "none" then
		helmet = CAKE.GetCharField( ply, "model" )
	end
	if glove == "none" then
		glove = CAKE.GetCharField( ply, "model" )
	end
		
	CAKE.HandleClothing( ply, body, 1 )
	CAKE.HandleClothing( ply, helmet or body, 2 )
	CAKE.HandleClothing( ply, glove or body, 3 )
	CAKE.CalculateEncumberment( ply )
	datastream.StreamToClients( ply, "recieveclothing",  ply.Clothing )
		
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
	
function meta:RemoveHelmet()
	
		local body = CAKE.GetCharField( self, "clothing" )
		local face = CAKE.GetCharField( self, "model" )
		local gloves = CAKE.GetCharField( self, "gloves" )
		CAKE.SetClothing( self, body, face, gloves )
		
end
	
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
		ply.Clothing[ type ]:SetDTInt( 3, CAKE.GetCharField( ply, "headratio" ) or 1 )
		ply.Clothing[ type ]:SetModel( model )
		ply.Clothing[ type ]:SetParent( ply )
		ply.Clothing[ type ]:SetPos( ply:GetPos() )
		ply.Clothing[ type ]:SetAngles( ply:GetAngles() )
		if ValidEntity( ply.Clothing[ type ]:GetPhysicsObject( ) ) then
			ply.Clothing[ type ]:GetPhysicsObject( ):EnableCollisions( false )
		end
		ply.Clothing[ type ]:Spawn()
		
		
end
	
local function SpawnClothingHook( ply )
	if ply:IsCharLoaded() then
			timer.Simple( 0.4, function() 
				ply:RemoveClothing()
				local clothes = CAKE.GetCharField( ply, "clothing" )
				local helmet = CAKE.GetCharField( ply, "helmet" )
				local gloves = CAKE.GetCharField( ply, "gloves" )
				local special = CAKE.GetCharField( ply, "specialmodel" )
				if special == "none" or special == "" then
					ply:SetNWBool( "specialmodel", false )
					CAKE.SetClothing( ply, clothes, helmet, gloves )
					if clothes != "none" then
						ply:SetNWString( "model", helmet )
					else
						ply:SetNWString( "model", CAKE.GetCharField( ply, "model" ) )
					end
					CAKE.RemoveAllGear( ply )
					CAKE.RestoreGear( ply )
					CAKE.SendConsole( ply, "Gear Restored" )
					datastream.StreamToClients( ply, "recieveclothing",  ply.Clothing )
				else
					ply:SetNWBool( "specialmodel", true )
					ply:SetNWString( "model", tostring( special ) )
					ply:SetModel( tostring( special ) )
				end
			end)
		timer.Create( ply:SteamID() .. "sendclothes", 1, 0, function()
			datastream.StreamToClients( ply, "recieveclothing",  ply.Clothing )
		end)
	end
end
hook.Add( "PlayerSetModel", "OldenSpawnClothing", SpawnClothingHook )

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
	datastream.StreamToClients( ply, "recieveclothing",  ply.Clothing )

end
concommand.Add( "rp_setclothing", ccSetClothing );

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "gloves", "none" ); --What you're wearing on your hands
	CAKE.AddDataField( 2, "clothing", "none" ); --What you're wearing on your body
	CAKE.AddDataField( 2, "helmet", "none" ); --What you're wearing on your head
	CAKE.AddDataField( 2, "headratio", 1 ); --for those bighead guys.
	CAKE.AddDataField( 2, "specialmodel", "none" );
	
end