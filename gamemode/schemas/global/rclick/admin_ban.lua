RCLICK.Name = "Ban"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 2 then return true end

end

function RCLICK.Click(target,ply)

	local reason
	CAKE.StringRequest( "Ban A Player", "Give a reason to ban " .. target:Nick(), "Bye.", function( text )
		reason = text
		CAKE.StringRequest( "Ban A Player", "State for how long do you want to ban " .. target:Nick(), "1", function( minutes )
			ply:ConCommand("rp_admin ban " .. CAKE.FormatText(target:SteamID()) .. " \"" .. reason .. "\" " .. minutes )
		end,
		function() end, "Accept", "Cancel")
	end,
	function() end, "Accept", "Cancel")

end