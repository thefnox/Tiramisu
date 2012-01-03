local mouserotate = Angle( 0, 0, 0 )
local mousex, newpos, targetent, lookattarget, ang, sa, ca, hitpos
local tracedata = {}
CAKE.CameraPos = Vector(0, 0, 0)
CAKE.CameraAngle = Angle(0, 0, 0)
CAKE.LastViewAng = Angle(0, 0, 0)
CAKE.RealAng = Angle(0, 0, 0)
CAKE.DiffReal = Angle(0, 0, 0)
CAKE.OldAngles = Angle(0, 0, 0)
CAKE.LastAng = Angle(0, 0, 0)
CAKE.CurAng = Angle(0, 0, 0)
CAKE.OTSPos = false
CAKE.OTSAng = false

usermessage.Hook( "recieveragdoll", function( um )
	
	CAKE.ViewRagdoll = ents.GetByIndex( um:ReadShort() )

end)

local stillcamera = false
timer.Create( "TiramisuLookAtTimer", 0.2, 0, function()
	if stillcamera then
		local angle = CAKE.CurAng - CAKE.LastViewAng
		RunConsoleCommand("t_sla", angle.p, math.NormalizeAngle( angle.y ))
	else
		RunConsoleCommand("t_sla", 0,0 )
		timer.Pause("TiramisuLookAtTimer")
	end
end)

--local intersect, intersecty,intersectz, x1, x2, x3, x3, y1, y2, y3, y4
local firstpersonswitch = false

local vecMove = Vector()

local mPitch = GetConVar( "m_pitch" )
local mYaw = GetConVar( "m_yaw" )

hook.Add( "CreateMove", "TiramisuCreateMoveCamera", function( cmd )
	CAKE.CameraMouseX = cmd:GetMouseX()
	CAKE.CameraMouseY = cmd:GetMouseY()
	if CAKE.Thirdperson:GetBool() and !LocalPlayer():GetNWBool( "aiming", false ) then
		if firstpersonswitch and CAKE.LastViewAng then
			CAKE.LastAng = CAKE.LastViewAng
			CAKE.OldAngles = CAKE.LastAng
			CAKE.CurAng = CAKE.LastAng
			--CAKE.RealAng = CAKE.CurAng
			firstpersonswitch = false
			stillcamera = false
		else
			CAKE.RealAng = cmd:GetViewAngles()
		end
		CAKE.RealAng = cmd:GetViewAngles()
		if cmd:GetButtons() & IN_FORWARD > 0 or cmd:GetButtons() & IN_BACK > 0 then
			CAKE.LastViewAng = CAKE.CurAng
			CAKE.DiffReal = CAKE.CurAng - CAKE.RealAng
			cmd:SetViewAngles(CAKE.CurAng)
			CAKE.RealAng = CAKE.CurAng
			stillcamera = false
		else
			timer.UnPause("TiramisuLookAtTimer")
			stillcamera = true
			CAKE.DiffReal = Angle( 0, 0, 0 )
			cmd:SetViewAngles(CAKE.LastViewAng)
		end
		CAKE.CorrectionAngle = 0
	elseif CAKE.Thirdperson:GetBool() and LocalPlayer():GetNWBool( "aiming", false ) then
		if !CAKE.OTSAng then
			CAKE.OTSAng = cmd:GetViewAngles()
		end
		CAKE.OTSAng = CAKE.OTSAng + Angle( cmd:GetMouseY() * mPitch:GetFloat(), cmd:GetMouseX() * -mYaw:GetFloat(), 0 )
		CAKE.OTSAng.p = math.Clamp( math.NormalizeAngle( CAKE.OTSAng.p ), -89, 89 )
	
		trace = util.TraceHull( {
			start = EyePos(),
			endpos = EyePos() + ( gui.ScreenToVector( ScrW()/2, ScrH()/2 ) * 5120 ),
			filter = LocalPlayer(),
			mask = MASK_SHOT,
			mins = Vector(-12,-12,-12),
			maxs = Vector( 12, 12, 12),
		} )

		--Hit Correction
		if ValidEntity(trace.Entity) and !trace.Entity:IsWorld() then
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
		
		ang = math.rad( cmd:GetViewAngles().y - CAKE.OTSAng.y )
		ca = math.cos( ang )
		sa = math.sin( ang )
		
		cmd:SetForwardMove( vecMove.x * ca - vecMove.y * sa )
		cmd:SetSideMove( vecMove.x * sa + vecMove.y * ca )
		cmd:SetUpMove( vecMove.z )
		
		LocalPlayer():LagCompensation( true )
		CAKE.DiffReal = ( hitpos - EyePos() ):Angle() + LocalPlayer():GetPunchAngle()
		CAKE.DiffReal.r = 0
		LocalPlayer():LagCompensation( false )
		
		cmd:SetViewAngles( CAKE.DiffReal )

		stillcamera = false
		firstpersonswitch = true
		CAKE.DiffReal = Angle( 0, 0, 0 )
	else
		CAKE.OTSAng = false
		stillcamera = false
		firstpersonswitch = true
		CAKE.DiffReal = Angle( 0, 0, 0 )
		CAKE.LastViewAng = cmd:GetViewAngles()
	end
end )

