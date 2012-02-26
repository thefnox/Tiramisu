CAKE.AddVoiceGroup( "Combine", function( ply )
	if ValidEntity(ply) and ply:IsPlayer() and ply:IsCharLoaded() then
		if CLIENT then
			if CAKE.ItemData[CAKE.Helmet] and CAKE.ItemData[CAKE.Helmet].IsCombine then
				return true
			end
		else
			if CAKE.ItemData[CAKE.GetCharField(ply, "helmet")] and CAKE.ItemData[CAKE.GetCharField(ply, "helmet")].IsCombine then
				return true
			end
		end
	end
	return false
end )

CAKE.AddVoiceGroup( "Vortigaunt", function( ply )
	if ValidEntity(ply) and ply:IsPlayer() and ply:IsCharLoaded() then
		if string.lower(ply:GetModel()) == "models/vortigaunt.mdl" then
			return true
		end
	end
	return false
end )