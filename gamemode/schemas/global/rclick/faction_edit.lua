RCLICK.Name = "Edit"
RCLICK.SubMenu = "Faction"

function RCLICK.Condition(target)

if target == LocalPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 and table.Count(TIRA.Factions) > 0 then return true end

end

function RCLICK.Click(target,ply)

	timer.Simple( 0, function() --This timer is so the system can close down the previous DermaMenu without closing this one too
		local dmenu = DermaMenu()
		local main = dmenu:AddSubMenu( "Edit" )

		for faction, uid in pairs( TIRA.Factions ) do
			main:AddOption(faction, function() RunConsoleCommand("rp_editfaction", uid) end)
		end
		dmenu:Open()
	end)

end