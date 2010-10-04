CLPLUGIN.Name = "Third Person Camera"
CLPLUGIN.Author = "F-Nox/Big Bang"

function CLPLUGIN.Init()
	
end

local pressvec = Vector( 0,0,0 )
local newpos = Vector( 0, 0, 0 )
local rotateangles = Angle(0,0,0)
local tracedata = {}

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

	if !CAKE.Thirdperson:GetBool() then	
		if CAKE.RenderBody:GetBool() then
			return true
		end
	else
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

local function Thirdperson(ply, pos, angles, fov)
	if ply:GetNWBool( "sittingchair", false ) or ply:GetNWBool( "sittingground", false ) then
		newpos = ply:GetForward()*100	
		target = ply:GetPos()+Vector(0,0,60)	
		newpos:Rotate(rotateangles)
		pos=target+newpos
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
						tracedata.endpos = pos - ( angles:Forward()*50 ) - ( angles:Right()* 25 )
						tracedata.filter = ply
						local trace = util.TraceLine(tracedata)
						if trace.HitWorld then
							newpos = trace.HitPos
						else
							newpos = pos - ( angles:Forward()*50 ) - ( angles:Right()* 25 )
						end
						return GAMEMODE:CalcView(ply, newpos , angles ,fov)
					
					else
						tracedata.start = pos
						tracedata.endpos = pos - ( angles:Forward()*100 )
						tracedata.filter = ply
						local trace = util.TraceLine(tracedata)
						if trace.HitWorld then
							newpos = trace.HitPos
						else
							newpos = pos - ( angles:Forward()*100 )
						end
				
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
					newpos = headpos + ( angles:Up()*CAKE.FirstPersonUp:GetFloat() ) + ( angles:Forward()*CAKE.FirstPersonForward:GetFloat() )
					return GAMEMODE:CalcView(ply, newpos , angles ,fov)
				
				end
			end
		else
				newpos = ply:GetForward()*100
				
				target = ply:GetPos()+Vector(0,0,60)
				
				newpos:Rotate(rotateangles)
				pos=target+newpos
				return GAMEMODE:CalcView(ply, pos , (target-pos):Angle() ,fov)
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
			rotateangles.p = rotateangles.p + movey

			gui.SetMousePos(pressvec.x,pressvec.y)
		end
	end
end)