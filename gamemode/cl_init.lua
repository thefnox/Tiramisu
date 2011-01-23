-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_init.lua
-- This file calls the rest of the script
-- As you can see, the clientside of CakeScript is pretty simple compared to the serverside.
-------------------------------

-- Set up the gamemode
DeriveGamemode( "sandbox" );
GM.Name = "Tiramisu";

-- Define global variables
CAKE = {  };
CAKE.Running = false;
CAKE.Loaded = false;
CAKE.Skin = "default"

CAKE.ViewRagdoll = false

CAKE.Clothing = "none"
CAKE.Helmet = "none"
CAKE.Gear = {}
CAKE.ClothingTbl = {}

CAKE.MyGroup = {}

CAKE.models = {  };
readysent = false;

require( "datastream" )

-- Client Includes
include( "shared.lua" );
include( "player_shared.lua" );
include( "cl_hud.lua" );
include( "cl_binds.lua" );
include( "cl_charactercreate.lua" );
include( "cl_playermenu.lua" );
include( "animations.lua" )
include( "resourcex.lua" ) -- Resource downloading

CAKE.Loaded = true;

-- Initialize the gamemode
function GM:Initialize( )

	CAKE.Running = true;

	self.BaseClass:Initialize( );

end

function GM:Think( )

	if( vgui and readysent == false ) then -- VGUI is initalized, tell the server we're ready for character creation.
	
		LocalPlayer( ):ConCommand( "rp_ready\n" );
		readysent = true;
		
	end
	
end

function GM:ForceDermaSkin()

	return CAKE.Skin
	
end

local function AddToChat( um )
	local string = um:ReadString()
	local font = um:ReadString()
	if aChat and aChat.AddChatLine then
		aChat.AddChatLine( "<color=135,209,255,255><font=" .. font .. ">" .. string .. "</font></color>" )
	end
end
usermessage.Hook( "tiramisuaddtochat", AddToChat )

function ConfirmCharRemove( um )
	local name = um:ReadString()
	local gender = um:ReadString()
	local description = um:ReadString()
	local age = um:ReadString()
	local model = um:ReadString()
	local id = um:ReadLong()
	PlayerInfo = vgui.Create( "DFrame" )
	PlayerInfo:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerInfo:SetSize( 536, 450 )
	PlayerInfo:SetTitle( "Confirm delete of: " .. name )
	PlayerInfo:SetVisible( true )
	PlayerInfo:SetDraggable( true )
	PlayerInfo:ShowCloseButton( false )
	PlayerInfo:MakePopup()
	PlayerPanel = vgui.Create( "DPanel", PlayerInfo )
	PlayerPanel:SetPos( 2, 23 )
	PlayerPanel:SetSize( 532, 425 )
	PlayerPanel.Paint = function()
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.DrawRect( 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall() )
	end
	local namelabel = vgui.Create( "DLabel", PlayerPanel )
	namelabel:SetPos( 5, 3 )
	namelabel:SetSize( 150, 20 )
	namelabel:SetText( name )
	
	local genderlabel = vgui.Create( "DLabel", PlayerPanel )
	genderlabel:SetPos( 5, 63 )
	genderlabel:SetSize( 150, 20 )
	genderlabel:SetText( "Gender : " .. gender )
	
	local agelabel = vgui.Create( "DLabel", PlayerPanel )
	agelabel:SetPos( 5, 93 )
	agelabel:SetSize( 150, 20 )
	agelabel:SetText( "Age : " .. age )
	
	local desctext = vgui.Create( "DTextEntry", PlayerPanel )
	desctext:SetPos( 5 , 243 )
	desctext:SetSize( 200, 75 )
	desctext:SetMultiline( true )
	desctext:SetEditable( false )
	desctext:SetText( description )
	
	local mdlPanel = vgui.Create( "DModelPanel", PlayerPanel )
	mdlPanel:SetSize( 400, 400 )
	mdlPanel:SetPos( 180, -30 )
	mdlPanel:SetModel( model )
	mdlPanel:SetAnimSpeed( 0.0 )
	mdlPanel:SetAnimated( false )
	mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	mdlPanel:SetCamPos( Vector( 100, 0, 30) );
	mdlPanel:SetLookAt( Vector( 0, 0, 30) );
	mdlPanel:SetFOV( 70 );
	function mdlPanel:LayoutEntity(Entity)

		self:RunAnimation()
		Entity:SetAngles( Angle( 0, 0, 0) )
		
	end
	
	local confirmbutton = vgui.Create( "DButton", PlayerPanel )
	confirmbutton:SetPos( 366, 375 )
	confirmbutton:SetSize( 150, 50 )
	confirmbutton:SetText( "Confirm Delete" )
	confirmbutton.DoClick = function( btn )
		LocalPlayer():ConCommand("rp_removechar " .. id);
		CreatePlayerMenu()
		PlayerInfo:Remove()
		PlayerInfo = nil;
	end
	
	local declinebutton = vgui.Create( "DButton", PlayerPanel )
	declinebutton:SetPos( 66, 375 )
	declinebutton:SetSize( 150, 50 )
	declinebutton:SetText( "Return to previous menu" )
	declinebutton.DoClick = function( btn )
		CAKE.SetActiveTab( "Characters" )
		PlayerInfo:Remove()
		PlayerInfo = nil;
	end
