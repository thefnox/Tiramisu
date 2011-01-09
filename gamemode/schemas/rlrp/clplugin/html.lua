CLPLUGIN.Name = "Forums Menu Element"
CLPLUGIN.Author = "F-Nox/Big Bang"


local function OpenForums()
	PlayerMenu = vgui.Create( "DFrameTransparent" )
	PlayerMenu:SetSize( 700, 520 )
	PlayerMenu:SetTitle( "Forums" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	PlayerMenu:SetBackgroundBlur( true )
	
	local html = vgui.Create( "HTML" , PlayerMenu )
	html:SetSize( 690, 487 )
	html:SetPos( 5, 28 )
	html:OpenURL( "http://www.facepunch.com/" )

end

local function CloseForums()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Forums", OpenForums, CloseForums )

function CLPLUGIN.Init()
	
end