CurrencyTable = {}

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

function CreateModelWindow()

	if(ModelWindow) then
	
		ModelWindow:Remove();
		ModelWindow = nil;
		
	end

	ModelWindow = vgui.Create( "DFrame" )
	ModelWindow:SetTitle("Select Model");

	local mdlPanel = vgui.Create( "DModelPanel", ModelWindow )
	mdlPanel:SetSize( 300, 300 )
	mdlPanel:SetPos( 10, 20 )
	mdlPanel:SetModel( models[1] )
	mdlPanel:SetAnimSpeed( 0.0 )
	mdlPanel:SetAnimated( false )
	mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	mdlPanel:SetCamPos( Vector( 50, 0, 50 ) )
	mdlPanel:SetLookAt( Vector( 0, 0, 50 ) )
	mdlPanel:SetFOV( 70 )

	local RotateSlider = vgui.Create("DNumSlider", ModelWindow);
	RotateSlider:SetMax(360);
	RotateSlider:SetMin(0);
	RotateSlider:SetText("Rotate");
	RotateSlider:SetDecimals( 0 );
	RotateSlider:SetWidth(300);
	RotateSlider:SetPos(10, 290);

	local BodyButton = vgui.Create("DButton", ModelWindow);
	BodyButton:SetText("Body");
	BodyButton.DoClick = function()

		mdlPanel:SetCamPos( Vector( 50, 0, 50) );
		mdlPanel:SetLookAt( Vector( 0, 0, 50) );
		mdlPanel:SetFOV( 70 );
		
	end
	BodyButton:SetPos(10, 40);

	local FaceButton = vgui.Create("DButton", ModelWindow);
	FaceButton:SetText("Face");
	FaceButton.DoClick = function()

		mdlPanel:SetCamPos( Vector( 50, 0, 60) );
		mdlPanel:SetLookAt( Vector( 0, 0, 60) );
		mdlPanel:SetFOV( 40 );
		
	end
	FaceButton:SetPos(10, 60);

	local FarButton = vgui.Create("DButton", ModelWindow);
	FarButton:SetText("Far");
	FarButton.DoClick = function()

		mdlPanel:SetCamPos( Vector( 100, 0, 30) );
		mdlPanel:SetLookAt( Vector( 0, 0, 30) );
		mdlPanel:SetFOV( 70 );
		
	end
	FarButton:SetPos(10, 80);
	
	local OkButton = vgui.Create("DButton", ModelWindow);
	OkButton:SetText("OK");
	OkButton.DoClick = function()

		SetChosenModel(mdlPanel.Entity:GetModel());
		ModelWindow:Remove();
		ModelWindow = nil;
		
	end
	OkButton:SetPos(10, 100);

	function mdlPanel:LayoutEntity(Entity)

		self:RunAnimation();
		Entity:SetAngles( Angle( 0, RotateSlider:GetValue(), 0) )
		
	end

	local i = 1;
	
	local LastMdl = vgui.Create( "DSysButton", ModelWindow )
	LastMdl:SetType("left");
	LastMdl.DoClick = function()

		i = i - 1;
		
		if(i == 0) then
			i = #models;
		end
		
		mdlPanel:SetModel(models[i]);
		
	end

	LastMdl:SetPos(10, 165);

	local NextMdl = vgui.Create( "DSysButton", ModelWindow )
	NextMdl:SetType("right");
	NextMdl.DoClick = function()

		i = i + 1;

		if(i > #models) then
			i = 1;
		end
		
		mdlPanel:SetModel(models[i]);
		
	end
	NextMdl:SetPos( 245, 165);
	
	ModelWindow:SetSize( 320, 330 )
	ModelWindow:Center()	
	ModelWindow:MakePopup()
	ModelWindow:SetKeyboardInputEnabled( false )
	
end


function InitHUDMenu()

	InitHiddenButton();
	/*
	HUDMenu = vgui.Create( "DFrame" )
	HUDMenu:SetPos( ScrW() - 130 - 5, 5 )
	HUDMenu:SetSize( 130, 150 )
	HUDMenu:SetTitle( "Player Menu" )
	HUDMenu:SetVisible( true )
	HUDMenu:SetDraggable( false )
	HUDMenu:ShowCloseButton( false )

	local label = vgui.Create("DLabel", HUDMenu);
	label:SetWide(0);
	label:SetPos(5, 25);
	label:SetText("Name: " .. LocalPlayer():Nick());
	
	local label3 = vgui.Create("DLabel", HUDMenu);
	label3:SetWide(0);
	label3:SetPos(5, 40);
	label3:SetText("Title: " .. LocalPlayer():GetNWString("title"));
	
	local label4 = vgui.Create("DLabel", HUDMenu);
	label4:SetWide(0);
	label4:SetPos(5, 55);
	label4:SetText("Assosciation: " .. team.GetName(LocalPlayer():Team()));

	local label5 = vgui.Create("DLabel", HUDMenu);
	label5:SetWide(0);
	label5:SetPos(5, 70);
	label5:SetText(LocalPlayer():GetNWString("money") .. " " .. CurrencyTable.abr);
	
	local spawnicon = vgui.Create( "SpawnIcon", HUDMenu);
	spawnicon:SetSize( 128, 128 );
	spawnicon:SetPos(1,21);
	spawnicon:SetIconSize( 128 )
	spawnicon:SetModel(LocalPlayer():GetModel());
	spawnicon:SetToolTip("Open Player Menu");
	
	local FadeSize = 130;
	
	function UpdateGUIData()
		label:SetText("Name: " .. LocalPlayer():Nick());
		
		label3:SetText("Title: " .. LocalPlayer():GetNWString("title"));
		
		label4:SetText("Assosciation: " .. team.GetName(LocalPlayer():Team()));

		label5:SetText(LocalPlayer():GetNWString("money") .. " " ..CurrencyTable.abr);

		spawnicon:SetModel(LocalPlayer():GetModel());
	end
	
	spawnicon.PaintOver = function()
		spawnicon:SetPos(FadeSize - 129, 21);
		HUDMenu:SetSize(FadeSize, 150);
		HUDMenu:SetPos(ScrW() - FadeSize - 5, 5 );
		
		label:SetWide(FadeSize - 128);
		label3:SetWide(FadeSize - 128);
		label4:SetWide(FadeSize - 128);
		label5:SetWide(FadeSize - 128);
		
		if(FadeSize > 130) then
			FadeSize = FadeSize - 5;
		end
		
		UpdateGUIData();
	end
	
	spawnicon.PaintOverHovered = function()
		
		spawnicon:SetPos(FadeSize - 129, 21);
		HUDMenu:SetSize(FadeSize, 150);
		HUDMenu:SetPos(ScrW() - FadeSize - 5, 5 );
		
		label:SetWide(FadeSize - 128);
		label3:SetWide(FadeSize - 128);
		label4:SetWide(FadeSize - 128);
		label5:SetWide(FadeSize - 128);
		
		if(FadeSize < 320) then
			FadeSize = FadeSize + 5;
		end
		
		UpdateGUIData();
	end*/
end

function CreatePlayerMenu()
	if(PlayerMenu) then
		PlayerMenu:Remove();
		PlayerMenu = nil;
	end
	
	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "" )
	--PlayerMenu:SetBackgroundBlur( true )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	function PlayerMenu:Paint()
	end
	PlayerMenu:MakePopup()

	
	PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent(PlayerMenu)
	PropertySheet:SetPos( 2, 30 )
	PropertySheet:SetSize( 636, 448 )
	
	local PlayerInfo = vgui.Create( "DPanelList" )
	PlayerInfo:SetPadding(20);
	PlayerInfo:SetSpacing(20);
	PlayerInfo:EnableHorizontal(false);
	
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
	label2:SetText("Title: " .. LocalPlayer():GetNWString("title"));
	DataList2:AddItem(label2);
	
	local label3 = vgui.Create("DLabel");
	label3:SetText("Assosciation: " .. team.GetName(LocalPlayer():Team()));
	DataList2:AddItem(label3);

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
	
	CharPanel = vgui.Create( "DPanelList" )
	CharPanel:SetPadding(20);
	CharPanel:SetSpacing(10);
	CharPanel:EnableVerticalScrollbar();
	CharPanel:EnableHorizontal(false);

	
	local label = vgui.Create("DLabel");
	label:SetText("Click your character to select it");
	CharPanel:AddItem(label);
	
	/*charlist = vgui.Create( "DPanelList" )
	charlist:SetPadding(20);
	charlist:SetSpacing(10);
	charlist:EnableHorizontal(false);
	CharPanel:AddItem( charlist )*/
	
	local widthnshit = 600
	local numberofchars = table.getn( ExistingChars )
	local modelnumber = {}
	
	local function AddCharacterModel( n, model )
		
		local mdlpanel = modelnumber[n]
		
		mdlpanel = vgui.Create( "DModelPanel" )
		mdlpanel:SetSize( 200, 180 )
		mdlpanel:SetModel( model )
		mdlpanel:SetAnimSpeed( 0.0 )
		mdlpanel:SetAnimated( false )
		mdlpanel:SetAmbientLight( Color( 50, 50, 50 ) )
		mdlpanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
		mdlpanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
		mdlpanel:SetCamPos( Vector( 100, 0, 40 ) )
		mdlpanel:SetLookAt( Vector( 0, 0, 40 ) )
		mdlpanel:SetFOV( 70 )

		mdlpanel.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("Trebuchet18");
			surface.SetTextPos( surface.GetTextSize(ExistingChars[n]['name']) , 0);
			surface.DrawText(ExistingChars[n]['name'])
		end
		
		function mdlpanel:OnMousePressed()
			local Options = DermaMenu()
			Options:AddOption("Select Character", function() 
				LocalPlayer():ConCommand("rp_selectchar " .. n);
				LocalPlayer().MyModel = ""
			
				PlayerMenu:Remove();
				PlayerMenu = nil;
			end )
			Options:AddOption("Delete Character", function() 
				LocalPlayer():ConCommand("rp_confirmremoval " .. n);
				PlayerMenu:Remove();
				PlayerMenu = nil;
			end )
			Options:Open()
		end

		function mdlpanel:LayoutEntity(Entity)

			self:RunAnimation();
			
		end
		function InitAnim()
		
			if(mdlpanel.Entity) then		
				local iSeq = mdlpanel.Entity:LookupSequence( "idle_angry" );
				mdlpanel.Entity:ResetSequence(iSeq);
			
			end
			
		end
		
		InitAnim()
		CharPanel:AddItem(mdlpanel);
	
	end
	
	
	for k, v in pairs(ExistingChars) do
		AddCharacterModel( k, v['model'] )
		
	end
	
	local newchar = vgui.Create("DButton");
	newchar:SetSize(100, 25);
	newchar:SetText("New Character");
	newchar.DoClick = function ( btn )
		CAKE.NextStep()
		PlayerMenu:Remove();
		PlayerMenu = nil;
	end
	CharPanel:AddItem( newchar )
	
	Inventory = vgui.Create( "DPropertySheet" )
	
	InventorySheet = vgui.Create( "DPanelList" )
	InventorySheet:SetPadding(10);
	InventorySheet:SetSpacing(10);
	InventorySheet:EnableHorizontal(false);
	InventorySheet:EnableVerticalScrollbar(false);
	local elipsis = ""
	
	local availablespace = 10
	
	local function drawinventoryicons()
		availablespace = 10
		InventorySheet:Clear()
		
		local label = vgui.Create( "DLabel" )
		label:SizeToContents()
		InventorySheet:AddItem(label);
		
		local grid = vgui.Create( "DGrid" )
		grid:SetCols( 8 )
		grid:SetColWide( 74 )
		grid:SetRowHeight( 74 )
		InventorySheet:AddItem(grid);
		
		for k, v in pairs(InventoryTable) do
			
			if string.len( v.Name ) > 6 then
				elipsis = "..."
			else
				elipsis = ""
			end
			
			local spawnicon = vgui.Create( "SpawnIcon");
			spawnicon:SetSize( 64, 64 );
			spawnicon:SetIconSize( 64 )
			spawnicon:SetModel(v.Model);
			spawnicon:SetToolTip(v.Description);
			
			local function DeleteMyself()
				grid:RemoveItem( spawnicon )
			end
			
			spawnicon.DoClick = function ( btn )
			
				local ContextMenu = DermaMenu()
					ContextMenu:AddOption("Drop", function() LocalPlayer():ConCommand("rp_dropitem " .. v.Class); DeleteMyself(); end);
					if CAKE.ExtraCargo > 0 then
						--drawinventoryicons(); drawextrainventory();
						ContextMenu:AddOption("Transfer to Cargo", function() LocalPlayer():ConCommand("rp_pickupextra " .. v.Class); DeleteMyself(); end);
					end
				ContextMenu:Open();
				
			end
			
			spawnicon.PaintOver = function()
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(32 - surface.GetTextSize( string.sub( v.Name, 1, 6 ) .. elipsis) / 2, 5);
				surface.DrawText( string.sub( v.Name, 1, 6 ) .. elipsis )
				
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(60, 60);
				surface.DrawText( v.Weight )
			end
			
			spawnicon.PaintOverHovered = function()
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(32 - surface.GetTextSize( string.sub( v.Name, 1, 6 ) .. elipsis ) / 2, 5);
				surface.DrawText(string.sub( v.Name, 1, 6 ) .. elipsis)
				
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(60, 60);
				surface.DrawText( v.Weight )
			end
			
			availablespace = availablespace - v.Weight
			
			grid:AddItem(spawnicon);
		end
		
		label:SetText( "Available space: " .. tostring( math.Clamp( availablespace, 0, 100 ) ) .. ".kg" )
	end
	drawinventoryicons()
	
	ExtraSheet = vgui.Create( "DPanelList" )
	ExtraSheet:SetPadding(10);
	ExtraSheet:SetSpacing(10);
	ExtraSheet:EnableHorizontal(false);
	ExtraSheet:EnableVerticalScrollbar(false);
	local elipsis = ""
	
	local function drawextrainventory()
		local label = vgui.Create( "DLabel" )
		label:SizeToContents()
		label:SetText( "Cargohold Capacity: " .. tostring( CAKE.ExtraCargo ) .. ".kg" )
		ExtraSheet:AddItem(label);
		
		for k, v in pairs(ExtraInventory) do
			
			if string.len( v.Name ) > 6 then
				elipsis = "..."
			else
				elipsis = ""
			end
			
			local spawnicon = vgui.Create( "SpawnIcon");
			spawnicon:SetSize( 64, 64 );
			spawnicon:SetIconSize( 64 )
			spawnicon:SetModel(v.Model);
			spawnicon:SetToolTip(v.Description);
			
			local function DeleteMyself()
				spawnicon:Remove()
			end
			
			spawnicon.DoClick = function ( btn )
			
				local ContextMenu = DermaMenu()
					ContextMenu:AddOption("Transfer to Backpack", function()
						LocalPlayer():ConCommand("rp_dropextraitem " .. v.Class);
						DeleteMyself();
						drawextrainventory()
						drawinventoryicons()
					end);
				ContextMenu:Open();
				
			end
			
			spawnicon.PaintOver = function()
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(32 - surface.GetTextSize( string.sub( v.Name, 1, 6 ) .. elipsis) / 2, 5);
				surface.DrawText( string.sub( v.Name, 1, 6 ) .. elipsis )
				
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(60, 60);
				surface.DrawText( v.Weight )
			end
			
			spawnicon.PaintOverHovered = function()
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(32 - surface.GetTextSize( string.sub( v.Name, 1, 6 ) .. elipsis ) / 2, 5);
				surface.DrawText(string.sub( v.Name, 1, 6 ) .. elipsis)
				
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(60, 60);
				surface.DrawText( v.Weight )
			end
			
			ExtraSheet:AddItem(spawnicon);
		end
	end
	
	if CAKE.ExtraCargo > 0 then
		
		drawextrainventory()
		drawinventoryicons()
		
	else
		local label = vgui.Create( "DLabel" )
		label:SizeToContents()
		label:SetText( "You don't have an extra container to put your cargo on!" )
		ExtraSheet:AddItem(label);
	end
	
	BusinessSheet = vgui.Create( "DPanelList" )
	BusinessSheet:SetPadding(20);
	BusinessSheet:SetSpacing(20);
	BusinessSheet:EnableHorizontal(true);
	BusinessSheet:EnableVerticalScrollbar(true);

	for k, v in pairs(BusinessTable) do
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetSize( 32, 32 );
		spawnicon:SetIconSize( 32 )
		spawnicon:SetModel(v.Model);
		spawnicon:SetToolTip(v.Description);
				
		spawnicon.DoClick = function ( btn )
				
			local ContextMenu = DermaMenu()
			if(tonumber(LocalPlayer():GetNWString("money")) >= v.Price) then
				ContextMenu:AddOption("Purchase", function() LocalPlayer():ConCommand("rp_buyitem " .. v.Class); end);
			else
				ContextMenu:AddOption("Not Enough Tokens!");
			end
				
			ContextMenu:Open();
					
		end
				
		spawnicon.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name .. " (" .. v.Price .. ")") / 2, 5);
			surface.DrawText(v.Name .. " (" .. v.Price .. ")")
		end
				
		spawnicon.PaintOverHovered = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name .. " (" .. v.Price .. ")") / 2, 5);
			surface.DrawText(v.Name .. " (" .. v.Price .. ")")
		end
				
		BusinessSheet:AddItem(spawnicon);
	end
	
	Inventory:AddSheet( "Backpack", InventorySheet, "gui/silkicons/box", false, false, "View your inventory.")
	Inventory:AddSheet( "Business", BusinessSheet, "gui/silkicons/box", false, false, "View your store.")
	Inventory:AddSheet( "Extra Cargo", ExtraSheet, "gui/silkicons/box", false, false, "Open your additional cargohold.")
	
	Scoreboard = vgui.Create( "DPanelList" )
	Scoreboard:SetPadding(0);
	Scoreboard:SetSpacing(0);

	-- Let's draw the SCOREBOARD.
	
	for k, v in pairs(player.GetAll()) do
		local DataList = vgui.Create("DPanelList");
		DataList:SetAutoSize( true )
		
		local CollapsableCategory = vgui.Create("DCollapsibleCategory");
		CollapsableCategory:SetExpanded( 0 )
		CollapsableCategory:SetLabel( v:Nick() );
		Scoreboard:AddItem(CollapsableCategory);
		
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetModel(v:GetModel());
		spawnicon:SetSize( 64, 64 );
		DataList:AddItem(spawnicon);
		
		local DataList2 = vgui.Create( "DPanelList" )
		DataList2:SetAutoSize( true )
		
		local label = vgui.Create("DLabel");
		label:SetText("OOC Name: " .. v:Name());
		DataList2:AddItem(label);
		
		local label2 = vgui.Create("DLabel");
		label2:SetText("Title: " .. v:GetNWString("title"));
		DataList2:AddItem(label2);
		
		local label3 = vgui.Create("DLabel");
		label3:SetText("Title2: " .. v:GetNWString("title2"));
		DataList2:AddItem(label3);
		
		local Divider = vgui.Create("DHorizontalDivider");
		Divider:SetLeft(spawnicon);
		Divider:SetRight(DataList2);
		Divider:SetLeftWidth(64);
		Divider:SetHeight(64);
		
		DataList:AddItem(spawnicon);
		DataList:AddItem(DataList2);
		DataList:AddItem(Divider);
		
		CollapsableCategory:SetContents(DataList);
	end
	
	Clothing = vgui.Create( "DPropertySheet" )
	
	ClothingSheet = vgui.Create( "DPanelList" )
	ClothingSheet:SetPadding(0);
	ClothingSheet:SetSpacing(0);
	ClothingSheet:EnableHorizontal(false);
	ClothingSheet:EnableVerticalScrollbar(false)
	
	local desc = ""
	
	ClothingMdlPanel = vgui.Create( "DModelPanel" )
	ClothingMdlPanel:SetSize( 200, 200 )
	if CAKE.Clothing == "none" then
		ClothingMdlPanel:SetModel( LocalPlayer():GetNWString( "model", "models/kleiner.mdl" ) )
	else
		for k, v in pairs( InventoryTable ) do
			if v.Class == CAKE.Clothing then
				ClothingMdlPanel:SetModel( v.Model )
				desc = v.Description
				break
			end
		end
	end
	ClothingMdlPanel:SetAnimSpeed( 0.0 )
	ClothingMdlPanel:SetAnimated( false )
	ClothingMdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	ClothingMdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	ClothingMdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	ClothingMdlPanel:SetCamPos( Vector( 50, 0, 50 ) )
	ClothingMdlPanel:SetLookAt( Vector( 0, 0, 50 ) )
	ClothingMdlPanel:SetFOV( 70 )
	ClothingMdlPanel.PaintOver = function()
		surface.SetTextColor(Color(255,255,255,255));
		surface.SetFont("UiBold");
		surface.SetTextPos( surface.GetTextSize( desc ) , 260 );
		surface.DrawText(desc)
	end
	
	ClothingBox = vgui.Create("DListView");
	ClothingBox:SetMultiSelect( false )
	ClothingBox:SetSize(310,130);
	ClothingBox:AddColumn("Item Name");
	ClothingBox:AddColumn("Item Class");
	ClothingBox:AddLine( "Default Clothes", "none" )
	for k, v in pairs( InventoryTable ) do
		if( string.match( v.Class, "clothing" ) ) then
			ClothingBox:AddLine( v.Name, v.Class )
		end
	end
	ClothingBox.DoDoubleClick = function(parent, index, list)
		if list:GetValue(2) == "none" then
			CAKE.Clothing = "none"
			desc = ""
			LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
			ClothingMdlPanel:SetModel( LocalPlayer():GetNWString( "model", "models/kleiner.mdl" ) )
		else
			for k, v in pairs( InventoryTable ) do
				if v.Class == list:GetValue(2) then
					ClothingMdlPanel:SetModel( v.Model )
					CAKE.Clothing = v.Class
					desc = v.Description
					--LocalPlayer():ConCommand("rp_setclothing " .. TeamTable[LineID].flagkey);
					LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
				end
			end
		end
		
	end
	ClothingSheet:AddItem( ClothingBox )
	ClothingSheet:AddItem( ClothingMdlPanel )
	
	Clothing:AddSheet( "Clothing/Armor", ClothingSheet, "gui/silkicons/user", false, false, "Set your clothes")
	
	HelmetSheet = vgui.Create( "DPanelList" )
	HelmetSheet:SetPadding(0);
	HelmetSheet:SetSpacing(00);
	HelmetSheet:EnableHorizontal(false);
	HelmetSheet:EnableVerticalScrollbar(true);
	
	HelmetMdlPanel = vgui.Create( "DModelPanel" )
	HelmetMdlPanel:SetSize( 250, 250 )
	if CAKE.Clothing == "none" then
		HelmetMdlPanel:SetModel( LocalPlayer():GetNWString( "model", "models/kleiner.mdl" ) )
	else
		for k, v in pairs( InventoryTable ) do
			if v.Class == CAKE.Clothing then
				HelmetMdlPanel:SetModel( v.Model )
				desc = v.Description
				break
			end
		end
	end
	HelmetMdlPanel:SetAnimSpeed( 0.0 )
	HelmetMdlPanel:SetAnimated( false )
	HelmetMdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	HelmetMdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	HelmetMdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	HelmetMdlPanel:SetCamPos( Vector( 50, 0, 60)  )
	HelmetMdlPanel:SetLookAt( Vector( 0, 0, 60 ) )
	HelmetMdlPanel:SetFOV( 40 )
	HelmetMdlPanel.PaintOver = function()
		surface.SetTextColor(Color(255,255,255,255));
		surface.SetFont("UiBold");
		surface.SetTextPos( surface.GetTextSize( desc ) , 260 );
		surface.DrawText(desc)
	end
	
	local Helmets = vgui.Create("DListView");
	Helmets:SetMultiSelect( false )
	Helmets:SetSize(310,130);
	Helmets:AddColumn( "Item Name" )
	Helmets:AddColumn( "Item Class" )
	Helmets:AddLine( "Default Helmet/Face", "none" )
	for k, v in pairs( InventoryTable ) do
		if( string.match( v.Class, "helmet" ) ) then
			Helmets:AddLine( v.Name, v.Class )
		end
	end
	Helmets.DoDoubleClick = function(parent, index, list)
		if list:GetValue(2) == "none" then
			CAKE.Helmet = "none"
			desc = ""
			LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
			HelmetMdlPanel:SetModel( LocalPlayer():GetNWString( "model", "models/kleiner.mdl" ) )
		else
			for k, v in pairs( InventoryTable ) do
				if v.Class == list:GetValue(2) then
					HelmetMdlPanel:SetModel( v.Model )
					CAKE.Helmet = v.Class
					desc = v.Description
					--LocalPlayer():ConCommand("rp_setclothing " .. TeamTable[LineID].flagkey);
					LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
				end
			end
		end
		
	end
	
	HelmetSheet:AddItem( Helmets )
	HelmetSheet:AddItem( HelmetMdlPanel )
	
	Clothing:AddSheet( "Helmets", HelmetSheet, "gui/silkicons/user", false, false, "Set your helmet")
	
	local Help = vgui.Create( "DPanelList" )
	Help:SetPadding(20);
	Help:EnableHorizontal(false);
	Help:EnableVerticalScrollbar(true);
	local html = vgui.Create( "HTML")
	html:SetPos(0,30)
	html:SetSize(256, 370)
	html:OpenURL( "http://blissrp.wikia.com/" )
	Help:AddItem( html )
	
    BizPanel = vgui.Create( "DPropertySheet" )
    BizPanel:SetPos( 0, 0 )
	   
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
	
	--Business:AddItem( MyBiz )

	BizPanel:AddSheet( "My Group", MyBiz, "gui/silkicons/group", false, false, "The group which you belong");
	BizPanel:AddSheet( "Search Groups", SearchBiz, "gui/silkicons/magnifier", false, false, "Search all groups");
	
	PropertySheet:AddSheet( "Player Menu", PlayerInfo, "gui/silkicons/user", false, false, "General information.");
	PropertySheet:AddSheet( "Character Menu", CharPanel, "gui/silkicons/group", false, false, "Switch to another character or create a new one.");
	--PropertySheet:AddSheet( "Commands/Flagging", Commands, "gui/silkicons/wrench", false, false, "Execute some common commands or set your flag.");
	PropertySheet:AddSheet( "Inventory", Inventory, "gui/silkicons/box", false, false, "View your inventory.")
	--PropertySheet:AddSheet( "Business", Business, "gui/silkicons/box", false, false, "Purchase items.");
	PropertySheet:AddSheet( "Clothing", Clothing, "gui/silkicons/anchor", false, false, "Change your clothes." )
	PropertySheet:AddSheet( "Scoreboard", Scoreboard, "gui/silkicons/application_view_detail", false, false, "View the scoreboard.");		
	PropertySheet:AddSheet( "INFO.Net", Help, "gui/silkicons/magnifier", false, false, "Get some information about Bliss");
	PropertySheet:AddSheet( "Groups", BizPanel, "gui/silkicons/group", false, false, "Armies, corporations and businesses.");
end
usermessage.Hook("playermenu", CreatePlayerMenu);