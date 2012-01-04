CLPLUGIN.Name = "Options Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"

hook.Add( "InitPostEntity", "TiramisuLoadSchemeColor", function()
	if file.Exists( CAKE.Name .. "/personaldata/schemecolor.txt" ) then
		local tbl = glon.decode( file.Read( CAKE.Name .. "/personaldata/schemecolor.txt" ))
		CAKE.BaseColor = tbl.color
	end
end)


local function OpenOptions()

	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Options" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	
	local Options = vgui.Create( "DPanelList", PlayerMenu )
	Options:Dock( LEFT )
	Options:SetWidth( 310 )
	Options:DockMargin( 0, 0, 5, 0 )
	Options:SetPadding(20)
	Options:SetSpacing(5)
	Options:EnableHorizontal(false)
	Options:EnableVerticalScrollbar(true)
	Options:SetAutoSize(false)
	
	local ThirdpersonCheck = vgui.Create( "DCheckBoxLabel"  )
	ThirdpersonCheck:SetText( "Toggle thirdperson camera" )
	ThirdpersonCheck:SetConVar( "rp_thirdperson" ) 
	Options:AddItem( ThirdpersonCheck )
	
	local HeadbobCheck = vgui.Create( "DCheckBoxLabel"  )
	HeadbobCheck:SetText( "Toggle head bobbing" )
	HeadbobCheck:SetConVar( "rp_headbob" ) 
	Options:AddItem( HeadbobCheck )

	local MinimalCheck = vgui.Create( "DCheckBoxLabel" )
	MinimalCheck:SetText( "Toggle minimal HUD" )
	MinimalCheck:SetConVar( "rp_minimalhud" ) 
	Options:AddItem( MinimalCheck )

	local CrouchCheck = vgui.Create( "DCheckBoxLabel" )
	CrouchCheck:SetText( "Enable toggled crouching" )
	CrouchCheck:SetConVar("rp_crouchtoggle" ) 
	Options:AddItem( CrouchCheck )

	local FirstpersonBody = vgui.Create( "DCheckBoxLabel" )
	FirstpersonBody:SetText( "Enable firstperson body visibility" )
	FirstpersonBody:SetConVar( "rp_firstpersonbody") 
	Options:AddItem( FirstpersonBody )

	local ThirdpersonDistance = vgui.Create( "DNumSlider" )
	ThirdpersonDistance:SetText( "Thirdperson Distance" )
	ThirdpersonDistance:SetDecimals( 0 )
	ThirdpersonDistance:SetMin( 30)
	ThirdpersonDistance:SetMax( 150 )
	ThirdpersonDistance:SetConVar( "rp_thirdpersondistance" )
	Options:AddItem( ThirdpersonDistance )

	local TitleDrawDistance = vgui.Create( "DNumSlider" )
	TitleDrawDistance:SetText( "3D Title Draw Distance( Affects Perfomance )" )
	TitleDrawDistance:SetDecimals( 0 )
	TitleDrawDistance:SetMin( 100 )
	TitleDrawDistance:SetMax( 2000 )
	TitleDrawDistance:SetConVar( "rp_titledrawdistance")
	Options:AddItem( TitleDrawDistance )

	local CameraSmoothFactor = vgui.Create( "DNumSlider" )
	CameraSmoothFactor:SetText( "Camera Smooth Factor ( Camera Speed )" )
	CameraSmoothFactor:SetDecimals( 1 )
	CameraSmoothFactor:SetMin( 1 )
	CameraSmoothFactor:SetMax( 20 )
	CameraSmoothFactor:SetConVar( "rp_camerasmooth")
	Options:AddItem( CameraSmoothFactor )
	
	local Custom = vgui.Create( "DPanelList", PlayerMenu )
	Custom:Dock( FILL )
	Custom:SetPadding(20)
	Custom:SetSpacing(5)
	Custom:EnableHorizontal(false)
	Custom:EnableVerticalScrollbar(true)
	Custom:SetAutoSize(false)

	local schemecolormixer = vgui.Create( "DColorMixer")
	schemecolormixer:SetColor( CAKE.BaseColor )
	schemecolormixer:SetSize( 200, 150 )
	
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
	Custom:AddItem( SchemeColor )
	Custom:AddItem( schemecolormixer )
	Custom:AddItem( SetSchemeColor )

	local colormixer = vgui.Create( "DColorMixer")
	colormixer:SetColor( Color( 0, 0, 255, 255 ) )
	colormixer:SetSize( 200, 150 )
	
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
	Custom:AddItem( OOCColor )
	Custom:AddItem( colormixer )
	Custom:AddItem( SetOOCColor )

end

local function CloseOptions()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Options", OpenOptions, CloseOptions )

function CLPLUGIN.Init()
	
end