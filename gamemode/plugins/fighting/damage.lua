hook.Add("PlayerShouldTakeDamage", "Tiramisu.PlayerShouldTakeDamage", function( ply, attacker )
	if ply.IsInvulnerable then
		return false
	end
	if IsValid( attacker ) then 
		if attacker:GetClass() == "prop_physics" then
			return CAKE.ConVars[ "Prop_Damage" ]
		end
	end
end)