AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.Entity:AddEffects( EF_BONEMERGE | EF_BONEMERGE_FASTCULL | EF_PARENT_ANIMATES )
	self:SetSolid(SOLID_NONE)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionBounds( Vector(0, 0, 0), Vector(0, 0, 0) )
end

function ENT:OnTakeDamage()

end

function ENT:PhysicsCollide()

end