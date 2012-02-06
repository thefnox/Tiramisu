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

hook.Add( "HUDPaint", "TiramisuDrawHUD", function()
	derma.SkinHook( "Paint", "TiramisuClock" ) --The clock and title display
	derma.SkinHook( "Paint", "TargetInfo" )
	derma.SkinHook( "Paint", "TiramisuWeaponSelection" )
	derma.SkinHook( "Paint", "PlayerTitles")
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

--Simple check to see if the player was damaged.
hook.Add( "Think", "TiramisuHUDThink",function() 

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

	derma.SkinHook("Think", "PlayerTitles")
	
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

--3D Door Titles
hook.Add( "PostDrawOpaqueRenderables", "Tiramisu3DDoorTitles", function()
	derma.SkinHook( "Paint", "DoorTitles" )
end)

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