PLUGIN.Name = "Damage Systems"; -- What is the plugin name
PLUGIN.Author = "Big Bang"; -- Author of the plugin
PLUGIN.Description = "Calculates damage and damage effects"; -- The description or purpose of the plugin

local function ArmorLerp( ply )
	
	if ply:GetNWFloat( "armor", 0 ) > 0 then
		if( ply:Armor() < ply:GetNWFloat( "armor", 0 ) ) then
			timer.Simple( 0.1, function()
				ply:SetArmor( math.ceil( Lerp( 0.25, ply:Armor(), ply:GetNWFloat( "armor" ) ) ) )
				ArmorLerp( ply )
			end)
		else
			local effectdata = EffectData()
			effectdata:SetEntity( ply.Clothing )
			util.Effect( "effect_shieldrecharge", effectdata, true, true )
			ply:EmitSound( Sound( "npc/sniper/reload1.wav" ))
			ply:SetBloodColor( -1 )
		end
	end
	
end

--Performs clientside effects and the like.
function GM:PlayerTraceAttack( ply, dmginfo, dir, trace ) 
	
	
	if ply:Armor() > 5 then
		local effectdata = EffectData()
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetOrigin( trace.HitPos )
		util.Effect( "AR2Impact", effectdata )
		ply:SetBloodColor( -1 )
	elseif ply:Armor() <= 5 and ply:Armor() > 0 then
		local effectdata = EffectData()
        effectdata:SetEntity( ply.Clothing[1] )
        util.Effect( "effect_shieldrecharge", effectdata, true, true )
		ply:EmitSound( Sound( "physics/glass/glass_largesheet_break2.wav" ) )
		ply:SetBloodColor( -1 )
	else
	
		if ( SERVER ) then 
			GAMEMODE:ScalePlayerDamage( ply, trace.HitGroup, dmginfo )
		end
		
	end
	
 	return false
	
end

--Performs damage calculations for unshielded players.
function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

        // More damage if we're shot in the head
        if ( hitgroup == HITGROUP_HEAD ) then
			if( ply:GetNWBool( "hashelmet", false ) ) then
				dmginfo:ScaleDamage( 1 )
			else
                dmginfo:ScaleDamage( 3 )
			end
        end
         
		if ( hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM ) then		
			local randomchance = math.random( 1, 20 )
			if( randomchance == 5 ) then
				local wep = ply:GetActiveWeapon( )
				if( wep:GetClass() != "hands" and wep:GetClass() != "gmod_tool" and wep:GetClass() != "weapon_physcannon" and wep:GetClass() != "weapon_physgun" ) then
					CAKE.DropWeapon( ply, ply:GetActiveWeapon( ) )
				end
			end
			dmginfo:ScaleDamage( 0.5 )
		end
		 
        // Less damage if we're shot in the arms or legs
        if ( hitgroup == HITGROUP_LEFTLEG || hitgroup == HITGROUP_LEFTLEG || hitgroup == HITGROUP_GEAR ) then
            dmginfo:ScaleDamage( 0.5 )
        end

end

function GM:GravGunPunt( ply, ent )
    return false --Useless to RP
end

--Handles the actual damage done
local function Shielding( ent, inflictor, attacker, amount, dmginfo )
	
	if ent:IsPlayer() then
		if ent:Armor() > 5 then
			timer.Create( "armorrecharge" .. ent:Nick(), 5, 1, function()
				ArmorLerp( ent )
			end)
			ent:SetBloodColor( -1 )
			if( dmginfo:IsExplosionDamage() ) then
				dmginfo:ScaleDamage( 1.2 )
			elseif( dmginfo:IsBulletDamage() ) then
				dmginfo:ScaleDamage( 0.25 )
			end
			dmginfo:ScaleDamage( 0.25 )
			ent:SetArmor( ent:Armor() - dmginfo:GetDamage() )
			dmginfo:SetDamage( 0 )
		else
			ent:SetBloodColor( COLOR_RED )
			timer.Create( "armorrecharge" .. ent:Nick(), 20, 1, function()
				ArmorLerp( ent )
			end)
		end
	end
 
end
hook.Add( "EntityTakeDamage", "VoidShielding", Shielding )

function PLUGIN.Init()
end