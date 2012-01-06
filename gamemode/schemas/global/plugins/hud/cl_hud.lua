CLPLUGIN.Name = "Core HUD"
CLPLUGIN.Author = "F-Nox/Big Bang"

hook.Add( "HUDPaint", "TiramisuClock and TargetInfo", function()
	derma.SkinHook( "Paint", "TiramisuClock" ) --The clock and title display
	derma.SkinHook( "Paint", "TargetInfo" ) 
end)

hook.Add( "HUDPaint", "TiramisuDrawCrosshair", function()
	if hook.Call("ShouldDrawLocalPlayer", GAMEMODE) and !CAKE.FreeScroll and LocalPlayer():Alive() and LocalPlayer():GetAiming() then
		derma.SkinHook( "Paint", "TiramisuCrosshair" )
	end
end)

hook.Add( "PostDrawHUD","TiramisuHUDMessages", function()
	derma.SkinHook( "Paint", "DeathMessage" ) --Messages displayed when dead/unconcious
end)

LocalPlayer().IsDamaged = false
LocalPlayer().DisplayDamage = true
local alpha = 150
local pos, ang
local ent
local perc
local ammotext 
local textsizex, textsizey
local label
local menuopened
local trace
local tracedata = {}

--Handles the drawing of all the thirdperson 2D3D elements, 3D health and 3D ammo displays.
hook.Add( "PostDrawTranslucentRenderables", "TiramisuHealthAmmoDisplay", function( )
	cam.IgnoreZ(true)
	if CAKE.MenuOpen then
		LocalPlayer().IsDamaged = true
		menuopened = true
	elseif !CAKE.MenuOpen and menuopened then
		LocalPlayer().IsDamaged = false
		LocalPlayer().DisplayDamage = false
		menuopened = false
	end

	if CAKE.Thirdperson:GetBool() and LocalPlayer():Alive() then
		if LocalPlayer().IsDamaged and !LocalPlayer().DisplayDamage then
			LocalPlayer().DisplayDamage = true
		elseif LocalPlayer().IsDamaged and LocalPlayer().DisplayDamage then
			alpha = 150
			pos, ang = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1"))
			ang:RotateAroundAxis( ang:Up(), 90 )
			ang:RotateAroundAxis( ang:Forward() , -180 )
			ang:RotateAroundAxis( ang:Right() , -90 )
			cam.Start3D2D( pos - ( ang:Right() * 18 ), ang , 0.25 )
				draw.RoundedBox( 4, 0, 0, 21, 18, Color( 60, 60, 60, 150 ) )
				draw.SimpleTextOutlined(tostring( LocalPlayer():Health() ), "Tiramisu24Font", 10, 8, Color(255, 100, 100, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
			cam.End3D2D()
			
			if LocalPlayer():Armor() > 0 then
				cam.Start3D2D( pos - ( ang:Right() * 12 ) + ( ang:Forward() * 7 ), ang , 0.25 )
					draw.RoundedBox( 4, 0, 0, 16, 15, Color( 60, 60, 60, 150 ) )
					draw.SimpleTextOutlined(tostring( LocalPlayer():Armor() ), "Tiramisu18Font", 8, 8, Color(100, 100, 255, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
				cam.End3D2D()
			end
		elseif !LocalPlayer().IsDamaged and LocalPlayer().DisplayDamage then
			if alpha > 5 then
				alpha = Lerp( 0.2, alpha, 0 )
				pos, ang = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1"))
				ang:RotateAroundAxis( ang:Up(), 90 )
				ang:RotateAroundAxis( ang:Forward() , -180 )
				ang:RotateAroundAxis( ang:Right() , -90 )
				cam.Start3D2D( pos - ( ang:Right() * 18 ), ang , 0.25 )
					draw.RoundedBox( 4, 0, 0, 21, 18, Color( 60, 60, 60, alpha ) )
					draw.SimpleTextOutlined(tostring( LocalPlayer():Health() ), "Tiramisu24Font", 10, 8, Color(255, 100, 100, alpha),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
				cam.End3D2D()
				
				if LocalPlayer():Armor() > 0 then
					cam.Start3D2D( pos - ( ang:Right() * 12 ) + ( ang:Forward() * 7 ), ang , 0.25 )
						draw.RoundedBox( 4, 0, 0, 16, 15, Color( 60, 60, 60, alpha ) )
						draw.SimpleTextOutlined(tostring( LocalPlayer():Armor() ), "Tiramisu18Font", 8, 8, Color(100, 100, 255, alpha),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
					cam.End3D2D()
				end
			else
				alpha = 150
				LocalPlayer().DisplayDamage = false
			end
		end

		ent = LocalPlayer():GetActiveWeapon()

		if ( ValidEntity( ent ) and LocalPlayer():GetAiming() ) or ( CAKE.MenuOpen and ValidEntity( ent ) ) then
			ammotext = tostring( ent:Clip1() ) .. "/" .. tostring( LocalPlayer():GetAmmoCount(ent:GetPrimaryAmmoType()) )
			pos, ang = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_R_Hand"))
			ang:RotateAroundAxis( ang:Up(), 90 )
			ang:RotateAroundAxis( ang:Forward() ,-90 )
			ang:RotateAroundAxis( ang:Right() ,0 )

			if ent:Clip1() >= 0 and ent:GetClass() != "weapon_physcannon" then
				cam.Start3D2D( pos - (ang:Right() * 10) + (ang:Forward() * 5), ang , 0.2 )
					if ent.Primary and ent.Primary.ClipSize then
						perc = ent:Clip1() / ent.Primary.ClipSize
					else
						perc = 1
					end
					surface.SetFont("Trebuchet24")
					textsizex, textsizey = surface.GetTextSize( ammotext )
					draw.RoundedBox( 4, 0, 0, math.Clamp( textsizex * perc, 6, 200 ), textsizey / 2 , Color( 60, 60, 60, 150 ) )
					draw.SimpleTextOutlined(ammotext, "Trebuchet24", textsizex / 2, 0, Color(180, 255, 180, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200))
					if LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) > 0 then
						surface.SetFont("Trebuchet20")
						textsizex, textsizey = surface.GetTextSize( tostring( LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) ) )
						draw.RoundedBox( 4, 50, 30, textsizex, textsizey / 2, Color( 60, 60, 60, 150 ) )
						draw.SimpleTextOutlined(tostring( LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) ), "Trebuchet20", (textsizex / 2 ) + 50, 30, Color(180, 180, 255, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200))
						if LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) > 0 then
							surface.SetFont("HUDNumber")
							textsizex, textsizey = surface.GetTextSize( tostring( LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) ) )
							draw.RoundedBox( 4, ScrW() - 160, ScrH() - 100, textsizex, textsizey / 2, Color( 60, 60, 60, 150 ) )
							draw.SimpleTextOutlined(tostring( LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) ), "HUDNumber", ( ScrW() - 160 ) + (textsizex / 2 ), ScrH() - 100, Color(180, 180, 255, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200))
						end
					end
				cam.End3D2D()
			end
		end
	end
	cam.IgnoreZ(false)
end)

