local colourmap = {
-- it's all black and white
	["black"] =        Color(0,0,0,255),
	["white"] =        Color(255,255,255,255),
-- it's greys
	["dkgrey"] =    Color(64,64,64,255),
	["grey"] =        Color(128,128,128,255),
	["ltgrey"] =    Color(192,192,192,255),
-- account for speeling mistakes
	["dkgray"] =    Color(64,64,64,255),
	["gray"] =        Color(128,128,128,255),
	["ltgray"] =    Color(192,192,192,255),
-- normal colours
	["red"] =        Color(255,0,0,255),
	["green"] =        Color(0,255,0,255),
	["blue"] =        Color(0,0,255,255),
	["yellow"] =    Color(255,255,0,255),
	["purple"] =    Color(255,0,255,255),
	["cyan"] =        Color(0,255,255,255),
	["turq"] =        Color(0,255,255,255),
-- dark variations
	["dkred"] =        Color(128,0,0,255),
	["dkgreen"] =    Color(0,128,0,255),
	["dkblue"] =    Color(0,0,128,255),
	["dkyellow"] =    Color(128,128,0,255),
	["dkpurple"] =    Color(128,0,128,255),
	["dkcyan"] =    Color(0,128,128,255),
	["dkturq"] =    Color(0,128,128,255),
-- light variations
	["ltred"] =        Color(255,128,128,255),
	["ltgreen"] =    Color(128,255,128,255),
	["ltblue"] =    Color(128,128,255,255),
	["ltyellow"] =    Color(255,255,128,255),
	["ltpurple"] =    Color(255,128,255,255),
	["ltcyan"] =    Color(128,255,255,255),
	["ltturq"] =    Color(128,255,255,255)
}

