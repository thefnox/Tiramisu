
-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- player_util.lua
-- Useful functions for players.
-------------------------------

function CAKE.SendChat( ply, msg, font, channel )
	
	if ply:IsPlayer() then
		--ply:PrintMessage( 3, msg );
		datastream.StreamToClients( ply, "TiramisuAddToChat", {
			["text"] = msg,
			["font"] = font or "ChatFont",
			["channel"] = channel or false 
		})
		/*
		umsg.Start( "tiramisuaddtochat", ply )
			umsg.String( msg )
			umsg.String( font )
		umsg.End()*/
		--CAKE.SendConsole( ply, msg )
	else
		for i = 0, msg:len() / 255 do
			MsgN(string.sub( msg, i * 255 + 1, i * 255 + 255 ) )
		end
	end
	
end

function CAKE.SendConsole( ply, msg )

	if ply:IsPlayer() then
		ply:PrintMessage( 2, msg );
	else
		print( msg )
	end
	
end

function CAKE.SendError( ply, msg )

	if ply:IsPlayer() then
		umsg.Start( "senderror", ply )
			umsg.String( msg )
		umsg.End()
	else
		print( msg )
	end
end

DecayingRagdolls = {};

function CAKE.DeathMode( ply )
	
	if ValidEntity( ply.deathrag ) then
		ply.deathrag:Remove()
		ply.deathrag = nil
	end
	
	ply.CheatedDeath = false
	CAKE.DayLog( "script.txt", "Starting death mode for " .. ply:SteamID( ) );
	local mdl = ply:GetModel( )
	
	local rag = ents.Create( "prop_ragdoll" )
	rag:SetModel( mdl )
	rag:SetPos( ply:GetPos( ) )
	rag:SetAngles( ply:GetAngles( ) )
	rag.isdeathdoll = true;
	rag.ply = ply;
	rag:Spawn( )
	
	
	if( ply.Clothing ) then
		for k, v in pairs( ply.Clothing ) do
			if( ValidEntity( v ) ) then
				v:SetParent( rag )
				v:Initialize()
			end
		end
	end
	
	if( ply.Gear ) then
		for k, v in pairs( ply.Gear ) do
			if( ValidEntity( v ) ) then
				v:SetParent( rag )
				v:SetDTEntity( 1, rag )
				v:Initialize()
			end
		end
	end
	
	rag.clothing = ply.Clothing
	ply.Clothing = nil
	ply.Gear = nil
	
	--ply:SetViewEntity( rag );

	rag:GetPhysicsObject():ApplyForceCenter( ply:GetVelocity() )
	rag:GetPhysicsObject():SetVelocity( ply:GetVelocity() )

	ply.deathrag = rag;
	
	ply:SetNWInt( "deathmode", 1 )
	ply:SetNWInt("deathmoderemaining", CAKE.ConVars[ "Respawn_Timer" ] )

	timer.Simple( 1, function()
		umsg.Start( "recieveragdoll", ply )
			umsg.Short( rag:EntIndex() )
		umsg.End()
	end)
	
	ply.deathtime = 0;
	ply.nextsecond = CurTime( ) + 1;
	
	timer.Simple( CAKE.ConVars[ "Respawn_Timer" ], function()
	
		ply:SetNWInt( "deathmode", 0 )
		ply:SetViewEntity( ply );

	
	end)
	
end

