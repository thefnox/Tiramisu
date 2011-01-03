CLPLUGIN.Name = "Health/Ammo Display"
CLPLUGIN.Author = "F-Nox/Big Bang"

function CLPLUGIN.Init()
	
end

local plydamaged = false
local displaydamage = true
local alpha = 150
local headpos, headang
local wep
local perc
local gunpos, gunang
local ammotext 
local textsizex, textsizey
local label
local menuopened

hook.Add( "PostDrawOpaqueRenderables", "TiramisuHealthAmmoDisplay", function( )

	if ValidEntity( LocalPlayer():GetEyeTrace().Entity ) and CAKE.IsDoor(LocalPlayer():GetEyeTrace().Entity) then
		--Not yet lololol this is for door titles
	end

	if CAKE.Thirdperson:GetBool() or CAKE.MenuOpen then
		if CAKE.MenuOpen then
			plydamaged = true
			menuopened = true
		elseif !CAKE.MenuOpen and menuopened then
			plydamaged = false
			displaydamage = false
		end
		if plydamaged and !displaydamage then
			displaydamage = true
		elseif plydamaged and displaydamage then
			alpha = 150
			headpos, headang = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1"))
		    headang:RotateAroundAxis( headang:Up(), 90 )
		    headang:RotateAroundAxis( headang:Forward() , -180 )
		    headang:RotateAroundAxis( headang:Right() , -90 )
		    cam.Start3D2D( headpos - ( headang:Right() * 18 ), headang , 0.25 )
		        draw.RoundedBox( 4, 0, 0, 21, 18, Color( 60, 60, 60, 150 ) )
		        draw.SimpleTextOutlined(tostring( LocalPlayer():Health() ), "Trebuchet22", 10, 8, Color(255, 100, 100, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
		    cam.End3D2D()
		    
		    if LocalPlayer():Armor() > 0 then
			    cam.Start3D2D( headpos - ( headang:Right() * 12 ) + ( headang:Forward() * 7 ), headang , 0.25 )
			        draw.RoundedBox( 4, 0, 0, 16, 15, Color( 60, 60, 60, 150 ) )
			        draw.SimpleTextOutlined(tostring( LocalPlayer():Armor() ), "Trebuchet19", 8, 8, Color(100, 100, 255, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
			    cam.End3D2D()
			end
		elseif !plydamaged and displaydamage then
			if alpha > 5 then
				alpha = Lerp( 0.2, alpha, 0 )
				headpos, headang = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1"))
			    headang:RotateAroundAxis( headang:Up(), 90 )
			    headang:RotateAroundAxis( headang:Forward() , -180 )
			    headang:RotateAroundAxis( headang:Right() , -90 )
			    cam.Start3D2D( headpos - ( headang:Right() * 18 ), headang , 0.25 )
			        draw.RoundedBox( 4, 0, 0, 21, 18, Color( 60, 60, 60, alpha ) )
			        draw.SimpleTextOutlined(tostring( LocalPlayer():Health() ), "Trebuchet22", 10, 8, Color(255, 100, 100, alpha),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
			    cam.End3D2D()
			    
			    if LocalPlayer():Armor() > 0 then
				    cam.Start3D2D( headpos - ( headang:Right() * 12 ) + ( headang:Forward() * 7 ), headang , 0.25 )
				        draw.RoundedBox( 4, 0, 0, 16, 15, Color( 60, 60, 60, alpha ) )
				        draw.SimpleTextOutlined(tostring( LocalPlayer():Armor() ), "Trebuchet19", 8, 8, Color(100, 100, 255, alpha),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
				    cam.End3D2D()
				end
			else
				alpha = 150
				displaydamage = false
			end
		end

		wep = LocalPlayer():GetActiveWeapon()

		if ( ValidEntity( wep ) and LocalPlayer():GetAiming() ) or ( CAKE.MenuOpen and ValidEntity( wep ) ) then
		    ammotext = tostring( wep:Clip1() ) .. "/" .. tostring( LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType()) )
		    gunpos, gunang = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_R_Hand"))
		    gunang:RotateAroundAxis( gunang:Up(), 90 )
		    gunang:RotateAroundAxis( gunang:Forward() ,-90 )
		    gunang:RotateAroundAxis( gunang:Right() ,0 )

		    if wep:Clip1() >= 0 then
		        cam.Start3D2D( gunpos - (gunang:Right() * 10) + (gunang:Forward() * 5), gunang , 0.2 )
		        	if wep.Primary and wep.Primary.ClipSize then
		        		perc = wep:Clip1() / wep.Primary.ClipSize
		        	else
		        		perc = 1
		        	end
		            surface.SetFont("Trebuchet24")
		            textsizex, textsizey = surface.GetTextSize( ammotext )
		            draw.RoundedBox( 4, 0, 0, textsizex * perc, textsizey / 2 , Color( 60, 60, 60, 150 ) )
		            draw.SimpleTextOutlined(ammotext, "Trebuchet24", textsizex / 2, 0, Color(180, 255, 180, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200))
		            if LocalPlayer():GetAmmoCount(wep:GetSecondaryAmmoType()) > 0 then
		                surface.SetFont("Trebuchet20")
		                textsizex, textsizey = surface.GetTextSize( tostring( LocalPlayer():GetAmmoCount(wep:GetSecondaryAmmoType()) ) )
		                draw.RoundedBox( 4, 50, 30, textsizex, textsizey / 2, Color( 60, 60, 60, 150 ) )
		                draw.SimpleTextOutlined(tostring( LocalPlayer():GetAmmoCount(wep:GetSecondaryAmmoType()) ), "Trebuchet20", (textsizex / 2 ) + 50, 30, Color(180, 180, 255, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200))
		            end
		        cam.End3D2D()
		    end
		end
	end

end)

hook.Add( "Think", "TiramisuDamageDetect",function() 

	if !LocalPlayer().TiramisuHUDDamage then
		LocalPlayer().TiramisuHUDDamage = LocalPlayer():Health()
	end

	if LocalPlayer().TiramisuHUDDamage != LocalPlayer():Health() and LocalPlayer():Health() < 100 then
		plydamaged = true
		LocalPlayer().TiramisuHUDDamage = LocalPlayer():Health()
		timer.Create("LocalDamageDisplayTimer", 3, 1, function()
			plydamaged = false
		end)
	end
	
end)

local pos
local trace
hook.Add( "HUDPaint", "TiramisuCrosshairDraw", function()
	
	if CAKE.Thirdperson:GetBool() then
		trace = LocalPlayer():GetEyeTrace()
		pos = trace.HitPos:ToScreen()
		if pos.visible then
			if !trace.HitWorld then
				surface.SetDrawColor( 200, 50, 50, 220 )
			else
				surface.SetDrawColor( 220, 220, 220, 220 )
			end
			surface.DrawLine( pos.x - 5, pos.y, pos.x + 5, pos.y )
			surface.DrawLine( pos.x, pos.y - 5, pos.x, pos.y + 5 )
		end
	end
	
end)

hook.Add( "HUDShouldDraw", "TiramisuHideHL2Crosshair", function( name )
	
	if CAKE.Thirdperson:GetBool() then
		if name == "CHudCrosshair" then
			return false
		end
	end

end )