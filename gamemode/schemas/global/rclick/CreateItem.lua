RCLICK.Name = "Create Item"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if ( !target or target:IsWorld() ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)
 	
 	local tbl = {}

	for k, v in ipairs( CAKE.ItemData ) do
		table.insert( tbl, k )
	end

	CAKE.ChoiceRequest( "Create an item", "Choose what item to create", tbl,
	function( text )
		RunConsoleCommand("rp_admin", "createitem", text )
	end,
	function() end, "Accept", "Cancel")

end