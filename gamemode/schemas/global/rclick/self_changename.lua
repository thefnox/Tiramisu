RCLICK.Name = "Change Name"

function RCLICK.Condition(target)

	if target == LocalPlayer() then return true end

end

function RCLICK.Click(target,ply)

	
	CAKE.StringRequest( "Change Your Name", "Change your character's name to what?", ply:Nick(), function( text )
		RunConsoleCommand( "rp_changename", text )
	end,
	function() end, "Accept", "Cancel")

end