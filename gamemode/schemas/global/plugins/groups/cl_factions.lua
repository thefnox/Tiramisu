CAKE.Factions = {}

datastream.Hook( "Tiramisu.GetFactionInfo", function( handler, id, encoded, decoded )
	CAKE.OpenFactionInfo( decoded )
end)

datastream.Hook( "Tiramisu.EditFaction", function( handler, id, encoded, decoded )
	CAKE.EditFaction( decoded )
end)

datastream.Hook( "Tiramisu.ReceiveFactions", function( handler, id, encoded, decoded )
	CAKE.Factions = decoded
end)

usermessage.Hook( "Tiramisu.FactionCreateQuery", function( um )
	CAKE.BeginFactionCreation( um:ReadString() )
end)

function CAKE.BeginFactionCreation( title )
	CAKE.StringRequest( "Faction Creation", "Please enter the name of the faction you want to create", title or "New Faction",
	function( entry )
		RunConsoleCommand( "rp_createfaction", entry )
	end,
	function() end, "Create Faction", "Cancel" )
end

local list
function CAKE.OpenWeaponList( tbl )
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 300, 250 )
	frame:SetTitle( "Select which weapons to make available" )
	frame:Center()
	frame:MakePopup()
	frame:SetSizable( true )

	list = vgui.Create( "DListView", frame )
	list:Dock( FILL )
	list:SetSortable( true )
	list:SetMultiSelect( true )
	list:AddColumn( "Class" )
	list:AddColumn( "Name" )

	function list:OnClickLine( Line )
		Line:SetSelected( !Line:GetSelected() )
		Line.m_fClickTime = SysTime()

		self:OnRowSelected( Line:GetID(), Line )
	end

	local line
	for k, weapon in pairs(weapons.GetList()) do
		line = list:AddLine( weapon.ClassName, weapon.PrintName )
		if table.HasValue(tbl, weapon.ClassName) then
			line:SetSelected( true )
		end
	end

	frame.Close = function()
		CAKE.Query( "Save changes to weapon loadout?", "Save changes",
		"Yes",	function()
			table.Empty(tbl)
			for k, line in pairs(list.Lines) do
				if line and line:GetSelected() then
					table.insert(tbl, line:GetValue(1)) 
				end
			end
			frame:Remove()
			frame = nil
		end, 
		"No",	function()
			frame:Remove()
			frame = nil
		end )
	end
end

function CAKE.OpenItemList( tbl )
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 300, 250 )
	frame:SetTitle( "Select which items to make available" )
	frame:Center()
	frame:MakePopup()
	frame:SetSizable( true )

	list = vgui.Create( "DListView", frame )
	list:Dock( FILL )
	list:SetSortable( true )
	list:SetMultiSelect( true )
	list:AddColumn( "Class" )
	list:AddColumn( "Name" )

	function list:OnClickLine( Line )
		Line:SetSelected( !Line:GetSelected() )
		Line.m_fClickTime = SysTime()

		self:OnRowSelected( Line:GetID(), Line )
	end

	local line
	for k, item in pairs(CAKE.ItemData) do
		line = list:AddLine( k, item.Name )
		if table.HasValue(tbl, k) then
			line:SetSelected( true )
		end
	end

	frame.Close = function()
		CAKE.Query( "Save changes to item loadout?", "Save changes",
		"Yes",	function()
			table.Empty(tbl)
			for k, line in pairs(list.Lines) do
				if line and line:GetSelected() then
					table.insert(tbl, line:GetValue(1)) 
				end
			end
			frame:Remove()
			frame = nil
		end, 
		"No", function()
			frame:Remove()
			frame = nil 
		end )
	end
end

