PLUGIN.Name = "Damage Systems"; -- What is the plugin name
PLUGIN.Author = "Big Bang"; -- Author of the plugin
PLUGIN.Description = "Calculates damage and damage effects"; -- The description or purpose of the plugin

function CAKE.CalculateShields( ply, item )
	--deprecated, may be used later
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
			local randomchance = math.random( 1, 40 )
			if( randomchance == 5 ) then
				local wep = ply:GetActiveWeapon( )
				if( wep:GetClass() != "hands" and wep:GetClass() != "gmod_tool" and wep:GetClass() != "weapon_physcannon" and wep:GetClass() != "weapon_physgun" ) then
					CAKE.DropWeapon( ply, ply:GetActiveWeapon( ) )
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
    return false --Useless to RP
end

function PLUGIN.Init()
end