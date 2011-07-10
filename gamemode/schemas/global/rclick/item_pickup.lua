RCLICK.Name = "Pick Up"

function RCLICK.Condition(target)

if ValidEntity( target) and target:GetClass() == "item_prop" then return true end

end

function RCLICK.Click(target,ply)

	ply:ConCommand("rp_pickup " .. target:EntIndex())

end