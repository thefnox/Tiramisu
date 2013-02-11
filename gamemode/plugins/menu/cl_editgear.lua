CAKE.Gear = {}
CAKE.WornItems = {}
CAKE.Clothing = "none"
CAKE.Helmet = "none"
CAKE.ClothingID = "none"
CAKE.HelmetID = "none"

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

local RealBoneList = {
	["pelvis"			] = "ValveBiped.Bip01_Pelvis"		,
	["stomach"			] = "ValveBiped.Bip01_Spine"		,
	["lower back"		] = "ValveBiped.Bip01_Spine1"		,
	["chest"			] = "ValveBiped.Bip01_Spine2"		,
	["upper back"		] = "ValveBiped.Bip01_Spine4"		,
	["neck"				] = "ValveBiped.Bip01_Neck1"		,
	["head"				] = "ValveBiped.Bip01_Head1"		,
	["right clavicle"	] = "ValveBiped.Bip01_R_Clavicle"	,
	["right upper arm"	] = "ValveBiped.Bip01_R_UpperArm"	,
	["right forearm"	] = "ValveBiped.Bip01_R_Forearm"	,
	["right hand"		] = "ValveBiped.Bip01_R_Hand"		,
	["left clavicle"	] = "ValveBiped.Bip01_L_Clavicle"	,
	["left upper arm"	] = "ValveBiped.Bip01_L_UpperArm"	,
	["left forearm"		] = "ValveBiped.Bip01_L_Forearm"	,
	["left hand"		] = "ValveBiped.Bip01_L_Hand"		,
	["right thigh"		] = "ValveBiped.Bip01_R_Thigh"		,
	["right calf"		] = "ValveBiped.Bip01_R_Calf"		,
	["right foot"		] = "ValveBiped.Bip01_R_Foot"		,
	["right toe"		] = "ValveBiped.Bip01_R_Toe0"		,
	["left thigh"		] = "ValveBiped.Bip01_L_Thigh"		,
	["left calf"		] = "ValveBiped.Bip01_L_Calf"		,
	["left foot"		] = "ValveBiped.Bip01_L_Foot"		,
	["left toe"			] = "ValveBiped.Bip01_L_Toe0"		
}

local function FetchWornItems()
	CAKE.WornItems = {}

	for _, bone in pairs(CAKE.Gear) do
		for k, v in pairs( bone ) do
			if v.itemid and v.itemid != "none" then
				table.insert( CAKE.WornItems, v.itemid )
			end
		end
	end

	for _, ent in pairs(CAKE.ClothingTbl) do
		if ent then
			if ent.itemid and ent.itemid != "none" then
				table.insert( CAKE.WornItems, ent.itemid )
			end
		end
	end

end

function RefreshGearTree()
	if GearTree then
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
							StartGearEditor( tbl.entity, tbl.item, bone, tbl.entity:GetDTVector( 1 ), tbl.entity:GetDTAngle( 1 ), tbl.entity:GetDTVector( 2 ), tbl.entity:GetSkin(), tbl.name )
						end
					end
				end
			end
		end
	end
end


