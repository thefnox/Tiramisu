include('shared.lua')

function ENT:Draw()
	
	self:DrawEntityOutline(0.0)
	self.Entity:DrawModel()

end