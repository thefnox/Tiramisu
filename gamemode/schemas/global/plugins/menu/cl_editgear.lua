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

local function HandleGearEditing( entity, bone, item, name )

	if entity and ValidEntity( entity ) then
		StartGearEditor( entity, item, bone, entity:GetDTVector( 1 ), entity:GetDTAngle( 1 ), entity:GetDTVector( 2 ), entity:GetSkin(), name )
	else
		if InventoryTable and #InventoryTable > 0 then
			if frame then
				frame:Remove()
				frame = nil
			end

			local frame = vgui.Create( "DFrame", PlayerMenu )
			frame:SetSize( 360, 423 )
			frame:Center()
			frame:SetTitle( "Choose the item you want to use for your gear" )

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
				    spawnicon:SetToolTip(v.Name)
				    spawnicon.DoClick = function()
				        RunConsoleCommand( "rp_setgear", v.Class, bone, v.ID )
				        frame:Remove()
				        frame = nil

				    end
				    panel:AddItem( spawnicon )
				end
			end
		else
			CAKE.Message( "You don't have any items!", "Error!", "OK" )
		end
	end

end

function EditGear()

	RunConsoleCommand( "rp_thirdperson", 1 )

	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( ScrW(), ScrH() )
	PlayerMenu:Center()
	PlayerMenu:SetDraggable( false )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetTitle( "" )
	PlayerMenu.Paint = function()

		CAKE.DrawBlurScreen()

	end
	PlayerMenu:MakePopup()

	PlayerModel = vgui.Create( "PlayerPanel", PlayerMenu )
	PlayerModel:SetSize( 500, 500 )
	PlayerModel:SetPos( ScrW() / 2 - 150, ScrH() / 2 - 300 )


	EditMenu = vgui.Create( "DFrame", PlayerMenu )
	EditMenu:SetSize( 260, 450 )
	EditMenu:ShowCloseButton( false )
	EditMenu:SetPos( ScrW() / 2 - 370, ScrH() / 2 - 285 )
	EditMenu:SetTitle( "Character Editor" )

	local PropertySheet = vgui.Create( "DPropertySheet", EditMenu )
	PropertySheet:SetPos( 5, 28 )
	PropertySheet:SetSize( 250, 417 )

	local ClothingList = vgui.Create( "DPanelList" )
	ClothingList:SetSize( 300, 432  )
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
	if InventoryTable and #InventoryTable > 0 then
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

	local entity = CAKE.ClothingTbl

	local headslider = vgui.Create( "DNumSlider" )
	headslider:SetText( "Head Scale" )
	if CAKE.ClothingTbl then
		for _,entity in pairs( CAKE.ClothingTbl ) do
			if ValidEntity( entity ) then
				headslider:SetValue( entity:GetDTFloat( 1 ))
				break
			end
		end
	else
		headslider:SetValue( 1 )
	end
	headslider:SetMinMax( 0.5, 1.2 )
	headslider:SetDecimals( 2 )
	headslider.ValueChanged = function(self, value)
		if CAKE.ClothingTbl then
			for _,entity in pairs( CAKE.ClothingTbl ) do
				if ValidEntity( entity ) then
					entity:SetDTFloat( 1, value )
				end
			end
		end
	end
	ClothingList:AddItem( headslider )

	local bodyslider = vgui.Create( "DNumSlider" )
	bodyslider:SetText( "Body Scale" )
	if CAKE.ClothingTbl then
		for _,entity in pairs( CAKE.ClothingTbl ) do
			if ValidEntity( entity ) then
				bodyslider:SetValue( entity:GetDTFloat( 2 ))
				break
			end
		end
	else
		bodyslider:SetValue( 1 )
	end
	bodyslider:SetMinMax( 0.5, 1.2 )
	bodyslider:SetDecimals( 2 )
	bodyslider.ValueChanged = function(self, value)
		if CAKE.ClothingTbl then
			for _,entity in pairs( CAKE.ClothingTbl ) do
				if ValidEntity( entity ) then
					entity:SetDTFloat( 2, value )
				end
			end
		end
	end
	ClothingList:AddItem( bodyslider )

	local handslider = vgui.Create( "DNumSlider" )
	handslider:SetText( "Hands Scale" )
	if CAKE.ClothingTbl then
		for _,entity in pairs( CAKE.ClothingTbl ) do
			if ValidEntity( entity ) then
				handslider:SetValue( entity:GetDTFloat( 3 ))
				break
			end
		end
	else
		handslider:SetValue( 1 )
	end
	handslider:SetMinMax( 0.5, 1.2 )
	handslider:SetDecimals( 2 )
	handslider.ValueChanged = function(self, value)
		if CAKE.ClothingTbl then
			for _,entity in pairs( CAKE.ClothingTbl ) do
				if ValidEntity( entity ) then
					entity:SetDTFloat( 3, value )
				end
			end
		end
	end
	ClothingList:AddItem( handslider )


	GearList = vgui.Create( "DPanelList" )
	GearList:SetSize( 300, 432 )
	PropertySheet:AddSheet( "Gear/Accessories", GearList, "gui/silkicons/wrench", false, false, "Edit your gear" )

	function RefreshGearTree()
		if GearList and GearList:IsValid() then
			if GearTree then
				GearTree:Remove()
				GearTree = nil

			end
			GearTree = vgui.Create( "DTree" )
			GearTree:SetPadding( 5 )
			GearTree:SetSize( 290, 400 )
			GearTree:Clear( true )
			GearTree:Rebuild()
			local bones = GearTree:AddNode("Bones")
			local node
			local node2
			local amount
			for _, bone in pairs( BoneList ) do
				amount = table.Count( CAKE.Gear[ string.lower( bone ) ] or {} )
				if amount > 0 then
					node = bones:AddNode( bone .. " (" .. amount .. " items)"  )
					if CAKE.Gear and CAKE.Gear[ string.lower( bone ) ] then
						for __, tbl in pairs( CAKE.Gear[ string.lower( bone ) ] ) do
							node2 = node:AddNode( tbl.name or tbl.item )
							node2.DoClick = function()
								HandleGearEditing( tbl.entity, tbl.item, string.lower( bone ), tbl.name )
							end
						end
					end
				end
			end
			GearList:AddItem( GearTree )
		end
	end

	RefreshGearTree()

	local x, y 
	local closelabel = vgui.Create( "DButton", PlayerMenu )
	closelabel:SetSize( 80, 26 )
	closelabel:SetText( "" )
	closelabel:SetPos( (ScrW() / 2 )- 60, ScrH() + 500  )
	closelabel.Paint = function() end
	closelabel.PaintOver = function()
		draw.SimpleText( "Close Menu", "TiramisuTimeFont", 40, 0, Color(255,255,255), TEXT_ALIGN_CENTER )
		x,y = closelabel:GetPos()
		closelabel:SetPos( (ScrW() / 2 )- 40, Lerp( 0.1, y, ScrH() / 2 + 230 ))
	end
	closelabel.DoClick = function()
		RunConsoleCommand( "rp_scaleclothing", tostring(headslider:GetValue()), tostring(bodyslider:GetValue()), tostring(handslider:GetValue()))
		PlayerModel:Close()
		CloseGear()
	end

