RCLICK.Name = "Sit Down"
RCLICK.SubMenu = "Actions"

function RCLICK.Condition(target)

	if target == LocalPlayer() and !target:GetNWBool( "sittingground", false ) then return true end

end

function RCLICK.Click(target,ply)
	RunConsoleCommand( "rp_sit" )
end