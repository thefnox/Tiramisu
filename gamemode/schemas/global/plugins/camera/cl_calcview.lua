local targetent, lookattarget, ang, sa, ca, hitpos
local tracedata = {}
TIRA.CameraPos = Vector(0, 0, 0)
TIRA.CameraAngle = Angle(0, 0, 0)
TIRA.LastViewAng = Angle(0, 0, 0)
TIRA.DiffReal = Angle(0, 0, 0)
TIRA.OldAngles = Angle(0, 0, 0)
TIRA.LastAng = Angle(0, 0, 0)
TIRA.CurAng = Angle(0, 0, 0)
TIRA.FreeScrollAng = Angle( 0, 0, 0 )
TIRA.OTSAng = false
TIRA.UseHeadRotation = false
TIRA.SwitchFromFirstPerson = false
TIRA.FlipAround = false
TIRA.UseFlash = true

local NormalizeAngle, Clamp, rad, cos, sin, abs, AngleDifference = math.NormalizeAngle, math.Clamp, math.rad, math.cos, math.sin, math.abs, math.AngleDifference

local wep
local function IronsightsOn()
	if ValidEntity( LocalPlayer():GetActiveWeapon() ) then
		wep = LocalPlayer():GetActiveWeapon()
		if wep:GetNWBool( "Ironsights", false ) and not LocalPlayer():KeyDown(IN_SPEED) then
			return true
		end
	end
	return false
end

usermessage.Hook( "Tiramisu.ReceiveRagdoll", function( um )
	
	TIRA.ViewRagdoll = ents.GetByIndex( um:ReadShort() )
	if ValidEntity(TIRA.ViewRagdoll) and TIRA.ViewRagdoll != LocalPlayer() then
		TIRA.ForceFreeScroll = true
	else
		TIRA.ForceFreeScroll = false
		TIRA.FreeScroll = false
	end

end)

--Sends the current player look at position.
timer.Create( "TiramisuLookAtTimer", 0.2, 0, function()
	if TIRA.UseHeadRotation then
		local angle = TIRA.RealAng - TIRA.LastViewAng
		angle.p = math.NormalizeAngle( angle.p )
		RunConsoleCommand("t_sla", angle.p, NormalizeAngle( angle.y ))
	else
		RunConsoleCommand("t_sla", 0,0 )
		timer.Pause("TiramisuLookAtTimer")
	end
end)

hook.Add("ShouldDrawLocalPlayer","TiramisuDrawLocalPlayerCamera", function()
	if IronsightsOn() then
		return false
	end
	if TIRA.ForceDraw then
		return true
	end
	if (TIRA.Thirdperson:GetBool() and TIRA.ThirdpersonDistance:GetInt() != 0 ) or TIRA.FreeScroll then
		return true
	else
		if TIRA.FirstpersonBody:GetBool() and !LocalPlayer():GetNWBool("specialmodel") then
			return true
		end
	end

	return false
end)

