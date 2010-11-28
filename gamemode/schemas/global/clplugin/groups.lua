CLPLUGIN.Name = "Clientside Group Utilities"
CLPLUGIN.Author = "FNox"

local function OpenGroups()

CAKE.MyGroup.Roster = {
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    
    
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" },
    { ["Name"] = "Test", ["Rank"] = "lol", ["SteamID"] = "STEAMLOL" }
}

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
CAKE.MyGroup[ "Name" ]= name,
[ "Type" ]= data:ReadString(),
[ "Founder" ]= data:ReadString(),
[ "Rank" ]= data:ReadString(),
[ "RankPermissions" ] = string.Explode( ",", data:ReadString() ),
[ "Inventory" ]= {}
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

RosterBiz = vgui.Create( "DPanelList" )
RosterBiz:SetPadding( 10 );
RosterBiz:SetPos( 100, 100 )
RosterBiz:SetSpacing( 10 );
RosterBiz:EnableHorizontal( false );
RosterBiz:EnableVerticalScrollbar(false);

NameBox = vgui.Create("DListView");
NameBox:SetMultiSelect( false )
NameBox:SetSize( 630 , 245 )
NameBox:AddColumn("Character Name");
NameBox:AddColumn("Rank");
NameBox:AddColumn("SteamID");
if CAKE.MyGroup and CAKE.MyGroup.Roster and #CAKE.MyGroup.Roster > 1 then
    for k, v in pairs( CAKE.MyGroup.Roster ) do
        NameBox:AddLine( v.Name, v.Rank, v.SteamID )
    end
else
    NameBox:AddLine( "None", "None", "STEAM:0_0" )
end
RosterBiz:AddItem( NameBox )

local LocalGroup = {}

CreateBiz = vgui.Create( "DPanelList" )
CreateBiz:SetPadding( 10 );
CreateBiz:SetPos( 100, 100 )
CreateBiz:SetSpacing( 10 );
CreateBiz:EnableHorizontal( false );
CreateBiz:EnableVerticalScrollbar(false);

BizPanel:AddSheet( "My Group", MyBiz, "gui/silkicons/group", false, false, "The group which you belong");
BizPanel:AddSheet( "Roster", RosterBiz, "gui/silkicons/group", false, false, "A list of people inside the group");
BizPanel:AddSheet( "Create Group", CreateBiz, "gui/silkicons/group", false, false, "Create your own group!");

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
