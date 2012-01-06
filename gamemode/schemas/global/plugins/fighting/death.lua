--He who is not busy being born is busy dying. -Bob Dylan
concommand.Add( "rp_acceptdeath", function(ply, cmd, args)
	if ply:GetNWInt( "deathmode", 0 ) != 0 and ply:GetNWInt("deathmoderemaining", 0) == 0 then
		ply:SetNWInt( "deathmode", 0 )
		ply:SetViewEntity( ply )
	end
end)

function GM:PlayerDeath(ply)
	
	CAKE.StandUp( ply )
	CAKE.DeathMode(ply)

end

function GM:PlayerDeathThink(ply)

	ply.nextsecond = CAKE.NilFix(ply.nextsecond, CurTime())
	ply.deathtime = CAKE.NilFix(ply.deathtime, CAKE.ConVars[ "Respawn_Timer" ])
	
	if(CurTime() > ply.nextsecond) then
	
		if(ply.deathtime < CAKE.ConVars[ "Respawn_Timer" ]) then
		
			ply.deathtime = ply.deathtime + 1
			ply.nextsecond = CurTime() + 1
			ply:SetNWInt("deathmoderemaining", CAKE.ConVars[ "Respawn_Timer" ] - ply.deathtime)
			
		else
			if ply:GetNWInt( "deathmode", 0 ) == 0 then
				CAKE.StandUp( ply )
				ply:Spawn()
				ply.deathtime = nil
				ply.nextsecond = nil
				ply:SetNWInt("deathmoderemaining", 0)
				if !CAKE.ConVars[ "ReturnToSpawnOnDeath" ] then
					if ValidEntity( ply.deathrag ) then
						ply:SetPos(ply.deathrag:GetPos() + Vector( 0, 0, 30 ))
					end
					ply.deathrag:Remove()
					ply.deathrag = nil
				else
					if CAKE.ConVars[ "DeathRagdoll_Linger" ] > 0 then
						timer.Simple( CAKE.ConVars[ "DeathRagdoll_Linger" ], function()
							local rag = ply.deathrag
							timer.Create("deadragdollremove".. ply:SteamID(), 0.1, 0, function()
								if ValidEntity(rag) then
									local r, g, b, alpha = rag:GetColor()
									if alpha != 0 then
										rag:SetColor( 255, 255, 255, math.Clamp( alpha - 25, 0, 255 ))
									else
										rag:Remove()
										rag = nil
										timer.Destroy("deadragdollremove".. ply:SteamID())
									end
								end
							end)
						end)
					end
				end
			end
		end
		
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	-- We don't want kills, deaths, nor ragdolls being made. Kthx.
	
end

-- Disallows suicide
function GM:CanPlayerSuicide( ply )

	if( !CAKE.ConVars[ "SuicideEnabled" ] ) then
	
		ply:ChatPrint( "Suicide is disabled!" )
		return false
		
	end
	
	return true
	
end

--Handles death ragdoll creation.
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
	
	CAKE.DayLog( "script.txt", "Starting death mode for " .. ply:SteamID( ) )
	local mdl = ply:GetModel( )
	
	local rag = ents.Create( "prop_ragdoll" )
	rag:SetModel( mdl )
	rag:SetPos( ply:GetPos( ) )
	rag:SetAngles( ply:GetAngles( ) )
	rag.isdeathdoll = true
	rag.ply = ply
	rag:Spawn( )
	
	if( ply.Clothing ) then
		for k, v in pairs( ply.Clothing ) do
			if( ValidEntity( v ) ) then
				v:SetParent( rag )
				v:Initialize()
			end
		end
	end
	
	rag.BonemergeGearEntity = ents.Create( "player_gearhandler" )
	rag.BonemergeGearEntity:SetPos( rag:GetPos() + Vector( 0, 0, 80 ) )
	rag.BonemergeGearEntity:SetAngles( rag:GetAngles() )
	rag.BonemergeGearEntity:SetModel("models/tiramisu/gearhandler.mdl")
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
	
	--ply:SetViewEntity( rag )

	rag:GetPhysicsObject():ApplyForceCenter( ply:GetVelocity() )
	rag:GetPhysicsObject():SetVelocity( ply:GetVelocity() )

	ply.deathrag = rag
	
	ply:SetNWInt( "deathmode", 1 )
	ply:SetNWInt("deathmoderemaining", CAKE.ConVars[ "Respawn_Timer" ] )

	timer.Simple( 1, function()
		umsg.Start( "Tiramisu.ReceiveRagdoll", ply )
			umsg.Short( rag:EntIndex() )
		umsg.End()
	end)
	
	ply.deathtime = 0
	ply.nextsecond = CurTime( ) + 1
	
	timer.Simple( CAKE.ConVars[ "Respawn_Timer" ], function()
		if CAKE.ConVars[ "Instant_Respawn" ] then
			ply:SetNWInt( "deathmode", 0 )
			ply:SetViewEntity( ply )
		else
			umsg.Start( "Tiramisu.DisplayRespawnButton", ply )
			umsg.End()
		end
	end)
	
end