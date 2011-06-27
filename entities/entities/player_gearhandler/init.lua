AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self:SetSolid(SOLID_NONE)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup( COLLISION_GROUP_PUSHAWAY )
	self:SetCollisionBounds( Vector(0, 0, 0), Vector(0, 0, 0) )
	local phy = self:GetPhysicsObject()
	if phy:IsValid() then
		phy:EnableCollisions(false)
		phy:EnableDrag(false)
		phy:SetMass( 0)
		phy:Sleep()
	end

end

function ENT:OnTakeDamage()

end

function ENT:Touch( )

end

function ENT:StartTouch( )

end

function ENT:EndTouch( )

end

function ENT:PhysicsCollide()

end