function EditGear()

	CAKE.EnableBlackScreen( true )

	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( ScrW(), ScrH() )
	PlayerMenu:Center()
	PlayerMenu:SetDraggable( false )
	PlayerMenu:ShowCloseButton( false )
	PlayerMenu:SetTitle( "" )
	PlayerMenu.Paint = function()

		CAKE.DrawBlurScreen()

	end
	PlayerMenu:MakePopup()

	PlayerModel = vgui.Create( "PlayerPanel", PlayerMenu )
	PlayerModel:SetSize( ScrH(), ScrH())
	PlayerModel:SetPos( ScrW() - ScrH(), 23 )


	local title = Label( "Character Editor", PlayerMenu)
	title:SetFont( "Tiramisu48Font")
	title:SetPos( 10, 23 )
	title:SizeToContents()
	local subtitle = Label( "Customize your character", PlayerMenu)
	subtitle:SetPos( 10, 66 )
	subtitle:SetFont( "Tiramisu24Font")
	subtitle:SizeToContents()

	EditMenu = vgui.Create( "DFrame", PlayerMenu )
	EditMenu:Dock( LEFT )
	EditMenu:DockMargin( 10, 70, 10, 10 )
	EditMenu:SetWide( 300 )
	EditMenu:ShowCloseButton( false )
	EditMenu:SetTitle( "Character Editor" )

	local PropertySheet = vgui.Create( "DPropertySheet", EditMenu )
	PropertySheet:Dock( FILL )
	PropertySheet:SetPos( 5, 28 )

	local ClothingList = vgui.Create( "DPanelList" )
	ClothingList:SetSpacing( 3 )
	ClothingList:SetPadding( 3 )
	ClothingList:EnableVerticalScrollbar( true )
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
	if CAKE.Containers[CAKE.Inventory] then
		for _, tbl in pairs( CAKE.Containers[CAKE.Inventory].Items ) do
			for k, v in pairs(tbl) do
				if( v.class and string.match( v.class, "clothing" ) ) then
					button = vgui.Create( "SpawnIcon" )
					button:SetSize(64, 64);
					button:InvalidateLayout( true ); 
					button:SetModel( CAKE.ItemData[v.class].Model )
					button:SetToolTip(CAKE.ItemData[v.class].Description)
					button.DoClick = function()
						CAKE.Clothing = v.class
						CAKE.ClothingID = v.itemid
						RunConsoleCommand("rp_setclothing", CAKE.Clothing, CAKE.Helmet, CAKE.ClothingID, CAKE.HelmetID)
					end
					clist:AddItem( button )
				end
			end
		end
	end

	button = vgui.Create( "SpawnIcon" )
	-- button:SetIconSize( 64 )
	button:SetModel( LocalPlayer():GetNWString("model","models/kleiner.mdl") )
	button:SetToolTip( "Your default clothes" )
	button.DoClick = function()
		CAKE.Clothing = "none"
		CAKE.ClothingID = "none"
		RunConsoleCommand("rp_setclothing", CAKE.Clothing, CAKE.Helmet, CAKE.ClothingID, CAKE.HelmetID)
	end
	clist:AddItem( button )

	local HelmetCategory = vgui.Create("DCollapsibleCategory")
	HelmetCategory:SetExpanded( 1 ) -- Expanded when popped up
	HelmetCategory:SetLabel( "Helmets/Heads" )
	ClothingList:AddItem( HelmetCategory )

	local hlist = vgui.Create( "DPanelList" )
	hlist:SetAutoSize( true )
	hlist:SetSpacing( 5 )
	hlist:SetPadding( 3 )
	hlist:EnableHorizontal( true )
	hlist:EnableVerticalScrollbar( true )
	HelmetCategory:SetContents( hlist )

	for _, tbl in pairs( CAKE.Containers[CAKE.Inventory].Items ) do
		for k, v in pairs(tbl) do
			if( v.class and string.match( v.class, "helmet" ) ) then
				button = vgui.Create( "SpawnIcon" )
				button:SetSize(64, 64);
				button:InvalidateLayout( true ); 
				button:SetModel( CAKE.ItemData[v.class].Model )
				button:SetToolTip(CAKE.ItemData[v.class].Description)
				button.DoClick = function()
					CAKE.Helmet = v.class
					CAKE.HelmetID = v.itemid
					RunConsoleCommand("rp_setclothing", CAKE.Clothing, CAKE.Helmet, CAKE.ClothingID, CAKE.HelmetID)
				end
				hlist:AddItem( button )
			end
		end
	end
	button = vgui.Create( "SpawnIcon" )
	-- button:SetIconSize( 64 )
	button:SetModel( LocalPlayer():GetNWString("model","models/kleiner.mdl") )
	button:SetToolTip( "Your default head" )
	button.DoClick = function()
		CAKE.Helmet = "none"
		CAKE.HelmetID = "none"
		RunConsoleCommand("rp_setclothing", CAKE.Clothing, CAKE.Helmet, CAKE.ClothingID, CAKE.HelmetID)
	end
	hlist:AddItem( button )

	local entity = CAKE.ClothingTbl

	local headslider, bodyslider, handslider
	if CAKE.ConVars[ "AllowRescaling" ] then
		headslider = vgui.Create( "DNumSlider" )
		headslider:SetText( "Head Scale" )
		if CAKE.ClothingTbl then
			for _,entity in pairs( CAKE.ClothingTbl ) do
				if IsValid( entity ) then
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
					if IsValid( entity ) then
						entity:SetDTFloat( 1, value )
					end
				end
			end
		end
		ClothingList:AddItem( headslider )

		bodyslider = vgui.Create( "DNumSlider" )
		bodyslider:SetText( "Body Scale" )
		if CAKE.ClothingTbl then
			for _,entity in pairs( CAKE.ClothingTbl ) do
				if IsValid( entity ) then
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
					if IsValid( entity ) then
						entity:SetDTFloat( 2, value )
					end
				end
			end
		end
		ClothingList:AddItem( bodyslider )

		handslider = vgui.Create( "DNumSlider" )
		handslider:SetText( "Hands Scale" )
		if CAKE.ClothingTbl then
			for _,entity in pairs( CAKE.ClothingTbl ) do
				if IsValid( entity ) then
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
					if IsValid( entity ) then
						entity:SetDTFloat( 3, value )
					end
				end
			end
		end
		ClothingList:AddItem( handslider )
	end

	local bodygroup1, bodygroup2, bodygroup3, plyskin
	if CAKE.ConVars[ "AllowBodygroups" ] then

		local ent = false
		if CAKE.ClothingTbl then
			for _,entity in pairs( CAKE.ClothingTbl ) do
				if IsValid( entity ) and entity:GetModel() == LocalPlayer():GetNWString("model","models/kleiner.mdl") then
					ent = entity
				end
			end
		end

		bodygroup1 = vgui.Create( "DNumSlider" )
		bodygroup1:SetText( "Bodygroup 1" )
		if IsValid( ent ) then
			bodygroup1:SetValue( ent:GetBodygroup(1))
		end
		bodygroup1:SetMinMax( 0, 10 )
		bodygroup1:SetDecimals( 0 )
		bodygroup1.ValueChanged = function(self, value)
			if CAKE.ClothingTbl then
				for _,entity in pairs( CAKE.ClothingTbl ) do
					if IsValid( entity ) and entity:GetModel() == LocalPlayer():GetNWString("model","models/kleiner.mdl") then
						entity:SetBodygroup( 1, value )
					end
				end
			end
		end
		ClothingList:AddItem( bodygroup1 )

		bodygroup2 = vgui.Create( "DNumSlider" )
		bodygroup2:SetText( "Bodygroup 2" )
		bodygroup2:SetMinMax( 0, 10 )
		if IsValid( ent ) then
			bodygroup2:SetValue( ent:GetBodygroup(2))
		end
		bodygroup2:SetDecimals( 0 )
		bodygroup2.ValueChanged = function(self, value)
			if CAKE.ClothingTbl then
				for _,entity in pairs( CAKE.ClothingTbl ) do
					if IsValid( entity ) and entity:GetModel() == LocalPlayer():GetNWString("model","models/kleiner.mdl") then
						entity:SetBodygroup( 2, value )
					end
				end
			end
		end
		ClothingList:AddItem( bodygroup2 )

		bodygroup3 = vgui.Create( "DNumSlider" )
		bodygroup3:SetText( "Bodygroup 3" )
		bodygroup3:SetMinMax( 0, 10 )
		if IsValid( ent ) then
			bodygroup3:SetValue( ent:GetBodygroup(3))
		end
		bodygroup3:SetDecimals( 0 )
		bodygroup3.ValueChanged = function(self, value)
			if CAKE.ClothingTbl then
				for _,entity in pairs( CAKE.ClothingTbl ) do
					if IsValid( entity ) and entity:GetModel() == LocalPlayer():GetNWString("model","models/kleiner.mdl") then
						entity:SetBodygroup( 3, value )
					end
				end
			end
		end
		ClothingList:AddItem( bodygroup3 )

		if IsValid( ent ) and ent:SkinCount() > 1 then
			plyskin = vgui.Create( "DNumSlider" )
			plyskin:SetText( "Player Skin" )
			plyskin:SetValue( ent:GetSkin() )
			plyskin:SetMinMax( 0, ent:SkinCount() )
			plyskin:SetDecimals( 0 )
			plyskin.ValueChanged = function(self, value)
				if CAKE.ClothingTbl then
					for _,entity in pairs( CAKE.ClothingTbl ) do
						if IsValid( entity ) and entity:GetModel() == LocalPlayer():GetNWString("model","models/kleiner.mdl") then
							entity:SetSkin( value )
						end
					end
				end
			end
			ClothingList:AddItem( plyskin )
		end
	end


	GearTree = vgui.Create( "DTree" )
	GearTree:SetPadding( 5 )
	PropertySheet:AddSheet( "Gear/Accessories", GearTree, "gui/silkicons/wrench", false, false, "Edit your gear" )

	RefreshGearTree()

	local x, y 
	local closelabel = vgui.Create( "DButton", PlayerMenu )
	closelabel:SetSize( 80, 26 )
	closelabel:SetText( "" )
	closelabel:SetPos( (ScrW() / 2 )- 60, ScrH() + 500  )
	closelabel.Paint = function() end
	closelabel.PaintOver = function()
		draw.SimpleText( "Close Menu", "Tiramisu18Font", 40, 0, Color(255,255,255), TEXT_ALIGN_CENTER )
		x,y = closelabel:GetPos()
		closelabel:SetPos( (ScrW() / 2 )- 40, Lerp( 0.1, y, ScrH() / 2 + 230 ))
	end
	closelabel.DoClick = function()
		PlayerModel:Close()
		if CAKE.ConVars[ "AllowRescaling" ] then
			RunConsoleCommand( "rp_scaleclothing", tostring(headslider:GetValue()), tostring(bodyslider:GetValue()), tostring(handslider:GetValue()))
		end
		if CAKE.ConVars[ "AllowBodygroups" ] then
			if plyskin then
				RunConsoleCommand( "rp_setplayerskin", tostring(plyskin:GetValue()))
			end
			RunConsoleCommand( "rp_bodygroupsclothing", tostring(bodygroup1:GetValue()),tostring(bodygroup2:GetValue()),tostring(bodygroup3:GetValue()))
		end
		CloseGear()
	end