--Simple check to see if the player was damaged.
hook.Add( "Think", "TiramisuDamageDetect",function() 

	if !LocalPlayer().TiramisuHUDDamage then
		LocalPlayer().TiramisuHUDDamage = LocalPlayer():Health()
	end

	if LocalPlayer().TiramisuHUDDamage != LocalPlayer():Health() and LocalPlayer():Health() < 100 then
		LocalPlayer().IsDamaged = true
		LocalPlayer().TiramisuHUDDamage = LocalPlayer():Health()
		timer.Create("LocalDamageDisplayTimer", 3, 1, function()
			LocalPlayer().IsDamaged = false
		end)
	end
	
end)

--Handles drawing of firstperson ammo GUI.
hook.Add( "HUDPaint", "TiramisuHUDDraw", function()
	if !CAKE.Thirdperson:GetBool() then
		if !CAKE.MinimalHUD:GetBool() or CAKE.MenuOpen then
			surface.SetFont("HUDNumber")
			ent = LocalPlayer():GetActiveWeapon()
		
			if ( ValidEntity( ent ) and LocalPlayer():GetAiming() ) or ( CAKE.MenuOpen and ValidEntity( ent ) ) then
				ammotext = tostring( ent:Clip1() ) .. "/" .. tostring( LocalPlayer():GetAmmoCount(ent:GetPrimaryAmmoType()) )
				if ent:Clip1() >= 0 and ent:GetClass() != "weapon_physcannon" then
					if ent.Primary and ent.Primary.ClipSize then
						perc = ent:Clip1() / ent.Primary.ClipSize
					else
						perc = 1
					end
					textsizex, textsizey = surface.GetTextSize( ammotext )
					draw.RoundedBox( 4, ScrW() - 160, ScrH() - 50, math.Clamp( textsizex * perc, 6, 200 ), textsizey / 2 , Color( 60, 60, 60, 150 ) )
					draw.SimpleTextOutlined(ammotext, "HUDNumber", ( ScrW() - 160 ) + textsizex / 2, ScrH() - 50, Color(180, 255, 180, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200))
				end
			end
		end
	end
end)

