RCLICK.Name = "Create"
RCLICK.SubMenu = "Faction"

function RCLICK.Condition(target)

if target == LocalPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.BeginFactionCreation()

end