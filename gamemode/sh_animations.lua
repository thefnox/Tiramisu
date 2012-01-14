--NPC Animations V4
Anims = {}
Anims.SequenceCache = {}
Anims.PersonalityTypes = {
	"default",
	"relaxed",
	"headstrong",
	"frustrated"
}

local meta = FindMetaTable( "Player" )
local model

function meta:GetGender()

	model = self:GetModel()
	if table.HasValue( Anims.Female[ "models" ], model ) or self:GetNWString( "gender", "Male" ) == "Female" then
		return "Female"
	end
	
	return "Male"

end

function meta:SetGesture( gesture, weight )

	self.DoGesture = gesture
	self.DoGestureWeight = weight or 1

end

function meta:StopGesture()

	self.DoGesture = false

end

function meta:GetPersonality()

	self.Personality = self.Personality or "default"

	if table.HasValue( Anims.PersonalityTypes, self.Personality ) then
		return self.Personality
	end

	return "default"

end

function meta:SetPersonality( i )

	i = tostring(i)

	if table.HasValue( Anims.PersonalityTypes, i:lower() ) then
		self.Personality = i
	else
		self.Personality = "default"
	end
	if SERVER then
		umsg.Start( "Tiramisu.SendPersonality" )
			umsg.Entity( self )
			umsg.String( self.Personality )
		umsg.End()
	end

end


local shotgunholdtypes = {
	"shotgun"
}

local meleeholdtypes = {
	"passive",
	"melee"
}
		
function Anims.DetectHoldType( act ) --This is just a function used to group up similar holdtype for them to use the same sequences, since NPC animations are kinda limited.
	--You can add or remove to this list as you see fit, if you feel like creating a different holdtype.
	
	if string.match(  act, "pistol" ) then
		return "pistol"
	end
	if string.match(  act, "melee2" ) then
		return "melee2"
	end
	for k, v in pairs( shotgunholdtypes ) do
		if string.match( act, v ) then
			return "shotgun"
		end
	end
	for k, v in pairs( meleeholdtypes ) do
		if string.match( act, v ) then
			return "melee"
		end
	end
	if string.match(  act, "ar2" ) then
		return "ar2"
	end
	if string.match(  act, "smg" ) then
		return "smg"
	end
	if string.match(  act, "rpg" ) then
		return "rpg"
	end
	if string.match(  act, "grenade" ) then
		return "grenade"
	end
	if string.match(  act, "knife" ) then
		return "knife"
	end
	if string.match(  act, "fist" ) then
		return "fist"
	end
	if string.match(  act, "slam" ) then
		return "slam"
	end
	return "default"
	
end

if SERVER then
	--Weapons that are always aimed
	AlwaysAimed = {
		"weapon_physgun",
		"weapon_physcannon",
		"weapon_frag",
		"weapon_slam",
		"weapon_rpg",
		"gmod_tool"
	}

	--Weapons that are never aimed
	NeverAimed = {
			"hands"
	}

	function meta:SetSpecialModel( model )
		self:SetNWBool( "specialmodel", true )
   		self:SetModel( model )
	end

	
	function meta:SetAiming( bool )
		local wep = self:GetActiveWeapon()
		if self:GetNWBool( "arrested", false ) then
			bool = false
		end
		if ValidEntity( wep ) and wep:GetClass() != nil and wep.SetNextPrimaryFire != nil then
			if table.HasValue( AlwaysAimed, wep:GetClass() ) then
				bool = true
			end
			if table.HasValue( NeverAimed, wep:GetClass() ) then
				bool = false
			end

			if bool then
				if not self.wasAiming then
					wep:SetNextPrimaryFire( CurTime() + .5 ) -- Slight time to 'aim' weapon before fire.
				end
				self.wasAiming = bool
			else
				wep:SetNextPrimaryFire( CurTime() + 999999999 )
				self.wasAiming = bool
			end
		end
		self:DrawViewModel( bool )
		self:SetNWBool( "aiming", bool )
	end
	
	local function HolsterToggle( ply, cmd, args )
		ply:SetAiming( !ply:GetAiming() )
	end
	concommand.Add( "rp_toggleholster", HolsterToggle )
	concommand.Add( "toggleholster", HolsterToggle )
	
	hook.Add( "PlayerSpawn", "TiramisuAnimSpawnHandle", function( ply )
		ply:SetAiming( false )
		timer.Create( ply:SteamID() .. "TiramisuAimTimer", 0.1, 0, function()
			if ValidEntity( ply ) then
				if ply.TiramisuLastWeapon and ValidEntity( ply:GetActiveWeapon() ) and ply:GetActiveWeapon():GetClass() != ply.TiramisuLastWeapon then
					ply:SetAiming( false )
					ply.TiramisuLastWeapon = ply:GetActiveWeapon():GetClass()
				else
					if ValidEntity( ply:GetActiveWeapon() ) then
						ply.TiramisuLastWeapon = ply:GetActiveWeapon():GetClass()
					end
				end
			end
	   end)
	end)

	hook.Add( "KeyPress", "TiramisuAimCheck", function(ply, key)
		if ValidEntity( ply ) and ValidEntity( ply:GetActiveWeapon() ) then
			if key == IN_ATTACK or key == IN_ATTACK2 then
			ply:SetAiming( true )
			end
		end
	end)

	--This is the look at for thirdperson command. Don't touch this.
	concommand.Add( "t_sla", function( ply, cmd, args )
		ply:SetNWAngle( "tiramisulookat", Angle( tonumber(args[1] or 0), tonumber(args[2] or 0), 0))
	end)


	concommand.Add( "t_setpersonality", function( ply, cmd, args )
		ply:SetPersonality( args[1] )
	end)

