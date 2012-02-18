--Makes you fall unconcious.
concommand.Add( "rp_passout", function( ply, cmd, args )
	CAKE.UnconciousMode( ply )
end)

--Makes you wake up if unconcious.
concommand.Add( "rp_wakeup", function( ply, cmd, args )

	if ply:GetNWBool( "unconciousmode", false ) then
		CAKE.UnconciousMode( ply )
	end

end)

--Toggles unconcious status.
function CAKE.UnconciousMode( ply, wait, delay )

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

			ply.LastUnconcious = CurTime() + (delay or 10)
			ply:GodEnable()
			ply:SetAiming( false )
			ply:DrawWorldModel(false)
			ply:DrawViewModel(false)
			ply:SetNoDraw( true )
			ply:SetNotSolid( true )
			
			if ValidEntity( ply.unconciousrag ) then
				ply.unconciousrag:Remove()
				ply.unconciousrag = nil
			end
			
			CAKE.DayLog( "script.txt", "Starting unconcious mode for " .. ply:SteamID( ) )
			
			local rag = CAKE.CreatePlayerRagdoll( ply )
			ply.unconciousrag = rag
			ply.unconcioustime = 0

			ply:SetNWBool( "unconciousmode", true ) 
			
			timer.Simple( 1, function()
				umsg.Start( "Tiramisu.ReceiveRagdoll", ply )
					umsg.Short( rag:EntIndex() )
				umsg.End()
				umsg.Start( "ToggleFreescroll", ply )
					umsg.Bool( true )
				umsg.End()
			end)
			
			timer.Simple( wait or CAKE.ConVars[ "UnconciousTimer" ], function()
				ply.CanWakeUp = true
				umsg.Start( "Tiramisu.DisplayWakeUpButton", ply )
					umsg.Bool( true )
				umsg.End()
			end)
			ply:Lock()
			
		elseif ply:GetNWBool( "unconciousmode", false ) and ply.CanWakeUp then
			ply:SetNWBool( "unconciousmode", false )
			ply:SetViewEntity( ply )
			CAKE.RestoreGear( ply )
			ply:SetPos( ply.unconciousrag:GetPos() + Vector( 0, 0, 10 ))
			ply:UnLock()
			CAKE.RestoreClothing( ply )
			ply:GodDisable()
			ply:SetNoDraw( false )
			ply:SetNotSolid( false )
			ply:DrawWorldModel(true)
			ply:DrawViewModel(true)
			umsg.Start( "Tiramisu.ReceiveRagdoll", ply )
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
			ply.CanWakeUp = false
			umsg.Start( "Tiramisu.DisplayWakeUpButton", ply )
				umsg.Bool( false )
			umsg.End()
			ply:SetVelocity( Vector(0,0,0))
		end

	elseif !ply:Alive() and ply:GetNWBool( "unconciousmode", false ) then 
		ply:SetNWBool( "unconciousmode", false )
		ply:GodDisable()
		ply:UnLock()
		ply:SetNoDraw( false )
		ply:SetNotSolid( false )
		ply:DrawWorldModel(true)
		ply:DrawViewModel(true)
		umsg.Start( "Tiramisu.ReceiveRagdoll", ply )
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
		ply.CanWakeUp = false
		ply:SetVelocity( Vector(0,0,0))
	end
end

function CAKE.WakeUp(ply)
	if !(ply:GetNWBool( "unconciousmode", false )) then return end
	ply:SetNWBool( "unconciousmode", false )
	ply:SetViewEntity( ply )
	CAKE.RestoreGear( ply )
	ply:SetPos( ply.unconciousrag:GetPos() + Vector( 0, 0, 10 ))
	ply:UnLock()
	CAKE.RestoreClothing( ply )
	ply:GodDisable()
	ply:SetNoDraw( false )
	ply:SetNotSolid( false )
	ply:DrawWorldModel(true)
	ply:DrawViewModel(true)
	umsg.Start( "Tiramisu.ReceiveRagdoll", ply )
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
	ply.CanWakeUp = false
	umsg.Start( "Tiramisu.DisplayWakeUpButton", ply )
		umsg.Bool( false )
	umsg.End()
	ply:SetVelocity( Vector(0,0,0))
end

function CAKE.RagDamage( ent, inflictor, attacker, amount )
 
	if ent.ply then
		ent.ply:SetHealth(ent.ply:Health()-amount)
		if ent.ply:Health() < 0 then
			ent.ply:Kill()
		end
	end
 
end
hook.Add( "EntityTakeDamage", "Tiramisu.RagdollDamage", CAKE.RagDamage )