
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	if self:GetDTBool( 2 ) then
		self.Entity:AddEffects( EF_BONEMERGE | EF_BONEMERGE_FASTCULL )
	end
	self.Entity:AddEffects( EF_PARENT_ANIMATES )
	self:SetSolid(SOLID_NONE)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionBounds( Vector(0, 0, 0), Vector(0, 0, 0) )
	local phy = self:GetPhysicsObject()
	if phy:IsValid() then
		phy:AddGameFlag(PLAYER_HELD)
	end

end

function ENT:OnTakeDamage()

end

function ENT:PhysicsCollide()

end