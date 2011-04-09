CLPLUGIN.Name = "Core HUD"
CLPLUGIN.Author = "F-Nox/Big Bang"

--Maximum distance a player can be to have his or her title drawn
CAKE.TitleDrawDistance = CreateClientConVar( "rp_titledrawdistance", 600, true, true )
CAKE.MinimalHUD = CreateClientConVar( "rp_minimalhud", 0, true, true )

surface.CreateFont(CAKE.MenuFont, 32, 500, true, false, "TiramisuTitlesFont", false, true)
surface.CreateFont(CAKE.MenuFont, 18, 500, true, false, "TiramisuTimeFont", true, false )
surface.CreateFont(CAKE.MenuFont, 12, 400, true, false, "TiramisuTabsFont", true )
surface.CreateFont("DefaultSmallDropShadow", ScreenScale(5), 500, true, false, "TiramisuWhisperFont", true )
surface.CreateFont("Trebuchet18", ScreenScale(10), 700, true, false, "TiramisuYellFont", true )

--Draws HUD time text
local struc = {}
struc.pos = { ScrW() - 10, 10 } -- Pos x, y
struc.color = Color(230,230,230,255 ) -- Red
struc.font = "TiramisuTimeFont" -- Font
struc.xalign = TEXT_ALIGN_RIGHT -- Horizontal Alignment
struc.yalign = TEXT_ALIGN_RIGHT -- Vertical Alignment
local markuplbl 

local function DrawTime( )

	if !CAKE.MinimalHUD:GetBool() or CAKE.MenuOpen then 
		if GetGlobalString( "time" ) != "Loading.." then
			struc.text = CAKE.FindDayName() .. ", " .. GetGlobalString( "time" )
			struc.pos = { ScrW() - 10, 10 } -- Pos x, y
			draw.Text( struc )
		else
			struc.text = GetGlobalString( "time" )
			struc.pos = { ScrW() - 10, 10 } -- Pos x, y
			draw.Text( struc )
		end
	end
	if CAKE.MenuOpen then
		struc.text = LocalPlayer():Nick()
		struc.pos = { ScrW() - 10, 30 }
		draw.Text( struc )
		markuplbl = markup.Parse( "<color=230,230,230><font=TiramisuTimeFont>" .. LocalPlayer():GetNWString( "title", "Connecting..." ) .. "</font></color>", 300 )
		markuplbl:Draw( ScrW() - 10, 50, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )
	end
	
end

--Draws item/prop titles

function DrawTargetInfo( )
	
	local tr = LocalPlayer( ):GetEyeTrace( )
	
	if( !tr.HitNonWorld ) then return; end
	
	if( tr.Entity:GetClass( ) == "item_prop" and tr.Entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 100 ) then
	
		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 255 ), 1 );	
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 );
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 0, 0, 255 ), 1 );
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 );
	
	elseif tr.Entity:GetNWString( "propdescription", "" ) != "" and tr.Entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 100 then
		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "propdescription" ), "ChatFont", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 255 ), 1 );
		draw.DrawText( tr.Entity:GetNWString( "propdescription" ), "ChatFont", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 );
	end
	
end
		
--Death/Unconcious message drawing

local timeleft
hook.Add( "HUDPaint", "TiramisuDeathMessages", function()
	if LocalPlayer():GetNWInt("deathmode", 0 ) == 1 then
		timeleft = LocalPlayer( ):GetNWInt( "deathmoderemaining" );
		draw.DrawText( "You have been mortally wounded. Wait " .. tostring( timeleft ) .. " seconds", "ChatFont", ScrW( ) / 2, 20, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	end
	
	if LocalPlayer():GetNWBool("unconciousmode", false ) then
		draw.DrawText( "You have been knocked out. Type 'rp_wakeup' on console.", "ChatFont", ScrW( ) / 2 , 20, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER );
	end
end)

--Context Button Initialization

function InitHiddenButton()
	HiddenButton = vgui.Create("DButton") -- HOLY SHIT WHAT A HACKY METHOD FO SHO
	HiddenButton:SetSize(ScrW(), ScrH());
	HiddenButton:SetText("");
	HiddenButton:SetDrawBackground(false);
	HiddenButton:SetDrawBorder(false);
	HiddenButton.DoRightClick = function()
		local Vect = gui.ScreenToVector(gui.MouseX(), gui.MouseY());
		local trace = LocalPlayer():GetEyeTrace( )
		
		if(trace.HitNonWorld) and trace.StartPos:Distance( trace.HitPos ) <= 400 then
			local target = trace.Entity;
			local ContextMenu = DermaMenu()
			
				for k,v in pairs (RclickTable) do
					if v.Condition(target) then ContextMenu:AddOption(v.Name, function() v.Click(target, LocalPlayer()) end) end
				end
				
			ContextMenu:Open();
		end
	end
end

--Disables default HUD elements

function GAMEMODE:HUDShouldDraw( name )

	if( LocalPlayer( ):GetNWInt( "charactercreate" ) == 1 or LocalPlayer( ):GetNWInt( "charactercreate" ) == nil ) then return false; end
	
	local nodraw = 
	{ 
	
		"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudBattery",
	
	 }
	
	for k, v in pairs( nodraw ) do
	
		if( name == v ) then return false; end
	
	end
	
	return true;

end

--Hook to draw titles.

function GAMEMODE:HUDPaint( )
	
	DrawTime( );
	DrawTargetInfo( );
	
end