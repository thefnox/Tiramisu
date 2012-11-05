--Speed boost!
local surface = surface
local draw = draw
local Color = Color
local gradient = surface.GetTextureID("gui/gradient.vtf")
//local matBlurScreen = Material( "pp/blurscreen" ) 
local gradientUp = surface.GetTextureID("gui/gradient_up.vtf")

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
	color = panel.Color or TIRA.BaseColor or Color( 100, 100, 115, 150 )
	
	// Background 
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
	surface.DrawTexturedRectUV( 0, 0, panel:GetWide(), panel:GetTall(), 0, 0, 1, 1)

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
	TIRA.IntroStage1 = true
	TIRA.IntroStage2 = false
	TIRA.IntroStage3 = false
	TIRA.IntroStage4 = false
	TIRA.IntroStage1Alpha = 0
	TIRA.IntroStage2Alpha = 0
	TIRA.IntroStage3Alpha = 0
	timer.Create( "IntroStage1", 1, 1, function()
		TIRA.IntroSkippable = true
	end)
	timer.Create( "IntroStage2", 3, 1, function()
		TIRA.IntroStage2 = true
	end)
	timer.Create( "IntroStage3", 5, 1, function()
		TIRA.IntroStage3 = true
	end)
	timer.Create( "IntroStage4", 9, 1, function()
		TIRA.IntroStage1 = false
		TIRA.IntroStage2 = false
		TIRA.IntroStage3 = false
		TIRA.IntroStage4 = true
	end)
	timer.Create( "IntroStage5", 12, 1, function()
		TIRA.EndIntro()
	end)
end

function SKIN:PaintIntro()
	if TIRA.IntroStage1 then
		TIRA.IntroStage1Alpha = Lerp(1.5 * RealFrameTime(), TIRA.IntroStage1Alpha, 255 )
	end
	if TIRA.IntroStage2 then
		TIRA.IntroStage2Alpha = Lerp(1.5 * RealFrameTime(), TIRA.IntroStage2Alpha, 255 )
	end
	if TIRA.IntroStage3 then
		TIRA.IntroStage3Alpha = Lerp(1.5 * RealFrameTime(), TIRA.IntroStage3Alpha, 255 )
	end
	if TIRA.IntroStage4 then
		TIRA.IntroStage1Alpha = Lerp(2 * RealFrameTime(), TIRA.IntroStage1Alpha, 0 )
		TIRA.IntroStage2Alpha = Lerp(2 * RealFrameTime(), TIRA.IntroStage2Alpha, 0 )
		TIRA.IntroStage3Alpha = Lerp(2 * RealFrameTime(), TIRA.IntroStage3Alpha, 0 )
	end

	draw.SimpleTextOutlined( "Tiramisu", "Tiramisu64Font", ScrW()/2-20, ScrH() /2 - 50, Color(255,255,255,TIRA.IntroStage1Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(TIRA.IntroStage1Alpha, 130)))
	draw.SimpleTextOutlined( "                       2", "Tiramisu64Font", ScrW()/2, ScrH() /2 - 50, Color(255,0,0,TIRA.IntroStage2Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(TIRA.IntroStage2Alpha, 130)))
	draw.SimpleTextOutlined( "A new era in roleplay", "Tiramisu24Font", ScrW()/2, ScrH() / 2 + 10, Color(255,255,255,TIRA.IntroStage3Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(TIRA.IntroStage3Alpha, 130)))
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
		surface.DrawTexturedRectUV( x, y, panel:GetWide(), panel:GetTall(), 0, 0, 1, 1 )
		surface.SetDrawColor( 0, 0, 0, fade ) 
		surface.DrawTexturedRectUV(  x, y, panel:GetWide(), panel:GetTall(), 0, 0, 1, 1  )
	end
end

