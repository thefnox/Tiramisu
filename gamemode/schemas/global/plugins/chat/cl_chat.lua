net.Receive( "TiramisuAddToChat", function( len )
	local decoded = net.ReadTable()
	local text = decoded.text
	local outline = false

	text = text:gsub("<%s*%w*%s*=%s*%w*%s*>", "")
	text = text:gsub("</font>", "")
	text = text:gsub("<%s*%w*%s*=%s*%w*%s*,%s*%w*%s*,%s*%w*%s*,%s*%w*%s*>", "")
	text = text:gsub("</color>", "")
	if !decoded.font then
		decoded.font = "TiramisuChatFont"
	end
	if decoded.font == "TiramisuChatFont" then
		outline = "TiramisuChatFontOutline"
	elseif decoded.font == "TiramisuYellFont" then
		outline = "TiramisuYellFontOutline"
	elseif decoded.font == "TiramisuWhisperFont" then
		outline = "TiramisuWhisperFontOutline"
	elseif decoded.font == "TiramisuEmoteFont" then
		outline = "TiramisuEmoteFontOutline"
	elseif decoded.font == "TiramisuOOCFont" then
		outline = "TiramisuOOCFontOutline"
	end
	if decoded.channel == "IC" then
		TIRA.Chatbox:AddLine(  "<color=135,209,255,255><font=" .. decoded.font .. ">" .. text .. "</font></color>", decoded.channel, decoded.handler or "", outline )
	else
		TIRA.Chatbox:AddLine( "<font=" .. decoded.font .. ">" .. text .. "</font>", decoded.channel, decoded.handler or "", outline )
	end

	for i = 0, text:len() / 255 do
		MsgN(string.sub( text, i * 255 + 1, i * 255 + 255 ) )
	end
end)

--Same as above, it is only being sent as a different net hook for it to print properly on console (IE, so that the </color> part is not printed)
net.Receive( "TiramisuAddToOOC", function( len )
	local decoded = net.ReadTable()
	local color = decoded.color
	local playername = decoded.name
	local text = decoded.text

	text = text:gsub("<%s*%w*%s*=%s*%w*%s*>", "")
	text = text:gsub("</font>", "")
	text = text:gsub("<%s*%w*%s*=%s*%w*%s*,%s*%w*%s*,%s*%w*%s*,%s*%w*%s*>", "")
	text = text:gsub("</color>", "")
	TIRA.Chatbox:AddLine(  "<font=TiramisuOOCFont><color=white>[OOC]</color><color=" .. tostring( color.r ) .. "," .. tostring( color.g ) .. "," .. tostring( color.b ) .. ">".. playername .. "</color><color=white>:" .. text .. "</color></font>", "OOC", "" ,"TiramisuOOCFontOutline" )

	text = "[OOC]" .. playername .. ": " .. text

	for i = 0, text:len() / 255 do
		MsgN(string.sub( text, i * 255 + 1, i * 255 + 255 ) )
	end
end)

local PANEL = {}
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:Init()
 
		self:SetFocusTopLevel( true )

		self.Channels = {}
		self.Color = TIRA.BaseColor
		self:ShowCloseButton( false )
		self:SetTitle( "" )
		
		self.Height = math.Round(( ScrH() / 3 ) / 10 ) * 10
		self.Width = self.Height * 2
		self.Alpha = 0
		self.Lines = 0
		self:SetSize( self.Width, self.Height )
		self:SetPos( 20, ScrH() - self.Height - 60 )
		self.Open = false

		// This turns off the engine drawing
		self:SetPaintBackgroundEnabled( false )
		self:SetPaintBorderEnabled( false )
		
		self.PropertySheet = vgui.Create( "DPropertySheet", self )
		self.PropertySheet:SetSize( self.Width - 5 , self.Height - 30 )
		self.PropertySheet:SetPos( 3, 3 )
		self.PropertySheet:SetShowIcons( false )
		self.PropertySheet.Paint = function()
		end
		self:AddChannel( "All", "All Messages", "", true )
		self:AddChannel( "IC", "In Character", "", true  )
		self:AddChannel( "OOC", "Out Of Character", "// ", true )

		self.TextEntry = vgui.Create( "DTextEntry", self )
		self.TextEntry:SetSize( self.Width - 13, 25 )
		self.TextEntry:SetPos( 5, self.Height - 30 )
		self.TextEntry:SetAllowNonAsciiCharacters(true)
		self.TextEntry.Paint = function()
			if self.Open then
				draw.RoundedBox( 2, 2, 2, self.TextEntry:GetWide(), self.TextEntry:GetTall(), Color( 50, 50, 50, self.Alpha ) )
				self.TextEntry:DrawTextEntryText( Color( 200, 200, 200, 240 ), self.TextEntry.m_colHighlight, self.TextEntry.m_colCursor )
			end
		end
		self.TextEntry.PaintOver = function() end
		self.TextEntry.OnEnter = function()
			local text = string.Trim(self.TextEntry:GetValue())
			if text != "" then
				if ( string.sub(text, 1, 1 ) == "@" ) then
					local exp = string.Explode( " ", text) or {}
					local command = exp[1] or text
					table.remove( exp, 1 )
					RunConsoleCommand(string.sub( command, 2, string.len(command) ), unpack(exp) )
				elseif ( string.sub( text, 1, 1 ) == "!" ) then
					local exp = string.Explode( " ", text) or {}
					local command = exp[1] or text
					table.remove( exp, 1 )
					RunConsoleCommand("rp_" .. string.sub( command, 2, string.len(command) ), unpack(exp) )
				else
				net.Start("TiramisuChatHandling")
					net.WriteString( (self.PropertySheet:GetActiveTab().handler or "") .. string.sub(string.Replace(text, "\"", "'"), 1, math.Clamp(text:len(),1,600)))
				net.SendToServer()
				end
			end
			self.TextEntry:Clear()
			self:Close()
		end
		self.TextEntry.Clear = function()
			self.TextEntry:SetValue("")
			self.TextEntry:SetCaretPos( 0 )
		end
 
