CLPLUGIN.Name = "Groups Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"


local function OpenGroups()

	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Groups" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	function PlayerMenu:Paint()
	end
	
    BizPanel = vgui.Create( "DPropertySheet", PlayerMenu )
	BizPanel:SetSize( 640, 450 )
    BizPanel:SetPos( 0, 23 )
	   
	MyBiz = vgui.Create( "DPanelList" )
	MyBiz:SetPadding( 10 );
	MyBiz:SetPos( 100, 100 )
	MyBiz:SetSpacing( 10 );
	MyBiz:EnableHorizontal( false );
	MyBiz:EnableVerticalScrollbar(false);
	
	/*
		CAKE.MyGroup[ "Name" ]		= name,
		[ "Type" ]		= data:ReadString(),
		[ "Founder" ]	= data:ReadString(),
		[ "Rank" ]		= data:ReadString(),
		[ "RankPermissions" ] = string.Explode( ",", data:ReadString() ),
		[ "Inventory" ]	= {}
*/
	if !CAKE.MyGroup.Name then
		labellol = vgui.Create( "DLabel" )
		labellol:SetText( "You are not a member of any groups!" )
		MyBiz:AddItem( labellol )
	else
		labellol1 = vgui.Create( "DLabel" )
		labellol1:SetText( "Group Name: " .. CAKE.MyGroup.Name )
		MyBiz:AddItem( labellol1 )
		labellol2 = vgui.Create( "DLabel" )
		labellol2:SetText( "Type of Group: " .. CAKE.MyGroup.Type )
		MyBiz:AddItem( labellol2 )
		labellol3 = vgui.Create( "DLabel" )
		labellol3:SetText( "Founder: " .. CAKE.MyGroup.Founder )
		MyBiz:AddItem( labellol3 )
		labellol4 = vgui.Create( "DLabel" )
		labellol4:SetText( "Rank: " .. CAKE.MyGroup.Rank )
		MyBiz:AddItem( labellol4 )
	end
	SearchBiz = vgui.Create( "DPanelList" )
	SearchBiz:SetPos( 100, 100 )
	SearchBiz:SetPadding( 10 );
	SearchBiz:SetSpacing( 10 );
	SearchBiz:EnableHorizontal( false );
	SearchBiz:EnableVerticalScrollbar(false);
	labellolz = vgui.Create( "DLabel" )
	labellolz:SetText( "TESTING!" )
	SearchBiz:AddItem( labellolz )
	
	BizPanel:AddSheet( "My Group", MyBiz, "gui/silkicons/group", false, false, "The group which you belong");
	BizPanel:AddSheet( "Search Groups", SearchBiz, "gui/silkicons/magnifier", false, false, "Search all groups");

end

local function CloseGroups()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Groups", OpenGroups, CloseGroups )


function CLPLUGIN.Init()
	
end