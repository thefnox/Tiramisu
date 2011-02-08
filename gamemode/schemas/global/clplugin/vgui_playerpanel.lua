CLPLUGIN.Name = "PlayerModel Frame"
CLPLUGIN.Author = "FNox"


function CLPLUGIN.Init()
	
end


/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 
 
*/
local PANEL = {}
 
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
 
/*---------------------------------------------------------
   Name: OnSelect
---------------------------------------------------------*/
function PANEL:StartDraw()
        
        // Note: Not in menu dll
        if ( !ClientsideModel ) then return end
        
        LocalPlayer():SetNoDraw( true )

        if CAKE.ClothingTbl then
        	for k, v in pairs( CAKE.ClothingTbl ) do
        		if ValidEntity( v ) then
        			v:SetNoDraw( true )
        		end
        	end
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
        
end
 
/*---------------------------------------------------------
   Name: OnMousePressed
---------------------------------------------------------*/
function PANEL:Paint()
 
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


	        if CAKE.ClothingTbl then
	        	for k, v in pairs( CAKE.ClothingTbl ) do
	        		if ValidEntity( v ) then
	        			v:DrawModel()
	        		end
	        	end
	        end

	        render.SuppressEngineLighting( false )
	        cam.IgnoreZ( false )
        cam.End3D()
        
        self.LastPaint = RealTime()
        
end

function PANEL:OnCursorMoved(x, y)
    if input.IsMouseDown( MOUSE_LEFT ) or input.IsMouseDown( MOUSE_RIGHT ) then
        newpos = ( LocalPlayer():GetForward() * 80 ) + ( LocalPlayer():GetUp() * 40 ) 
        angle = LocalPlayer():GetAngles()
        angle:RotateAroundAxis(angle:Up(), math.NormalizeAngle( 180 - ( x - self:GetWide()/ 2 ) / 2 ) )
        angle:RotateAroundAxis(angle:Right(), math.NormalizeAngle( 0 - ( y - self:GetTall()/ 2 ) / 2 ) )
        newpos:Rotate( angle )
        self:SetCamPos( angle:Forward() * -80 + Vector( 0, 0, 40 ))
        self:SetCamAngle( angle )
    end
end

derma.DefineControl( "PlayerPanel", "A panel containing the player's model", PANEL, "DButton" )