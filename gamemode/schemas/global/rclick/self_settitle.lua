RCLICK.Name = "Change Title"

function RCLICK.Condition(target)

	if target == LocalPlayer() then return true end

end

function RCLICK.Click(target,ply)

	
	CAKE.StringRequest( "Change Your Title", "Change your title to what?", ply:GetNWString( "title", "" ), function( text )
		RunConsoleCommand( "rp_title", text )
	end,
	function() end, "Accept", "Cancel")

end