end
usermessage.Hook( "ConfirmCharRemoval", ConfirmCharRemove );


function message_GetPlayerInfo( um )
	local target = um:ReadEntity()
	local gender = um:ReadString()
	local age = um:ReadString()
	PlayerInfo = vgui.Create( "DFrameTransparent" )
	PlayerInfo:Center()
	PlayerInfo:SetSize( 450, 350 )
	PlayerInfo:SetTitle( "Character Info: " .. target:Nick() )
	PlayerInfo:SetVisible( true )
	PlayerInfo:SetDraggable( true )
	PlayerInfo:ShowCloseButton( true )
	PlayerInfo:MakePopup()
	PlayerPanel = vgui.Create( "DPanelList", PlayerInfo )
	PlayerPanel:SetPos( 5, 28 )
	PlayerPanel:SetSize( 420, 318 )
	PlayerPanel.Paint = function()
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.DrawRect( 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall() )
	end
	local namelabel = vgui.Create( "DLabel", PlayerPanel )
	namelabel:SetPos( 5, 3 )
	namelabel:SetSize( 150, 20 )
	namelabel:SetText( target:Nick() )

	PlayerPanel:AddItem( namelabel)
	
	local genderlabel = vgui.Create( "DLabel", PlayerPanel )
	genderlabel:SetPos( 5, 63 )
	genderlabel:SetSize( 150, 20 )
	genderlabel:SetText( "Gender : " .. gender )

	PlayerPanel:AddItem( genderlabel)
	
	local agelabel = vgui.Create( "DLabel", PlayerPanel )
	agelabel:SetPos( 5, 93 )
	agelabel:SetSize( 150, 20 )
	agelabel:SetText( "Age : " .. age )

	PlayerPanel:AddItem( agelabel)
	
	local titlelabel = vgui.Create( "DLabel", PlayerPanel )
	titlelabel:SetPos( 5, 183 )
	titlelabel:SetSize( 150, 20 )
	titlelabel:SetText( target:GetNWString( "title" ) )

	PlayerPanel:AddItem( titlelabel)
	
	local title2label = vgui.Create( "DLabel", PlayerPanel )
	title2label:SetPos( 5, 213 )
	title2label:SetSize( 150, 20 )
	title2label:SetText( target:GetNWString( "title2" ) )
	PlayerPanel:AddItem( title2label)
	
	local mdlPanel = vgui.Create( "DModelPanel", PlayerPanel )
	mdlPanel:SetSize( 200, 200 )
	mdlPanel:SetModel( target:GetModel() )
	mdlPanel:SetAnimSpeed( 0.0 )
	mdlPanel:SetAnimated( false )
	mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	mdlPanel:SetCamPos( Vector( 100, 0, 30) );
	mdlPanel:SetLookAt( Vector( 0, 0, 30) );
	mdlPanel:SetFOV( 70 );
	function mdlPanel:LayoutEntity(Entity)

		self:RunAnimation()
		Entity:SetAngles( Angle( 0, 0, 0) )
		
	end

	PlayerPanel:AddItem( mdlPanel)
