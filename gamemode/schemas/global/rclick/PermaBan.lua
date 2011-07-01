RCLICK.Name = "Perma Ban"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	local reason
	CAKE.StringRequest( "Permanently Ban A Player", "Give a reason to permaban " .. target:Nick(), "Bye.", function( text )
		reason = text
		ply:ConCommand("rp_admin ban \"" .. target:Nick() .. "\" \"" .. reason .. "\" 0" )
	end,
	function() end, "Accept", "Cancel")

end