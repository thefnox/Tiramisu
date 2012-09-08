TIRA.WeaponTable = {}
TIRA.DefaultWepTranslation = {}
TIRA.DefaultWepTranslation["#GMOD_Physgun"] = "Physics Gun"
TIRA.DefaultWepTranslation["#HL2_GravityGun"] = "Gravity Gun"
TIRA.DefaultWepSlot = {}
TIRA.DefaultWepSlot["#GMOD_Physgun"] = 0
TIRA.DefaultWepSlot["#HL2_GravityGun"] = 0
TIRA.DefaultWepSlot["#HL2_Crossbow"] = 4
TIRA.DefaultWepSlot["#HL2_RPG"] = 4
TIRA.DefaultWepSlot["#HL2_Crowbar"] = 0
TIRA.DefaultWepSlot["#HL2_Shotgun"] = 3
TIRA.DefaultWepSlot["#HL2_SMG1"] = 2
TIRA.DefaultWepSlot["#HL2_Pulse_Rifle"] = 3
TIRA.DefaultWepSlot["#HL2_Pistol"] = 1
TIRA.ActiveWepPos = -1
TIRA.ActiveSlot = -1

function TIRA.BuildWeaponTable()
	TIRA.WeaponTable = {}
	local slot = 0
	local name = ""
	for _, wep in pairs( LocalPlayer():GetWeapons() ) do
		if ValidEntity( wep ) then
			slot = wep.Slot or 0
			name = wep:GetPrintName()
			if TIRA.DefaultWepSlot[name] then
				slot = TIRA.DefaultWepSlot[name]
			end
			if !TIRA.WeaponTable[slot] then
				TIRA.WeaponTable[slot] = {}
			end
			if TIRA.DefaultWepTranslation[name] then
				name = TIRA.DefaultWepTranslation[name]
			end

			table.insert(TIRA.WeaponTable[slot], {name, wep:GetClass()})
		end
	end
end

hook.Add( "HUDPaint", "TiramisuDrawHUD", function()
	derma.SkinHook( "Paint", "TiramisuClock" ) --The clock and title display
	derma.SkinHook( "Paint", "TargetInfo" ) --The labels over items and props.
	derma.SkinHook( "Paint", "TiramisuWeaponSelection" ) --The weapon selection
	derma.SkinHook( "Paint", "PlayerTitles") --The labels above players.
	if !TIRA.FreeScroll and LocalPlayer():Alive() and LocalPlayer():GetAiming() then
		derma.SkinHook( "Paint", "AmmoDisplay" )
		if hook.Call("ShouldDrawLocalPlayer", GAMEMODE) then
			derma.SkinHook( "Paint", "TiramisuCrosshair" ) --The crosshair
		end
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

--3D Door Titles
hook.Add( "PostDrawOpaqueRenderables", "Tiramisu3DDoorTitles", function()
	derma.SkinHook( "Paint", "DoorTitles" )
end)

local sort = false
hook.Add( "PlayerBindPress", "Tiramisu.HandleWeaponSelection", function(ply, bind, pressed)

	if string.match(bind, "attack") then
		if TIRA.ActiveSlot != -1 and TIRA.WeaponTable[TIRA.ActiveSlot] and TIRA.WeaponTable[TIRA.ActiveSlot][TIRA.ActiveWepPos] then
			RunConsoleCommand("rp_selectweapon", TIRA.WeaponTable[TIRA.ActiveSlot][TIRA.ActiveWepPos][2])
			timer.Destroy("TiramisuResetDefaultWep")
			TIRA.ActiveWepPos = -1
			TIRA.ActiveSlot = -1
			return true
		end
	end

	sort = false
	if string.match(bind, "slot1") and pressed then
		TIRA.ActiveSlot = 0
		sort = true
	elseif string.match(bind, "slot2") and pressed then
		TIRA.ActiveSlot = 1
		sort = true
	elseif string.match(bind, "slot3") and pressed then
		TIRA.ActiveSlot = 2
		sort = true
	elseif string.match(bind, "slot4") and pressed then
		TIRA.ActiveSlot = 3
		sort = true
	elseif string.match(bind, "slot5") and pressed then
		TIRA.ActiveSlot = 4
		sort = true
	elseif string.match(bind, "slot6") and pressed then
		TIRA.ActiveSlot = 5
		sort = true
	elseif string.match(bind, "slot7") and pressed then
		TIRA.ActiveSlot = 6
		sort = true
	end

	if sort then
		if TIRA.ActiveSlot != -1 then
			TIRA.BuildWeaponTable()
			if TIRA.WeaponTable[TIRA.ActiveSlot] then
				timer.Create( "TiramisuResetDefaultWep", 3, 1, function()
					TIRA.ActiveWepPos = -1
					TIRA.ActiveSlot = -1
				end)
				if TIRA.ActiveWepPos == -1 then
					TIRA.ActiveWepPos = 1
				end
				TIRA.ActiveWepPos = TIRA.ActiveWepPos + 1
				if !TIRA.WeaponTable[TIRA.ActiveSlot][TIRA.ActiveWepPos] then
					TIRA.ActiveWepPos = 1
				end 
				return true
			end
		end
	end
end)