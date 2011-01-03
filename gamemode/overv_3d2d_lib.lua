/*-------------------------------------------------------------------------------------------------------------------------
        3D2D vgui wrapper
                By Overv
-------------------------------------------------------------------------------------------------------------------------*/
 
local origin, angle, normal, scale
 
/*-------------------------------------------------------------------------------------------------------------------------
        Helper functions
-------------------------------------------------------------------------------------------------------------------------*/
 
local function planeLineIntersect( lineStart, lineEnd, planeNormal, planePoint )
        local t = planeNormal:Dot( planePoint - lineStart ) / planeNormal:Dot( lineEnd - lineStart )
        return lineStart + t * ( lineEnd - lineStart )
end
 
local function getCursorPos()
        if normal or origin then
                local p = planeLineIntersect( LocalPlayer():EyePos(), LocalPlayer():EyePos() + LocalPlayer():GetCursorAimVector() * 16000, normal, origin )
                local offset = origin - p
                
                local angle2 = angle:Angle()
                angle2:RotateAroundAxis( normal, 90 )
                angle2 = angle2:Forward()
                
                local x = Vector( offset.x * angle.x, offset.y * angle.y, offset.z * angle.z ):Length()
                local y = Vector( offset.x * angle2.x, offset.y * angle2.y, offset.z * angle2.z ):Length()
                
                return x, y
        else
                return gui.MousePos()
        end
end
 
local function getParents( pnl )
        local parents = {}
        local parent = pnl.Parent
        while ( parent ) do
                table.insert( parents, parent )
                parent = parent.Parent
        end
        return parents
end
 
local function absolutePanelPos( pnl )
        local x, y = pnl:GetPos()
        local parents = getParents( pnl )
        
        for _, parent in ipairs( parents ) do
                local px, py = parent:GetPos()
                x = x + px
                y = y + py
        end
        
        return x, y
end
 
local function pointInsidePanel( pnl, x, y )
        local px, py = absolutePanelPos( pnl )
        local sx, sy = pnl:GetSize()
        return x >= px and y >= py and x <= px + sx and y <= py + sy
end
 
/*-------------------------------------------------------------------------------------------------------------------------
        Input
-------------------------------------------------------------------------------------------------------------------------*/
 
local inputWindows = {}
 
 function gui.MouseX()
        local x, y = getCursorPos()
        return x
end
function gui.MouseY()   
        local x, y = getCursorPos()
        return y
end
 
local function isMouseOver( pnl )
        return pointInsidePanel( pnl, getCursorPos() )
end
 
local function checkHover( pnl )
        pnl.Hovered = isMouseOver( pnl )
        
        for child, _ in pairs( pnl.Childs or {} ) do
                if ( child:IsValid() ) then checkHover( child ) end
        end
end
 
local function postPanelEvent( pnl, event, ... )
        if ( !pnl:IsValid() or !pointInsidePanel( pnl, getCursorPos() ) ) then return false end
        
        local handled = false
        
        for child in pairs( pnl.Childs or {} ) do
                if ( postPanelEvent( child, event, ... ) ) then
                        handled = true
                        break
                end
        end
        
        if ( !handled and pnl[ event ] ) then
                pnl[ event ]( pnl, ... )
                return true
        else
                return false
        end
end
 
/*-------------------------------------------------------------------------------------------------------------------------
        Mouse input
-------------------------------------------------------------------------------------------------------------------------*/
 
hook.Add( "KeyPress", "VGUI3D2DMousePress", function( _, key )
        if ( key == IN_ATTACK ) then
                for pnl in pairs( inputWindows ) do
                        if ( pnl:IsValid() ) then
                                origin = pnl.Origin
                                scale = pnl.Scale
                                angle = pnl.Angle
                                normal = pnl.Normal
                                
                                postPanelEvent( pnl, "OnMousePressed", MOUSE_LEFT )
                        end
                end
        end
end )

hook.Add( "GUIMousePressed", "VGUI3D2DCursorPress", function( key, _ )
        if ( key == MOUSE_LEFT ) then
                for pnl in pairs( inputWindows ) do
                        if ( pnl:IsValid() ) then
                                origin = pnl.Origin
                                scale = pnl.Scale
                                angle = pnl.Angle
                                normal = pnl.Normal
                                
                                postPanelEvent( pnl, "OnMousePressed", MOUSE_LEFT )
                        end
                end
        end
end )
 
hook.Add( "KeyRelease", "VGUI3D2DMouseRelease", function( _, key )
        if ( key == IN_ATTACK ) then
                for pnl in pairs( inputWindows ) do
                        if ( pnl:IsValid() ) then
                                origin = pnl.Origin
                                scale = pnl.Scale
                                angle = pnl.Angle
                                normal = pnl.Normal
                                
                                postPanelEvent( pnl, "OnMouseReleased", MOUSE_LEFT )
                        end
                end
        end
end )

hook.Add( "GUIMouseReleased", "VGUI3D2DCursorRelease", function( key, _ )
        if ( key == MOUSE_LEFT ) then
                for pnl in pairs( inputWindows ) do
                        if ( pnl:IsValid() ) then
                                origin = pnl.Origin
                                scale = pnl.Scale
                                angle = pnl.Angle
                                normal = pnl.Normal
                                
                                postPanelEvent( pnl, "OnMouseReleased", MOUSE_LEFT )
                        end
                end
        end
end )
 
/*-------------------------------------------------------------------------------------------------------------------------
        Key input
-------------------------------------------------------------------------------------------------------------------------*/
 
 
 
/*-------------------------------------------------------------------------------------------------------------------------
        Drawing
-------------------------------------------------------------------------------------------------------------------------*/
 
function vgui.Start3D2D( pos, ang, res )
        origin = pos
        scale = res
        angle = ang:Forward()
        
        normal = Angle( ang.p, ang.y, ang.r )
        normal:RotateAroundAxis( ang:Forward(), -90 )
        normal:RotateAroundAxis( ang:Right(), 90 )
        normal = normal:Forward()
        
        cam.Start3D2D( pos, ang, res )
end
 
function _R.Panel:Paint3D2D()
        if ( !self:IsValid() ) then return end
        
        // Add it to the list of windows to receive input
        inputWindows[ self ] = true
        
        // Override think of DFrame's to correct the mouse pos by changing the active orientation
        if ( !self.OThink ) then
                self.OThink = self.Think
                
                self.Think = function()
                        origin = self.Origin
                        scale = self.Scale
                        angle = self.Angle
                        normal = self.Normal
                        
                        self:OThink()
                end
        end
        
        // Update the hover state of controls
        checkHover( self )
        
        // Store the orientation of the window to calculate the position outside the render loop
        self.Origin = origin
        self.Scale = scale
        self.Angle = angle
        self.Normal = normal
        
        // Draw it manually
        self:SetPaintedManually( false )
                self:PaintManual()
        self:SetPaintedManually( true )
end
 
function vgui.End3D2D()
        cam.End3D2D()
end
 
/*-------------------------------------------------------------------------------------------------------------------------
        Keep track of child controls
-------------------------------------------------------------------------------------------------------------------------*/
 
if ( !vguiCreate ) then vguiCreate = vgui.Create end
function vgui.Create( class, parent )
        local pnl = vguiCreate( class, parent )
        
        pnl.Parent = parent
        pnl.Class = class
        
        if ( parent ) then
                if ( !parent.Childs ) then parent.Childs = {} end
                parent.Childs[ pnl ] = true
        end
        
        return pnl
end