local amount = 5
hook.Add( "PlayerBindPress", "TiramisuPlayerBindPressCamera", function( ply, bind, down )
	if ValidEntity(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() != "weapon_physgun" then
		if string.find(bind, "invprev") then
			RunConsoleCommand( "rp_thirdpersondistance",  tostring(Clamp( TIRA.ThirdpersonDistance:GetInt() - amount, 0, 150)))
		elseif string.find(bind, "invnext") then
			RunConsoleCommand( "rp_thirdpersondistance",  tostring(Clamp( TIRA.ThirdpersonDistance:GetInt() + amount, 0, 150)))
		end

		if string.find(bind, "invprev") or string.find(bind, "invnext") then
			if TIRA.ThirdpersonDistance:GetInt() <= 5 then
				RunConsoleCommand("rp_thirdperson","0")
			else
				RunConsoleCommand("rp_thirdperson","1")
			end
			return true
		end
	end
end)

local vecMove = Vector()
local mPitch = GetConVar( "m_pitch" )
local mYaw = GetConVar( "m_yaw" )
local middleDown = false

hook.Add( "CreateMove", "TiramisuCreateMoveCamera", function( cmd )

	if LocalPlayer():GetNWBool("specialmodel") then
		TIRA.UseHeadRotation = false
		if TIRA.Thirdperson:GetBool() then
			TIRA.WasOTS = false
			if TIRA.SwitchFromFirstPerson and TIRA.LastViewAng then
				TIRA.RealAng = TIRA.LastViewAng
				TIRA.CurAng = TIRA.RealAng
				TIRA.LastAng = TIRA.LastViewAng
				TIRA.OldAngles = TIRA.LastAng
				TIRA.CurAng = TIRA.LastAng
				--TIRA.RealAng = TIRA.CurAng
				TIRA.SwitchFromFirstPerson = false
				TIRA.UseHeadRotation = false
			elseif !TIRA.RealAng then
				TIRA.RealAng = cmd:GetViewAngles()
			end

			TIRA.LastAng = TIRA.RealAng
			TIRA.RealAng = TIRA.RealAng + Angle( cmd:GetMouseY() * (mPitch:GetFloat()), cmd:GetMouseX() * (-mYaw:GetFloat()), 0 )
			TIRA.RealAng.p = Clamp( NormalizeAngle( TIRA.RealAng.p ), -89, 89 )
			TIRA.RealAng.y = NormalizeAngle( TIRA.RealAng.y )
		else
			TIRA.WasOTS = false
			if TIRA.UseHeadRotation then
				cmd:SetViewAngles(TIRA.RealAng)
			end
			TIRA.OTSAng = false
			TIRA.UseHeadRotation = false
			TIRA.SwitchFromFirstPerson = true
			TIRA.DiffReal = Angle( 0, 0, 0 )
			TIRA.LastViewAng = cmd:GetViewAngles()
		end
		return
	end
	
	if !IronsightsOn() and !LocalPlayer():InVehicle() and bit.band(cmd:GetButtons(), IN_USE) == 0 then
		if input.IsMouseDown(MOUSE_MIDDLE) then
			TIRA.FreeScroll = true
		else
			TIRA.FreeScroll = false		
		end

		if TIRA.ForceFreeScroll then
			TIRA.FreeScroll = true
		end

		if TIRA.FreeScroll then
			TIRA.WasOTS = false
			cmd:SetViewAngles(TIRA.RealAng or cmd:GetViewAngles())
			TIRA.FreeScrollAng = TIRA.FreeScrollAng + Angle( cmd:GetMouseY() * (mPitch:GetFloat()), cmd:GetMouseX() * (-mYaw:GetFloat()), 0 )
			TIRA.FreeScrollAng.p = Clamp( NormalizeAngle( TIRA.FreeScrollAng.p ), -89, 89 )
		else
			TIRA.FreeScrollAng = Angle( 0, 0, 0 )
			TIRA.FreeScroll = false
			if TIRA.Thirdperson:GetBool() and !LocalPlayer():GetNWBool( "aiming", false ) then --NON AIMING THIRDPERSON
				TIRA.WasOTS = false
				if TIRA.SwitchFromFirstPerson and TIRA.LastViewAng then
					TIRA.RealAng = TIRA.LastViewAng
					TIRA.CurAng = TIRA.RealAng
					TIRA.LastAng = TIRA.LastViewAng
					TIRA.OldAngles = TIRA.LastAng
					TIRA.CurAng = TIRA.LastAng
					--TIRA.RealAng = TIRA.CurAng
					TIRA.SwitchFromFirstPerson = false
					TIRA.UseHeadRotation = false
				elseif !TIRA.RealAng then
					TIRA.RealAng = cmd:GetViewAngles()
				end
				TIRA.LastAng = TIRA.RealAng
				TIRA.RealAng = TIRA.RealAng + Angle( cmd:GetMouseY() * (mPitch:GetFloat()), cmd:GetMouseX() * (-mYaw:GetFloat()), 0 )
				TIRA.RealAng.p = Clamp( NormalizeAngle( TIRA.RealAng.p ), -89, 89 )
				TIRA.RealAng.y = NormalizeAngle( TIRA.RealAng.y )
				if bit.band(cmd:GetButtons(), IN_FORWARD) > 0 or bit.band(cmd:GetButtons(), IN_BACK) > 0 then
					if input.IsKeyDown(KEY_LALT) and TIRA.UseHeadRotation then
						if not TIRA.UseHeadRotation == 2 then
							ply.CurrentLookAt = Angle(0,0,0)
						end
						TIRA.UseHeadRotation = 2
						cmd:SetViewAngles(TIRA.WasWalkingAng)
					else
						if TIRA.UseHeadRotation == 2 then
							TIRA.RealAng = TIRA.WasWalkingAng
							TIRA.CurrentLookAt = Angle(0, 0, 0)
						end
						TIRA.WasWalkingAng = TIRA.RealAng
						cmd:SetViewAngles(TIRA.RealAng)
						TIRA.UseHeadRotation = 1
					end
				else
					timer.UnPause("TiramisuLookAtTimer")
					if TIRA.UseHeadRotation == 1 then
						TIRA.LastViewAng.y = TIRA.RealAng.y
					elseif TIRA.UseHeadRotation == 2 then
						ply.CurrentLookAt = Angle(0,0,0)
						TIRA.RealAng.p = TIRA.WasWalkingAng.p
					end
					TIRA.UseHeadRotation = true
					cmd:SetViewAngles(TIRA.LastViewAng)
				end
				if AngleDifference(TIRA.RealAng.y, TIRA.LastViewAng.y) > 170  and not TIRA.UseHeadRotation == 2 then
					cmd:SetViewAngles( TIRA.RealAng )
					TIRA.LastViewAng.y = TIRA.RealAng.y
					TIRA.LastAng = TIRA.RealAng
					LocalPlayer():AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GESTURE_TURN_RIGHT90 )
				elseif AngleDifference(TIRA.RealAng.y, TIRA.LastViewAng.y) < -170 and not TIRA.UseHeadRotation == 2 then
					cmd:SetViewAngles( TIRA.RealAng )
					TIRA.LastViewAng.y = TIRA.RealAng.y
					TIRA.LastAng = TIRA.RealAng
					LocalPlayer():AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GESTURE_TURN_LEFT90 )					
				end
			elseif TIRA.Thirdperson:GetBool() and LocalPlayer():GetNWBool( "aiming", false ) then --OVER THE SHOULDER
			
				if !TIRA.WasOTS then
					TIRA.OTSAng = cmd:GetViewAngles()
				end
				
				TIRA.WasOTS = true
				
				if TIRA.UseHeadRotation then
					cmd:SetViewAngles(TIRA.RealAng)
				end
				if !TIRA.OTSAng then
					TIRA.OTSAng = cmd:GetViewAngles()
				end
				TIRA.OTSAng = TIRA.OTSAng + Angle( cmd:GetMouseY() * (mPitch:GetFloat()), cmd:GetMouseX() * (-mYaw:GetFloat()), 0 )
				TIRA.OTSAng.p = Clamp( NormalizeAngle( TIRA.OTSAng.p ), -89, 89 )
			
				--[[trace = util.TraceHull( {
					start = TIRA.CameraPos,
					endpos = TIRA.CameraPos + ( TIRA.OldAngles * 3000 ),
					filter = LocalPlayer(),
					mask = MASK_SHOT,
					mins = Vector(-12,-12,-12),
					maxs = Vector( 12, 12, 12),
				} )]]--

				local tracedata = {}
				tracedata.start = TIRA.CameraPos
				tracedata.endpos = TIRA.CameraPos + (TIRA.OldAngles:Forward() * 3000)
				local trace = util.TraceLine(tracedata)

				--Hit Correction
				--if ValidEntity(trace.Entity) and !trace.HitWorld and !trace.HitSky then
					--local head = trace.Entity:LookupBone("ValveBiped.Bip01_Head1")
					--if head then
					--	hitpos = Lerp( 0.3, trace.HitPos, trace.Entity:GetBonePosition(head) )
					--else
					--	hitpos = Lerp( 0.3, trace.HitPos, trace.Entity:LocalToWorld(trace.Entity:OBBCenter()))
					--end
				--else
				--	hitpos = trace.HitPos
				--end

				--hitpos = hitpos - trace.HitNormal
				
				chitpos = trace.HitPos
								
				vecMove.x = cmd:GetForwardMove()
				vecMove.y = cmd:GetSideMove()
				vecMove.z = cmd:GetUpMove()
				
				ang = rad( cmd:GetViewAngles().y - TIRA.OTSAng.y )
				ca = cos( ang )
				sa = sin( ang )
				
				cmd:SetForwardMove( vecMove.x * ca - vecMove.y * sa )
				cmd:SetSideMove( vecMove.x * sa + vecMove.y * ca )
				cmd:SetUpMove( vecMove.z )
				
				LocalPlayer():LagCompensation( true )
				TIRA.DiffReal = (chitpos - LocalPlayer():EyePos()):Angle() + LocalPlayer():GetPunchAngle()
				TIRA.DiffReal.r = 0
				LocalPlayer():LagCompensation( false )

				TIRA.DiffReal.p = Clamp( NormalizeAngle( TIRA.DiffReal.p ), -89, 89 )
				
				TIRA.LastViewAng = cmd:GetViewAngles()
				cmd:SetViewAngles( TIRA.DiffReal )
				TIRA.UseHeadRotation = false
				TIRA.SwitchFromFirstPerson = true
			else
				TIRA.WasOTS = false
				if TIRA.UseHeadRotation then
					cmd:SetViewAngles(TIRA.RealAng)
				end
				TIRA.OTSAng = false
				TIRA.UseHeadRotation = false
				TIRA.SwitchFromFirstPerson = true
				TIRA.DiffReal = Angle( 0, 0, 0 )
				TIRA.LastViewAng = cmd:GetViewAngles()
			end
		end
	else
		TIRA.SwitchFromFirstPerson = false
		TIRA.UseHeadRotation = false
	end
