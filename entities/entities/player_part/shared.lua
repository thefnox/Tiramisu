ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""

ENT.AutomaticFrameAdvance = true

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:SetupDataTables()
	self:DTVar("Int", 1, "type")
	self:DTVar("Int", 2, "index" )
	self:DTVar("Float", 1, "headratio" )
	self:DTVar("Float", 2, "bodyratio" )
	self:DTVar("Float", 3, "handratio" )
end

function ENT:PhysicsCollide()

end

function ENT:Think()

end