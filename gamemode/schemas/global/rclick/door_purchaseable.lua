RCLICK.Name = "Set Purchaseable"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if TIRA.IsDoor( target ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	TIRA.StringRequest( "Set Purchaseable Status", "Enter if this door should be purchaseable ( true or false )", "true", function( text )
		ply:ConCommand("rp_admin setdoorpurchaseable " .. target:EntIndex() .. " " .. text)
	end,
	function() end, "Accept", "Cancel")

end