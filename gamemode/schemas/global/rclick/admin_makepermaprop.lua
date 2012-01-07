RCLICK.Name = "Make Permanent"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if ValidEntity( target) and !target:GetNWBool("permaprop",false) and target:GetClass() == "prop_physics" and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 0 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.Query( "Make this prop permanent?\n(If permanent, the prop will be unremoveable, unphysable and will stay through map resets\nuntil set to non permanent by an admin)", "Confirm",
		"Yes",	function() ply:ConCommand("rp_admin addpermaprop " .. target:EntIndex()) end, 
		"No",	function() end )

end