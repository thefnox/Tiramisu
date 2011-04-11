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

	if CAKE.ConVars[ "LoseWeaponsOnDeath" ] then
		if CAKE.ConVars[ "LoseItemsOnDeath" ] then
			for k, v in pairs( CAKE.GetCharField( ply, "inventory" ) ) do
				ply:TakeItem( v )
			end
		end
		for k, v in pairs( CAKE.GetCharField( ply, "weapons" ) ) do
			ply:TakeItem( v )
		end
		ply:RemoveAllAmmo( )
		CAKE.SetCharField( ply, "weapons", {} )
		CAKE.SetCharField( ply, "ammo", {} )
	end
	
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
	
	rag.BonemergeGearEntity = ents.Create( "prop_physics" )
	rag.BonemergeGearEntity:SetPos( rag:GetPos() + Vector( 0, 0, 80 ) )
	rag.BonemergeGearEntity:SetAngles( rag:GetAngles() )
	rag.BonemergeGearEntity:SetModel("models/Tiramisu/gearhandler.mdl")
	rag.BonemergeGearEntity:SetParent( rag )
	rag.BonemergeGearEntity:SetNoDraw( true )
	rag.BonemergeGearEntity:SetSolid( SOLID_NONE )
	rag.BonemergeGearEntity:Spawn()
			
	if( ply.Gear ) then
		for k, v in pairs( ply.Gear ) do
			if( ValidEntity( v ) ) then
				v:SetParent( rag.BonemergeGearEntity )
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

			ply.LastUnconcious = ply.LastUnconcious or 0

			if ply:GetNWBool( "sittingchair", false ) or ply:GetNWBool( "sittingground", false ) and CAKE.PlayerRank(ply) < 1 then
				--ADMIN ONLY BUTT RACING FUCK YEAH
				CAKE.SendError( ply, "You must stand up to go unconcious!")
				return
			end

			if ply:GetNWBool( "observe" ) then
				CAKE.SendError( ply, "You can't go unconcious while on observe!")
				return
			end

			if ply.LastUnconcious > CurTime() then
				CAKE.SendError( ply, "You must wait " .. tostring( math.ceil( ply.LastUnconcious - CurTime() )) .. " seconds to go unconcious again!")
				return
			end

			ply.LastUnconcious = CurTime() + 10
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

			rag.BonemergeGearEntity = ents.Create( "prop_physics" )
			rag.BonemergeGearEntity:SetPos( rag:GetPos() + Vector( 0, 0, 80 ) )
			rag.BonemergeGearEntity:SetAngles( rag:GetAngles() )
			rag.BonemergeGearEntity:SetModel("models/Tiramisu/gearhandler.mdl")
			rag.BonemergeGearEntity:SetParent( rag )
			rag.BonemergeGearEntity:SetNoDraw( true )
			rag.BonemergeGearEntity:SetSolid( SOLID_NONE )
			rag.BonemergeGearEntity:Spawn()
			
			if( ply.Gear ) then
				for k, v in pairs( ply.Gear ) do
					if( ValidEntity( v ) ) then
						v:SetParent( rag.BonemergeGearEntity )
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

	elseif !ply:Alive() and ply:GetNWBool( "unconciousmode", false ) then 
		ply:SetNWBool( "unconciousmode", false )
		ply:GodDisable()
		ply:UnLock()
		ply:SetViewEntity( ply )
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


local meta = FindMetaTable( "Player" );

function meta:ConCommand( cmd ) --Rewriting this due to Garry fucking it up.
	umsg.Start( "runconcommand", self )
		umsg.String( cmd ) 
		--Yeah it just sends the command as a string which is then ran clientside. 2 usermessages sent, all because of
		--A REALLY REALLY not well thought fix.
	umsg.End()
end

function meta:IsCharLoaded()
	
	return self:GetNWBool( "charloaded", false )

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