end

function StartGearEditor( entity, item, bone, offset, angle, scale, skin, name )

	if PlayerMenu then
		EditorFrame = vgui.Create( "DFrame", PlayerMenu ) -- Creates the frame itself
		EditorFrame:Center() -- Position on the players screen
		EditorFrame:SetSize( 280, 260 ) -- Size of the frame
		EditorFrame:SetDeleteOnClose( true )
		EditorFrame:SetTitle( "Editing gear in bone " .. bone ) -- Title of the frame
		EditorFrame:SetVisible( true )
		EditorFrame:SetDraggable( true ) -- Draggable by mouse?
		EditorFrame:ShowCloseButton( true ) -- Show the close button?

		local PropertySheet = vgui.Create( "DPropertySheet" )
		PropertySheet:SetParent( EditorFrame )
		PropertySheet:SetPos( 5, 28 )
		PropertySheet:SetSize( EditorFrame:GetWide() - 10, EditorFrame:GetTall() - 33 )

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
		itemlist:SetText( name or "-None-" )
		itemlist:SetPos(2,32)
		itemlist:SetSize( 295, 20 )
		function itemlist:OnSelect(index,value,data)
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", "none", "none", "none", value )
		end
		for k, v in pairs( InventoryTable ) do
			itemlist:AddChoice( v.Name )
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
			if ValidEntity( entity ) then
				entity:SetSkin( val )
			end
		end
		skinnumber:SetValue( skin )
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
		xslider:SetMinMax( -80, 80 )
		xslider.ValueChanged = function(self, value)
			if ValidEntity( entity ) then
				entity:SetDTVector( 1, Vector( value, entity:GetDTVector( 1 ).y, entity:GetDTVector( 1 ).z ))
			end
		end
		PosList:AddItem( xslider )

		local yslider = vgui.Create( "DNumSlider" )
		yslider:SetText( "Y Position" )
		yslider:SetValue( offset.y )
		yslider:SetMinMax( -80, 80 )
		yslider.ValueChanged = function(self, value)
			if ValidEntity( entity ) then
				entity:SetDTVector( 1, Vector( entity:GetDTVector( 1 ).x, value, entity:GetDTVector( 1 ).z ))
			end
		end
		PosList:AddItem( yslider )

		local zslider = vgui.Create( "DNumSlider" )
		zslider:SetText( "Z Position" )
		zslider:SetMinMax( -80, 80 )
		zslider:SetValue( offset.z )
		zslider.ValueChanged = function(self, value)
			if ValidEntity( entity ) then
				entity:SetDTVector( 1, Vector( entity:GetDTVector( 1 ).x, entity:GetDTVector( 1 ).y, value ))
			end
		end
		PosList:AddItem( zslider )

		local setbutton = vgui.Create( "DButton" )
		setbutton:SetText( "Save Offset Coordinates" )
		setbutton.DoClick = function( button )
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), tostring( xslider:GetValue() ) .. "," .. tostring( yslider:GetValue() ) .. "," .. tostring( zslider:GetValue() ) )
		end
		PosList:AddItem( setbutton )
		
		local resetbutton = vgui.Create( "DButton" )
		resetbutton:SetText( "Reset Offset Coordinates" )
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
		
		local pitchslider = vgui.Create( "DNumSlider" )
		pitchslider:SetText( "Pitch" )
		pitchslider:SetValue( angle.p )
		pitchslider:SetMinMax( 0, 360 )
		pitchslider:SetDecimals( 0 )
		pitchslider.ValueChanged = function(self, value)
			if ValidEntity( entity ) then
				entity:SetDTAngle( 1, Angle( value, entity:GetDTAngle( 1 ).y, entity:GetDTAngle( 1 ).r ))
			end
		end
		AngList:AddItem( pitchslider )

		local yawslider = vgui.Create( "DNumSlider" )
		yawslider:SetText( "Yaw" )
		yawslider:SetValue( angle.y )
		yawslider:SetMinMax( 0, 360 )
		yawslider:SetDecimals( 0 )
		yawslider.ValueChanged = function(self, value)
			if ValidEntity( entity ) then
				entity:SetDTAngle( 1, Angle( entity:GetDTAngle( 1 ).p, value, entity:GetDTAngle( 1 ).r ))
			end
		end
		AngList:AddItem( yawslider )

		local rollslider = vgui.Create( "DNumSlider" )
		rollslider:SetText( "Roll" )
		rollslider:SetValue( angle.r )
		rollslider:SetMinMax( 0, 360 )
		rollslider:SetDecimals( 0 )
		rollslider.ValueChanged = function(self, value)
			if ValidEntity( entity ) then
				entity:SetDTAngle( 1, Angle( entity:GetDTAngle( 1 ).p, entity:GetDTAngle( 1 ).y, value ))
			end
		end
		AngList:AddItem( rollslider )

		local setbutton = vgui.Create( "DButton" )
		setbutton:SetText( "Save Angles" )
		setbutton.DoClick = function( button )
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", tostring( pitchslider:GetValue() ) .. "," .. tostring( yawslider:GetValue() ) .. "," .. tostring( rollslider:GetValue() ) )
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
		
		local xscale = vgui.Create( "DNumSlider" )
		xscale:SetValue( scale.x )
		xscale:SetText( "X Scale" )
		xscale:SetMinMax( 0, 10 ) 
		xscale.ValueChanged = function(self, value)
			if ValidEntity( entity ) then
				entity:SetDTVector( 2, Vector( value, entity:GetDTVector(2).y, entity:GetDTVector(2).z ))
			end
		end
		ScaleList:AddItem( xscale )

		local yscale = vgui.Create( "DNumSlider" )
		yscale:SetText( "Y Scale" )
		yscale:SetValue( scale.y )
		yscale:SetMinMax( 0, 10 )
		yscale.ValueChanged = function(self, value)
			if ValidEntity( entity ) then
				entity:SetDTVector( 2, Vector( entity:GetDTVector(2).x, value, entity:GetDTVector(2).z ))
			end
		end
		ScaleList:AddItem( yscale )

		local zscale = vgui.Create( "DNumSlider" )
		zscale:SetValue( scale.z )
		zscale:SetText( "Z Scale" )
		zscale:SetMinMax( 0, 10 )
		zscale.ValueChanged = function(self, value)
			if ValidEntity( entity ) then
				entity:SetDTVector( 2, Vector( entity:GetDTVector(2).x, entity:GetDTVector(2).y, value ))
			end
		end
		ScaleList:AddItem( zscale )

		local setbutton = vgui.Create( "DButton" )
		setbutton:SetText( "Save Scale" )
		setbutton.DoClick = function( button )
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", tostring( xscale:GetValue() ) .. "," .. tostring( yscale:GetValue() ) .. "," .. tostring( zscale:GetValue() ) )
		end
		ScaleList:AddItem( setbutton )
		
		local resetbutton = vgui.Create( "DButton" )
		resetbutton:SetText( "Reset Coordinates" )
		resetbutton.DoClick = function( button )
			RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", "1,1,1" )
		end
		ScaleList:AddItem( resetbutton )
		PropertySheet:AddSheet( "Scale", ScaleList, "gui/silkicons/magnifier", false, false, "Edit gear's scale");

		EditorFrame.Close = function()
			CAKE.Query( "Save Changes for " .. name, "Save",
				"Yes", function()
						local offstr = "\"" .. tostring( xslider:GetValue() ) .. "," .. tostring( yslider:GetValue() ) .. "," .. tostring( zslider:GetValue()) .. "\""
						local angstr = "\"" .. tostring( pitchslider:GetValue() ) .. "," .. tostring( yawslider:GetValue() ) .. "," .. tostring( rollslider:GetValue() ) .. "\""
						local scalestr =  "\"" .. tostring( xscale:GetValue() ) .. "," .. tostring( yscale:GetValue() ) .. "," .. tostring( zscale:GetValue()) .. "\""
						RunConsoleCommand( "rp_editgear", entity:EntIndex(), offsetstr, angstr, scalestr, "\"none\"", "\"" .. tostring( skinnumber:GetValue()) .. "\"" )
						EditorFrame:SetVisible( false )
						EditorFrame:Remove()
					end,
				"No", function()
						RunConsoleCommand( "rp_editgear", entity:EntIndex(), "none", "none", "none", "none", "none" )
						entity:SetDTVector( 1, offset )
						entity:SetDTAngle( 1, angle )
						entity:SetDTVector( 2, scale )
						entity:SetSkin( skin )
						RunConsoleCommand( "rp_editgear", entity:EntIndex(), offset.x .. "," .. offset.y .. "," .. offset.z , angle.p .. "," .. angle.y .. "," .. angle.r, scale.x .. "," .. scale.y .. "," .. scale.z, "none", skin )
						EditorFrame:SetVisible( false )
						EditorFrame:Remove()
					end)
		end

	end
