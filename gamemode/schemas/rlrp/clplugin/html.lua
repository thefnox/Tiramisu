CLPLUGIN.Name = "Forums Menu Element"
CLPLUGIN.Author = "F-Nox/Big Bang"


local function OpenForums()
	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 700, 520 )
	PlayerMenu:SetTitle( "Forums" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	PlayerMenu:SetBackgroundBlur( true )
	
	local Help = vgui.Create( "DPanelList", PlayerMenu )
	Help:SetSize( 700, 490 )
	Help:SetPos( 0, 23 )
	Help:SetPadding(10);
	Help:EnableHorizontal(false);
	Help:EnableVerticalScrollbar(false);
	
	local html = vgui.Create( "HTML")
	html:SetSize( 700, 467 )
	html:SetPos( 0, 23)
	html:OpenURL( "http://www.facepunch.com/showthread.php?t=1004787" )
	Help:AddItem( html )
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