RCLICK.Name = "Set OOC Delay"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if ( !target or target:IsWorld() ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 0 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.StringRequest( "Set OOC delay", "Set OOC delay to how many seconds", "10", function( text )
		ply:ConCommand("rp_admin oocdelay " .. text )
	end,
	function() end, "Accept", "Cancel")

end