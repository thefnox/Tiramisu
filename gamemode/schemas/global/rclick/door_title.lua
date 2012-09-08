RCLICK.Name = "Set Door Title"
RCLICK.SubMenu = "Door"

function RCLICK.Condition(target)

if TIRA.IsDoor(target) then return true end

end

function RCLICK.Click(target,ply)

	Derma_StringRequest("Set Door Title", "Enter the title that you want for this door", ply:Nick() .. "'s Door", function(text) RunConsoleCommand("rp_doortitle", text) end)

end