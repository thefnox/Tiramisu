local panel = FindMetaTable( "Panel" )

--Utility function, allows a panel to track a world position.
function panel:TrackPos( vector, margin, allowclipoff, keepoffmouse )
	margin = margin or 0
	if vector then
		local toscreen = vector:ToScreen()
		local x, y
		if allowclipoff then
			--Just let it follow the on screen position, regardless of if it is actually fully on screen
			if toscreen.visible then
				x, y = toscreen.x, toscreen.y
			else
				x, y = ScrW(), ScrH()
			end
		else
			if !toscreen.visible then
				toscreen.x, toscreen.y = ScrW(), ScrH()
			end
			--Try to keep it on screen.
			if toscreen.x + self:GetWide() + margin > ScrW() then
				x = ScrW() - self:GetWide() - margin
			elseif toscreen.x < 0 then
				x = margin
			else
				x = toscreen.x
			end 
			if toscreen.y + self:GetTall() + margin > ScrH() then
				y = ScrH() - self:GetTall() - margin
			elseif toscreen.y < 0 then
				y = margin
			else
				y = toscreen.y
			end 
		end
		if keepoffmouse and vgui.CursorVisible() and CAKE.PosInRegion( gui.MouseX(), gui.MouseY(), x,y, self:GetWide() + x, self:GetTall() + y ) then
			local deltax, deltay = gui.MouseX() - toscreen.x, gui.MouseY() - toscreen.y
			if deltax > self:GetWide() / 2 then
				toscreen.x = toscreen.x - ( x + self:GetWide() / 2 - gui.MouseX() )
			else
				toscreen.x = toscreen.x + deltax
			end
			if deltay > self:GetTall() / 2 then
				toscreen.y = toscreen.y - ( y + self:GetTall() / 2 - gui.MouseY() )
			else
				toscreen.y = toscreen.y + deltay
			end
			if allowclipoff then
				--Just let it follow the on screen position, regardless of if it is actually fully on screen
				if toscreen.visible then
					x, y = toscreen.x, toscreen.y
				else
					x, y = ScrW(), ScrH()
				end
			else
				if !toscreen.visible then
					toscreen.x, toscreen.y = ScrW(), ScrH()
				end
				--Try to keep it on screen.
				if toscreen.x + self:GetWide() + margin > ScrW() then
					x = ScrW() - self:GetWide() - margin
				elseif toscreen.x < 0 then
					x = margin
				else
					x = toscreen.x
				end 
				if toscreen.y + self:GetTall() + margin > ScrH() then
					y = ScrH() - self:GetTall() - margin
				elseif toscreen.y < 0 then
					y = margin
				else
					y = toscreen.y
				end 
			end
		end
		return x, y
	end
end

meta = nil

--And a non panel version.
function CAKE.TrackPos( wide, tall, vector, margin, allowclipoff )
	margin = margin or 0
	if vector then
		local toscreen = vector:ToScreen()
		local x, y
		if allowclipoff then
			--Just let it follow the on screen position, regardless of if it is actually fully on screen
			if toscreen.visible then
				x, y = toscreen.x, toscreen.y
			else
				x, y = ScrW(), ScrH()
			end
		else
			--Try to keep it on screen.
			if toscreen.x + wide + margin > ScrW() then
				x = ScrW() - wide - margin
			elseif toscreen.x < 0 then
				x = margin
			else
				x = toscreen.x
			end 
			if toscreen.y + tall + margin > ScrH() then
				y = ScrW() - tall - margin
			elseif toscreen.y < 0 then
				y = margin
			else
				y = toscreen.y
			end 
		end
		return x, y
	end
end

--And a helper function, to check if a point is within a region in space.
function CAKE.PosInRegion( x, y, topx, topy, botx, boty, z, topz, botz )
	if !z then --Keep it bidimensional 
		if ( x >= topx and x <= botx ) and ( y >= topy and y <= boty ) then
			return true
		end
	else
		if (topx <= x and botx >= x) and (topy <= y and boty >= y) and (topz <= z and botz >= z) then
			return true
		end
	end
	return false
