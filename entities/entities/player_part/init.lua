AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self:AddEffects( EF_BONEMERGE | EF_BONEMERGE_FASTCULL )
	self:SetSolid(SOLID_NONE)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	self:SetCollisionBounds( Vector(0, 0, 0), Vector(0, 0, 0) )
	local phy = self:GetPhysicsObject()
	if phy:IsValid() then
		phy:EnableCollisions(false)
		phy:EnableDrag(false)
		phy:SetMass( 0)
	end
	
	self:SetSequence( ACT_IDLE )

end

function ENT:OnTakeDamage()

end

function ENT:PhysicsCollide()

end