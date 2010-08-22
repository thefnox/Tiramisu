

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""

ENT.AutomaticFrameAdvance = true

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:SetupDataTables()
	self:DTVar("Int", 1, "bonenum");
	self:DTVar("Entity", 1, "ply");
	self:DTVar("Angle", 1, "angle");
	self:DTVar("Vector", 1, "offset");
	self:DTVar("Vector", 2, "scale");
	self:DTVar("Bool", 1, "visible");
end