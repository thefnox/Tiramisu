// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModel 			= "models/ctf_weapons/v_alyx_gun.mdl"
SWEP.WorldModel 			= "models/weapons/w_alyx_gun.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound		= Sound("weapons/alyxgun/alyx_gun_fire.wav")
SWEP.Primary.Reload 		= Sound("Weapon_SMG1.Reload")
SWEP.Primary.Recoil		= 0.2
SWEP.Primary.Damage		= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.015
SWEP.Primary.Delay 		= 0.096

SWEP.Primary.ClipSize		= 30					// Size of a clip
SWEP.Primary.DefaultClip	= 30					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Battery"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "effect_mad_shell_pistol"	// "none" or "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.HoldType				= "pistol"

SWEP.IronSightsPos 		= Vector (-6.8784, -3.3806, 3.9993)
SWEP.IronSightsAng 		= Vector (0.3273, -2.9768, 1.6612)
SWEP.RunArmOffset 		= Vector (-0.0202, 0, 5.1736)
SWEP.RunArmAngle 			= Vector (-20.0943, 1.3665, 0)

SWEP.Type				= 1 					// 1 = Automatic/Semi-Automatic mode, 2 = Suppressor mode, 3 = Burst fire mode
SWEP.Mode				= true

SWEP.data 				= {}
SWEP.data.NormalMsg		= "Switched to semi-automatic."
SWEP.data.ModeMsg			= "Switched to automatic."
SWEP.data.Delay			= 1.1
SWEP.data.Cone			= 1.25
SWEP.data.Damage			= 1
SWEP.data.Recoil			= 1
SWEP.data.Automatic		= true

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/alyxgun/alyx_gun_fire.wav")
    	util.PrecacheSound("weapons/smg1/smg1_reload.wav")
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if self.Owner:IsNPC() then return end
	if not IsFirstTimePredicted() then return end

	if (self.Owner:KeyDown(IN_USE) and (self.Mode)) then // Mode
		bMode = !self.Weapon:GetDTBool(3)
		self:SetMode(bMode)
		self:SetIronsights(false)

		self.Weapon:SetNextPrimaryFire(CurTime() + self.data.Delay)
		self.Weapon:SetNextSecondaryFire(CurTime() + self.data.Delay)

		return
	end

	if (!self.IronSightsPos) or (self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0)) then return end

	if self.Weapon:GetDTBool(3) then
		if (SERVER) then
			self.Owner:PrintMessage(HUD_PRINTTALK, "You can't aim when you're in automatic fire!")
		end

		self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)

		return
	end
	
	// Not pressing Use + Right click? Ironsights
	bIronsights = !self.Weapon:GetDTBool(1)
	self:SetIronsights(bIronsights)

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
end

/*---------------------------------------------------------
   Name: SWEP:SetMode()
---------------------------------------------------------*/
function SWEP:SetMode(b)

	if (self.Owner) then
		if (b) then
			self.Primary.Automatic = true

			if (SERVER) then
				self.Owner:PrintMessage(HUD_PRINTTALK, self.data.ModeMsg)
			end

			local Animation = self.Owner:GetViewModel()
			Animation:SetSequence(Animation:LookupSequence("pistol2SMG"))
			Animation:SetPlaybackRate(1)
		else
			self.Primary.Automatic = false

			if (SERVER) then
				self.Owner:PrintMessage(HUD_PRINTTALK, self.data.NormalMsg)
			end

			local Animation = self.Owner:GetViewModel()
			Animation:SetSequence(Animation:LookupSequence("SMG2pistol"))
			Animation:SetPlaybackRate(1)
		end
	end

	self.Weapon:EmitSound("weapons/alyxgun/alyx_gun_switch_burst.wav")

	if (self.Weapon) then
		self.Weapon:SetDTBool(3, b)
	end
end

/*---------------------------------------------------------
   Name: SWEP:SecondThink()
   Desc: Called every frame. Use this function if you don't 
	   want to copy/past the think function everytime you 
	   create a new weapon with this base...
---------------------------------------------------------*/
function SWEP:SecondThink()

	if self.Weapon:GetDTBool(3) then
		self.ViewModelFOV = math.Approach(self.ViewModelFOV, 46, 0.2)
	else
		self.ViewModelFOV = math.Approach(self.ViewModelFOV, 52, 0.2)
	end
end

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()

	// When the weapon is already doing an animation, just return end because we don't want to interrupt it
	if (self.ActionDelay > CurTime()) then return end 

	// Need to call the default reload before the real reload animation (don't try to understand my reason)
//	self.Weapon:DefaultReload(ACT_VM_RELOAD)

	if (self.Weapon:Clip1() < self.Primary.ClipSize) and (self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self:SetIronsights(false)
		self:ReloadAnimation()

		timer.Simple(1.5, function() self.Owner:RemoveAmmo(self.Primary.ClipSize - self.Weapon:Clip1(), self.Weapon:GetPrimaryAmmoType()) self.Weapon:SetClip1(self.Primary.ClipSize) end)
		self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
		self.Weapon:SetNextSecondaryFire(CurTime() + 1.5)
		self.ActionDelay = CurTime() + 1.5
	end
end

/*---------------------------------------------------------
   Name: SWEP:ReloadAnimation()
---------------------------------------------------------*/
function SWEP:ReloadAnimation()

	if self.Weapon:GetDTBool(3) then
		local Animation = self.Owner:GetViewModel()
		Animation:SetSequence(Animation:LookupSequence("smg_reload"))
		Animation:SetPlaybackRate(1)

		self.Weapon:EmitSound("weapons/alyxgun/alyx_gun_reload1.wav")
	else
		local Animation = self.Owner:GetViewModel()
		Animation:SetSequence(Animation:LookupSequence("reload"))
		Animation:SetPlaybackRate(1)

		self.Weapon:EmitSound("weapons/alyxgun/alyx_gun_reload.wav")
	end
end

/*---------------------------------------------------------
   Name: SWEP:DeployAnimation()
---------------------------------------------------------*/
function SWEP:DeployAnimation()

	if self.Weapon:GetDTBool(3) then
		local Animation = self.Owner:GetViewModel()
		Animation:SetSequence(Animation:LookupSequence("smg_draw"))
		Animation:SetPlaybackRate(1)
	else
		local Animation = self.Owner:GetViewModel()
		Animation:SetSequence(Animation:LookupSequence("draw"))
		Animation:SetPlaybackRate(1)
	end
end

/*---------------------------------------------------------
   Name: SWEP:ShootAnimation()
---------------------------------------------------------*/
local ShootAccumulation = 0
function SWEP:ShootAnimation()

	if self.Weapon:GetDTBool(3) then
		if ShootAccumulation == 0 then
			local Animation = self.Owner:GetViewModel()
			Animation:SetSequence(Animation:LookupSequence("smg_fire"))
			Animation:SetPlaybackRate(1)

			ShootAccumulation = 1
		elseif ShootAccumulation == 1 then
			local Animation = self.Owner:GetViewModel()
			Animation:SetSequence(Animation:LookupSequence("smg_fire1"))
			Animation:SetPlaybackRate(1)

			ShootAccumulation = 0
		end
	else
		if ShootAccumulation == 0 then
			local Animation = self.Owner:GetViewModel()
			Animation:SetSequence(Animation:LookupSequence("fire"))
			Animation:SetPlaybackRate(1)

			ShootAccumulation = 1
		elseif ShootAccumulation == 1 then
			local Animation = self.Owner:GetViewModel()
			Animation:SetSequence(Animation:LookupSequence("fire1"))
			Animation:SetPlaybackRate(1)

			ShootAccumulation = 0
		end
	end
end