function CAKE.TranslateMarkupToTable( str )
	str = string.gsub(str, "%</.-%>", "")
	str = string.gsub(str, "\t", " ")
	local chatargs = {}
	local tbl = {}
	local x = ""
	string.gsub(str, "%<.-%>", function(...)
		local args = {...}
		for k, v in ipairs(args) do
			str = string.gsub(str, v, "\t")
			table.insert(tbl,#tbl+1, v)
		end  
	end )
	for k, s in ipairs(tbl) do
		local e, c
		e = string.find(str, "\t", 1, true)
		if(e > 1) then
			table.insert(chatargs,#chatargs+1, string.sub(str,1,e))
			str = string.sub(str, e)
		end
		str = string.sub(str, 2)
		s = string.gsub( s, "<", "" )
		s = string.gsub( s, ">", "" )
		if string.match(s, ",") then
			s = string.gsub( s, " ", "" )
			s = string.gsub( s, "color=", "" )
			e = string.Explode(",", s)
			c = Color(math.Clamp(tonumber(e[1]or 0) or 255, 0, 255),math.Clamp(tonumber(e[2] or 0), 0, 255),math.Clamp(tonumber(e[3] or 0), 0, 255),255)
			table.insert(chatargs,#chatargs+1, c)
		elseif type(s) == "string" then
			if string.match(s, "font=") then
				s = string.gsub( s, "font=", "" )
				table.insert(chatargs,#chatargs+1,{ ["font"] = s })
			elseif string.match(s, "player=") then
				s = string.gsub( s, "player=", "" )
				table.insert(chatargs,#chatargs+1,player.GetByUniqueID(s))
			else
				s = string.gsub( s, " ", "" )
				s = string.gsub( s, "color=", "" )
				table.insert(chatargs,#chatargs+1,colourmap[s] or colourmap["black"])
			end
		end
	end
	if string.len(str) > 0 then
		table.insert(chatargs,#chatargs+1, str)
	end
	//PrintTable(chatargs)
	return unpack(chatargs)
end


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
		decoded.font = "TiramisuChatFontOutline"
	elseif decoded.font == "TiramisuYellFont" then
		decoded.font = "TiramisuYellFontOutline"
	elseif decoded.font == "TiramisuWhisperFont" then
		decoded.font = "TiramisuWhisperFontOutline"
	elseif decoded.font == "TiramisuEmoteFont" then
		decoded.font = "TiramisuEmoteFontOutline"
	elseif decoded.font == "TiramisuOOCFont" then
		decoded.font = "TiramisuOOCFontOutline"
	end
	if decoded.channel == "IC" then
		CAKE.Chatbox:AddLine( decoded.channel, decoded.handler or "", CAKE.TranslateMarkupToTable("<color=135,209,255,255><font=" .. decoded.font .. ">" .. text .. "</font></color>"))
	else
		CAKE.Chatbox:AddLine( decoded.channel, decoded.handler or "", CAKE.TranslateMarkupToTable("<font=" .. decoded.font .. ">" .. text .. "</font>"))
	end
end)

--Same as above, it is only being sent as a different net hook for it to print properly on console (IE, so that the </color> part is not printed)
net.Receive( "TiramisuAddToOOC", function( len )
	local decoded = net.ReadTable()
	local color = decoded.color
	local ply = decoded.player
	local playername = decoded.name
	local text = decoded.text

	text = text:gsub("<%s*%w*%s*=%s*%w*%s*>", "")
	text = text:gsub("</font>", "")
	text = text:gsub("<%s*%w*%s*=%s*%w*%s*,%s*%w*%s*,%s*%w*%s*,%s*%w*%s*>", "")
	text = text:gsub("</color>", "")
	CAKE.Chatbox:AddLine( "OOC", "" , CAKE.TranslateMarkupToTable("<font=TiramisuOOCFontOutline><color=white>[OOC]</color><color=" .. tostring( color.r ) .. "," .. tostring( color.g ) .. "," .. tostring( color.b ) .. "><player=" .. ply:UniqueID() .. "></color><color=white> :" .. text .. "</color></font>" ))
end)

local PANEL = {}

function PANEL:Init()
	self.IsVisible = true
	self.lines = {}

	self.LHeight = 0
	self.txtPanel = vgui.Create("Panel", self)
	self.txtPanel:SetPos(0,0)

	self.VBar = vgui.Create("DVScrollBar", self)
	self.VBar.Paint = function(selfbar, w, h )
	    if self.IsVisible then derma.SkinHook( "Paint", "VScrollBar", selfbar, w, h ) end
    	return true
	end

end

function PANEL:SetPrintMessages( b )
	self.PrintMessages = b
end

function PANEL:SetAlpha( alpha )
	self.alpha = alpha
end

function PANEL:GetAlpha()
	return self.alpha
end

function PANEL:labelHelper(text, color, font)
	if self.PrintMessages then MsgC( color, text ) end
	local label = vgui.Create( "DLabel" )
	label.timestamp = CurTime()
	label.color = color or Color(255,255,255,255)
	label.color.a = 255
	label.ApplySchemeSettings = function( self )
		self:SetFGColor( self.color )
	end
	label.Paint = function()
		surface.SetTextColor(label.color )
		surface.SetTextPos( 0, 0 )
		surface.SetFont(font or "ChatFont")
		surface.DrawText( label:GetText() )
	end
	label:SetFont( font or "ChatFont" )
	label:SetText( text )
	label:SizeToContents( )
	surface.SetFont(font or "ChatFont" )
	return label, surface.GetTextSize(text)
end

function PANEL:PlayerLabelHelper(ply, text, color, font)
	if self.PrintMessages then MsgC( color, text ) end
	local label = vgui.Create( "DButton" )
	label.timestamp = CurTime()
	label.color = color or Color(255,255,255,255)
	label.color.a = 255
	label.isplayer = true
	label.PaintOver = function() end
	function label:Paint( w, h )
		surface.SetTextColor(self.color )
		surface.SetTextPos( 0, 0 )
		surface.SetFont(font or "ChatFont")
		surface.DrawText( text )
	end
	label.DoClick = function()
		MsgN("Clicked player label ", ply:SteamID())
	end
	label:SetText( "" )
	surface.SetFont( font or "ChatFont")
	local w, h = surface.GetTextSize(text)
	label:SetSize(w + 2, h + 2)
	return label, surface.GetTextSize(text)
end

function PANEL:AddText( ... )
	local textToAdd = { ... }
	local color = Color(255,255,255)
	local right = 0
	local height = 0
	local label,w,addLater
	local font = "ChatFont"
	for k,v in pairs(textToAdd) do
		if type(v) == "string" then
			label,w,h = self:labelHelper(v, color, font)
			if right+w > self:GetWide() then
				local len = string.len(v)
				local tot,chs,w = right, 0, 0
				for i=1,len do
					w = surface.GetTextSize(v[i])
					if tot + w >= self.txtPanel:GetWide() then
						break
					elseif tot + w >= self.txtPanel:GetWide() - 50 then
						if v[i] == " " then
							tot = tot + w
							chs = chs +1
							break
						end
					end
					tot = tot + w
					chs = chs +1
				end
				addLater = string.sub(v, chs+1)
				v = string.sub(v, 1, chs)
				label:SetText( v )
			end
			label:SetParent(self.txtPanel)
			label:SetPos(right,self.LHeight)
			height = math.max(height, h)
			right = right + w
			table.insert( self.lines, label )
		elseif type(v) == "Player" then
			label,w, h = self:PlayerLabelHelper(v, v:Name(), color)
			label:SetParent(self.txtPanel)
			label:SetPos(right,self.LHeight)
			height = math.max(height, h)
			right = right + w
			table.insert( self.lines, label )
		elseif type(v) == "table" and v.r then
			color = v
		elseif type(v) == "table" and v.font then
			font = v.font
		end
	end
	self.LHeight = self.LHeight + height
	self.txtPanel:SetTall(self.LHeight + 2)
	self:InvalidateLayout()
	if addLater then
		self:AddText(color, {["font"] = font},addLater)
	else
		Msg("\n")
	end
	self.VBar:SetScroll(self.VBar:GetScroll()+10000)
end

function PANEL:Think()
	if self.IsVisible then
		self.VBar:SetScroll(self.VBar:GetScroll()+1)
	end
end

function PANEL:PerformLayout( )
	-- This isn't called often, no need to cache values.
	self.VBar:SetPos(self:GetWide()-16, 0)
	self.VBar:SetSize(16, self:GetTall())
	self.VBar:SetUp(self:GetTall(), self.txtPanel:GetTall())
	self.txtPanel:SetPos(0,self.VBar:GetOffset())
	self.txtPanel:SetSize(self:GetWide()-16, self.txtPanel:GetTall())
end

function PANEL:Hide( )
	-- We should hide the scrollbar here, but it refuses. (Maybe some hack could work?)
	self.IsVisible = false
	self.VBar:SetVisible(false)
	self.VBar.btnUp:SetVisible(false)
	self.VBar.btnDown:SetVisible(false)
	self.VBar.btnGrip:SetVisible(false)
end

function PANEL:Show( )
	self.IsVisible = true
	self.VBar:SetVisible(true)
	self.VBar.btnUp:SetVisible(true)
	self.VBar.btnDown:SetVisible(true)
	self.VBar.btnGrip:SetVisible(true)
	for _, label in pairs(self.lines) do
		label.color.a = 255
		label:SetFGColor(unpack(label.color))
	end
end

function PANEL:Paint( )
	if !self.IsVisible then
		for _, label in pairs(self.lines) do
			if CurTime() > label.timestamp + 15 then
				if label.isplayer then
					label.color.a = 0
				else
					label.color.a = 0
					label:SetFGColor(unpack(label.color))
				end
			elseif CurTime() > label.timestamp + 10 then
				if label.isplayer then
					label.color.a = math.max(label.color.a - FrameTime() * 200, 0)
				else
					label.color.a = math.max(label.color.a - FrameTime() * 100, 0)
					label:SetFGColor(unpack(label.color))
				end
			end
		end
	end
	//surface.SetDrawColor( 50, 50, 50,0)
	//surface.DrawRect( 0, 0, self:GetWide( ), self:GetTall( ) )
end

vgui.Register( "ChatPanel", PANEL, "EditablePanel" )

PANEL = {}
function PANEL:Init()
 
	self:SetFocusTopLevel( true )

	self.Channels = {}
	self.Color = CAKE.BaseColor
	self:ShowCloseButton( false )
	self:SetTitle( "" )
	
	self.Height = math.Round(( ScrH() / 3 ) / 10 ) * 10
	self.Width = self.Height * 2
	self.Alpha = 0
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
	self:AddChannel( "All", "All Messages", "", true, true )
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
		self.TextEntry:SetText("")
		self.TextEntry:SetCaretPos( 0 )
	end 
end

function PANEL:AddChannel( name, description, handler, cantclose, printmessages )

	local steps
	local x, y
	if !self.Channels[ name ] then
		local panel = vgui.Create( "ChatPanel" )
		panel:SetPrintMessages( printmessages )
		self.Channels[ name ] = panel
		local tab = self.PropertySheet:AddSheet( name, panel, "gui/silkicons/user.vtf", false, false, description or name )
		panel:SetWide(self.PropertySheet:GetWide())
		tab.Tab.handler = handler or ""
		if cantclose then
			tab.Tab.CantBeClosed = true
		else
			tab.Tab.DoClick = function()
				tab.Tab:GetPropertySheet():SetActiveTab( tab.Tab )
				if input.IsMouseDown(MOUSE_LEFT) then
					local menu = DermaMenu()
					menu:AddOption("Close", function()
						self.PropertySheet:CloseTab(tab.Tab, true)
					end)
					menu:Open()
				end
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
			item.Tab.Image:SetVisible( false )
		end
	end

end

--Doesn't actually close the chatbox, simply hides it.
function PANEL:Close()
	for k, v in pairs(self.Channels) do
		v:Hide()
	end
	self.LastTimeOpen = CurTime()
	self.Open = false
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
	gui.EnableScreenClicker( false )
	if self.PropertySheet.tabScroller then
		self.PropertySheet.tabScroller:SetVisible( false )
	end



	LocalPlayer( ):ConCommand( "rp_closedchat" )

end

function PANEL:OpenChat()

	if !self.Open then
		for k, v in pairs(self.Channels) do
			v:Show()
		end
		self.Open = true
		self:SetKeyboardInputEnabled(true)
		self:SetMouseInputEnabled(true)
		self:MakePopup()
		self.TextEntry:RequestFocus()
		self.TextEntry:SetText("")
		gui.EnableScreenClicker( true )
		LocalPlayer( ):ConCommand( "rp_openedchat" )
		if self.PropertySheet.tabScroller then
			self.PropertySheet.tabScroller:SetVisible( true )
		end
	end
end
 
--Adds a line to a particular channel. If no channel is specified it simply becomes global.
function PANEL:AddLine( channel, handler, ... )
	
	if channel then
		if !self.Channels[ channel ] then
			self:AddChannel( channel, "", handler )
		end
		self.Channels[ channel ]:AddText( ...)
	end

	chat.AddText( ... ) //Add it to the all channel

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


--Calculations to determine which lines fade out.
local linetbl = {}
local tblcount
local tbl
function PANEL:Think()

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

function PANEL:OnMousePressed()
 
	self:OpenChat()
 
end

vgui.Register( "TiramisuChatBox", PANEL, "DFrame")

function chat.AddText(...) --Overriding default chat text entry
	if CAKE.Chatbox and CAKE.Chatbox.Channels and CAKE.Chatbox.Channels[ "All" ] then
		CAKE.Chatbox.Channels[ "All" ]:AddText(...)
	end
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
