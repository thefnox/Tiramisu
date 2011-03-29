datastream.Hook( "TiramisuAddToChat", function( handler, id, encoded, decoded )
    if decoded.channel == "IC" then
        CAKE.Chatbox:AddLine(  "<color=135,209,255,255><font=" .. decoded.font .. ">" .. decoded.text .. "</font></color>", decoded.channel )
    else
        CAKE.Chatbox:AddLine(  "<font=" .. decoded.font .. ">" .. decoded.text .. "</font>", decoded.channel )
    end

    for i = 0, decoded.text:len() / 255 do
        MsgN(string.sub( decoded.text, i * 255 + 1, i * 255 + 255 ) )
    end
end)

datastream.Hook( "TiramisuAddToOOC", function( handler, id, encoded, decoded )
    
    local color = decoded.color
    local playername = decoded.name
    local text = decoded.text

    CAKE.Chatbox:AddLine(  "<font=ChatFont><color=white>[OOC]</color><color=" .. tostring( color.r ) .. "," .. tostring( color.g ) .. "," .. tostring( color.b ) .. ">".. playername .. "</color><color=white>:" .. text .. "</color></font>", "OOC" )

    text = "[OOC]" .. playername .. ": " .. text

    for i = 0, text:len() / 255 do
        MsgN(string.sub( text, i * 255 + 1, i * 255 + 255 ) )
    end
end)

/*
function AddOOCLine( handler, id, encoded, decoded )

	local text = decoded.text
	local playername = decoded.playername
	local color = decoded.color
	chat.AddText( Color(255,255,255,255), "[OOC]", color, playername, Color(255,255,255,255), " :", Color(255,255,255,255), text )
 
end
datastream.Hook( "AddOOCLine", AddOOCLine );*/

local matBlurScreen = Material( "pp/blurscreen" ) 
local PANEL = {}
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:Init()
 
        self:SetFocusTopLevel( true )
        
        /*
        self.btnClose = vgui.Create( "DSysButton", self )
        self.btnClose:SetType( "close" )
        self.btnClose.DoClick = function ( button ) self:Close() end
        self.btnClose.PaintOver = function()
            self.btnClose:SetVisible( self.Open )
        end
        self.btnClose:SetDrawBorder( false )
        self.btnClose:SetDrawBackground( false )*/
        self.Channels = {}
        self.Color = CAKE.BaseColor
        self:ShowCloseButton( false )
        self:SetTitle( "" )
        
        self.Height = math.Round(( ScrH() / 3 ) / 10 ) * 10
        self.Width = self.Height * 2
        self.Alpha = 0
        self.Lines = {}
        self:SetSize( self.Width, self.Height )
        self:SetPos( 20, ScrH() - self.Height - 40 )
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
        self:AddChannel( "All", "All Messages" )
        self:AddChannel( "IC", "In Character" )
        self:AddChannel( "OOC", "Out Of Character" )

        self.TextEntry = vgui.Create( "DTextEntry", self )
        self.TextEntry:SetSize( self.Width - 13, 25 )
        self.TextEntry:SetPos( 5, self.Height - 30 )
        self.TextEntry.Paint = function()
            
            if self.Open then
                draw.RoundedBox( 2, 2, 2, self.TextEntry:GetWide(), self.TextEntry:GetTall(), Color( 50, 50, 50, self.Alpha ) )
                self.TextEntry:DrawTextEntryText( Color( 200, 200, 200, 240 ), self.TextEntry.m_colHighlight, self.TextEntry.m_colCursor )
            end

        end
        self.TextEntry.OnEnter = function()
            if self.TextEntry:GetValue() != "" then
                if self.TextEntry:GetValue():len() > 600 then
                    datastream.StreamToServer( "TiramisuChatHandling", { ["text"] = string.sub( string.Replace(self.TextEntry:GetValue(), "\"", "'"), 1, 600 ) } )
                else
                    datastream.StreamToServer( "TiramisuChatHandling", { ["text"] = string.Replace(self.TextEntry:GetValue(), "\"", "'") } )
                end
                self.TextEntry:Clear()
                self:Close()
            else
                self.TextEntry:Clear()
                self:Close()
            end
        end
        self.TextEntry.Clear = function()
            self.TextEntry:SetValue("")
            self.TextEntry:SetCaretPos( 0 )
        end
 
end

