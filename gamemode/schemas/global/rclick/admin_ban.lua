RCLICK.Name = "Ban"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsTiraPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 2 then return true end

end

function RCLICK.Click(target,ply)

	target = target:IsTiraPlayer()
	local reason
	TIRA.StringRequest( "Ban A Player", "Give a reason to ban " .. target:Nick(), "Bye.", function( text )
		reason = text
		TIRA.StringRequest( "Ban A Player", "State for how long do you want to ban " .. target:Nick(), "1", function( minutes )
			ply:ConCommand("rp_admin ban " .. TIRA.FormatText(target:SteamID()) .. " \"" .. reason .. "\" " .. minutes )
		end,
		function() end, "Accept", "Cancel")
	end,
	function() end, "Accept", "Cancel")

end