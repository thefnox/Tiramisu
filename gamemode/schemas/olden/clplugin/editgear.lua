CLPLUGIN.Name = "Edit Gear"
CLPLUGIN.Author = "FNox"

local function EditGear() 
local EditPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
EditPanel:SetPos( 50,50 ) -- Position on the players screen
EditPanel:SetSize( 200, 400 ) -- Size of the frame
EditPanel:SetTitle( "Edit your gear" ) -- Title of the frame
EditPanel:SetVisible( true )
EditPanel:SetDraggable( true ) -- Draggable by mouse?
EditPanel:ShowCloseButton( true ) -- Show the close button?
EditPanel:MakePopup() -- Show the frame

local List= vgui.Create( "DMultiChoice", EditPanel )
	List:SetPos(2,32)
	List:SetSize( 195, 20 )
	List:AddChoice("Option 1")
	List:AddChoice("Option 2")
	List:AddChoice("Option 3")

	local PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent( EditPanel )
	PropertySheet:SetPos( 2, 30 )
	PropertySheet:SetSize( 198, 370 )

	local EditList = vgui.Create( "DPanelList" )
	EditList:SetPos( 25,25 )
	EditList:SetSize( 175, 375 )
	EditList:SetSpacing( 5 ) -- Spacing between items
	EditList:EnableHorizontal( false ) -- Only vertical items
	EditList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis

	PropertySheet:AddSheet( "General", EditList, "gui/silkicons/group", false, false, "Edit general settings");

	local PosList = vgui.Create( "DPanelList" )
	PosList:SetPos( 25,25 )
	PosList:SetSize( 175, 375 )
	PosList:SetSpacing( 10 ) -- Spacing between items
	PosList:EnableHorizontal( false ) -- Only vertical items
	PosList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis

	local xslider = vgui.Create( "DNumSlider" )
	xslider:SetText( "X Position" )
	xslider:SetMinMax( -10, 10 ) 
	PosList:AddItem( xslider )

	local yslider = vgui.Create( "DNumSlider" )
	yslider:SetText( "Y Position" )
	yslider:SetMinMax( -10, 10 )
	PosList:AddItem( yslider )

	local zslider = vgui.Create( "DNumSlider" )
	zslider:SetText( "Z Position" )
	zslider:SetMinMax( -10, 10 )
	PosList:AddItem( zslider )
	
	local resetbutton = vgui.Create( "DButton" )
	resetbutton:SetText( "Reset Coordinates" )
	PosList:AddItem( resetbutton )
	
	local setbutton = vgui.Create( "DButton" )
	setbutton:SetText( "Set Coordinates" )
	PosList:AddItem( setbutton )

	PropertySheet:AddSheet( "Position", PosList, "gui/silkicons/anchor", false, false, "Edit gear's position");

	local AngList = vgui.Create( "DPanelList" )
	AngList:SetPos( 25,25 )
	AngList:SetSize( 175, 375 )
	AngList:SetSpacing( 10 ) -- Spacing between items
	AngList:EnableHorizontal( false ) -- Only vertical items
	AngList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
	
	local pslider = vgui.Create( "DNumSlider" )
	pslider:SetText( "Pitch" )
	pslider:SetMinMax( -180, 180 ) 
	AngList:AddItem( pslider )

	local yslider = vgui.Create( "DNumSlider" )
	yslider:SetText( "Yaw" )
	yslider:SetMinMax( -180, 180 )
	AngList:AddItem( yslider )

	local rslider = vgui.Create( "DNumSlider" )
	rslider:SetText( "Roll" )
	rslider:SetMinMax( -180, 180 )
	AngList:AddItem( rslider )
	
	local resetbutton = vgui.Create( "DButton" )
	resetbutton:SetText( "Reset Angles" )
	AngList:AddItem( resetbutton )
	
	local setbutton = vgui.Create( "DButton" )
	setbutton:SetText( "Set Angles" )
	AngList:AddItem( setbutton )

	PropertySheet:AddSheet( "Angles", AngList, "gui/silkicons/application_view_detail", false, false, "Edit gear's angles");

	local ScaleList = vgui.Create( "DPanelList" )
	ScaleList:SetPos( 25,25 )
	ScaleList:SetSize( 175, 375 )
	ScaleList:SetSpacing( 10 ) -- Spacing between items
	ScaleList:EnableHorizontal( false ) -- Only vertical items
	ScaleList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
	
	local xslider = vgui.Create( "DNumSlider" )
	xslider:SetText( "X Scale" )
	xslider:SetMinMax( -10, 10 ) 
	ScaleList:AddItem( xslider )

	local yslider = vgui.Create( "DNumSlider" )
	yslider:SetText( "Y Scale" )
	yslider:SetMinMax( -10, 10 )
	ScaleList:AddItem( yslider )

	local zslider = vgui.Create( "DNumSlider" )
	zslider:SetText( "Z Scale" )
	zslider:SetMinMax( -10, 10 )
	ScaleList:AddItem( zslider )
	
	local resetbutton = vgui.Create( "DButton" )
	resetbutton:SetText( "Reset Coordinates" )
	ScaleList:AddItem( resetbutton )
	
	local setbutton = vgui.Create( "DButton" )
	setbutton:SetText( "Set Coordinates" )
	ScaleList:AddItem( setbutton )

	PropertySheet:AddSheet( "Angles", ScaleList, "gui/silkicons/magnifier", false, false, "Edit gear's angles");
end

local function EditSit( um )
	local vec = um:ReadVector( )
	local ang = um:ReadAngle( )
	local newposition, newangles = LocalToWorld( vec, ang, LocalPlayer():GetParent():GetPos(), LocalPlayer():GetParent():GetAngles() )
	LocalPlayer():SetRenderOrigin(newposition)
	LocalPlayer():SetRenderAngles(newangles)
end
usermessage.Hook( "editsit", EditSit )

local function RecieveGear( handler, id, encoded, decoded )

	CAKE.Gear = decoded
	PrintTable( CAKE.Gear )

end
datastream.Hook( "recievegear", RecieveGear );

local function RecieveClothing( handler, id, encoded, decoded )

	CAKE.ClothingTbl = decoded
	PrintTable( CAKE.ClothingTbl )

end
datastream.Hook( "recieveclothing", RecieveClothing );

function CLPLUGIN.Init()

end
