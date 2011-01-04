CLPLUGIN.Name = "Third Person Camera"
CLPLUGIN.Author = "F-Nox/Big Bang"

function CLPLUGIN.Init()
end

CAKE.Thirdperson = CreateClientConVar( "rp_thirdperson", 0, true, true )
CAKE.ThirdpersonDistance = CreateClientConVar( "rp_thirdpersondistance", 50, true, true )
CAKE.Headbob = CreateClientConVar( "rp_headbob", 1, true, true )
CAKE.HeadbobAmount = CreateClientConVar( "rp_headbob", 1, true, true )
CAKE.MiddleDown = false

local mouserotate = Angle( 0, 0, 0 )
local mousex
local newpos
local headpos, headang
local tracedata = {}
local ignoreent

local function RecieveViewRagdoll( handler, id, encoded, decoded )
	CAKE.ViewRagdoll = decoded.ragdoll
	if ValidEntity( CAKE.ViewRagdoll ) then
		CAKE.ViewRagdoll.Clothing = decoded.clothing
	end
end
datastream.Hook( "RecieveViewRagdoll", RecieveViewRagdoll )

local function RecieveUnconciousRagdoll( handler, id, encoded, decoded )
	CAKE.ViewRagdoll = decoded.ragdoll
	if ValidEntity( CAKE.ViewRagdoll ) then
		CAKE.ViewRagdoll.Clothing = decoded.clothing
	end
end
datastream.Hook( "RecieveUnconciousRagdoll", RecieveUnconciousRagdoll )

local function drawlocalplayer()

	if CAKE.Thirdperson:GetBool() or CAKE.MiddleDown then
		return true
	end

	return false

end
hook.Add("ShouldDrawLocalPlayer","TiramisuDrawLocalPlayer", drawlocalplayer )

hook.Add("CalcView", "TiramisuThirdperson", function(ply, pos , angles ,fov)

	if !newpos then
		newpos = pos
	end
	
	if CAKE.MiddleDown then
		tracedata.start = ply:EyePos()
		tracedata.endpos = ply:GetForward()*100
		tracedata.filter = ply
		trace = util.TraceLine(tracedata)
		
		newpos = trace.HitPos
		newpos:Rotate(mouserotate)
		pos = ply:GetPos()+Vector(0,0,60) + newpos
		return GAMEMODE:CalcView(ply, pos , (ply:GetPos()+Vector(0,0,60)-pos):Angle(),fov)
	end

	if( CAKE.Thirdperson:GetBool() ) then
		if ValidEntity( CAKE.ViewRagdoll ) then
			pos = CAKE.ViewRagdoll:GetPos()
			ignoreent = CAKE.ViewRagdoll
		else
			ignoreent = ply
		end
					
		if( ply:GetNWBool( "aiming", false ) ) then
            tracedata.start = pos
            tracedata.endpos = pos - ( angles:Forward() * CAKE.ThirdpersonDistance:GetInt() ) + ( angles:Right()* 30 )
            tracedata.filter = ignoreent
            trace = util.TraceLine(tracedata)
            
            pos = newpos
			newpos = LerpVector( 0.2, pos, trace.HitPos )

			return GAMEMODE:CalcView(ply, newpos , angles ,fov)
		else
            tracedata.start = pos
            tracedata.endpos = pos - ( angles:Forward() * CAKE.ThirdpersonDistance:GetInt() * 2 ) + ( angles:Up()* 20 )
            tracedata.filter = ignoreent
            trace = util.TraceLine(tracedata)
            
            pos = newpos
			newpos = LerpVector( 0.2, pos, trace.HitPos )

			return GAMEMODE:CalcView(ply, newpos , angles ,fov)

		end
	else --It's firstperson time!

		if ValidEntity( CAKE.ViewRagdoll ) then
			headpos, headang = CAKE.ViewRagdoll:GetBonePosition( CAKE.ViewRagdoll:LookupBone( "ValveBiped.Bip01_Head1" ) )
			return GAMEMODE:CalcView(ply, headpos, angles ,fov)
		end

		if CAKE.Headbob:GetBool() then
			headpos, headang = LocalPlayer():GetBonePosition( LocalPlayer():LookupBone( "ValveBiped.Bip01_Head1" ) )
			return GAMEMODE:CalcView(ply, headpos, angles ,fov)
		end

	end

	return GAMEMODE:CalcView(ply, pos , angles ,fov)


end)

timer.Create( "LocalMouseControlCam", 0.01, 0, function()
	if !input.IsMouseDown(MOUSE_MIDDLE) and CAKE.MiddleDown then
		CAKE.MiddleDown = false
		gui.EnableScreenClicker( false )
	elseif input.IsMouseDown(MOUSE_MIDDLE) and !CAKE.MiddleDown then
		CAKE.MiddleDown = true
		mouserotate = Angle(0,0,0)
		gui.EnableScreenClicker( true )
		gui.SetMousePos( ScrW()/2, ScrH()/2 )
		mousex = gui.MouseX()
	elseif input.IsMouseDown(MOUSE_MIDDLE) and CAKE.MiddleDown then
		mouserotate.y = math.NormalizeAngle(( gui.MouseX() - mousex ) / 2)
	end
end)