hook.Add("ShouldDrawLocalPlayer","TiramisuDrawLocalPlayerCamera", function()
	if CAKE.ForceDraw then
		return true
	end
	if (CAKE.Thirdperson:GetBool() and CAKE.ThirdpersonDistance:GetInt() != 0 ) or CAKE.FreeScroll then
		return true
	end

	return false
end)

local amount = 5
hook.Add( "PlayerBindPress", "TiramisuPlayerBindPressCamera", function( ply, bind, down )
	if string.find(bind, "invprev") then
		RunConsoleCommand( "rp_thirdpersondistance",  tostring(math.Clamp( CAKE.ThirdpersonDistance:GetInt() - amount, 0, 150)))
	elseif string.find(bind, "invnext") then
		RunConsoleCommand( "rp_thirdpersondistance",  tostring(math.Clamp( CAKE.ThirdpersonDistance:GetInt() + amount, 0, 150)))
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

hook.Add("CalcView", "TiramisuThirdperson", function(ply, pos , angles ,fov)

	if CAKE.FreeScroll then --Rotate around the player/objective
		if ValidEntity( CAKE.ViewRagdoll ) then
			targetent = CAKE.ViewRagdoll
		else
			targetent = ply
		end

		newpos =  targetent:GetAngles():Forward()*100
		newpos:Rotate(mouserotate)
		pos = targetent:LocalToWorld(targetent:OBBCenter()) + Vector(0,0,10) + newpos

		tracedata.start = targetent:LocalToWorld(targetent:OBBCenter()) + Vector(0,0,10)
		tracedata.endpos = targetent:LocalToWorld(targetent:OBBCenter()) + Vector(0,0,10) + newpos
		tracedata.filter = targetent
		trace = util.TraceLine(tracedata)

		pos = trace.HitPos + trace.HitNormal * 4
		CAKE.CameraPos = pos
		CAKE.CameraAngle = angles
		return GAMEMODE:CalcView(ply, pos, (targetent:LocalToWorld(targetent:OBBCenter())+Vector(0,0,10)-pos):Angle(), fov)
	end

	if CAKE.Thirdperson:GetBool() then --All thirdperson code goes here.

		if !CAKE.OldAngles then
			CAKE.OldAngles = Angle( angles.p, angles.y, 0 )
		end

		if( ply:GetNWBool( "aiming", false ) and CAKE.OTSAng ) then--Over the shoulder view.

			trace = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() - CAKE.OTSAng:Forward() * CAKE.ThirdpersonDistance:GetInt() + CAKE.OTSAng:Right() * 20,
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

			CAKE.DiffAng = CAKE.RealAng - angles
			CAKE.CurAng = CAKE.LastAng + CAKE.DiffAng - CAKE.DiffReal
			CAKE.CurAng = Angle( math.Clamp(CAKE.CurAng.p or 0, -90, 90 ), CAKE.CurAng.y, CAKE.CurAng.r )
			--angles = CAKE.CurAng
			CAKE.LastAng = CAKE.CurAng 

			if !ply:InVehicle() then
				tracedata.start = pos
				tracedata.endpos = pos - ( CAKE.CurAng:Forward() * CAKE.ThirdpersonDistance:GetInt() * 2 ) --+ ( angles:Up()* 20 )
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
	return GAMEMODE:CalcView(ply, pos , angles ,fov)
end)

hook.Add( "UpdateAnimation", "TiramisuAnimateRotate", function( ply, velocity, maxseqgroundspeed )
	if ply == LocalPlayer() and !CAKE.ForceDraw then
		ply:SetPoseParameter("aim_yaw", 0 )
		ply:SetPoseParameter("head_yaw", 0 )
		ply:SetPoseParameter("body_yaw", 0 )
		ply:SetPoseParameter("spine_yaw", 0 )
		if stillcamera then
			lookattarget = CAKE.CurAng - CAKE.LastViewAng
			lookattarget = Angle( lookattarget.p, math.NormalizeAngle( lookattarget.y ), 0 )
			if !ply.CurrentLookAt then
				ply.CurrentLookAt = lookattarget
			end
			ang = LerpAngle( 0.1, ply.CurrentLookAt, lookattarget)
			ply.CurrentLookAt = ang
			ply:SetPoseParameter("head_pitch", ang.p + 20)
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
	else
		ply:SetPoseParameter("aim_yaw", 0 )
		ply:SetPoseParameter("head_yaw", 0 )
		ply:SetPoseParameter("body_yaw", 0 )
		ply:SetPoseParameter("spine_yaw", 0 )
	end
end)


local keydown = false
timer.Create( "LocalMouseControlCam", 0.01, 0, function()
	
	keydown = input.IsMouseDown(MOUSE_MIDDLE)
	
	if !CAKE.FreeScroll then
		if keydown then
			gui.EnableScreenClicker( true )
			gui.SetMousePos( ScrW()/2, ScrH()/2 )
			CAKE.FreeScroll = true
		end
	else
		if !keydown and !CAKE.ForceFreeScroll then
			CAKE.FreeScroll = false
			gui.EnableScreenClicker( false )
		end
		mouserotate.y = math.NormalizeAngle(( gui.MouseX() - ScrW()/2 ) / 2)
		mouserotate.p = math.NormalizeAngle(( gui.MouseY() - ScrH()/2 ) / -1.7)
	end

end)