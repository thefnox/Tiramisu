RCLICK.Name = "Own/Unown Door"

function RCLICK.Condition(target)

if CAKE.IsDoor(target) then return true end

end

function RCLICK.Click(target,ply)

ply:ConCommand("rp_purchasedoor " .. target:EntIndex())

end