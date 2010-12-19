CurrencyTable = {}
CAKE.MenuTabs = {}
CAKE.ActiveTab = nil
CAKE.MenuOpen = false
CAKE.DisplayMenu = false
CAKE.MenuFont = "Base 02"

surface.CreateFont( CAKE.MenuFont, 48, 800, true, false, "BaseTitle" )
surface.CreateFont( CAKE.MenuFont, 32, 800, true, false, "BaseOptions" )

CAKE.Button3d2d = {}

local function CalcModelUsed( x, y )
	local i, f
	local j, k
	x = math.Clamp( math.Round( x / 25 ), 1, 120 )
	y = math.Clamp( math.Round( y / 25 ), 1, 120 )
	y = y * 0.25
	x = x * 0.25
	if y > x then
		i, f = math.modf( x )
		if f == "0" then
			f = ""
		end
		j, k = math.modf( y )
		if k == "0" then
			k = ""
		end
		return "models/hunter/plates/plate" .. tostring( i ) .. tostring( f * 100 ) .. "x" .. tostring( j ) .. tostring( k * 100 ) .. ".mdl", false
	elseif x > y then
		i, f = math.modf( x )
		j, k = math.modf( y )
		if f == "0" then
			f = ""
		end
		if k == "0" then
			k = ""
		end
		return "models/hunter/plates/plate" .. tostring( j ) .. tostring( k * 100 ) .. "x" .. tostring( i ) .. tostring( f * 100 ) .. ".mdl", true
	elseif x == y then
		i, f = math.modf( x )
		if f == "0" then
			f = ""
		end
		return "models/hunter/plates/plate" .. tostring( i ) .. tostring( f * 100 ) .. "x" .. tostring( i ) .. tostring( f * 100 ) .. ".mdl", false
	end
end

function CAKE.Create3d2dButton( pos, angle, x, y, func )
	
	local modelused, turnaround = CalcModelUsed( x, y )
	local ent = ClientsideModel(modelused, RENDERGROUP_TRANSLUCENT)
	ent.ClickFunction = func
	ent.IsA3d2dButton = true
	ent:SetPos( pos )
	if turnaround then
		ent:SetAngles( Angle( math.NormalizeAngle( angle.p + 90 ), angle.y, angle.r ) )
	else
		ent:SetAngles( angle )
	end
	table.insert( CAKE.Button3d2d, ent )
	/*
	
	--local ent = ClientsideModel("models/props_junk/wood_crate001a.mdl", RENDERGROUP_TRANSLUCENT)
	local ent = ents.Create( "cl_3d2d_clickcontroller" )
	ent:SetModel( "models/props_junk/wood_crate001a.mdl" )
	ent.BoundaryX = x
	ent.BoundaryY = y
	ent:InitializeAsClientEntity( )
	--ent:SetNoDraw( true )
	ent:SetPos( pos )
	print( tostring( pos ) )
	ent:SetAngles( angle )
	ent.ClickFunction = func
	ent.IsA3d2dButton = true
	
	table.insert( CAKE.Button3d2d, ent )*/
	
	return ent

end

function CAKE.DestroyAllButtons()
	
	for k, v in pairs( CAKE.Button3d2d ) do
		if ValidEntity( v ) then
			v:Remove()
		end
	end
	
	CAKE.Button3d2d = {}
	
end

local localpos = Vector( 0, 0, 0 )
local localang = Angle( 0, 0, 0 )
local lastpos = 0
local w, h
local postable = {}
local tabpositions = {}
local ent
local runonce = false

hook.Add( "Think", "Tiramisu3DButtons", function( )
	
	if CAKE.MenuOpen and !runonce then
		runonce = true
		for k, v in pairs( CAKE.MenuTabs ) do
			lastpos = lastpos + 55
			tabpositions[ k ] = lastpos
		end
		localang = Angle( 0, math.NormalizeAngle( LocalPlayer():GetAngles().y + 90 ) , 90 )
		localpos = LocalPlayer():GetPos() + Vector( 0, 100, 0 ) + Vector( 300 * 0.13, 0, 0 )
		for k, v in pairs( tabpositions ) do
			ent = CAKE.Create3d2dButton( localpos + Vector( 0, 0 , v * 0.2 ), localang, 75, 25, function()
				CAKE.SetActiveTab(k)
			end)
			ent.Name = k
		end
		timer.Simple( 0.3, function()
			CAKE.DisplayMenu = true
		end)
	elseif !CAKE.MenuOpen and runonce then
		CAKE.DestroyAllButtons()
		runonce = false
		lastpos = 0
	end
	
end)

local angle
local angle2

