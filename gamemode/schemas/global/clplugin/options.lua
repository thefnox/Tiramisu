CLPLUGIN.Name = "Options Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"


local function OpenOptions()

	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Options" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	PlayerMenu:SetBackgroundBlur( true )
	
	local Options = vgui.Create( "DPanelList", PlayerMenu )
	Options:SetSize( 640, 450 )
	Options:SetPos( 0, 23 )
	Options:SetPadding(20);
	Options:SetSpacing(15)
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
	
	
	local colormixer = vgui.Create( "DColorMixer");
	colormixer:SetColor( Color( 0, 0, 255, 255 ) )
	colormixer:SetSize( 200, 200 )
	
	local OOCColor = vgui.Create( "DLabel" )
	OOCColor:SetText( "OOC Color" )
	OOCColor:SetFont( "HUDNumber" )
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