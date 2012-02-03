datastream.Hook( "TiramisuAddToChat", function( handler, id, encoded, decoded )

	local text = decoded.text

	text = text:gsub("<%s*%w*%s*=%s*%w*%s*>", "")
	text = text:gsub("</font>", "")
	text = text:gsub("<%s*%w*%s*=%s*%w*%s*,%s*%w*%s*,%s*%w*%s*,%s*%w*%s*>", "")
	text = text:gsub("</color>", "")
	if !decoded.font then
		decoded.font = "TiramisuChatFont"
	end
	if decoded.channel == "IC" then
		CAKE.Chatbox:AddLine(  "<color=135,209,255,255><font=" .. decoded.font .. ">" .. text .. "</font></color>", decoded.channel, decoded.handler or "" )
	else
		CAKE.Chatbox:AddLine( "<font=" .. decoded.font .. ">" .. text .. "</font>", decoded.channel, decoded.handler or "" )
	end

	for i = 0, text:len() / 255 do
		MsgN(string.sub( text, i * 255 + 1, i * 255 + 255 ) )
	end
end)

--Same as above, it is only being sent as a different datastream for it to print properly on console (IE, so that the </color> part is not printed)
datastream.Hook( "TiramisuAddToOOC", function( handler, id, encoded, decoded )
	
	local color = decoded.color
	local playername = decoded.name
	local text = decoded.text

	text = text:gsub("<%s*%w*%s*=%s*%w*%s*>", "")
	text = text:gsub("</font>", "")
	text = text:gsub("<%s*%w*%s*=%s*%w*%s*,%s*%w*%s*,%s*%w*%s*,%s*%w*%s*>", "")
	text = text:gsub("</color>", "")
	CAKE.Chatbox:AddLine(  "<font=" .. "TiramisuOOCFont" .. "><color=white>[OOC]</color><color=" .. tostring( color.r ) .. "," .. tostring( color.g ) .. "," .. tostring( color.b ) .. ">".. playername .. "</color><color=white>:" .. text .. "</color></font>", "OOC" )

	text = "[OOC]" .. playername .. ": " .. text

	for i = 0, text:len() / 255 do
		MsgN(string.sub( text, i * 255 + 1, i * 255 + 255 ) )
	end
end)

local matBlurScreen = Material( "pp/blurscreen" ) 
local PANEL = {}
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:Init()
 
		self:SetFocusTopLevel( true )

		self.Channels = {}
		self.Color = CAKE.BaseColor
		self:ShowCloseButton( false )
		self:SetTitle( "" )
		
		self.Height = math.Round(( ScrH() / 3 ) / 10 ) * 10
		self.Width = self.Height * 2
		self.Alpha = 0
		self.Lines = {}
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
		self.TextEntry.OnEnter = function()
			if self.TextEntry:GetValue() != "" then
				if ( string.sub(self.TextEntry:GetValue(), 1, 1 ) == "@" ) then
					local exp = string.Explode( " ", self.TextEntry:GetValue()) or {}
					local command = exp[1] or self.TextEntry:GetValue()
					table.remove( exp, 1 )
					RunConsoleCommand(string.sub( command, 2, string.len(command) ), unpack(exp) )
				elseif ( string.sub( self.TextEntry:GetValue(), 1, 1 ) == "!" ) then
					local exp = string.Explode( " ", self.TextEntry:GetValue()) or {}
					local command = exp[1] or self.TextEntry:GetValue()
					table.remove( exp, 1 )
					RunConsoleCommand("rp_" .. string.sub( command, 2, string.len(command) ), unpack(exp) )
				else
				datastream.StreamToServer( "TiramisuChatHandling", { ["text"] = (self.PropertySheet:GetActiveTab().handler or "") .. string.sub(string.Replace(self.TextEntry:GetValue(), "\"", "'"), 1, math.Clamp(self.TextEntry:GetValue():len(),1,600)) } )
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

	if !self.Channels[ name ] then
		local panel = vgui.Create( "DPanelList" )
		panel:EnableVerticalScrollbar(true)
		panel.Paint = function()
			draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall(), Color( 50, 50, 50, self.Alpha ) )
			if panel.VBar and panel.VBar.Enabled then
				panel.VBar:SetVisible( self.Open )
			end
		end
		self.Channels[ name ] = panel
		local tab = self.PropertySheet:AddSheet( name, panel, "", false, false, description or name )
		tab.Tab.handler = handler or ""
		if cantclose then
			tab.Tab.CantBeClosed = true
		else
			tab.Tab.Image:Remove()
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
			end
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
function PANEL:AddLine( text, channel, handler )

	local label = MarkupLabelOutline( text, self.Width - 30, 1, Color( 0,0,0, 100) )
	local number = #self.Lines + 1
	label.numberid = number 
	self.Lines[ number ] = {}
	self.Lines[ number ][ "panel" ] = label
	self.Lines[ number ][ "timestamp" ] = CurTime()
	self.Channels[ "All" ]:AddItem( label )
	local tbl = self.Channels[ "All" ]:GetItems()
	local low = 999999999999
	local lowest
	if #tbl > 500 then
		for k, v in pairs( tbl ) do
			if v and v.numberid < low then
				low = v.numberid
				lowest = k 
			end
		end
		self.Channels[ "All" ]:RemoveItem( tbl[lowest] )
	end

	if channel then
		self:AddChannel( channel, channel, handler )
		label = MarkupLabelOutline( text, self.Width - 30, 1, Color( 0,0,0, 100) )
		label.numberid = number 
		self.Channels[ channel ]:AddItem( label )

		tbl = self.Channels[ channel ]:GetItems()
		low = 999999999999
		if #tbl > 500 then
			for k, v in pairs( tbl ) do
				if v and v.numberid < low then
					low = v.numberid
					lowest = k 
				end
			end
			--We purge it from existance, as this line will necessarily be purged or has already been purged from the All channel. (The All channel will have either 50 or more items)
			self.Channels[ channel ]:RemoveItem( tbl[lowest] )
			self.Lines[ low ] = nil
		end
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
function PANEL:Think()
	if self.Lines and !self.Open then
		for k, v in pairs( self.Lines ) do
			if v[ "panel" ] and v[ "timestamp" ] + 10 < CurTime() then
				v[ "panel" ]:SetAlpha( Lerp( 0.05, v[ "panel" ]:GetAlpha() , 0 ) )
			end
		end
	else
		for k, v in pairs( self.Lines ) do
			if v[ "panel" ] then
				v[ "panel" ]:SetAlpha( 255 )
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
		CAKE.Chatbox:OpenChat()
		return true
	end
end)

usermessage.Hook( "TiramisuInitChat", function( um )
	gamemode.Call( "StartChat" )
	gamemode.Call( "FinishChat" )
	if !CAKE.ChatBox then
		CAKE.Chatbox = vgui.Create( "TiramisuChatBox" )
		CAKE.Chatbox:Init()
	end
end)
