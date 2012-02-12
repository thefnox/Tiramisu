CLPLUGIN.Name = "Clientside Group Utilities"
CLPLUGIN.Author = "FNox"

CAKE.Groups = {}
CAKE.ActiveGroup = "none"
CAKE.RankPermissions = {}

datastream.Hook( "TiramisuAddToGroupChat", function( handler, id, encoded, decoded )
	
	local color = decoded.color
	local playername = decoded.name
	local text = decoded.text
	local channel = decoded.channel
	local handler = decoded.handler

	text = text:gsub("<%s*%w*%s*=%s*%w*%s*>", "")
	text = text:gsub("</font>", "")
	text = text:gsub("<%s*%w*%s*=%s*%w*%s*,%s*%w*%s*,%s*%w*%s*,%s*%w*%s*>", "")
	text = text:gsub("</color>", "")
	CAKE.Chatbox:AddLine(  "<font=TiramisuOOCFont><color=" .. tostring( color.r ) .. "," .. tostring( color.g ) .. "," .. tostring( color.b ) .. ">".. playername .. "</color><color=white>:" .. text .. "</color></font>", channel, handler or "/g " )

	text = "[" .. channel .. "]" .. playername .. ": " .. text

	for i = 0, text:len() / 255 do
		MsgN(string.sub( text, i * 255 + 1, i * 255 + 255 ) )
	end
end)

datastream.Hook( "Tiramisu.ReceiveGroups", function( handler, id, encoded, decoded )

	CAKE.Groups = decoded["groups"]
	CAKE.ActiveGroup = decoded["activegroup"]
	CAKE.RankPermissions = decoded["rankpermissions"]

end )

datastream.Hook( "Tiramisu.EditGroup", function( handler, id, encoded, decoded )
	CAKE.EditGroup( decoded )
end)

datastream.Hook( "Tiramisu.GetGroupInfo", function( handler, id, encoded, decoded )
	CAKE.OpenGroupInfo( decoded )
end)

datastream.Hook( "Tiramisu.GetRanksToPromote", function( handler, id, encoded, decoded )
	if table.Count(tbl.ranks) > 1 then
		CAKE.ChoiceRequest( "Confirm Promotion",
		"Select the rank you want to promote " .. tbl.target:Nick() .. " to, then press 'Accept'" ,
		tbl.ranks,
			function( choice ) RunConsoleCommand( "rp_promote", choice ) end,
		function( choice ) end,
		"Accept",
		"Cancel")
	end
end)

usermessage.Hook( "Tiramisu.GetInvite", function( um )
	local ply = um:ReadEntity()
	local uid = um:ReadString()
	local name = um:ReadString()

	CAKE.Query( "You have been invited to join group: " .. name .. ", accept?", "Group Invite",
		"Accept", function() RunConsoleCommand( "rp_joingroup", uid, CAKE.FormatText(ply:SteamID()))end, 
		"Deny",	function() end)
end)

usermessage.Hook( "Tiramisu.GroupCreateQuery", function( um )
	CAKE.BeginGroupCreation( um:ReadString() )
end)

function CAKE.AddRank( tbl )
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

	local CanEdit = vgui.Create( "DCheckBoxLabel" )
	CanEdit:SetText("Can edit the group's data")
	CanEdit:SetValue(0)
	CanEdit.OnChange = function( panel, value )
		rank["canedit"] = CanEdit:GetChecked()
	end
	Permissions:AddItem(CanEdit)

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
			CAKE.EditGroup( tbl )
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
		CAKE.EditGroup( tbl )
		frame:Remove()
	end
end

function CAKE.EditRank( tbl, rankname )

	local rank = table.Copy(tbl["ranks"][rankname])

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

	local DefaultGroup = vgui.Create("DButton")
	DefaultGroup:SetText("Set As Default Group")
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

	local CanEdit = vgui.Create( "DCheckBoxLabel" )
	CanEdit:SetText("Can edit the group's data")
	CanEdit:SetValue(0)
	CanEdit.OnChange = function( panel, value )
		rank["canedit"] = CanEdit:GetChecked()
	end
	Permissions:AddItem(CanEdit)

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

	local Accept = vgui.Create( "DButton", Buttons )
	Accept:SetText( "Accept Changes" )
	Accept:Dock( LEFT )
	Accept:SetTall( 30 )
	Accept:SetWide( 100 )
	Accept:DockMargin( 20, 2, 5, 2 )
	Accept.DoClick = function()
		tbl["ranks"][rankname] = rank
		CAKE.EditGroup( tbl )
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
		CAKE.EditGroup( tbl )
	end

end

