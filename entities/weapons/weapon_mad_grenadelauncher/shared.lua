// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_spas"

SWEP.ViewModel			= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("NPC_Combine.GrenadeLaunch")
SWEP.Primary.Reload		= Sound("Weapon_SHOTGUN.Reload")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 0.5

SWEP.Primary.ClipSize		= 1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Grenade"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "effect_mad_shell_shotgun"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= false
SWEP.Rifle				= false
SWEP.Shotgun			= true
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-8.9203, -4.7091, 1.7697)
SWEP.IronSightsAng 		= Vector (3.0659, 0.0913, 0)
SWEP.RunArmOffset 		= Vector (3, 0, 2.5)
SWEP.RunArmAngle 			= Vector (-13, 27, 0)

SWEP.Mode				= false

SWEP.HoldType				= "ar2"

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/grenade_launcher1.wav")
    	util.PrecacheSound("weapons/shotgun/shotgun_reload1.wav")
    	util.PrecacheSound("weapons/shotgun/shotgun_reload2.wav")
    	util.PrecacheSound("weapons/shotgun/shotgun_reload3.wav")
end

/*---------------------------------------------------------
   Name: SWEP:Grenade()
---------------------------------------------------------*/
SWEP.Force = 7500

function SWEP:Grenade()

	if (CLIENT) then return end

	local grenade = ents.Create("ent_mad_grenadelauncher")
		grenade:SetOwner(self.Owner)
		
		if not (self.Weapon:GetNetworkedBool("Ironsights")) then
			local pos = self.Owner:GetShootPos()
				pos = pos + self.Owner:GetForward() * 5
				pos = pos + self.Owner:GetRight() * 9
				pos = pos + self.Owner:GetUp() * -7
			grenade:SetPos(pos)	
		else
			grenade:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector()))
		end
		
		grenade:SetAngles(self.Owner:GetAngles())
		grenade:Spawn()
		grenade:Activate()

	local phys = grenade:GetPhysicsObject()
	phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force + Vector(0, 0, 200))
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetDTBool(0)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

	if (not self:CanPrimaryAttack()) then return end

	self.ActionDelay = (CurTime() + self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 		// View model animation
	self.Owner:SetAnimation(PLAYER_ATTACK1)				// 3rd Person Animation

	self.Weapon:EmitSound(self.Primary.Sound)

	self:TakePrimaryAmmo(1)

	self:Grenade()

	self.Owner:ViewPunch(Angle(math.Rand(-5, -15), math.Rand(0, 0), math.Rand(0, 0)))	

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Owner:GetShootPos())
		effectdata:SetEntity(self.Weapon)
		effectdata:SetStart(self.Owner:GetShootPos())
		effectdata:SetNormal(self.Owner:GetAimVector())
		effectdata:SetAttachment(1)
	util.Effect("effect_mad_shotgunsmoke", effectdata)

	timer.Simple(self.ShellDelay, function()
		if not self.Owner then return end
		if not IsFirstTimePredicted() then return end
		if not self.Owner:IsNPC() and not self.Owner:Alive() then return end

		local effectdata = EffectData()
			effectdata:SetEntity(self.Weapon)
			effectdata:SetNormal(self.Owner:GetAimVector())
			effectdata:SetAttachment(2)
		util.Effect(self.ShellEffect, effectdata)
	end)

	local WeaponModel = self.Weapon:GetOwner():GetActiveWeapon():GetClass()

	if (self.Weapon:Clip1() < 1) then
		timer.Simple(self.Primary.Delay + 0.1, function() 
			if not self.Owner then return end

			if self.Owner:Alive() and self.Weapon:GetOwner():GetActiveWeapon():GetClass() == WeaponModel then
				self:Reload() 
			end
		end)
	end
end