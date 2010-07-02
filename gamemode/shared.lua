-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- shared.lua
-- Some shared functions
-------------------------------

local DoorTypes =
{

	"func_door",
	"func_door_rotating",
	"prop_door_rotating"

}

function CAKE.IsDoor( door )

	local class = door:GetClass();
	
	for k, v in pairs( DoorTypes ) do
	
		if( v == class ) then return true; end
	
	end
	
	return false;

end

function GM:PlayerTraceAttack( ply, dmginfo, dir, trace ) 
	
	if CLIENT then
		local protectedhead = true
		if trace.HitGroup == HITGROUP_HEAD then
			if !ply:GetNWBool( "hashelmet", false ) then
				protectedhead = false
			end
		end
		
		if ply:Armor() > 5 and protectedhead then
			local effectdata = EffectData()
			effectdata:SetNormal( trace.HitNormal )
			effectdata:SetOrigin( trace.HitPos )
			util.Effect( "AR2Impact", effectdata )
			ply:SetBloodColor( -1 )
		elseif ply:Armor() <= 5 and ply:Armor() > 1 then
			local effectdata = EffectData()
			effectdata:SetEntity( ply )
			util.Effect( "entity_remove", effectdata, true, true )
			ply:EmitSound( Sound( "physics/glass/glass_largesheet_break2.wav" ) )
			ply:SetBloodColor( -1 )
		end
		
	end
	
	if SERVER then
		GAMEMODE:ScalePlayerDamage( ply, trace.HitGroup, dmginfo )
	end
	
 	return false
	
end