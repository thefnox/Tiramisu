
include('shared.lua')

local lolpos

function ENT:Draw()

	if !self.Entity:GetDTInt(1) or !self.Entity:GetDTEntity( 1 ) then
		--no shirt, no pants, no service
		return
	end

	if !self.Entity:GetDTBool(1) then
		return
	end

	if self.Entity:GetParent() == LocalPlayer() then
		if !CAKE.Thirdperson:GetBool() and !CAKE.MiddleDown then
			if !gamemode.Call( "ShouldDrawLocalPlayer" ) then
				return
			end
		end
	end
	self.Entity:DrawModel()
	self.Entity:DrawShadow( true )
	
end

function ENT:Think()
	if ValidEntity( self.Entity:GetParent() ) and ValidEntity( self.Entity:GetDTEntity( 1 ) ) then
		local position, angles = self.Entity:GetDTEntity( 1 ):GetBonePosition(self.Entity:GetDTInt(1))
		local newposition, newangles = LocalToWorld( self.Entity:GetDTVector(1), self.Entity:GetDTAngle(1), position, angles )
		self.Entity:SetPos(newposition)
		self.Entity:SetAngles(newangles)
		self.Entity:SetModelScale( self.Entity:GetDTVector(2) )
	end
end



