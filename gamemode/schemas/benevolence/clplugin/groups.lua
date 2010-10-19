CLPLUGIN.Name = "Clientside Group Utilities"
CLPLUGIN.Author = "FNox"

--Keeping shit neat.

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
	
	imagelol = vgui.Create( "DImage", PlayerMenu )
	imagelol:SetImage( CAKE.MyGroup.Image )
	imagelol:SizeToContents()
	imagelol:SetPos( 320 - 64, 23 )

    BizPanel = vgui.Create( "DPropertySheet", PlayerMenu )
    BizPanel:SetPos( 0, 23 + 128 )
	BizPanel:SetSize( 640 , 427 - 128 )
	   
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
	
	BizPanel:AddSheet( "My Group", MyBiz, "gui/silkicons/group", false, false, "The group which you belong");
	
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
