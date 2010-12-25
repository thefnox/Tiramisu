CLPLUGIN.Name = "Third Person Camera"
CLPLUGIN.Author = "F-Nox/Big Bang"

CAKE.CamPos = false

function CLPLUGIN.Init()
	
end

local pressvec = Vector( 0,0,0 )
local newpos = Vector( 0, 0, 0 )
local rotateangles = Angle(0,0,0)
local tracedata = {}
local exitingrotatemode = false

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

local function AlwaysDrawLocalPlayer()

	if CAKE.MenuOpen or LocalPlayer():GetNWBool( "sittingchair", false ) or LocalPlayer():GetNWBool( "sittingground", false ) then
		return true
	end
	
	if !CAKE.UseCalcView:GetBool() then
		return false
	end

	if CAKE.Thirdperson:GetBool() then	
		return true
	end
	
	return false
		
end
hook.Add("ShouldDrawLocalPlayer","AlwaysDrawLocalPlayer", AlwaysDrawLocalPlayer)

local shutrenderbody = false
local shutthirdperson = false
local headpos, headang
local oripos
local target
local trace
local oldangle = Angle( 0, 0, 0 )
local newangle = Angle( 0, 0, 0 )

local function Thirdperson(ply, pos, angles, fov)
	if ply:GetNWBool( "sittingchair", false ) or ply:GetNWBool( "sittingground", false ) then
		tracedata.start = pos
		tracedata.endpos = ply:GetForward()*100
		tracedata.filter = ply
		trace = util.TraceLine(tracedata)
		if trace.HitWorld then
			newpos = trace.HitPos
		else
			newpos = ply:GetForward()*100
		end
		
		newpos = ply:GetForward()*100	
		target = ply:GetPos()+Vector(0,0,60)
				
		newpos:Rotate(rotateangles)
		pos=target+newpos
		CAKE.CamPos = pos
		return GAMEMODE:CalcView(ply, pos , (target-pos):Angle() ,fov)
		
	end
	
		if !CAKE.MenuOpen then
			if CAKE.UseCalcView:GetBool() then
				if( ValidEntity( ply:GetActiveWeapon() ) and ply:GetActiveWeapon():GetDTBool( 1 ) ) then
					if CAKE.Thirdperson:GetBool() then
						RunConsoleCommand( "rp_thirdperson", 0 )
						shutthirdperson = true
					end
					if CAKE.RenderBody:GetBool() then
						RunConsoleCommand( "rp_renderbody", 0 )
						shutrenderbody = true
					end
					return GAMEMODE:CalcView(ply, pos , angles ,fov)
				else
					if shutrenderbody then
						RunConsoleCommand( "rp_renderbody", 1 )
						shutrenderbody = false
					end
					if shutthirdperson then
						RunConsoleCommand( "rp_thirdperson", 1 )
						thirdperson = false
					end
				end
				if( CAKE.Thirdperson:GetBool() ) then
					
					if ValidEntity( CAKE.ViewRagdoll ) then
						pos = CAKE.ViewRagdoll:GetPos()
					end
					
					if( ply:GetNWBool( "aiming", false ) ) then
                    tracedata.start = pos
                    tracedata.endpos = pos - ( angles:Forward()*50 ) - ( angles:Right()* 30 )
                    tracedata.filter = ply
                    trace = util.TraceLine(tracedata)
                    oldpos = newpos
                    if trace.HitWorld then
						newpos = LerpVector( 0.2, oldpos, trace.HitPos )
                    else
						newpos = LerpVector( 0.2, oldpos, pos - ( angles:Forward()*50 ) - ( angles:Right()* 30 ) )
                    end
					CAKE.CamPos = newpos
					return GAMEMODE:CalcView(ply, newpos , angles ,fov)
					
				else
						tracedata.start = pos
						tracedata.endpos = pos - ( angles:Forward()*100 )
						tracedata.filter = ply
						oldpos = newpos
						trace = util.TraceLine(tracedata)
						if trace.HitWorld then
							newpos = LerpVector( 0.2, oldpos, trace.HitPos )
						else
							newpos = LerpVector( 0.2, oldpos, pos - ( angles:Forward()*100 ) )
						end
						CAKE.CamPos = newpos
						return GAMEMODE:CalcView(ply, newpos , angles ,fov)
				
					end
					
				elseif !CAKE.Thirdperson:GetBool() then
				
					if CAKE.Headbob:GetBool() and !ValidEntity( CAKE.ViewRagdoll ) then
						headpos, headang = LocalPlayer():GetBonePosition( LocalPlayer():LookupBone( "ValveBiped.Bip01_Head1" ) )
					elseif ValidEntity( CAKE.ViewRagdoll ) then
						headpos, headang = CAKE.ViewRagdoll:GetBonePosition( CAKE.ViewRagdoll:LookupBone( "ValveBiped.Bip01_Head1" ) )
					else
						headpos, headang = pos, angles
					end
					
					CAKE.CamPos = headpos
					return GAMEMODE:CalcView(ply, headpos, headang ,fov)
				
				end
			end
		else
			if middleDown then
				tracedata.start = newpos
				tracedata.endpos = Angle( 0, ply:GetAngles().y, 0 ):Forward()*100
				tracedata.filter = ply
				trace = util.TraceLine(tracedata)
				if trace.HitWorld then
					newpos = trace.HitPos
				else
					newpos = Angle( 0, ply:GetAngles().y, 0 ):Forward()*100
				end
				
				target = ply:GetPos()+Vector(0,0,60)
				
				newpos:Rotate(rotateangles)
				newpos = target+newpos
				newangle = (target-newpos):Angle()
				return GAMEMODE:CalcView(ply, newpos , newangle ,fov)
			else
				target = Angle( 0, ply:GetAngles().y, 0 ):Forward()*100
				target:Rotate( Angle( 0, 0, 0 ) )
				newpos = LerpVector( 0.2, newpos, ply:GetPos()+Vector(0,0,60) + target )	
				angles = Angle( 0, math.NormalizeAngle( angles.y + 180 ), angles.r )
				return GAMEMODE:CalcView(ply, newpos , angles ,fov)
			end
		end
	
	return GAMEMODE:CalcView(ply, pos , angles ,fov)
end
	
hook.Add("CalcView", "OldenThirdperson", Thirdperson)
	
hook.Add("Think","TiramisuMouseCalc", function()
	if CAKE.MenuOpen or LocalPlayer():GetNWBool( "sittingchair", false ) or LocalPlayer():GetNWBool( "sittingground", false ) then
		if !input.IsMouseDown(MOUSE_RIGHT) and middleDown then
			middleDown = false
		elseif input.IsMouseDown(MOUSE_RIGHT) and !middleDown then
			middleDown = true 
			pressvec.x = gui.MouseX()
			pressvec.y  = gui.MouseY()
			
		elseif input.IsMouseDown(MOUSE_RIGHT) and middleDown then
			local movex = ( gui.MouseX()-pressvec.x )
			rotateangles.y = rotateangles.y + movex
			
			local movey = (gui.MouseY()-pressvec.y)
			--rotateangles.p = rotateangles.p + movey

			gui.SetMousePos(pressvec.x,pressvec.y)
		end
	end
end)