end

function CloseGear()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
	if EditMenu then
		EditMenu:Remove()
		EditMenu = nil
	end
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
end
CAKE.RegisterMenuTab( "Character Editor", EditGear, CloseGear )

usermessage.Hook( "cleargear", function( um )
	CAKE.Gear = {}
	if RefreshGearTree then
		RefreshGearTree()
	end
end)

usermessage.Hook( "clearclothing", function( um )
	CAKE.ClothingTbl = {}
end)


usermessage.Hook( "addgear", function( um )

	local entity = ents.GetByIndex( um:ReadShort() )
	local item = um:ReadString()
	local bone = um:ReadString()
	local name = um:ReadString()

	if CAKE.Gear and !CAKE.Gear[ bone ] then
		CAKE.Gear[ bone ] = {}
	end

	local tbl = {}
	tbl.item = item
	tbl.entity = entity
	tbl.name = name

	table.insert( CAKE.Gear[ bone ], tbl )
	if RefreshGearTree then
		RefreshGearTree()
	end

end)

usermessage.Hook( "addclothing", function( um )

	local entity = ents.GetByIndex( um:ReadShort() )
	local item = um:ReadString()

	entity.item = item 

	table.insert( CAKE.ClothingTbl, entity )

end)

usermessage.Hook( "editgear", function( um )
	
	local ent = ents.GetByIndex( um:ReadShort() )

	StartGearEditor( ent, um:ReadString(), um:ReadString(), ent:GetDTVector( 1 ), ent:GetDTAngle( 1 ), ent:GetDTVector( 2 ), ent:GetSkin(), um:ReadString() )
	if RefreshGearTree then
		RefreshGearTree()
	end

end)

function CLPLUGIN.Init()

end
