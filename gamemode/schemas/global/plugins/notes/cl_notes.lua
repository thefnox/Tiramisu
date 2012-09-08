usermessage.Hook("Tiramisu.StartWrite", function()
	TIRA.WriteNote()
end)

function TIRA.WriteNote()
	WriteMenu = vgui.Create( "DFrame" )
	WriteMenu:SetSize( 640, 480 )
	WriteMenu:SetTitle( "Write" )
	WriteMenu:SetVisible( true )
	WriteMenu:SetDraggable( true )
	WriteMenu:ShowCloseButton( true )
	WriteMenu:SetDeleteOnClose( true )
	WriteMenu:Center()
	
	local TitleBox = vgui.Create("TextEntry", WriteMenu)
	TitleBox:SetSize( 630, 25 ) 
	TitleBox:SetPos( 5 , 30 )
	
	local NoteBox = vgui.Create("TextEntry", WriteMenu)
	NoteBox:SetMultiline(true)
	NoteBox:SetSize( 630, 380 ) 
	NoteBox:SetPos( 5, 60 )
	
	local WriteButton = vgui.Create( "DButton", WriteMenu )
	WriteButton:SetSize( 100, 30 )
	WriteButton:SetPos( 270,  445 )
	WriteButton:SetText( "Write" )
	WriteButton.DoClick = function( button )
		datastream.StreamToServer( "Tiramisu.WriteNote", { ["title"] = TitleBox:GetValue(), ["text"] = NoteBox:GetValue() }, function() end)
		WriteMenu:Close()
	end

	WriteMenu:MakePopup()
end

function TIRA.OpenNote( title, text )
	ReadMenu = vgui.Create( "DFrame" )
	ReadMenu:SetSize( 640, 480 )
	ReadMenu:SetTitle( "Note" )
	ReadMenu:SetVisible( true )
	ReadMenu:SetDraggable( true )
	ReadMenu:ShowCloseButton( true )
	ReadMenu:SetDeleteOnClose( true )
	ReadMenu:Center()

	local titlelabel = Label( title , ReadMenu)
	titlelabel:SetFont( "Tiramisu32Font")
	titlelabel:Dock(TOP)
	titlelabel:SizeToContents()

	local LineList = vgui.Create( "DPanelList", ReadMenu )
	LineList:Dock( FILL )
	LineList:DockMargin(2, 2, 2, 2)
	LineList.Paint = function() end
	LineList:SetPadding(20)
	LineList:SetSpacing(5)
	LineList:EnableHorizontal(false)
	LineList:EnableVerticalScrollbar(true)
	LineList:SetAutoSize(false)
	
	local linetable = string.Explode( "\n", text )
	
	for k,v in pairs(linetable) do
		local align = TEXT_ALIGN_LEFT
		local alignstr = v:sub(1, 3)

		if alignstr == "<r>" then align = TEXT_ALIGN_RIGHT 
		elseif alignstr == "<c>" then align = TEXT_ALIGN_CENTER end

		if align != TEXT_ALIGN_LEFT then v = v:sub(4) end

		NoteLabel = MarkupLabelBook( "<font=TiramisuNoteFont>" .. v .. "</font>", 590, 590 )
		NoteLabel:SetAlign(align)
		LineList:AddItem(NoteLabel)
	end

	ReadMenu:MakePopup()
end
datastream.Hook( "Tiramisu.ReadNote", function( handler, id, encoded, decoded )
	TIRA.OpenNote( decoded.title, decoded.text )
end )