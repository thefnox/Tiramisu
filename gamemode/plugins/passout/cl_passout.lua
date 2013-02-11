usermessage.Hook( "Tiramisu.PlayerRagged", function(data)
		ply = data:ReadEntity()
		rag = data:ReadEntity()
		
		ply.rag = rag
		rag.ply = ply
end)

local uncbutton
usermessage.Hook( "Tiramisu.DisplayWakeUpButton", function(um)
	if um:ReadBool() then
		gui.EnableScreenClicker( true )
		uncbutton = vgui.Create( "DButton" )
		uncbutton:SetText( "Wake up" )
		uncbutton:SetSize( 74, 25 )
		uncbutton:SetPos( ScrW() / 2 - 32, 90 )
		uncbutton.DoClick = function()
			RunConsoleCommand( "rp_wakeup" )
			uncbutton:Remove()
			uncbutton = nil
		end
	else
		gui.EnableScreenClicker( false )
		if uncbutton then
			uncbutton:Remove()
			uncbutton = nil
		end
	end
end)