else
	
	local matrix
	local function ScaleDemBones( ply, n, physbones )
		if ply and n then
			matrix = ply:GetBoneMatrix( n )
			if matrix then
				matrix:Scale(Vector( 0.001,0.001,0.001 ))
				ply:SetBoneMatrix(n, matrix)
			end
		end
	end

	hook.Add( "OnEntityCreated", "Tiramisu.StripYouOfYourBones", function(ent)
		if ent:IsPlayer() then
			if !ent.oldbuildbones then
				ent.oldbuildbones = ent.BuildBonePositions
			end
			if ent.oldbuildbones then
				ent.BuildBonePositions = function( ent, numbones, numphysbones)
					ent.oldbuildbones(ent, numbones, numphysbones)
					ScaleDemBones( ent, numbones, numphysbones )
				end
			else
				ent.BuildBonePositions = ScaleDemBones
			end
		end
	end)

	usermessage.Hook( "Tiramisu.SendPersonality", function(um)
		local ply = um:ReadEntity()
		if ValidEntity( ply ) then
			ply:SetPersonality( um:ReadString() )
		end
	end)	

end

function meta:GetAiming()
	if self:GetNWBool( "aiming", false ) then
		return true
	end
	
	return false
end

meta = nil

--local cachetable = {}
local function FindEnumeration( actname ) --Finds the enumeration number based on it's name.

	--if cachetable[actname] then return cachetable[actname] end

	for k, v in pairs ( _E ) do
		if(  k == actname ) then
			--cachetable[actname] = v
			return tonumber( v )
		end
	end
	
	return -1

end

local function FindName( actnum ) --Finds the enumeration name based on it's number.
	for k, v in pairs ( _E ) do
		if(  v == actnum ) then
			return tostring( k )
		end
	end
	
	return "ACT_IDLE"
end	

local function HandleLuaAnimation( ply, animation )
	
	if CLIENT then
		if !ply.InLuaSequence then
			ply.InLuaSequence = true
			ply:SetLuaAnimation( animation )
		end
	end
	
end

