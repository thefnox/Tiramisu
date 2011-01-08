CLPLUGIN.Name = "Transparent Frame"
CLPLUGIN.Author = "Overv"

--Credits for Overv, who posted this on the WAYWO thread.

function CLPLUGIN.Init()
	
end

local PANEL = {} 
   
local matBlurScreen = Material( "pp/blurscreen" ) 
   
function PANEL:Init() 
end
   
function PANEL:Paint()  
    local x, y = self:ScreenToLocal( 0, 0 ) 
       
    // Background 
    surface.SetMaterial( matBlurScreen ) 
    surface.SetDrawColor( 255, 255, 255, 255 ) 
       
    matBlurScreen:SetMaterialFloat( "$blur", 5 ) 
    render.UpdateScreenEffectTexture() 
       
    surface.DrawTexturedRect( x, y, ScrW(), ScrH() ) 
       
    surface.SetDrawColor( 100, 100, 100, 150 ) 
    surface.DrawRect( x, y, ScrW(), ScrH() ) 
       
    // Border 
    surface.SetDrawColor( 50, 50, 50, 255 ) 
    surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() ) 
       
    return true 
end
   
vgui.Register( "DFrameTransparent", PANEL, "DFrame" )