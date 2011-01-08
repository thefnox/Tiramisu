CLPLUGIN.Name = "Post Process Effects"
CLPLUGIN.Author = "F-Nox/Big Bang"

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
        
        self:SetCamPos( Vector( 50, 50, 50 ) + LocalPlayer():GetPos() )
        self:SetLookAt( Vector( 0, 0, 40 ) )
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
 
/*---------------------------------------------------------
   Name: OnSelect
---------------------------------------------------------*/
function PANEL:BeginDraw( )
        
        // Note: Not in menu dll
        if ( !ClientsideModel ) then return end
        
        if ( !IsValid(LocalPlayer()) ) then return end

        
        LocalPlayer():SetNoDraw( true )
        if CAKE.ClothingTbl then
			for k, v in pairs( CAKE.ClothingTbl ) do
				if ValidEntity( v ) then
					v:SetNoDraw( true )
				end
			end
		end
		if CAKE.Gear then
			for k, v in pairs( CAKE.Gear ) do
				if v and ValidEntity( v ) then
					v:SetNoDraw( true )
				end
			end
		end
        
        
end

function PANEL:EndDraw( )
        
        // Note: Not in menu dll
        if ( !ClientsideModel ) then return end
        
        if ( !IsValid(LocalPlayer()) ) then return end

        
        LocalPlayer():SetNoDraw( false )
        if CAKE.ClothingTbl then
			for k, v in pairs( CAKE.ClothingTbl ) do
				if ValidEntity( v ) then
					v:SetNoDraw( false )
				end
			end
		end
		if CAKE.Gear then
			for k, v in pairs( CAKE.Gear ) do
				if v and ValidEntity( v ) then
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
        
        self:LayoutEntity( )
        
        cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetWide(), self:GetTall() )
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
		if CAKE.Gear then
			for k, v in pairs( CAKE.Gear ) do
				if v and ValidEntity( v ) then
					v:DrawModel()
				end
			end
		end
        
        render.SuppressEngineLighting( false )
        cam.IgnoreZ( false )
        cam.End3D()
        
        self.LastPaint = RealTime()
        
end
 
/*---------------------------------------------------------
   Name: RunAnimation
---------------------------------------------------------*/

/*---------------------------------------------------------
   Name: LayoutEntity
---------------------------------------------------------*/
function PANEL:LayoutEntity( )
 
        //
        // This function is to be overriden
        //
        
        LocalPlayer():SetAngles( Angle( 0, RealTime()*10,  0) )
        if CAKE.ClothingTbl then
			for k, v in pairs( CAKE.ClothingTbl ) do
				if ValidEntity( v ) then
					v:SetAngles( Angle( 0, RealTime()*10,  0) )
				end
			end
		end
		if CAKE.Gear then
			for k, v in pairs( CAKE.Gear ) do
				if v and ValidEntity( v ) then
					v:SetAngles( Angle( 0, RealTime()*10,  0) )
				end
			end
		end
 
end

derma.DefineControl( "PlayerPanel", "A panel containing LocalPlayer's model", PANEL, "DButton" )