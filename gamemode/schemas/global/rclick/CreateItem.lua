RCLICK.Name = "Create Item"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if ( !target or target:IsWorld() ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)
 	
 	local tbl = {}

	for k, v in pairs( CAKE.ItemData ) do
		table.insert( tbl, v.Class )
	end

	CAKE.ChoiceRequest( "Create an item", "Choose what item to create", tbl,
	function( value )
		print( "rp_admin createitem  \"" .. value .. "\"" )
		ply:ConCommand("rp_admin createitem  \"" .. value .. "\"" )
	end,
	function() end, "Accept", "Cancel")

end