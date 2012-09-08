RCLICK.Name = "Perma Ban"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsTiraPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	target = target:IsTiraPlayer()
	TIRA.StringRequest( "Permanently Ban A Player", "Give a reason to permaban " .. target:Nick(), "Bye.", function( text )
		ply:ConCommand("rp_admin ban " .. TIRA.FormatText(target:SteamID()) .. " \"" .. reason .. "\" 0" )
	end,
	function() end, "Accept", "Cancel")

end