local exp
local exp2
local model
local sequence
local skeletonanim
local gender
local gesture
local lastseq
local weight
function HandleSequence( ply, seq ) --Internal function to handle different sequence types.
	
	ply.SpecialModel = ply:GetNWBool( "specialmodel", false )
	

	if !ply.Sequence then
		ply.Sequence = "none"
	end
	
	if string.match( seq, "&" ) then
		ply.Sequence = seq
		if string.match( seq, "sequence" ) then -- NON ENUMERATED SEQUENCE
			--"&sequence:modelstring;sequencestring"
			exp = string.Explode( ";", string.gsub( seq, "&", "" ) )
			exp2 = string.Explode( ":", exp[1] )
			model = exp2[2]
			seq = exp[2]
			if !model then
				model = Anims[ply:GetGender()][ "models" ][1]
			end
			if( ply:GetModel():lower() != model:lower() and !ply.SpecialModel and ply:GetNWBool( "charloaded", false ) ) then
				ply:SetModel( model )
			end
			if !Anims.SequenceCache[ply:GetModel()] then
				Anims.SequenceCache[ply:GetModel()] = {}
			end
			if !Anims.SequenceCache[ply:GetModel()][seq] then
				Anims.SequenceCache[ply:GetModel()][seq] = ply:LookupSequence(string.gsub( seq, ";", "" ))
			end
			return 1, Anims.SequenceCache[ply:GetModel()][seq]
		elseif string.match( seq, "gesture" ) then --ENUMERATED SEQUENCE WITH A GESTURE
			--"&gesture:modelstring;enumerationstring;gesturestring;weight(optional)"
			exp = string.Explode( ";", string.gsub( seq, "&", "" ) )
			exp2 = string.Explode( ":", exp[1] )
			seq = exp[2]
			gesture = ply:LookupSequence(exp[3])
			model = exp2[2]
			if exp[4] then
				weight = exp[4]
			else
				weight = 1
			end
			if !model then
				model = Anims[ply:GetGender()][ "models" ][1]
			end
			if( ply:GetModel() != model:lower() and !ply.SpecialModel and ply:GetNWBool( "charloaded", false ) ) then
				ply:SetModel( model )
			end
			ply:SetGesture( gesture, weight )
			return FindEnumeration( seq ), -1

		elseif string.match( seq, "number" ) then -- NUMBER BASED ENUMERATIONS, BASICALLY THE OPPOSITE OF STRING ONES
			--"&number:modelstring;sequencenumber"
			exp = string.Explode( ";", string.gsub( seq, "&", "" ) )
			exp2 = string.Explode( ":", exp[1] )
			model = exp2[2]
			seq = exp[2]
			if( ply:GetModel() != string.lower(model) and !ply.SpecialModel and ply:GetNWBool( "charloaded", false )) then
				ply:SetModel( model )
			end
			exp = string.Explode( ":", string.gsub( seq, "&", "" ) )
			
			return FindName(seq), -1
		end
		
		if string.match( seq, "lua" ) then --LUA BASED ANIMATIONS USING JETBOOMS LIBRARY
			exp = string.Explode( ";", string.gsub( seq, "&", "" ) )
			exp2 = string.Explode( ":", exp[1] )
			sequence = exp2[2]
			skeletonanim = exp[2] or "ACT_DIERAGDOLL"
			HandleLuaAnimation( ply, sequence )
			
			return FindEnumeration( skeletonanim ), -1
		else
			if ply.InLuaSequence then
				if CLIENT then
					ply:StopAllLuaAnimations()
				end
				ply.InLuaSequence = false
			end
		end
		
		if string.match( seq, "switch" ) then --Internal handler used to switch skeletons.
			exp = string.Explode( ";", string.gsub( seq, "&", "" ) )
			exp2 = string.Explode( ":", exp[1] )
			model = exp2[2]
			seq = exp[2]
			if( ply:GetModel() != string.lower(model) and !ply.SpecialModel and ply:GetNWBool( "charloaded", false )) then
				ply:SetModel( model )
			end
			
			return FindEnumeration( seq ), -1
		end
	end

	
	return FindEnumeration( seq ), -1
	
end