end )

local head, headang
hook.Add("CalcView", "TiramisuThirdperson", function(ply, pos , angles ,fov)

	if IronsightsOn() or ply:InVehicle() then
		TIRA.CameraPos = pos
		return GAMEMODE:CalcView(ply, pos , angles ,fov)
	end

	if TIRA.FreeScroll then --Rotate around the player/objective

		if ValidEntity( TIRA.ViewRagdoll ) then
			targetent = TIRA.ViewRagdoll
		else
			targetent = ply
		end

		tracedata.start = targetent:LocalToWorld(targetent:OBBCenter())
		tracedata.endpos = targetent:LocalToWorld(targetent:OBBCenter()) + TIRA.FreeScrollAng:Forward()*targetent:BoundingRadius()*3
		tracedata.filter = targetent
		trace = util.TraceLine(tracedata)

		pos = LerpVector( RealFrameTime() * TIRA.CameraSmoothFactor:GetFloat(), (TIRA.CameraPos or pos), trace.HitPos + trace.HitNormal * 4 )

		TIRA.CameraPos = pos
		TIRA.CameraAngle = angles
		return GAMEMODE:CalcView(ply, pos, (targetent:LocalToWorld(targetent:OBBCenter())-pos):Angle(), fov)
	end

	if LocalPlayer():GetNWBool("specialmodel") then
		if TIRA.Thirdperson:GetBool() then 
			
		else

		end
	end

	if TIRA.Thirdperson:GetBool() then --All thirdperson code goes here.

		if !TIRA.OldAngles then
			TIRA.OldAngles = Angle( angles.p, angles.y, 0 )
		end

		if( ply:GetNWBool( "aiming", false ) and TIRA.OTSAng ) then--Over the shoulder view.

			trace = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() - TIRA.OTSAng:Forward() * TIRA.ThirdpersonDistance:GetInt() + TIRA.OTSAng:Right() * 15 + TIRA.OTSAng:Up() * 7.5,
				filter = ply,
				mask = MASK_SOLID_BRUSHONLY,
			} )
			
			if !TIRA.CameraPos then
				TIRA.CameraPos = trace.HitPos + trace.HitNormal*2
			else
				TIRA.CameraPos = LerpVector( RealFrameTime() * TIRA.CameraSmoothFactor:GetFloat(), TIRA.CameraPos, trace.HitPos + trace.HitNormal*2 )
			end
			
			if !TIRA.OldAngles then
				TIRA.OldAngles = TIRA.OTSAng
			else
				TIRA.OldAngles = LerpAngle( RealFrameTime() * TIRA.CameraSmoothFactor:GetFloat(), TIRA.OldAngles, TIRA.OTSAng )  
			end
			
			TIRA.OldAngles.r = 0
			
			return GAMEMODE:CalcView( ply, TIRA.CameraPos, TIRA.OldAngles, fov )
	
		else -- Regular view.

			TIRA.DiffAng = TIRA.RealAng - TIRA.LastAng
			TIRA.DiffAng = Angle( Clamp(TIRA.DiffAng.p, -89, 89), NormalizeAngle(TIRA.DiffAng.y),0 )
			TIRA.CurAng = TIRA.LastAng + TIRA.DiffAng
			--angles = TIRA.CurAng
			TIRA.LastAng = TIRA.CurAng 
			TIRA.LastAng.y = NormalizeAngle( TIRA.LastAng.y )

			if !ply:InVehicle() then
				tracedata.start = pos
				tracedata.endpos = pos - ( TIRA.CurAng:Forward() * TIRA.ThirdpersonDistance:GetInt() * 2 ) + ( angles:Up()* 10 )
				tracedata.filter = ply
				trace = util.TraceLine(tracedata)
				pos = LerpVector( RealFrameTime() * TIRA.CameraSmoothFactor:GetFloat(), (TIRA.CameraPos or pos), trace.HitPos + trace.HitNormal*2 )
			else
				pos = ply:EyePos()
			end
			TIRA.CurAng = LerpAngle( RealFrameTime() * TIRA.CameraSmoothFactor:GetFloat(), TIRA.OldAngles, Angle( TIRA.CurAng.p, TIRA.CurAng.y, 0 ) )
			TIRA.OldAngles = TIRA.CurAng
			TIRA.CameraPos = pos
			return GAMEMODE:CalcView(ply, pos , Angle( TIRA.CurAng.p, TIRA.CurAng.y, 0) ,fov)
	
		end

	end

	TIRA.CameraPos = pos
	if TIRA.FirstpersonBody:GetBool() then
		head = ply:LookupBone( "ValveBiped.Bip01_Head1" )
		headang = Angle(0, angles.y, 0)
		if head and !ply:GetNWBool( "observe" ) then
			pos = ply:GetBonePosition( head )
			if pos == Vector( 0, 0, 0 ) then
				pos = ply:EyePos() + TIRA.FirstpersonForward:GetFloat() * headang:Forward() + TIRA.FirstpersonUp:GetFloat() * headang:Up()
			else
				pos = ply:GetBonePosition( head ) + TIRA.FirstpersonForward:GetFloat() * headang:Forward() + TIRA.FirstpersonUp:GetFloat() * headang:Up()
			end
		else
			pos = ply:EyePos() + TIRA.FirstpersonForward:GetFloat() * headang:Forward() + TIRA.FirstpersonUp:GetFloat() * headang:Up()
		end
	elseif TIRA.Headbob:GetBool() then
		--Todo
	end
	return GAMEMODE:CalcView(ply, pos , angles ,fov)