end

--Adds a tab to the chatbox. Can be done while the chatbox is open.
function PANEL:AddChannel( name, description, handler, cantclose )

	local steps
	local x, y
	if !self.Channels[ name ] then
		local panel = vgui.Create( "DPanelList" )
		panel:EnableVerticalScrollbar(true)
		panel.Lines = 0
		local offset = 0
		panel.Paint = function()
			offset = 0
			draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall(), Color( 50, 50, 50, self.Alpha ) )
			if panel.VBar and panel.VBar.Enabled then
				panel.VBar:SetVisible( self.Open )
			end
			render.SetScissorRect( 4, 0, 0, panel:GetWide(), panel:GetTall(), true )
			for i = math.max(panel.Lines - TIRA.ConVars[ "MaxChatLines" ],1), panel.Lines do
				local pnl = panel.Items[i]
				if pnl and pnl:Valid() then
					if self.Open then
						pnl.Alpha = 255
						pnl.timestamp = CurTime()
					end
					x, y = 0, offset
					if panel.VBar then
						y = y - panel.VBar:GetScroll()
					end
					if pnl.StrOutlineCheap then
						pnl.StrOutlineCheap:Draw(x+3, y+1, pnl.Align, pnl.VerticalAlign, pnl.Alpha )		
					end
					if pnl.Str then
						pnl.Str:Draw(x+2, y, pnl.Align, pnl.VerticalAlign, pnl.Alpha )
					end
					offset = offset + pnl:GetTall()
				end
			end
			render.SetScissorRect( 4, 0, 0, panel:GetWide(), panel:GetTall(), false )
		end
		panel.AddItem = function(pnl, item)
			panel.Lines = panel.Lines + 1

			if panel.Lines > TIRA.ConVars[ "MaxChatLines" ] then
				panel.Items[panel.Lines - TIRA.ConVars[ "MaxChatLines" ]]:Remove()
				panel.Items[panel.Lines - TIRA.ConVars[ "MaxChatLines" ]] = nil
			end

			if (!item || !item:IsValid()) then return end

			item:SetVisible( true )
			item:SetParent( panel:GetCanvas() )
			panel.Items[panel.Lines] = item 

			panel:InvalidateLayout()

		end
		self.Channels[ name ] = panel
		local tab = self.PropertySheet:AddSheet( name, panel, "gui/silkicons/user.vtf", false, false, description or name )
		tab.Tab.handler = handler or ""
		if cantclose then
			tab.Tab.CantBeClosed = true
		else
			tab.Tab.Image:Remove()
			/*
			tab.Tab.Image = vgui.Create( "DSysButton", tab.Tab )
			tab.Tab.Image:SizeToContents()
			tab.Tab.Image:SetType( "close" )
			tab.Tab.Image:SetDrawBorder( false )
			tab.Tab.Image:SetDrawBackground( false )
			tab.Tab.Image.SetImageColor = function() end
			tab.Tab.Image.DoClick = function()
				if self.PropertySheet.tabScroller and self.PropertySheet.tabScroller.Panels then
					for k, panel in pairs( self.PropertySheet.tabScroller.Panels ) do
						if panel == tab.Tab then
							table.remove(self.PropertySheet.tabScroller.Panels, k)
							self.PropertySheet.tabScroller.Panels[k] = nil
						end
					end
				end
				for k, tabs in pairs( self.PropertySheet.Items ) do
					if tabs.Tab == tab.Tab then
						table.remove(self.PropertySheet.Items, k)
						self.PropertySheet.Items[k] = nil
					end
				end
				self.Channels[ name ]:Remove()
				self.Channels[ name ] = nil
				tab.Tab:Remove()
				self.PropertySheet.m_pActiveTab = table.Random(self.PropertySheet.Items).Tab
				self.PropertySheet:InvalidateLayout( true, true ) 
				self:InvalidateLayout( true, true ) 
			end*/
		end
		self.PropertySheet:InvalidateLayout( true, true ) 
		for _,item in pairs( self.PropertySheet.Items ) do
			item.Tab.Paint = function()
				if item.Tab:GetPropertySheet():GetActiveTab() == item.Tab then
					draw.RoundedBox( 2, 0, 0, item.Tab:GetWide() - 8, item.Tab:GetTall(), Color( 40, 40, 40, self.Alpha ) )
					item.Tab:SetTextColor( Color( 170, 170, 170, self.Alpha ) )
				else
					draw.RoundedBox( 2, 1, 1, item.Tab:GetWide() - 9, item.Tab:GetTall() - 1, Color( 90, 90, 90, self.Alpha ))
					item.Tab:SetTextColor( Color( 170, 170, 170, self.Alpha ) )
				end
			end
			if item.Tab.CantBeClosed then
				item.Tab.Image:SetVisible( false )
			end
		end
	end

