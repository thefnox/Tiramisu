RCLICK.Name = "Create New Group"
RCLICK.SubMenu = "Groups"

function RCLICK.Condition(target)

if target == LocalPlayer() then return true end

end

function RCLICK.Click(target,ply)

	CAKE.BeginGroupCreation()

end