CLPLUGIN.Name = "Edit Gear"
CLPLUGIN.Author = "FNox"

function EditGear() 

	ClosePlayerMenu()
	
	local closebutton = vgui.Create( "DButton" )
	closebutton:SetSize( 100, 30 )
	closebutton:SetPos( ScrW() / 2 - 50, 20 )
	closebutton:SetText( "Close Editor" )
	closebutton.DoClick = function( button )
		if EditPanel then
			EditPanel:Remove()
			EditPanel = nil
		end
		if ClothingPanel then
			ClothingPanel:Remove()
			ClothingPanel = nil
		end
		hook.Remove( "CalcMainActivity", "EditGearIdle" )
		closebutton:Remove()
		closebutton = nil
		CAKE.MenuOpen = false
	end
	
	local bone = ""
	local ent
	local item = ""
	local itemlist
	
	EditPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
	EditPanel:SetPos( ScrW() - 210,50 ) -- Position on the players screen
	EditPanel:SetSize( 300, 300 ) -- Size of the frame
	EditPanel:SetTitle( "Edit your gear" ) -- Title of the frame
	EditPanel:SetVisible( true )
	EditPanel:SetDraggable( true ) -- Draggable by mouse?
	EditPanel:ShowCloseButton( true ) -- Show the close button?
	EditPanel:MakePopup() -- Show the frame

	local List= vgui.Create( "DMultiChoice", EditPanel )
	List:SetText( "Bone" )
	List:SetPos(2,32)
	List:SetSize( 296, 20 )
	List:AddChoice("pelvis")
	List:AddChoice("stomach")
	List:AddChoice("lower back")
	List:AddChoice("chest")
	List:AddChoice("upper back")
	List:AddChoice("neck")
	List:AddChoice("head")
	List:AddChoice("right clavicle")
	List:AddChoice("right upper arm")
	List:AddChoice("right forearm")
	List:AddChoice("right hand")
	List:AddChoice("left clavicle")
	List:AddChoice("left upper arm")
	List:AddChoice("left forearm")
	List:AddChoice("left hand")
	List:AddChoice("right thigh")
	List:AddChoice("right calf")
	List:AddChoice("right foot")
	List:AddChoice("right toe")
	List:AddChoice("left thigh")
	List:AddChoice("left calf")
	List:AddChoice("left foot")
	List:AddChoice("left toe")
	function List:OnSelect(index,value,data)
		bone = value
		if CAKE.Gear and CAKE.Gear[ bone ] then
			ent = CAKE.Gear[ bone ][ "entity" ]
			item = CAKE.Gear[ bone ][ "item" ]
			print( "ENTITY: " .. tostring( ent:EntIndex() ) .. " ITEM: " .. item )
			itemlist:SetText( item )
		else
			itemlist:SetText( "None" )
		end
	end

	local PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent( EditPanel )
	PropertySheet:SetPos( 2, 52 )
	PropertySheet:SetSize( 296, 370 )

	local EditList = vgui.Create( "DPanelList" )
	EditList:SetPos( 25,25 )
	EditList:SetSize( 275, 375 )
	EditList:SetSpacing( 10 ) -- Spacing between items
	EditList:EnableHorizontal( false ) -- Only vertical items
	EditList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
	
	local itemlabel = vgui.Create( "DLabel" )
	itemlabel:SetText( "Item:" )
	EditList:AddItem( itemlabel )
	
	itemlist= vgui.Create( "DMultiChoice" )
	itemlist:SetText( item or "-None-" )
	itemlist:SetPos(2,32)
	itemlist:SetSize( 295, 20 )
	function itemlist:OnSelect(index,value,data)
		RunConsoleCommand( "rp_setgear", value, bone )
		timer.Simple( 0.3, function()
			if CAKE.Gear and CAKE.Gear[ bone ] then
				ent = CAKE.Gear[ bone ][ "entity" ]
				item = CAKE.Gear[ bone ][ "item" ]
			end
		end)
	end
	for k, v in pairs( InventoryTable ) do
		itemlist:AddChoice( v.Class )
	end
	EditList:AddItem( itemlist )
	
	local skinlabel = vgui.Create( "DLabel" )
	skinlabel:SetText( "Skin:" )
	EditList:AddItem( skinlabel )
	
	local skinnumber = vgui.Create( "DNumberWang" )
	skinnumber:SetMax( 20 )
	skinnumber:SetMin( 0 )
	skinnumber:SetDecimals( 0 )
	function skinnumber:OnValueChanged( val )
		RunConsoleCommand( "rp_editgear", bone, "none", "none", "none", "none", tostring( val ))
	end
	EditList:AddItem( skinnumber )
	
	local removebutton = vgui.Create( "DButton" )
	removebutton:SetSize( 100, 30 )
	removebutton:SetText( "Remove Gear" )
	removebutton.DoClick = function( button )
		RunConsoleCommand( "rp_removegear", bone )
	end
	EditList:AddItem( removebutton )
	
	local removeallbutton = vgui.Create( "DButton" )
	removeallbutton:SetSize( 100, 30 )
	removeallbutton:SetText( "Remove All Gear" )
	removeallbutton.DoClick = function( button )
		RunConsoleCommand( "rp_removegear" )
	end
	EditList:AddItem( removeallbutton )
	
	PropertySheet:AddSheet( "General", EditList, "gui/silkicons/group", false, false, "Edit general settings");

	local PosList = vgui.Create( "DPanelList" )
	PosList:SetPos( 25,25 )
	PosList:SetSize( 175, 375 )
	PosList:SetSpacing( 10 ) -- Spacing between items
	PosList:EnableHorizontal( false ) -- Only vertical items
	PosList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis

	local xslider = vgui.Create( "DNumSlider" )
	xslider:SetText( "X Position" )
	xslider:SetMinMax( -40, 40 )
	xslider.ValueChanged = function(self, value)
		if CAKE.Gear[ bone ] and ValidEntity( CAKE.Gear[ bone ][ "entity" ] ) then
			RunConsoleCommand( "rp_editgear", bone, tostring( value ) .. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 1 ).y ) .. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 1 ).z ) )
		end
	end
	PosList:AddItem( xslider )

	local yslider = vgui.Create( "DNumSlider" )
	yslider:SetText( "Y Position" )
	yslider:SetMinMax( -40, 40 )
	yslider.ValueChanged = function(self, value)
		if CAKE.Gear[ bone ] and ValidEntity( CAKE.Gear[ bone ][ "entity" ] ) then
			RunConsoleCommand( "rp_editgear", bone, tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 1 ).x ) .. "," .. tostring( value ) .. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 1 ).z ) )
		end
	end
	PosList:AddItem( yslider )

	local zslider = vgui.Create( "DNumSlider" )
	zslider:SetText( "Z Position" )
	zslider:SetMinMax( -40, 40 )
	zslider.ValueChanged = function(self, value)
		if CAKE.Gear[ bone ] and ValidEntity( CAKE.Gear[ bone ][ "entity" ] ) then
			RunConsoleCommand( "rp_editgear", bone, tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 1 ).x ) .. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 1 ).y ) .. "," .. tostring( value ) )
		end
	end
	PosList:AddItem( zslider )
	
	local resetbutton = vgui.Create( "DButton" )
	resetbutton:SetText( "Reset Coordinates" )
	resetbutton.DoClick = function( button )
		RunConsoleCommand( "rp_editgear", bone, "0,0,0" )
	end
	PosList:AddItem( resetbutton )
	
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
	pslider.ValueChanged = function(self, value)
		if CAKE.Gear[ bone ] and ValidEntity( CAKE.Gear[ bone ][ "entity" ] ) then
			RunConsoleCommand( "rp_editgear", bone, "none" ,tostring( value ).. "," ..tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTAngle( 1 ).y ) .. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTAngle( 1 ).r ) )
		end
	end
	AngList:AddItem( pslider )

	local yslider = vgui.Create( "DNumSlider" )
	yslider:SetText( "Yaw" )
	yslider:SetMinMax( -180, 180 )
	yslider.ValueChanged = function(self, value)
		if CAKE.Gear[ bone ] and ValidEntity( CAKE.Gear[ bone ][ "entity" ] ) then
			RunConsoleCommand( "rp_editgear", bone, "none" ,tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTAngle( 1 ).p ).. "," .. tostring( value ) .. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTAngle( 1 ).r ) )
		end
	end
	AngList:AddItem( yslider )

	local rslider = vgui.Create( "DNumSlider" )
	rslider:SetText( "Roll" )
	rslider:SetMinMax( -180, 180 )
	rslider.ValueChanged = function(self, value)
		if CAKE.Gear[ bone ] and ValidEntity( CAKE.Gear[ bone ][ "entity" ] ) then
			RunConsoleCommand( "rp_editgear", bone, "none" ,tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTAngle( 1 ).p ).. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTAngle( 1 ).y ) .. "," .. tostring( value ) )
		end
	end
	AngList:AddItem( rslider )
	
	local resetbutton = vgui.Create( "DButton" )
	resetbutton:SetText( "Reset Angles" )
	resetbutton.DoClick = function( button )
		RunConsoleCommand( "rp_editgear", bone, "none", "0,0,0" )
	end
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
	xslider.ValueChanged = function(self, value)
		if CAKE.Gear[ bone ] and ValidEntity( CAKE.Gear[ bone ][ "entity" ] ) then
			RunConsoleCommand( "rp_editgear", bone, "none", "none", tostring( value ) .. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 2 ).y ) .. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 2 ).z ) )
		end
	end
	ScaleList:AddItem( xslider )

	local yslider = vgui.Create( "DNumSlider" )
	yslider:SetText( "Y Scale" )
	yslider:SetMinMax( -10, 10 )
	yslider.ValueChanged = function(self, value)
		if CAKE.Gear[ bone ] and ValidEntity( CAKE.Gear[ bone ][ "entity" ] ) then
			RunConsoleCommand( "rp_editgear", bone, "none", "none", tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 2 ).x ) .. "," .. tostring( value ) .. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 2 ).z ) )
		end
	end
	ScaleList:AddItem( yslider )

	local zslider = vgui.Create( "DNumSlider" )
	zslider:SetText( "Z Scale" )
	zslider:SetMinMax( -10, 10 )
	zslider.ValueChanged = function(self, value)
		if CAKE.Gear[ bone ] and ValidEntity( CAKE.Gear[ bone ][ "entity" ] ) then
			RunConsoleCommand( "rp_editgear", bone, "none", "none", tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 2 ).x ) .. "," .. tostring( CAKE.Gear[ bone ][ "entity" ]:GetDTVector( 2 ).y ) .. "," ..  tostring( value ) )
		end
	end
	ScaleList:AddItem( zslider )
	
	local resetbutton = vgui.Create( "DButton" )
	resetbutton:SetText( "Reset Coordinates" )
	resetbutton.DoClick = function( button )
		RunConsoleCommand( "rp_editgear", bone, "none", "none", "1,1,1" )
	end
	ScaleList:AddItem( resetbutton )
	
	local setbutton = vgui.Create( "DButton" )
	setbutton:SetText( "Set Coordinates" )
	ScaleList:AddItem( setbutton )

	PropertySheet:AddSheet( "Scale", ScaleList, "gui/silkicons/magnifier", false, false, "Edit gear's scale");
	
	ClothingPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
	ClothingPanel:SetPos( 10 ,50 ) -- Position on the players screen
	ClothingPanel:SetSize( 400, 630 ) -- Size of the frame
	ClothingPanel:SetTitle( "Edit your clothing" ) -- Title of the frame
	ClothingPanel:SetVisible( true )
	ClothingPanel:SetDraggable( true ) -- Draggable by mouse?
	ClothingPanel:ShowCloseButton( true ) -- Show the close button?
	ClothingPanel:MakePopup() -- Show the frame
	
	local ctrl = vgui.Create( "OldenModelBrowser", ClothingPanel )
	ctrl:SetSize( 400, 577 )
	ctrl:SetPos( 0, 23 )
	
	local search = vgui.Create( "DTextEntry", ClothingPanel )
	search:SetSize( 400, 20 )
	search:SetPos( 0, 610 )
	search:SetText( "Enter folder to search ( FOLDERS ONLY )" )
    search.OnTextChanged = function( txtentry )
		if ctrl then
			ctrl:ModelBrowse( txtentry:GetValue() or "" )
		end
	end

	
	/*
	local ToolData = vgui.Create("DPanelList", ClothingPanel );
	ToolData:SetPos( 0, 23 )
	ToolData:SetSize( 300, 277 )
	ToolData:SetAutoSize(true)
	ToolData:SetPadding(10);
	ToolData:SetSpacing(4);
	
	local modellabel = vgui.Create("DLabel");
	modellabel:SetSize(30,25);
	modellabel:SetPos(5, 50);
	modellabel:SetText("Model: ")
	
	local modelname = vgui.Create("DTextEntry");
	modelname:SetSize(450,20);
	modelname:SetPos(390, 50);
	modelname:SetText("");
	
	local permacheck = vgui.Create( "DCheckBoxLabel" )
	permacheck:SetText( "Permanently change your model" )
	
	local specialcheck = vgui.Create( "DCheckBoxLabel" )
	specialcheck:SetText( "Non bipedal/prop/special model" )
	
	local selectedpart = 0
	local bodypart = vgui.Create( "DMultiChoice" )
	bodypart:AddChoice("Whole Body")
	bodypart:AddChoice("Torso/Legs")
	bodypart:AddChoice("Head")
	bodypart:AddChoice("Hands")
	bodypart:ChooseOptionID( 1 )
	function bodypart:OnSelect(index,value,data)
		selectedpart = index - 1
		print( tostring( selectedpart ) )
	end
		
	local settemp = vgui.Create("DButton");
	settemp:SetSize(75, 25);
	settemp:SetText("Change Your Model");
	settemp.DoClick = function ( btn )
		
		if(modelname:GetValue() == "" ) then
			LocalPlayer():PrintMessage(3, "You must enter a model's file path!");
			return;
		end
		 
		local permabool = permacheck:GetChecked(true)
		local permastr = "0"
		local specialbool = specialcheck:GetChecked(true)
		local specialstr = "0"
		if permabool then permastr = "1" end
		if specialbool then specialstr = "1" end
		
		LocalPlayer():ConCommand("rp_changemodel \"" .. modelname:GetValue() .. "\" " .. permastr .. " " .. specialstr .. " " .. tostring(selectedpart));
		
	end
	
	
	ToolData:AddItem(modellabel)
	ToolData:AddItem(modelname)
	ToolData:AddItem(settemp)
	ToolData:AddItem(permacheck)
	ToolData:AddItem(specialcheck)
	ToolData:AddItem(bodypart)*/
	hook.Add( "CalcMainActivity", "EditGearIdle", function()
		return ACT_DIERAGDOLL, -1
	end)
	
	
end

local function CloseGear()
	if EditPanel then
		EditPanel:Remove()
		EditPanel = nil
	end
end
CAKE.RegisterMenuTab( "Character Editor", EditGear, CloseGear )

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

end
datastream.Hook( "recievegear", RecieveGear );

local function RecieveClothing( handler, id, encoded, decoded )

	CAKE.ClothingTbl = decoded

end
datastream.Hook( "recieveclothing", RecieveClothing );

local function EnterEditGear( handler, id, encoded, decoded )

	CAKE.SetActiveTab( "Character Editor" )

end
datastream.Hook( "EnterGearEdit", EnterEditGear );

function CLPLUGIN.Init()

end
