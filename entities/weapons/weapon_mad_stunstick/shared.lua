// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_stunstick.mdl" 
SWEP.WorldModel			= "models/weapons/w_stunbaton.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Recoil		= 5
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 0.5

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "XBowBolt"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"				// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.RunArmOffset 		= Vector (0.3671, 0.1571, 5.7856)
SWEP.RunArmAngle	 		= Vector (-37.4833, 2.7476, 0)

SWEP.Sequence			= 0

SWEP.HoldType				= "knife"

SWEP.Hit = { 
    Sound( "weapons/stunstick/stunstick_impact1.wav" ),
    Sound( "weapons/stunstick/stunstick_impact2.wav" )
};
 
SWEP.FleshHit = {
    Sound( "weapons/stunstick/stunstick_fleshhit1.wav" ),
    Sound( "weapons/stunstick/stunstick_fleshhit2.wav")
};   

/*---------------------------------------------------------
   Name: SWEP:Precache()
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/stunstick/stunstick_impact1.wav")
    	util.PrecacheSound("weapons/stunstick/stunstick_impact2.wav")
    	util.PrecacheSound("weapons/stunstick/stunstick_fleshhit1.wav")
    	util.PrecacheSound("weapons/stunstick/stunstick_fleshhit2.wav")
    	util.PrecacheSound("weapons/stunstick/stunstick_swing1.wav")
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)

	self:IdleAnimation(1)

	return true
end

function SWEP:EntsInSphereBack(pos, range)

	local ents = ents.FindInSphere(pos, range)

	for k, v in pairs(ents) do
		if v ~= self and v ~= self.Owner and (v:IsNPC() or v:IsPlayer()) and ValidEntity(v) and self:EntityFaceBack(v) then
			return true
		end
	end

	return false
end

function SWEP:EntityFaceBack(ent)

	local angle = self.Owner:GetAngles().y - ent:GetAngles().y

	if angle < -180 then angle = 360 + angle end
	if angle <= 90 and angle >= -90 then return true end

	return false
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

	if self.Weapon:GetNetworkedBool("Holsted") or self.Owner:KeyDown(IN_SPEED) then return end

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 50)
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine(tr)

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if (trace.Hit) then
		if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			if trace.Entity:IsPlayer() then
				if SERVER then
					local randomchance = math.random( 1, 3 )
					if( randomchance == 4 ) then
						CAKE.UnconciousMode( trace.Entity )
					end
				end
			end
			if self:EntsInSphereBack(tr.endpos, 12) then
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
				local Animation = self.Owner:GetViewModel()
				Animation:SetSequence(Animation:LookupSequence("stab"))

				bullet = {}
				bullet.Num    = 1
				bullet.Src    = self.Owner:GetShootPos()
				bullet.Dir    = self.Owner:GetAimVector()
				bullet.Spread = Vector(0, 0, 0)
				bullet.Tracer = 0
				bullet.Force  = 1
				bullet.Damage = 100
				self.Owner:FireBullets(bullet)

				self.Weapon:EmitSound(self.FleshHit[math.random(1,#self.FleshHit)])
				self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
				self.Weapon:SetNextSecondaryFire(CurTime() + 1.5)

				return
			end

			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			local Animation = self.Owner:GetViewModel()
			Animation:SetSequence(Animation:LookupSequence("midslash" .. math.random(1, 2)))

			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 7
			self.Owner:FireBullets(bullet) 

			self.Weapon:EmitSound(self.Hit[math.random(1,#self.Hit)])
		else
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			local Animation = self.Owner:GetViewModel()
			Animation:SetSequence(Animation:LookupSequence("midslash" .. math.random(1, 2)))

			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 50
			self.Owner:FireBullets(bullet) 

			self.Weapon:EmitSound(self.Hit[math.random(1,#self.Hit)])
	
			--util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
		end
	else
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		local Animation = self.Owner:GetViewModel()
		Animation:SetSequence(Animation:LookupSequence("midslash" .. math.random(1, 2)))

		self.Weapon:EmitSound("Weapon_Knife.Slash" )
	end

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end

	self:IdleAnimation(1)
end