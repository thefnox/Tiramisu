CLPLUGIN.Name = "Clientside Group Utilities"
CLPLUGIN.Author = "FNox"

CAKE.Groups = {}
CAKE.ActiveGroup = "none"
CAKE.RankPermissions = {}
CAKE.Factions = {}
CAKE.SpawnPoints = {}

-- datastream.Hook( "TiramisuAddToGroupChat", function( handler, id, encoded, decoded )
net.Receive( "TiramisuAddToGroupChat", function( len )
	local decoded = net.ReadTable( )
	local color = decoded.color
	local playername = decoded.name
	local text = decoded.text
	local channel = decoded.channel
	local handler = decoded.handler

	text = text:gsub("<%s*%w*%s*=%s*%w*%s*>", "")
	text = text:gsub("</font>", "")
	text = text:gsub("<%s*%w*%s*=%s*%w*%s*,%s*%w*%s*,%s*%w*%s*,%s*%w*%s*>", "")
	text = text:gsub("</color>", "")
	CAKE.Chatbox:AddLine(  channel, handler or "/g ", CAKE.TranslateMarkupToTable("<font=TiramisuOOCFontOutline><color=" .. tostring( color.r ) .. "," .. tostring( color.g ) .. "," .. tostring( color.b ) .. ">".. playername .. "</color><color=white>: " .. text .. "</color></font>" ))

	text = "[" .. channel .. "]" .. playername .. ": " .. text

end)

--datastream.Hook( "Tiramisu.ReceiveGroups", function( handler, id, encoded, decoded )
net.Receive( "Tiramisu.ReceiveGroups", function( len )
	local decoded = net.ReadTable( )

	CAKE.Groups = decoded["groups"]
	CAKE.ActiveGroup = decoded["activegroup"]
	CAKE.RankPermissions = decoded["rankpermissions"]
	CAKE.Factions = decoded["factions"]

end )

--datastream.Hook( "Tiramisu.EditGroup", function( handler, id, encoded, decoded )
--	CAKE.EditGroup( decoded )
net.Receive( "Tiramisu.EditGroup", function( len )
	CAKE.EditGroup( net.ReadTable( ) )
end)

--datastream.Hook( "Tiramisu.GetGroupInfo", function( handler, id, encoded, decoded )
--	CAKE.OpenGroupInfo( decoded )
net.Receive( "Tiramisu.GetGroupInfo", function( len )
	CAKE.OpenGroupInfo( net.ReadTable( ) )
end)

--datastream.Hook( "Tiramisu.EditCharInfo", function( handler, id, encoded, decoded )
--	if decoded then
--		CAKE.EditCharacterInfo( decoded )
net.Receive( "Tiramisu.EditCharInfo", function( len )
	local charInfo = net.ReadTable( )
	if charInfo then
		CAKE.EditCharacterInfo( charInfo )
	end
end)

--datastream.Hook( "Tiramisu.ReceiveSpawnPoints", function( handler, id, encoded, decoded )
--	CAKE.SpawnPoints = decoded
net.Receive( "Tiramisu.ReceiveSpawnPoints", function( len )
	CAKE.SpawnPoints = net.ReadTable( )
end)

--[[datastream.Hook( "Tiramisu.GetSearchResults", function( handler, id, encoded, decoded )
	local uid = decoded.uid
	if decoded.results then
		if table.Count( decoded.results ) == 1 then
			RunConsoleCommand( "rp_getcharinfo",uid ,CAKE.FormatText(decoded.results[1].SteamID) .. ";" .. decoded.results[1].uid )
		elseif table.Count( decoded) > 1 then ]]--
net.Receive( "Tiramisu.GetSearchResults", function( len )
	local uid = net.ReadString( )
	local results = net.ReadTable( )
	if results then
		if table.Count( results ) == 1 then
			RunConsoleCommand( "rp_getcharinfo",uid ,CAKE.FormatText(results[1].SteamID) .. ";" .. results[1].uid )
		elseif table.Count( results ) > 1 then
			frame = vgui.Create( "DFrame" )
			frame:SetSize( 300, 200 )
			frame:SetTitle( "Group Selection" )
			frame:SetVisible( true )
			frame:SetDraggable( true )
			frame:ShowCloseButton( true )
			frame:SetDeleteOnClose( true )
			frame:Center()

			local label = Label( "Select a character:", frame)
			label:Dock(TOP )

			local results = vgui.Create( "DListView" )
			results:SetParent( frame )
			results:Dock(FILL)
			results:SetMultiSelect( false )
			results:AddColumn("SteamID")
			results:AddColumn("Name")
			results:AddColumn("UID")
			-- for k, v in pairs( decoded.results ) do
			for k, v in pairs( results ) do
				results:AddLine( v.SteamID, v.Name, v.uid )
			end
			results.OnClickLine = function(parent, line, isselected)
				RunConsoleCommand("rp_getcharinfo",uid, CAKE.FormatText(line:GetValue(1)) .. ";" .. line:GetValue(3))
				frame:Remove()
				frame = nil
			end
		end
	end
end)

usermessage.Hook( "Tiramisu.GetInvite", function( um )
	local ply = um:ReadEntity()
	local name = um:ReadString()
	local uid = um:ReadString()

	CAKE.Query( "You have been invited to join group: " .. name .. ", accept?", "Group Invite",
		"Accept", function() RunConsoleCommand( "rp_joingroup", uid, CAKE.FormatText(ply:SteamID())) end, 
		"Deny",	function() end)
end)

usermessage.Hook( "Tiramisu.GroupCreateQuery", function( um )
	CAKE.BeginGroupCreation( um:ReadString() )
end)

function CAKE.EditCharacterInfo( tbl )

	local permissions = tbl.permissions or {}
	local rank = tbl.rank
	local ranks = permissions.ranks or {}

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 500, 100 )
	frame:SetTitle( "Editing player " .. tbl.uid .. " on group " .. tbl.groupid )
	frame:SetVisible( true )
	frame:SetDraggable( true )
	frame:ShowCloseButton( true )
	frame:SetDeleteOnClose( true )
	frame.Close = function()
		if permissions["canpromote"] and table.Count( ranks ) > 0 then
			if rank != "" then
				CAKE.Query( "Promote this player to " .. rank .. "?", "Promote",
				"Yes",	function() RunConsoleCommand("rp_promote", CAKE.FormatText(tbl.SteamID) .. ";" .. tbl.uid, rank, tbl.groupid) end, 
				"No",	function() end )
			end
		end
		frame:Remove()
		frame = nil
	end

	local title = Label( tbl.name, frame)
	title:SetFont( "Tiramisu48Font")
	title:SetPos( 10, 23 )
	title:SizeToContents()

	frame:SetWide( title:GetWide() + 20 )

	local subtitle = Label( "SteamID: " .. tbl.SteamID, frame)
	subtitle:SetPos( 10, 66 )
	subtitle:SetFont( "Tiramisu24Font")
	subtitle:SizeToContents()

	if frame:GetWide() < subtitle:GetWide() then
		frame:SetWide( subtitle:GetWide() + 20 )
	end

	local rank = Label( "Rank: " .. tbl.rankname, frame)
	rank:SetPos( 10, 95 )
	rank:SetFont( "Tiramisu18Font")
	rank:SizeToContents()

	frame:SetTall( frame:GetTall() + rank:GetTall() )
	frame:Center()

	if permissions["canpromote"] or permissions["cankick"] then

		frame:SetTall( frame:GetTall() + 132 )
		local actions = vgui.Create( "DForm", frame )
		actions:SetPos( 2, 90 )
		actions:SetSize( frame:GetWide() - 4, 70 )
		--actions.Paint = function() end
		actions:SetName( "Actions:" )
		actions:SetPadding(5)
		actions:SetSpacing(10)

		if permissions["canpromote"] and table.Count( ranks ) > 0 then
			actions:AddItem( Label( "Promote/Demote to a rank:" ))
			-- local setrank = vgui.Create( "DMultiChoice" )
			local setrank = vgui.Create( "DComboBox" )
			rank = ""
			for k, v in pairs( ranks ) do
				setrank:AddChoice(k)
			end
			setrank.OnSelect = function( index, value, data )
				rank = value
			end
			actions:AddItem( setrank ) 
		end

		if permissions["cankick"] then
			local kick = vgui.Create( "DButton" )
			kick:SetText( "Kick From Group" )
			kick.DoClick = function()
				CAKE.Query( "Are you sure you want to kick " .. tbl.name .. "?", "Kicking a player",
					"Yes",	function() frame:Remove() RunConsoleCommand("rp_kickfromgroup", CAKE.FormatText(tbl.SteamID) .. ";" .. tbl.uid, tbl.groupid) end, 
					"No",	function() end )
			end
			actions:AddItem(kick)
		end

		frame:Center()

	end
end

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

	local rank = {}
	rank["canedit"] = tbl["ranks"][rankname]["canedit"]
	rank["caninvite"] = tbl["ranks"][rankname]["caninvite"]
	rank["cankick"] = tbl["ranks"][rankname]["cankick"]
	rank["canpromote"] = tbl["ranks"][rankname]["canpromote"]
	rank["cantakeinventory"] = tbl["ranks"][rankname]["cantakeinventory"]
	rank["canplaceinventory"] = tbl["ranks"][rankname]["canplaceinventory"]
	rank["level"] = tbl["ranks"][rankname]["level"]
	rank["name"] = tbl["ranks"][rankname]["name"]
	rank["handler"] = tbl["ranks"][rankname]["handler"]
	rank["description"] = tbl["ranks"][rankname]["description"]

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
	Level:SetValue(tonumber(rank["level"]))
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
	if rank["canedit"] then
		CanEdit:SetValue(1)
	else
		CanEdit:SetValue(0)
	end
	CanEdit.OnChange = function( panel, value )
		rank["canedit"] = CanEdit:GetChecked()
	end
	Permissions:AddItem(CanEdit)

	local CanInvite = vgui.Create( "DCheckBoxLabel" )
	CanInvite:SetText("Can invite people to join")
	if rank["caninvite"] then
		CanInvite:SetValue(1)
	else
		CanInvite:SetValue(0)
	end
	CanInvite.OnChange = function( panel, value )
		rank["caninvite"] = CanInvite:GetChecked()
	end
	Permissions:AddItem(CanInvite)

	local CanKick = vgui.Create( "DCheckBoxLabel" )
	CanKick:SetText("Can kick people off the group")
	if rank["cankick"] then
		CanKick:SetValue(1)
	else
		CanKick:SetValue(0)
	end
	CanKick.OnChange = function( panel, value )
		rank["cankick"] = CanKick:GetChecked()
	end
	Permissions:AddItem(CanKick)

	local CanPromote = vgui.Create( "DCheckBoxLabel" )
	CanPromote:SetText("Can promote people to higher ranks")
	if rank["canpromote"] then
		CanPromote:SetValue(1)
	else
		CanPromote:SetValue(0)
	end
	CanPromote.OnChange = function( panel, value )
		rank["canpromote"] = CanPromote:GetChecked()
	end
	Permissions:AddItem(CanPromote)

	local CanTakeInventory = vgui.Create( "DCheckBoxLabel" )
	CanTakeInventory:SetText("Can take things off the inventory")
	if rank["cantakeinventory"] then
		CanTakeInventory:SetValue(1)
	else
		CanTakeInventory:SetValue(0)
	end
	CanTakeInventory.OnChange = function( panel, value )
		rank["cantakeinventory"] = CanTakeInventory:GetChecked()
	end
	Permissions:AddItem(CanTakeInventory)

	local CanPlaceInventory = vgui.Create( "DCheckBoxLabel" )
	CanPlaceInventory:SetText("Can place things in the inventory")
	if rank["canplaceinventory"] then
		CanPlaceInventory:SetValue(1)
	else
		CanPlaceInventory:SetValue(0)
	end
	CanPlaceInventory.OnChange = function( panel, value )
		rank["canplaceinventory"] = CanPlaceInventory:GetChecked()
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
		--datastream.StreamToServer( "Tiramisu.GetEditGroup", tbl )
		net.Start( "Tiramisu.GetEditGroup" )
			net.WriteTable( tbl )
		net.SendToServer()
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
	PlayerMenu:SetSize( 540, 400 )
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
	actions:SetSpacing(5)

	local FindPlayer = vgui.Create( "DButton" )
	FindPlayer:SetText( "Find A Player" )
	FindPlayer:SetTall( 30 )
	FindPlayer.DoClick = function()
		CAKE.StringRequest( "Find A Player", 
			"Enter the name, rank, or SteamID of the player you want to find:\nLeave empty to fetch the whole roster", 
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
		if tbl.inventory then
			RunConsoleCommand("rp_opencontainer", tbl.inventory)
		end
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

function CAKE.GetRankPermission( group, name )
	if CAKE.Groups and CAKE.ActiveGroup != "none" and CAKE.RankPermissions and CAKE.RankPermissions[group] then
		return CAKE.RankPermissions[group][name]
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
		if table.HasValue(CAKE.Factions, CAKE.ActiveGroup ) then
			RunConsoleCommand("rp_getfactioninfo", CAKE.ActiveGroup)
		else
			RunConsoleCommand("rp_getgroupinfo", CAKE.ActiveGroup)
		end
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
			if table.HasValue(CAKE.Factions, line:GetValue(1) ) then
				RunConsoleCommand("rp_getfactioninfo", line:GetValue(1))
			else
				RunConsoleCommand("rp_getgroupinfo", line:GetValue(1))
			end
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
