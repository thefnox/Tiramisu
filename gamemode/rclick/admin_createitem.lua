RCLICK.Name = "Create Item"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if ( !target or target:IsWorld() ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.StringRequest( "Spawn an item", "Enter the class name of the item to create (Enter nothing to have the list of items sent to your console)", "", function( text )
		ply:ConCommand("rp_admin createitem \"" .. text .. "\"")
	end,
	function() end, "Accept", "Cancel")

end