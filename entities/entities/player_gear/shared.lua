

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""

ENT.AutomaticFrameAdvance = true

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:SetupDataTables()
	self:DTVar("Int", 1, "bonenum");
	self:DTVar("Entity", 2, "ply");
	self:DTVar("Angle", 3, "angle");
	self:DTVar("Vector", 4, "offset");
end