function CAKE.UnconciousMode( ply )

	if ply:Alive() then

		if !ply:GetNWBool( "unconciousmode", false ) then
		
			ply:GodEnable()
			ply:SetAiming( false )

			if ply:GetActiveWeapon():IsValid() then
				ply:GetActiveWeapon():SetNoDraw( true )
			end
			
			if ValidEntity( ply.unconciousrag ) then
				ply.unconciousrag:Remove()
				ply.unconciousrag = nil
			end
			
			CAKE.DayLog( "script.txt", "Starting unconcious mode for " .. ply:SteamID( ) );
			local mdl = ply:GetModel( )
			
			local rag = ents.Create( "prop_ragdoll" )
			rag:SetModel( mdl )
			rag:SetPos( ply:GetPos( ) )
			rag:SetAngles( ply:GetAngles( ) )
			rag.ply = ply;
			rag:Spawn( )
			
			if( ply.Clothing ) then
				for k, v in pairs( ply.Clothing ) do
					if( ValidEntity( v ) ) then
						v:SetParent( rag )
						v:Initialize()
					end
				end
			end
			
			if( ply.Gear ) then
				for k, v in pairs( ply.Gear ) do
					if( ValidEntity( v ) ) then
						v:SetParent( rag )
						v:SetDTEntity( 1, rag )
						v:Initialize()
					end
				end
			end
			
			rag:GetPhysicsObject():ApplyForceCenter( ply:GetVelocity() )
			
			rag.clothing = ply.Clothing
			rag.gear = ply.Gear
			ply.Clothing = nil
			ply.Gear = nil
			ply:SetNWBool( "unconciousmode", true ) 
			
			timer.Simple( 1, function()
				umsg.Start( "recieveragdoll", ply )
					umsg.Short( rag:EntIndex() )
				umsg.End()
				umsg.Start( "ToggleFreescroll", ply )
					umsg.Bool( true )
				umsg.End()
			end)
			
			ply.unconciousrag = rag;
			
			ply.unconcioustime = 0;
			ply.nextsecond = CurTime( ) + 1;
			
			ply:Lock()
			
		else
			ply:SetNWBool( "unconciousmode", false )
			ply:SetViewEntity( ply )
			CAKE.RestoreGear( ply )
			ply:SetPos( ply.unconciousrag:GetPos() + Vector( 0, 0, 10 ))
			ply:UnLock()
			CAKE.RestoreClothing( ply )
			ply:GodDisable()
			if ply:GetActiveWeapon():IsValid() then
				ply:GetActiveWeapon():SetNoDraw( false )
			end
			umsg.Start( "recieveragdoll", ply )
				umsg.Short( nil )
			umsg.End()
			umsg.Start( "ToggleFreescroll", ply )
				umsg.Bool( false )
			umsg.End()
			if ply.unconciousrag then
				ply.unconciousrag:Remove()
			end
			if timer.IsTimer( ply:SteamID() .. "UnconciousActionTimer" ) then
				timer.Destroy( ply:SteamID() .. "UnconciousActionTimer" )
			end
			if timer.IsTimer( ply:SteamID() .. "unconcioustimer" ) then
				timer.Destroy( ply:SteamID() .. "unconcioustimer"  )
			end
		end

	end
end


local meta = FindMetaTable( "Player" );

function meta:ConCommand( cmd ) --Rewriting this due to Garry fucking it up.
	umsg.Start( "runconcommand", self )
		umsg.String( cmd ) 
		--Yeah it just sends the command as a string which is then ran clientside. 2 usermessages sent, all because of
		--A REALLY REALLY not well thought fix.
	umsg.End()
end

function meta:MaxHealth( )

	return self:GetNWFloat("MaxHealth");
	
end

function meta:ChangeMaxHealth( amt )

	self:SetNWFloat("MaxHealth", self:MaxHealth() + amt);
	
end

function meta:MaxArmor( )

	return self:GetNWFloat("MaxArmor");
	
end

function meta:ChangeMaxArmor( amt )

	self:SetNWFloat("MaxArmor", self:MaxArmor() + amt);
	
end

function meta:MaxWalkSpeed( )

	return self:GetNWFloat("MaxWalkSpeed");
	
end

function meta:ChangeMaxWalkSpeed( amt )

	self:SetNWFloat("MaxWalkSpeed", self:MaxWalkSpeed() + amt);
	
end

function meta:MaxRunSpeed( )

	return self:GetNWFloat("MaxRunSpeed");
	
end

function meta:ChangeMaxRunSpeed( amt )

	self:SetNWFloat("MaxRunSpeed", self:MaxRunSpeed() + amt);
	
end

function meta:GiveItem( class )

	CAKE.DayLog( "economy.txt", "Adding item '" .. class .. "' to " .. CAKE.FormatCharString( self ) .. " inventory" );
	local inv = CAKE.GetCharField( self, "inventory" );
	table.insert( inv, class );
	CAKE.SetCharField( self, "inventory", inv);
	CAKE.CalculateEncumberment( self )
	if string.match( class, "weapon" ) then
		if !table.HasValue( CAKE.GetCharField( self, "inventory" ), class ) then
			if !table.HasValue( CAKE.GetCharField( self, "weapons" ), class) then
				local weapons = CAKE.GetCharField( self, "weapons" )
				table.insert( weapons, class )
				CAKE.SetCharField( self, "weapons", weapons )
			end
			self:Give( class )
		end 
	end
	
	self:RefreshInventory( );

end

function meta:TakeItem( class )
	local inv = CAKE.GetCharField(self, "inventory" );
	
	for k, v in pairs( inv ) do
		if( v == class ) then
			inv[ k ] = nil;
			CAKE.SetCharField( self, "inventory", inv);
			self:RefreshInventory( );
			CAKE.DayLog( "economy.txt", "Removing item '" .. class .. "' from " .. CAKE.FormatCharString( self ) .. " inventory" );
			return;
		end
	end
	CAKE.CalculateEncumberment( self )
	
end

function meta:ClearInventory( )
	umsg.Start( "clearinventory", self )
	umsg.End( );
