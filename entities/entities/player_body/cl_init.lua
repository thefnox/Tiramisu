include('shared.lua')

function ENT:Draw()

	if self.Entity:GetParent() == LocalPlayer() then
		if !CAKE.Thirdperson:GetBool() and !CAKE.MiddleDown then
			if !gamemode.Call( "ShouldDrawLocalPlayer" ) then
				return
			end
		end
	end
	
	if self.Entity:GetParent():IsPlayer() then 
		self.Entity:SetEyeTarget( self.Entity:GetParent():GetEyeTrace().HitPos )
	end
	self.Entity:RemoveEffects(EF_ITEM_BLINK)
	self.Entity:DrawModel()
	self.Entity:DrawShadow( true )
	
end