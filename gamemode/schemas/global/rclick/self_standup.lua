RCLICK.Name = "Stand Up"

function RCLICK.Condition(target)

	if target == LocalPlayer() and (target:GetNWBool( "sittingground", false ) or target:GetNWBool( "sittingchair", false )) then return true end

end

function RCLICK.Click(target,ply)
	RunConsoleCommand( "rp_stand" )
end