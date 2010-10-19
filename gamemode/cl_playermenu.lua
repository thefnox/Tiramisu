CurrencyTable = {}
CAKE.MenuTabs = {}
CAKE.ActiveTab = nil
CAKE.MenuOpen = false
CAKE.MenuFont = "Base 02"

surface.CreateFont( CAKE.MenuFont, 48, 800, true, false, "BaseTitle" )
surface.CreateFont( CAKE.MenuFont, 32, 800, true, false, "BaseOptions" )

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
	CAKE.MyGroup.Image = decoded.Image or ""

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
	CAKE.MenuOpen = true
end

function CreatePlayerMenu( um )
		
		if CAKE.MenuOpen then
			ClosePlayerMenu()
			return
		end
	
		CAKE.MenuOpen = true
		TabPanel = vgui.Create("DFrame");
		TabPanel:SetSize( 270, 600 )
		TabPanel:SetPos( 10, 10 )
		TabPanel:SetTitle( "" )
		TabPanel:SetDraggable( false ) -- Draggable by mouse?
		TabPanel:ShowCloseButton( false ) -- Show the close button?
		TabPanel:ParentToHUD()
		function TabPanel:Paint()
		end
		TabList = vgui.Create( "DPanelList", TabPanel )
		TabList:SetPos( 0,25 )
		TabList:SetSize( 260, 567 )
		TabList:SetSpacing( 2 ) -- Spacing between items
		TabList:SetPadding( 10 )
		TabList:EnableHorizontal( false ) -- Only vertical items
		TabList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
		function TabList:Paint()
		end
		local MainMenu = vgui.Create( "DLabel" )
		MainMenu:SetFont("BaseTitle")
		MainMenu:SetText( "Main Menu" )
		MainMenu:SetSize( 250, 50 )
		MainMenu:SetTextColor( Color( 220, 0, 0 ) )
		MainMenu:SetExpensiveShadow( 2, Color( 255, 255, 255, 255 ) )
		TabList:AddItem( MainMenu )
		for k, v in pairs( CAKE.MenuTabs ) do
			local label = vgui.Create( "DLabel" )
			label:SetFont("BaseOptions")
			label:SetText( k )
			label:SetSize( 250, 30 )
			label:SetTextColor( Color( 0, 0, 0 ) )
			label.OnMousePressed = function()
				CAKE.SetActiveTab(k)
			end
			label:SetExpensiveShadow( 1, Color( 255, 255, 255, 255 ) )
			TabList:AddItem( label )
		end
		local closelabel = vgui.Create( "DLabel" )
		closelabel:SetFont("BaseOptions")
		closelabel:SetText( "Close Menu" )
		closelabel:SetSize( 250, 65 )
		closelabel:SetExpensiveShadow( 1, Color( 255, 255, 255, 255 ) )
		closelabel:SetTextColor( Color( 0, 0, 0 ) )
		closelabel.OnMousePressed = function()
			ClosePlayerMenu()
		end
		TabList:AddItem( closelabel )
		TabPanel:MakePopup()
		
		VitalsMenu = vgui.Create( "DFrame" )
		VitalsMenu:SetSize( 340, 230 )
		VitalsMenu:SetTitle( "" )
		VitalsMenu:SetVisible( true )
		VitalsMenu:SetDraggable( false )
		VitalsMenu:ShowCloseButton( false )
		VitalsMenu:SetDeleteOnClose( true )
		VitalsMenu:SetPos( ScrW() - 350, 310 )
		function VitalsMenu:Paint()
		end

		local PlayerInfo = vgui.Create( "DPanelList", VitalsMenu )
		PlayerInfo:SetSize( 340, 200 )
		PlayerInfo:SetPos( 0, 23 )
		PlayerInfo:SetPadding(10);
		PlayerInfo:SetSpacing(10);
		PlayerInfo:EnableHorizontal(false);
		function PlayerInfo:Paint()
		end

		local icdata = vgui.Create( "DForm" );
		icdata:SetPadding(4);
		icdata:SetName(LocalPlayer():Nick() or "");

		local FullData = vgui.Create("DPanelList");
		FullData:SetSize(0, 84);
		FullData:SetPadding(10);

		local DataList = vgui.Create("DPanelList");
		DataList:SetSize(0, 64);

		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetModel(LocalPlayer():GetNWString( "model", LocalPlayer():GetModel()) );
		spawnicon:SetSize( 64, 64 );
		DataList:AddItem(spawnicon);

		local DataList2 = vgui.Create( "DPanelList" )

		local label2 = vgui.Create("DLabel");
		label2:SetText("Title: " .. LocalPlayer():GetNWString("title", ""));
		DataList2:AddItem(label2);

		local label3 = vgui.Create("DLabel");
		label3:SetText("Title 2: " .. LocalPlayer():GetNWString("title2", ""));
		DataList2:AddItem(label3);

		local label4 = vgui.Create("DLabel");
		label4:SetText( CurrencyTable.name .. ": " .. LocalPlayer():GetNWString("money", "0" ));
		DataList2:AddItem(label4);

		local Divider = vgui.Create("DHorizontalDivider");
		Divider:SetLeft(spawnicon);
		Divider:SetRight(DataList2);
		Divider:SetLeftWidth(64);
		Divider:SetHeight(64);

		DataList:AddItem(spawnicon);
		DataList:AddItem(DataList2);
		DataList:AddItem(Divider);

		FullData:AddItem(DataList)

		icdata:AddItem(FullData)

		local vitals = vgui.Create( "DForm" );
		vitals:SetPadding(4);
		vitals:SetName("Vital Signs");

		local VitalData = vgui.Create("DPanelList");
		VitalData:SetAutoSize(true)
		VitalData:SetPadding(10);
		vitals:AddItem(VitalData);

		local healthstatus = ""
		local hp = LocalPlayer():Health();

		if(!LocalPlayer():Alive()) then healthstatus = "Dead";
		elseif(hp > 95) then healthstatus = "Healthy";
		elseif(hp > 50 and hp < 95) then healthstatus = "OK";
		elseif(hp > 30 and hp < 50) then healthstatus = "Near Death";
		elseif(hp > 1 and hp < 30) then healthstatus = "Death Imminent"; end

		local health = vgui.Create("DLabel");
		health:SetText("Vitals: " .. healthstatus);
		VitalData:AddItem(health);

		PlayerInfo:AddItem(icdata)
		PlayerInfo:AddItem(vitals)

	
end
usermessage.Hook("openplayermenu", CreatePlayerMenu);

function ClosePlayerMenu( um )

	CAKE.CloseTabs()
	if TabPanel then
		if VitalsMenu then
			VitalsMenu:Remove();
			VitalsMenu = nil
		end
		TabPanel:Remove();
		TabPanel = nil
	end
	CAKE.MenuOpen = false
end
usermessage.Hook("closeplayermenu", ClosePlayerMenu);