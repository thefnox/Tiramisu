// Variables that are used on both client and server

local Automatic 			= CreateConVar ("mad_admin_automatic", "true", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local PrimarySound		= CreateConVar ("mad_admin_sound", "NPC_Sniper.FireBullet", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local Shell				= CreateConVar ("mad_admin_shell", "effect_mad_shell_pistol", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local Recoil 			= CreateConVar ("mad_admin_recoil", "0.1", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local Damage 			= CreateConVar ("mad_admin_damage", "100", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local NumShots 			= CreateConVar ("mad_admin_numshots", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local Cone	 			= CreateConVar ("mad_admin_cone", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local Delay				= CreateConVar ("mad_admin_delay", "0.1", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local MaxRicochet 		= CreateConVar ("mad_admin_maxricochet", "10", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local ScopeZooms			= CreateConVar ("mad_admin_scopezooms", "8", {FCVAR_REPLICATED, FCVAR_ARCHIVE})

SWEP.Base 				= "weapon_mad_base_sniper"

SWEP.ViewModel			= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Primary.Sound 		= Sound("NPC_Sniper.FireBullet")
SWEP.Primary.Recoil		= 0.1
SWEP.Primary.Damage		= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay 		= 0.1

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "effect_mad_shell_pistol"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= false
SWEP.Rifle				= false
SWEP.Shotgun			= true
SWEP.Sniper				= true

SWEP.HoldType				= "ar2"

SWEP.IronSightsPos 		= Vector (-8.9761, -46.3924, 4.0769)
SWEP.IronSightsAng 		= Vector (0, 0, 0)
SWEP.RunArmOffset 		= Vector (3, 0, 2.5)
SWEP.RunArmAngle 			= Vector (-13, 27, 0)

SWEP.Penetration			= true
SWEP.MaxPenetration 		= 256
SWEP.MaxWoodPenetration 	= 256
SWEP.Ricochet			= true
SWEP.MaxRicochet			= 10

SWEP.ScopeZooms			= {8}

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("npc/sniper/echo1.wav")
end

/*---------------------------------------------------------
   Name: SWEP:AdminCommands()
---------------------------------------------------------*/
function SWEP:AdminCommands()

	self.Primary.Automatic 	= Automatic:GetBool()
	self.Primary.Sound 	= Sound(PrimarySound:GetString())
	self.ShellEffect 		= Shell:GetString()
	self.Primary.Recoil 	= Recoil:GetFloat()
	self.Primary.Damage 	= Damage:GetFloat()
	self.Primary.NumShots 	= NumShots:GetFloat()
	self.Primary.Cone		= Cone:GetFloat()
	self.Primary.Delay	= Delay:GetFloat()
	self.MaxRicochet		= MaxRicochet:GetFloat()
	self.ScopeZooms		= {ScopeZooms:GetFloat()}
end

/*---------------------------------------------------------
   Name: SWEP:SecondThink()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:SecondThink()

	self:AdminCommands()
end

/*---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack()
   Desc: Helper function for checking for no ammo.
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()

	if (not self.Owner:IsNPC()) and (self.Owner:KeyDown(IN_SPEED)) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	return true
end

/*---------------------------------------------------------
   Name: SWEP:CanSecondaryAttack()
   Desc: Helper function for checking for no ammo.
---------------------------------------------------------*/
function SWEP:CanSecondaryAttack()

	if (not self.Owner:IsNPC()) and (self.Owner:KeyDown(IN_SPEED)) then
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		return false
	end

	return true
end