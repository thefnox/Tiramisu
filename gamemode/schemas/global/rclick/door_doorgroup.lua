RCLICK.Name = "Set Door Group"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if CAKE.IsDoor( target ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.StringRequest( "Set Door Group", "Enter which doorgroup to assign to this door", "0", function( text )
		RunConsoleCommand( "rp_admin", "setdoorgroup", target:EntIndex(), text )
	end,
	function() end, "Accept", "Cancel")

end