end

function StartGearEditor( entity, item, bone, offset, angle, scale, skin, name, itemid )
	local bod1, bod2, bod3 = entity:GetBodygroup( 1 ), entity:GetBodygroup( 2 ), entity:GetBodygroup( 3 )
	if PlayerMenu then
		if PlayerModel then
			PlayerModel:SetTargetBone(RealBoneList[string.lower(bone)])
		end
		if EditorFrame then
			EditorFrame:Remove()
			EditorFrame = nil
		end
		EditorFrame = vgui.Create( "DFrame", PlayerMenu )
		EditorFrame:SetSize( 250, 230 )
		EditorFrame:SetDeleteOnClose( true )
		EditorFrame:SetTitle( "Editing gear in bone " .. bone )
		EditorFrame:SetVisible( true )
		EditorFrame:SetSizable( true )
		EditorFrame:SetDraggable( true )
		EditorFrame:ShowCloseButton( true )
		EditorFrame:SetPos( 310 , ScrH()/2 - EditorFrame:GetTall()/2 )

		local PropertySheet = vgui.Create( "DPropertySheet", EditorFrame )
		PropertySheet:Dock( FILL )

		local EditList = vgui.Create( "DPanelList" )
		EditList:SetPadding( 3 )
		EditList:SetSpacing( 3 )
		EditList:EnableHorizontal( false )
		EditList:EnableVerticalScrollbar( false )
		
		local itemlabel = vgui.Create( "DLabel" )
		itemlabel:SetText( "Name:" )
		EditList:AddItem( itemlabel )
		
		local itemname = vgui.Create( "DTextEntry" )
		itemname:SetValue( name or "-None-" )
		itemname:SetTextColor( Color(255, 255, 255, 255) )
		itemname:SetDrawBackground( false )
		itemname.OnEnter = function()
			LocalPlayer():ConCommand( "rp_renameitem \"" .. itemid .. "\" \"" .. itemname:GetValue() .. "\"" )
		end

		EditList:AddItem( itemname )
		
		local skinlabel = vgui.Create( "DLabel" )
		skinlabel:SetText( "Skin:" )
		EditList:AddItem( skinlabel )
		
		local skinnumber = vgui.Create( "DNumberWang" )
		skinnumber:SetMax( entity:SkinCount() or 20 )
		skinnumber:SetMin( 0 )
		skinnumber:SetDecimals( 0 )
		function skinnumber:OnValueChanged( val )
			if IsValid( entity ) then
				entity:SetSkin( val )
			end
		end
		skinnumber:SetValue( skin )
		EditList:AddItem( skinnumber )

		EditList:AddItem( Label( "Bodygroup 1:") )
		local bodygroup1 = vgui.Create( "DNumberWang" )
		bodygroup1:SetMax( 10 )
		bodygroup1:SetMin( 1 )
		bodygroup1:SetValue( entity:GetBodygroup(1) )
		bodygroup1:SetDecimals( 0 )
		function bodygroup1:OnValueChanged( val )
			if IsValid( entity ) then
				entity:SetBodygroup( 1, val )
			end
		end
		bodygroup1:SetValue( skin )
		EditList:AddItem( bodygroup1 )

		EditList:AddItem( Label( "Bodygroup 2:") )
		local bodygroup2 = vgui.Create( "DNumberWang" )
		bodygroup2:SetMax( 10 )
		bodygroup2:SetMin( 1 )
		bodygroup2:SetValue( entity:GetBodygroup(2) )
		bodygroup2:SetDecimals( 0 )
		function bodygroup2:OnValueChanged( val )
			if IsValid( entity ) then
				entity:SetBodygroup( 2, val )
			end
		end
		EditList:AddItem( bodygroup2 )

		EditList:AddItem( Label( "Bodygroup 3:") )
		local bodygroup3 = vgui.Create( "DNumberWang" )
		bodygroup3:SetMax( 10 )
		bodygroup3:SetMin( 1 )
		bodygroup3:SetValue( entity:GetBodygroup(3) )
		bodygroup3:SetDecimals( 0 )
		function bodygroup3:OnValueChanged( val )
			if IsValid( entity ) then
				entity:SetBodygroup( 3, val )
			end
		end
		EditList:AddItem( bodygroup3 )
		
		PropertySheet:AddSheet( "General", EditList, "gui/silkicons/group", false, false, "Edit general settings")

		local PosList = vgui.Create( "DPanelList" )
		PosList:SetPadding( 3 )
		PosList:SetSpacing( 10 ) -- Spacing between items
		PosList:EnableHorizontal( false ) -- Only vertical items
		PosList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis

		local xslider = vgui.Create( "DNumSlider" )
		xslider:SetText( "X Position" )
		xslider:SetValue( offset.x )
		xslider:SetMinMax( -20, 20 )
		xslider.ValueChanged = function(self, value)
			if IsValid( entity ) then
				entity:SetDTVector( 1, Vector( value, entity:GetDTVector( 1 ).y, entity:GetDTVector( 1 ).z ))
			end
		end
		PosList:AddItem( xslider )

		local yslider = vgui.Create( "DNumSlider" )
		yslider:SetText( "Y Position" )
		yslider:SetValue( offset.y )
		yslider:SetMinMax( -20, 20 )
		yslider.ValueChanged = function(self, value)
			if IsValid( entity ) then
				entity:SetDTVector( 1, Vector( entity:GetDTVector( 1 ).x, value, entity:GetDTVector( 1 ).z ))
			end
		end
		PosList:AddItem( yslider )

		local zslider = vgui.Create( "DNumSlider" )
		zslider:SetText( "Z Position" )
		zslider:SetMinMax( -20, 20 )
		zslider:SetValue( offset.z )
		zslider.ValueChanged = function(self, value)
			if IsValid( entity ) then
				entity:SetDTVector( 1, Vector( entity:GetDTVector( 1 ).x, entity:GetDTVector( 1 ).y, value ))
			end
		end
		PosList:AddItem( zslider )

		local resetbutton = vgui.Create( "DButton" )
		resetbutton:SetText( "Reset Offset Coordinates" )
		resetbutton.DoClick = function( button )
			xslider:SetValue( offset.x )
			yslider:SetValue( offset.y )
			zslider:SetValue( offset.z )
			entity:SetDTVector( 1, offset )
		end
		PosList:AddItem( resetbutton )
		
		PropertySheet:AddSheet( "Position", PosList, "gui/silkicons/anchor", false, false, "Edit gear's position")

		local AngList = vgui.Create( "DPanelList" )
		AngList:SetPadding( 3 )
		AngList:SetSpacing( 10 ) -- Spacing between items
		AngList:EnableHorizontal( false ) -- Only vertical items
		AngList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
		
		local pitchslider = vgui.Create( "DNumSlider" )
		pitchslider:SetText( "Pitch" )
		pitchslider:SetValue( angle.p )
		pitchslider:SetMinMax( 0, 360 )
		pitchslider:SetDecimals( 0 )
		pitchslider.ValueChanged = function(self, value)
			if IsValid( entity ) then
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
			if IsValid( entity ) then
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
			if IsValid( entity ) then
				entity:SetDTAngle( 1, Angle( entity:GetDTAngle( 1 ).p, entity:GetDTAngle( 1 ).y, value ))
			end
		end
		AngList:AddItem( rollslider )

		local resetbutton = vgui.Create( "DButton" )
		resetbutton:SetText( "Reset Angles" )
		resetbutton.DoClick = function( button )
			pitchslider:SetValue( angle.p )
			yawslider:SetValue( angle.y )
			rollslider:SetValue( angle.r )
			entity:SetDTAngle( 1, angle )
		end
		AngList:AddItem( resetbutton )

		PropertySheet:AddSheet( "Angles", AngList, "gui/silkicons/application_view_detail", false, false, "Edit gear's angles")

		local ScaleList = vgui.Create( "DPanelList" )
		ScaleList:SetPadding( 3 )
		ScaleList:SetSpacing( 10 ) -- Spacing between items
		ScaleList:EnableHorizontal( false ) -- Only vertical items
		ScaleList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
		
		local xscale = vgui.Create( "DNumSlider" )
		xscale:SetValue( scale.x )
		xscale:SetText( "X Scale" )
		xscale:SetMinMax( 0, 3 ) 
		xscale.ValueChanged = function(self, value)
			if IsValid( entity ) then
				entity:SetDTVector( 2, Vector( value, entity:GetDTVector(2).y, entity:GetDTVector(2).z ))
			end
		end
		ScaleList:AddItem( xscale )

		local yscale = vgui.Create( "DNumSlider" )
		yscale:SetText( "Y Scale" )
		yscale:SetValue( scale.y )
		yscale:SetMinMax( 0, 3 )
		yscale.ValueChanged = function(self, value)
			if IsValid( entity ) then
				entity:SetDTVector( 2, Vector( entity:GetDTVector(2).x, value, entity:GetDTVector(2).z ))
			end
		end
		ScaleList:AddItem( yscale )

		local zscale = vgui.Create( "DNumSlider" )
		zscale:SetValue( scale.z )
		zscale:SetText( "Z Scale" )
		zscale:SetMinMax( 0, 3 )
		zscale.ValueChanged = function(self, value)
			if IsValid( entity ) then
				entity:SetDTVector( 2, Vector( entity:GetDTVector(2).x, entity:GetDTVector(2).y, value ))
			end
		end
		ScaleList:AddItem( zscale )

		local resetbutton = vgui.Create( "DButton" )
		resetbutton:SetText( "Reset Coordinates" )
		resetbutton.DoClick = function( button )
			entity:SetDTVector( 2, scale )
			xscale:SetValue( scale.x )
			yscale:SetValue( scale.y )
			zscale:SetValue( scale.z )
		end
		ScaleList:AddItem( resetbutton )
		PropertySheet:AddSheet( "Scale", ScaleList, "gui/silkicons/magnifier", false, false, "Edit gear's scale")

		EditorFrame.Close = function()
			CAKE.Query( "Save Changes for " .. itemname:GetValue(), "Save",
			"Yes", function()
				--[[datastream.StreamToServer( "Tiramisu.GetEditGear", {
					["entity"] = entity,
					["offset"] = Vector(xslider:GetValue(), yslider:GetValue(), zslider:GetValue()),
					["scale"] = Vector(xscale:GetValue(), yscale:GetValue(), zscale:GetValue()),
					["angle"] = Angle(pitchslider:GetValue(), yawslider:GetValue(), rollslider:GetValue()),
					["skin"] = skinnumber:GetValue(),
					["name"] = itemname:GetValue(),
					["bodygroup1"] = bodygroup1:GetValue(),
					["bodygroup2"] = bodygroup2:GetValue(),
					["bodygroup3"] = bodygroup3:GetValue()
				})]]--
				net.Start( "Tiramisu.GetEditGear" )
					net.WriteTable({
						["entity"] = entity,
						["offset"] = Vector(xslider:GetValue(), yslider:GetValue(), zslider:GetValue()),
						["scale"] = Vector(xscale:GetValue(), yscale:GetValue(), zscale:GetValue()),
						["angle"] = Angle(pitchslider:GetValue(), yawslider:GetValue(), rollslider:GetValue()),
						["skin"] = skinnumber:GetValue(),
						["name"] = itemname:GetValue(),
						["bodygroup1"] = bodygroup1:GetValue(),
						["bodygroup2"] = bodygroup2:GetValue(),
						["bodygroup3"] = bodygroup3:GetValue()
					})
				net.SendToServer()
				PlayerModel:SetTargetBone("ValveBiped.Bip01_Head1")
				EditorFrame:SetVisible( false )
				EditorFrame:Remove()
				RefreshGearTree()
			end,
			"No", function()
				entity:SetDTVector( 1, offset )
				entity:SetDTAngle( 1, angle )
				entity:SetDTVector( 2, scale )
				entity:SetSkin( skin )
				entity:SetBodygroup(1, bod1)
				entity:SetBodygroup(2, bod2)
				entity:SetBodygroup(3, bod3)
				PlayerModel:SetTargetBone("ValveBiped.Bip01_Head1")
				EditorFrame:SetVisible( false )
				EditorFrame:Remove()
			end)
		end

	end
