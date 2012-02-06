include('shared.lua')

local parent
function ENT:Draw()

	parent = self.Entity:GetDTEntity( 1 )

	if ValidEntity( parent) then
		local position, angles = self.Entity:GetDTEntity( 1 ):GetBonePosition(self.Entity:GetDTInt(1))
		local newposition, newangles = LocalToWorld( self.Entity:GetDTVector(1), self.Entity:GetDTAngle(1), position, angles )
		self.Entity:SetPos(newposition)
		self.Entity:SetAngles(newangles)
		self.Entity:SetModelScale( self.Entity:GetDTVector(2) )
	end

	if !self.Entity:GetDTInt(1) or !parent then
		--no shirt, no pants, no service
		return
	end

	if !self.Entity:GetDTBool(1) then
		--If it is not meant to be drawn, don't draw it.
		return
	end

	if (parent == LocalPlayer() or self.Entity:GetParent() == LocalPlayer()) and !CAKE.ForceDraw then
		--If the body ain't visible neither should the gear item be.
		if !hook.Call("ShouldDrawLocalPlayer", GAMEMODE) then
			return
		--If it is attached to a head bone then hide it when the body is visible in first person
		elseif self.Entity:GetDTBool(3) and !CAKE.Thirdperson:GetBool() then
			return
		end
	end

	self.Entity:DrawModel()
	self.Entity:DrawShadow( false )
	
end


