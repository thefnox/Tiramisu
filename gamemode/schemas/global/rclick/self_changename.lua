RCLICK.Name = "Change Name"
RCLICK.SubMenu = "Settings"

function RCLICK.Condition(target)

	if target == LocalPlayer() then return true end

end

function RCLICK.Click(target,ply)

	
	TIRA.StringRequest( "Change Your Name", "Change your character's name to what?", ply:Nick(), function( text )
		RunConsoleCommand( "rp_changename", text )
	end,
	function() end, "Accept", "Cancel")

end