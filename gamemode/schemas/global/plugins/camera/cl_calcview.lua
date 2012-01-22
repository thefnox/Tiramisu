local targetent, lookattarget, ang, sa, ca, hitpos
local tracedata = {}
CAKE.CameraPos = Vector(0, 0, 0)
CAKE.CameraAngle = Angle(0, 0, 0)
CAKE.LastViewAng = Angle(0, 0, 0)
CAKE.DiffReal = Angle(0, 0, 0)
CAKE.OldAngles = Angle(0, 0, 0)
CAKE.LastAng = Angle(0, 0, 0)
CAKE.CurAng = Angle(0, 0, 0)
CAKE.FreeScrollAng = Angle( 0, 0, 0 )
CAKE.OTSAng = false
CAKE.UseHeadRotation = false
CAKE.SwitchFromFirstPerson = false
CAKE.FlipAround = false

local NormalizeAngle, Clamp, rad, cos, sin, abs, AngleDifference = math.NormalizeAngle, math.Clamp, math.rad, math.cos, math.sin, math.abs, math.AngleDifference

local wep
local function IronsightsOn()
	if ValidEntity( LocalPlayer():GetActiveWeapon() ) then
		wep = LocalPlayer():GetActiveWeapon()
		if wep:GetNWBool( "Ironsights", false ) then
			return true
		end
	end
	return false
end

usermessage.Hook( "Tiramisu.ReceiveRagdoll", function( um )
	
	CAKE.ViewRagdoll = ents.GetByIndex( um:ReadShort() )
	if ValidEntity(CAKE.ViewRagdoll) and CAKE.ViewRagdoll != LocalPlayer() then
		CAKE.ForceFreeScroll = true
	else
		CAKE.ForceFreeScroll = false
		CAKE.FreeScroll = false
	end

end)

--Sends the current player look at position.
timer.Create( "TiramisuLookAtTimer", 0.2, 0, function()
	if CAKE.UseHeadRotation then
		local angle = CAKE.RealAng - CAKE.LastViewAng
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
	if CAKE.ForceDraw then
		return true
	end
	if (CAKE.Thirdperson:GetBool() and CAKE.ThirdpersonDistance:GetInt() != 0 ) or CAKE.FreeScroll then
		return true
	else
		if CAKE.FirstpersonBody:GetBool() then
			return true
		end
	end

	return false
end)

local amount = 5
hook.Add( "PlayerBindPress", "TiramisuPlayerBindPressCamera", function( ply, bind, down )
	if string.find(bind, "invprev") then
		RunConsoleCommand( "rp_thirdpersondistance",  tostring(Clamp( CAKE.ThirdpersonDistance:GetInt() - amount, 0, 150)))
	elseif string.find(bind, "invnext") then
		RunConsoleCommand( "rp_thirdpersondistance",  tostring(Clamp( CAKE.ThirdpersonDistance:GetInt() + amount, 0, 150)))
	end

	if string.find(bind, "invprev") or string.find(bind, "invnext") then
		if CAKE.ThirdpersonDistance:GetInt() == 0 then
			RunConsoleCommand("rp_thirdperson","0")
		else
			RunConsoleCommand("rp_thirdperson","1")
		end
		return true
	end

end)

local vecMove = Vector()
local mPitch = GetConVar( "m_pitch" )
local mYaw = GetConVar( "m_yaw" )
local middleDown = false

