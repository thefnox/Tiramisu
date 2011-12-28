local mouserotate = Angle( 0, 0, 0 )
local mousex, newpos, headpos, headang, ignoreent, targetent
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

usermessage.Hook( "recieveragdoll", function( um )
	
	CAKE.ViewRagdoll = ents.GetByIndex( um:ReadShort() )

end)

local stillcamera = false
timer.Create( "TiramisuLookAtTimer", 0.5, 0, function()
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
		CAKE.RealAng = UCMD:GetViewAngles()
		CAKE.LastViewAng = CAKE.CurAng
		CAKE.DiffReal = CAKE.CurAng - CAKE.RealAng
		UCMD:SetViewAngles(CAKE.CurAng)
		CAKE.RealAng = CAKE.CurAng
		stillcamera = false
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
		angles = CAKE.CurAng
		CAKE.LastAng = CAKE.CurAng 

		if( ply:GetNWBool( "aiming", false ) ) then--Over the shoulder view.
			if !ply:InVehicle() then
				tracedata.start = pos
				tracedata.endpos = pos - ( angles:Forward() * CAKE.ThirdpersonDistance:GetInt() ) + ( angles:Right()* 30 )
				tracedata.filter = ply
				trace = util.TraceLine(tracedata)
				pos = LerpVector( CAKE.CameraSmoothFactor, pos, trace.HitPos + trace.HitNormal*2 )
			else
				pos = ply:EyePos()
			end
			angles = LerpAngle( CAKE.CameraSmoothFactor, CAKE.OldAngles, Angle( angles.p, angles.y, 0 ) )
			CAKE.OldAngles = angles
			return GAMEMODE:CalcView(ply, pos, Angle( angles.p, angles.y, 0), fov)
	
		else -- Regular view.
	
			if !ply:InVehicle() then
				tracedata.start = pos
				tracedata.endpos = pos - ( angles:Forward() * CAKE.ThirdpersonDistance:GetInt() * 2 ) --+ ( angles:Up()* 20 )
				tracedata.filter = ply
				trace = util.TraceLine(tracedata)
				pos = LerpVector( CAKE.CameraSmoothFactor, pos, trace.HitPos + trace.HitNormal*2 )
			else
				pos = ply:EyePos()
			end
			angles = LerpAngle( CAKE.CameraSmoothFactor, CAKE.OldAngles, Angle( angles.p, angles.y, 0 ) )
			CAKE.OldAngles = angles
			return GAMEMODE:CalcView(ply, pos , Angle( angles.p, angles.y, 0) ,fov)
	
		end

	end

	return GAMEMODE:CalcView(ply, pos , angles ,fov)
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