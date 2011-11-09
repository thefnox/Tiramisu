CLPLUGIN.Name = "VGUI Elements"
CLPLUGIN.Author = "FNox, Garry, Overv, et al"

--Credits for Overv, who posted this on the WAYWO thread. I just added the pretentious line crap

--DFrame. A copy of DFrame with a much better looking interface. Also, colourable.

function CLPLUGIN.Init()
	
end

local PANEL = {} 
   
local matBlurScreen = Material( "pp/blurscreen" ) 
   
AccessorFunc( PANEL, "m_bDraggable",         "Draggable",         FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable",             "Sizable",             FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock",         "ScreenLock",         FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose",     "DeleteOnClose",     FORCE_BOOL )
AccessorFunc( PANEL, "m_iMinWidth",         "MinWidth" )
AccessorFunc( PANEL, "m_iMinHeight",         "MinHeight" )

AccessorFunc( PANEL, "m_bBackgroundBlur",     "BackgroundBlur",     FORCE_BOOL )
 
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
 
        self.lblTitle:SetText( tostring( strTitle ))
 
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
local color

function PANEL:Paint()  

    x, y = self:ScreenToLocal( 0, 0 ) 
    color = self.Color or CAKE.BaseColor or Color( 100, 100, 115, 150 )
       
    // Background 
    surface.SetMaterial( matBlurScreen ) 
    surface.SetDrawColor( 255, 255, 255, 255 ) 
       
    matBlurScreen:SetMaterialFloat( "$blur", 5 ) 
    render.UpdateScreenEffectTexture() 
       
    surface.DrawTexturedRect( x, y, ScrW(), ScrH() ) 

    if ( self.m_bBackgroundBlur ) then
        Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    end
       
    surface.SetDrawColor( color.r, color.g, color.b, 150 ) 
    surface.DrawRect( x, y, ScrW(), ScrH() ) 

    // Pretentious line bullshit :P
    x = math.floor( self:GetWide() / 5 )
    y = math.floor( self:GetTall() / 5 )

    surface.SetDrawColor( 50, 50, 50, 80 ) 

    for i = 1, self:GetWide() / 5 * 2  do
        surface.DrawLine( ( i * 5 ), 23, 0, ( i * 5 ) + 23 )
    end

    // and some gradient shit for additional overkill

    for i = 1, ( y + 5 ) do
        surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), Lerp( i / ( ( y + 5 ) ), 0 , 245 ) ) 
        surface.DrawRect( 0, ( i * 5 ) , self:GetWide(), 5 )
    end

    // Border 
    surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), 255 ) 
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

derma.DefineControl( "DFrame", "Cool transparent DFrame", PANEL, "EditablePanel" )

--PlayerPanel. A 3D panel that draws the player and his/her clothing and gear. With mouse rotation/zooming.

PANEL = {}
 
AccessorFunc( PANEL, "m_fAnimSpeed",    "AnimSpeed" )
AccessorFunc( PANEL, "Entity",                  "Entity" )
AccessorFunc( PANEL, "vCamPos",                 "CamPos" )
AccessorFunc( PANEL, "fFOV",                    "FOV" )
AccessorFunc( PANEL, "vLookatPos",              "LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor",                "Color" )
AccessorFunc( PANEL, "bAnimated",               "Animated" )
 
 
/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

        self.LastPaint = 0
        self.DirectionalLight = {}
        
        self:SetCamPos( LocalPlayer():GetForward() * 80 + Vector( 0, 0, 40 ) )
        local plyangle = LocalPlayer():GetAngles()
        plyangle:RotateAroundAxis(plyangle:Up(), 180) 
        self:SetCamAngle(  plyangle )
        self:SetFOV( 70 )
        
        self:SetText( "" )
        self:SetAnimSpeed( 0.5 )
        self:SetAnimated( false )
        
        self:SetAmbientLight( Color( 50, 50, 50 ) )
        
        self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
        self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
        
        self:SetColor( Color( 255, 255, 255, 255 ) )
 
