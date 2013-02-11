RCLICK.Name = "Noclip"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if ( !target or target:IsWorld() ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 0 then return true end

end

function RCLICK.Click(target,ply)
 	
	ply:ConCommand("rp_admin noclip" )

end