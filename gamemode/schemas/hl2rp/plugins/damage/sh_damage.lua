local bad_dmg_types = {
	
	DMG_CRUSH,
	DMG_CLUB,
	DMG_SLASH
	
	}

local translation = {
	
	[DMG_CRUSH] = "Crush Damage",
	[DMG_CLUB] = "Club Damage",
	[DMG_SLASH] = "Slash Damage"
	
	}

function Damage_EntityTakeDamage(ent, dmginfo)
	
	if !ent:IsPlayer() then return end
	
	local attacker = dmginfo:GetAttacker()
	local amount = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	
	if table.HasValue(bad_dmg_types, dmgtype) then
		
		if ent:Health() >= 60 then return end // they're health enough to sustain it
		if ent:Armor() != 0 then return end // they has armor, don't knock them out
		
		local chance = math.random(1, 3) == 2
		
		if !chance then return end // not lucky enough, sorry
		
		CAKE.DayLog("combat.txt", CAKE.GetCharSignature(ent) .. " has been knocked out by \"" .. translation[dmgtype] .. "\"")
		CAKE.UnconciousMode(ent)
		
	end
	
end
hook.Add("EntityTakeDamage", "Damage_ETD", Damage_EntityTakeDamage)