hook.Add( "PostDrawOpaqueRenderables", "Tiramisu3DMenu", function( )
	if CAKE.DisplayMenu then
		angle = Angle( 0, math.NormalizeAngle( LocalPlayer():GetAngles().y + 90 ) , 90 )
		angle2 = Angle( 0, math.NormalizeAngle( LocalPlayer():GetAngles().y + 65 ) , 90 )
		cam.Start3D2D( LocalPlayer():GetPos() + Vector( 0, 0, 100 ) - angle:Up( ) * 2.5, angle, 0.13 )
			surface.SetFont( "BaseTitle" )
			w , h = surface.GetTextSize( "Main Menu" )
			surface.SetDrawColor( 10, 255, 10, 70) --Blue
			surface.DrawRect(( w + 10 ) / -2 , 0, w + 10, h )
		cam.End3D2D()
		cam.Start3D2D( LocalPlayer():GetPos() + Vector( 0, 0, 100 ), angle, 0.13 )
			surface.SetFont( "BaseTitle" )
			w , h = surface.GetTextSize( "Main Menu" )
			draw.DrawText( "Main Menu", "BaseTitle", 0, 0, Color( 255, 255, 255, 255 ), 1 )
		cam.End3D2D()
		cam.Start3D2D( LocalPlayer():GetPos() + Vector( 0, 0, 100 ) - angle2:Up( ) * 2.5, angle2, 0.13 )
			surface.SetFont( "BaseTitle" )
			for k, v in pairs( CAKE.MenuTabs ) do
				if !postable[ k ] then
					postable[ k ] = 0
				end
				postable[ k ] = Lerp( 0.1, postable[ k ], tabpositions[ k ])
				w , h = surface.GetTextSize( k )
				surface.SetDrawColor( 255, 10, 10, 70) --Red
				surface.DrawRect( (( w + 10 ) / -2 ) + 300 , postable[ k ], w + 10, h )
			end
		cam.End3D2D()
		cam.Start3D2D( LocalPlayer():GetPos() + Vector( 0, 0, 100 ), angle2, 0.13 )
			surface.SetFont( "BaseTitle" )
			for k, v in pairs( CAKE.MenuTabs ) do
				if !postable[ k ] then
					postable[ k ] = 0
				end
				postable[ k ] = Lerp( 0.1, postable[ k ], tabpositions[ k ])
				w , h = surface.GetTextSize( k )
				surface.SetDrawColor( 255, 10, 10, 70) --Red
				draw.DrawText( k, "BaseTitle", 300, postable[ k ], Color( 255, 255, 255, 255 ), 1 )
			end
		cam.End3D2D()
	else
		postable = {}
	end
end)

function CAKE.RegisterMenuTab( name, func, closefunc ) --The third argument is the function used for closing your panel.
	print( "Registering Menu Tab " .. name )
	CAKE.MenuTabs[ name ] = {}
	CAKE.MenuTabs[ name ][ "function" ] = func or function() end
	CAKE.MenuTabs[ name ][ "closefunc" ] = closefunc or function() end
end

function CAKE.CloseTabs()
	if CAKE.ActiveTab then
		CAKE.MenuTabs[ CAKE.ActiveTab ][ "closefunc" ]()
		CAKE.ActiveTab = nil
	end
end

function CAKE.SetActiveTab( name )
	CAKE.CloseTabs()
	CAKE.MenuTabs[ name ][ "function" ]()
	CAKE.ActiveTab = name
	CAKE.MenuOpen = true
end

