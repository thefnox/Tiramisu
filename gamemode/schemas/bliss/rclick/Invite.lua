RCLICK.Name = "Invite to my group"

function RCLICK.Condition(target)

	if target:IsPlayer() then
		if CAKE.MyGroup then
			if CAKE.MyGroup.RankPermissions[ "caninvite" ] then
				return true 
			end
		end
	end
	
end

function RCLICK.Click(target,ply)

	LocalPlayer():ConCommand("rp_sendinvite " .. target:Nick() );
	
end