end


function CAKE.AddNotification( text, pos, color, textcolor, allowclipoff, radius, callback, runonce )
	local tbl = {}
	tbl["text"] = text or "-none-"
	tbl["pos"] = pos or Vector( 0, 0, 0 )
	tbl["color"] = color or CAKE.BaseColor
	tbl["textcolor"] = textcolor or Color( 255, 255, 255, 255 )
	tbl["radius"] = radius or 0
	tbl["callback"] = callback or true
	tbl["runonce"] = runonce

	table.insert( CAKE.Notifications, tbl ) 
end

	
--Taken from derma_utils, meant to be used with the cute little frames
/*
	Display a simple message box.
	
	CAKE.Message( "Hey Some Text Here!!!", "Message Title (Optional)", "Button Text (Optional)" )
	
*/
function CAKE.Message( strText, strTitle, strButtonText )
 
	local Window = vgui.Create( "DFrame" )
		Window:SetTitle( strTitle or "Message" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		
	local InnerPanel = vgui.Create( "DPanel", Window )
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_black )
		
	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
		
	local Button = vgui.Create( "DButton", ButtonPanel )
		Button:SetText( strButtonText or "OK" )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button:SetPos( 5, 5 )
		Button.DoClick = function() Window:Close() end
		
	ButtonPanel:SetWide( Button:GetWide() + 10 )
	
	local w, h = Text:GetSize()
	
	Window:SetSize( w + 50, h + 25 + 45 + 10 )
	Window:Center()
	
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	
	Text:StretchToParent( 5, 5, 5, 5 )      
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	
	Window:MakePopup()
 
end


