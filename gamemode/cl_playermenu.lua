CurrencyTable = {}
CAKE.MenuTabs = {}
CAKE.ActiveTab = nil
CAKE.MenuOpen = false

function AddCurrency( ply, handle, id, encoded, decoded )
	local currencydata = {}
	currencydata.name = encoded.name
	currencydata.centenials = encoded.centenials
	currencydata.slang = encoded.slang
	currencydata.abr   = encoded.abr
	CurrencyTable = currencydata
end
datastream.Hook( "addcurrency", AddCurrency )

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

local function RecieveMyGroup( handler, id, encoded, decoded )
	
	CAKE.MyGroup.Name = decoded.Name or false
	CAKE.MyGroup.Type = decoded.Type or ""
	CAKE.MyGroup.Founder = decoded.Founder or ""
	CAKE.MyGroup.Rank = decoded.Rank or ""
	CAKE.MyGroup.RankPermissions = decoded.RankPermissions or {}
	CAKE.MyGroup.Inventory = decoded.Inventory or {}

end
datastream.Hook("recievemygroup", RecieveMyGroup )


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

function InitHiddenButton()
	HiddenButton = vgui.Create("DButton") -- HOLY SHIT WHAT A HACKY METHOD FO SHO
	HiddenButton:SetSize(ScrW(), ScrH());
	HiddenButton:SetText("");
	HiddenButton:SetDrawBackground(false);
	HiddenButton:SetDrawBorder(false);
	HiddenButton.DoRightClick = function()
		local Vect = gui.ScreenToVector(gui.MouseX(), gui.MouseY());
		local tracedata = {};
		tracedata.start = LocalPlayer():GetShootPos();
		tracedata.endpos = LocalPlayer():GetShootPos() + (Vect * 100);
		tracedata.filter = LocalPlayer();
		local trace = util.TraceLine(tracedata);
		
		if(trace.HitNonWorld) then
			local target = trace.Entity;
			
			local ContextMenu = DermaMenu()
			
				for k,v in pairs (RclickTable) do
					if v.Condition(target) then ContextMenu:AddOption(v.Name, function() v.Click(target, LocalPlayer()) end) end
				end
				
			ContextMenu:Open();
		end
	end
end


function InitHUDMenu()
	InitHiddenButton();
end

function CAKE.RegisterMenuTab( name, func, closefunc ) --The third argument is the function used for closing your panel.
	print( "Registering Menu Tab " .. name )
	CAKE.MenuTabs[ name ] = {}
	CAKE.MenuTabs[ name ][ "function" ] = func or function() end
	CAKE.MenuTabs[ name ][ "closefunc" ] = closefunc or function() end
end

function CAKE.CloseTabs()
	if CAKE.ActiveTab then
		CAKE.MenuTabs[ CAKE.ActiveTab ][ "closefunc" ]()
		CAKE.ActiveTab = nil
	end
end

function CAKE.SetActiveTab( name )
	CAKE.CloseTabs()
	CAKE.MenuTabs[ name ][ "function" ]()
	CAKE.ActiveTab = name
end

function CreatePlayerMenu()
	
		CAKE.MenuOpen = true
		TabPanel = vgui.Create("DFrame");
		TabPanel:SetSize( 220, 600 )
		TabPanel:SetPos( 10, 10 )
		TabPanel:SetTitle( "" )
		TabPanel:SetDraggable( false ) -- Draggable by mouse?
		TabPanel:ShowCloseButton( false ) -- Show the close button?
		TabPanel:ParentToHUD()
		function TabPanel:Paint()
		end
		TabList = vgui.Create( "DPanelList", TabPanel )
		TabList:SetPos( 0,25 )
		TabList:SetSize( 210, 567 )
		TabList:SetSpacing( 2 ) -- Spacing between items
		TabList:SetPadding( 10 )
		TabList:EnableHorizontal( false ) -- Only vertical items
		TabList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
		function TabList:Paint()
		end
		local MainMenu = vgui.Create( "DLabel" )
		MainMenu:SetFont("HUDNumber5")
		MainMenu:SetText( "MAIN MENU" )
		MainMenu:SetSize( 200, 50 )
		MainMenu:SetTextColor( Color( 255, 0, 0 ) )
		TabList:AddItem( MainMenu )
		for k, v in pairs( CAKE.MenuTabs ) do
			local label = vgui.Create( "DLabel" )
			label:SetFont("Trebuchet24")
			label:SetText( string.upper( k ) )
			label:SetSize( 200, 20 )
			label:SetTextColor( Color( 0, 0, 0 ) )
			label.OnMousePressed = function()
				CAKE.SetActiveTab(k)
			end
			TabList:AddItem( label )
		end
		local closelabel = vgui.Create( "DLabel" )
		closelabel:SetFont("Trebuchet24")
		closelabel:SetText( string.upper( "Close Menu" ))
		closelabel:SetSize( 200, 65 )
		closelabel:SetTextColor( Color( 0, 0, 0 ) )
		closelabel.OnMousePressed = function()
			CAKE.CloseTabs()
			TabPanel:Remove();
			TabPanel = nil;
			CAKE.MenuOpen = false
		end
		TabList:AddItem( closelabel )
		TabPanel:MakePopup()
	
end
usermessage.Hook("openplayermenu", CreatePlayerMenu);

function ClosePlayerMenu()
	if TabPanel then
		TabPanel:Remove();
		TabPanel = nil
		CAKE.MenuOpen = false
	end
end
usermessage.Hook("closeplayermenu", ClosePlayerMenu);