end)

hook.Add( "UpdateAnimation", "TiramisuAnimateRotate", function( ply, velocity, maxseqgroundspeed )
	if not ply.CurrentLookAt then ply.CurrentLookAt = Angle( 0, 0, 0 ) end
	if !ply:GetNWBool("specialmodel") then
		if ply == LocalPlayer() and !TIRA.ForceDraw then
			if TIRA.UseHeadRotation == 2 then
				TIRA.wasMoveLook = true
			elseif TIRA.UseHeadRotation != 2 and TIRA.wasMoveLook then
				TIRA.RealAng = TIRA.WasWalkingAng
				TIRA.CurrentLookAt = Angle(0, 0, 0)
				TIRA.wasMoveLook = false
			end
			--pl:SetPoseParameter("aim_yaw", 0 )
			ply:SetPoseParameter("head_yaw", 0 )
			ply:SetPoseParameter("body_yaw", 0 )
			ply:SetPoseParameter("spine_yaw", 0 )
			if TIRA.UseHeadRotation then
				if not (TIRA.UseHeadRotation == 2) then
					lookattarget = TIRA.RealAng - TIRA.LastViewAng
					lookattarget = Angle( lookattarget.p, NormalizeAngle( lookattarget.y ), 0 )
				elseif TIRA.UseHeadRotation == 2 then
					lookattarget = TIRA.RealAng - TIRA.WasWalkingAng
					lookattarget = Angle( lookattarget.p, NormalizeAngle( lookattarget.y ), 0 )
				end
				ang = LerpAngle( 0.1, ply.CurrentLookAt, lookattarget)
				if TIRA.UseHeadRotation == 1 then
					ang.y = 0
				end
				ply.CurrentLookAt = ang
				ply:SetPoseParameter("head_pitch", ang.p + 10)
				ply:SetPoseParameter("aim_pitch", ang.p)
				ply:SetPoseParameter("aim_yaw", ang.y)
				ply:SetPoseParameter("spine_roll", 90)
				if ang.y > 0 then
					if ang.y < 60 then
						ply:SetPoseParameter("head_yaw", ang.y)
						ply:SetPoseParameter("body_yaw", 0)
						ply:SetPoseParameter("spine_yaw", 0)
					elseif ang.y >= 60 and ang.y <= 90 then
						ply:SetPoseParameter("head_yaw", ang.y)
						ply:SetPoseParameter("body_yaw", (ang.y - 60))
						ply:SetPoseParameter("spine_yaw", 0)
					elseif ang.y > 90 then
						ply:SetPoseParameter("head_yaw", ang.y)
						ply:SetPoseParameter("body_yaw", (ang.y - 60))
						ply:SetPoseParameter("spine_yaw", (ang.y - 90))
					end
				else
					if ang.y > -60 then
						ply:SetPoseParameter("head_yaw", ang.y)
						ply:SetPoseParameter("body_yaw", 0)
						ply:SetPoseParameter("spine_yaw", 0)
					elseif ang.y <= -60 and ang.y >= -90 then
						ply:SetPoseParameter("head_yaw", ang.y)
						ply:SetPoseParameter("body_yaw", (ang.y + 60))
						ply:SetPoseParameter("spine_yaw", 0)
					elseif ang.y < -90 then
						ply:SetPoseParameter("head_yaw", ang.y)
						ply:SetPoseParameter("body_yaw", (ang.y + 60))
						ply:SetPoseParameter("spine_yaw", (ang.y + 90))
					end
				end
			end
		end
	end
end)