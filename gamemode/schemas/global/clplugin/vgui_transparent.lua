CLPLUGIN.Name = "Transparent Frame"
CLPLUGIN.Author = "Overv"

--Credits for Overv, who posted this on the WAYWO thread. I just added the pretentious line crap

function CLPLUGIN.Init()
	
end

local PANEL = {} 
   
local matBlurScreen = Material( "pp/blurscreen" ) 
   
AccessorFunc( PANEL, "m_bDraggable",            "Draggable",            FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable",                      "Sizable",                      FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock",           "ScreenLock",           FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose",        "DeleteOnClose",        FORCE_BOOL )
 
AccessorFunc( PANEL, "m_bBackgroundBlur",       "BackgroundBlur",       FORCE_BOOL )
 
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:Init()
 
        self:SetFocusTopLevel( true )
        
        self.btnClose = vgui.Create( "DSysButton", self )
        self.btnClose:SetType( "close" )
        self.btnClose.DoClick = function ( button ) self:Close() end
        self.btnClose:SetDrawBorder( false )
        self.btnClose:SetDrawBackground( false )
        self.Color = CAKE.BaseColor
        
        self.lblTitle = vgui.Create( "DLabel", self )
        
        self:SetDraggable( true )
        self:SetSizable( false )
        self:SetScreenLock( true )
        self:SetDeleteOnClose( true )
        self:SetTitle( "#Untitled DFrame" )
        
        // This turns off the engine drawing
        self:SetPaintBackgroundEnabled( false )
        self:SetPaintBorderEnabled( false )
        
        self.m_fCreateTime = SysTime()
 
end

function PANEL:SetColor( color )

    self.Color = color

end
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:ShowCloseButton( bShow )
 
        self.btnClose:SetVisible( bShow )
 
end
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:SetTitle( strTitle )
 
        self.lblTitle:SetText( strTitle )
 
end
 
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:Close()
 
        self:SetVisible( false )
 
        if ( self:GetDeleteOnClose() ) then
                self:Remove()
        end
 
end
 
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:Center()
 
        self:InvalidateLayout( true )
        self:SetPos( ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2 )
 
end
 
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:Think()
 
        if (self.Dragging) then
        
                local x = gui.MouseX() - self.Dragging[1]
                local y = gui.MouseY() - self.Dragging[2]
 
                // Lock to screen bounds if screenlock is enabled
                if ( self:GetScreenLock() ) then
                
                        x = math.Clamp( x, 0, ScrW() - self:GetWide() )
                        y = math.Clamp( y, 0, ScrH() - self:GetTall() )
                
                end
                
                self:SetPos( x, y )
        
        end
        
        
        if ( self.Sizing ) then
        
                local x = gui.MouseX() - self.Sizing[1]
                local y = gui.MouseY() - self.Sizing[2] 
        
                self:SetSize( x, y )
                self:SetCursor( "sizenwse" )
                return
        
        end
        
        if ( self.Hovered &&
         self.m_bSizable &&
             gui.MouseX() > (self.x + self:GetWide() - 20) &&
             gui.MouseY() > (self.y + self:GetTall() - 20) ) then       
 
                self:SetCursor( "sizenwse" )
                return
                
        end
        
        if ( self.Hovered && self:GetDraggable() ) then
                self:SetCursor( "sizeall" )
        end
        
end
 
local x, y
local lastpos

function PANEL:Paint()  
    x, y = self:ScreenToLocal( 0, 0 ) 
    lastpos = 0
       
    // Background 
    surface.SetMaterial( matBlurScreen ) 
    surface.SetDrawColor( 255, 255, 255, 255 ) 
       
    matBlurScreen:SetMaterialFloat( "$blur", 5 ) 
    render.UpdateScreenEffectTexture() 
       
    surface.DrawTexturedRect( x, y, ScrW(), ScrH() ) 
       
    surface.SetDrawColor( self.Color.r, self.Color.g, self.Color.b, 150 ) 
    surface.DrawRect( x, y, ScrW(), ScrH() ) 

    // Pretentious line bullshit :P
    x = math.floor( self:GetWide() / 5 )
    y = math.floor( self:GetTall() / 5 )

    surface.SetDrawColor( 50, 50, 50, 80 ) 

    for i = 1, y + 5 do
        surface.DrawLine( 0, ( i * 5 ) + 23, (y * 5) - (i * 5), self:GetTall() + 23 )
    end

    for i = 0, x + 5 do
        surface.DrawLine( i * 5 , 23, self:GetWide(), ( x * 5 ) - ( i * 5 ) + 23 )
    end

    // and some gradient shit for additional overkill

    for i = 1, ( y + 5 ) do
        surface.SetDrawColor( math.Clamp( self.Color.r - 50, 0, 255 ), math.Clamp( self.Color.g - 50,0, 255 ), math.Clamp( self.Color.b - 50, 0, 255 ), Lerp( i / ( ( y + 5 ) ), 0 , 245 ) ) 
        surface.DrawRect( 0, ( i * 5 ) , self:GetWide(), 5 )
    end

    // Border 
    surface.SetDrawColor( math.Clamp( self.Color.r - 50, 0, 255 ), math.Clamp( self.Color.g - 50,0, 255 ), math.Clamp( self.Color.b - 50, 0, 255 ), 255 ) 
    surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
    surface.DrawLine( 0, 23, self:GetWide(), 23 )
       
    return true 
end

 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:OnMousePressed()
 
        if ( self.m_bSizable ) then
        
                if ( gui.MouseX() > (self.x + self:GetWide() - 20) &&
                        gui.MouseY() > (self.y + self:GetTall() - 20) ) then                    
        
                        self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
                        self:MouseCapture( true )
                        return
                end
                
        end
        
        if ( self:GetDraggable() ) then
                self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
                self:MouseCapture( true )
                return
        end
        
 
 
end
 
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:OnMouseReleased()
 
        self.Dragging = nil
        self.Sizing = nil
        self:MouseCapture( false )
 
end
 
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:PerformLayout()
 
        derma.SkinHook( "Layout", "Frame", self )
 
end
 
 
/*---------------------------------------------------------
 
---------------------------------------------------------*/
function PANEL:IsActive()
 
        if ( self:HasFocus() ) then return true end
        if ( vgui.FocusedHasParent( self ) ) then return true end
        
        return false
 
end

derma.DefineControl( "DFrameTransparent", "Cool transparent DFrame", PANEL, "EditablePanel" )