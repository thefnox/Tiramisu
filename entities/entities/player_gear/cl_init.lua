include('shared.lua')

local parent
function ENT:Draw()

	--if !self:GetParent() then return end //We don't want no orphans here

	local position, angles = self:GetDTEntity(1):GetBonePosition(self:GetDTInt(1))
	local newposition, newangles = LocalToWorld( self:GetDTVector(1), self:GetDTAngle(1), position, angles )
	self:SetPos(newposition)
	self:SetAngles(newangles)
	local mat = Matrix()
	mat:Scale(self:GetDTVector(2))
	self:EnableMatrix( "RenderMultiply", mat )

	if !self:GetDTBool(1) then
		--If it is not meant to be drawn, don't draw it.
		return
	end

	if self:GetDTEntity(1) == LocalPlayer() and !CAKE.ForceDraw then
		--If the body ain't visible neither should the gear item be.
		if !hook.Call("ShouldDrawLocalPlayer", GAMEMODE) then
			return
		--If it is attached to a head bone then hide it when the body is visible in first person
		elseif self:GetDTBool(3) and !CAKE.Thirdperson:GetBool() then
			return
		end
	end

	self:DrawModel()
	self:DrawShadow( false )
	
end


