CLPLUGIN.Name = "Core HUD"
CLPLUGIN.Author = "F-Nox/Big Bang"

--Maximum distance a player can be to have his or her title drawn
CAKE.TitleDrawDistance = CreateClientConVar( "rp_titledrawdistance", 600, true, true )
CAKE.MinimalHUD = CreateClientConVar( "rp_minimalhud", 0, true, true )

--Draws HUD time text
local struc = {}
struc.pos = { ScrW() - 10, 10 } -- Pos x, y
struc.color = Color(230,230,230,255 ) -- Red
struc.font = "TiramisuTimeFont" -- Font
struc.xalign = TEXT_ALIGN_RIGHT -- Horizontal Alignment
struc.yalign = TEXT_ALIGN_RIGHT -- Vertical Alignment
local markuplbl = markup.Parse( "<color=230,230,230,255><font=TiramisuTimeFont>" .. LocalPlayer():GetNWString( "title", "Connecting..." ) .. "</font></color>", 300 )

timer.Create( "TiramisuTitleMarkupRefresh", 1, 0, function()
	markuplbl = markup.Parse( "<color=230,230,230,255><font=TiramisuTimeFont>" .. LocalPlayer():GetNWString( "title", "Connecting..." ) .. "</font></color>", 300 )
end)

--Draws the time and the player name/title
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
		markuplbl:Draw( ScrW() - 10, 50, TEXT_ALIGN_RIGHT )
	end
	
end

--Draws item/prop titles

function DrawTargetInfo( )
	
	local ang = gui.ScreenToVector(gui.MouseX(), gui.MouseY());
	local tracedata = {}
	tracedata.start = CAKE.CameraPos
	tracedata.endpos = CAKE.CameraPos+(ang*300)
	tracedata.filter = LocalPlayer()
	local tr = util.TraceLine(tracedata)
	
	if( !tr.HitNonWorld ) then return; end
	
	if( tr.Entity:GetClass( ) == "item_prop" and tr.Entity:GetPos( ):Distance( CAKE.CameraPos ) <= 200 ) then
		--If the entity is nearby, we draw it's name and description fully.

		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 255 ), 1 );	
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 );
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 0, 0, 255 ), 1 );
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 );

	elseif ( tr.Entity:GetClass( ) == "item_prop" and tr.Entity:GetPos( ):Distance( CAKE.CameraPos ) > 200 ) then
		--If the entity is further away than 200 units, we draw only it's name, but greyed out to indicate that you can't use it unless you get closer.

		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 185 ), 1 );	
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x, screenpos.y, Color( 125, 125, 125, 185 ), 1 );

	elseif tr.Entity:GetNWString( "propdescription", "" ) != "" and tr.Entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 200 then
		--if it's a prop with a description added to it, you can read it's description only if you're 200 units near.

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

function CAKE.EntityIsItem(targ)
	if target and target:GetClass() == "item_prop" then
		return CAKE.ItemData[target:GetNWString("Class")]
	end
end

function InitHiddenButton()
	HiddenButton = vgui.Create("DButton") -- HOLY SHIT WHAT A HACKY METHOD FO SHO
	HiddenButton:SetSize(ScrW(), ScrH());
	HiddenButton:SetText("");
	HiddenButton:SetDrawBackground(false);
	HiddenButton:SetDrawBorder(false);
	HiddenButton.DoRightClick = function()
		local ang = gui.ScreenToVector(gui.MouseX(), gui.MouseY());
		local tracedata = {}
		tracedata.start = CAKE.CameraPos
		tracedata.endpos = CAKE.CameraPos+(ang*1000)
		tracedata.filter = LocalPlayer()
		local trace = util.TraceLine(tracedata)
		local distance = 200
		if LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 0 then
			distance = 5000
		end
		
		if trace.StartPos:Distance( trace.HitPos ) <= distance then
			local target = trace.Entity;
			local submenus = {}
			local ContextMenu = DermaMenu()
			
				if ValidEntity( target ) and target:GetClass() == "item_prop" then
					item = CAKE.ItemData[target:GetNWString("Class")]
					for k,v in pairs(item.RightClick or {}) do
						ContextMenu:AddOption(k, function() LocalPlayer():ConCommand("rp_useitem " ..target:EntIndex().. " " .. v) end)
					end
				end

				for k,v in pairs (RclickTable) do
					if v.Condition(target) then 
						if v.SubMenu then
							if !submenus[ v.SubMenu ] then
								submenus[ v.SubMenu ] = ContextMenu:AddSubMenu( v.SubMenu )
							end
							submenus[ v.SubMenu ]:AddOption(v.Name, function() v.Click(target, LocalPlayer()) end)
						else
							ContextMenu:AddOption(v.Name, function() v.Click(target, LocalPlayer()) end)
						end
					end
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