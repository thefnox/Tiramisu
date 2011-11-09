RCLICK.Name = "Go To"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if ( !target or target:IsWorld() ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 2 then return true end

end

function RCLICK.Click(target,ply)
 	
 	local tbl = {}

	for k, v in ipairs( player.GetAll() ) do
		table.insert( tbl, v:Nick() )
	end

	CAKE.ChoiceRequest( "Go to a player", "Choose what player to go to", tbl,
	function( text )
		ply:ConCommand("rp_admin goto \""  .. text .. "\"" )
	end,
	function() end, "Accept", "Cancel")

end