function SKIN:PaintQuickMenuLabel(panel)
	draw.SimpleTextOutlined( panel.LabelText or "", "Tiramisu32Font", panel:GetWide()/2, 0, Color(panel.SpecialColor.r,panel.SpecialColor.g,panel.SpecialColor.b,fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,fade))
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
	color = TIRA.BaseColor or Color( 100, 100, 115, 150 )
	
	// Background 
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
	TIRA.EnableBlackScreen( true )

	local subtitlelabel
	local titlelabel

	if hideclosebutton then
		TIRA.CurrentChar = false
	else
		TIRA.CurrentChar = TIRA.SelectedChar
	end

	if !CharacterMenu then
		CharacterMenu = vgui.Create( "DFrame" )
		CharacterMenu:SetSize( ScrW(), ScrH() )
		CharacterMenu:Center()
		CharacterMenu:SetDraggable( false )
		CharacterMenu:ShowCloseButton( false )
		CharacterMenu:SetTitle( "" )
		CharacterMenu.Paint = function()
			TIRA.DrawBlurScreen()
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
		titlelabel:SetText( TIRA.ConVars[ "IntroText" ] )
		titlelabel:SetFont( "Tiramisu64Font" )
		titlelabel:SizeToContents()
		titlelabel:SetPos( 20, 20 )
		CharacterMenu.AddChild(titlelabel)

		subtitlelabel = vgui.Create( "DLabel", CharacterMenu )
		subtitlelabel:SetText( TIRA.ConVars[ "IntroSubtitle" ] )
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
		if !CharacterListPanel or !CharacterListPanel:Valid() then
			CharacterListPanel = vgui.Create( "DPanelList", CharacterMenu )
			CharacterListPanel:SetSize( ScrW() - ScrH() - 100, ScrH() - 270 )
			CharacterListPanel:SetPos( 100, 170 )
			CharacterListPanel:SetSpacing( 5 )
			CharacterListPanel:SetAutoSize( false )
			CharacterListPanel:EnableVerticalScrollbar( true )
			CharacterMenu.AddChild( CharacterListPanel )
			CharacterListPanel.Paint = function()
			end
		elseif CharacterListPanel and CharacterListPanel:Valid() then
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
		if TIRA.SelectedChar then
			RunConsoleCommand( "rp_spawnchar", tostring( TIRA.SelectedChar ))
			derma.SkinHook( "Close", "CharacterSelection")
		else
			TIRA.Message( "You need to select a character first!", "Warning", "OK", Color( 140, 100, 100) )
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
		TIRA.EnableBlackScreen( true, true )
		TIRA.StartIntro( canclose )
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
			RunConsoleCommand("rp_selectchar", tostring( TIRA.CurrentChar ))
			derma.SkinHook( "Close", "CharacterSelection")
		end
		CharacterMenu.AddChild( closelabel )
	end
end