function CAKE.OpenFactionInfo( tbl )
	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 500, 340 )
	PlayerMenu:SetTitle( "Faction" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()

	local title = Label( tbl.name, PlayerMenu)
	title:SetFont( "Tiramisu48Font")
	title:SetPos( 10, 23 )
	title:SizeToContents()

	local subtitle = Label( "UID:" .. tbl.uid, PlayerMenu)
	subtitle:SetPos( 10, 66 )
	subtitle:SetFont( "Tiramisu24Font")
	subtitle:SizeToContents()

	local info = vgui.Create("DPanelList", PlayerMenu)
	info:SetSpacing( 10 )
	info:SetPadding( 10 )
	info.Paint = function() end
	info:EnableHorizontal(false)
	info:EnableVerticalScrollbar(true)
	info:SetAutoSize(false)
	info:Dock( LEFT )
	info:SetWidth( 310 )
	info:DockMargin( 0,70,5,0 )

	local description = vgui.Create( "DLabel" )
	description:SetAutoStretchVertical( true )
	description:SetText(tbl.description)
	description:SetFont("Tiramisu16Font")
	description:SetWrap(true)

	info:AddItem(description)

	local actions = vgui.Create( "DForm", PlayerMenu )
	actions:Dock( FILL )
	actions:DockMargin( 0, 70, 0, 0 )
	--actions.Paint = function() end
	actions:SetName( "Actions:" )
	actions:SetPadding(5)
	actions:SetSpacing(10)

	local FindPlayer = vgui.Create( "DButton" )
	FindPlayer:SetText( "Find A Player" )
	FindPlayer:SetTall( 30 )
	FindPlayer.DoClick = function()
		CAKE.StringRequest( "Find A Player", 
			"Enter the name, rank, or SteamID of the player you want to find:", 
			LocalPlayer():Nick(), 
			function( str ) RunConsoleCommand("rp_rostersearch", tbl.uid, str) end,
			function()end,
			"Search", 
		"Cancel" )
	end
	actions:AddItem(FindPlayer)

	local OpenChat = vgui.Create( "DButton" )
	OpenChat:SetText( "Open Group Chat" )
	OpenChat:SetTall( 30 )
	OpenChat.DoClick = function()
		if CAKE.Chatbox then
			CAKE.Chatbox:AddChannel( "[" .. tbl.name .. "]", "Group: " .. tbl.uid, "/g " .. tbl.uid .. " " )
		end
	end
	actions:AddItem(OpenChat)

	local OpenInventory = vgui.Create( "DButton" )
	OpenInventory:SetText( "Open Group Inventory" )
	OpenInventory:SetTall( 30 )
	OpenInventory.DoClick = function()
		CAKE.Message( "Feature isn't done yet.", "Error!", "OK" )
	end
	actions:AddItem(OpenInventory)

	local LeaveGroup = vgui.Create( "DButton" )
	LeaveGroup:SetText( "Leave Group" )
	LeaveGroup:SetTall( 30 )
	LeaveGroup.DoClick = function()
		CAKE.Query( "Are you sure you want to leave " .. tbl.name .. "?", "Leaving a group",
			"Yes",	function() PlayerMenu:Remove() RunConsoleCommand("rp_leavegroup", tbl.uid) end, 
			"No",	function() end )
	end
	actions:AddItem(LeaveGroup)

	local SetActive = vgui.Create( "DButton" )
	SetActive:SetText( "Set As Active Group" )
	SetActive:SetTall( 30 )
	if CAKE.ActiveGroup == tbl.uid then
		SetActive:SetText("Currently Active Group")
		SetActive:SetDisabled( true ) 
	end
	SetActive.DoClick = function()
		if !SetActive:GetDisabled() then
			CAKE.Query( "Make " .. tbl.name .. " your active group?", "Active Group",
				"Yes",	function() RunConsoleCommand("rp_setactivegroup", tbl.uid) SetActive:SetText("Currently Active Group") SetActive:SetDisabled( true ) end, 
				"No",	function() end )
		end
	end
	actions:AddItem(SetActive)

end

function CAKE.AddFactionRank( tbl )
	local rank = {}
	rank["canedit"] = false
	rank["caninvite"] = false
	rank["cankick"] = false
	rank["canpromote"] = false
	rank["cantakeinventory"] = false
	rank["canplaceinventory"] = false
	rank["level"] = 0
	rank["name"] = "New Rank"
	rank["handler"] = "none"
	rank["description"] = "None Available"
	rank["weapons"] = {}
	rank["loadout"] = {}

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 500, 300)
	frame:SetTitle("Creating a rank")
	frame:ShowCloseButton( false )
	frame:SetDeleteOnClose( true )
	frame:MakePopup()
	frame:Center()

	local Buttons = vgui.Create( "DPanel", frame )
	Buttons.Paint = function() end
	Buttons:Dock( BOTTOM )
	Buttons:SetTall(40)
	Buttons:DockMargin( frame:GetWide()/5, 0, frame:GetWide()/5, 0 )

	local Info = vgui.Create( "DPanelList", frame )
	Info:Dock( LEFT )
	Info:SetWidth( 230 )
	Info.Paint = function() end
	Info:DockMargin( 0, 0, 5, 0 )
	Info:SetPadding(5)
	Info:SetSpacing(5)
	Info:EnableHorizontal(false)
	Info:EnableVerticalScrollbar(true)
	Info:SetAutoSize(false)

	local InfoForm = vgui.Create( "DForm" )
	InfoForm:SetName( "Info:" )
	InfoForm:SetSpacing( 5 )
	InfoForm:SetPadding( 5 )

	local DescForm = vgui.Create( "DForm" )
	DescForm:SetName( "Description:" )
	DescForm:SetSpacing( 5 )
	DescForm:SetPadding( 5 )

	InfoForm:AddItem(Label("Name:"))
	local Name = vgui.Create( "DTextEntry" )
	Name:SetValue( rank.name ) 
	Name:SetDrawBackground( false )
	Name.OnTextChanged = function()
		rank["name"] = Name:GetValue()
	end
	InfoForm:AddItem(Name)

	InfoForm:AddItem(Label("Handler:"))
	local Handler = vgui.Create( "DTextEntry" )
	Handler:SetValue( rank.handler ) 
	Handler:SetDrawBackground( false )
	Handler.OnTextChanged = function()
		rank["handler"] = Handler:GetValue()
	end
	InfoForm:AddItem(Handler)

	local Level = vgui.Create( "DNumSlider", DermaPanel )
	Level:SetValue(0)
	Level:SetText( "Level (In rank hirearchy)" )
	Level:SetMin( 0 ) -- Minimum number of the slider
	Level:SetMax( 50 ) -- Maximum number of the slider
	Level:SetDecimals( 0 ) -- Sets a decimal. Zero means it's a whole number
	Level.OnValueChanged = function( panel, value )
		rank["level"] = value
	end
	InfoForm:AddItem(Level)

	local Desc = vgui.Create( "DTextEntry" )
	Desc:SetTall( 120 )
	Desc:SetValue( rank["description"] ) 
	Desc:SetMultiline( true )
	Desc:SetDrawBackground( false )
	Desc.OnTextChanged = function()
		rank["description"] = Desc:GetValue()
	end
	DescForm:AddItem(Desc)

	Info:AddItem(InfoForm)
	Info:AddItem(DescForm)

	local Permissions = vgui.Create( "DForm", frame )
	Permissions:Dock( FILL )
	Permissions:DockMargin( 0, 0, 0, 0 )
	--Permissions.Paint = function() end
	Permissions:SetName( "Permissions:" )
	Permissions:SetPadding(5)
	Permissions:SetSpacing(5)

	local CanInvite = vgui.Create( "DCheckBoxLabel" )
	CanInvite:SetText("Can invite people to join")
	CanInvite:SetValue(0)
	CanInvite.OnChange = function( panel, value )
		rank["caninvite"] = CanInvite:GetChecked()
	end
	Permissions:AddItem(CanInvite)

	local CanKick = vgui.Create( "DCheckBoxLabel" )
	CanKick:SetText("Can kick people off the group")
	CanKick:SetValue(0)
	CanKick.OnChange = function( panel, value )
		rank["cankick"] = CanKick:GetChecked()
	end
	Permissions:AddItem(CanKick)

	local CanPromote = vgui.Create( "DCheckBoxLabel" )
	CanPromote:SetText("Can promote people to higher ranks")
	CanPromote:SetValue(0)
	CanPromote.OnChange = function( panel, value )
		rank["canpromote"] = CanPromote:GetChecked()
	end
	Permissions:AddItem(CanPromote)

	local CanTakeInventory = vgui.Create( "DCheckBoxLabel" )
	CanTakeInventory:SetText("Can take things off the inventory")
	CanTakeInventory:SetValue(0)
	CanTakeInventory.OnChange = function( panel, value )
		rank["cantakeinventory"] = CanTakeInventory:GetChecked()
	end
	Permissions:AddItem(CanTakeInventory)

	local CanPlaceInventory = vgui.Create( "DCheckBoxLabel" )
	CanPlaceInventory:SetText("Can place things in the inventory")
	CanPlaceInventory:SetValue(0)
	CanPlaceInventory.OnChange = function( panel, value )
		rank["canedit"] = CanPlaceInventory:GetChecked()
	end
	Permissions:AddItem(CanPlaceInventory)

	local ItemLoadout = vgui.Create( "DButton" )
	ItemLoadout:SetText( "Edit Item Loadout" )
	ItemLoadout.DoClick = function()
		CAKE.OpenItemList( rank["loadout"] )
	end	
	Permissions:AddItem(ItemLoadout)

	local WeaponLoadout = vgui.Create( "DButton" )
	WeaponLoadout:SetText( "Edit Weapon Loadout" )
	WeaponLoadout.DoClick = function()
		CAKE.OpenWeaponList( rank["weapons"] )
	end	
	Permissions:AddItem(WeaponLoadout)

	local Accept = vgui.Create( "DButton", Buttons )
	Accept:SetText( "Accept, create rank" )
	Accept:Dock( LEFT )
	Accept:SetTall( 30 )
	Accept:SetWide( 100 )
	Accept:DockMargin( 20, 2, 5, 2 )
	Accept.DoClick = function()
		if tbl["ranks"][rank.handler] then
			CAKE.Message( "Handler already exists! Please choose a new one.", "Error!", "OK" )
		else
			if tbl["defaultrank"] == "none" then
				tbl["defaultrank"] = rank.handler
			end
			tbl["ranks"][rank.handler] = rank
			CAKE.EditFaction( tbl )
			frame:Remove()
			frame = nil
		end
	end

	local Cancel = vgui.Create( "DButton", Buttons )
	Cancel:SetText( "Cancel" )
	Cancel:Dock( FILL )
	Cancel:SetTall( 30 )
	Cancel:DockMargin( 20, 2, 20, 2 )
	Cancel.DoClick = function()
		CAKE.EditFaction( tbl )
		frame:Remove()
	end
