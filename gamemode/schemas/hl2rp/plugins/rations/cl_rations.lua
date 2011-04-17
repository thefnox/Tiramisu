hook.Add( "ScoreboardShow", "HL2RPRationsDisplay", function()

	if RationFrame then
	    RationFrame:Remove()
	end

	RationFrame = vgui.Create( "DFrameTransparent" )
	RationFrame:SetSize( 90, 74 )
	RationFrame:SetTitle( "Rations" )
	RationFrame:ShowCloseButton( false ) 
	RationFrame:SetPos( -110, ScrH() / 2 - 52 )

	local label = Label( "Rations (" .. GetGlobalInt( "rations" ) .. " left)" , RationFrame)
	label:SizeToContents()
	timer.Create( "RefreshRationLabel", 2, 0, function()
		if label and label:IsValid() then
			label:SetText( "Rations (" .. GetGlobalInt( "rations" ) .. " left)" )
		end
	end)
	label:SetPos( 3, 26 )

	local amount = vgui.Create( "DNumberWang", RationFrame )
	amount:SetPos( 4, 44 )
	amount:SetDecimals( 0 )
	amount:SetMax( 60 )
	amount:SetMin( 1 )
	amount:SetValue( 1 )
	amount:SetSize( 36, 25 )

	local spawn = vgui.Create( "DButton", RationFrame )
	spawn:SetSize( 40, 25)
	spawn:SetText( "Create" )
	spawn:SetPos( 44, 44 )
	spawn.DoClick = function()
		RunConsoleCommand( "rp_makeration", amount:GetValue() )
	end

	local x, y
	RationFrame.PaintOver = function()
		x, y = RationFrame:GetPos()
		if CAKE.MenuOpen and CAKE.Group and ( CAKE.Group["Name"] == "CCA" or CAKE.Group["Name"] == "Overwatch" ) then
			RationFrame:SetPos( Lerp( 0.2, x, 10), ScrH() / 2 - 52)
		end
	end   


end )

hook.Add( "ScoreboardHide", "HL2RPDestroyRations", function()
	if RationFrame then
	    RationFrame:Remove()
	end
end)