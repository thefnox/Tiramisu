RCLICK.Name = "Own/Unown Door"
RCLICK.SubMenu = "Door"

function RCLICK.Condition(target)

if TIRA.IsDoor(target) then return true end

end

function RCLICK.Click(target,ply)

	RunConsoleCommand("rp_purchasedoor", target:EntIndex())

end