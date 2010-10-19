--Okay! Right click has been pluginized! Now every element has it's own file.
RCLICK.Name = "Invite to my group"

function RCLICK.Condition(target) --The conditions necessary for this particular right click option to show up.

	if target:IsPlayer() then
		if CAKE.MyGroup then
			if CAKE.MyGroup.RankPermissions[ "caninvite" ] then
				return true 
			end
		end
	end
	
end

function RCLICK.Click(target,ply) --What happens when you click it.

	LocalPlayer():ConCommand("rp_sendinvite " .. target:Nick() );
	
end