hook.Add( "CreateMove", "TiramisuCreateMoveCamera", function( cmd )
	
	if !IronsightsOn() and !LocalPlayer():InVehicle() then
		if input.IsMouseDown(MOUSE_MIDDLE) then
			CAKE.FreeScroll = true
		else
			CAKE.FreeScroll = false		
		end

		if CAKE.ForceFreeScroll then
			CAKE.FreeScroll = true
		end

		if CAKE.FreeScroll then
			cmd:SetViewAngles(CAKE.RealAng or cmd:GetViewAngles())
			CAKE.FreeScrollAng = CAKE.FreeScrollAng + Angle( cmd:GetMouseY() * (mPitch:GetFloat()), cmd:GetMouseX() * (-mYaw:GetFloat()), 0 )
			CAKE.FreeScrollAng.p = Clamp( NormalizeAngle( CAKE.FreeScrollAng.p ), -89, 89 )
		else
			CAKE.FreeScrollAng = Angle( 0, 0, 0 )
			CAKE.FreeScroll = false
			if CAKE.Thirdperson:GetBool() and !LocalPlayer():GetNWBool( "aiming", false ) then --NON AIMING THIRDPERSON
				if CAKE.SwitchFromFirstPerson and CAKE.LastViewAng then
					CAKE.RealAng = CAKE.LastViewAng
					CAKE.CurAng = CAKE.RealAng
					CAKE.LastAng = CAKE.LastViewAng
					CAKE.OldAngles = CAKE.LastAng
					CAKE.CurAng = CAKE.LastAng
					--CAKE.RealAng = CAKE.CurAng
					CAKE.SwitchFromFirstPerson = false
					CAKE.UseHeadRotation = false
				elseif !CAKE.RealAng then
					CAKE.RealAng = cmd:GetViewAngles()
				end
				CAKE.LastAng = CAKE.RealAng
				CAKE.RealAng = CAKE.RealAng + Angle( cmd:GetMouseY() * (mPitch:GetFloat()), cmd:GetMouseX() * (-mYaw:GetFloat()), 0 )
				CAKE.RealAng.p = Clamp( NormalizeAngle( CAKE.RealAng.p ), -89, 89 )
				CAKE.RealAng.y = NormalizeAngle( CAKE.RealAng.y )
				if cmd:GetButtons() & IN_FORWARD > 0 or cmd:GetButtons() & IN_BACK > 0 then
					cmd:SetViewAngles(CAKE.RealAng)
					CAKE.LastViewAng = CAKE.CurAng
					CAKE.UseHeadRotation = false
				else
					timer.UnPause("TiramisuLookAtTimer")
					CAKE.UseHeadRotation = true
					cmd:SetViewAngles(CAKE.LastViewAng)
				end
				if abs(AngleDifference(CAKE.RealAng.y, CAKE.LastViewAng.y)) > 170 then
					cmd:SetViewAngles( CAKE.RealAng )
					CAKE.LastViewAng = CAKE.RealAng
					CAKE.LastAng = CAKE.RealAng
					LocalPlayer():AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GESTURE_TURN_RIGHT180 )
				end
			elseif CAKE.Thirdperson:GetBool() and LocalPlayer():GetNWBool( "aiming", false ) then --OVER THE SHOULDER
				if CAKE.UseHeadRotation then
					cmd:SetViewAngles(CAKE.RealAng)
				end
				if !CAKE.OTSAng then
					CAKE.OTSAng = cmd:GetViewAngles()
				end
				CAKE.OTSAng = CAKE.OTSAng + Angle( cmd:GetMouseY() * (mPitch:GetFloat()), cmd:GetMouseX() * (-mYaw:GetFloat()), 0 )
				CAKE.OTSAng.p = Clamp( NormalizeAngle( CAKE.OTSAng.p ), -89, 89 )
			
				trace = util.TraceHull( {
					start = EyePos(),
					endpos = EyePos() + ( gui.ScreenToVector( ScrW()/2, ScrH()/2 ) * 30000 ),
					filter = LocalPlayer(),
					mask = MASK_SHOT,
					mins = Vector(-12,-12,-12),
					maxs = Vector( 12, 12, 12),
				} )

				--Hit Correction
				if ValidEntity(trace.Entity) and !trace.HitWorld and !trace.HitSky then
					local head = trace.Entity:LookupBone("ValveBiped.Bip01_Head1")
					if head then
						hitpos = Lerp( 0.3, trace.HitPos, trace.Entity:GetBonePosition(head) )
					else
						hitpos = Lerp( 0.3, trace.HitPos, trace.Entity:LocalToWorld(trace.Entity:OBBCenter()))
					end
				else
					hitpos = trace.HitPos
				end

				hitpos = hitpos - trace.HitNormal
				
				vecMove.x = cmd:GetForwardMove()
				vecMove.y = cmd:GetSideMove()
				vecMove.z = cmd:GetUpMove()
				
				ang = rad( cmd:GetViewAngles().y - CAKE.OTSAng.y )
				ca = cos( ang )
				sa = sin( ang )
				
				cmd:SetForwardMove( vecMove.x * ca - vecMove.y * sa )
				cmd:SetSideMove( vecMove.x * sa + vecMove.y * ca )
				cmd:SetUpMove( vecMove.z )
				
				LocalPlayer():LagCompensation( true )
				CAKE.DiffReal = ( hitpos - EyePos() ):Angle() + LocalPlayer():GetPunchAngle()
				CAKE.DiffReal.r = 0
				LocalPlayer():LagCompensation( false )
				
				cmd:SetViewAngles( CAKE.DiffReal )

				CAKE.LastViewAng = cmd:GetViewAngles()
				CAKE.UseHeadRotation = false
				CAKE.SwitchFromFirstPerson = true
				CAKE.DiffReal = Angle( 0, 0, 0 )
			else
				if CAKE.UseHeadRotation then
					cmd:SetViewAngles(CAKE.RealAng)
				end
				CAKE.OTSAng = false
				CAKE.UseHeadRotation = false
				CAKE.SwitchFromFirstPerson = true
				CAKE.DiffReal = Angle( 0, 0, 0 )
				CAKE.LastViewAng = cmd:GetViewAngles()
			end
		end
	else
		CAKE.SwitchFromFirstPerson = false
		CAKE.UseHeadRotation = false
	end