--Locator for the 3D Titles

timer.Create( "LocalTiramisuTitleTimer", 0.2, 0, function()
	
	closeents = ents.FindInSphere( LocalPlayer():GetPos(), CAKE.TitleDrawDistance:GetInt() )

end)

--3D Door Titles
local doordata
local alpha
local viewpos
hook.Add( "PostDrawOpaqueRenderables", "Tiramisu3DDoorTitles", function()
	if closeents then
		for _, door in pairs( closeents ) do
			if ValidEntity( door ) and CAKE.IsDoor( door ) and CAKE.GetDoorTitle( door ) != "" then
				doordata = CAKE.CalculateDoorTextPosition( door )
				if !doordata.HitWorld then
					viewpos = LocalPlayer():GetShootPos()
					alpha = math.Clamp( viewpos:Distance( door:GetPos() ) * - 1 + 300, 0, 255 )
					cam.Start3D2D(doordata.position, doordata.angles, 0.12 )
						draw.SimpleTextOutlined( CAKE.GetDoorTitle( door ), "Tiramisu32Font", 0, 0, Color( 255, 255, 255, alpha ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,alpha) )
					cam.End3D2D()
									
					cam.Start3D2D(doordata.positionBack, doordata.anglesBack, 0.12)
						draw.SimpleTextOutlined( CAKE.GetDoorTitle( door ), "Tiramisu32Font", 0, 0, Color( 255, 255, 255, alpha ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,alpha) )
					cam.End3D2D()
				end
			end
		end
	end

end)

--3D Titles drawing.

local position
local angle
local closeents
local tracedata = {}
local mlabel
local trace
local ent

hook.Add( "PostDrawTranslucentRenderables", "Tiramisu3DPlayerTitles", function( )
	if closeents then
		for k, v in pairs( closeents ) do
			if ValidEntity( v ) then
				if v:IsPlayer() and LocalPlayer() != v and v:Alive() and !v:GetNWBool( "observe" ) and !v:GetNWBool( "unconciousmode", false ) then
					mlabel = markup.Parse( "<c><font=TiramisuTitlesFont>\n" .. v:GetNWString( "title", "Connecting..." ) .. "</font></c>", 570 )
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
					
					position = position - angle:Right() * 28
					cam.Start3D2D( position, angle, 0.12 )
						if v:GetNWBool( "chatopen", false ) then
							draw.DrawText( "Typing...", "Tiramisu32Font", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
						end
						draw.DrawText( v:Nick(), "Tiramisu32Font", 0, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
						mlabel:Draw( 0, 70, TEXT_ALIGN_CENTER )
					cam.End3D2D()

					angle:RotateAroundAxis( angle:Forward(), 180 )
					angle:RotateAroundAxis( angle:Up(), 180 )
					cam.Start3D2D( position, angle, 0.12 )
						if v:GetNWBool( "chatopen", false ) then
							draw.DrawText( "Typing...", "Tiramisu32Font", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
						end
						draw.DrawText( v:Nick(), "Tiramisu32Font", 0, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
						mlabel:Draw( 0, 70, TEXT_ALIGN_CENTER )
					cam.End3D2D()
				end
		   end
		end
	end
end)
