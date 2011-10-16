RCLICK.Name = "Set Model"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 1 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.StringRequest( "Change a player's model", "Select what model to set " .. target:Nick() .. " as (Will remove clothing)", target:GetModel(), function( text )
		ply:ConCommand("rp_admin setmodel \"" .. target:Nick() .. "\" \"" .. text .. "\"" )
	end,
	function() end, "Accept", "Cancel")

end