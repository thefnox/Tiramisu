CLPLUGIN.Name = "Edit Gear"
CLPLUGIN.Author = "FNox"

CAKE.Gear = {}
CAKE.Clothing = "none"
CAKE.Helmet = "none"

local BoneList = {
		"Pelvis",
		"Stomach",
		"Lower back",
		"Chest",
		"Upper back",
		"Neck",
		"Head",
		"Right clavicle",
		"Right upper arm",
		"Right forearm",
		"Right hand",
		"Left clavicle",
		"Left upper arm",
		"Left forearm",
		"Left hand",
		"Right thigh",
		"Right calf",
		"Right foot",
		"Right toe",
		"Left thigh",
		"Left calf",
		"Left foot",
		"Left toe"
}

local function HandleGearEditing( entity, bone, item )

	CloseGear()

	if entity and ValidEntity( entity ) then
		StartGearEditor( entity, item, bone, entity:GetDTVector( 1 ), entity:GetDTAngle( 1 ), entity:GetDTVector( 2 ), entity:GetSkin() )
	else
		if frame then
			frame:Remove()
			frame = nil
		end

		local frame = vgui.Create( "DFrameTransparent" )
		frame:SetSize( 360, 423 )
		frame:Center()
		frame:SetTitle( "Choose the item you want to use for your gear" )
		frame:MakePopup()

		local panel = vgui.Create( "DPanelList", frame )
		panel:SetSize( 350, 390 )
		panel:SetPos( 5, 28 )
		panel:SetSpacing( 5 )
		panel:SetPadding( 5 )
		panel:EnableHorizontal( true )

		for k, v in pairs(InventoryTable) do
			if !string.match( v.Class, "clothing" ) and !string.match( v.Class, "helmet" ) then
			    local spawnicon = vgui.Create( "SpawnIcon");
			    spawnicon:SetIconSize( 64 )
			    spawnicon:SetModel(v.Model);
			    spawnicon:SetToolTip(v.Description)
			    spawnicon.DoClick = function()
			        RunConsoleCommand( "rp_setgear", v.Class, bone )
			        frame:Remove()
			        frame = nil

			    end
			    panel:AddItem( spawnicon )
			end
		end
	end

end

