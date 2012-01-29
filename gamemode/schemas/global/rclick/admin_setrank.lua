RCLICK.Name = "Set Rank"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.StringRequest( "Change a player's rank", "Choose which admin rank should " .. target:Nick() .. " have. Options:\n\tPlayer (\"none\")\n\tEvent Coordinator (\"ec\")\n\tModerator (\"m\")\n\tAdministrator (\"a\")\n\tSuper Administrator (\"sa\")", "none",
	function( text )
		ply:ConCommand("rp_admin setrank " .. CAKE.FormatText(target:SteamID()) .. " " .. text)
		print("rp_admin setrank " .. CAKE.FormatText(target:SteamID()) .. " " .. text)
	end,
	function() end, "Accept", "Cancel")

end