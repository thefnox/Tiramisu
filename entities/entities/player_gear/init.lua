
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	if self:GetDTBool( 2 ) then
		self:AddEffects( bit.bor(bit.bor( EF_BONEMERGE, EF_BONEMERGE_FASTCULL ), EF_PARENT_ANIMATES ) )
	else
		self:AddEffects( EF_PARENT_ANIMATES )
	end
	self:SetSolid(SOLID_NONE)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionBounds( Vector(0, 0, 0), Vector(0, 0, 0) )

end

function ENT:OnTakeDamage()

end

function ENT:PhysicsCollide()

end