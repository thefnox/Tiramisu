CLPLUGIN.Name = "Clothing Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"
local function OpenClothing()
	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Clothing" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	function PlayerMenu:Paint()
	end

	Clothing = vgui.Create( "DPropertySheet", PlayerMenu )
	Clothing:SetSize( 640, 450 )
	Clothing:SetPos( 0, 23 )
	
	ClothingSheet = vgui.Create( "DPanelList" )
	ClothingSheet:SetPadding(0);
	ClothingSheet:SetSpacing(0);
	ClothingSheet:EnableHorizontal(false);
	ClothingSheet:EnableVerticalScrollbar(false)
	
	local desc = ""
	
	ClothingMdlPanel = vgui.Create( "DModelPanel" )
	ClothingMdlPanel:SetSize( 200, 200 )
	if CAKE.Clothing == "none" then
		ClothingMdlPanel:SetModel( LocalPlayer():GetNWString( "model", "models/kleiner.mdl" ) )
	else
		for k, v in pairs( InventoryTable ) do
			if v.Class == CAKE.Clothing then
				ClothingMdlPanel:SetModel( v.Model )
				desc = v.Description
				break
			end
		end
	end
	ClothingMdlPanel:SetAnimSpeed( 0.0 )
	ClothingMdlPanel:SetAnimated( false )
	ClothingMdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	ClothingMdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	ClothingMdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	ClothingMdlPanel:SetCamPos( Vector( 50, 0, 50 ) )
	ClothingMdlPanel:SetLookAt( Vector( 0, 0, 50 ) )
	ClothingMdlPanel:SetFOV( 70 )
	ClothingMdlPanel.PaintOver = function()
		surface.SetTextColor(Color(255,255,255,255));
		surface.SetFont("UiBold");
		surface.SetTextPos( surface.GetTextSize( desc ) , 260 );
		surface.DrawText(desc)
	end
	
	ClothingBox = vgui.Create("DListView");
	ClothingBox:SetMultiSelect( false )
	ClothingBox:SetSize(310,130);
	ClothingBox:AddColumn("Item Name");
	ClothingBox:AddColumn("Item Class");
	ClothingBox:AddLine( "Default Clothes", "none" )
	for k, v in pairs( InventoryTable ) do
		if( string.match( v.Class, "clothing" ) ) then
			ClothingBox:AddLine( v.Name, v.Class )
		end
	end
	ClothingBox.DoDoubleClick = function(parent, index, list)
		if list:GetValue(2) == "none" then
			CAKE.Clothing = "none"
			desc = ""
			LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
			ClothingMdlPanel:SetModel( LocalPlayer():GetNWString( "model", "models/kleiner.mdl" ) )
		else
			for k, v in pairs( InventoryTable ) do
				if v.Class == list:GetValue(2) then
					ClothingMdlPanel:SetModel( v.Model )
					CAKE.Clothing = v.Class
					desc = v.Description
					--LocalPlayer():ConCommand("rp_setclothing " .. TeamTable[LineID].flagkey);
					LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
				end
			end
		end
		
	end
	ClothingSheet:AddItem( ClothingBox )
	ClothingSheet:AddItem( ClothingMdlPanel )
	
	Clothing:AddSheet( "Clothing/Armor", ClothingSheet, "gui/silkicons/user", false, false, "Set your clothes")
	
	HelmetSheet = vgui.Create( "DPanelList" )
	HelmetSheet:SetPadding(0);
	HelmetSheet:SetSpacing(00);
	HelmetSheet:EnableHorizontal(false);
	HelmetSheet:EnableVerticalScrollbar(true);
	
	HelmetMdlPanel = vgui.Create( "DModelPanel" )
	HelmetMdlPanel:SetSize( 250, 250 )
	if CAKE.Clothing == "none" then
		HelmetMdlPanel:SetModel( LocalPlayer():GetNWString( "model", "models/kleiner.mdl" ) )
	else
		for k, v in pairs( InventoryTable ) do
			if v.Class == CAKE.Clothing then
				HelmetMdlPanel:SetModel( v.Model )
				desc = v.Description
				break
			end
		end
	end
	HelmetMdlPanel:SetAnimSpeed( 0.0 )
	HelmetMdlPanel:SetAnimated( false )
	HelmetMdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	HelmetMdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	HelmetMdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	HelmetMdlPanel:SetCamPos( Vector( 50, 0, 60)  )
	HelmetMdlPanel:SetLookAt( Vector( 0, 0, 60 ) )
	HelmetMdlPanel:SetFOV( 40 )
	HelmetMdlPanel.PaintOver = function()
		surface.SetTextColor(Color(255,255,255,255));
		surface.SetFont("UiBold");
		surface.SetTextPos( surface.GetTextSize( desc ) , 260 );
		surface.DrawText(desc)
	end
	
	local Helmets = vgui.Create("DListView");
	Helmets:SetMultiSelect( false )
	Helmets:SetSize(310,130);
	Helmets:AddColumn( "Item Name" )
	Helmets:AddColumn( "Item Class" )
	Helmets:AddLine( "Default Helmet/Face", "none" )
	for k, v in pairs( InventoryTable ) do
		if( string.match( v.Class, "helmet" ) ) then
			Helmets:AddLine( v.Name, v.Class )
		end
	end
	Helmets.DoDoubleClick = function(parent, index, list)
		if list:GetValue(2) == "none" then
			CAKE.Helmet = "none"
			desc = ""
			LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
			HelmetMdlPanel:SetModel( LocalPlayer():GetNWString( "model", "models/kleiner.mdl" ) )
		else
			for k, v in pairs( InventoryTable ) do
				if v.Class == list:GetValue(2) then
					HelmetMdlPanel:SetModel( v.Model )
					CAKE.Helmet = v.Class
					desc = v.Description
					--LocalPlayer():ConCommand("rp_setclothing " .. TeamTable[LineID].flagkey);
					LocalPlayer():ConCommand( "rp_setclothing \"" .. CAKE.Clothing .. "\" \"" .. CAKE.Helmet .. "\"" )
				end
			end
		end
		
	end
	
	HelmetSheet:AddItem( Helmets )
	HelmetSheet:AddItem( HelmetMdlPanel )
	
	Clothing:AddSheet( "Helmets", HelmetSheet, "gui/silkicons/user", false, false, "Set your helmet")
end

local function CloseClothing()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Clothing", OpenClothing, CloseClothing )

function CLPLUGIN.Init()
	
end