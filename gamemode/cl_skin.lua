--Speed boost!
local surface = surface
local draw = draw
local Color = Color
local gradient = surface.GetTextureID("gui/gradient")
local matBlurScreen = Material( "pp/blurscreen" ) 
local gradientUp = surface.GetTextureID("gui/gradient_up")

function derma.SkinHook( strType, strName, panel, ... )
	local Skin
	if panel and type(panel) == "table" and panel.GetSkin then
		Skin = panel:GetSkin()
	else
		Skin = derma.GetDefaultSkin()
	end
	local func = Skin[ strType .. strName ]
	if !func then return end
	return func(Skin, panel, ...)
end

local SKIN = {}

SKIN.PrintName 		= "Tiramisu Skin"
SKIN.Author 		= "FNox"
SKIN.DermaVersion	= 1

SKIN.bg_color 					= Color( 110, 110, 110, 255 )
SKIN.bg_color_sleep 			= Color( 70, 70, 70, 255 )
SKIN.bg_color_dark				= Color( 55, 57, 61, 255 )
SKIN.bg_color_bright			= Color( 220, 220, 220, 255 )
SKIN.frame_border				= Color( 50, 50, 50, 255 )
SKIN.frame_title				= Color( 130, 130, 130, 255 )


SKIN.fontFrame					= "TiramisuDefaultFont"

SKIN.control_color 				= Color( 120, 120, 120, 255 )
SKIN.control_color_highlight	= Color( 150, 150, 150, 255 )
SKIN.control_color_active 		= Color( 110, 150, 250, 255 )
SKIN.control_color_bright 		= Color( 255, 200, 100, 255 )
SKIN.control_color_dark 		= Color( 100, 100, 100, 255 )

SKIN.bg_alt1 					= Color( 50, 50, 50, 255 )
SKIN.bg_alt2 					= Color( 55, 55, 55, 255 )

SKIN.listview_hover				= Color( 70, 70, 70, 255 )
SKIN.listview_selected			= Color( 100, 170, 220, 255 )

SKIN.text_bright				= Color( 255, 255, 255, 255 )
SKIN.text_normal				= Color( 180, 180, 180, 255 )
SKIN.text_dark					= Color( 20, 20, 20, 255 )
SKIN.text_highlight				= Color( 255, 20, 20, 255 )

SKIN.texGradientUp				= Material( "gui/gradient_up" )
SKIN.texGradientDown			= Material( "gui/gradient_down" )

SKIN.combobox_selected			= SKIN.listview_selected

SKIN.panel_transback			= Color( 255, 255, 255, 50 )
SKIN.tooltip					= Color( 255, 245, 175, 255 )

SKIN.colPropertySheet 			= Color( 170, 170, 170, 255 )
SKIN.colTab			 			= SKIN.colPropertySheet
SKIN.colTabInactive				= Color( 140, 140, 140, 255 )
SKIN.colTabShadow				= Color( 0, 0, 0, 170 )
SKIN.colTabText		 			= Color( 255, 255, 255, 255 )
SKIN.colTabTextInactive			= Color( 0, 0, 0, 200 )
SKIN.fontTab					= "TiramisuDefaultFont"

SKIN.colCollapsibleCategory		= Color( 255, 255, 255, 20 )

SKIN.colCategoryText			= Color( 255, 255, 255, 255 )
SKIN.colCategoryTextInactive	= Color( 200, 200, 200, 255 )
SKIN.fontCategoryHeader			= "Tiramisu16Font"

SKIN.colNumberWangBG			= Color( 255, 240, 150, 255 )
SKIN.colTextEntryBG				= Color( 240, 240, 240, 255 )
SKIN.colTextEntryBorder			= Color( 20, 20, 20, 255 )
SKIN.colTextEntryText			= Color( 20, 20, 20, 255 )
SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )
SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )

SKIN.colMenuBG					= Color( 255, 255, 255, 200 )
SKIN.colMenuBorder				= Color( 0, 0, 0, 200 )

SKIN.colButtonText				= Color( 255, 255, 255, 255 )
SKIN.colButtonTextDisabled		= Color( 255, 255, 255, 55 )
SKIN.colButtonBorder			= Color( 20, 20, 20, 255 )
SKIN.colButtonBorderHighlight	= Color( 255, 255, 255, 50 )
SKIN.colButtonBorderShadow		= Color( 0, 0, 0, 100 )
SKIN.fontButton					= "TiramisuDefaultFont"

--------------------
--------------------
--DEFAULT ELEMENTS--
--------------------
--------------------
/*---------------------------------------------------------
	Frame
---------------------------------------------------------*/
function SKIN:PaintFrame( panel )

	x, y = panel:ScreenToLocal( 0, 0 ) 
	color = panel.Color or CAKE.BaseColor or Color( 100, 100, 115, 150 )
	
	// Background 
	surface.SetMaterial( matBlurScreen ) 
	surface.SetDrawColor( 255, 255, 255, 255 ) 
	
	matBlurScreen:SetMaterialFloat( "$blur", 5 ) 
	render.UpdateScreenEffectTexture() 
	
	surface.DrawTexturedRect( x, y, ScrW(), ScrH() ) 

	if ( panel.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( panel, panel.m_fCreateTime )
	end
	
	surface.SetDrawColor( color.r, color.g, color.b, 150 ) 
	surface.DrawRect( x, y, ScrW(), ScrH() ) 

	// Pretentious line bullshit :P
	x = math.floor( panel:GetWide() / 5 )
	y = math.floor( panel:GetTall() / 5 )

	surface.SetDrawColor( 50, 50, 50, 80 ) 

	for i = 1, panel:GetWide() / 5 * 2  do
		surface.DrawLine( ( i * 5 ), 23, 0, ( i * 5 ) + 23 )
	end

	// and some gradient shit for additional overkill

	surface.SetTexture( gradientUp )
	surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), color.a ) 
	surface.DrawTexturedRectUV( 0, 0, panel:GetWide(), panel:GetTall(), panel:GetWide(), panel:GetWide() )

	// Border 
	surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), 255 ) 
	surface.DrawOutlinedRect( 0, 0, panel:GetWide(), panel:GetTall() )
	surface.DrawLine( 0, 23, panel:GetWide(), 23 )

