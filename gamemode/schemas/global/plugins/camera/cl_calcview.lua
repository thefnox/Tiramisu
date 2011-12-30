local mouserotate = Angle( 0, 0, 0 )
local mousex, newpos, headpos, headang, ignoreent, targetent, hypotenuse, lookattarget, ang, length
local tracedata = {}
CAKE.CameraSmoothFactor = 0.9
CAKE.CameraPos = Vector(0, 0, 0)
CAKE.CameraAngle = Angle(0, 0, 0)
CAKE.LastViewAng = Angle(0, 0, 0)
CAKE.RealAng = Angle(0, 0, 0)
CAKE.DiffReal = Angle(0, 0, 0)
CAKE.OldAngles = Angle(0, 0, 0)
CAKE.LastAng = Angle(0, 0, 0)
CAKE.CurAng = Angle(0, 0, 0)
CAKE.CorrectionAngle = 0
CAKE.CorrectionData = {}

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

local firstpersonswitch = false
hook.Add( "CreateMove", "TiramisuCreateMoveCamera", function( UCMD )
	if CAKE.Thirdperson:GetBool() and !LocalPlayer():GetNWBool( "aiming", false ) then
		if firstpersonswitch and CAKE.LastViewAng then
			CAKE.CurAng = CAKE.LastViewAng
			UCMD:SetViewAngles(CAKE.LastViewAng)
			firstpersonswitch = false
			stillcamera = false
		end
		CAKE.RealAng = UCMD:GetViewAngles()
		if UCMD:GetButtons() & IN_FORWARD > 0 or UCMD:GetButtons() & IN_BACK > 0 then
			CAKE.LastViewAng = CAKE.CurAng
			CAKE.DiffReal = CAKE.CurAng - CAKE.RealAng
			UCMD:SetViewAngles(CAKE.CurAng)
			CAKE.RealAng = CAKE.CurAng
			stillcamera = false
		else
			timer.UnPause("TiramisuLookAtTimer")
			stillcamera = true
			CAKE.DiffReal = Angle( 0, 0, 0 )
			UCMD:SetViewAngles(CAKE.LastViewAng)
		end
	elseif CAKE.Thirdperson:GetBool() and LocalPlayer():GetNWBool( "aiming", false ) then
		stillcamera = false
		firstpersonswitch = true
		CAKE.DiffReal = Angle( 0, 0, 0 )
		--UCMD:SetViewAngles( UCMD:GetViewAngles() + Angle(0,CAKE.CorrectionAngle,0))
		CAKE.LastViewAng = UCMD:GetViewAngles()
	else
		stillcamera = false
		firstpersonswitch = true
		CAKE.DiffReal = Angle( 0, 0, 0 )
		CAKE.LastViewAng = UCMD:GetViewAngles()
	end
end )

hook.Add("ShouldDrawLocalPlayer","TiramisuDrawLocalPlayerCamera", function()
	if (CAKE.Thirdperson:GetBool() and CAKE.ThirdpersonDistance:GetInt() != 0 ) or CAKE.FreeScroll then
		return true
	end

	return false
end)