function PANEL:AddChannel( name, description )

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
        self.PropertySheet:AddSheet( name, panel, "", false, false, description or name )
        self.PropertySheet:InvalidateLayout( true, true ) 
        for _,item in pairs( self.PropertySheet.Items ) do
            item.Tab.Paint = function()
                if ( item.Tab:GetPropertySheet():GetActiveTab() == item.Tab ) then
                    draw.RoundedBox( 2, 0, 0, item.Tab:GetWide() - 8, item.Tab:GetTall(), Color( 40, 40, 40, self.Alpha ) )
                    item.Tab:SetTextColor( Color( 170, 170, 170, self.Alpha ) )
                else
                    draw.RoundedBox( 2, 1, 1, item.Tab:GetWide() - 9, item.Tab:GetTall() - 1, Color( 90, 90, 90, self.Alpha ))
                    item.Tab:SetTextColor( Color( 170, 170, 170, self.Alpha ) )
                end
            end
		    if ( item.Tab.Image ) then
		        item.Tab.Image:SetVisible( false )
		   	end
        end
    end

end

function PANEL:AddLine( text, channel )

    local label = MarkupLabel( text, self.Width - 25 )
    local number = #self.Lines + 1
    self.Lines[ number ] = {}
    self.Lines[ number ][ "panel" ] = label
    self.Lines[ number ][ "timestamp" ] = CurTime()
    self.Channels[ "All" ]:AddItem( label )

    if channel then
        self:AddChannel( channel )
        label = MarkupLabel( text, self.Width - 25 )
        local number = #self.Lines + 1
        self.Lines[ number ] = {}
        self.Lines[ number ][ "panel" ] = label
        self.Lines[ number ][ "timestamp" ] = CurTime()
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
function PANEL:Close()

    self.Open = false
    self:SetKeyboardInputEnabled(false)
    self:SetMouseInputEnabled(false)
    gui.EnableScreenClicker( false )
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
    end
end
 
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
local linetbl = {}
function PANEL:Think()
    if self.Lines and !self.Open then
        for k, v in pairs( self.Lines ) do
            if v[ "timestamp" ] + 10 < CurTime() then
                v[ "panel" ]:SetAlpha( Lerp( 0.05, v[ "panel" ]:GetAlpha() , 0 ) )
            end
        end
    else
        for k, v in pairs( self.Lines ) do
            v[ "panel" ]:SetAlpha( 255 )
        end
    end
    if self.Open and input.IsKeyDown(KEY_ESCAPE) then
        self:Close()
    end
end
 
local x, y
local lastpos
local color

function PANEL:Paint()

    if !self.Alpha then
        self.Alpha = 0
    else
        if !self.Open then
            self.Alpha = Lerp( 0.2, self.Alpha, 0 )
        else
             self.Alpha = Lerp( 0.2, self.Alpha, 150 )
        end
    end

    x, y = self:ScreenToLocal( 0, 0 ) 
    lastpos = 0
    color = self.Color or CAKE.BaseColor or Color( 100, 100, 115, 150 )
       
    // Background 
    surface.SetMaterial( matBlurScreen ) 
    surface.SetDrawColor( 255, 255, 255, self.Alpha or 0 ) 
       
    matBlurScreen:SetMaterialFloat( "$blur", self.Alpha or 0 / 50 ) 
    render.UpdateScreenEffectTexture() 
       
    surface.DrawTexturedRect( x, y, ScrW(), ScrH() ) 

    if ( self.m_bBackgroundBlur ) then
        Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    end
       
    surface.SetDrawColor( color.r, color.g, color.b, self.Alpha or 0 ) 
    surface.DrawRect( x, y, ScrW(), ScrH() ) 

    surface.SetDrawColor( 50, 50, 50, math.Clamp( self.Alpha or 0 - 50, 0, 255 ) ) 

    for i = 1, self:GetWide() / 5 * 2  do
        surface.DrawLine( ( i * 5 ), 0, 0, ( i * 5 ) )
    end

    // Pretentious line bullshit :P
    x = math.floor( self:GetWide() / 5 )
    y = math.floor( self:GetTall() / 5 )

    // and some gradient shit for additional overkill

    for i = 1, ( y + 5 ) do
        surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), Lerp( i / ( ( y + 5 ) ), 0 , self.Alpha or 0 ) ) 
        surface.DrawRect( 0, ( i * 5 ) , self:GetWide(), 5 )
    end

    // Border 
    surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), self.Alpha or 0 ) 
    surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
       
    return true 
end

function PANEL:PerformLayout()
end
 
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
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