end

--------------------
--------------------
--CUSTOM--ELEMENTS--
--------------------
--------------------

/*---------------------------------------------------------
	Intro
---------------------------------------------------------*/

function SKIN:InitIntro()
	CAKE.IntroStage1 = true
	CAKE.IntroStage2 = false
	CAKE.IntroStage3 = false
	CAKE.IntroStage4 = false
	CAKE.IntroStage1Alpha = 0
	CAKE.IntroStage2Alpha = 0
	CAKE.IntroStage3Alpha = 0
	timer.Create( "IntroStage1", 1, 1, function()
		CAKE.IntroSkippable = true
	end)
	timer.Create( "IntroStage2", 3, 1, function()
		CAKE.IntroStage2 = true
	end)
	timer.Create( "IntroStage3", 5, 1, function()
		CAKE.IntroStage3 = true
	end)
	timer.Create( "IntroStage4", 9, 1, function()
		CAKE.IntroStage1 = false
		CAKE.IntroStage2 = false
		CAKE.IntroStage3 = false
		CAKE.IntroStage4 = true
	end)
	timer.Create( "IntroStage5", 12, 1, function()
		CAKE.EndIntro()
	end)
end

function SKIN:PaintIntro()
	if CAKE.IntroStage1 then
		CAKE.IntroStage1Alpha = Lerp(1.5 * RealFrameTime(), CAKE.IntroStage1Alpha, 255 )
	end
	if CAKE.IntroStage2 then
		CAKE.IntroStage2Alpha = Lerp(1.5 * RealFrameTime(), CAKE.IntroStage2Alpha, 255 )
	end
	if CAKE.IntroStage3 then
		CAKE.IntroStage3Alpha = Lerp(1.5 * RealFrameTime(), CAKE.IntroStage3Alpha, 255 )
	end
	if CAKE.IntroStage4 then
		CAKE.IntroStage1Alpha = Lerp(2 * RealFrameTime(), CAKE.IntroStage1Alpha, 0 )
		CAKE.IntroStage2Alpha = Lerp(2 * RealFrameTime(), CAKE.IntroStage2Alpha, 0 )
		CAKE.IntroStage3Alpha = Lerp(2 * RealFrameTime(), CAKE.IntroStage3Alpha, 0 )
	end

	draw.SimpleTextOutlined( "Tiramisu", "Tiramisu64Font", ScrW()/2-20, ScrH() /2 - 50, Color(255,255,255,CAKE.IntroStage1Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(CAKE.IntroStage1Alpha, 130)))
	draw.SimpleTextOutlined( "                       2", "Tiramisu64Font", ScrW()/2, ScrH() /2 - 50, Color(255,0,0,CAKE.IntroStage2Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(CAKE.IntroStage2Alpha, 130)))
	draw.SimpleTextOutlined( "A new era in roleplay", "Tiramisu24Font", ScrW()/2, ScrH() / 2 + 10, Color(255,255,255,CAKE.IntroStage3Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(CAKE.IntroStage3Alpha, 130)))
end

function SKIN:ThinkIntro()
end

function SKIN:DestroyIntro()
	--You may be pondering why this one hook exists.
	--It's what allows you to make intro's skippable, this is where you destroy all remnants of the intro.
	timer.Destroy( "IntroStage1" )
	timer.Destroy( "IntroStage2" )
	timer.Destroy( "IntroStage3" )
	timer.Destroy( "IntroStage4" )
	timer.Destroy( "IntroStage5" )
end

/*---------------------------------------------------------
	Quick Menu
---------------------------------------------------------*/

local fade = 0
local x, y
function SKIN:PaintQuickMenu(panel)
	if panel then
		if !panel.FadeOut then
			fade = Lerp( 10 * RealFrameTime(), fade, 255 )
			panel.FadeAlpha = fade
		else
			fade = Lerp( 10 * RealFrameTime(), fade, 0 )
			panel.FadeAlpha = fade
			if fade < 5 then
				panel:Remove()
			end
		end
		x, y = panel:ScreenToLocal( 0, 0 )
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, fade ) 
		surface.DrawTexturedRectUV( x, y, panel:GetWide(), panel:GetTall(), panel:GetWide(), panel:GetWide() )
		surface.SetDrawColor( 0, 0, 0, fade ) 
		surface.DrawTexturedRectUV(  x, y, panel:GetWide(), panel:GetTall(), panel:GetWide(), panel:GetWide() )
	end
end

function SKIN:PaintQuickMenuLabel(panel)
	draw.SimpleTextOutlined( panel.LabelText or "", "Tiramisu32Font", panel:GetWide()/2, 0, Color(panel.FuckingColor.r,panel.FuckingColor.g,panel.FuckingColor.b,fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,fade))
end

/*---------------------------------------------------------
	TiramisuChatBox
---------------------------------------------------------*/

