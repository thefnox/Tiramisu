ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""

ENT.AutomaticFrameAdvance = true

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:SetupDataTables()
	self:DTVar("Int", 1, "type");
	self:DTVar("Int", 2, "index" );
	self:DTVar("Int", 3, "headratio" );
end

function ENT:Think()
	
	if ValidEntity( self:GetParent() ) and self:GetParent():IsPlayer() then
		if self:GetParent().CalcIdeal then
			self:SetSequence( self:GetParent().CalcIdeal )
		end
	end

end