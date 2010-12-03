-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_hud.lua 
-- General HUD stuff.
-------------------------------

LocalPlayer( ).MyModel = "" -- Has to be blank for the initial value, so it will create a spawnicon in the first place.

surface.CreateFont("TargetID", ScreenScale(72), 400, true, false, "TiramisuTitlesFont")
surface.CreateFont("ChatFont", ScreenScale(72), 400, true, false, "TiramisuChatFont")

local function DrawTime( )

	draw.DrawText( GetGlobalString( "time" ), "PlInfoFont", 10, 10, Color( 255,255,255,255 ), 0 );
	
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

hook.Add( "PostDrawOpaqueRenderables", "Tiramisu3DTitles", function( )
	
	local position
	local screenpos
	local trace
	local alpha
	local tracedata
	local dist
	local angle
	local inverseangle
	local rendered = {}
	for k, v in pairs( player.GetAll( ) ) do
		
		
		if( v != LocalPlayer( ) and !v:GetNWBool( "observe" )) then
			if( v:Alive( ) ) then
				alpha = 0
				tracedata = {}
				tracedata.start = LocalPlayer():GetShootPos()
				tracedata.endpos = v:GetPos()
				tracedata.filter = LocalPlayer()
				tracedata.mask = MASK_SOLID_BRUSHONLY
				trace = util.TraceLine( tracedata )
				position = v:GetPos()
				if v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") ) then
					position = v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") )
					position = Vector( position.x, position.y, position.z + 18 )
				else
					position = Vector( position.x, position.y, position.z + 115 )
				end
				--screenpos = position:ToScreen( )
				screenpos = Vector( 0, 0, 0 )
				dist = position:Distance( LocalPlayer( ):GetPos( ) )
				dist = dist / 2
				dist = math.floor( dist )
				
				if !trace.HitWorld and !LocalPlayer():GetNWBool("seeall", false) then
					if( dist > 100 ) then
						alpha = 255 - ( dist - 100 )
					else
						alpha = 255
					end
				
					if( alpha > 255 ) then
						alpha = 255
					elseif( alpha < 0 ) then
						alpha = 0
					end
					
					angle = math.NormalizeAngle( v:GetAngles().y + 90 )
					inverseangle = math.NormalizeAngle( v:GetAngles().y - 90 )
					--Why do I create two instances of cam.Start3d2d, you may ask.
					--It's actually quite simple, one's angles are mirrored in comparison to the other
					--Considering that 3d2d screens render only one way, this is the only way to effectively have text
					--That can be seen equally from the front of a character as well as from the back.
					cam.Start3D2D( position, Angle( 0, angle , 90 ), 0.03 )
						draw.DrawText( v:Nick( ), "TiramisuTitlesFont", screenpos.x, screenpos.y, Color( 255, 255, 255, alpha ), 1 )
						draw.DrawText( v:GetNWString( "title", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 100, Color( 255, 255, 255, alpha ), 1 )
						draw.DrawText( v:GetNWString( "title2", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 200, Color( 255, 255, 255, alpha ), 1 )
						if( v:GetNWInt( "chatopen" ) == 1 ) then
							draw.DrawText( "Typing..", "TiramisuChatFont", screenpos.x, screenpos.y - 150, Color( 255, 255, 255, alpha ), 1 )
						end
					cam.End3D2D()
					cam.Start3D2D( position, Angle( 0,inverseangle, 90 ), 0.03 )
						draw.DrawText( v:Nick( ), "TiramisuTitlesFont", screenpos.x, screenpos.y, Color( 255, 255, 255, alpha ), 1 )
						draw.DrawText( v:GetNWString( "title", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 100, Color( 255, 255, 255, alpha ), 1 )
						draw.DrawText( v:GetNWString( "title2", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 200, Color( 255, 255, 255, alpha ), 1 )
						if( v:GetNWInt( "chatopen" ) == 1 ) then
							draw.DrawText( "Typing..", "TiramisuChatFont", screenpos.x, screenpos.y - 150, Color( 255, 255, 255, alpha ), 1 )
						end
					cam.End3D2D()
						
					table.insert( rendered, v )
					
				elseif LocalPlayer():GetNWBool("seeall", false) then
					alpha = 255
					cam.Start3D2D( position, Angle( 0, angle , 90 ), 0.03 )
						draw.DrawText( v:Nick( ), "TiramisuTitlesFont", screenpos.x, screenpos.y, Color( 255, 255, 255, alpha ), 1 )
						draw.DrawText( v:GetNWString( "title", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 100, Color( 255, 255, 255, alpha ), 1 )
						draw.DrawText( v:GetNWString( "title2", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 200, Color( 255, 255, 255, alpha ), 1 )
						draw.DrawText( v:Name() .. " [" .. v:SteamID() .. "]", "TiramisuTitlesFont", screenpos.x, screenpos.y - 100, Color(60, 160, 255, 255), 1)
						draw.DrawText( dist*2 .. " units away.", "TiramisuTitlesFont", screenpos.x, screenpos.y + 300, Color(60, 160, 255, 255), 1)
						table.insert( rendered, v )
					cam.End3D2D()
					cam.Start3D2D( position, Angle( 0, inverseangle , 90 ), 0.03 )
						draw.DrawText( v:Nick( ), "TiramisuTitlesFont", screenpos.x, screenpos.y, Color( 255, 255, 255, alpha ), 1 )
						draw.DrawText( v:GetNWString( "title", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 100, Color( 255, 255, 255, alpha ), 1 )
						draw.DrawText( v:GetNWString( "title2", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 200, Color( 255, 255, 255, alpha ), 1 )
						draw.DrawText( v:Name() .. " [" .. v:SteamID() .. "]", "TiramisuTitlesFont", screenpos.x, screenpos.y - 100, Color(60, 160, 255, 255), 1)
						draw.DrawText( dist*2 .. " units away.", "TiramisuTitlesFont", screenpos.x, screenpos.y + 300, Color(60, 160, 255, 255), 1)
						table.insert( rendered, v )
					cam.End3D2D()
				end
			end
		end
	end
	
	local closeplayers = ents.FindInSphere( LocalPlayer():GetPos(), 120 )
	for k, v in pairs( closeplayers ) do
		if v:IsPlayer() and LocalPlayer() != v then
			if !table.HasValue( rendered, v ) then
					position = v:GetPos()
					if v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") ) then
						position = v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") )
						position = Vector( position.x, position.y, position.z + 13 )
					else
						position = Vector( position.x, position.y, position.z + 100 )
					end
					screenpos = position:ToScreen( )
					cam.Start3D2D( position, Angle( 0, angle , 90 ), 0.03 )
						draw.DrawText( v:Nick( ), "TiramisuTitlesFont", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 )
						draw.DrawText( v:GetNWString( "title", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 100, Color( 255, 255, 255, 255 ), 1 )
						draw.DrawText( v:GetNWString( "title2", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 200, Color( 255, 255, 255, 255 ), 1 )
						if( v:GetNWInt( "chatopen" ) == 1 ) then
							draw.DrawText( "Typing..", "TiramisuChatFont", screenpos.x, screenpos.y - 150, Color( 255, 255, 255, 255 ), 1 )
						end
					cam.End3D2D()
					cam.Start3D2D( position, Angle( 0, inverseangle, 90 ), 0.03 )
						draw.DrawText( v:Nick( ), "TiramisuTitlesFont", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 )
						draw.DrawText( v:GetNWString( "title", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 100, Color( 255, 255, 255, 255 ), 1 )
						draw.DrawText( v:GetNWString( "title2", "Connecting.." ), "TiramisuTitlesFont", screenpos.x, screenpos.y + 200, Color( 255, 255, 255, 255 ), 1 )
						if( v:GetNWInt( "chatopen" ) == 1 ) then
							draw.DrawText( "Typing..", "TiramisuChatFont", screenpos.x, screenpos.y - 150, Color( 255, 255, 255, 255 ), 1 )
						end
					cam.End3D2D()
			end
		end
	end
	
end)

function GM:HUDPaint( )
	
	--DrawTime( );
	--DrawPlayerInfo( );
	DrawTargetInfo( );
	
end