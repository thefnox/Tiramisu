meta = FindMetaTable( "Entity" )

function meta:IsTiraPlayer()
	if self.ply and !self.deathrag then
		return self.ply
	elseif self:IsPlayer() then
		return self
	else
		return false
	end
end