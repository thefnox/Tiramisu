TIRA.AddVoiceGroup( "Combine", function( ply )
	if ValidEntity(ply) and ply:IsPlayer() and ply:IsCharLoaded() then
		if CLIENT then
			if TIRA.ItemData[TIRA.Helmet] and TIRA.ItemData[TIRA.Helmet].IsCombine then
				return true
			end
		else
			if TIRA.ItemData[TIRA.GetCharField(ply, "helmet")] and TIRA.ItemData[TIRA.GetCharField(ply, "helmet")].IsCombine then
				return true
			end
		end
	end
	return false
end )

TIRA.AddVoiceGroup( "Vortigaunt", function( ply )
	if ValidEntity(ply) and ply:IsPlayer() and ply:IsCharLoaded() then
		if string.lower(ply:GetModel()) == "models/vortigaunt.mdl" then
			return true
		end
	end
	return false
end )