function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed ) -- This handles everything about how sequences run, the framerate, boneparameters, everything.

	local len = velocity:Length()
	local movement = 1.0
	if ( len > 0.2 ) then
		movement =  ( len / maxseqgroundspeed )
	end
	local eye = ply:EyeAngles()
	
	rate = math.min( movement * 0.8, 2 )

	// if we're under water we want to constantly be swimming..
	if ( (!ply:IsOnGround() and len >= 1000) or ply:WaterLevel() >= 2 ) then 
		rate = 0.1
	end
	
	ply:SetPlaybackRate( rate )

	if ( ply:InVehicle() ) then
		local Vehicle =  ply:GetVehicle()
		
		// We only need to do this clientside..
		if ( CLIENT ) then
			//
			// This is used for the 'rollercoaster' arms
			//
			local Velocity = Vehicle:GetVelocity()
			ply:SetPoseParameter( "vertical_velocity", Velocity.z * 0.01 ) 

			// Pass the vehicles steer param down to the player
			local steer = Vehicle:GetPoseParameter( "vehicle_steer" )
			steer = steer * 2 - 1 // convert from 0..1 to -1..1
			ply:SetPoseParameter( "vehicle_steer", steer  ) 
		end
		
	end
		
	local estyaw = math.Clamp( math.atan2(velocity.y, velocity.x) * 180 / 3.141592, -180, 180 )
	local myaw = math.NormalizeAngle(math.NormalizeAngle(eye.y) - estyaw)

	if !ply:GetNWBool( "sittingchair", false ) then
		ply:SetPoseParameter("move_yaw", myaw * -1 )
	else
		ply:SetPoseParameter("move_yaw", 0 )
	end

	if ply:GetNWAngle( "tiramisulookat", Angle( 0, 0, 0 )) != Angle( 0, 0, 0 ) and ( SERVER or ply != LocalPlayer()) then
		if !ply.CurrentLookAt then
			ply.CurrentLookAt = ply:GetNWAngle( "tiramisulookat")
		end
		ang = LerpAngle( 0.1, ply.CurrentLookAt, ply:GetNWAngle( "tiramisulookat"))
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
		--print("HEAD YAW:", ply:GetPoseParameter("head_yaw"))
	elseif SERVER or ply != LocalPlayer() then
		--This set of boneparameters are all set to 0 to avoid having the engine setting them to something else, thus resulting in  awkwardly twisted models
		ply.CurrentLookAt = Angle( 0, 0, 0 )
		ply:SetPoseParameter("aim_yaw", 0 )
		ply:SetPoseParameter("head_yaw", 0 )
		ply:SetPoseParameter("body_yaw", 0 )
		ply:SetPoseParameter("spine_yaw", 0 )
	end
	ply:SetPoseParameter("head_roll", 0 )
	
end

function GM:HandlePlayerJumping( ply ) --Handles jumping

	local holdtype
	--If we're not on the ground, then play the gliding animation.
	if !ply.Jumping and !ply:OnGround() and !ply:GetNWBool( "sittingchair", false ) and ply:WaterLevel() <= 0 then
		ply.Jumping = true
		ply.FirstJumpFrame = false
		ply.JumpStartTime = CurTime()
	end
	
	if ply.Jumping then
		if ply.FirstJumpFrame then
			ply.FirstJumpFrame = false
			ply:AnimRestartMainSequence()
		end
		
		if ply:WaterLevel() >= 2 then
			ply.Jumping = false
			ply:AnimRestartMainSequence()
					end
					
		if (CurTime() - ply.JumpStartTime) > 0.4 then --If we have been on the air for more than 0.4 seconds, then we're meant to play the land animation.
			if ply:OnGround() and !ply.Landing and ply:GetMoveType() == MOVETYPE_WALK then
				ply.Landing = true
				timer.Simple( 0.3, function()
					ply.Landing = false
					ply.Jumping = false
				end)
				return true
			end
		else
			if ply:OnGround() and !ply.Landing then
				ply.Jumping = false
				ply:AnimRestartMainSequence()
			end
		end
		
		if ply.Jumping then --If we're still on a part of the jumping sequence, that means we're either on the process of jumping or landing.
			if !ply.Landing then 
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ ply:GetPersonality() ][ "jump" ] )
			else
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ ply:GetPersonality() ][ "land" ] )
			end
			return true
		end
	end
	
	return false
end
 
function GM:HandlePlayerDucking( ply, velocity, holdtype ) --Handles crouching

	local len2d = velocity:Length2D() -- the velocity on the x and y axis.

	if ply:Crouching() and ply:WaterLevel() <= 0 then
		if ply:GetNWBool( "aiming", false ) then
			if len2d > 0.5 then
				ply.CalcIdeal, ply.CalcSeqOverride =  HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "crouch" ][ "aimwalk" ] )
			else
				ply.CalcIdeal, ply.CalcSeqOverride =  HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "crouch" ][ "aimidle" ] )
			end
		else
			if len2d > 0.5 then
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "crouch" ][ "walk" ] )
			else
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "crouch" ][ "idle" ] )
			end
		end
		return true
	end
	
	return false
end
 
function GM:HandlePlayerSwimming( ply, velocity ) --Handles swimming.

	if ( ply:WaterLevel() < 2 ) then 
		ply.m_bInSwim = false
		return false 
	end
	
	ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ "default" ][ "swim" ] )
	
	if SERVER then
		ply:SetAiming(false)
	end
	ply.m_bInSwim = true
	return true
end

