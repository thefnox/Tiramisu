RCLICK.Name = "Set Rank"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.ChoiceRequest( "Change a player's rank", "Choose which admin rank should " .. target:Nick() .. " have", {
		"Event Coordinator",
		"Moderator",
		"Administrator",
		"Super Administrator"
	},
	function( text )
		ply:ConCommand("rp_admin setrank \"" .. target:Nick() .. "\" \"" .. text .."\"")
	end,
	function() end, "Accept", "Cancel")

end