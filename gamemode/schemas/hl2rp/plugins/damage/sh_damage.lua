// Made by VorteX
// For Tiramisu

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
		
		CAKE.DayLog("combat.txt", CAKE.GetCharSignature(ent) .. " has been hit with \"" .. translation[dmgtype] .. "\"")
		CAKE.UnconciousMode(ent)
		
	end
	
end
hook.Add("EntityTakeDamage", "Damage_ETD", Damage_EntityTakeDamage)