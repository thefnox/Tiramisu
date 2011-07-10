RCLICK.Name = "Set Default Title"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if CAKE.IsDoor( target ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.StringRequest( "Set Door's Default Title", "Enter which title should this door have by default", "Title", function( text )
		RunConsoleCommand( "rp_admin", "setdoortitle", target:EntIndex(), text )
	end,
	function() end, "Accept", "Cancel")

end