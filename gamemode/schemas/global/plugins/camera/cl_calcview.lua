local mouserotate = Angle( 0, 0, 0 )
local mousex
local newpos
local headpos, headang
local tracedata = {}
local ignoreent
CAKE.CameraPos = Vector(0, 0, 0)
CAKE.CameraAngle = Angle(0, 0, 0)

usermessage.Hook( "recieveragdoll", function( um )
	
	CAKE.ViewRagdoll = ents.GetByIndex( um:ReadShort() )

end)

hook.Add("ShouldDrawLocalPlayer","TiramisuDrawLocalPlayer", function()
	if CAKE.Thirdperson:GetBool() or CAKE.FreeScroll then
		return true
	end

	return false
end)

hook.Add("CalcView", "TiramisuThirdperson", function(ply, pos , angles ,fov)

	if !newpos then
		newpos = pos
	end
	
	if CAKE.FreeScroll then --Rotate around the player/objective
		if ValidEntity( CAKE.ViewRagdoll ) then

			newpos =  CAKE.ViewRagdoll:GetAngles():Forward()*100
			newpos:Rotate(mouserotate)
			pos = CAKE.ViewRagdoll:LocalToWorld(CAKE.ViewRagdoll:OBBCenter()) + Vector(0,0,10) + newpos

			tracedata.start = CAKE.ViewRagdoll:LocalToWorld(CAKE.ViewRagdoll:OBBCenter()) + Vector(0,0,10)
			tracedata.endpos = CAKE.ViewRagdoll:LocalToWorld(CAKE.ViewRagdoll:OBBCenter()) + Vector(0,0,10) + newpos
			tracedata.filter = CAKE.ViewRagdoll
			trace = util.TraceLine(tracedata)

			pos = trace.HitPos + trace.HitNormal * 4
			CAKE.CameraPos = pos
			CAKE.CameraAngle = angles
			return GAMEMODE:CalcView(ply, pos, (CAKE.ViewRagdoll:LocalToWorld(CAKE.ViewRagdoll:OBBCenter())+Vector(0,0,10)-pos):Angle(), fov)

		else

			newpos = ply:GetAngles():Forward()*100
			newpos:Rotate(mouserotate)
			pos = ply:EyePos() + newpos

			tracedata.start = ply:EyePos()
			tracedata.endpos = ply:EyePos() + newpos
			tracedata.filter = ply
			trace = util.TraceLine(tracedata)

			pos = trace.HitPos + trace.HitNormal * 4
			CAKE.CameraPos = pos
			CAKE.CameraAngle = angles
			return GAMEMODE:CalcView(ply, pos, ( ply:EyePos() - pos ):Angle(), fov)

		end
	end

	if( CAKE.Thirdperson:GetBool() ) then --All thirdperson code goes here.
		if ValidEntity( CAKE.ViewRagdoll ) then
			pos = CAKE.ViewRagdoll:GetPos()
			ignoreent = CAKE.ViewRagdoll
		else
			ignoreent = ply
		end

		if CAKE.Headbob:GetBool() then
			pos = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) ) or ply:EyePos()
		end
					
		if( ply:GetNWBool( "aiming", false ) ) then--Over the shoulder view.
			if !LocalPlayer():InVehicle() then
				tracedata.start = pos
				tracedata.endpos = pos - ( angles:Forward() * CAKE.ThirdpersonDistance:GetInt() ) + ( angles:Right()* 30 )
				tracedata.filter = ignoreent
				trace = util.TraceLine(tracedata)  
	          		pos = newpos
				newpos = LerpVector( 0.3, pos, trace.HitPos + trace.HitNormal*2 )
			else
				newpos = LocalPlayer():EyePos()
			end

			CAKE.CameraPos = pos
			CAKE.CameraAngle = angles
			return GAMEMODE:CalcView(ply, newpos, angles, fov)
		else -- Regular view.
			if !LocalPlayer():InVehicle() then
				tracedata.start = pos
				tracedata.endpos = pos - ( angles:Forward() * CAKE.ThirdpersonDistance:GetInt() * 2 ) + ( angles:Up()* 20 )
				tracedata.filter = ignoreent
	    			trace = util.TraceLine(tracedata)
	          		pos = newpos
				newpos = LerpVector( 0.3, pos, trace.HitPos + trace.HitNormal*2 )
			else
				newpos = LocalPlayer():EyePos()
			end
			CAKE.CameraPos = pos
			CAKE.CameraAngle = angles
			return GAMEMODE:CalcView(ply, newpos , angles ,fov)

		end
	else --It's firstperson time!

		if ValidEntity( CAKE.ViewRagdoll ) then
			headpos, headang = CAKE.ViewRagdoll:GetBonePosition( CAKE.ViewRagdoll:LookupBone( "ValveBiped.Bip01_Head1" ) )
			newpos = headpos
			CAKE.CameraPos = pos
			CAKE.CameraAngle = angles
			return GAMEMODE:CalcView(ply, headpos, angles ,fov)
		end

		if CAKE.Headbob:GetBool() then
			headpos, headang = LocalPlayer():GetBonePosition( LocalPlayer():LookupBone( "ValveBiped.Bip01_Head1" ) )
			newpos = headpos
			CAKE.CameraPos = pos
			CAKE.CameraAngle = angles
			return GAMEMODE:CalcView(ply, headpos, angles ,fov)
		end

	end

	CAKE.CameraPos = pos
	CAKE.CameraAngle = angles
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