end

function CloseGear()
	CAKE.EnableBlackScreen( false )
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
			if IsValid( v ) then
				v:SetNoDraw( false )
			end
		end
	end

	if CAKE.Gear then
		for _, bone in pairs( CAKE.Gear ) do
			if bone then
				for k, v in pairs( bone ) do
					if IsValid( v.entity ) then
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
	FetchWornItems()
end)

usermessage.Hook( "clearclothing", function( um )
	CAKE.ClothingTbl = {}
	CAKE.Helmet = "none"
	CAKE.Clothing = "none"
end)


usermessage.Hook( "addgear", function( um )

	local entity = ents.GetByIndex( um:ReadShort() )
	local item = um:ReadString()
	local bone = um:ReadString()
	local name = um:ReadString()
	local itemid = um:ReadString()

	if CAKE.Gear and !CAKE.Gear[ bone ] then
		CAKE.Gear[ bone ] = {}
	end

	local tbl = {}
	tbl.item = item
	tbl.entity = entity
	tbl.name = name
	tbl.itemid = itemid

	table.insert( CAKE.Gear[ bone ], tbl )
	FetchWornItems()

end)

usermessage.Hook( "addclothing", function( um )

	local entity = ents.GetByIndex( um:ReadShort() )
	local item = um:ReadString()
	local itemid = um:ReadString()

	entity.item = item 
	entity.itemid = itemid

	if string.match(item, "helmet_") then
		CAKE.Helmet = item
	end
	if string.match(item, "clothing_") then
		CAKE.Clothing = item
	end

	table.insert( CAKE.ClothingTbl, entity )
	FetchWornItems()

end)

usermessage.Hook( "editgear", function( um )
	
	local ent = ents.GetByIndex( um:ReadShort() )

	StartGearEditor( ent, um:ReadString(), um:ReadString(), ent:GetDTVector( 1 ), ent:GetDTAngle( 1 ), ent:GetDTVector( 2 ), ent:GetSkin(), um:ReadString(), um:ReadString() )

end)
