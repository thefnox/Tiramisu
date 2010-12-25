include('shared.lua')

function ENT:Draw()

	if !gamemode.Call( "ShouldDrawLocalPlayer" ) then
		if GetViewEntity() == LocalPlayer() then
			return
		end
	end
	
	if self.Entity:GetParent():IsPlayer() then 
		self.Entity:SetEyeTarget( self.Entity:GetParent():GetEyeTrace().HitPos )
	end
	self.Entity:RemoveEffects(EF_ITEM_BLINK)
	self.Entity:DrawModel()
	self.Entity:DrawShadow( true )
	
end