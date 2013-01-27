local legs = {
	
	HITGROUP_LEFTLEG,
	HITGROUP_RIGHTLEG
	
	}

local translation = {
	
	[HITGROUP_LEFTLEG] = "Left Leg",
	[HITGROUP_RIGHTLEG] = "Right Leg"
	
	}

function LegDamage_EntityTakeDamage(ent, dmginfo)
	
	if !ent:IsPlayer() then return end
	
	local attacker = dmginfo:GetAttacker()
	local amount = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	local hitgroup = ent:LastHitGroup()
	
	if ent:Armor() != 0 then return end // they has armor, don't knock them out
	
	if table.HasValue(legs, hitgroup) then
		
		CAKE.CombatLog(Color(25, 25, 230), CAKE.GetCharSignature(ent) .. " has been hit in their \"" .. translation[hitgroup] .. "\"")
		CAKE.UnconciousMode(ent, 15, false)
		
	elseif dmginfo:IsFallDamage() then
		
		CAKE.CombatLog(Color(25, 25, 230), CAKE.GetCharSignature(ent) .. " has been hit in their \"Legs (falling damage)\"")
		CAKE.UnconciousMode(ent, 15, false)
		
	end
	
end
hook.Add("EntityTakeDamage", "LegDamage_ETD", LegDamage_EntityTakeDamage)