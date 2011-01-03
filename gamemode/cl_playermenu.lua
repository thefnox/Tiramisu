CurrencyTable = {}
CAKE.MenuTabs = {}
CAKE.ActiveTab = nil
CAKE.MenuOpen = false
CAKE.DisplayMenu = false
CAKE.MenuFont = "Base 02"

surface.CreateFont( CAKE.MenuFont, 20, 400, true, false, "BaseOptions" )

local MenuPos
local MenuAng
local MenuScale


hook.Add( "PostDrawOpaqueRenderables", "Tiramisu3DMenu", function( )
	if CAKE.DisplayMenu then
		vgui.Start3D2D( MenuPos, MenuAng, 1 )
			TabPanel:Paint3D2D()
		vgui.End3D2D()
	end
end )

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
	CAKE.MenuOpen = true
	CAKE.CloseTabs()
	CAKE.MenuTabs[ name ][ "function" ]()
	CAKE.ActiveTab = name
end

local postable = {}

function CreatePlayerMenu( um )
		
		if CAKE.MenuOpen then
			ClosePlayerMenu()
			return
		end
	
		CAKE.MenuOpen = true
		CAKE.DisplayMenu = true
		local plytrace = LocalPlayer():GetEyeTrace()
		MenuPos = ( plytrace.HitPos  )
		MenuAng = plytrace.HitNormal:Angle(plytrace.HitPos)
		MenuScale = math.Clamp(( LocalPlayer():GetPos():Distance( plytrace.HitPos ) ) / 1000 , 0.8, 1000 )
		MenuAng:RotateAroundAxis( MenuAng:Up(), 90 )
		MenuAng:RotateAroundAxis( MenuAng:Forward() * -1, -90 )
		
		TabPanel = vgui.Create("DFrame");
		TabPanel:SetSize( 270, 600 )
		TabPanel:SetTitle( "" )
		TabPanel:SetPos( -20, -20 )
		TabPanel:SetDraggable( false ) -- Draggable by mouse?
		TabPanel:ShowCloseButton( false ) -- Show the close button?
		TabPanel.Paint = function() end
		local lastpos = 0
		for k, v in pairs( CAKE.MenuTabs ) do
			lastpos = lastpos + 15
			postable[ k ] = {}
			local label = vgui.Create( "DLabel", TabPanel )
			label:SetFont("BaseOptions")
			label:SetText( k )
			label:SetSize( 250, 20 )
			label:SetTextColor( Color( 255, 255, 255 ) )
			label.OnMousePressed = function()
				CAKE.SetActiveTab(k)
			end
			label:SetPos( 0, 0)
			label:SetExpensiveShadow( 1, Color( 10, 10, 10, 255 ) )
			postable[ k ].maxpos = lastpos
			postable[ k ].panel = label
		end

		local posx, posy
		timer.Create( "labelscrolltimer", 0.01, 0, function()
			for k, v in pairs( postable ) do
				posx, posy = v.panel:GetPos( )
				v.panel:SetPos( 0, Lerp( 0.2, posy, v.maxpos ) )
			end
		end )
	
end
usermessage.Hook("openplayermenu", CreatePlayerMenu);

function ClosePlayerMenu( um )

	timer.Destroy( "labelscrolltimer" )
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
	CAKE.DisplayMenu = false
	CAKE.MenuOpen = false
	
end
usermessage.Hook("closeplayermenu", ClosePlayerMenu);