function GM:HandlePlayerDriving( ply ) --Handles sequences while in vehicles.

	local vehicle
	local class
 
	if ply:InVehicle() then
		vehicle = ply:GetVehicle()
		class = vehicle:GetClass()
		if ( class == "prop_vehicle_jeep" ) then
			ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, "&sequence:models/player/breen.mdl;drive_jeep" )
		elseif ( class == "prop_vehicle_airboat" ) then
			ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, "&sequence:models/player/breen.mdl;drive_airboat" )
		elseif ( class == "prop_vehicle_prisoner_pod" and vehicle:GetModel() == "models/vehicles/prisoner_pod_inner.mdl" ) then
			ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, "&sequence:models/player/breen.mdl;drive_pd" )
		else
			ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, "&sequence:models/player/breen.mdl;sit_rollercoaster" )
		end
		return true
	end
end

function GM:HandlePlayerNoClipping( ply, velocity )

	if ( false ) then

		if ( ply:GetMoveType() != MOVETYPE_NOCLIP ) then 
			return false 
		end
		
		if ( velocity:Length() > 1000 ) then
			ply.CalcIdeal, calc = ACT_MP_SWIM
		else
			ply.CalcIdeal = ACT_MP_SWIM_IDLE
		end
			
		return true
	end

	return false

end

function GM:HandlePlayerVaulting( ply, velocity )

	if ( velocity:Length() < 1000 ) then return end
	if ( ply:IsOnGround() or ply:WaterLevel() >= 2 ) then return end

	ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ "default" ][ "swim" ] )	
	return true

end

function GM:HandleExtraActivities( ply ) --Drop in here everything additional you need checks for.

	--Use this hook for all the other sequenced activities you may wanna add, like uh, flying I guess.

		if ply:GetNWBool( "sittingchair", false ) then
			if !ply.IsSittingDamn then
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ ply:GetPersonality() ][ "sitentry" ] )
				timer.Simple( 1.5, function()
					ply.IsSittingDamn = true
				end)
				return true
			else
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ ply:GetPersonality() ][ "sit" ]  )
				return true
			end
		else
			if ply.IsSittingDamn then
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ ply:GetPersonality() ][ "sitexit" ]  )
				timer.Simple( 0.8, function()
					ply.IsSittingDamn = false
				end)
				return true
			end
		end
		
		if ply:GetNWBool( "sittingground", false ) then
			if !ply.IsSittingGround then
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ ply:GetPersonality() ][ "sitgroundentry" ]  )
				timer.Simple( 1.7, function()
					ply.IsSittingGround = true
				end)
				return true
			else
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ ply:GetPersonality() ][ "sitground" ]  )
				return true
			end
		else
			if ply.IsSittingGround then
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ ply:GetPersonality() ][ "sitgroundexit" ]  )
				timer.Simple( 1.2, function()
					ply.IsSittingGround = false
				end)
				return true
			end
		end
	
	return false

end

