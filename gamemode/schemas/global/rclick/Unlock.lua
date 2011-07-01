RCLICK.Name = "Unlock"

function RCLICK.Condition(target)

if ValidEntity( target) and CAKE.IsDoor(target) then return true end

end

function RCLICK.Click(target,ply)

ply:ConCommand("rp_unlockdoor " .. target:EntIndex())

end