end


function CAKE.EditFactionRank( tbl, rankname )

	local rank = table.Copy(tbl["ranks"][rankname])

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 500, 300)
	frame:SetTitle("Editing a rank")
	frame:ShowCloseButton( false )
	frame:SetDeleteOnClose( true )
	frame:MakePopup()
	frame:Center()

	local Buttons = vgui.Create( "DPanel", frame )
	Buttons.Paint = function() end
	Buttons:Dock( BOTTOM )
	Buttons:SetTall(40)
	Buttons:DockMargin( frame:GetWide()/5, 0, frame:GetWide()/5, 0 )

	local Info = vgui.Create( "DPanelList", frame )
	Info:Dock( LEFT )
	Info:SetWidth( 230 )
	Info.Paint = function() end
	Info:DockMargin( 0, 0, 5, 0 )
	Info:SetPadding(5)
	Info:SetSpacing(5)
	Info:EnableHorizontal(false)
	Info:EnableVerticalScrollbar(true)
	Info:SetAutoSize(false)

	local InfoForm = vgui.Create( "DForm" )
	InfoForm:SetName( "Info:" )
	InfoForm:SetSpacing( 5 )
	InfoForm:SetPadding( 5 )

	local DescForm = vgui.Create( "DForm" )
	DescForm:SetName( "Description:" )
	DescForm:SetSpacing( 5 )
	DescForm:SetPadding( 5 )

	InfoForm:AddItem(Label("Name:"))
	local Name = vgui.Create( "DTextEntry" )
	Name:SetValue( rank.name ) 
	Name:SetDrawBackground( false )
	Name.OnTextChanged = function()
		rank["name"] = Name:GetValue()
	end
	InfoForm:AddItem(Name)

	local DefaultGroup = vgui.Create("DButton")
	DefaultGroup:SetText("Set As Default Rank")
	DefaultGroup.DoClick = function()
		tbl["defaultrank"] = rank.handler
	end
	InfoForm:AddItem(DefaultGroup)

	local Level = vgui.Create( "DNumSlider", DermaPanel )
	Level:SetValue(0)
	Level:SetText( "Level (In rank hirearchy)" )
	Level:SetMin( 0 ) -- Minimum number of the slider
	Level:SetMax( 50 ) -- Maximum number of the slider
	Level:SetDecimals( 0 ) -- Sets a decimal. Zero means it's a whole number
	Level.OnValueChanged = function( panel, value )
		rank["level"] = value
	end
	InfoForm:AddItem(Level)

	local Desc = vgui.Create( "DTextEntry" )
	Desc:SetTall( 120 )
	Desc:SetValue( rank["description"] ) 
	Desc:SetMultiline( true )
	Desc:SetDrawBackground( false )
	Desc.OnTextChanged = function()
		rank["description"] = Desc:GetValue()
	end
	DescForm:AddItem(Desc)

	Info:AddItem(InfoForm)
	Info:AddItem(DescForm)

	local Permissions = vgui.Create( "DForm", frame )
	Permissions:Dock( FILL )
	Permissions:DockMargin( 0, 00, 0, 0 )
	--Permissions.Paint = function() end
	Permissions:SetName( "Permissions:" )
	Permissions:SetPadding(5)
	Permissions:SetSpacing(5)

	local CanInvite = vgui.Create( "DCheckBoxLabel" )
	CanInvite:SetText("Can invite people to join")
	CanInvite:SetValue(0)
	CanInvite.OnChange = function( panel, value )
		rank["caninvite"] = CanInvite:GetChecked()
	end
	Permissions:AddItem(CanInvite)

	local CanKick = vgui.Create( "DCheckBoxLabel" )
	CanKick:SetText("Can kick people off the group")
	CanKick:SetValue(0)
	CanKick.OnChange = function( panel, value )
		rank["cankick"] = CanKick:GetChecked()
	end
	Permissions:AddItem(CanKick)

	local CanPromote = vgui.Create( "DCheckBoxLabel" )
	CanPromote:SetText("Can promote people to higher ranks")
	CanPromote:SetValue(0)
	CanPromote.OnChange = function( panel, value )
		rank["canpromote"] = CanPromote:GetChecked()
	end
	Permissions:AddItem(CanPromote)

	local CanTakeInventory = vgui.Create( "DCheckBoxLabel" )
	CanTakeInventory:SetText("Can take things off the inventory")
	CanTakeInventory:SetValue(0)
	CanTakeInventory.OnChange = function( panel, value )
		rank["cantakeinventory"] = CanTakeInventory:GetChecked()
	end
	Permissions:AddItem(CanTakeInventory)

	local CanPlaceInventory = vgui.Create( "DCheckBoxLabel" )
	CanPlaceInventory:SetText("Can place things in the inventory")
	CanPlaceInventory:SetValue(0)
	CanPlaceInventory.OnChange = function( panel, value )
		rank["canedit"] = CanPlaceInventory:GetChecked()
	end
	Permissions:AddItem(CanPlaceInventory)

	local ItemLoadout = vgui.Create( "DButton" )
	ItemLoadout:SetText( "Edit Item Loadout" )
	ItemLoadout.DoClick = function()
		CAKE.OpenItemList( rank["loadout"] )
	end	
	Permissions:AddItem(ItemLoadout)

	local WeaponLoadout = vgui.Create( "DButton" )
	WeaponLoadout:SetText( "Edit Weapon Loadout" )
	WeaponLoadout.DoClick = function()
		CAKE.OpenWeaponList( rank["weapons"] )
	end	
	Permissions:AddItem(WeaponLoadout)

	local Accept = vgui.Create( "DButton", Buttons )
	Accept:SetText( "Accept Changes" )
	Accept:Dock( LEFT )
	Accept:SetTall( 30 )
	Accept:SetWide( 100 )
	Accept:DockMargin( 20, 2, 5, 2 )
	Accept.DoClick = function()
		tbl["ranks"][rankname] = rank
		CAKE.EditFaction( tbl )
		frame:Remove()
		frame = nil
	end

	local Cancel = vgui.Create( "DButton", Buttons )
	Cancel:SetText( "Cancel" )
	Cancel:Dock( FILL )
	Cancel:SetTall( 30 )
	Cancel:DockMargin( 20, 2, 20, 2 )
	Cancel.DoClick = function()
		frame:Remove()
		CAKE.EditFaction( tbl )
	end