end
usermessage.Hook( "GetPlayerInfo", message_GetPlayerInfo );

function RunConcommand( um ) --Simple fix to garry's fuckup.
	
	local cmd = um:ReadString()
	local exp = string.Explode( " ", cmd )
	cmd = exp[1]
	local args = ""
	table.remove( exp, 1 )
	if #exp > 1 then
		args = table.concat( exp, " " )
	else
		args = exp[1] or ""
	end
	
	RunConsoleCommand( cmd, args )
	
end
usermessage.Hook( "runconcommand", RunConcommand )

function RemoveChar( um )
	
	local n = um:ReadLong();
	table.Empty( ExistingChars[ n ] )
	ExistingChars[ n ] = nil;
	
end
usermessage.Hook( "RemoveChar", RemoveChar );

usermessage.Hook( "addcurrency", function( um )
	local currencydata = {}
	currencydata.name = um:ReadString()
	currencydata.slang = um:ReadString()
	currencydata.abr   = um:ReadString()
	CurrencyTable = currencydata
end)

Schemas = {}

function AddSchema(data)
	local schema = data:ReadString()
	AddRclicks(schema)
	AddCharCreates(schema)
end
usermessage.Hook("addschema", AddSchema)
/*
		[ "Name" ]		= name,
		[ "Type" ]		= data:ReadString(),
		[ "Founder" ]	= data:ReadString(),
		[ "Rank" ]		= data:ReadString(),
		[ "RankPermissions" ] = string.Explode( ",", data:ReadString() ),
		[ "Inventory" ]	= {}
*/

RclickTable = {}

function AddRclicks(schema)
		local list = file.FindInLua( "tiramisu/gamemode/schemas/" .. schema .. "/rclick/*.lua" )	
		for k,v in pairs( list ) do
			local path = "tiramisu/gamemode/schemas/" .. schema .. "/rclick/" .. v
			RCLICK = { }
			include( path )
			table.insert(RclickTable, RCLICK);
		end
end


InventoryTable = {}

function AddItem(data)
	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Weight = data:ReadShort();
	
	table.insert(InventoryTable, itemdata);
end
usermessage.Hook("addinventory", AddItem);

function ClearItems()
	
	InventoryTable = {}
	
end
usermessage.Hook("clearinventory", ClearItems);

BusinessTable = {};

function AddBusinessItem(data)
	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Price = data:ReadLong();
	
	--print( itemdata.Class )
	
	table.insert(BusinessTable, itemdata);
end
usermessage.Hook("addbusiness", AddBusinessItem);

MyGroupInventory = {}

function AddMyGroupItem(data)
	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Price = data:ReadLong();
	
	
	table.insert(MyGroupInventory, itemdata);
end
usermessage.Hook("addmygroupitem", AddMyGroupItem);

function ClearBusinessItems()
	
	BusinessTable = {}
	
end
usermessage.Hook("clearbusiness", ClearBusinessItems);

function RecieveGroupInvite( um )
	local group = um:ReadString()
	local promoter = um:ReadString()
	Derma_Query("You have recieved an invitation from " .. promoter .. " to join: " .. group, "Group Invite",
				"Accept", function() RunConsoleCommand("rp_acceptinvite", group, promoter ) end,
				"Decline", function() print( "You have declined a group invite" ) end)

end
usermessage.Hook("recievegroupinvite", RecieveGroupInvite);

function RecieveGroupPromotion( um )
	local rank = um:ReadString()
	local promoter = um:ReadString()
	Derma_Query("You have recieved an promotion from " .. promoter .. " to rank: " .. rank, "Congratulations!",
				"Accept", function() RunConsoleCommand("rp_acceptinvite", group, promoter ) end)
end
usermessage.Hook("recievegrouppromotion", RecieveGroupPromotion);
