TIRA.SpawnTable = {}

function TIRA.MaxProps(ply)

	return tonumber(TIRA.ConVars[ "PropLimit" ])
	
end

function TIRA.MaxRagdolls(ply)

	return tonumber(TIRA.ConVars[ "RagdollLimit" ])
	
end

function TIRA.MaxVehicles(ply)

	return tonumber(TIRA.ConVars[ "VehicleLimit" ])
	
end

function TIRA.MaxEffects(ply)

	return tonumber(TIRA.ConVars[ "EffectLimit" ])
	
end

function TIRA.CreateSpawnTable(ply)
	
	TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())] = {}
	
	local spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
	spawntable.props = {}
	spawntable.ragdolls = {}
	spawntable.vehicles = {}
	spawntable.effects = {}

end

function GM:PlayerSpawnProp(ply, mdl)

	local spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
	
	if TIRA.PlayerRank(ply) <= 2 then
		
		if !util.tobool( TIRA.GetPlayerField(ply, "tooltrust") ) and !TIRA.ConVars[ "DefaultPropTrust" ] then -- require tt to spawn stuff.
			TIRA.SendChat(ply, "You are not allowed to spawn anything!")
			return false
		end

		if(!spawntable) then
			TIRA.CreateSpawnTable(ply)
			spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
		end

		local spawned = 0
		for k, v in pairs(spawntable.props) do
			if(v != nil and v:IsValid()) then
				spawned = spawned + 1
			else
				spawntable.props[k] = nil -- No longer exists. Wipe it out.
			end
		end
		
		if(spawned >= TIRA.MaxProps(ply)) then
			TIRA.SendChat(ply, "You have reached your limit! (" .. TIRA.MaxProps(ply) .. ")")
			return false
		else
			return true
		end
		
	else
		TIRA.CreateSpawnTable(ply)
		return true
	end
	
end

function GM:PlayerSpawnRagdoll(ply, mdl)

	local spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
	
	if TIRA.PlayerRank(ply) <= 2 then
	
		if !util.tobool( TIRA.GetPlayerField(ply, "tooltrust") ) and !TIRA.ConVars[ "DefaultPropTrust" ] then
			TIRA.SendChat(ply, "You are not allowed to spawn ragdolls!")
			return false
		end
		
		if(!spawntable) then
			TIRA.CreateSpawnTable(ply)
			spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
		end

		local spawned = 0
		for k, v in pairs(spawntable.ragdolls) do
			if(v != nil and v:IsValid()) then
				spawned = spawned + 1
			else
				spawntable.ragdolls[k] = nil -- No longer exists. Wipe it out.
			end
		end
		if(spawned >= TIRA.MaxRagdolls(ply)) then
			TIRA.SendChat(ply, "You have reached your limit! (" .. TIRA.MaxRagdolls(ply) .. ")")
			return false
		else
			return true
		end
	else
		TIRA.CreateSpawnTable(ply)
		return true
	end
	
end

function GM:PlayerSpawnVehicle(ply)

	local spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
	
	if TIRA.PlayerRank(ply) <= 2 then

		if !util.tobool( TIRA.GetPlayerField(ply, "tooltrust") ) and !TIRA.ConVars[ "DefaultVehicles" ] then
			TIRA.SendChat(ply, "You are not allowed to spawn vehicles!")
			return false
		end

		if(!spawntable) then
			TIRA.CreateSpawnTable(ply)
			spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
		end

		local spawned = 0

		for k, v in pairs(spawntable.vehicles) do
			if(v != nil and v:IsValid()) then
				spawned = spawned + 1
			else
				spawntable.vehicles[k] = nil -- No longer exists. Wipe it out.
			end
		end
		
		if(spawned >= TIRA.MaxVehicles(ply)) then
			TIRA.SendChat(ply, "You have reached your limit! (" .. TIRA.MaxVehicles(ply) .. ")")
			return false
		else
			return true
		end
			
	
	else
		TIRA.CreateSpawnTable(ply)
		return true
	end
	
end

function GM:PlayerSpawnNPC( ply, class )

	return TIRA.PlayerRank( ply ) > 0

end


