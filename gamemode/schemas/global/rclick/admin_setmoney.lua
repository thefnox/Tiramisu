RCLICK.Name = "Set Money"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsTiraPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	target = target:IsTiraPlayer()

	TIRA.StringRequest( "Change a player's cash", "Choose how much cash should " .. target:Nick() .. " have", "0", function( text )
		ply:ConCommand("rp_admin setmoney " .. TIRA.FormatText(target:SteamID()) .. " "  .. text  )
	end,
	function() end, "Accept", "Cancel")

end