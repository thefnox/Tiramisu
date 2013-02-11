RCLICK.Name = "Unlock"
RCLICK.SubMenu = "Door"

function RCLICK.Condition(target)

if IsValid( target) and CAKE.IsDoor(target) then return true end

end

function RCLICK.Click(target,ply)

ply:ConCommand("rp_unlockdoor " .. target:EntIndex())

end