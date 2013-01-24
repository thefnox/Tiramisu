hook.Add( "InitPostEntity", "TiramisuLoadSchemeColor", function()
	if file.Exists( CAKE.Name .. "/personaldata/schemecolor.txt", "DATA" ) then
		local tbl = glon.decode( file.Read( CAKE.Name .. "/personaldata/schemecolor.txt" ))
		CAKE.BaseColor = tbl.color
	end
end)


local function OpenOptions()

	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 650, 560 )
	PlayerMenu:SetTitle( "Options" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()

	local title = Label( "Options", PlayerMenu)
	title:SetFont( "Tiramisu48Font")
	title:SetPos( 10, 23 )
	title:SizeToContents()
	local subtitle = Label( "Configuration and settings", PlayerMenu)
	subtitle:SetPos( 10, 66 )
	subtitle:SetFont( "Tiramisu24Font")
	subtitle:SizeToContents()
	
	local Options = vgui.Create( "DPanelList", PlayerMenu )
	Options:Dock( LEFT )
	Options:SetWidth( 310 )
	Options.Paint = function() end
	Options:DockMargin( 0, 70, 5, 0 )
	Options:SetPadding(5)
	Options:SetSpacing(5)
	Options:EnableHorizontal(false)
	Options:EnableVerticalScrollbar(true)
	Options:SetAutoSize(false)

	local General = vgui.Create( "DForm" )
	General:SetName( "General:" )
	General:SetSpacing( 5 )
	General:SetPadding( 5 )

	local MinimalCheck = vgui.Create( "DCheckBoxLabel" )
	MinimalCheck:SetText( "Toggle minimal HUD" )
	MinimalCheck:SetConVar( "rp_minimalhud" ) 
	General:AddItem( MinimalCheck )

	local CrouchCheck = vgui.Create( "DCheckBoxLabel" )
	CrouchCheck:SetText( "Enable toggled crouching" )
	CrouchCheck:SetConVar("rp_crouchtoggle" ) 
	General:AddItem( CrouchCheck )

	local AlwaysIntro = vgui.Create( "DCheckBoxLabel" )
	AlwaysIntro:SetText( "Always display the intro" )
	AlwaysIntro:SetConVar( "rp_alwaysintro") 
	General:AddItem( AlwaysIntro )

	Options:AddItem( General )

	local Camera = vgui.Create( "DForm" )
	Camera:SetName( "Camera:" )
	Camera:SetSpacing( 5 )
	Camera:SetPadding( 5 )

	local ThirdpersonCheck = vgui.Create( "DCheckBoxLabel"  )
	ThirdpersonCheck:SetText( "Toggle thirdperson camera" )
	ThirdpersonCheck:SetConVar( "rp_thirdperson" ) 
	Camera:AddItem( ThirdpersonCheck )
	
	local HeadbobCheck = vgui.Create( "DCheckBoxLabel"  )
	HeadbobCheck:SetText( "Toggle head bobbing" )
	HeadbobCheck:SetConVar( "rp_headbob" ) 
	Camera:AddItem( HeadbobCheck )

	local FirstpersonBody = vgui.Create( "DCheckBoxLabel" )
	FirstpersonBody:SetText( "Enable firstperson body visibility" )
	FirstpersonBody:SetConVar( "rp_firstpersonbody") 
	Camera:AddItem( FirstpersonBody )

	local ThirdpersonDistance = vgui.Create( "DNumSlider" )
	ThirdpersonDistance:SetText( "Thirdperson Distance" )
	ThirdpersonDistance:SetDecimals( 0 )
	ThirdpersonDistance:SetMin( 30)
	ThirdpersonDistance:SetMax( 150 )
	ThirdpersonDistance:SetConVar( "rp_thirdpersondistance" )
	Camera:AddItem( ThirdpersonDistance )

	local CameraSmoothFactor = vgui.Create( "DNumSlider" )
	CameraSmoothFactor:SetText( "Camera Smooth Factor ( Camera Speed )" )
	CameraSmoothFactor:SetDecimals( 1 )
	CameraSmoothFactor:SetMin( 1 )
	CameraSmoothFactor:SetMax( 20 )
	CameraSmoothFactor:SetConVar( "rp_camerasmooth")
	Camera:AddItem( CameraSmoothFactor )

	local FirstpersonForward = vgui.Create( "DNumSlider" )
	FirstpersonForward:SetText( "Firstperson Forward" )
	FirstpersonForward:SetDecimals( 1 )
	FirstpersonForward:SetMin( 0 )
	FirstpersonForward:SetMax( 10 )
	FirstpersonForward:SetConVar( "rp_firstpersonforward" )
	Camera:AddItem( FirstpersonForward )

	local FirstpersonUp = vgui.Create( "DNumSlider" )
	FirstpersonUp:SetText( "Firstperson Up" )
	FirstpersonUp:SetDecimals( 1 )
	FirstpersonUp:SetMin( -2 )
	FirstpersonUp:SetMax( 8 )
	FirstpersonUp:SetConVar( "rp_firstpersonup" )
	Camera:AddItem( FirstpersonUp )

	Options:AddItem( Camera )

	local Titles = vgui.Create( "DForm" )
	Titles:SetName( "Titles:" )
	Titles:SetSpacing( 5 )
	Titles:SetPadding( 5 )

	local TitleDrawDistance = vgui.Create( "DNumSlider" )
	TitleDrawDistance:SetText( "Title Draw Distance" )
	TitleDrawDistance:SetDecimals( 0 )
	TitleDrawDistance:SetMin( 100 )
	TitleDrawDistance:SetMax( 2000 )
	TitleDrawDistance:SetConVar( "rp_titledrawdistance")
	Titles:AddItem( TitleDrawDistance )

	local TitleFadeTime = vgui.Create( "DNumSlider" )
	TitleFadeTime:SetText( "Title Fade Time (Set to 0 to disable)" )
	TitleFadeTime:SetDecimals( 0 )
	TitleFadeTime:SetMin( 0 )
	TitleFadeTime:SetMax( 100 )
	TitleFadeTime:SetConVar("rp_titlefadetime")
	Titles:AddItem( TitleFadeTime )

	local NameFadeCheck = vgui.Create( "DCheckBoxLabel" )
	NameFadeCheck:SetText( "Fade Names after time has elapsed" )
	NameFadeCheck:SetConVar( "rp_fadenames" ) 
	Titles:AddItem( NameFadeCheck )

	local TitleFadeCheck = vgui.Create( "DCheckBoxLabel" )
	TitleFadeCheck:SetText( "Fade Titles after time has elapsed" )
	TitleFadeCheck:SetConVar( "rp_fadetitles" ) 
	Titles:AddItem( TitleFadeCheck )

	Options:AddItem( Titles )
	
	local Custom = vgui.Create( "DPanelList", PlayerMenu )
	Custom:Dock( FILL )
	Custom:DockMargin( 0, 70, 0, 0 )
	Custom.Paint = function() end
	Custom:SetPadding(5)
	Custom:SetSpacing(5)
	Custom:EnableHorizontal(false)
	Custom:EnableVerticalScrollbar(true)
	Custom:SetAutoSize(false)

	local Schema = vgui.Create( "DForm" )
	Schema:SetName( "Schema:" )
	Schema:SetSpacing( 5 )
	Schema:SetPadding( 5 )

	local schemecolormixer = vgui.Create( "DColorMixer")
	schemecolormixer:SetColor( CAKE.BaseColor )
	schemecolormixer:SetSize( 200, 140 )
	
	local SchemeColor = vgui.Create( "DLabel" )
	SchemeColor:SetText( "Scheme Color" )
	SchemeColor:SetFont( "Tiramisu24Font" )
	function SchemeColor:PaintOver()
		SchemeColor:SetTextColor( schemecolormixer:GetColor() )
	end
	
	local SetSchemeColor = vgui.Create( "DButton" )
	SetSchemeColor:SetText( "Set the scheme color" )
	SetSchemeColor.DoClick = function()
		local color = SchemeColor:GetColor()
		CAKE.BaseColor = color
		local tbl = { ["color"] = CAKE.BaseColor }
		file.Write( CAKE.Name .. "/personaldata/schemecolor.txt", glon.encode( tbl ) )
	end
	Schema:AddItem( SchemeColor )
	Schema:AddItem( schemecolormixer )
	Schema:AddItem( SetSchemeColor )

	Custom:AddItem( Schema )

	local OOC = vgui.Create( "DForm" )
	OOC:SetName( "OOC:" )
	OOC:SetSpacing( 5 )
	OOC:SetPadding( 5 )

	local colormixer = vgui.Create( "DColorMixer")
	colormixer:SetColor( Color( 0, 0, 255, 255 ) )
	colormixer:SetSize( 200, 140 )
	
	local OOCColor = vgui.Create( "DLabel" )
	OOCColor:SetText( "OOC Color" )
	OOCColor:SetFont( "Tiramisu24Font" )
	function OOCColor:PaintOver()
		OOCColor:SetTextColor( colormixer:GetColor() )
	end
	
	local SetOOCColor = vgui.Create( "DButton" )
	SetOOCColor:SetText( "Set your OOC Color" )
	SetOOCColor.DoClick = function()
		local color = OOCColor:GetColor()
		RunConsoleCommand( "rp_ooccolor", tostring( color.r ), tostring( color.g ), tostring( color.b ), tostring( color.a ) )
	end
	OOC:AddItem( OOCColor )
	OOC:AddItem( colormixer )
	OOC:AddItem( SetOOCColor )

	Custom:AddItem( OOC )

end

local function CloseOptions()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Options", OpenOptions, CloseOptions )