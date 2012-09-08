RCLICK.Name = "Tooltrust"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsTiraPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) >= 3 then return true end

end

function RCLICK.Click(target,ply)

	target = target:IsTiraPlayer()

	TIRA.Query( "Do you want to give " .. target:Nick() .. " tooltrust, or do you want to take it away?", "Tooltrust",
		"Give",	function() ply:ConCommand( "rp_admin tooltrust " .. TIRA.FormatText(target:SteamID()) .. " 1") end, 
		"Take",	function() ply:ConCommand( "rp_admin tooltrust " .. TIRA.FormatText(target:SteamID()) .. " 0") end, 
		"Cancel",       function() end )

end