-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_hud.lua 
-- General HUD stuff.
-------------------------------

CAKE.TitleDrawDistance = CreateClientConVar( "rp_titledrawdistance", 600, true, true )

LocalPlayer( ).MyModel = "" -- Has to be blank for the initial value, so it will create a spawnicon in the first place.

surface.CreateFont(CAKE.MenuFont, 32, 500, true, false, "TiramisuTitlesFont", false, true)
surface.CreateFont(CAKE.MenuFont, 18, 500, true, false, "TiramisuTimeFont")
surface.CreateFont(CAKE.MenuFont, 12, 400, true, false, "TiramisuTabsFont", true )
surface.CreateFont("DefaultSmallDropShadow", ScreenScale(5), 500, true, false, "TiramisuWhisperFont", true )
surface.CreateFont("Trebuchet18", ScreenScale(10), 700, true, false, "TiramisuYellFont", true )

local function DrawTime( )

	surface.SetFont( "HudHintTextLarge" )

	local struc = {}
	struc.pos = { 10,10 } -- Pos x, y
	struc.color = Color(255,255,255,255 ) -- Red
	struc.font = "TiramisuTimeFont" -- Font
	struc.xalign = TEXT_ALIGN_LEFT -- Horizontal Alignment
	struc.yalign = TEXT_ALIGN_LEFT -- Vertical Alignment

	if GetGlobalString( "time" ) != "Loading.." then
		struc.text = CAKE.FindDayName() .. ", " .. GetGlobalString( "time" )
		draw.TextShadow( struc,  3,  150 )
		--draw.DrawText( CAKE.FindDayName() .. ", " .. GetGlobalString( "time" ) , "PlInfoFont", 10, 10, Color( 255,255,255,255 ), 0 );
	else
		struc.text = GetGlobalString( "time" )
		draw.TextShadow( struc,  3,  180 )
		--draw.DrawText( GetGlobalString( "time" ), "PlInfoFont", 10, 10, Color( 255,255,255,255 ), 0 );
	end
	
end

function DrawTargetInfo( )
	
	local tr = LocalPlayer( ):GetEyeTrace( )
	
	if( !tr.HitNonWorld ) then return; end
	
	if( tr.Entity:GetClass( ) == "item_prop" and tr.Entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 100 ) then
	
		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 255 ), 1 );	
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 );
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 0, 0, 255 ), 1 );	
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 );

	end
	
end
		
function GM:HUDShouldDraw( name )

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

local position
local angle
local closeents
local tracedata = {}
local mlabel
local trace
local ent

timer.Create( "LocalTiramisuTitleTimer", 0.2, 0, function()
	
	closeents = ents.FindInSphere( LocalPlayer():GetPos(), CAKE.TitleDrawDistance:GetInt() )

end)

hook.Add( "PostDrawOpaqueRenderables", "Tiramisu3DTitles", function( )
	
	if closeents then
	    for k, v in pairs( closeents ) do
	    	if ValidEntity( v ) then
		        if v:IsPlayer() and LocalPlayer() != v and v:Alive() and !v:GetNWBool( "observe" ) and !v:GetNWBool( "unconciousmode", false ) then
		        	mlabel = markup.Parse( "<font=TiramisuTitlesFont>\n" .. v:GetNWString( "title", "Connecting..." ) .. "</font>", 550 )
		            position = v:GetPos()
		            if v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") ) then
		                position = v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") )
		            else
		            	position = position + Vector( 0, 0, 80 )
		            end
		            angle = v:GetAngles()
		            angle = Angle( 0, angle.y, 0 )
		            angle:RotateAroundAxis( angle:Up(), 90 )
		            angle:RotateAroundAxis( angle:Forward(), 90 )
		            
		            position = position - angle:Right() * 22
		            cam.Start3D2D( position, angle, 0.12 )
		            	if v:GetNWBool( "chatopen", false ) then
		            		draw.DrawText( "Typing...", "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		            	end
		            	draw.DrawText( v:Nick(), "TiramisuTitlesFont", 0, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		                mlabel:Draw( 0, 70, TEXT_ALIGN_CENTER )
		            cam.End3D2D()

		            angle:RotateAroundAxis( angle:Forward(), 180 )
		            angle:RotateAroundAxis( angle:Up(), 180 )
		            cam.Start3D2D( position, angle, 0.12 )
		            	if v:GetNWBool( "chatopen", false ) then
		            		draw.DrawText( "Typing...", "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		            	end
		            	draw.DrawText( v:Nick(), "TiramisuTitlesFont", 0, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		                mlabel:Draw( 0, 70, TEXT_ALIGN_CENTER )
		            cam.End3D2D()

		        elseif CAKE.IsDoor( v ) and CAKE.GetDoorTitle( v ) != "" then
		      	  	position = v:LocalToWorld(v:OBBCenter())
				    angle = v:GetAngles()
				    angle:RotateAroundAxis( angle:Up(), 90 )
				    angle:RotateAroundAxis( angle:Forward() * -1, -90 )
				    cam.Start3D2D( position + ( angle:Up() * 4 ), angle , 0.12 )
				        draw.SimpleTextOutlined( CAKE.GetDoorTitle( v ), "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,200) )
				    cam.End3D2D()   
				                angle:RotateAroundAxis( angle:Forward(), 180 )
				            angle:RotateAroundAxis( angle:Up(), 180 )
				    cam.Start3D2D( position + ( angle:Up() * 4 ), angle , 0.12 )
				        draw.SimpleTextOutlined( CAKE.GetDoorTitle( v ), "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,200) )
				    cam.End3D2D()   
		        end
		   end
	    end
	end
end)

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
				if target.IsA3d2dButton then
					print( target.Name )
					target:ClickFunction()
				end
			
				for k,v in pairs (RclickTable) do
					if v.Condition(target) then ContextMenu:AddOption(v.Name, function() v.Click(target, LocalPlayer()) end) end
				end
				
			ContextMenu:Open();
		end
	end
end

function InitHUDMenu()
	InitHiddenButton();
end

function GM:HUDPaint( )
	
	DrawTime( );
	--DrawPlayerInfo( );
	DrawTargetInfo( );
	
end