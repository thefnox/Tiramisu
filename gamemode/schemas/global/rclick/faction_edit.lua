RCLICK.Name = "Edit Faction"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

if target == LocalPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 and table.Count(CAKE.Factions) > 0 then return true end

end

function RCLICK.Click(target,ply)

	timer.Simple( 0, function() --This timer is so the system can close down the previous DermaMenu without closing this one too
		local dmenu = DermaMenu()
		local main = dmenu:AddSubMenu( "Edit Faction" )

		for faction, uid in pairs( CAKE.Factions ) do
			main:AddOption(faction, function() RunConsoleCommand("rp_editfaction", uid) end)
		end
		dmenu:Open()
	end)

end