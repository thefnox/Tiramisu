--HTML Page tab.

local function OpenForums()
	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 700, 520 )
	PlayerMenu:SetTitle( "Forums" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:SetSizable( true )
	PlayerMenu:Center()
	PlayerMenu:SetBackgroundBlur( true )
	
	local controls = vgui.Create( "DHTMLControls", PlayerMenu )
	controls:Dock( TOP )

	local html = vgui.Create( "HTML" , PlayerMenu )
	html:Dock(FILL)
	html:OpenURL( CAKE.ConVars[ "Webpage" ] )

	controls:SetHTML( html )

	PlayerMenu:MakePopup()

end

local function CloseForums()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Forums", OpenForums, CloseForums )