hook.Add("PlayerShouldTakeDamage", "Tiramisu.PlayerShouldTakeDamage", function( ply, attacker )
	if ply.IsInvulnerable then
		return false
	end
	if ValidEntity( attacker ) then 
		if attacker:GetClass() == "prop_physics" then
			return TIRA.ConVars[ "Prop_Damage" ]
		end
	end
end)