local amount = 5
hook.Add( "PlayerBindPress", "TiramisuPlayerBindPressCamera", function( ply, bind, down )
	if string.find(bind, "invprev") then
		RunConsoleCommand( "rp_thirdpersondistance",  tostring(math.Clamp( CAKE.ThirdpersonDistance:GetInt() - amount, 0, 250)))
	elseif string.find(bind, "invnext") then
		RunConsoleCommand( "rp_thirdpersondistance",  tostring(math.Clamp( CAKE.ThirdpersonDistance:GetInt() + amount, 0, 250)))
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

		CAKE.DiffAng = CAKE.RealAng - angles
		CAKE.CurAng = CAKE.LastAng + CAKE.DiffAng - CAKE.DiffReal
		CAKE.CurAng = Angle( math.Clamp(CAKE.CurAng.p or 0, -90, 90 ), CAKE.CurAng.y, CAKE.CurAng.r )
		--angles = CAKE.CurAng
		CAKE.LastAng = CAKE.CurAng 

		if( ply:GetNWBool( "aiming", false ) ) then--Over the shoulder view.
			if !ply:InVehicle() then
				--Setting the camera to the over the shoulder position.
				tracedata.start = pos
				tracedata.endpos = pos - ( angles:Forward() * CAKE.ThirdpersonDistance:GetInt() ) + ( angles:Right()* 30 )
				tracedata.filter = ply
				trace = util.TraceLine(tracedata)
				pos = LerpVector( CAKE.CameraSmoothFactor, pos, trace.HitPos + trace.HitNormal*2 )
			else
				pos = ply:EyePos() -- Override it
			end
			angles = LerpAngle( CAKE.CameraSmoothFactor, CAKE.OldAngles, Angle( angles.p, angles.y , 0 ) )
			CAKE.OldAngles = angles
			CAKE.CameraPos = pos
			return GAMEMODE:CalcView(ply, pos, Angle( angles.p, angles.y, 0), fov)
	
		else -- Regular view.
	
			if !ply:InVehicle() then
				tracedata.start = pos
				tracedata.endpos = pos - ( CAKE.CurAng:Forward() * CAKE.ThirdpersonDistance:GetInt() * 2 ) --+ ( angles:Up()* 20 )
				tracedata.filter = ply
				trace = util.TraceLine(tracedata)
				pos = LerpVector( CAKE.CameraSmoothFactor, pos, trace.HitPos + trace.HitNormal*2 )
			else
				pos = ply:EyePos()
			end
			CAKE.CurAng = LerpAngle( CAKE.CameraSmoothFactor, CAKE.OldAngles, Angle( CAKE.CurAng.p, CAKE.CurAng.y, 0 ) )
			CAKE.OldAngles = CAKE.CurAng
			CAKE.CameraPos = pos
			return GAMEMODE:CalcView(ply, pos , Angle( CAKE.CurAng.p, CAKE.CurAng.y, 0) ,fov)
	
		end

	end

	CAKE.CameraPos = pos
	return GAMEMODE:CalcView(ply, pos , angles ,fov)
end)

hook.Add( "UpdateAnimation", "TiramisuAnimateRotate", function( ply, velocity, maxseqgroundspeed )
	if ply == LocalPlayer() then
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

	if CAKE.Thirdperson:GetBool() and LocalPlayer():GetNWBool( "aiming", false ) then
		--Calculating the hypotenuse
		CAKE.CorrectionData["origin"] = LocalPlayer():GetShootPos()
		CAKE.CorrectionData["ideal"] = gui.ScreenToVector( ScrW()/2, ScrH()/2 )
		CAKE.CorrectionData["endpos"] = CAKE.CameraPos + CAKE.CorrectionData["ideal"] * 10000
		tracedata.start = CAKE.CameraPos
		tracedata.endpos = CAKE.CorrectionData["endpos"]
		tracedata.filter = LocalPlayer()
		trace = util.TraceLine(tracedata)
		CAKE.CorrectionData["hitpos"] = trace.HitPos
		CAKE.CorrectionData["hypotenuse"] = CAKE.CorrectionData["origin"]:Distance(CAKE.CorrectionData["hitpos"])

		--Calculating adyacent leg.
		CAKE.CorrectionData["leg"] = CAKE.CorrectionData["origin"]:Distance(LocalPlayer():GetEyeTrace().HitPos)

		if (CAKE.CorrectionData["hypotenuse"] != 0 ) then
			CAKE.CorrectionAngle =  math.Rad2Deg(math.acos(math.Clamp( CAKE.CorrectionData["leg"]/CAKE.CorrectionData["hypotenuse"], -1, 1)))
		else
			CAKE.CorrectionAngle = 0
		end
	else
		CAKE.CorrectionAngle = 0
	end

end)