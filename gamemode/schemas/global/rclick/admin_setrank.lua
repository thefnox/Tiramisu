RCLICK.Name = "Set Rank"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.StringRequest( "Change a player's rank", "Choose which admin rank should " .. target:Nick() .. " have. Options:\n\tEvent Coordinator\n\tModerator\n\tAdministrator\n\tSuper Administrator", "", function( text )
		ply:ConCommand("rp_admin setrank \"" .. target:Nick() .. "\" \"" .. text .."\"")
	end,
	function() end, "Accept", "Cancel")

end