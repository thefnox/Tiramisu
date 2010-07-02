// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModel			= "models/weapons/v_physcannon.mdl"
SWEP.WorldModel			= "models/weapons/w_physics.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_MegaPhysCannon.HoldSound")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 0.1

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"				// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"

SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.HoldType				= "physgun"

SWEP.RunArmOffset 		= Vector (0.041, 0, 5.6778)
SWEP.RunArmAngle 			= Vector (-17.6901, 0.321, 0)

SWEP.EmittingSound		= false

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("ambient/levels/citadel/zapper_loop1.wav")
    	util.PrecacheSound("ambient/levels/citadel/zapper_loop2.wav")
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if self.Owner:KeyDown(IN_SPEED) then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local trace = self.Owner:GetEyeTrace()
	local ent = self.Owner:GetEyeTrace().Entity

	if (self.Owner:EyePos():Distance(ent:GetPos()) < 300) then

		if not self.EmittingSound then
			self.Weapon:EmitSound(self.Primary.Sound)
			self.EmittingSound = true
		end

/*
		local effectdata = EffectData()
			effectdata:SetOrigin(trace.HitPos)
			effectdata:SetNormal(trace.HitNormal)
			effectdata:SetScale(10)
		util.Effect("StunstickImpact", effectdata)
*/

		if (SERVER and GetConVarNumber("mad_damagesystem_resistance") != 0 and ent:IsValid() and MadCows[ent:EntIndex()] and MadCows[ent:EntIndex()] < ent:GetPhysicsObject():GetMass()) then
			local mass = ent:GetPhysicsObject():GetMass()
			local repair = math.Clamp(mass / 50, 0, 10)

			MadCows[ent:EntIndex()] = math.Clamp(MadCows[ent:EntIndex()] + repair, 0, mass)

			ent:SetNWInt("health", MadCows[ent:EntIndex()])
			ent:SetNWInt("maxhealth", mass)
		end
	elseif (self.EmittingSound) then
		self:StopSounds()
	end	
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
   Name: SWEP:SecondThink()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:SecondThink()

	local ent = self.Owner:GetEyeTrace().Entity

	if (self.Owner:KeyReleased(IN_ATTACK) or self.Owner:KeyReleased(IN_ATTACK2) or self.Owner:KeyDown(IN_SPEED)) and self.EmittingSound then
		self:StopSounds()
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
end

/*---------------------------------------------------------
   Name: SWEP:Holster()
   Desc: Weapon wants to holster.
	   Return true to allow the weapon to holster.
---------------------------------------------------------*/
function SWEP:Holster()

	self:StopSounds()

	return true
end

/*---------------------------------------------------------
   Name: SWEP:StopSounds()
---------------------------------------------------------*/
function SWEP:StopSounds()

	if self.EmittingSound then
		self.Weapon:StopSound(self.Primary.Sound)
		self.EmittingSound = false
	end	
end