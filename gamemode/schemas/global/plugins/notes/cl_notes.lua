function ccWrite(ply, cmd, args)
	WriteMenu = vgui.Create( "DFrameTransparent" )
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
		datastream.StreamToServer( "NoteStream", { ["title"] = TitleBox:GetValue(), ["text"] = NoteBox:GetValue() }, function() end)
		WriteMenu:Close()
	end

	WriteMenu:MakePopup()
end
concommand.Add( "rp_write", ccWrite )

function noteRead( handler, id, encoded, decoded )
	ReadMenu = vgui.Create( "DFrameTransparent" )
	ReadMenu:SetSize( 640, 480 )
	ReadMenu:SetTitle( decoded["title"] )
	ReadMenu:SetVisible( true )
	ReadMenu:SetDraggable( true )
	ReadMenu:ShowCloseButton( true )
	ReadMenu:SetDeleteOnClose( true )
	ReadMenu:Center()

	local LineList = vgui.Create( "DPanelList", ReadMenu )
	LineList:SetPos( 5, 30 )
	LineList:SetSize( 630, 445 )
	LineList:SetPadding(20);
	LineList:SetSpacing(5)
	LineList:EnableHorizontal(false);
	LineList:EnableVerticalScrollbar(true);
	LineList:SetAutoSize(false)
	
	linetable = string.Explode( "\n", decoded["text"] )
	
	for k,v in pairs(linetable) do
		align = TEXT_ALIGN_LEFT
		alignstr = v:sub(1, 3)

		if alignstr == "<r>" then align = TEXT_ALIGN_RIGHT 
		elseif alignstr == "<c>" then align = TEXT_ALIGN_CENTER end

		if align != TEXT_ALIGN_LEFT then v = v:sub(4) end

		NoteLabel = MarkupLabelBook( v, 590, 590 )
		NoteLabel:SetAlign(align)
		LineList:AddItem(NoteLabel)
	end

	ReadMenu:MakePopup()
end
datastream.Hook( "ReadStream", noteRead );