end

function CAKE.EditFaction( tbl )
	if EditGroup then
		EditGroup:Remove()
	end
	EditGroup = vgui.Create( "DFrame" )
	EditGroup:SetSize( 650, 560 )
	EditGroup:SetTitle( "Editing Faction: " .. tbl.uid )
	EditGroup:SetVisible( true )
	EditGroup:SetDraggable( true )
	EditGroup:ShowCloseButton( false )
	EditGroup:SetDeleteOnClose( true )
	EditGroup:MakePopup()
	EditGroup:Center()

	local title = Label( "Editing faction: " .. tbl.name , EditGroup)
	title:SetFont( "Tiramisu48Font")
	title:SetPos( 10, 23 )
	title:SizeToContents()
	local subtitle = Label( "UID: " .. tbl.uid, EditGroup)
	subtitle:SetPos( 10, 66 )
	subtitle:SetFont( "Tiramisu24Font")
	subtitle:SizeToContents()

	local Buttons = vgui.Create( "DPanel", EditGroup )
	Buttons.Paint = function() end
	Buttons:Dock( BOTTOM )
	Buttons:SetTall(40)
	Buttons:DockMargin( EditGroup:GetWide()/5, 0, EditGroup:GetWide()/5, 0 )
	
	local Group = vgui.Create( "DPanelList", EditGroup )
	Group:Dock( LEFT )
	Group:SetWidth( 310 )
	Group.Paint = function() end
	Group:DockMargin( 0, 70, 5, 0 )
	Group:SetPadding(5)
	Group:SetSpacing(5)
	Group:EnableHorizontal(false)
	Group:EnableVerticalScrollbar(true)
	Group:SetAutoSize(false)

	local NameForm = vgui.Create( "DForm" )
	NameForm:SetName( "Name:" )
	NameForm:SetSpacing( 5 )
	NameForm:SetPadding( 5 )

	local Name = vgui.Create( "DTextEntry" )
	Name:SetValue( tbl.name ) 
	Name:SetDrawBackground( false )
	Name.OnTextChanged = function()
		tbl["name"] = Name:GetValue()
		title:SetText("Editing faction: " .. Name:GetValue())
		title:SizeToContents()
	end
	NameForm:AddItem(Name)

	Group:AddItem(NameForm)

	local HandlerForm = vgui.Create( "DForm" )
	HandlerForm:SetName( "Handler (Shorthand form of the name):" )
	HandlerForm:SetSpacing( 5 )
	HandlerForm:SetPadding( 5 )

	local Handler = vgui.Create( "DTextEntry" )
	Handler:SetValue( tbl.handler ) 
	Handler:SetDrawBackground( false )
	Handler.OnTextChanged = function()
		tbl["handler"] = Handler:GetValue()
	end
	HandlerForm:AddItem(Handler)

	Group:AddItem(HandlerForm)

	local DescForm = vgui.Create( "DForm" )
	DescForm:SetName( "Description:" )
	DescForm:SetSpacing( 5 )
	DescForm:SetPadding( 5 )

	local Desc = vgui.Create( "DTextEntry" )
	Desc:SetTall( 250 )
	Desc:SetValue( tbl.description ) 
	Desc:SetMultiline( true )
	Desc:SetDrawBackground( false )
	Desc.OnTextChanged = function()
		tbl["description"] = Desc:GetValue()
	end
	DescForm:AddItem(Desc)

	Group:AddItem(DescForm)

	local RanksForm = vgui.Create( "DForm", EditGroup )
	RanksForm:Dock( FILL )
	RanksForm:DockMargin( 0, 70, 0, 0 )
	--RanksForm.Paint = function() end
	RanksForm:SetName( "Ranks:" )
	RanksForm:SetPadding(5)
	RanksForm:SetSpacing(5)

	if table.Count( tbl.ranks ) > 0 then
		local Ranks = vgui.Create( "DListView" )
		Ranks:SetTall(320)
		Ranks:SetMultiSelect( false )
		Ranks:AddColumn("Handler")
		Ranks:AddColumn("Name")
		for k, v in pairs( tbl.ranks ) do
			if k != "founder" then
				Ranks:AddLine( k, v.name )
			end
		end
		Ranks.OnClickLine = function(parent, line, isselected)
			CAKE.EditFactionRank( tbl, line:GetValue(1) )
			EditGroup:Remove()
			EditGroup = nil
		end
		RanksForm:AddItem( Ranks )
	end

	local AddRank = vgui.Create( "DButton" )
	AddRank:SetText( "Add a rank" )
	AddRank:SetTall( 30 )
	AddRank.DoClick = function()
		CAKE.AddFactionRank( tbl )
		EditGroup:Remove()
		EditGroup = nil
	end
	RanksForm:AddItem( AddRank )

	local Accept = vgui.Create( "DButton", Buttons )
	Accept:SetText( "Accept Changes" )
	Accept:Dock( LEFT )
	Accept:SetTall( 30 )
	Accept:SetWide( 150 )
	Accept:DockMargin( 20, 2, 5, 2 )

	Accept.DoClick = function()
		datastream.StreamToServer( "Tiramisu.GetEditFaction", tbl )
		EditGroup:Remove()
		EditGroup = nil
	end

	local Cancel = vgui.Create( "DButton", Buttons )
	Cancel:SetText( "Cancel" )
	Cancel:Dock( FILL )
	Cancel:SetTall( 30 )
	Cancel:DockMargin( 20, 2, 20, 2 )
	Cancel.DoClick = function()
		EditGroup:Remove()
	end
end