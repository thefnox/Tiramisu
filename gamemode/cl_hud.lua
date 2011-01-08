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

surface.CreateFont("TargetID", ScreenScale(72), 400, true, false, "TiramisuTitlesFont")
surface.CreateFont("ChatFont", ScreenScale(72), 400, true, false, "TiramisuChatFont")

local function DrawTime( )

	if GetGlobalString( "time" ) != "Loading.." then
		draw.DrawText( CAKE.FindDayName() .. ", " .. GetGlobalString( "time" ) , "PlInfoFont", 10, 10, Color( 255,255,255,255 ), 0 );
	else
		draw.DrawText( GetGlobalString( "time" ), "PlInfoFont", 10, 10, Color( 255,255,255,255 ), 0 );
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
local trace
local ent

hook.Add( "PostDrawOpaqueRenderables", "Tiramisu3DTitles", function( )

    closeents = ents.FindInSphere( LocalPlayer():GetPos(), CAKE.TitleDrawDistance:GetInt() )

    for k, v in pairs( closeents ) do
        if v:IsPlayer() and LocalPlayer() != v and v:Alive() and !v:GetNWBool( "observe" ) and !v:GetNWBool( "unconciousmode", false ) then
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
            
            position = position - angle:Right() * 18
            cam.Start3D2D( position, angle, 0.03 )
                surface.SetFont( "TiramisuTitlesFont" )
                draw.SimpleTextOutlined( v:Nick(), "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
                draw.SimpleTextOutlined( v:GetNWString( "title", "Connecting.." ), "TiramisuTitlesFont", 0, 120, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
                draw.SimpleTextOutlined( v:GetNWString( "title2", "Connecting.." ), "TiramisuTitlesFont", 0, 220, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
            cam.End3D2D()
            angle:RotateAroundAxis( angle:Forward(), 180 )
            angle:RotateAroundAxis( angle:Up(), 180 )
            cam.Start3D2D( position, angle, 0.03 )
                surface.SetFont( "TiramisuTitlesFont" )
                draw.SimpleTextOutlined( v:Nick(), "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
                draw.SimpleTextOutlined( v:GetNWString( "title", "Connecting.." ), "TiramisuTitlesFont", 0, 120, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
                draw.SimpleTextOutlined( v:GetNWString( "title2", "Connecting.." ), "TiramisuTitlesFont", 0, 220, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
            cam.End3D2D()
        elseif CAKE.IsDoor( v ) and CAKE.GetDoorTitle( v ) != "" then
      	  	position = v:LocalToWorld(v:OBBCenter())
		    angle = v:GetAngles()
		    angle:RotateAroundAxis( angle:Up(), 90 )
		    angle:RotateAroundAxis( angle:Forward() * -1, -90 )
		    cam.Start3D2D( position + ( angle:Up() * 4 ), angle , 0.045 )
		        draw.SimpleTextOutlined( CAKE.GetDoorTitle( v ), "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
		    cam.End3D2D()   
		                angle:RotateAroundAxis( angle:Forward(), 180 )
		            angle:RotateAroundAxis( angle:Up(), 180 )
		    cam.Start3D2D( position + ( angle:Up() * 4 ), angle , 0.045 )
		        draw.SimpleTextOutlined( CAKE.GetDoorTitle( v ), "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
		    cam.End3D2D()   
        end
    end
end)


function InitHiddenButton()
	HiddenButton = vgui.Create("DButton") -- HOLY SHIT WHAT A HACKY METHOD FO SHO
	HiddenButton:SetSize(ScrW(), ScrH());
	HiddenButton:SetText("");
	HiddenButton:SetDrawBackground(false);
	HiddenButton:SetDrawBorder(false);
	HiddenButton.DoClick = function()
		local trace = LocalPlayer():GetEyeTrace( )
		
		if(trace.HitNonWorld) then
			local target = trace.Entity
			print( target.Name )
			if target.IsA3d2dButton then
				target:ClickFunction()
			end
		end
	end
	HiddenButton.DoRightClick = function()
		local Vect = gui.ScreenToVector(gui.MouseX(), gui.MouseY());
		local trace = LocalPlayer():GetEyeTrace( )
		
		if(trace.HitNonWorld) then
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
	
	--DrawTime( );
	--DrawPlayerInfo( );
	DrawTargetInfo( );
	
end