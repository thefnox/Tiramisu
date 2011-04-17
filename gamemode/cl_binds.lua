

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

end

local params = {
	["$basetexture"] = "tiramisu/tabbutton2",
	["$translucent"] = 1,
	["$color"] = "{" .. CAKE.BaseColor.r .. " " .. CAKE.BaseColor.g .. " " .. CAKE.BaseColor.b .. "}"
}
local tabmaterial = CreateMaterial("TabMaterial","UnlitGeneric",params);

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
	QuickMenu:SetSize( 260, 400 )
	QuickMenu:SetPos( ScrW() + 130, 200 )
	QuickMenu:SetTitle( "" )
	QuickMenu:SetDraggable( false ) -- Draggable by mouse?
	QuickMenu:ShowCloseButton( false ) -- Show the close button?
	QuickMenu.Paint = function() end

	local lastpos = 0
	for k, v in pairs( CAKE.MenuTabs ) do
		lastpos = lastpos + 30
		local label = vgui.Create( "DImageButton", QuickMenu )
		label.m_Image:SetMaterial( tabmaterial )
		label:SetSize( 256, 28 )
		label.DoClick = function()
			CAKE.SetActiveTab(k)
		end
		label.Paint = function() end
		label.PaintOver = function()
			draw.DrawText(k, "TiramisuTabsFont", 80, 8, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		end
		label:SetPos( 5, lastpos)
		label:SetExpensiveShadow( 1, Color( 10, 10, 10, 255 ) )
	end

	local posx, posy
	timer.Create( "quickmenuscrolltimer", 0.01, 0, function()
		if QuickMenu then
			posx, posy = QuickMenu:GetPos( )
			QuickMenu:SetPos( Lerp( 0.2, posx, ScrW() - 128 ), 200 )
		else
			timer.Destroy( "quickmenuscrolltimer" )
		end
	end )
	
end

function GM:ScoreboardHide( )

	CAKE.MenuOpen = false
	CAKE.ContextEnabled = false;
	gui.EnableScreenClicker( false );
	if HiddenButton then
		HiddenButton:SetVisible( false );
	end

	local posx, posy
	if QuickMenu then
		QuickMenu:Remove()
		QuickMenu = nil
	end
	if VitalsMenu then
		VitalsMenu:Remove()
		VitalsMenu = nil
	end
	
end