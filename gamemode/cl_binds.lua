

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

function CAKE.DrawQuickMenu()
	if QuickMenu then
		QuickMenu:Remove()
		Quickmenu = nil
	end

	QuickMenu = vgui.Create("DFrame");
	QuickMenu:SetSize( ScrW()/4, ScrH() )
	QuickMenu:SetPos( 0, 0 )
	QuickMenu:SetTitle( "" )
	QuickMenu:SetDraggable( false ) -- Draggable by mouse?
	QuickMenu:ShowCloseButton( false ) -- Show the close button?
	local fade = 0
	local x, y
	local gradient = surface.GetTextureID("gui/gradient")
	QuickMenu.Paint = function()
		if QuickMenu then
			if !QuickMenu.FadeOut then
				fade = Lerp( 10 * RealFrameTime(), fade, 255 )
			else
				fade = Lerp( 10 * RealFrameTime(), fade, 0 )
				if fade < 5 then
					QuickMenu:Remove()
				end
			end
			x, y = QuickMenu:ScreenToLocal( 0, 0 )
			surface.SetTexture( gradient )
			surface.SetDrawColor( 0, 0, 0, fade ) 
			surface.DrawTexturedRectUV( x, y, QuickMenu:GetWide(), QuickMenu:GetTall(), QuickMenu:GetWide(), QuickMenu:GetWide() )
			surface.SetDrawColor( 0, 0, 0, fade ) 
			surface.DrawTexturedRectUV(  x, y, QuickMenu:GetWide(), QuickMenu:GetTall(), QuickMenu:GetWide(), QuickMenu:GetWide() )
		end
	end

	local titlelabel = Label( "Main Menu", QuickMenu )
	titlelabel:SetSize( QuickMenu:GetWide() - 25, 40 )
	titlelabel:SetFont( "TiramisuTitlesFont" )
	titlelabel:SetTextColor(Color(255, 255, 255, 0))
	titlelabel:SetPos( 25, QuickMenu:GetTall() / 6)
	titlelabel.PaintOver = function()
		titlelabel:SetTextColor(Color(255, 255, 255, fade))
	end

	local startpos = QuickMenu:GetTall() / 4 - #CAKE.MenuTabs * 40
	local lastpos = startpos
	for k, v in pairs( CAKE.MenuTabs ) do
		lastpos = lastpos + 40
		local label = vgui.Create( "DButton", QuickMenu )
		label:SetDrawBorder( false )
		label:SetText( "" )
		label:SetDrawBackground( false )
		label.DoClick = function()
			CAKE.SetActiveTab(k)
		end
		label:SetSize( QuickMenu:GetWide()-10, 28 )
		label:SetTextColor(Color(255, 255, 255, 0))
		label:SetTextColorHovered(CAKE.BaseColor)
		label:SetPos( 10, lastpos)
		label.FuckingColor = label:GetTextColor()
		label.OnCursorEntered = function()
			label.FuckingColor = label:GetTextColorHovered()
		end
		label.OnCursorExited = function()
			label.FuckingColor = label:GetTextColor()
		end
		label.Paint = function()
			 draw.SimpleTextOutlined( k, "TiramisuTitlesFont", label:GetWide()/2, 0, Color(label.FuckingColor.r,label.FuckingColor.g,label.FuckingColor.b,fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,fade))
		end
	end

end

function CAKE.HideQuickMenu()
	if QuickMenu then
		QuickMenu.FadeOut = true
	end
end

function GM:ScoreboardShow( )

	CAKE.ContextEnabled = true;
	CAKE.MenuOpen = true
	gui.EnableScreenClicker( true )
	HiddenButton:SetVisible( true );

	CAKE.DrawQuickMenu()

end

function GM:ScoreboardHide( )

	CAKE.MenuOpen = false
	CAKE.ContextEnabled = false;
	if !CAKE.FreeScroll or !CAKE.ForceFreeScroll then
		gui.EnableScreenClicker( false )
	end
	if HiddenButton then
		HiddenButton:SetVisible( false );
	end

	if VitalsMenu then
		VitalsMenu:Remove()
		VitalsMenu = nil
	end

	CAKE.HideQuickMenu()
	
end