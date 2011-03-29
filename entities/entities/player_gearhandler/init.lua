AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()

	--self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_NONE)
	--self.Entity:SetSolid( SOLID_NONE)
	
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then
		phys:EnableCollisions( false )
	end
	
end

function ENT:Touch( hitEnt )
   
end