end )

local head
hook.Add("CalcView", "TiramisuThirdperson", function(ply, pos , angles ,fov)

	if IronsightsOn() or ply:InVehicle() then
		CAKE.CameraPos = pos
		return GAMEMODE:CalcView(ply, pos , angles ,fov)
	end

	if CAKE.FreeScroll then --Rotate around the player/objective

		if ValidEntity( CAKE.ViewRagdoll ) then
			targetent = CAKE.ViewRagdoll
		else
			targetent = ply
		end

		tracedata.start = targetent:LocalToWorld(targetent:OBBCenter())
		tracedata.endpos = targetent:LocalToWorld(targetent:OBBCenter()) + CAKE.FreeScrollAng:Forward()*targetent:BoundingRadius()*3
		tracedata.filter = targetent
		trace = util.TraceLine(tracedata)

		pos = LerpVector( RealFrameTime() * CAKE.CameraSmoothFactor:GetFloat(), (CAKE.CameraPos or pos), trace.HitPos + trace.HitNormal * 4 )

		CAKE.CameraPos = pos
		CAKE.CameraAngle = angles
		return GAMEMODE:CalcView(ply, pos, (targetent:LocalToWorld(targetent:OBBCenter())-pos):Angle(), fov)
	end

	if CAKE.Thirdperson:GetBool() then --All thirdperson code goes here.

		if !CAKE.OldAngles then
			CAKE.OldAngles = Angle( angles.p, angles.y, 0 )
		end

		if( ply:GetNWBool( "aiming", false ) and CAKE.OTSAng ) then--Over the shoulder view.

			trace = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() - CAKE.OTSAng:Forward() * CAKE.ThirdpersonDistance:GetInt() + CAKE.OTSAng:Right() * 15 + CAKE.OTSAng:Up() * 7.5,
				filter = ply,
				mask = MASK_SOLID_BRUSHONLY,
			} )
			
			if !CAKE.CameraPos then
				CAKE.CameraPos = trace.HitPos + trace.HitNormal*2
			else
				CAKE.CameraPos = LerpVector( RealFrameTime() * CAKE.CameraSmoothFactor:GetFloat(), CAKE.CameraPos, trace.HitPos + trace.HitNormal*2 )
			end
			
			if !CAKE.OldAngles then
				CAKE.OldAngles = CAKE.OTSAng
			else
				CAKE.OldAngles = LerpAngle( RealFrameTime() * CAKE.CameraSmoothFactor:GetFloat(), CAKE.OldAngles, CAKE.OTSAng )  
			end
			
			CAKE.OldAngles.r = 0
			
			return GAMEMODE:CalcView( ply, CAKE.CameraPos, CAKE.OldAngles, fov )
	
		else -- Regular view.

			CAKE.DiffAng = CAKE.RealAng - CAKE.LastAng
			CAKE.DiffAng = Angle( Clamp(CAKE.DiffAng.p, -89, 89), NormalizeAngle(CAKE.DiffAng.y),0 )
			CAKE.CurAng = CAKE.LastAng + CAKE.DiffAng
			--angles = CAKE.CurAng
			CAKE.LastAng = CAKE.CurAng 
			CAKE.LastAng.y = NormalizeAngle( CAKE.LastAng.y )

			if !ply:InVehicle() then
				tracedata.start = pos
				tracedata.endpos = pos - ( CAKE.CurAng:Forward() * CAKE.ThirdpersonDistance:GetInt() * 2 ) + ( angles:Up()* 10 )
				tracedata.filter = ply
				trace = util.TraceLine(tracedata)
				pos = LerpVector( RealFrameTime() * CAKE.CameraSmoothFactor:GetFloat(), (CAKE.CameraPos or pos), trace.HitPos + trace.HitNormal*2 )
			else
				pos = ply:EyePos()
			end
			CAKE.CurAng = LerpAngle( RealFrameTime() * CAKE.CameraSmoothFactor:GetFloat(), CAKE.OldAngles, Angle( CAKE.CurAng.p, CAKE.CurAng.y, 0 ) )
			CAKE.OldAngles = CAKE.CurAng
			CAKE.CameraPos = pos
			return GAMEMODE:CalcView(ply, pos , Angle( CAKE.CurAng.p, CAKE.CurAng.y, 0) ,fov)
	
		end

	end

	CAKE.CameraPos = pos
	if CAKE.FirstpersonBody:GetBool() then
		head = ply:LookupBone( "ValveBiped.Bip01_Head1" )
		if head then
			pos = ply:GetBonePosition( head ) + angles:Forward() * 1 + angles:Up() * 4
		end
	elseif CAKE.Headbob:GetBool() then

	end
	return GAMEMODE:CalcView(ply, pos , angles ,fov)
