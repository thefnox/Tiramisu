RCLICK.Name = "Open"

function RCLICK.Condition(target)
	if IsValid( target) and target:GetNWString("container", "") != "" and target:GetClass() == "prop_physics" then return true end
end

function RCLICK.Click(target,ply)
	RunConsoleCommand("rp_opencontainer", target:GetNWString("container", ""))
end 