--[[ include('shared.lua')

function ENT:Draw()
	
	self:DrawEntityOutline(0.0)
	self.Entity:DrawModel()

end ]]

include('shared.lua')
 
GAMEMODE.haloEnts = GAMEMODE.haloEnts or {}

--hook.Add( "PreDrawHalos", "DrawPropHalos", function( )
--	halo.Add( GAMEMODE.haloEnts, Color( 0, 0, 255 ), 2, 2, 1, true, false )
--end )

function ENT:Initialize( )
	self.haloIndex = table.insert( GAMEMODE.haloEnts, self.Entity )
end

function ENT:OnRemove( )
	table.remove( GAMEMODE.haloEnts, self.haloIndex )
end

 function ENT:Draw()
 	
	-- self:DrawEntityOutline(0.0)
 	self.Entity:DrawModel()
 
 end