function EditGear() 

	PlayerMenu = vgui.Create( "DFrameTransparent" )
	PlayerMenu:SetSize( 330, 570 )
	PlayerMenu:Center()
	PlayerMenu:SetTitle( "Character Editor" )

	local PropertySheet = vgui.Create( "DPropertySheet", PlayerMenu )
	PropertySheet:SetPos( 5, 28 )
	PropertySheet:SetSize( 320, 537 )

	local ClothingList = vgui.Create( "DPanelList" )
	ClothingList:SetSize( 300, 527 )
	PropertySheet:AddSheet( "Clothing", ClothingList, "gui/silkicons/user", false, false, "Edit your clothes" )

	local ClothesCategory = vgui.Create("DCollapsibleCategory")
	ClothesCategory:SetExpanded( 1 ) -- Expanded when popped up
	ClothesCategory:SetLabel( "Clothing/Bodies" )
	ClothingList:AddItem( ClothesCategory )

	local clist = vgui.Create( "DPanelList" )
	clist:SetAutoSize( true )
	clist:SetSpacing( 5 )
	clist:EnableHorizontal( true )
	clist:EnableVerticalScrollbar( true )
	ClothesCategory:SetContents( clist )

	local button
	for k, v in pairs( InventoryTable ) do
		if( string.match( v.Class, "clothing" ) ) then
			button = vgui.Create( "SpawnIcon" )
			button:SetIconSize( 64 )
			button:SetModel( v.Model )
			button:SetToolTip(v.Description)
			button.DoClick = function()
				CAKE.Clothing = v.Class
				LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
			end
			clist:AddItem( button )
		end
	end
	button = vgui.Create( "SpawnIcon" )
	button:SetIconSize( 64 )
	button:SetModel( LocalPlayer():GetModel() )
	button:SetToolTip( "Your default clothes" )
	button.DoClick = function()
		CAKE.Clothing = "none"
		LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
	end
	clist:AddItem( button )

	local HelmetCategory = vgui.Create("DCollapsibleCategory")
	HelmetCategory:SetExpanded( 1 ) -- Expanded when popped up
	HelmetCategory:SetLabel( "Helmets/Heads" )
	ClothingList:AddItem( HelmetCategory )

	local hlist = vgui.Create( "DPanelList" )
	hlist:SetAutoSize( true )
	hlist:SetSpacing( 5 )
	hlist:EnableHorizontal( true )
	hlist:EnableVerticalScrollbar( true )
	HelmetCategory:SetContents( hlist )

	for k, v in pairs( InventoryTable ) do
		if( string.match( v.Class, "helmet" ) ) then
			button = vgui.Create( "SpawnIcon" )
			button:SetIconSize( 64 )
			button:SetModel( v.Model )
			button:SetToolTip(v.Description)
			button.DoClick = function()
				CAKE.Helmet = v.Class
				LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
			end
			hlist:AddItem( button )
		end
	end
	button = vgui.Create( "SpawnIcon" )
	button:SetIconSize( 64 )
	button:SetModel( LocalPlayer():GetModel() )
	button:SetToolTip( "Your default head" )
	button.DoClick = function()
		CAKE.Helmet = "none"
		LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
	end
	hlist:AddItem( button )

	local GearList = vgui.Create( "DPanelList" )
	GearList:SetSize( 300, 527 )
	PropertySheet:AddSheet( "Gear/Accessories", GearList, "gui/silkicons/wrench", false, false, "Edit your gear" )

	local GearTree = vgui.Create( "DTree" )
	GearTree:SetPadding( 5 )
	GearTree:SetSize( 290, 517 )

	local bones = GearTree:AddNode("Bones")
	local node
	local node2
	for _, bone in pairs( BoneList ) do
		node = bones:AddNode( bone )
		if CAKE.Gear and CAKE.Gear[ string.lower( bone ) ] then
			for __, tbl in pairs( CAKE.Gear[ string.lower( bone ) ] ) do
				node2 = node:AddNode( tbl.item )
				node2.DoClick = function()
					HandleGearEditing( tbl.entity, tbl.item, string.lower( bone ) )
				end
			end
		end
		node2 = node:AddNode( "Create New Gear..." )
		node2.DoClick = function()
			HandleGearEditing( false, string.lower( bone ) )
		end
	end

	GearList:AddItem( GearTree )

end