function CAKE.EditGroup( tbl )
	if EditGroup then
		EditGroup:Remove()
	end
	EditGroup = vgui.Create( "DFrame" )
	EditGroup:SetSize( 650, 560 )
	EditGroup:SetTitle( "Editing Group: " .. tbl.uid )
	EditGroup:SetVisible( true )
	EditGroup:SetDraggable( true )
	EditGroup:ShowCloseButton( false )
	EditGroup:SetDeleteOnClose( true )
	EditGroup:MakePopup()
	EditGroup:Center()

	local title = Label( "Editing group: " .. tbl.name , EditGroup)
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
		title:SetText("Editing group: " .. Name:GetValue())
		title:SizeToContents()
	end
	NameForm:AddItem(Name)

	Group:AddItem(NameForm)

	local DescForm = vgui.Create( "DForm" )
	DescForm:SetName( "Description:" )
	DescForm:SetSpacing( 5 )
	DescForm:SetPadding( 5 )

	local Desc = vgui.Create( "DTextEntry" )
	Desc:SetTall( 300 )
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
			CAKE.EditRank( tbl, line:GetValue(1) )
			EditGroup:Remove()
			EditGroup = nil
		end
		RanksForm:AddItem( Ranks )
	end

	local AddRank = vgui.Create( "DButton" )
	AddRank:SetText( "Add a rank" )
	AddRank:SetTall( 30 )
	AddRank.DoClick = function()
		CAKE.AddRank( tbl )
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
		datastream.StreamToServer( "Tiramisu.GetEditGroup", tbl )
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

function CAKE.OpenGroupInfo( tbl )
	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 500, 340 )
	PlayerMenu:SetTitle( "Group" )
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
	description:SetText(tbl.description .. "\n\nFounded by: " .. tbl.founder )
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
		CAKE.Message( "Feature isn't done yet.", "Error!", "OK" )
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

	if tbl.canedit then
		local EditGroup = vgui.Create( "DButton" )
		EditGroup:SetText( "Edit Group Info" )
		EditGroup:SetTall( 30 )
		EditGroup.DoClick = function()
			RunConsoleCommand("rp_editgroup", tbl.uid)
			PlayerMenu:Remove()
			PlayerMenu = nil
		end
		actions:AddItem(EditGroup)
	end

	local LeaveGroup = vgui.Create( "DButton" )
	LeaveGroup:SetText( "Leave Group" )
	LeaveGroup:SetTall( 30 )
	LeaveGroup.DoClick = function()
		CAKE.Query( "Are you sure you want to leave " .. tbl.name .. "?", "Leaving a group",
			"Yes",	function() PlayerMenu:Remove() RunConsoleCommand("rp_leavegroup", tbl.uid) end, 
			"No",	function() end )
	end
	actions:AddItem(LeaveGroup)

end
/*
 CAKE.EditGroup( {
    ["name"] = "bob",
    ["uid"] = "0",
    ["description"] = "none available",
    ["ranks"] = {}
} )*/

function CAKE.GetRankPermission( name )
	if CAKE.Groups and CAKE.ActiveGroup != "none" and CAKE.RankPermissions then
		return CAKE.RankPermissions[name]
	end
	return false
end

function CAKE.BeginGroupCreation( title )
	CAKE.StringRequest( "Group Creation", "Please enter the name of the group you want to create", title or "New Group",
	function( entry )
		RunConsoleCommand( "rp_creategroup", entry )
	end,
	function() end, "Create Group", "Cancel" )
end

local function OpenGroups()

	if table.Count(CAKE.Groups) < 1 then
		CAKE.Query( "You do not currently belong to any groups, would you like to create one?", "Groups",
		"Yes", function() CAKE.BeginGroupCreation() end, 
		"No",	function() end)
	elseif table.Count(CAKE.Groups) == 1 then
		RunConsoleCommand("rp_getgroupinfo", CAKE.ActiveGroup)
	elseif table.Count(CAKE.Groups) > 1 then
		PlayerMenu = vgui.Create( "DFrame" )
		PlayerMenu:SetSize( 300, 200 )
		PlayerMenu:SetTitle( "Group Selection" )
		PlayerMenu:SetVisible( true )
		PlayerMenu:SetDraggable( true )
		PlayerMenu:ShowCloseButton( true )
		PlayerMenu:SetDeleteOnClose( true )
		PlayerMenu:Center()

		local label = Label( "Select which group to open:", PlayerMenu)
		label:Dock(TOP )

		local Groups = vgui.Create( "DListView" )
		Groups:SetParent( PlayerMenu )
		Groups:Dock(FILL)
		Groups:SetMultiSelect( false )
		Groups:AddColumn("UniqueID")
		Groups:AddColumn("Name")
		for k, v in pairs( CAKE.Groups ) do
			Groups:AddLine( k, v )
		end
		Groups.OnClickLine = function(parent, line, isselected)
			RunConsoleCommand("rp_getgroupinfo", line:GetValue(1))
			PlayerMenu:Remove()
			PlayerMenu = nil
		end
	end

end

local function CloseGroups()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
function CLPLUGIN.Init()
	CAKE.RegisterMenuTab( "Groups", OpenGroups, CloseGroups )
end
