RCLICK.Name = "Use"

function RCLICK.Condition(target)

if target:GetClass() == "item_prop" then return true end

end

function RCLICK.Click(target,ply)

ply:ConCommand("rp_useitem " .. target:EntIndex())

end