end)

hook.Add( "UpdateAnimation", "TiramisuAnimateRotate", function( ply, velocity, maxseqgroundspeed )
	if ply == LocalPlayer() and !CAKE.ForceDraw then
		--ply:SetPoseParameter("aim_yaw", 0 )
		ply:SetPoseParameter("head_yaw", 0 )
		ply:SetPoseParameter("body_yaw", 0 )
		ply:SetPoseParameter("spine_yaw", 0 )
		if CAKE.UseHeadRotation then
			lookattarget = CAKE.RealAng - CAKE.LastViewAng
			lookattarget = Angle( lookattarget.p, NormalizeAngle( lookattarget.y ), 0 )
			if !ply.CurrentLookAt then
				ply.CurrentLookAt = lookattarget
			end
			ang = LerpAngle( 0.1, ply.CurrentLookAt, lookattarget)
			ply.CurrentLookAt = ang
			ply:SetPoseParameter("head_pitch", ang.p + 10)
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
		else
			ply.CurrentLookAt = Angle( 0, 0, 0 )
		end
	end
end)

/*
hook.Add( "HUDPaint", "tits", function()
	draw.SimpleTextOutlined( "CURRENT ANGLE: " .. tostring( CAKE.CurAng ), "ScoreboardText", 10, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0,0,0,255))
	draw.SimpleTextOutlined( "LAST ANGLE: " .. tostring( CAKE.LastAng ), "ScoreboardText", 10, 30, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0,0,0,255))
	draw.SimpleTextOutlined( "ANGLE DIFFERENCE: " .. tostring( CAKE.DiffAng ), "ScoreboardText", 10, 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0,0,0,255))
	draw.SimpleTextOutlined( "RAW MOUSE ANGLE: " .. tostring( CAKE.RealAng ), "ScoreboardText", 10, 70, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0,0,0,255))
	draw.SimpleTextOutlined( "LAST VIEW ANGLE: " .. tostring( CAKE.LastViewAng ), "ScoreboardText", 10, 90, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0,0,0,255))
end)*/