end

--Adds a line to a particular channel. If no channel is specified it simply becomes global.
function PANEL:AddLine( text, channel, handler, outline )

	local label
	if outline then
		label = MarkupLabelOutlineCheap( text, self.Width - 30, outline, Color( 0,0,0, 255) )
	else
		label = MarkupLabel( text, self.Width - 30)
	end
	local number = self.Lines + 1
	label.Paint = function() end
	label.numberid = number
	label.timestamp = CurTime()
	self.Channels[ "All" ]:AddItem( label )
	
	if channel then
		self:AddChannel( channel, channel, handler )
		if outline then
			label = MarkupLabelOutlineCheap( text, self.Width - 30, outline, Color( 0,0,0, 255) )
		else
			label = MarkupLabel( text, self.Width - 30)
		end
		label.numberid = number
		label.timestamp = CurTime()
		label.Paint = function() end
		self.Channels[ channel ]:AddItem( label )
	end

	timer.Simple( 0.1, function()
		if channel then
			if self.Channels[ channel ] and self.Channels[ channel ].VBar then
				self.Channels[ channel ].VBar:SetScroll( 999999 )
			end
		end
		if self.Channels[ "All" ].VBar then
			self.Channels[ "All" ].VBar:SetScroll( 999999 )
		end
	end)

end

	
/*---------------------------------------------------------
 
---------------------------------------------------------*/
--Doesn't actually close the chatbox, simply hides it.
function PANEL:Close()

	self.Open = false
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
	gui.EnableScreenClicker( false )
	if self.PropertySheet.tabScroller then
		self.PropertySheet.tabScroller:SetVisible( false )
	end

	LocalPlayer( ):ConCommand( "rp_closedchat" )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:OpenChat()

	if !self.Open then
		self.Open = true
		self:SetKeyboardInputEnabled(true)
		self:SetMouseInputEnabled(true)
		self:MakePopup()
		self.TextEntry:RequestFocus()
		gui.EnableScreenClicker( true )
		LocalPlayer( ):ConCommand( "rp_openedchat" )
		if self.PropertySheet.tabScroller then
			self.PropertySheet.tabScroller:SetVisible( true )
		end
	end
end
 
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
--Calculations to determine which lines fade out.
local linetbl = {}
local tblcount
local tbl
function PANEL:Think()
	if !self.Open then
		for k, v in pairs(self.Channels) do
			if v and v:Valid() and v:GetItems() then
				tbl = v:GetItems()
				tblcount = v.Lines or 0
				if tblcount > 0 then
					for i = tblcount - 20, tblcount do
						if tbl[i] and tbl[i]:Valid() and tbl[i].timestamp + 10 < CurTime() then
							tbl[i]:SetAlpha( 255 - (CurTime()-tbl[i].timestamp + 10) * 10 )
						end				
					end
				end
			end
		end
	end

	if self.Open and input.IsKeyDown(KEY_ESCAPE) then
		self:Close()
	end
end
 
local x, y
local lastpos
local color

--Handles the whole drawing part.
function PANEL:Paint()
	derma.SkinHook( "Paint", "TiramisuChatBox", self )
end

function PANEL:PerformLayout()
end

function PANEL:IsActive()
 
		if ( self:HasFocus() ) then return true end
		if ( vgui.FocusedHasParent( self ) ) then return true end
		
		return false
 
end
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:OnMousePressed()
 
	self:OpenChat()
 
end
 
vgui.Register( "TiramisuChatBox", PANEL, "DFrame")

function chat.AddText(...) --Overriding default chat text entry
end

hook.Add( "ChatText", "WhatDontGoOnTheChatboxGetsDisabled", function(  playerindex, playername, text, messagetype  )
	return true
end)


hook.Add("PlayerBindPress", "TiramisuChatOverride", function(ply, bind, pressed)
	if string.find( bind, "messagemode" ) or string.find( bind, "messagemode2" ) then
		TIRA.Chatbox:OpenChat()
		return true
	end
end)

usermessage.Hook( "TiramisuInitChat", function( um )
	gamemode.Call( "StartChat" )
	gamemode.Call( "FinishChat" )
	if !TIRA.ChatBox then
		TIRA.Chatbox = vgui.Create( "TiramisuChatBox" )
		TIRA.Chatbox:Init()
	end
end)
