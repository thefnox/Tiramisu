PLUGIN.Name = "Damage Systems" -- What is the plugin name
PLUGIN.Author = "Big Bang" -- Author of the plugin
PLUGIN.Description = "Calculates damage and damage effects" -- The description or purpose of the plugin

--Calculates the protection ratio of an item.
function CAKE.CalculateShields( ply, item, helmet )
	
	if CAKE.ItemData[ item ] then
		if !ply.DamageProtection then
			ply.DamageProtection = {}
		end

		if ply:ItemHasFlag( item, "armor" ) then
			ply:SetArmor( ply:GetFlagValue( item, "armor" ) )
		else
			ply:SetArmor( 0 )
		end
		
		if ply:ItemHasFlag( item, "bulletarmor" ) then
			ply.DamageProtection.Bullets = tonumber( ply:GetFlagValue( item, "bulletarmor" ) )
		else
			ply.DamageProtection.Bullets = 1
		end
		
		if ply:ItemHasFlag( item, "explosivearmor" ) then
			ply.DamageProtection.Explosion = tonumber( ply:GetFlagValue( item, "explosivearmor" ) )
		else
			ply.DamageProtection.Explosion = 3
		end
		
		if ply:ItemHasFlag( item, "kineticarmor" ) then
			ply.DamageProtection.Kinetic = tonumber( ply:GetFlagValue( item, "kineticarmor" ) )
		else
			ply.DamageProtection.Kinetic = 1.5
		end
		
		if ply:ItemHasFlag( item, "fallprotection" ) then
			ply.DamageProtection.Fall = util.tobool( ply:GetFlagValue( item, "fallprotection" ) )
		else
			ply.DamageProtection.Fall = false
		end
		
		if ply:ItemHasFlag( item, "hazmat" ) then
			ply.DamageProtection.Hazmat = util.tobool( ply:GetFlagValue( item, "hazmat" ) )
		else
			ply.DamageProtection.Hazmat = false
		end
		
		if CAKE.ItemData[ helmet ] and ply:ItemHasFlag( helmet, "headprotection" ) then
			ply.DamageProtection.Head = tonumber( ply:GetFlagValue( helmet, "headprotection" ) )
		end
	else
		ply.DamageProtection = {}
	end
	
end

--Performs damage calculations for unshielded players.
function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

        // More damage if we're shot in the head
        if ( hitgroup == HITGROUP_HEAD ) then
			if ply.DamageProtection and ply.DamageProtection.Head then
				dmginfo:ScaleDamage( ply.DamageProtection.Head )
			else
                dmginfo:ScaleDamage( 3 )
			end
        end
         
		if ( hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM ) then		
			local randomchance = math.random( 1, 40 )
			if( randomchance == 5 ) then
				local wep = ply:GetActiveWeapon( )
				local class = wep:GetClass()
				if( class != "hands" and class != "gmod_tool" and class != "weapon_physcannon" and class != "weapon_physgun" ) then
					CAKE.DropWeapon( ply, class )
				end
			end
			dmginfo:ScaleDamage( 0.7 )
		end
		 
        // Less damage if we're shot in the arms or legs
        if ( hitgroup == HITGROUP_LEFTLEG || hitgroup == HITGROUP_LEFTLEG || hitgroup == HITGROUP_GEAR ) then
            dmginfo:ScaleDamage( 0.7 )
        end
		
		if dmginfo:GetDamageType() == DMG_BULLET or dmginfo:GetDamageType() == DMG_BUCKSHOT then
			dmginfo:ScaleDamage( ply.DamageProtection.Bullets or 1 )
		end
		
		if dmginfo:GetDamageType() == DMG_SLASH or dmginfo:GetDamageType() == DMG_CLUB or dmginfo:GetDamageType() == DMG_CRUSH then
			dmginfo:ScaleDamage( ply.DamageProtection.Kinetic or 1 )
		end
		
		if dmginfo:GetDamageType() == DMG_BURN or dmginfo:GetDamageType() == DMG_SHOCK or dmginfo:GetDamageType() == DMG_BLAST or dmginfo:GetDamageType() == DMG_DISSOLVE then
			dmginfo:ScaleDamage( ply.DamageProtection.Explosion or 1 )
		end
		
		if dmginfo:GetDamageType() == DMG_ACID or dmginfo:GetDamageType() == DMG_DIRECT or dmginfo:GetDamageType() == DMG_RADIATION or dmginfo:GetDamageType() == DMG_BURN then
			if ply.DamageProtection.Hazmat then
				dmginfo:ScaleDamage( 0 )
			else
				dmginfo:ScaleDamage( 1 )
			end
		end

end

function GM:GravGunPunt( ply, ent )
    return false --Useless for RP, so we disable gravity gun punting.
end

hook.Add( "PlayerSetModel", "TiramisuShieldCalc", function( ply )
	CAKE.CalculateShields( ply, CAKE.GetCharField( ply, "clothing" ), CAKE.GetCharField( ply, "helmet" ) )
end)

function PLUGIN.Init()
end