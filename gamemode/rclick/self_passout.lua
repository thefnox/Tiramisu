RCLICK.Name = "Pass Out"
RCLICK.SubMenu = "Actions"

function RCLICK.Condition(target)

	if target == LocalPlayer() then return true end

end

function RCLICK.Click(target,ply)

	
	RunConsoleCommand( "rp_passout" )

end