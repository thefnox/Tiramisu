CLPLUGIN.Name = "Options Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"


local function OpenOptions()

	PlayerMenu = vgui.Create( "DFrameTransparent" )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Options" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	
	local Options = vgui.Create( "DPanelList", PlayerMenu )
	Options:SetSize( 630, 448 )
	Options:SetPos( 5, 28 )
	Options:SetPadding(20);
	Options:SetSpacing(5)
	Options:EnableHorizontal(false);
	Options:EnableVerticalScrollbar(true);
	Options:SetAutoSize(false)
	
	local ThirdpersonCheck = vgui.Create( "DCheckBoxLabel"  )
	ThirdpersonCheck:SetText( "Toggle thirdperson camera" )
	ThirdpersonCheck:SetConVar( "rp_thirdperson" ) -- ConCommand must be a 1 or 0 value
	Options:AddItem( ThirdpersonCheck )
	
	
	local HeadbobCheck = vgui.Create( "DCheckBoxLabel"  )
	HeadbobCheck:SetText( "Toggle head bobbing" )
	HeadbobCheck:SetConVar( "rp_headbob" ) -- ConCommand must be a 1 or 0 value
	Options:AddItem( HeadbobCheck )

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
	
	local colormixer = vgui.Create( "DColorMixer");
	colormixer:SetColor( Color( 0, 0, 255, 255 ) )
	colormixer:SetSize( 200, 200 )
	
	local OOCColor = vgui.Create( "DLabel" )
	OOCColor:SetText( "OOC Color" )
	OOCColor:SetFont( "Trebuchet24" )
	function OOCColor:PaintOver()
		OOCColor:SetTextColor( colormixer:GetColor() )
	end
	
	local SetOOCColor = vgui.Create( "DButton" )
	SetOOCColor:SetText( "Set your OOC Color" )
	SetOOCColor.DoClick = function()
		local color = OOCColor:GetColor()
		RunConsoleCommand( "rp_ooccolor", tostring( color.r ), tostring( color.g ), tostring( color.b ), tostring( color.a ) )
	end
	Options:AddItem( OOCColor )
	Options:AddItem( colormixer )
	Options:AddItem( SetOOCColor )

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