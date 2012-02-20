RCLICK.Name = "Create New Faction"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

if target == LocalPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.BeginFactionCreation()

end