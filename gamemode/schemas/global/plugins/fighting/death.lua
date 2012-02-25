--He who is not busy being born is busy dying. -Bob Dylan
concommand.Add( "rp_acceptdeath", function(ply, cmd, args)
	if ply:GetNWInt( "deathmode", 0 ) != 0 and ply:GetNWInt("deathmoderemaining", 0) == 0 then
		ply:SetNWInt( "deathmode", 0 )
		ply:SetViewEntity( ply )
		umsg.Start( "Tiramisu.DisplayRespawnButton", ply )
			umsg.Bool( false )
		umsg.End()
	end
end)

function GM:PlayerDeath(ply)
	
	if !ply.DeadWhileUnconcious then
		CAKE.WakeUp( ply )
	end
	CAKE.StandUp( ply )
	CAKE.DeathMode( ply, ply.DeadWhileUnconcious )

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
					if ValidEntity( ply.rag ) then
						ply:SetPos(ply.rag:GetPos() + Vector( 0, 0, 30 ))
					end
					ply.rag:Remove()
					ply.rag = nil
				else
					if CAKE.ConVars[ "DeathRagdoll_Linger" ] > 0 then
						timer.Simple( CAKE.ConVars[ "DeathRagdoll_Linger" ], function()
							local rag = ply.rag
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
function CAKE.DeathMode( ply, noragdoll )
	
	local speed = ply:GetVelocity()

	timer.Destroy("deadragdollremove".. ply:SteamID())

	if CAKE.ConVars[ "LoseWeaponsOnDeath" ] then
		local container = ply:GetInventory()
		for i, tbl in pairs( ply:GetInventory().Items ) do
			for j, v in pairs(tbl) do
				if CAKE.GetUData( v.itemid, "weaponclass" ) or string.match( v.class, "weapon_" ) then
					container:ClearSlot(j,i)
				end
			end
		end
		if CAKE.ConVars[ "LoseItemsOnDeath" ] then
			container:Clear()
		end
		ply:RemoveAllAmmo()
	end
	
	CAKE.DayLog( "script.txt", "Starting death mode for " .. ply:SteamID( ) )

	local rag
	if !noragdoll then
		if ValidEntity( ply.rag ) then
			ply.rag:Remove()
			ply.rag = nil
		end
		rag = CAKE.CreatePlayerRagdoll( ply )
		ply.rag = rag
		ply:SetNWInt( "deathmode", 1 )
		timer.Simple( 1, function()
			umsg.Start( "Tiramisu.ReceiveRagdoll", ply )
				umsg.Short( rag:EntIndex() )
			umsg.End()
		end)
	else
		ply:SetNWInt( "deathmode", 2 )
		ply.DeadWhileUnconcious = false
	end
	
	ply:SetNWInt("deathmoderemaining", CAKE.ConVars[ "Respawn_Timer" ] )

	ply.deathtime = 0
	ply.nextsecond = CurTime( ) + 1
	
	timer.Simple( CAKE.ConVars[ "Respawn_Timer" ], function()
		if ValidEntity( ply ) then
			if CAKE.ConVars[ "Instant_Respawn" ] then
				ply:SetNWInt( "deathmode", 0 )
				ply:SetViewEntity( ply )
			else
				umsg.Start( "Tiramisu.DisplayRespawnButton", ply )
					umsg.Bool( true )
				umsg.End()
			end
		end
	end)
	
end