end
 
/*---------------------------------------------------------
   Name: SetDirectionalLight
---------------------------------------------------------*/
function PANEL:SetDirectionalLight( iDirection, color )
        self.DirectionalLight[iDirection] = color
end

function PANEL:SetCamAngle( angle )
        self.CamAngle = angle
end

function PANEL:GetCamAngle()
        return self.CamAngle or Angle( 0, 0, 0 )
end
 
function PANEL:StartDraw()

        CAKE.ForceDraw = true
        
        // Note: Not in menu dll
        if ( !ClientsideModel ) then return end
        
        LocalPlayer():SetNoDraw( true )

        if CAKE.ClothingTbl then
            for k, v in pairs( CAKE.ClothingTbl ) do
                if ValidEntity( v ) then
                    v:SetNoDraw( true )
                    v.ForceDraw = true
                end
            end
        end

        if CAKE.Gear then
            for _, bone in pairs( CAKE.Gear ) do
                if bone then
                    for k, v in pairs( bone ) do
                        if ValidEntity( v.entity ) then
                            v.entity:SetNoDraw( true )
                        end
                    end
                end
            end
        end
        
end

function PANEL:SetTarget( entity )
    if ValidEntity( entity ) then
        self.CamTarget = entity
        self:SetCamPos( self.CamTarget:GetForward() * 80 )
        local angle = self.CamTarget:GetAngles()
        angle:RotateAroundAxis(angle:Up(), 180) 
        self:SetCamAngle( angle )
    end
end 

function PANEL:EndDraw()
        
        // Note: Not in menu dll
        if ( !ClientsideModel ) then return end
        
        LocalPlayer():SetNoDraw( false )

        if CAKE.ClothingTbl then
            for k, v in pairs( CAKE.ClothingTbl ) do
                if ValidEntity( v ) then
                    v:SetNoDraw( false )
                end
            end
        end

        if CAKE.Gear then
            for _, bone in pairs( CAKE.Gear ) do
                if bone then
                    for k, v in pairs( bone ) do
                        if ValidEntity( v.entity ) then
                            v.entity:SetNoDraw( false )
                        end
                    end
                end
            end
        end
        
end
 
/*---------------------------------------------------------
   Name: OnMousePressed
---------------------------------------------------------*/
function PANEL:Paint()
        
        self:StartDraw()

        if ( !IsValid( LocalPlayer() ) ) then return end
        
        local x, y = self:LocalToScreen( 0, 0 )
        
        cam.Start3D( LocalPlayer():GetPos() + self.vCamPos, self.CamAngle, 70, x, y, self:GetWide(), self:GetTall() )
            cam.IgnoreZ( true )
            
            render.SuppressEngineLighting( true )
            render.SetLightingOrigin( LocalPlayer():GetPos() )
            render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
            render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
            render.SetBlend( self.colColor.a/255 )
            
            for i=0, 6 do
                    local col = self.DirectionalLight[ i ]
                    if ( col ) then
                            render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
                    end
            end
                    
            LocalPlayer():DrawModel()
            LocalPlayer():CreateShadow()


            if CAKE.ClothingTbl then
                for k, v in pairs( CAKE.ClothingTbl ) do
                    if ValidEntity( v ) then
                        v:DrawModel()
                        v:CreateShadow()
                    end
                end
            end

            if CAKE.Gear then
                for _, bone in pairs( CAKE.Gear ) do
                    if bone then
                        for k, v in pairs( bone ) do
                            if ValidEntity( v.entity ) then
                                v.entity:DrawModel()
                                v.entity:CreateShadow()
                            end
                        end
                    end
                end
            end

            render.SuppressEngineLighting( false )
            cam.IgnoreZ( false )
        cam.End3D()
        
        self.LastPaint = RealTime()

        self:EndDraw()
        
end

