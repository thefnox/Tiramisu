-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_binds.lua
-- Changes what keys do.
-------------------------------

CAKE.ContextEnabled = false;

local function ToggleThirdperson( um )

	if CAKE.Thirdperson:GetBool() then
		RunConsoleCommand( "rp_thirdperson", "0" )
	else
		RunConsoleCommand( "rp_thirdperson", "1" )
	end

end
usermessage.Hook( "togglethirdperson", ToggleThirdperson)

local function ToggleInventory( um )

	CAKE.SetActiveTab( "Inventory" )

end
usermessage.Hook( "toggleinventory", ToggleInventory)

function GM:PlayerBindPress( ply, bind, pressed )

	if( LocalPlayer( ):GetNWInt( "charactercreate" ) == 1 ) then
	
		if( bind == "+forward" or bind == "+back" or bind == "+moveleft" or bind == "+moveright" or bind == "+jump" or bind == "+duck" ) then return true; end -- Disable ALL movement keys.
	
	end
	
	if( bind == "+use" ) then
	
		local trent = LocalPlayer( ):GetEyeTrace( ).Entity;
		
		if( trent != nil and trent:IsValid( ) and CAKE.IsDoor( trent ) ) then
		
			LocalPlayer( ):ConCommand( "rp_opendoor" );
			
		end
		
	end

end

function GM:ScoreboardShow( )

	CAKE.ContextEnabled = true;
	CAKE.MenuOpen = true
	gui.EnableScreenClicker( true )
	HiddenButton:SetVisible( true );

	if QuickMenu then
		QuickMenu:Remove()
		Quickmenu = nil
	end

	QuickMenu = vgui.Create("DFrame");
	QuickMenu:SetSize( 130, 400 )
	QuickMenu:SetPos( -100, 10 )
	QuickMenu:SetTitle( "" )
	QuickMenu:SetDraggable( false ) -- Draggable by mouse?
	QuickMenu:ShowCloseButton( false ) -- Show the close button?
	QuickMenu.Paint = function() end

	local lastpos = 0
	for k, v in pairs( CAKE.MenuTabs ) do
		lastpos = lastpos + 27
		local label = vgui.Create( "DButton", QuickMenu )
		label:SetText( k )
		label:SetSize( 120, 25 )
		label:SetTextColor( Color( 255, 255, 255 ) )
		label.DoClick = function()
			CAKE.SetActiveTab(k)
		end
		label:SetPos( 5, lastpos)
		label:SetExpensiveShadow( 1, Color( 10, 10, 10, 255 ) )
	end

	local posx, posy
	timer.Create( "quickmenuscrolltimer", 0.01, 0, function()
		if QuickMenu then
			posx, posy = QuickMenu:GetPos( )
			QuickMenu:SetPos( Lerp( 0.2, posx, 20 ), 10 )
		else
			timer.Destroy( "quickmenuscrolltimer" )
		end
	end )
	
end

function GM:ScoreboardHide( )

	CAKE.MenuOpen = false
	CAKE.ContextEnabled = false;
	gui.EnableScreenClicker( false );
	HiddenButton:SetVisible( false );

	local posx, posy
	if QuickMenu then
		QuickMenu:Remove()
		QuickMenu = nil
	end
	
end

function GM:StartChat( )

	LocalPlayer( ):ConCommand( "rp_openedchat" );
	
end

function GM:FinishChat( )

	LocalPlayer( ):ConCommand( "rp_closedchat" );
	
end