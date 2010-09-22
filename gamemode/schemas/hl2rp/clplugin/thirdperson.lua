CLPLUGIN.Name = "Third Person Camera"
CLPLUGIN.Author = "F-Nox/Big Bang"

function CLPLUGIN.Init()
	
end

local camHeight = 60
local pressedPos = {}
local newpos = Vector( 0, 0, 0 )
local RotateAngles = Angle(0,0,0)

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

	if CAKE.MenuOpen then
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

timer.Simple( 1, function()
	local function Thirdperson(ply, pos, angles, fov)
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
						local tracedata = {}
						tracedata.start = pos
						tracedata.endpos = pos - ( angles:Forward()*50 ) - ( angles:Right()* 20 )
						tracedata.filter = ply
						local trace = util.TraceLine(tracedata)
						if trace.HitWorld then
							pos = trace.HitPos
						else
							pos = pos - ( angles:Forward()*50 ) - ( angles:Right()* 20 )
						end
						return GAMEMODE:CalcView(ply, pos , angles ,fov)
					
					else
				
						local tracedata = {}
						tracedata.start = pos
						tracedata.endpos = pos - ( angles:Forward()*100 )
						tracedata.filter = ply
						local trace = util.TraceLine(tracedata)
						if trace.HitWorld then
							pos = trace.HitPos
						else
							pos = pos - ( angles:Forward()*100 )
						end
				
						return GAMEMODE:CalcView(ply, pos , angles ,fov)
				
					end
					
				elseif !CAKE.Thirdperson:GetBool() then
					if CAKE.Headbob:GetBool() and !ValidEntity( CAKE.ViewRagdoll ) then
						headpos, headang = LocalPlayer():GetBonePosition( LocalPlayer():LookupBone( "ValveBiped.Bip01_Head1" ) )
					elseif ValidEntity( CAKE.ViewRagdoll ) then
						headpos, headang = CAKE.ViewRagdoll:GetBonePosition( CAKE.ViewRagdoll:LookupBone( "ValveBiped.Bip01_Head1" ) )
					else
						headpos, headang = pos, angles
					end
					pos = headpos + ( angles:Up()*CAKE.FirstPersonUp:GetFloat() ) + ( angles:Forward()*CAKE.FirstPersonForward:GetFloat() )
					return GAMEMODE:CalcView(ply, pos , angles ,fov)
				
				end
			end
		else
				/*
					local t = {}
					local vec = ply:GetForward()*25 + ply:GetUp()*10
					
					local camTarget = ply:GetPos()+Vector(0,0,camHeight)
					
					vec:Rotate(RotateAngles)
					t.origin=camTarget+vec
					t.angles=(camTarget-t.origin):Angle()
					return t
				*/
				local t = {}
				local vec = ply:GetForward()*100
				
				local camTarget = ply:GetPos()+Vector(0,0,60)
				
				vec:Rotate(RotateAngles)
				t.origin=camTarget+vec
				t.angles=(camTarget-t.origin):Angle()
				return GAMEMODE:CalcView(ply, t.origin , t.angles ,fov)
		end
		
		return GAMEMODE:CalcView(ply, pos , angles ,fov)
	end
		
	hook.Add("CalcView", "OldenThirdperson", Thirdperson)
end)

local function MousePos()
	if CAKE.MenuOpen then
		if !input.IsMouseDown(MOUSE_RIGHT) and middleDown then 
			middleDown = false
		elseif input.IsMouseDown(MOUSE_RIGHT) and !middleDown then
			middleDown = true 
			pressedPos[1] = gui.MouseX()
			pressedPos[2] = gui.MouseY()
			
		elseif input.IsMouseDown(MOUSE_RIGHT) and middleDown then
			local movex = ( gui.MouseX()-pressedPos[1] ) * 0.9
			RotateAngles.y = RotateAngles.y + movex
			
			local movey = (gui.MouseY()-pressedPos[2])
			RotateAngles.p = RotateAngles.p + movey

			gui.SetMousePos(pressedPos[1],pressedPos[2])
		end
	end
end
hook.Add("Think","TiramisuMouseCalc",MousePos)