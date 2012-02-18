RCLICK.Name = "Slay"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsTiraPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 2 then return true end

end

function RCLICK.Click(target,ply)

	target = target:IsTiraPlayer()

	ply:ConCommand("rp_admin slay \"" .. target:Nick() .. "\"" )

end