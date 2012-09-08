RCLICK.Name = "Assign Building"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if TIRA.IsDoor( target ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	TIRA.StringRequest( "Assign to Building", "Enter which building enumeration to assign to this door (All doors with the same building enumeration will be bought when one of them is purchased)", "0", function( text )
		ply:ConCommand("rp_admin setdoorbuilding " .. target:EntIndex() .. " " .. text)
	end,
	function() end, "Accept", "Cancel")

end