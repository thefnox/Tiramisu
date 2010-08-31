AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.Entity:AddEffects( EF_BONEMERGE | EF_BONEMERGE_FASTCULL | EF_PARENT_ANIMATES )
end

