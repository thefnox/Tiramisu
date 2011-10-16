RCLICK.Name = "Use"

function RCLICK.Condition(target)

if ValidEntity( target) and target:GetClass() == "item_prop" and !CAKE.ItemData[target:GetNWString("Class")].Unusable then return true end

end

function RCLICK.Click(target,ply)

ply:ConCommand("rp_useitem " .. target:EntIndex())

end