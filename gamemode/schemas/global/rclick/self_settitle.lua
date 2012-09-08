RCLICK.Name = "Change Title"
RCLICK.SubMenu = "Settings"

function RCLICK.Condition(target)

	if target == LocalPlayer() then return true end

end

function RCLICK.Click(target,ply)

	
	TIRA.StringRequest( "Change Your Title", "Change your title to what?", ply:Title(), function( text )
		RunConsoleCommand( "rp_title", text )
	end,
	function() end, "Accept", "Cancel")

end