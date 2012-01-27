CAKE.WeaponTable = {}
CAKE.DefaultWepTranslation = {}
CAKE.DefaultWepTranslation["#GMOD_Physgun"] = "Physics Gun"
CAKE.DefaultWepTranslation["#HL2_GravityGun"] = "Gravity Gun"
CAKE.DefaultWepSlot = {}
CAKE.DefaultWepSlot["#GMOD_Physgun"] = 0
CAKE.DefaultWepSlot["#HL2_GravityGun"] = 0
CAKE.DefaultWepSlot["#HL2_Crossbow"] = 4
CAKE.DefaultWepSlot["#HL2_RPG"] = 4
CAKE.DefaultWepSlot["#HL2_Crowbar"] = 0
CAKE.DefaultWepSlot["#HL2_Shotgun"] = 3
CAKE.DefaultWepSlot["#HL2_SMG1"] = 2
CAKE.DefaultWepSlot["#HL2_Pulse_Rifle"] = 3
CAKE.DefaultWepSlot["#HL2_Pistol"] = 1
CAKE.ActiveWepPos = -1
CAKE.ActiveSlot = -1

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

function CAKE.BuildWeaponTable()
	CAKE.WeaponTable = {}
	local slot = 0
	local name = ""
	for _, wep in pairs( LocalPlayer():GetWeapons() ) do
		if ValidEntity( wep ) then
			slot = wep.Slot or 0
			name = wep:GetPrintName()
			if CAKE.DefaultWepSlot[name] then
				slot = CAKE.DefaultWepSlot[name]
			end
			if !CAKE.WeaponTable[slot] then
				CAKE.WeaponTable[slot] = {}
			end
			if CAKE.DefaultWepTranslation[name] then
				name = CAKE.DefaultWepTranslation[name]
			end

			table.insert(CAKE.WeaponTable[slot], {name, wep:GetClass()})
		end
	end
end

local sort = false
hook.Add( "PlayerBindPress", "Tiramisu.HandleWeaponSelection", function(ply, bind, pressed)

	if string.match(bind, "attack") then
		if CAKE.ActiveSlot != -1 and CAKE.WeaponTable[CAKE.ActiveSlot] and CAKE.WeaponTable[CAKE.ActiveSlot][CAKE.ActiveWepPos] then
			RunConsoleCommand("rp_selectweapon", CAKE.WeaponTable[CAKE.ActiveSlot][CAKE.ActiveWepPos][2])
			timer.Destroy("TiramisuResetDefaultWep")
			CAKE.ActiveWepPos = -1
			CAKE.ActiveSlot = -1
			return true
		end
	end

	sort = false
	if string.match(bind, "slot1") and pressed then
		CAKE.ActiveSlot = 0
		sort = true
	elseif string.match(bind, "slot2") and pressed then
		CAKE.ActiveSlot = 1
		sort = true
	elseif string.match(bind, "slot3") and pressed then
		CAKE.ActiveSlot = 2
		sort = true
	elseif string.match(bind, "slot4") and pressed then
		CAKE.ActiveSlot = 3
		sort = true
	elseif string.match(bind, "slot5") and pressed then
		CAKE.ActiveSlot = 4
		sort = true
	elseif string.match(bind, "slot6") and pressed then
		CAKE.ActiveSlot = 5
		sort = true
	elseif string.match(bind, "slot7") and pressed then
		CAKE.ActiveSlot = 6
		sort = true
	end

	if sort then
		if CAKE.ActiveSlot != -1 then
			CAKE.BuildWeaponTable()
			if CAKE.WeaponTable[CAKE.ActiveSlot] then
				timer.Create( "TiramisuResetDefaultWep", 3, 1, function()
					CAKE.ActiveWepPos = -1
					CAKE.ActiveSlot = -1
				end)
				if CAKE.ActiveWepPos == -1 then
					CAKE.ActiveWepPos = 1
				end
				CAKE.ActiveWepPos = CAKE.ActiveWepPos + 1
				if !CAKE.WeaponTable[CAKE.ActiveSlot][CAKE.ActiveWepPos] then
					CAKE.ActiveWepPos = 1
				end 
				return true
			end
		end
	end
end)

local textalpha = 200
local next, prev 
local gradient = surface.GetTextureID("gui/gradient")
local prevspot, nextspot = 0,0
local curslot
hook.Add( "HUDPaint", "Fuck SHIT UP!", function()
	if CAKE.ActiveSlot != -1 and CAKE.WeaponTable[CAKE.ActiveSlot] then
		textalpha = 200
		next = CAKE.ActiveWepPos + 1
		prev = CAKE.ActiveWepPos - 1
		if !CAKE.WeaponTable[CAKE.ActiveSlot][next] then
			next = 1
		end
		if !CAKE.WeaponTable[CAKE.ActiveSlot][prev] then
			prev = #CAKE.WeaponTable[CAKE.ActiveSlot]
		end
		prevspot, nextspot = ScrW()/2, ScrW()/2 + 175
		surface.SetDrawColor( Color( 0,0,0, 200 ) )
		surface.SetTexture( gradient )
		surface.DrawTexturedRectRotated(ScrW()/2-100,50,200,25,180)
		surface.DrawTexturedRectRotated(ScrW()/2+100,50,200,25,0)
		draw.DrawText( CAKE.WeaponTable[CAKE.ActiveSlot][CAKE.ActiveWepPos][1], "Tiramisu16Font", ScrW()/2, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT )
		draw.DrawText( CAKE.WeaponTable[CAKE.ActiveSlot][next][1], "Tiramisu16Font", ScrW()/2 + 175, 40, Color( 255, 255, 255, 120 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT )
		draw.DrawText( CAKE.WeaponTable[CAKE.ActiveSlot][prev][1], "Tiramisu16Font", ScrW()/2 - 175, 40, Color( 255, 255, 255, 120 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT )
	elseif textalpha != 0 then
		curslot = false
		textalpha = Lerp( 10 * RealFrameTime(), textalpha, 0 )
		surface.SetDrawColor( Color( 0,0,0, textalpha ) )
		surface.SetTexture( gradientcenter )
		surface.DrawTexturedRectRotated(ScrW()/2-100,50,200,25,180)
		surface.DrawTexturedRectRotated(ScrW()/2+100,50,200,25,0)		
	end
end)