CLPLUGIN.Name = "Third Person Camera"
CLPLUGIN.Author = "F-Nox/Big Bang"

function CLPLUGIN.Init()
	
end

local function RecieveViewRagdoll( handler, id, encoded, decoded )
	CAKE.ViewRagdoll = decoded.ragdoll
	if ValidEntity( CAKE.ViewRagdoll ) then
		CAKE.ViewRagdoll.Clothing = decoded.clothing
	end
end
datastream.Hook( "RecieveViewRagdoll", RecieveViewRagdoll )


local function AlwaysDrawLocalPlayer()

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

local function Thirdperson(ply, pos, angles, fov)
--Added support for the Combine Mech

	if !ply:Alive() then return end
	if(ply:GetActiveWeapon() == NULL or ply:GetActiveWeapon() == "Camera") then return end
	if GetViewEntity() ~= ply and GetViewEntity():GetClass() ~= "prop_ragdoll" then return end
	
	local useCam = ply:GetNetworkedInt("ControlsCombineMech")
	
	if (useCam && useCam == 1 or useCam == 2) && ply:InVehicle() then
	
		local ent = ply:GetNetworkedEntity( "CombineMechEnt" )
		local saw = ply:GetNetworkedEntity( "CombineMechSawEnt" )

		if ent != NULL && ent:IsValid() then
	
			if useCam == 1 then
				local pos = ent:GetPos() + (angles:Forward() * -300)
				
				local Trace = {}
				Trace.start = ent:GetPos() + (angles:Forward() * -100)
				Trace.endpos = pos
				Trace.filter = {ply,ent,saw}
				local tr = util.TraceLine(Trace)
				
				if tr.Hit then	
					pos = tr.HitPos
				end	
				
				position = pos
				return GAMEMODE:CalcView(ply, position, angles, fov)
			elseif useCam == 2 then
				local pos = saw:GetPos()
				local ang = saw:GetAngles()
				ang.p = angles.p
				ang.y = angles.y
				angles = ang
				pos = pos + saw:GetForward() * 50 + saw:GetUp() * -20

				position = pos
				return GAMEMODE:CalcView(ply, position, angles, fov)
			end
		end
	else
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
			
			if( ply:GetActiveWeapon():GetNWBool( "NPCAimed", false ) ) then
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
			
		else
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
	if (useCam && useCam == 1 or useCam == 2) && not(ply:InVehicle()) then
		ply:SetNetworkedInt("ControlsCombineMech",0)
	end	
	
    return GAMEMODE:CalcView(ply, pos , angles ,fov)
    
end
hook.Add("CalcView", "BlissThirdperson", Thirdperson)