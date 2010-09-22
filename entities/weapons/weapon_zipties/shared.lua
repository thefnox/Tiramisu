if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if ( CLIENT ) then
	SWEP.PrintName      = "Zipties"
	SWEP.Author    = "FNox"
	SWEP.Contact    = ""
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
end
 
SWEP.Spawnable      = true
SWEP.AdminSpawnable  = true
 
SWEP.ViewModel      = ""
SWEP.WorldModel   = ""
SWEP.HoldType = "normal"
 
SWEP.Primary.ClipSize      = 1
SWEP.Primary.DefaultClip    = 1
SWEP.Primary.Automatic    = false

SWEP.Secondary.ClipSize      = 0
SWEP.Secondary.DefaultClip    = 0

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if SERVER then
		if !self.Owner:GetNWBool( "arrested", false ) then
			local trace = self.Owner:GetEyeTrace( )
			if trace.StartPos:Distance( trace.HitPos ) < 150 then
				if trace.Entity:IsPlayer() then
					CAKE.ArrestPlayer( self.Owner, trace.Entity )
				elseif trace.Entity.ply and trace.Entity.ply:IsPlayer() then
					CAKE.ArrestPlayer( self.Owner, trace.Entity.ply )
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		if !self.Owner:GetNWBool( "arrested", false ) then
			local trace = self.Owner:GetEyeTrace( )
			if trace.StartPos:Distance( trace.HitPos ) < 150 then
				if trace.Entity:IsPlayer() then
					CAKE.UnArrestPlayer( self.Owner, trace.Entity )
				elseif trace.Entity.ply and trace.Entity.ply:IsPlayer() then
					CAKE.UnArrestPlayer( self.Owner, trace.Entity.ply )
				end
			end
		end
	end
end

function SWEP:Think()
end