/*
	Ask a question with multiple answers..
	
	CAKE.Query( "Would you like me to punch you right in the face?", "Question!",
						"Yesss",	function() MsgN( "Pressed YES!") end, 
						"Nope!",	function() MsgN( "Pressed Nope!") end, 
						"Cancel",       function() MsgN( "Cancelled!") end )
		
*/
function CAKE.Query( strText, strTitle, ... )

	local arg = {...}
 
	local Window = vgui.Create( "DFrame" )
		Window:SetTitle( strTitle or "Message Title (First Parameter)" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		
	local InnerPanel = vgui.Create( "DPanel", Window )
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text (Second Parameter)" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_black )
 
	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
 
	// Loop through all the options and create buttons for them.
	local NumOptions = 0
	local x = 5
	for k=1, 8, 2 do
		
		if ( arg[k] == nil ) then break end
		
		local Text = arg[k]
		local Func = arg[k+1] or function() end
	
		local Button = vgui.Create( "DButton", ButtonPanel )
			Button:SetText( Text )
			Button:SizeToContents()
			Button:SetTall( 20 )
			Button:SetWide( Button:GetWide() + 20 )
			Button.DoClick = function() Window:Close() Func() end
			Button:SetPos( x, 5 )
			
		x = x + Button:GetWide() + 5
			
		ButtonPanel:SetWide( x ) 
		NumOptions = NumOptions + 1
	
	end
 
	
	local w, h = Text:GetSize()
	
	w = math.max( w, ButtonPanel:GetWide() )
	
	Window:SetSize( w + 50, h + 25 + 45 + 10 )
	Window:Center()
	
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	
	Text:StretchToParent( 5, 5, 5, 5 )      
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	
	Window:MakePopup()
	
	if ( NumOptions == 0 ) then
	
		Window:Close()
		Error( "CAKE.Query: Created Query with no Options!?" )
	
	end
 
end
 
 
/*
	Request a string from the user
	
	CAKE.StringRequest( "Question", 
					"What Is Your Favourite Color?", 
					"Type your answer here!", 
					function( strTextOut ) CAKE.Message( "Your Favourite Color Is: " .. strTextOut ) end,
					function( strTextOut ) CAKE.Message( "You pressed Cancel!" ) end,
					"Okey Dokey", 
					"Cancel" )
	
*/
function CAKE.StringRequest( strTitle, strText, strDefaultText, fnEnter, fnCancel, strButtonText, strButtonCancelText, color )
 
	local Window = vgui.Create( "DFrame" )
		Window:SetTitle( strTitle or "Message Title (First Parameter)" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )

	local InnerPanel = vgui.Create( "DPanel", Window )
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text (Second Parameter)" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_black )
		
	local TextEntry = vgui.Create( "DTextEntry", InnerPanel )
		TextEntry:SetText( strDefaultText or "" )
		TextEntry.OnEnter = function() Window:Close() fnEnter( TextEntry:GetValue() ) end
		
	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
		
	local Button = vgui.Create( "DButton", ButtonPanel )
		Button:SetText( strButtonText or "OK" )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button:SetPos( 5, 5 )
		Button.DoClick = function() Window:Close() fnEnter( TextEntry:GetValue() ) end
		
	local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
		ButtonCancel:SetText( strButtonCancelText or "Cancel" )
		ButtonCancel:SizeToContents()
		ButtonCancel:SetTall( 20 )
		ButtonCancel:SetWide( Button:GetWide() + 20 )
		ButtonCancel:SetPos( 5, 5 )
		ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( TextEntry:GetValue() ) end end
		ButtonCancel:MoveRightOf( Button, 5 )
		
	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
	
	local w, h = Text:GetSize()
	w = math.max( w, 400 ) 
	
	Window:SetSize( w + 50, h + 25 + 75 + 10 )
	Window:Center()
	
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	
	Text:StretchToParent( 5, 5, 5, 35 )     
	
	TextEntry:StretchToParent( 5, nil, 5, nil )
	TextEntry:AlignBottom( 5 )
	
	TextEntry:RequestFocus()
	TextEntry:SelectAllText( true )
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	
	Window:MakePopup()
 
end

--Same as the above, only that it takes a table, containing all the available choices.
function CAKE.ChoiceRequest( strTitle, strText, tbl, fnEnter, fnCancel, strButtonText, strButtonCancelText, color )
	
	local choice

	local Window = vgui.Create( "DFrame" )
		Window:SetTitle( strTitle or "Message Title (First Parameter)" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )

	local InnerPanel = vgui.Create( "DPanel", Window )
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text (Second Parameter)" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_black )
		
	local MultiChoice = vgui.Create( "DComboBox", InnerPanel )
		choice = tbl[1]
		for k, v in pairs( tbl ) do
		    MultiChoice:AddChoice( v )
		end
		MultiChoice.OnSelect = function(panel,index,value) choice = value end
		MultiChoice:SizeToContents()
		
	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
		
	local Button = vgui.Create( "DButton", ButtonPanel )
		Button:SetText( strButtonText or "OK" )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button:SetPos( 5, 5 )
		Button.DoClick = function() Window:Close() fnEnter( choice ) end
		
	local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
		ButtonCancel:SetText( strButtonCancelText or "Cancel" )
		ButtonCancel:SizeToContents()
		ButtonCancel:SetTall( 20 )
		ButtonCancel:SetWide( Button:GetWide() + 20 )
		ButtonCancel:SetPos( 5, 5 )
		ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( choice ) end end
		ButtonCancel:MoveRightOf( Button, 5 )
		
	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
	
	local w, h = Text:GetSize()
	w = math.max( w, 400 ) 
	
	Window:SetSize( w + 50, h + 25 + 75 + 10 )
	Window:Center()
	
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	
	Text:StretchToParent( 5, 5, 5, 35 )     
	
	MultiChoice:StretchToParent( 5, nil, 5, nil )
	MultiChoice:AlignBottom( 5 )
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	
	Window:MakePopup()
 
end
	