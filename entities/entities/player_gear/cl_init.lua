
include('shared.lua')

function ENT:Draw()


	self.Entity:DrawModel()
	self.Entity:DrawShadow( false )


end

function ENT:Think()
	local position, angles = self.Entity:GetDTEntity( 2 ):GetBonePosition(self.Entity:GetDTInt(1))
	local newposition, newangles = LocalToWorld( self.Entity:GetDTVector(4), self.Entity:GetDTAngle(3), position, angles )
	self.Entity:SetPos(newposition)
	self.Entity:SetAngles(newangles)
end