--The mouse angle calculations are all here.
local angle
local distance = -80
local target
function PANEL:OnCursorMoved(x, y)
    target = self.CamTarget or LocalPlayer()
    if input.IsMouseDown( MOUSE_LEFT ) then
        angle = Angle(0, target:GetAngles().y, 0 )
        angle:RotateAroundAxis(angle:Up(), math.NormalizeAngle( 180 - ( x - self:GetWide()/ 2 ) / 2 ) )
        angle:RotateAroundAxis(angle:Right(), math.NormalizeAngle( 0 - ( y - self:GetTall()/ 2 ) / 2 ) )
        self:SetCamPos( angle:Forward() * distance + Vector( 0, 0, 40))
        self:SetCamAngle( angle )
    elseif input.IsMouseDown( MOUSE_RIGHT ) then
        distance =  ( y - self:GetTall()/ 2 ) + -80
        self:SetCamPos( Vector( 0, 0, 40) + self.CamAngle:Forward() * distance )
    end
end

derma.DefineControl( "PlayerPanel", "A panel containing the player's model", PANEL, "DButton" )

--MarkupLabel. Basically a regular label with markup.Parse support.

PANEL = {}
 
/*---------------------------------------------------------
        Init
---------------------------------------------------------*/
function PANEL:Init()

        self.Text = "Label"
        self.Str = markup.Parse("Label", self.MaxWidth)
        self.Alpha = 255
        self.Align = TEXT_ALIGN_LEFT
        self.VerticalAlign = TEXT_ALIGN_LEFT
        
end

function PANEL:Paint( )

    if self.Str then
	if self.BWidth and self.Align == TEXT_ALIGN_CENTER then
		print(self.BWidth/2)
		self.Str:Draw((self.BWidth/2)-(self.Str:GetWidth()/2), 0, TEXT_ALIGN_LEFT, self.VerticalAlign, self.Alpha)
	else
     		self.Str:Draw(2, 0, self.Align, self.VerticalAlign, self.Alpha)
	end
    end

end

function PANEL:SetMaxWidth( w )

    self.MaxWidth = tonumber(w) or self.MaxWidth
    self:SetText( self.Text )

end

function PANEL:SetMaxHeight( h )

    self.MaxHeight = tonumber( h ) or self.MaxHeight
    self:SetText( self.Text )

end

function PANEL:SetMaxSize( w, h )

    self.MaxWidth = tonumber(w) or self.MaxWidth
    self.MaxHeight = tonumber( h ) or self.MaxHeight
    self:SetText( self.Text )

end

function PANEL:SetText( s )

    self.Text = s
    self.Str = markup.Parse(tostring(s), self.MaxWidth or self:GetSize() )
    self:SetSize( self.MaxWidth or self:GetSize(), ( self.MaxHeight or self.Str:GetHeight() ) + 2 )

end

function PANEL:SetAlign( align )

    self.Align = align or TEXT_ALIGN_LEFT

end

function PANEL:SetVerticalAlign( align )

    self.VerticalAlign = align or TEXT_ALIGN_LEFT

end

function PANEL:SetAlpha( a )

    self.Alpha = math.Clamp( tonumber( a ), 0, 255 ) or 255

end    
 
function PANEL:GetAlpha()

    return self.Alpha or 255

end
 
vgui.Register( "MarkupLabel", PANEL, "Panel" )
 
 
/*---------------------------------------------------------
   Name: Convenience Function, creates a MarkupLabel and returns it.
---------------------------------------------------------*/
function MarkupLabel( strText, width, parent )
    
        local lbl = vgui.Create( "MarkupLabel", parent )
        lbl:SetWidth( width )
        lbl:SetText( strText )
        
        return lbl
 
end

function MarkupLabelBook(strText, width, containerwidth)
	    
        local lbl = vgui.Create( "MarkupLabel", parent )
        lbl:SetWidth( width )
        lbl:SetText( strText )
	lbl.BWidth = containerwidth
        
        return lbl
 
end