function SKIN:PaintTiramisuChatBox(panel)

	if !panel.Alpha then
		panel.Alpha = 0
	else
		if !panel.Open then
			panel.Alpha = Lerp( 0.2, panel.Alpha, 0 )
		else
			 panel.Alpha = Lerp( 0.2, panel.Alpha, 150 )
		end
	end

	x, y = panel:ScreenToLocal( 0, 0 ) 
	lastpos = 0
	color = CAKE.BaseColor or Color( 100, 100, 115, 150 )
	
	// Background 
	surface.SetMaterial( matBlurScreen ) 
	surface.SetDrawColor( 255, 255, 255, panel.Alpha or 0 ) 
	
	matBlurScreen:SetMaterialFloat( "$blur", panel.Alpha or 0 / 50 ) 
	render.UpdateScreenEffectTexture() 
	
	surface.DrawTexturedRect( x, y, ScrW(), ScrH() ) 

	if ( panel.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( panel, panel.m_fCreateTime )
	end
	
	surface.SetDrawColor( color.r, color.g, color.b, panel.Alpha or 0 ) 
	surface.DrawRect( x, y, ScrW(), ScrH() ) 

	surface.SetDrawColor( 50, 50, 50, math.Clamp( panel.Alpha or 0 - 50, 0, 255 ) ) 

	for i = 1, panel:GetWide() / 5 * 2  do
		surface.DrawLine( ( i * 5 ), 0, 0, ( i * 5 ) )
	end

	// Pretentious line bullshit :P
	x = math.floor( panel:GetWide() / 5 )
	y = math.floor( panel:GetTall() / 5 )

	// and some gradient shit for additional overkill

	for i = 1, ( y + 5 ) do
		surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), Lerp( i / ( ( y + 5 ) ), 0 , panel.Alpha or 0 ) ) 
		surface.DrawRect( 0, ( i * 5 ) , panel:GetWide(), 5 )
	end

	// Border 
	surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), panel.Alpha or 0 ) 
	surface.DrawOutlinedRect( 0, 0, panel:GetWide(), panel:GetTall() )

end

/*---------------------------------------------------------
	Character Selection
---------------------------------------------------------*/
function SKIN:LayoutCharacterSelection( hideclosebutton )
	CAKE.EnableBlackScreen( true )

	local subtitlelabel
	local titlelabel

	if hideclosebutton then
		CAKE.CurrentChar = false
	else
		CAKE.CurrentChar = CAKE.SelectedChar
	end

	if !CharacterMenu then
		CharacterMenu = vgui.Create( "DFrame" )
		CharacterMenu:SetSize( ScrW(), ScrH() )
		CharacterMenu:Center()
		CharacterMenu:SetDraggable( false )
		CharacterMenu:ShowCloseButton( true )
		CharacterMenu:SetTitle( "" )
		CharacterMenu.Paint = function()
			CAKE.DrawBlurScreen()
		end
		CharacterMenu.PaintOver = function()
			if CharacterMenu.Children then
				for k, panel in pairs( CharacterMenu.Children ) do
					if !panel or !panel.GetPos then
						table.remove( CharacterMenu.Children, k )
					else
						x, y = panel:GetPos()
						if CharacterMenu.SlideOut then
							panel:SetPos( Lerp( 3 * RealFrameTime(), x, -100 - panel:GetWide()), panel.OriginalPosY )
						else
							panel:SetPos( Lerp( 3 * RealFrameTime(), x, panel.OriginalPosX ), panel.OriginalPosY )
						end
					end
				end
			end
		end
		CharacterMenu.AddChild = function( panel )
			if !CharacterMenu.Children then
				CharacterMenu.Children = {}
			end
			if panel then
				panel.OriginalPosX, panel.OriginalPosY = panel:GetPos()
				table.insert( CharacterMenu.Children, panel )
			end
		end
		CharacterMenu:MakePopup()

		titlelabel = vgui.Create( "DLabel", CharacterMenu )
		titlelabel:SetText( CAKE.ConVars[ "IntroText" ] )
		titlelabel:SetFont( "Tiramisu64Font" )
		titlelabel:SizeToContents()
		titlelabel:SetPos( 20, 20 )
		CharacterMenu.AddChild(titlelabel)

		subtitlelabel = vgui.Create( "DLabel", CharacterMenu )
		subtitlelabel:SetText( CAKE.ConVars[ "IntroSubtitle" ] )
		subtitlelabel:SetFont( "Tiramisu32Font" )
		subtitlelabel:SizeToContents()
		subtitlelabel:SetPos( 20, 30 + titlelabel:GetTall() )
		CharacterMenu.AddChild(subtitlelabel)

		PlayerModel = vgui.Create( "PlayerPanel", CharacterMenu )
		PlayerModel:SetSize( ScrH(), ScrH())
		PlayerModel:SetPos( ScrW() - ScrH(), 0 )
		PlayerModel.PaintOver = function()
			if PlayerModel.SlideOut then
				x, y = PlayerModel:GetPos()
				PlayerModel:SetPos( Lerp( RealFrameTime() * 3, x, 0 ), 0 )
			else
				x, y = PlayerModel:GetPos()
				PlayerModel:SetPos( Lerp( RealFrameTime() * 3, x,  ScrW() - ScrH() ), 0)
			end
		end
		RunConsoleCommand( "rp_receivechars", tostring(!hideclosebutton) )
		derma.SkinHook( "Layout", "CharacterSelectionButtons", !hideclosebutton )
	else
		CharacterMenu.SlideOut = false
		if PlayerModel then
			PlayerModel.SlideOut = false
		end
	end