end

function meta:RefreshInventory( )
	self:ClearInventory( )
	
	for k, v in pairs( CAKE.GetCharField( self, "inventory" ) ) do
		umsg.Start( "addinventory", self );
			umsg.String( CAKE.ItemData[ v ].Name );
			umsg.String( CAKE.ItemData[ v ].Class );
			umsg.String( CAKE.ItemData[ v ].Description );
			umsg.String( CAKE.ItemData[ v ].Model );
			umsg.Short( CAKE.GetWeight( v ) )
		umsg.End( );
	end
end

function meta:ClearBusiness( )
	umsg.Start( "clearbusiness", self )
	umsg.End( );
end

function meta:RefreshBusiness( )
	self:ClearBusiness( )
		
	if !self:IsCharLoaded() then return; end -- Team not assigned
	local group = CAKE.GetCharField( self, "group" )
	local rank = CAKE.GetCharField( self, "grouprank" )

	if CAKE.GroupExists( group ) and CAKE.GetRankField( group, rank, "canbuy" ) and CAKE.GetRankField( group, rank, "buygroups" ) then
		local buygroups = CAKE.GetRankField( group, rank, "buygroups" ) or {}
		for k, v in pairs( CAKE.ItemData ) do
			if v.Purchaseable then
				if table.HasValue( buygroups, v.ItemGroup ) then
					umsg.Start( "addbusiness", self );
					umsg.String( v.Name );
					umsg.String( v.Class );
					umsg.String( v.Description );
					umsg.String( v.Model );
					umsg.Long( v.Price );
					umsg.End( )		
				end
			end
		end
	end
end

function meta:ItemHasFlag( item, flag )
	
	if !CAKE.ItemData[ item ] then
		return false
	end

	if !CAKE.ItemData[ item ].Flags then
		CAKE.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( CAKE.ItemData[ item ].Flags ) do
		if type( v ) == "table" then
			for k2, v2 in pairs( v ) do
				if string.match( v2, flag ) then
					return true
				end
			end
		end
		if string.match( v, flag ) then
			return true
		end
	end
	
	return false

end

function meta:GetFlagValue( item, flag )

	if !CAKE.ItemData[ item ].Flags then
		CAKE.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( CAKE.ItemData[ item ].Flags ) do
		if type( v ) == "table" then
			for k2, v2 in pairs( v ) do
				if string.match( v2, flag ) then
					local exp = string.Explode( ";", v2 )
					return exp[2] or true
				end
			end
		end
		if string.match( v, flag ) then
			local exp = string.Explode( ";", v )
			return exp[2] or true
		end
	end
	
	return false

end

function meta:IsCharLoaded()
	
	return self:GetNWBool( "charloaded", false )

end

function meta:HasItem( class )
	local inv = CAKE.GetCharField(self, "inventory" );
	for k, v in pairs( inv ) do
		if( v == class ) then
			return true
		end
	end
	return false
end

function CAKE.ChangeMoney( ply, amount ) -- Modify someone's money amount.

	-- Come on, Nori, how didn't you see the error in this?
	--if( ( CAKE.GetCharField( ply, "money" ) - amount ) < 0 ) then return; end 
	
	CAKE.DayLog( "economy.txt", "Changing " .. ply:SteamID( ) .. "-" .. ply:GetNWString( "uid" ) .. " money by " .. tostring( amount ) );
	
	CAKE.SetCharField( ply, "money", CAKE.GetCharField( ply, "money" ) + amount );
	if CAKE.GetCharField( ply, "money" ) < 0 then -- An actual negative number block
		CAKE.SetCharField( ply, "money", 0 );
		ply:SetNWInt("money", 0 )
	else
		ply:SetNWInt("money", tonumber( CAKE.GetCharField( ply, "money" ) ));
	end

end

function CAKE.DrugPlayer( pl, mul ) -- DRUG DAT BITCH

	mul = mul / 10 * 2;

	pl:ConCommand("pp_motionblur 1")
	pl:ConCommand("pp_motionblur_addalpha " .. 0.05 * mul)
	pl:ConCommand("pp_motionblur_delay " .. 0.035 * mul)
	pl:ConCommand("pp_motionblur_drawalpha 1.00")
	pl:ConCommand("pp_dof 1")
	pl:ConCommand("pp_dof_initlength 9")
	pl:ConCommand("pp_dof_spacing 8")

	local IDSteam = string.gsub(pl:SteamID(), ":", "")

	timer.Create(IDSteam, 40 * mul, 1, CAKE.UnDrugPlayer, pl)
end

function CAKE.UnDrugPlayer(pl)
	pl:ConCommand("pp_motionblur 0")
	pl:ConCommand("pp_dof 0")
end