RCLICK.Name = "Write A Note"
RCLICK.SubMenu = "Create"

function RCLICK.Condition(target)

	if target == LocalPlayer() then return true end

end

function RCLICK.Click(target,ply)
	RunConsoleCommand( "rp_write" )
end