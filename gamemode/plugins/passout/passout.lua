--Makes you fall unconcious.
concommand.Add( "rp_passout", function( ply, cmd, args )
	CAKE.UnconciousMode( ply )
	if ply:GetNWBool( "unconciousmode", false ) and ply.CanWakeUp then
		CAKE.WakeUp(ply)
	end
end)

--Makes you wake up if unconcious.
concommand.Add( "rp_wakeup", function( ply, cmd, args )

	if ply:GetNWBool( "unconciousmode", false ) and ply.CanWakeUp then
		CAKE.WakeUp(ply)
	end

end)

--Toggles unconcious status.
function CAKE.UnconciousMode( ply, wait, delay )

	if ply:Alive() and !ply:GetNWBool( "unconciousmode", false ) then

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

		ply.LastUnconcious = CurTime() + (delay or 10)
		ply:GodEnable()
		ply:SetAiming( false )
		ply:DrawWorldModel(false)
		ply:DrawViewModel(false)
		ply:SetNoDraw( true )
		ply:SetNotSolid( true )
		
		if IsValid( ply.rag ) then
			ply.rag:Remove()
			ply.rag = nil
		end
		
		CAKE.DayLog( "script.txt", "Starting unconcious mode for " .. ply:SteamID( ) )
		
		local rag = CAKE.CreatePlayerRagdoll( ply )
		ply.rag = rag
		ply.unconcioustime = 0

		local bull = ents.Create("npc_bullseye")
		bull:SetPos( rag:LocalToWorld( rag:OBBCenter( )))
		bull:SetParent( rag )
		bull:SetKeyValue("health","9999")
		bull:SetKeyValue("minangle","360")
		bull:SetKeyValue("spawnflags","516")
		bull:SetNotSolid( true )
		bull:Spawn()
		bull:Activate()

		for _, npc in pairs( ents.GetAll() ) do
			if IsValid( npc ) and npc:IsNPC( ) and npc:Disposition(ply) == D_HT then
				npc:AddEntityRelationship( rag, D_HT, 999 )
				npc:AddRelationship("npc_bullseye D_HT 1")
				npc:AddEntityRelationship( ply, D_NU, 1 )
			end
		end

		ply:SetNWBool( "unconciousmode", true ) 
		
		timer.Simple( 1, function()
			umsg.Start( "Tiramisu.ReceiveRagdoll", ply )
				umsg.Short( rag:EntIndex() )
			umsg.End()
			umsg.Start( "Tiramisu.Freescroll", ply )
				umsg.Bool( true )
			umsg.End()
		end)		
		 
		timer.Create(ply:SteamID() .. "unconcioustimer", wait or CAKE.ConVars[ "UnconciousTimer" ], 1, function()
			ply.CanWakeUp = true
			umsg.Start( "Tiramisu.DisplayWakeUpButton", ply )
				umsg.Bool( true )
			umsg.End()
		end)
		ply:Freeze(true)
			
	end
end

function CAKE.WakeUp(ply, dontdestroyragdoll)
	if !(ply:GetNWBool( "unconciousmode", false )) then return end
	ply:SetNWBool( "unconciousmode", false )
	ply:SetPos( ply.rag:GetPos() + Vector( 0, 0, 10 ))
	ply:Freeze(false)
	ply:GodDisable()
	ply:SetNoDraw( false )
	ply:SetNotSolid( false )
	ply:DrawWorldModel(true)
	ply:DrawViewModel(true)
	if !dontdestroyragdoll then
		for _, npc in pairs( ents.GetAll( ) ) do
			if IsValid( npc ) and npc:IsNPC( ) and npc:Disposition(ply.rag) == D_HT then
				npc:AddEntityRelationship( ply, D_HT, 99 )
			end
		end
		CAKE.RestoreClothing( ply )
		CAKE.RestoreGear( ply )
		ply:SetViewEntity( ply )
		if ply.rag then
			ply.rag:Remove()
		end
		umsg.Start( "Tiramisu.ReceiveRagdoll", ply )
			umsg.Short( nil )
		umsg.End()
		umsg.Start( "Tiramisu.Freescroll", ply )
			umsg.Bool( false )
		umsg.End()
	end
	if timer.Exists( ply:SteamID() .. "unconcioustimer" ) then
		timer.Destroy( ply:SteamID() .. "unconcioustimer"  )
	end
	ply.CanWakeUp = false
	umsg.Start( "Tiramisu.DisplayWakeUpButton", ply )
		umsg.Bool( false )
	umsg.End()
	ply:SetVelocity( Vector(0,0,0))
end

function CAKE.RagDamage( ent, dmginfo )
 	
 	local inflictor = dmginfo:GetInflictor()
 	local attacker = dmginfo:GetAttacker()
 	local amount = dmginfo:GetDamage()

	if IsValid(ent.ply) and ent.ply:Alive() and IsValid(inflictor) and (inflictor:IsPlayer() or inflictor:IsNPC()) then
		if CAKE.ConVars[ "DamageWhileUnconcious" ] then
			ent.ply:SetHealth(ent.ply:Health()-amount)
			if ent.ply:Health() <= 0 then
				CAKE.WakeUp(ent.ply, true)
				ent.ply.DeadWhileUnconcious = true
				ent.ply:Kill()
				ent.ply = nil
			end
		end
	end
 
end
hook.Add( "EntityTakeDamage", "Tiramisu.RagdollDamage", CAKE.RagDamage )