function CreatePlayerMenu( um )
		
		if CAKE.MenuOpen then
			ClosePlayerMenu()
			return
		end
	
		CAKE.MenuOpen = true
		
		gui.EnableScreenClicker( true )
		InitHUDMenu()
		HiddenButton:SetVisible( true )
		
		/*
		TabPanel = vgui.Create("DFrame");
		TabPanel:SetSize( 270, 600 )
		TabPanel:SetPos( 10, 10 )
		TabPanel:SetTitle( "" )
		TabPanel:SetDraggable( false ) -- Draggable by mouse?
		TabPanel:ShowCloseButton( false ) -- Show the close button?
		TabPanel:ParentToHUD()
		function TabPanel:Paint()
		end
		TabList = vgui.Create( "DPanelList", TabPanel )
		TabList:SetPos( 0,25 )
		TabList:SetSize( 260, 567 )
		TabList:SetSpacing( 2 ) -- Spacing between items
		TabList:SetPadding( 10 )
		TabList:EnableHorizontal( false ) -- Only vertical items
		TabList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
		function TabList:Paint()
		end
		local MainMenu = vgui.Create( "DLabel" )
		MainMenu:SetFont("BaseTitle")
		MainMenu:SetText( "Main Menu" )
		MainMenu:SetSize( 250, 50 )
		MainMenu:SetTextColor( Color( 220, 0, 0 ) )
		MainMenu:SetExpensiveShadow( 2, Color( 255, 255, 255, 255 ) )
		TabList:AddItem( MainMenu )
		for k, v in pairs( CAKE.MenuTabs ) do
			local label = vgui.Create( "DLabel" )
			label:SetFont("BaseOptions")
			label:SetText( k )
			label:SetSize( 250, 30 )
			label:SetTextColor( Color( 0, 0, 0 ) )
			label.OnMousePressed = function()
				CAKE.SetActiveTab(k)
			end
			label:SetExpensiveShadow( 1, Color( 255, 255, 255, 255 ) )
			TabList:AddItem( label )
		end
		local closelabel = vgui.Create( "DLabel" )
		closelabel:SetFont("BaseOptions")
		closelabel:SetText( "Close Menu" )
		closelabel:SetSize( 250, 65 )
		closelabel:SetExpensiveShadow( 1, Color( 255, 255, 255, 255 ) )
		closelabel:SetTextColor( Color( 0, 0, 0 ) )
		closelabel.OnMousePressed = function()
			ClosePlayerMenu()
		end
		TabList:AddItem( closelabel )
		TabPanel:MakePopup()
		
		VitalsMenu = vgui.Create( "DFrame" )
		VitalsMenu:SetSize( 340, 230 )
		VitalsMenu:SetTitle( "" )
		VitalsMenu:SetVisible( true )
		VitalsMenu:SetDraggable( false )
		VitalsMenu:ShowCloseButton( false )
		VitalsMenu:SetDeleteOnClose( true )
		VitalsMenu:SetPos( ScrW() - 350, 310 )
		function VitalsMenu:Paint()
		end

		local PlayerInfo = vgui.Create( "DPanelList", VitalsMenu )
		PlayerInfo:SetSize( 340, 200 )
		PlayerInfo:SetPos( 0, 23 )
		PlayerInfo:SetPadding(10);
		PlayerInfo:SetSpacing(10);
		PlayerInfo:EnableHorizontal(false);
		function PlayerInfo:Paint()
		end

		local icdata = vgui.Create( "DForm" );
		icdata:SetPadding(4);
		icdata:SetName(LocalPlayer():Nick() or "");

		local FullData = vgui.Create("DPanelList");
		FullData:SetSize(0, 84);
		FullData:SetPadding(10);

		local DataList = vgui.Create("DPanelList");
		DataList:SetSize(0, 64);

		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetModel(LocalPlayer():GetNWString( "model", LocalPlayer():GetModel()) );
		spawnicon:SetSize( 64, 64 );
		DataList:AddItem(spawnicon);

		local DataList2 = vgui.Create( "DPanelList" )

		local label2 = vgui.Create("DLabel");
		label2:SetText("Title: " .. LocalPlayer():GetNWString("title", ""));
		DataList2:AddItem(label2);

		local label3 = vgui.Create("DLabel");
		label3:SetText("Title 2: " .. LocalPlayer():GetNWString("title2", ""));
		DataList2:AddItem(label3);

		local label4 = vgui.Create("DLabel");
		label4:SetText( CurrencyTable.name .. ": " .. LocalPlayer():GetNWString("money", "0" ));
		DataList2:AddItem(label4);

		local Divider = vgui.Create("DHorizontalDivider");
		Divider:SetLeft(spawnicon);
		Divider:SetRight(DataList2);
		Divider:SetLeftWidth(64);
		Divider:SetHeight(64);

		DataList:AddItem(spawnicon);
		DataList:AddItem(DataList2);
		DataList:AddItem(Divider);

		FullData:AddItem(DataList)

		icdata:AddItem(FullData)

		local vitals = vgui.Create( "DForm" );
		vitals:SetPadding(4);
		vitals:SetName("Vital Signs");

		local VitalData = vgui.Create("DPanelList");
		VitalData:SetAutoSize(true)
		VitalData:SetPadding(10);
		vitals:AddItem(VitalData);

		local healthstatus = ""
		local hp = LocalPlayer():Health();

		if(!LocalPlayer():Alive()) then healthstatus = "Dead";
		elseif(hp > 95) then healthstatus = "Healthy";
		elseif(hp > 50 and hp < 95) then healthstatus = "OK";
		elseif(hp > 30 and hp < 50) then healthstatus = "Near Death";
		elseif(hp > 1 and hp < 30) then healthstatus = "Death Imminent"; end

		local health = vgui.Create("DLabel");
		health:SetText("Vitals: " .. healthstatus);
		VitalData:AddItem(health);

		PlayerInfo:AddItem(icdata)
		PlayerInfo:AddItem(vitals)
		
		*/
	
end
usermessage.Hook("openplayermenu", CreatePlayerMenu);

function ClosePlayerMenu( um )

	CAKE.CloseTabs()
	if TabPanel then
		if VitalsMenu then
			VitalsMenu:Remove();
			VitalsMenu = nil
		end
		TabPanel:Remove();
		TabPanel = nil
	end
	gui.EnableScreenClicker( false )
	HiddenButton:SetVisible( false )
	CAKE.DestroyAllButtons()
	CAKE.DisplayMenu = false
	CAKE.MenuOpen = false
	
end
usermessage.Hook("closeplayermenu", ClosePlayerMenu);