function GM:PlayerSpawnEffect(ply, mdl)

	local spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
	
	if TIRA.PlayerRank(ply) <= 2 then
	
		if(!tobool(TIRA.GetPlayerField(ply, "tooltrust")) and !TIRA.ConVars[ "DefaultPropTrust" ]) then
			TIRA.SendChat(ply, "You are not allowed to spawn effects!" )
			return false
		end
		
		if(!spawntable) then
			TIRA.CreateSpawnTable(ply)
			spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
		end
		
		local spawned = 0
		
		for k, v in pairs(spawntable.effects) do
			if(v and v:IsValid()) then
				spawned = spawned + 1
			else
				spawntable.effects[k] = nil -- No longer exists. Wipe it out.
			end
		end
		
		if(spawned >= TIRA.MaxEffects(ply)) then
			TIRA.SendChat(ply, "You have reached your limit! (" .. TIRA.MaxEffects(ply) .. ")")
			return false
		else
			return true
		end
		
	else
		TIRA.CreateSpawnTable(ply)
		return true
	end
	
end

function GM:PlayerSpawnedProp(ply, mdl, ent)

	local spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
	table.insert(spawntable.props, ent)
	
end

function GM:PlayerSpawnedRagdoll(ply, mdl, ent)

	local spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
	table.insert(spawntable.ragdolls, ent)
	
end

function GM:PlayerSpawnedVehicle(ply, ent)

	local spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
	table.insert(spawntable.vehicles, ent)
	
end

function GM:PlayerSpawnedEffect(ply, mdl, ent)

	local spawntable = TIRA.SpawnTable[TIRA.FormatText(ply:SteamID())]
	table.insert(spawntable.effects, ent)
	
end

hook.Add( "PlayerLoadout", "TiramisuTooltrustLoadout", function( ply )

	if(!util.tobool(TIRA.GetPlayerField(ply, "tooltrust"))) then

		if TIRA.ConVars[ "DefaultGravgun" ] then
			ply:Give("weapon_physcannon")
		end
		if TIRA.ConVars[ "DefaultPhysgun" ] then
			ply:Give("weapon_physgun")
		end

	else
	
		ply:Give("gmod_tool")
		ply:Give("weapon_physcannon")
		ply:Give("weapon_physgun")
	
	end

end)

function Admin_Tooltrust(ply, cmd, args)

	if(#args != 2) then
	
		TIRA.SendChat( ply, "Invalid number of arguments! ( rp_admin tooltrust \"name\" value )" )
		return

	end
	
	local target = TIRA.FindPlayer(args[1])
	
	if !(target and target:IsValid() and target:IsTiraPlayer()) then
		TIRA.SendChat( ply, "Target not found!" )
		return
	end

	local toggle = util.tobool(args[2])

	if toggle then
		TIRA.SetPlayerField(target, "tooltrust", 1)
		TIRA.SendChat( target, "You have been granted tooltrust by " .. ply:Name() )
		TIRA.SendChat( ply, target:Name() .. " [" .. target:SteamID() .. "] | " .. target:Nick() .. " has been granted tooltrust" )

		if !TIRA.ConVars[ "DefaultPhysgun" ] then
			target:Give("weapon_physgun")
		end
		if !TIRA.ConVars[ "DefaultGravgun" ] then
			target:Give("weapon_physgun")
		end
		target:Give("gmod_tool")
	else
		TIRA.SetPlayerField(target, "tooltrust", 0)
		TIRA.SendChat( target, "Your tooltrust has been removed by " .. ply:Name() )
		TIRA.SendChat( ply, target:Name() .. " [" .. target:SteamID() .. "] | " .. target:Nick() .. " has been removed from tooltrust" )
		
		target:StripWeapon("gmod_tool")
		if !TIRA.ConVars[ "DefaultPhysgun" ] then
			target:StripWeapon("weapon_physgun")
		end
		if !TIRA.ConVars[ "DefaultGravgun" ] then
			target:StripWeapon("weapon_physgun")
		end
	end

end


hook.Add( "PhysgunPickup", "TiramisuPhysgunPickup", function( ply, ent )
	if TIRA.IsDoor( ent ) then
		return false
	end

	if ValidEntity(ent) then
		if ent:IsTiraPlayer() or ent:GetClass() == "item_prop" then
			return TIRA.PlayerRank(ply) > 0
		end
	end

end)

function PLUGIN.Init()

	TIRA.AddDataField( 1, "tooltrust", TIRA.ConVars[ "DefaultToolTrust" ] ) -- Is the player allowed to have the toolgun
	
	TIRA.AdminCommand( "tooltrust", Admin_Tooltrust, "Change someones tooltrust", true, true, 3 )
	
end