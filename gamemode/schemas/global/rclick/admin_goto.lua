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

	TIRA.ChoiceRequest( "Go to a player", "Choose what player to go to", tbl,
	function( text )
		if TIRA.FindPlayer(text) then
			ply:ConCommand("rp_admin goto \""  .. text .. "\"" )
		end
	end,
	function() end, "Accept", "Cancel")

end