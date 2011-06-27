AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

function SWEP:Reload()
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
	if SERVER then
		if !self.Owner:GetNWBool( "arrested", false ) then
			local trace = self.Owner:GetEyeTrace( )
			if trace.StartPos:Distance( trace.HitPos ) < 150 and CAKE.UnArrestPlayer then
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