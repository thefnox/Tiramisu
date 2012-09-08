RCLICK.Name = "Remove Permanent Status"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if ValidEntity( target) and target:GetNWBool("permaprop",false) and target:GetClass() == "prop_physics" and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 0 then return true end

end

function RCLICK.Click(target,ply)

	TIRA.Query( "Remove permanent status on this prop?", "Confirm",
		"Yes",	function() ply:ConCommand("rp_admin removepermaprop " .. target:EntIndex()) end, 
		"No",	function() end )

end