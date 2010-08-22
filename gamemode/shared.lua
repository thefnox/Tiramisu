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

/*

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
		elseif ply:Armor() <= 5 and ply:Armor() > 1 then
			local effectdata = EffectData()
			effectdata:SetEntity( ply )
			util.Effect( "entity_remove", effectdata, true, true )
			ply:EmitSound( Sound( "physics/glass/glass_largesheet_break2.wav" ) )
		end
		
	end
	
	if SERVER then
		GAMEMODE:ScalePlayerDamage( ply, trace.HitGroup, dmginfo )
	end
	
 	return false
	
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf ) 
	
	local tbl = {}
	
	if ply.DamageProtection then
		local tbl = {}
		local ratio = 100
		if ply.DamageProtection.Weight == "light" then
			tbl = {
				"player/footsteps/concrete1.wav",
				"player/footsteps/concrete2.wav",
				"player/footsteps/concrete3.wav",
				"player/footsteps/concrete4.wav"
			}
		elseif ply.DamageProtection.Weight == "medium" or ply.DamageProtection.Weight == "heavy" then
			tbl = {
				"npc/footsteps/hardboot_generic1.wav",
				"npc/footsteps/hardboot_generic2.wav",
				"npc/footsteps/hardboot_generic3.wav",
				"npc/footsteps/hardboot_generic4.wav",
				"npc/footsteps/hardboot_generic5.wav",
				"npc/footsteps/hardboot_generic6.wav",
				"npc/footsteps/hardboot_generic8.wav"
			}
		elseif ply.DamageProtection.Weight == "superheavy" then
			tbl = {
				"npc/dog/dog_footstep1.wav",
				"npc/dog/dog_footstep2.wav",
				"npc/dog/dog_footstep3.wav",
				"npc/dog/dog_footstep4.wav"
			}
			ratio = 20
		end
		ply:EmitSound(table.Random( tbl ))
	else
		tbl = {
			"npc/footsteps/hardboot_generic1.wav",
			"npc/footsteps/hardboot_generic2.wav",
			"npc/footsteps/hardboot_generic3.wav",
			"npc/footsteps/hardboot_generic4.wav",
			"npc/footsteps/hardboot_generic5.wav",
			"npc/footsteps/hardboot_generic6.wav",
			"npc/footsteps/hardboot_generic8.wav"
		}
	ply:EmitSound(table.Random( tbl ), ratio)
	end
	return true 
	
 end
 */