end

function SKIN:LayoutCharacterList()
	if CharacterMenu then
		if !CharacterListPanel then
			CharacterListPanel = vgui.Create( "DPanelList", CharacterMenu )
			CharacterListPanel:SetSize( ScrW() - ScrH() - 100, ScrH() - 270 )
			CharacterListPanel:SetPos( 100, 170 )
			CharacterListPanel:SetSpacing( 5 )
			CharacterListPanel:SetAutoSize( false )
			CharacterListPanel:EnableVerticalScrollbar( true )
			CharacterMenu.AddChild( CharacterListPanel )
			CharacterListPanel.Paint = function()
			end
		else
			CharacterListPanel:Clear()
		end

		for k, v in pairs(ExistingChars) do

			local charbutton = vgui.Create( "DButton" )
			charbutton:SetTall( 50 )
			charbutton.DoClick = function()
				RunConsoleCommand("rp_selectchar", tostring( k ))
			end
			charbutton:SetText("")
			charbutton.Paint = function()
				surface.SetDrawColor(Color(30, 30, 30, 250 ))
				surface.DrawRect( 0, 0, charbutton:GetSize())
			end

			local namelabel = vgui.Create( "DLabel", charbutton )
			namelabel:SetSize( ScrW() - ScrH() - 140, 33 )
			namelabel:SetPos( 10, 10 )
			namelabel:SetText( v['name'] )
			namelabel:SetFont("Tiramisu32Font")

			local deletebutton = vgui.Create( "DButton", charbutton )
			deletebutton:SetSize( 32, 32 )
			deletebutton:SetPos( ScrW() - ScrH() - 136, 4 )
			deletebutton:SetText("")
			deletebutton.Paint = function()
				surface.SetDrawColor(Color(0, 0, 0, 250 ))
				surface.SetTexture()
				surface.DrawTexturedRectRotated( 15, 22, 20, 8, 45 )
				surface.DrawTexturedRectRotated( 15, 22, 20, 8, 135 )
			end

			deletebutton.DoClick = function()
				RunConsoleCommand("rp_confirmremoval", tostring( k ))
			end

			CharacterListPanel:AddItem(charbutton)

		end
	end
end