function StartGearEditor( entity, item, bone, offset, angle, scale, skin )

	CloseGear()

	EditorFrame = vgui.Create( "DFrameTransparent" ) -- Creates the frame itself
	EditorFrame:Center() -- Position on the players screen
	EditorFrame:SetSize( 300, 300 ) -- Size of the frame
	EditorFrame:SetDeleteOnClose( true )
	EditorFrame:SetTitle( "Editing gear in bone " .. bone ) -- Title of the frame
	EditorFrame:SetVisible( true )
	EditorFrame:SetDraggable( true ) -- Draggable by mouse?
	EditorFrame:ShowCloseButton( true ) -- Show the close button?
	EditorFrame:MakePopup() -- Show the frame

	local PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent( EditorFrame )
	PropertySheet:SetPos( 5, 28 )
	PropertySheet:SetSize( 290, 267 )

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
		RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", "none", "none", "none", value )
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
		RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", "none", "none", tostring( val ))
	end
	EditList:AddItem( skinnumber )
	
	local removebutton = vgui.Create( "DButton" )
	removebutton:SetSize( 100, 30 )
	removebutton:SetText( "Remove Gear" )
	removebutton.DoClick = function( button )
		RunConsoleCommand( "rp_removegear", entity:EntIndex() )
		EditorFrame:Remove()
		EditorFrame = nil
	end
	EditList:AddItem( removebutton )
	
	PropertySheet:AddSheet( "General", EditList, "gui/silkicons/group", false, false, "Edit general settings");

	local PosList = vgui.Create( "DPanelList" )
	PosList:SetPos( 25,25 )
	PosList:SetSize( 175, 375 )
	PosList:SetSpacing( 10 ) -- Spacing between items
	PosList:EnableHorizontal( false ) -- Only vertical items
	PosList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis

	local xslider = vgui.Create( "DNumSlider" )
	xslider:SetText( "X Position" )
	xslider:SetValue( offset.x )
	xslider:SetMinMax( -40, 40 )
	xslider.ValueChanged = function(self, value)
		if  ValidEntity( entity ) then
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), tostring( value ) .. "," .. tostring( entity:GetDTVector( 1 ).y ) .. "," .. tostring( entity:GetDTVector( 1 ).z ) )
		end
	end
	PosList:AddItem( xslider )

	local yslider = vgui.Create( "DNumSlider" )
	yslider:SetText( "Y Position" )
	yslider:SetValue( offset.y )
	yslider:SetMinMax( -40, 40 )
	yslider.ValueChanged = function(self, value)
		if  ValidEntity( entity ) then
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), tostring( entity:GetDTVector( 1 ).x ) .. "," .. tostring( value ) .. "," .. tostring( entity:GetDTVector( 1 ).z ) )
		end
	end
	PosList:AddItem( yslider )

	local zslider = vgui.Create( "DNumSlider" )
	zslider:SetText( "Z Position" )
	zslider:SetMinMax( -40, 40 )
	zslider:SetValue( offset.z )
	zslider.ValueChanged = function(self, value)
		if  ValidEntity( entity ) then
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), tostring( entity:GetDTVector( 1 ).x ) .. "," .. tostring( entity:GetDTVector( 1 ).z ) .. "," .. tostring( value ) )
		end
	end
	PosList:AddItem( zslider )

	local setbutton = vgui.Create( "DButton" )
	setbutton:SetText( "Set Coordinates" )
	setbutton.DoClick = function( button )
		RunConsoleCommand( "rp_editgear", entity:EntIndex(), tostring( xslider:GetValue() ) .. "," .. tostring( yslider:GetValue() ) .. "," .. tostring( zslider:GetValue() ) )
	end
	PosList:AddItem( setbutton )
	
	local resetbutton = vgui.Create( "DButton" )
	resetbutton:SetText( "Reset Coordinates" )
	resetbutton.DoClick = function( button )
		RunConsoleCommand( "rp_editgear", entity:EntIndex(), "0,0,0" )
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
	pslider:SetValue( angle.p )
	pslider:SetMinMax( -180, 180 ) 
	pslider.ValueChanged = function(self, value)
		if ValidEntity( entity ) then
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none" ,tostring( value ).. "," ..tostring( entity:GetDTAngle( 1 ).y ) .. "," .. tostring( entity:GetDTAngle( 1 ).r ) )
		end
	end
	AngList:AddItem( pslider )

	local yslider = vgui.Create( "DNumSlider" )
	yslider:SetText( "Yaw" )
	yslider:SetValue( angle.y )
	yslider:SetMinMax( -180, 180 )
	yslider.ValueChanged = function(self, value)
		if ValidEntity( entity ) then
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none" , tostring( entity:GetDTAngle( 1 ).p ).. "," .. tostring( value ) .. "," .. tostring( entity:GetDTAngle( 1 ).r ) )
		end
	end
	AngList:AddItem( yslider )

	local rslider = vgui.Create( "DNumSlider" )
	rslider:SetText( "Roll" )
	rslider:SetValue( angle.r )
	rslider:SetMinMax( -180, 180 )
	rslider.ValueChanged = function(self, value)
		if ValidEntity( entity ) then
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none" , tostring( entity:GetDTAngle( 1 ).p ).. "," .. tostring( entity:GetDTAngle( 1 ).y ) .. "," .. tostring( value ) )
		end
	end
	AngList:AddItem( rslider )

	local setbutton = vgui.Create( "DButton" )
	setbutton:SetText( "Set Angles" )
	setbutton.DoClick = function( button )
		RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", tostring( pslider:GetValue() ) .. "," .. tostring( yslider:GetValue() ) .. "," .. tostring( rslider:GetValue() ) )
	end
	AngList:AddItem( setbutton )
	
	local resetbutton = vgui.Create( "DButton" )
	resetbutton:SetText( "Reset Angles" )
	resetbutton.DoClick = function( button )
		RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "0,0,0" )
	end
	AngList:AddItem( resetbutton )

	PropertySheet:AddSheet( "Angles", AngList, "gui/silkicons/application_view_detail", false, false, "Edit gear's angles");

	local ScaleList = vgui.Create( "DPanelList" )
	ScaleList:SetPos( 25,25 )
	ScaleList:SetSize( 175, 375 )
	ScaleList:SetSpacing( 10 ) -- Spacing between items
	ScaleList:EnableHorizontal( false ) -- Only vertical items
	ScaleList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
	
	local xslider = vgui.Create( "DNumSlider" )
	xslider:SetValue( scale.x )
	xslider:SetText( "X Scale" )
	xslider:SetMinMax( 0, 10 ) 
	xslider.ValueChanged = function(self, value)
		if ValidEntity( entity ) then
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", tostring( value ) .. "," .. tostring( entity:GetDTVector( 2 ).y ) .. "," .. tostring( entity:GetDTVector( 2 ).z ) )
		end
	end
	ScaleList:AddItem( xslider )

	local yslider = vgui.Create( "DNumSlider" )
	yslider:SetText( "Y Scale" )
	yslider:SetValue( scale.y )
	yslider:SetMinMax( 0, 10 )
	yslider.ValueChanged = function(self, value)
		if ValidEntity( entity ) then
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", tostring( entity:GetDTVector( 2 ).x ) .. "," .. tostring( value ) .. "," .. tostring( entity:GetDTVector( 2 ).z ) )
		end
	end
	ScaleList:AddItem( yslider )

	local zslider = vgui.Create( "DNumSlider" )
	zslider:SetValue( scale.z )
	zslider:SetText( "Z Scale" )
	zslider:SetMinMax( 0, 10 )
	zslider.ValueChanged = function(self, value)
		if ValidEntity( entity ) then
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", tostring( entity:GetDTVector( 2 ).x ) .. "," .. tostring( entity:GetDTVector( 2 ).y ) .. "," .. tostring( value) )
		end
	end
	ScaleList:AddItem( zslider )

	local setbutton = vgui.Create( "DButton" )
	setbutton:SetText( "Set Angles" )
	setbutton.DoClick = function( button )
		RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", tostring( xslider:GetValue() ) .. "," .. tostring( yslider:GetValue() ) .. "," .. tostring( zslider:GetValue() ) )
	end
	ScaleList:AddItem( setbutton )
	
	local resetbutton = vgui.Create( "DButton" )
	resetbutton:SetText( "Reset Coordinates" )
	resetbutton.DoClick = function( button )
		RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", "1,1,1" )
	end
	ScaleList:AddItem( resetbutton )

	PropertySheet:AddSheet( "Scale", ScaleList, "gui/silkicons/magnifier", false, false, "Edit gear's scale");

end

function CloseGear()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Character Editor", EditGear, CloseGear )

usermessage.Hook( "cleargear", function( um )
	CAKE.Gear = {}
end)

usermessage.Hook( "clearclothing", function( um )
	CAKE.ClothingTbl = {}
end)


usermessage.Hook( "addgear", function( um )

	local entity = ents.GetByIndex( um:ReadShort() )
	local item = um:ReadString()
	local bone = um:ReadString()

	if CAKE.Gear and !CAKE.Gear[ bone ] then
		CAKE.Gear[ bone ] = {}
	end

	local tbl = {}
	tbl.item = item
	tbl.entity = entity

	table.insert( CAKE.Gear[ bone ], tbl )

end)

usermessage.Hook( "addclothing", function( um )

	local entity = ents.GetByIndex( um:ReadShort() )

	table.insert( CAKE.ClothingTbl, entity )

end)

usermessage.Hook( "editgear", function( um )
	
	local ent = ents.GetByIndex( um:ReadShort() )

	StartGearEditor( ent, um:ReadString(), um:ReadString(), ent:GetDTVector( 1 ), ent:GetDTAngle( 1 ), ent:GetDTVector( 2 ), ent:GetSkin() )

end)


function CLPLUGIN.Init()

end
