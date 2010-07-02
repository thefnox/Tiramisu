PLUGIN.Name = "Damage Systems"; -- What is the plugin name
PLUGIN.Author = "Big Bang"; -- Author of the plugin
PLUGIN.Description = "Calculates damage and damage effects"; -- The description or purpose of the plugin

function CAKE.CalculateShields( ply, item )
	
		if ply:ItemHasFlag( item, "armor" ) then
			ply:SetNWFloat( "armor", tonumber( ply:GetFlagValue( item, "armor" ) ) )
			ply:SetArmor( ply:GetFlagValue( item, "armor" ) )
		else
			ply:SetNWFloat( "armor", 0)
			ply:SetArmor( 0 )
		end
		
		if ply:ItemHasFlag( item, "shieldratio" ) then
			ply.DamageProtection.Shield = tonumber( ply:GetFlagValue( item, "shieldratio" ) )
		else
			ply.DamageProtection.Shield = 0.7
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
		
		if ply:ItemHasFlag( item, "rigweight" ) then
			ply.DamageProtection.Weight = ply:GetFlagValue( item, "rigweight" )
		else
			ply.DamageProtection.Weight = "light"
			ply:SetWalkSpeed( CAKE.ConVars[ "WalkSpeed" ] )
			ply:SetRunSpeed( CAKE.ConVars[ "RunSpeed" ] )
		end
		
		if ply.DamageProtection.Weight == "heavy" then
			ply:SetWalkSpeed( CAKE.ConVars[ "WalkSpeed" ] - 30 )
			ply:SetRunSpeed( CAKE.ConVars[ "RunSpeed" ] - 75 )
		elseif ply.DamageProtection.Weight == "superheavy" then
			ply:SetWalkSpeed( CAKE.ConVars[ "WalkSpeed" ] -70 )
			ply:SetRunSpeed( CAKE.ConVars[ "RunSpeed" ] - 105)
		else
			ply:SetWalkSpeed( CAKE.ConVars[ "WalkSpeed" ])
			ply:SetRunSpeed( CAKE.ConVars[ "RunSpeed" ])
		end
		
end

local function ArmorLerp( ply )
	
	if ply:GetNWFloat( "armor", 0 ) > 0 then
		if( ply:Armor() < ply:GetNWFloat( "armor", 0 ) ) then
			timer.Simple( 0.1, function()
				ply:SetArmor( math.ceil( Lerp( 0.05, ply:Armor(), ply:GetNWFloat( "armor" ) ) ) )
				ArmorLerp( ply )
			end)
		else
			local effectdata = EffectData()
			effectdata:SetEntity( ply.Clothing )
			local discharge = ents.Create("point_tesla")
			discharge:SetPos(ply:GetPos() + Vector( 0, 30, 0 ))
			discharge:SetKeyValue("texture", "trails/laser.vmt")
			discharge:SetKeyValue("m_Color", "255 255 255")
			discharge:SetKeyValue("m_flRadius", "200" )
			discharge:SetKeyValue("interval_min", "0.3" )
			discharge:SetKeyValue("interval_max", "0.4" )
			discharge:SetKeyValue("beamcount_min", "6" )
			discharge:SetKeyValue("beamcount_max", "10" )
			discharge:SetKeyValue("thick_min", "0.75" )
			discharge:SetKeyValue("thick_max", "0.75")
			discharge:SetKeyValue("lifetime_min", "0.05" )
			discharge:SetKeyValue("lifetime_max", "0.1")
			discharge:Fire("DoSpark", "", 1)
			discharge:Fire("TurnOn", "", 1)
			ply:EmitSound( Sound( "npc/sniper/reload1.wav" ))
			ply:SetBloodColor( -1 )
			timer.Simple( 0.6, function()
				discharge:Fire("Kill", "", 0)
			end)
		end
	end
	
end

function GM:GetFallDamage( ply, speed )
	
	local damagemultiplier = 1
	
	if ply.DamageProtection.Weight then
		if ply.DamageProtection.Weight == "medium" then
			damagemultiplier = 2
		elseif ply.DamageProtection.Weight == "heavy" then
			damagemultiplier = 3
		elseif ply.DamageProtection.Weight == "superheavy" then
			damagemultiplier = 4
		end
		if ply.DamageProtection.Fall then
			damagemultiplier = 0
		end
	end
	
	local damage = ( speed / 16 ) * damagemultiplier
	
	if damage > 10 then
		return damage
	else
		return 0
	end
 
 
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

--Handles the actual damage done
local function Shielding( ent, inflictor, attacker, amount, dmginfo )
	
	if ent:IsPlayer() then
		local shieldratio = ent.DamageProtection.Shield or 0.7
		if ent:Armor() > 5 and dmginfo:GetDamageType() != DMG_FALL then
			timer.Create( "armorrecharge" .. ent:Nick(), 5, 1, function()
				ArmorLerp( ent )
			end)
			ent:SetBloodColor( -1 )
			dmginfo:ScaleDamage( shieldratio )
			ent:SetArmor( ent:Armor() - dmginfo:GetDamage() )
			dmginfo:SetDamage( 0 )
		elseif dmginfo:GetDamageType() == DMG_FALL then
		else
			ent:SetBloodColor( COLOR_RED )
			local seconds = 20
			if ent.DamageProtection.Weight == "light" then
				seconds = 7
			elseif ent.DamageProtection.Weight == "medium" then
				seconds = 12
			elseif ent.DamageProtection.Weight == "heavy" then
				seconds = 20
			elseif ent.DamageProtection.Weight == "superheavy" then
				seconds = 30
			end
			if ent:GetNWFloat( "armor", 0 ) > 0 then 
				timer.Create( "armorrecharge" .. ent:Nick(), seconds, 1, function()
					ArmorLerp( ent )
				end)
			end
		end
	end
 
end
hook.Add( "EntityTakeDamage", "VoidShielding", Shielding )

function PLUGIN.Init()
end