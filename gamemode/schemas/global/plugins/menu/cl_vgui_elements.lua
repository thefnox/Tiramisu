CLPLUGIN.Name = "VGUI Elements"
CLPLUGIN.Author = "FNox, Garry, Overv, et al"

--Credits for Overv, who posted this on the WAYWO thread. I just added the pretentious line crap

--DFrameTransparent. A copy of DFrame with a much better looking interface. Also, colourable.

function CLPLUGIN.Init()
	
end

local PANEL = {} 

--PlayerPanel. A 3D panel that draws the player and his/her clothing and gear. With mouse rotation/zooming.

PANEL = {}
 
AccessorFunc( PANEL, "m_fAnimSpeed",	"AnimSpeed" )
AccessorFunc( PANEL, "Entity",				  "Entity" )
AccessorFunc( PANEL, "vCamPos",				 "CamPos" )
AccessorFunc( PANEL, "fFOV",					"FOV" )
AccessorFunc( PANEL, "vLookatPos",			  "LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor",				"Color" )
AccessorFunc( PANEL, "bAnimated",			"Animated" )
 
 
/*---------------------------------------------------------
Name: Init
---------------------------------------------------------*/
function PANEL:Init()

    CAKE.ForceDraw = true

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
	self:StartDraw()
 
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

	if CAKE.Thirdperson:GetBool() then
		
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
		
		--CAKE.ForceDraw = false
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

function PANEL:Close()
	CAKE.ForceDraw = false
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
	self:Remove()
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