function SKIN:LayoutCharacterSelectionButtons( canclose )
	local closelabel
	local spawnlabel = vgui.Create( "DButton", CharacterMenu )
	spawnlabel:SetSize( 80, 26 )
	spawnlabel:SetText( "" )
	spawnlabel:SetPos(  260, ScrH() - 85 )
	spawnlabel.Paint = function() end
	spawnlabel.PaintOver = function()
		surface.SetFont("Tiramisu24Font")
		surface.SetDrawColor(Color(30, 30, 30, 150 ))
		surface.DrawRect( 0, 0, surface.GetTextSize(" Spawn "))
		draw.SimpleText( " Spawn ", "Tiramisu24Font", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
	end
	spawnlabel.DoClick = function()
		if CAKE.SelectedChar then
			RunConsoleCommand( "rp_spawnchar", tostring( CAKE.SelectedChar ))
			derma.SkinHook( "Close", "CharacterSelection")
		else
			CAKE.Message( "You need to select a character first!", "Warning", "OK", Color( 140, 100, 100) )
		end
	end
	CharacterMenu.AddChild( spawnlabel )

	local disconnectlabel = vgui.Create( "DButton", CharacterMenu )
	disconnectlabel:SetSize( 80, 26 )
	disconnectlabel:SetText( "" )
	disconnectlabel:SetPos( 160, ScrH() - 85 )
	disconnectlabel.Paint = function() end
	disconnectlabel.PaintOver = function()
		surface.SetFont("Tiramisu24Font")
		surface.SetDrawColor(Color(30, 30, 30, 150 ))
		surface.DrawRect( 0, 0, surface.GetTextSize(" Disconnect "))
		draw.SimpleText( " Disconnect ", "Tiramisu24Font", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
	end
	disconnectlabel.DoClick = function()
		RunConsoleCommand( "disconnect" )
	end
	CharacterMenu.AddChild( disconnectlabel )

	local createcharacter = vgui.Create( "DButton", CharacterMenu )
	createcharacter:SetText( "" )
	createcharacter:SetSize( 200, 26 )
	createcharacter:SetColor(Color( 200, 255, 200 ))
	createcharacter:SetPos( 340, ScrH() - 85 )
	createcharacter.Paint = function() end
	createcharacter.PaintOver = function()
		surface.SetFont("Tiramisu24Font")
		surface.SetDrawColor(Color(30, 30, 30, 150 ))
		surface.DrawRect( 0, 0, surface.GetTextSize(" Create New Character "))
		draw.SimpleText( " Create New Character ", "Tiramisu24Font", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
	end
	createcharacter.DoClick = function()
		PlayerModel.SlideOut = true
		CharacterMenu.SlideOut = true
		RunConsoleCommand( "rp_begincreate" )
	end
	CharacterMenu.AddChild( createcharacter )

	local x, y 
	introlabel = vgui.Create( "DButton", CharacterMenu )
	introlabel:SetSize( 80, 26 )
	introlabel:SetText( "" )
	introlabel:SetPos( ScrW() - 80, ScrH() - 30 )
	introlabel.Paint = function() end
	introlabel.PaintOver = function()
		surface.SetFont("Tiramisu24Font")
		surface.SetDrawColor(Color(30, 30, 30, 150 ))
		surface.DrawRect( 0, 0, surface.GetTextSize(" Play Intro "))
		draw.SimpleText( " Play Intro ", "Tiramisu24Font", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
	end
	introlabel.DoClick = function()
		CAKE.EnableBlackScreen( true, true )
		CAKE.StartIntro( canclose )
		if CharacterMenu then
			PlayerModel:Close()
			CharacterMenu:Remove()
			CharacterMenu = nil
		end
	end
	CharacterMenu.AddChild( introlabel )

	if canclose then
		local x, y 
		closelabel = vgui.Create( "DButton", CharacterMenu )
		closelabel:SetSize( 80, 26 )
		closelabel:SetText( "" )
		closelabel:SetPos( (ScrW() / 2 )- 40, ScrH() - 85  )
		closelabel.Paint = function() end
		closelabel.PaintOver = function()
			surface.SetFont("Tiramisu24Font")
			surface.SetDrawColor(Color(30, 30, 30, 150 ))
			surface.DrawRect( 0, 0, surface.GetTextSize(" Close Menu "))
			draw.SimpleText( " Close Menu ", "Tiramisu24Font", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
		end
		closelabel.DoClick = function()
			RunConsoleCommand("rp_selectchar", tostring( CAKE.CurrentChar ))
			derma.SkinHook( "Close", "CharacterSelection")
		end
		CharacterMenu.AddChild( closelabel )
	end
end

function SKIN:CloseCharacterSelection()
	CAKE.EnableBlackScreen( false )
	if CharTitleLabel then
		CharTitleLabel:Remove()
		CharTitleLabel = nil
	end
	if CharacterListPanel then
		CharacterListPanel:Remove()
		CharacterListPanel = nil
	end
	if CharacterMenu then
		PlayerModel:Close()
		CharacterMenu:Remove()
		CharacterMenu = nil
	end
end

/*---------------------------------------------------------
	Character Creation
---------------------------------------------------------*/
function SKIN:LayoutCharacterCreation()
	derma.SkinHook( "CharacterCreation", "Step1" )
end

function SKIN:CharacterCreationStep1()
	local x, y
	local Age = "30"
	local Gender = "Male"
	local Title1 = "Title1"
	local Title2 = "Title2"
	local CharName = "Set Your Name"
	local SelectedClothing = "none"
	local SelectedModel = "models/humans/group01/male_01.mdl"

	if CharacterMenu then

		local titlelabel = vgui.Create( "DLabel", CharacterMenu )
		titlelabel:SetText( "Create a Character" )
		titlelabel:SetFont( "Tiramisu64Font" )
		titlelabel:SizeToContents()
		titlelabel:SetPos( ScrW() + 100, 20 )
		titlelabel.PaintOver = function()
			if titlelabel then
				x,y = titlelabel:GetPos()
				if !titlelabel.SlideOut then
					titlelabel:SetPos( ScrW() - Lerp( 3 * RealFrameTime(), -(x - ScrW()), titlelabel:GetWide() + 20), y )
				else
					titlelabel:SetPos( ScrW() + Lerp( 3 * RealFrameTime(), x - ScrW(), 200), y )
					if x > ScrW() + 110 then
						titlelabel:Remove()
						titlelabel = nil
					end
				end
			end
		end

		local subtitlelabel = vgui.Create( "DLabel", CharacterMenu )
		subtitlelabel:SetText( "Live a new life" )
		subtitlelabel:SetFont( "Tiramisu32Font" )
		subtitlelabel:SizeToContents()
		subtitlelabel:SetPos( ScrW() + 100, 30 + titlelabel:GetTall() )
		subtitlelabel.PaintOver = function()
			if subtitlelabel then
				x,y = subtitlelabel:GetPos()
				if !subtitlelabel.SlideOut then
					subtitlelabel:SetPos( ScrW() - Lerp( 3 * RealFrameTime(), -(x - ScrW()), subtitlelabel:GetWide() + 20), y )
				else
					subtitlelabel:SetPos( ScrW() + Lerp( 3 * RealFrameTime(), x - ScrW(), 200), y )
					if x > ScrW() + 110 then
						subtitlelabel:Remove()
						subtitlelabel = nil
					end
				end
			end
		end

		local panel = vgui.Create( "DPanelList", CharacterMenu)
		panel:SetSize( ScrW() - ScrH() - 50, ScrH() - 270 )
		panel:SetPos( ScrH(), 170 )
		panel:SetPadding( 5 )
		panel:SetSpacing( 10 )
		panel.Paint = function()
			x,y = panel:GetPos()
			if panel.SlideOut then
				panel:SetPos( Lerp( 10 * RealFrameTime(), x, ScrW() + 500 ) , ScrH() / 2 - 250)
				if x > ScrW() then
					panel:Remove()
					panel = nil
				end
			else
				--panel:SetPos( Lerp( 10 * RealFrameTime(), x, ScrW() / 2 ) , ScrH() / 2 - 250)
			end
		end

		local label

		label = vgui.Create( "DLabel" )
		label:SetText( "Name :" )
		label:SetFont( "Tiramisu24Font" )
		panel:AddItem( label )

		local nametext = vgui.Create( "DTextEntry" )
		nametext:SetText( CharName )
		nametext:SetTooltip( "Click to edit" )
		panel:AddItem( nametext )

		label = vgui.Create( "DLabel" )
		label:SetText( "Title :" )
		label:SetFont( "Tiramisu24Font" )
		panel:AddItem( label )

		local titletext = vgui.Create( "DTextEntry" )
		titletext:SetText( Title1 )
		titletext:SetTooltip( "Click to edit" )
		panel:AddItem( titletext )

		local modellist = vgui.Create( "DMultiChoice" )
		for k, v in pairs( CAKE.ConVars[ "Default_Models" ][ Gender ] ) do
			modellist:AddChoice( v )
		end
		modellist.OnSelect = function( panel,index,value )
			RunConsoleCommand( "rp_testclothing", "none", value, SelectedClothing )
			SelectedModel = value
		end
		modellist:ChooseOptionID( 1 )

		local genderlist = vgui.Create( "DMultiChoice" )
		genderlist:AddChoice( "Male" )
		genderlist:AddChoice( "Female" )
		genderlist.OnSelect = function( panel,index,value )
			Gender = value
			RunConsoleCommand( "rp_testclothing", value, CAKE.ConVars[ "Default_Models" ][ value ][1] )
			modellist:Clear()
			for k, v in pairs( CAKE.ConVars[ "Default_Models" ][ Gender ] ) do
				modellist:AddChoice( v )
			end
			SelectedClothing = "none"
			SelectedModel = CAKE.ConVars[ "Default_Models" ][ value ][1]
			modellist:ChooseOptionID( 1 )
		end
		genderlist:ChooseOptionID( 1 )

		label = vgui.Create( "DLabel" )
		label:SetText( "Gender :" )
		label:SetFont( "Tiramisu24Font" )
		panel:AddItem( label )
		panel:AddItem( genderlist )

		label = vgui.Create( "DLabel" )
		label:SetText( "Model :" )
		label:SetFont( "Tiramisu24Font" )
		panel:AddItem( label )
		panel:AddItem( modellist )

		label = vgui.Create( "DLabel" )
		label:SetText( "Age :" )
		label:SetFont( "Tiramisu24Font" )
		panel:AddItem( label )

		local numberwang = vgui.Create( "DNumberWang" )
		numberwang:SetMin( 18 )
		numberwang:SetMax( 89 )
		numberwang:SetValue( 30 )
		numberwang:SetDecimals( 0 )
		numberwang.OnValueChanged = function( panel, value )
			Age = tostring( value )
		end
		panel:AddItem( numberwang )

		gobacklabel = vgui.Create( "DButton", CharacterMenu )
		gobacklabel:SetSize( 80, 26 )
		gobacklabel:SetText( "" )
		gobacklabel:SetPos( ScrW() + 240, ScrH() - 85 )
		gobacklabel.Paint = function() end
		gobacklabel.PaintOver = function()
			if gobacklabel then
				draw.SimpleText( "Go Back", "Tiramisu24Font", 40, 0, Color(255,255,255), TEXT_ALIGN_CENTER )
				x,y = gobacklabel:GetPos()
				if !gobacklabel.SlideOut then
					gobacklabel:SetPos( ScrW() - Lerp( 3 * RealFrameTime(), -(x - ScrW()), 240), y )
				else
					gobacklabel:SetPos( ScrW() + Lerp( 3 * RealFrameTime(), x - ScrW(), 240), y )
					if x > ScrW() + 110 then
						gobacklabel:Remove()
						gobacklabel = nil
					end
				end
			end
		end
		gobacklabel.DoClick = function()
			RunConsoleCommand( "rp_escapecreate" )
			RunConsoleCommand("rp_selectchar", tostring( CAKE.SelectedChar ))
			panel.SlideOut = true
			gobacklabel.SlideOut = true
			createlabel.SlideOut = true
			subtitlelabel.SlideOut = true
			titlelabel.SlideOut = true

			derma.SkinHook( "Layout", "CharacterSelection" )
		end

		createlabel = vgui.Create( "DButton", CharacterMenu )
		createlabel:SetSize( 200, 26 )
		createlabel:SetText( "" )
		createlabel:SetPos(ScrW() + 160, ScrH() - 85 )
		createlabel.Paint = function() end
		createlabel.PaintOver = function()
			if createlabel then
				draw.SimpleText( "Finish Creation", "Tiramisu24Font", 70, 0, Color(255,255,255), TEXT_ALIGN_CENTER )
				x,y = createlabel:GetPos()
				if !createlabel.SlideOut then
					createlabel:SetPos( ScrW() - Lerp( 3 * RealFrameTime(), -(x - ScrW()), 160), y )
				else
					createlabel:SetPos( ScrW() - Lerp( 3 * RealFrameTime(), x - ScrW(), 160), y )
					if x > ScrW() + 110 then
						createlabel:Remove()
						createlabel = nil
					end
				end
			end
		end
		createlabel.DoClick = function()
			Title1 = string.sub(titletext:GetValue(), 1, 255)
			CharName = string.sub(nametext:GetValue(), 1, 64)

			RunConsoleCommand("rp_startcreate")
			RunConsoleCommand("rp_setmodel", SelectedModel )
			RunConsoleCommand("rp_changename", CharName )
			RunConsoleCommand("rp_title", Title1 )
			RunConsoleCommand("rp_setage", Age )
			RunConsoleCommand("rp_setgender", Gender )
			RunConsoleCommand("rp_setcid")
			RunConsoleCommand( "rp_finishcreate" )
			panel.SlideOut = true
			gobacklabel.SlideOut = true
			createlabel.SlideOut = true
			subtitlelabel.SlideOut = true
			titlelabel.SlideOut = true

			derma.SkinHook( "Layout", "CharacterSelection" )
		end

	end
end


--------------------
--------------------
----HUD ELEMENTS----
--------------------
--------------------

/*---------------------------------------------------------
	Stamina Bar
---------------------------------------------------------*/
local perc, alpha
alpha = 230
function SKIN:PaintStaminaBar()
	if CAKE.MinimalHUD:GetBool() then
		if LocalPlayer().TiramisuStaminaRegen and alpha != 230 then
			alpha = Lerp( 10 * RealFrameTime(), alpha, 230 )
		elseif !LocalPlayer().TiramisuStaminaRegen then
			alpha = Lerp( 10 * RealFrameTime(), alpha, 0 )
		end
	else
		alpha = 230
	end
	perc = LocalPlayer():GetStamina() / 100
	if alpha != 0 then
		--perc = math.Clamp( perc - 0.001, 0, 1 )
		draw.RoundedBoxEx( 4, ScrW()/2 - 150, 0, 300, 31, Color( 50, 50, 50, alpha ), false, false, false, true )
		surface.SetDrawColor( Color( 10, 10, 10, alpha ) )
		surface.DrawRect( ScrW()/2 - 147, 2, 293, 26 )
		draw.SimpleText(tostring(math.ceil(perc * 100)) .. "%", "Tiramisu12Font", ScrW()/2 - 144 + 287, 9, Color(255,255,255,alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
		if perc != 0 then
			draw.RoundedBoxEx( 2, ScrW()/2 - 144, 5, 287 * perc, 20, Color( 200, 200, 50, alpha ), false, false, false, true )
			draw.RoundedBoxEx( 2, ScrW()/2 - 140, 8, 280 * perc, 4, Color( 255, 255, 255, math.Clamp( alpha - 180, 0, 50) ), false, false, false, true )
		end
		draw.SimpleText("STAMINA", "Tiramisu12Font", ScrW()/2 - 144 + math.Clamp( 287 * perc, 41, 287), 9, Color(255,255,255,alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
	end
end

/*---------------------------------------------------------
	Health Bar
---------------------------------------------------------*/
local perc, alpha
alpha = 230
local rot = 0
function SKIN:PaintHealthBar()
	if LocalPlayer():Alive() then
		rot = math.NormalizeAngle( rot + RealFrameTime() )
		if CAKE.MinimalHUD:GetBool() then
			if (CAKE.MenuOpen or LocalPlayer().IsDamaged) and alpha != 230 then
				alpha = Lerp( 10 * RealFrameTime(), alpha, 230 )
			elseif !(CAKE.MenuOpen or LocalPlayer().IsDamaged) then
				alpha = Lerp( 10 * RealFrameTime(), alpha, 0 )
			end
		else
			alpha = 230
		end
		perc = LocalPlayer():Health() / LocalPlayer():GetMaxHealth()
		if alpha != 0 then
			if LocalPlayer():Armor() > 0 then
				surface.SetDrawColor( Color( 50, 50, 50, alpha ) )
				surface.DrawNPoly( ScrW()-35, ScrH()/2 + 155, 15, 8, rot )
				draw.SimpleText(tostring(LocalPlayer():Armor()) .. "%", "Tiramisu12Font", ScrW()-35, ScrH()/2 + 155, Color(200,200,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			draw.RoundedBoxEx( 4, ScrW()- 31, ScrH()/2 - 150, 31, 300, Color( 50, 50, 50, alpha ), false, false, false, true )
			surface.SetDrawColor( Color( 10, 10, 10, alpha ) )
			surface.DrawRect( ScrW() - 28, ScrH()/2 - 147, 26,293 )
			draw.SimpleText(tostring(math.ceil(perc * 100)) .. "%", "Tiramisu12Font", ScrW() - 17, ScrH()/2 - 144, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
			if perc != 0 then
				draw.RoundedBoxEx( 2, ScrW() - 26, ScrH()/2 - 144 + 287 - 287 * perc, 20, 287 * perc, Color( 200, 20, 20, alpha ), false, false, false, true )
				draw.RoundedBoxEx( 2, ScrW()-22, ScrH()/2 - 140+ 287 - 287 * perc, 4, 280 * perc, Color( 255, 255, 255, math.Clamp( alpha - 180, 0, 50) ), false, false, false, true )
			end
			draw.DrawText("H\nE\nA\nL\nT\nH", "Tiramisu12Font", ScrW()-18, ScrH()/2 - 144 + math.Clamp( 287 - 287 * perc, 0, 200), Color(255,255,255,alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end
	end
end

/*---------------------------------------------------------
	DeathMessage
---------------------------------------------------------*/
function SKIN:PaintDeathMessage()
	if LocalPlayer():GetNWInt("deathmode", 0 ) == 1 then
		if LocalPlayer():GetNWInt( "deathmoderemaining" ) < 5 and LocalPlayer():GetNWInt( "deathmoderemaining" ) != 0 then
			CAKE.EnableBlackScreen( CAKE.ConVars[ "FadeToBlackOnDeath" ] )
		end
		if LocalPlayer():GetNWInt( "deathmoderemaining" ) > 0 then
			draw.DrawText( "You have been mortally wounded. Wait " .. tostring( LocalPlayer( ):GetNWInt( "deathmoderemaining" ) ) .. " seconds", "Tiramisu18Font", ScrW( ) / 2,60, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
		elseif !CAKE.ConVars[ "Instant_Respawn" ] then
			draw.DrawText( "Press the button to respawn or type rp_acceptdeath in console.", "Tiramisu18Font", ScrW( ) / 2,60, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
		end
	end
	
	if LocalPlayer():GetNWBool("unconciousmode", false ) then
		draw.DrawText( "You have passed out. Wait a few moments until you can wake up.", "Tiramisu18Font", ScrW( ) / 2 ,60, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	end
end

/*---------------------------------------------------------
	TiramisuClock, draws current gamemode time and player title.
---------------------------------------------------------*/
local struc = {}
struc.pos = { ScrW() - 10, 10 } -- Pos x, y
struc.color = Color(230,230,230,255 ) -- Red
struc.font = "Tiramisu24Font" -- Font
struc.xalign = TEXT_ALIGN_RIGHT -- Horizontal Alignment
struc.yalign = TEXT_ALIGN_RIGHT -- Vertical Alignment

function SKIN:PaintTiramisuClock()
	if !CAKE.MinimalHUD:GetBool() or CAKE.MenuOpen then 
		if GetGlobalString( "time" ) != "Loading.." and GetGlobalString( "time" ) != "" then
			struc.text = CAKE.FindDayName() .. ", " .. GetGlobalString( "time" )
			struc.pos = { ScrW() - 10, 10 } -- Pos x, y
			draw.Text( struc )
		else
			struc.text = GetGlobalString( "time" )
			struc.pos = { ScrW() - 10, 10 } -- Pos x, y
			draw.Text( struc )
		end
	end
	if CAKE.MenuOpen then
		struc.text = LocalPlayer():Nick()
		struc.pos = { ScrW() - 10, 30 }
		draw.Text( struc )
		struc.text = LocalPlayer():GetNWString( "title", "Connecting..." )
		struc.pos = { ScrW() - 10, 50 }
		draw.Text( struc )
	end
end

/*---------------------------------------------------------
	TargetInfo, messages over items and props
---------------------------------------------------------*/
local screenpos
function SKIN:PaintTargetInfo()
	for _, ent in pairs( ents.FindInSphere( LocalPlayer():GetPos(), 500 ) ) do
		if ValidEntity( ent ) and !ent:IsWorld() then
			if ent:GetClass() == "item_prop" then
				screenpos = ent:GetPos() + Vector( 0,0,10)
				if screenpos:Distance( LocalPlayer():GetPos() ) > 200 and LocalPlayer():CanTraceTo(ent) then
					screenpos = screenpos:ToScreen()
					draw.SimpleText( ent:GetNWString( "Name",""), "Tiramisu18Font", screenpos.x, screenpos.y, Color(150,150,150,150),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					screenpos = screenpos:ToScreen()
					draw.SimpleTextOutlined( ent:GetNWString( "Name",""), "Tiramisu18Font", screenpos.x, screenpos.y, Color(255,255,255,255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,2,Color(0,0,0,255))
					draw.SimpleTextOutlined( ent:GetNWString( "Description",""), "Tiramisu18Font", screenpos.x, screenpos.y+20, Color(255,255,255,255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,2,Color(0,0,0,255))
				end
			elseif ent:GetNWString( "propdescription", "" ) != "" then
				screenpos = ent:LocalToWorld(ent:OBBCenter()):ToScreen()
				draw.SimpleTextOutlined( ent:GetNWString( "propdescription",""), "Tiramisu18Font", screenpos.x, screenpos.y, Color(255,255,255,255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,2,Color(0,0,0,255))
			end
		end
	end
end

/*---------------------------------------------------------
	BlurScreen, used in the fullscreen editors
---------------------------------------------------------*/
local x, y, n
local gradientup = surface.GetTextureID("gui/gradient_up")
local gradientdown = surface.GetTextureID("gui/gradient_down")
function SKIN:PaintBlurScreen()
	color = CAKE.BaseColor or Color( 100, 100, 115, 150 )

	// new hip way of doing gradients

	x,y = ScrW(), ScrH()

	surface.SetTexture(gradientdown)
	surface.SetDrawColor( 0, 0, 0, 250 ) 
	surface.DrawTexturedRectUV( 0, 0, x, y/5 , 0, y/5, y/5 )
	surface.SetTexture(gradientup)
	surface.DrawTexturedRectUV( 0, y - y/5, x, y/5 , 0, y/5, y/5 )
	surface.SetTexture()
	
	// Background 
	surface.SetMaterial( matBlurScreen ) 
	surface.SetDrawColor( 255, 255, 255, 255 ) 
	
	matBlurScreen:SetMaterialFloat( "$blur", 5 ) 
	render.UpdateScreenEffectTexture() 
	
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() ) 
	
	surface.SetDrawColor( color.r, color.g, color.b, 150 ) 
	surface.DrawRect( 0, 0, ScrW(), ScrH() ) 


	// Pretentious line bullshit :P
	x = math.floor( ScrW() / 5 )
	y = math.floor( ScrH() / 5 )

	surface.SetDrawColor( 50, 50, 50, 110 ) 

	for i = 1, ScrW() / 5 * 2  do
		surface.DrawLine( ( i * 5 ),0, 0, ( i * 5 ) )
	end

end

/*---------------------------------------------------------
	TiramisuCrosshair
---------------------------------------------------------*/
local trace, pos
function SKIN:PaintTiramisuCrosshair()
	trace = LocalPlayer():GetEyeTrace()
	pos = trace.HitPos:ToScreen()
	if pos.visible then
		if !trace.HitWorld then
			surface.SetDrawColor( 200, 50, 50, 220 )
		else
			surface.SetDrawColor( 220, 220, 220, 220 )
		end
		surface.DrawLine( pos.x - 5, pos.y, pos.x + 5, pos.y )
		surface.DrawLine( pos.x, pos.y - 5, pos.x, pos.y + 5 )
	end
end



derma.DefineSkin( "Tiramisu", "Made to look like some good stuff", SKIN )