function SKIN:CloseCharacterSelection()
	TIRA.EnableBlackScreen( false )
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

		local modellist = vgui.Create( "DComboBox" )
		for k, v in pairs( TIRA.ConVars[ "DefaultModels" ][ Gender ] ) do
			modellist:AddChoice( v )
		end
		modellist.OnSelect = function( panel,index,value )
			RunConsoleCommand( "rp_testclothing", "none", value, SelectedClothing )
			SelectedModel = value
		end
		modellist:ChooseOptionID( 1 )

		local genderlist = vgui.Create( "DComboBox" )
		genderlist:AddChoice( "Male" )
		genderlist:AddChoice( "Female" )
		genderlist.OnSelect = function( panel,index,value )
			Gender = value
			RunConsoleCommand( "rp_testclothing", value, TIRA.ConVars[ "DefaultModels" ][ value ][1] )
			modellist:Clear()
			for k, v in pairs( TIRA.ConVars[ "DefaultModels" ][ Gender ] ) do
				modellist:AddChoice( v )
			end
			SelectedClothing = "none"
			SelectedModel = TIRA.ConVars[ "DefaultModels" ][ value ][1]
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

		local facev
		if TIRA.ConVars[ "UseEnhancedCitizens" ] then
			facev = vgui.Create( "DNumSlider", DermaPanel )
			facev:SetValue(0)
			facev:SetText( "Face Variation" )
			facev:SetMin( 0 ) -- Minimum number of the slider
			facev:SetMax( 12 ) -- Maximum number of the slider
			facev:SetDecimals( 0 ) -- Sets a decimal. Zero means it's a whole number
			facev.ValueChanged = function(self, value)
				RunConsoleCommand("rp_testskin", value)
			end
			panel:AddItem(facev)			
		end

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
			RunConsoleCommand("rp_selectchar", tostring( TIRA.SelectedChar ))
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
			if TIRA.ConVars[ "UseEnhancedCitizens" ] then
				RunConsoleCommand("rp_facevariation", facev:GetValue() )
			end
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
local staminaperc, staminaalpha
staminaalpha = 230
function SKIN:PaintStaminaBar()
	if TIRA.MinimalHUD:GetBool() then
		if LocalPlayer().TiramisuStaminaRegen and staminaalpha != 230 then
			staminaalpha = Lerp( 10 * RealFrameTime(), staminaalpha, 230 )
		elseif !LocalPlayer().TiramisuStaminaRegen then
			staminaalpha = Lerp( 10 * RealFrameTime(), staminaalpha, 0 )
		end
	else
		staminaalpha = 230
	end
	staminaperc = LocalPlayer():GetStamina() / 100
	if staminaalpha != 0 then
		--staminaperc = math.Clamp( staminaperc - 0.001, 0, 1 )
		draw.RoundedBoxEx( 4, ScrW()/2 - 150, 0, 300, 31, Color( 50, 50, 50, staminaalpha ), false, false, false, true )
		surface.SetDrawColor( Color( 10, 10, 10, staminaalpha ) )
		surface.DrawRect( ScrW()/2 - 147, 2, 293, 26 )
		draw.SimpleText(tostring(math.ceil(staminaperc * 100)) .. "%", "Tiramisu12Font", ScrW()/2 - 144 + 287, 9, Color(255,255,255,staminaalpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
		if staminaperc != 0 then
			draw.RoundedBoxEx( 2, ScrW()/2 - 144, 5, 287 * staminaperc, 20, Color( 200, 200, 50, staminaalpha ), false, false, false, true )
			draw.RoundedBoxEx( 2, ScrW()/2 - 140, 8, 280 * staminaperc, 4, Color( 255, 255, 255, math.Clamp( staminaalpha - 180, 0, 50) ), false, false, false, true )
		end
		draw.SimpleText("STAMINA", "Tiramisu12Font", ScrW()/2 - 144 + math.Clamp( 287 * staminaperc, 41, 287), 9, Color(255,255,255,staminaalpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
	end
end

/*---------------------------------------------------------
	Health Bar
---------------------------------------------------------*/
local healthperc, healthalpha
healthalpha = 230
local rot = 0
function SKIN:PaintHealthBar()
	if LocalPlayer():Alive() then
		rot = math.NormalizeAngle( rot + RealFrameTime() )
		if TIRA.MinimalHUD:GetBool() then
			if (TIRA.MenuOpen or LocalPlayer().IsDamaged) and healthalpha != 230 then
				healthalpha = Lerp( 10 * RealFrameTime(), healthalpha, 230 )
			elseif !(TIRA.MenuOpen or LocalPlayer().IsDamaged) then
				healthalpha = Lerp( 10 * RealFrameTime(), healthalpha, 0 )
			end
		else
			healthalpha = 230
		end
		healthperc = LocalPlayer():Health() / LocalPlayer():GetMaxHealth()
		if healthalpha != 0 then
			if LocalPlayer():Armor() > 0 then
				surface.SetDrawColor( Color( 50, 50, 50, healthalpha ) )
				surface.DrawNPoly( ScrW()-35, ScrH()/2 + 155, 15, 8, rot )
				draw.SimpleText(tostring(LocalPlayer():Armor()) .. "%", "Tiramisu12Font", ScrW()-35, ScrH()/2 + 155, Color(200,200,255,healthalpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			draw.RoundedBoxEx( 4, ScrW()- 31, ScrH()/2 - 150, 31, 300, Color( 50, 50, 50, healthalpha ), false, false, false, true )
			surface.SetDrawColor( Color( 10, 10, 10, healthalpha ) )
			surface.DrawRect( ScrW() - 28, ScrH()/2 - 147, 26,293 )
			draw.SimpleText(tostring(math.ceil(healthperc * 100)) .. "%", "Tiramisu12Font", ScrW() - 17, ScrH()/2 - 144, Color(255,255,255,healthalpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
			if healthperc != 0 then
				draw.RoundedBoxEx( 2, ScrW() - 26, ScrH()/2 - 144 + 287 - 287 * healthperc, 20, 287 * healthperc, Color( 200, 20, 20, healthalpha ), false, false, false, true )
				draw.RoundedBoxEx( 2, ScrW()-22, ScrH()/2 - 140+ 287 - 287 * healthperc, 4, 280 * healthperc, Color( 255, 255, 255, math.Clamp( healthalpha - 180, 0, 50) ), false, false, false, true )
			end
			draw.DrawText("H\nE\nA\nL\nT\nH", "Tiramisu12Font", ScrW()-18, ScrH()/2 - 144 + math.Clamp( 287 - 287 * healthperc, 0, 200), Color(255,255,255,healthalpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end
	end
end

/*---------------------------------------------------------
	AmmoDisplay
---------------------------------------------------------*/
local wep
function SKIN:PaintAmmoDisplay()
	wep = LocalPlayer():GetActiveWeapon()

	if ValidEntity( wep ) and Anims.AlwaysAimed and !table.HasValue(Anims.AlwaysAimed, wep:GetClass()) and Anims.NeverAimed and !table.HasValue(Anims.NeverAimed, wep:GetClass()) then
		draw.SimpleTextOutlined( tostring( wep:Clip1() ), "Tiramisu32Font", ScrW() - 70,ScrH() - 50, Color( 255, 255, 255, 230) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP,1,Color(0,0,0,100))
		draw.SimpleTextOutlined( "/" .. tostring( LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType())), "Tiramisu24Font", ScrW() - 68,ScrH() - 50, Color( 255, 255, 255, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP,1,Color(0,0,0,100))

		if wep:Clip2() > 0 then
			draw.SimpleTextOutlined( tostring( wep:Clip2() ), "Tiramisu18Font", ScrW() - 70,ScrH() - 30, Color( 255, 255, 255, 230), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP,1,Color(0,0,0,100))
			draw.SimpleTextOutlined( "/" .. tostring( LocalPlayer():GetAmmoCount(wep:GetSecondaryAmmoType())) , "Tiramisu18Font", ScrW() - 68,ScrH() - 30, Color( 255, 255, 255, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP,1,Color(0,0,0,100))
		end
	end
end


/*---------------------------------------------------------
	DeathMessage
---------------------------------------------------------*/
function SKIN:PaintDeathMessage()
	if LocalPlayer():GetNWInt("deathmode", 0 ) != 0 then
		if LocalPlayer():GetNWInt( "deathmoderemaining" ) < 5 and LocalPlayer():GetNWInt( "deathmoderemaining" ) != 0 then
			TIRA.EnableBlackScreen( TIRA.ConVars[ "FadeToBlackOnDeath" ] )
		end
		if LocalPlayer():GetNWInt( "deathmoderemaining" ) > 0 then
			--Normal death.
			if LocalPlayer():GetNWInt("deathmode", 0 ) == 1 then
				draw.DrawText( "You have been mortally wounded. Wait " .. tostring( LocalPlayer( ):GetNWInt( "deathmoderemaining" ) ) .. " seconds", "Tiramisu18Font", ScrW( ) / 2,60, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
			--Death while unconcious.
			elseif LocalPlayer():GetNWInt("deathmode", 0 ) == 2 then
				draw.DrawText( "You have died while unconcious. Wait " .. tostring( LocalPlayer( ):GetNWInt( "deathmoderemaining" ) ) .. " seconds", "Tiramisu18Font", ScrW( ) / 2,60, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
			end
		else
			if !TIRA.ConVars[ "Instant_Respawn" ] then
				draw.DrawText( "Press the button to respawn or type rp_acceptdeath in console.", "Tiramisu18Font", ScrW( ) / 2,60, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
			end
		end
	end
	
	if LocalPlayer():GetNWBool("unconciousmode", false ) then
		draw.DrawText( "You have passed out. Wait a few moments until you can wake up.", "Tiramisu18Font", ScrW( ) / 2 ,60, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	end
end

/*---------------------------------------------------------
	TiramisuClock, draws current gamemode time and player title.
---------------------------------------------------------*/
function SKIN:PaintTiramisuClock()
	if !TIRA.MinimalHUD:GetBool() or TIRA.MenuOpen then 
		if GetGlobalString( "time" ) != "Loading.." and GetGlobalString( "time" ) != "" then
			draw.SimpleTextOutlined( TIRA.FindDayName() .. ", " .. GetGlobalString( "time" ), "TiramisuNamesFont", ScrW() - 10, 10, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
		else
			draw.SimpleTextOutlined( GetGlobalString( "time" ), "TiramisuNamesFont", ScrW() - 10, 10, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
		end
	end
	if TIRA.MenuOpen then
		draw.SimpleTextOutlined( LocalPlayer():Nick(), "TiramisuNamesFont", ScrW() - 10, 30, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
		draw.SimpleTextOutlined( LocalPlayer():Title(), "TiramisuNamesFont", ScrW() - 10, 50, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
		draw.SimpleTextOutlined( LocalPlayer():GetNWInt( "money", 0 ) .. " " .. TIRA.ConVars[ "CurrencySlang" ] .. "s", "TiramisuNamesFont", ScrW() - 10, 70, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
	end
end

/*---------------------------------------------------------
	PlayerTitles, draws current gamemode time and player title.
---------------------------------------------------------*/
local foundents, ply, tracehull
function SKIN:ThinkPlayerTitles()
	foundents = ents.FindInSphere( LocalPlayer():GetPos(), TIRA.TitleDrawDistance:GetInt() )
	for _, ply in pairs(TIRA.NearbyPlayers) do
		if ValidEntity( ply ) and ply:IsTiraPlayer() then
			if !table.HasValue( foundents, ply ) then
				ply.FirstSeen = false
			else
				if !ply.FirstSeen then
					ply.FirstSeen = CurTime()
				end
			end
		end
	end
	TIRA.NearbyPlayers = foundents
	if TIRA.Thirdperson:GetBool() and LocalPlayer().CurrentLookAt then
		tracehull = util.TraceHull({
			start = LocalPlayer():EyePos(),
			endpos = LocalPlayer():EyePos() + (LocalPlayer().CurrentLookAt + LocalPlayer():GetAngles()):Forward() * TIRA.TitleDrawDistance:GetInt(),
			filter = LocalPlayer(),
			mins = LocalPlayer():OBBMins(),
			maxs = LocalPlayer():OBBMaxs()
		})
		if tracehull.Entity and ValidEntity(tracehull.Entity) and tracehull.Entity:IsTiraPlayer() then
			tracehull.Entity.Alpha = 255
			tracehull.Entity.FirstSeen = CurTime()
		end
	else
		ply = LocalPlayer():GetEyeTrace().Entity
		if ValidEntity(ply) and ply:IsTiraPlayer() then
			ply.Alpha = 255
			ply.FirstSeen = CurTime()
		end
	end
end

function SKIN:PaintPlayerTitles()
	for _, ply in pairs( TIRA.NearbyPlayers ) do
		if !LocalPlayer() then return end
		if ValidEntity( ply ) and ply:IsTiraPlayer() and ply:IsTiraPlayer() != LocalPlayer() and LocalPlayer():CanTraceTo(ply) and !ply:GetNWBool("unconciousmode") then
			local angleto = (ply:GetPos() - LocalPlayer():GetPos()):Angle()
			local yawdif = math.abs(math.AngleDifference(angleto.y, (LocalPlayer():GetAngles()).y + LocalPlayer().CurrentLookAt.y))
			local dist = ply:GetPos():Distance(LocalPlayer():GetPos())
			--print("Difference from: " .. yawdif, "Player: " .. LocalPlayer():GetAngles().y, "Other: " .. angleto.y)
			if yawdif < 30 then
				local plyt = ply:IsTiraPlayer()
				local pos = (ply:EyePos() + Vector(0, 0, 10)):ToScreen()
				if yawdif > 5 then
					ply.Alpha = 255 -  (255 * (math.pow(yawdif / 30, 2)))
				else
					ply.Alpha = 255
				end
				if pos.visible then
					if plyt:GetNWBool( "chatopen" ) then
						draw.SimpleTextOutlined( "Typing...", "TiramisuTitlesFont", pos.x, pos.y - 90, Color(255,255,255,ply.Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,100))
					end
					draw.SimpleTextOutlined( plyt:Nick(), "TiramisuNamesFont", pos.x, pos.y - 70, Color(255,255,255,ply.Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,100))
					
					local curleft = string.len(plyt:Title())
					local line = 0
					local lines = {}
					while curleft > 52 do
						draw.SimpleTextOutlined( plyt:Title():sub(line*52+1, line*52+52), "TiramisuTitlesFont", pos.x, pos.y - 45 + line*10, Color(255,255,255,ply.Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,100))
						curleft = curleft - 52
						line = line + 1
					end
					last = plyt:Title():sub(line*52+1, line*52+curleft)
					
					draw.SimpleTextOutlined( last, "TiramisuTitlesFont", pos.x, pos.y - 45 + line*10, Color(255,255,255,ply.Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,100))
				end
			end
		end
	end
end

/*---------------------------------------------------------
	DoorTitles, titles placed over doors.
---------------------------------------------------------*/
local door, doordata
function SKIN:PaintDoorTitles()
	door = LocalPlayer():GetEyeTrace().Entity
	if LocalPlayer().CurDoor and LocalPlayer().CurDoor != door then
		LocalPlayer().PrevDoor = LocalPlayer().CurDoor
		if ValidEntity( LocalPlayer().PrevDoor ) then
			LocalPlayer().PrevDoor.DoorAlpha = math.Clamp( LocalPlayer():EyePos():Distance( LocalPlayer().PrevDoor:GetPos() ) * - 1 + 300, 0, 255 )
		end
	end
	LocalPlayer().CurDoor = door
	if ValidEntity( door ) and TIRA.IsDoor( door ) and TIRA.GetDoorTitle( door ) != "" then
		doordata = TIRA.CalculateDoorTextPosition( door )
		if doordata and !doordata.HitWorld then
			viewpos = LocalPlayer():GetShootPos()
			alpha = math.Clamp( LocalPlayer():EyePos():Distance( door:GetPos() ) * - 1 + 300, 0, 255 )
			cam.Start3D2D(doordata.position, doordata.angles, 0.12 )
				draw.SimpleTextOutlined( TIRA.GetDoorTitle( door ), "Tiramisu48Font", 0, 0, Color( 255, 255, 255, alpha ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,alpha) )
			cam.End3D2D()
							
			cam.Start3D2D(doordata.positionBack, doordata.anglesBack, 0.12)
				draw.SimpleTextOutlined( TIRA.GetDoorTitle( door ), "Tiramisu48Font", 0, 0, Color( 255, 255, 255, alpha ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,alpha) )
			cam.End3D2D()
		end
	end
	if LocalPlayer().PrevDoor and ValidEntity( LocalPlayer().PrevDoor ) and TIRA.IsDoor( LocalPlayer().PrevDoor ) and TIRA.GetDoorTitle( LocalPlayer().PrevDoor ) != "" then
		if LocalPlayer().PrevDoor.DoorAlpha == 0 then
			LocalPlayer().PrevDoor.DoorAlpha = false
			LocalPlayer().PrevDoor = false
		else
			LocalPlayer().PrevDoor.DoorAlpha = -Lerp( RealFrameTime() * 5, -LocalPlayer().PrevDoor.DoorAlpha, 0 )
		end
		doordata = TIRA.CalculateDoorTextPosition( LocalPlayer().PrevDoor )
		if doordata and !doordata.HitWorld then
			viewpos = LocalPlayer():GetShootPos()
			alpha = LocalPlayer().PrevDoor.DoorAlpha
			cam.Start3D2D(doordata.position, doordata.angles, 0.12 )
				draw.SimpleTextOutlined( TIRA.GetDoorTitle( LocalPlayer().PrevDoor ), "Tiramisu48Font", 0, 0, Color( 255, 255, 255, alpha ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,alpha) )
			cam.End3D2D()
							
			cam.Start3D2D(doordata.positionBack, doordata.anglesBack, 0.12)
				draw.SimpleTextOutlined( TIRA.GetDoorTitle( LocalPlayer().PrevDoor ), "Tiramisu48Font", 0, 0, Color( 255, 255, 255, alpha ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,alpha) )
			cam.End3D2D()
		end
	end
end


/*---------------------------------------------------------
	TargetInfo, messages over items and props
---------------------------------------------------------*/
local screenpos
function SKIN:PaintTargetInfo()
	for _, ent in pairs( ents.FindInSphere( LocalPlayer():GetPos(), 500 ) ) do
		if ValidEntity( ent ) and !ent:IsWorld() and LocalPlayer():CanTraceTo(ent) then
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
local gradientup = surface.GetTextureID("gui/gradient_up.vtf")
local gradientdown = surface.GetTextureID("gui/gradient_down.vtf")
function SKIN:PaintBlurScreen()
	color = TIRA.BaseColor or Color( 100, 100, 115, 150 )

	// new hip way of doing gradients

	x,y = ScrW(), ScrH()

	surface.SetTexture(gradientdown)
	surface.SetDrawColor( 0, 0, 0, 250 ) 
	surface.DrawTexturedRectUV( 0, 0, x, y/5 ,0, 0, 1, 1)
	surface.SetTexture(gradientup)
	surface.DrawTexturedRectUV( 0, y - y/5, x, y/5 ,0, 0, 1, 1 )
	--
	
	// Background 
	
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

local textalpha = 200
local next, prev
local prevspot, nextspot = 0,0
local curslot
/*---------------------------------------------------------
	TiramisuWeaponSelection, used for selecting weapons
---------------------------------------------------------*/
function SKIN:PaintTiramisuWeaponSelection()
	if TIRA.ActiveSlot != -1 and TIRA.WeaponTable[TIRA.ActiveSlot] then
		textalpha = 200
		next = TIRA.ActiveWepPos + 1
		prev = TIRA.ActiveWepPos - 1
		if !TIRA.WeaponTable[TIRA.ActiveSlot][next] then
			next = 1
		end
		if !TIRA.WeaponTable[TIRA.ActiveSlot][prev] then
			prev = #TIRA.WeaponTable[TIRA.ActiveSlot]
		end
		prevspot, nextspot = ScrW()/2, ScrW()/2 + 175
		surface.SetDrawColor( Color( 0,0,0, 200 ) )
		surface.SetTexture( gradient )
		surface.DrawTexturedRectRotated(ScrW()/2-100,50,200,25,180)
		surface.DrawTexturedRectRotated(ScrW()/2+100,50,200,25,0)
		draw.DrawText( TIRA.WeaponTable[TIRA.ActiveSlot][TIRA.ActiveWepPos][1], "Tiramisu16Font", ScrW()/2, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT )
		draw.DrawText( TIRA.WeaponTable[TIRA.ActiveSlot][next][1], "Tiramisu16Font", ScrW()/2 + 175, 40, Color( 255, 255, 255, 120 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT )
		draw.DrawText( TIRA.WeaponTable[TIRA.ActiveSlot][prev][1], "Tiramisu16Font", ScrW()/2 - 175, 40, Color( 255, 255, 255, 120 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT )
	elseif textalpha != 0 then
		curslot = false
		textalpha = Lerp( 10 * RealFrameTime(), textalpha, 0 )
		surface.SetDrawColor( Color( 0,0,0, textalpha ) )
		--surface.SetTexture( gradientcenter )
		surface.DrawTexturedRectRotated(ScrW()/2-100,50,200,25,180)
		surface.DrawTexturedRectRotated(ScrW()/2+100,50,200,25,0)		
	end
end

/*---------------------------------------------------------
	TiramisuCrosshair
---------------------------------------------------------*/
local trace, pos
function SKIN:PaintTiramisuCrosshair()
		surface.SetDrawColor( 220, 220, 220, 220 )
		nv = chitpos:ToScreen()
		scrw = ScrW()/2
		scrh = ScrH()/2
		surface.DrawLine( scrw - 5, scrh, scrw + 5, scrh )
		surface.DrawLine( scrw, scrh - 5, scrw, scrh + 5 )
end

derma.DefineSkin( "Tiramisu", "Made to look like some good stuff", SKIN )