function GM:CalcMainActivity( ply, velocity )
	--This is the hook used to handle sequences, if you need to add additional activities you should check the hook above.
	--By a general rule you don't have to touch this hook at all.
	local holdtype = "default"
	local personality = ply:GetPersonality()
	if( ValidEntity(ply:GetActiveWeapon()) ) then
		holdtype = Anims.DetectHoldType( ply:GetActiveWeapon():GetHoldType() ) 
	end

	if holdtype == "default" and personality != "default" and !ply:GetNWBool( "specialmodel" ) then
		holdtype = personality --We use the personality custom animation table, rather than the default.
	end

	ply.CalcIdeal = ACT_IDLE
	ply.CalcSeqOverride = -1
	
	if self:HandleExtraActivities( ply ) or self:HandlePlayerDriving( ply ) or
		self:HandlePlayerJumping( ply ) or
		self:HandlePlayerDucking( ply, velocity, holdtype ) or
		self:HandlePlayerSwimming( ply, velocity ) or self:HandlePlayerVaulting( ply, velocity ) then --We do nothing, I guess, lol.
	else
		local len2d = velocity:Length2D()
		if ply:GetNWBool( "aiming", false ) then
			if len2d > 320 then
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ personality ][ "sprint" ] )
				if SERVER then
					if ply:GetAiming() and !ply.WasAimingBeforeRunning then
						ply.WasAimingBeforeRunning = true
					end
					ply:SetAiming( false )
				end				
			elseif len2d > 135 and len2d <= 320 then
				ply.CalcIdeal, ply.CalcSeqOverride =  HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "run" ] )
				if SERVER then
					if ply:GetAiming() and !ply.WasAimingBeforeRunning then
						ply.WasAimingBeforeRunning = true
					end
					ply:SetAiming( false )
				end
			elseif len2d > 0.1 and len2d <= 135 then
				if ply.WasAimingBeforeRunning then
					ply:SetAiming( true )
					ply.WasAimingBeforeRunning = false
				end
				ply.CalcIdeal, ply.CalcSeqOverride =  HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "aim" ][ "walk" ] )
			else
				if ply.WasAimingBeforeRunning then
					ply:SetAiming( true )
					ply.WasAimingBeforeRunning = false
				end
				if !ply:GetNWBool( "specialmodel" ) then
					ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "aim" ][ "idle" ] )
				else
					ply.CalcIdeal, ply.CalcSeqOverride = ACT_IDLE, -1
				end
			end
		else
			if len2d > 320 then
				ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][ personality ][ "sprint" ] )
			elseif len2d > 135 and len2d <= 320 then
				ply.CalcIdeal, ply.CalcSeqOverride =  HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "run" ] )
			elseif len2d > 0.1 and len2d <= 135 then
				if ply.WasAimingBeforeRunning then
					ply:SetAiming( true )
					ply.WasAimingBeforeRunning = false
				end
				ply.CalcIdeal, ply.CalcSeqOverride =  HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "walk" ] )
			else
				if ply.WasAimingBeforeRunning then
					ply:SetAiming( true )
					ply.WasAimingBeforeRunning = false
				end
				if !ply:GetNWBool( "specialmodel" ) then
					ply.CalcIdeal, ply.CalcSeqOverride = HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "idle" ] )
				else
					ply.CalcIdeal, ply.CalcSeqOverride = ACT_IDLE, -1
				end
			end
		end
	end

	if CLIENT and CAKE.ForceDraw then
		if !ply:GetNWBool( "specialmodel", false ) then
			return HandleSequence( ply, Anims[ ply:GetGender() ][ "default" ][ "idle" ] )
		else
			return ACT_IDLE, -1
		end
	end

	return ply.CalcIdeal, ply.CalcSeqOverride or -1

end		
	
function GM:TranslateActivity( ply, act )
		
	--We're not translating through the weapon, thus, this hook isn't used.
	return act
		
end
 
function GM:DoAnimationEvent( ply, event, data ) -- This is for gestures.

	holdtype = "default"
	if( ValidEntity(  ply:GetActiveWeapon() ) ) then
		holdtype = Anims.DetectHoldType( ply:GetActiveWeapon():GetHoldType() ) 
	end

	if event == "CUSTOMGESTUREPARTY"  then
		ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, data )
	end

	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then

		if Anims[ ply:GetGender() ][ holdtype ][ "fire" ] then
			if !string.match( Anims[ ply:GetGender() ][ holdtype ][ "fire" ], "&lua" ) then
				local ideal, override = HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "fire" ] )
				if override == -1 then
					ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ideal )
				else
					ply.CalcSeqOverride = override
				end
			else
				exp = string.Explode( ";", string.gsub( Anims[ ply:GetGender() ][ holdtype ][ "fire" ], "&", "" ) )
				exp2 = string.Explode( ":", exp[1] )
				sequence = exp2[2]
				if CLIENT then
					ply:SetLuaAnimation( sequence )
				end
			end
		else
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GESTURE_RANGE_ATTACK_SMG1 )
		end

		return ACT_VM_PRIMARYATTACK
	
	elseif event == PLAYERANIMEVENT_RELOAD then

		if Anims[ ply:GetGender() ][ holdtype ][ "reload" ] then
			if( string.match( Anims[ ply:GetGender() ][ holdtype ][ "reload" ], "GESTURE" ) ) then
				ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, FindEnumeration(  Anims[ ply:GetGender() ][ holdtype ][ "reload" ] ) )
			else
				--ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "reload" ] )
			end	
		else
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GESTURE_RELOAD_SMG1 )
		end
	
		return ACT_INVALID

	elseif event == PLAYERANIMEVENT_CANCEL_RELOAD then
	
		ply:AnimResetGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD )
	
		return ACT_INVALID

	end
	
	if event == PLAYERANIMEVENT_JUMP then
	
		ply.Jumping = true
		ply.FirstJumpFrame = true
		ply.JumpStartTime = CurTime()
		
		ply:AnimRestartMainSequence()
		
		return ACT_INVALID
	
	end
 
	return nil
end