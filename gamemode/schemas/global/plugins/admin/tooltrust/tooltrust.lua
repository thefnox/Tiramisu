CAKE.SpawnTable = {}

function CAKE.MaxProps(ply)

	return tonumber(CAKE.ConVars[ "PropLimit" ])
	
end

function CAKE.MaxRagdolls(ply)

	return tonumber(CAKE.ConVars[ "RagdollLimit" ])
	
end

function CAKE.MaxVehicles(ply)

	return tonumber(CAKE.ConVars[ "VehicleLimit" ])
	
end

function CAKE.MaxEffects(ply)

	return tonumber(CAKE.ConVars[ "EffectLimit" ])
	
end

function CAKE.CreateSpawnTable(ply)
	
	CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())] = {}
	
	local spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
	spawntable.props = {}
	spawntable.ragdolls = {}
	spawntable.vehicles = {}
	spawntable.effects = {}

end

function GM:PlayerSpawnProp(ply, mdl)

	local spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
	
	if CAKE.PlayerRank(ply) <= 2 then
		
		if !util.tobool( CAKE.GetPlayerField(ply, "tooltrust") ) and !CAKE.ConVars[ "DefaultPropTrust" ] then -- require tt to spawn stuff.
			CAKE.SendChat(ply, "You are not allowed to spawn anything!")
			return false
		end

		if(!spawntable) then
			CAKE.CreateSpawnTable(ply)
			spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
		end

		local spawned = 0
		for k, v in pairs(spawntable.props) do
			if(v != nil and v:IsValid()) then
				spawned = spawned + 1
			else
				spawntable.props[k] = nil -- No longer exists. Wipe it out.
			end
		end
		
		if(spawned >= CAKE.MaxProps(ply)) then
			CAKE.SendChat(ply, "You have reached your limit! (" .. CAKE.MaxProps(ply) .. ")")
			return false
		else
			return true
		end
		
	else
		CAKE.CreateSpawnTable(ply)
		return true
	end
	
end

function GM:PlayerSpawnRagdoll(ply, mdl)

	local spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
	
	if CAKE.PlayerRank(ply) <= 2 then
	
		if !util.tobool( CAKE.GetPlayerField(ply, "tooltrust") ) and !CAKE.ConVars[ "DefaultPropTrust" ] then
			CAKE.SendChat(ply, "You are not allowed to spawn ragdolls!")
			return false
		end
		
		if(!spawntable) then
			CAKE.CreateSpawnTable(ply)
			spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
		end

		local spawned = 0
		for k, v in pairs(spawntable.ragdolls) do
			if(v != nil and v:IsValid()) then
				spawned = spawned + 1
			else
				spawntable.ragdolls[k] = nil -- No longer exists. Wipe it out.
			end
		end
		if(spawned >= CAKE.MaxRagdolls(ply)) then
			CAKE.SendChat(ply, "You have reached your limit! (" .. CAKE.MaxRagdolls(ply) .. ")")
			return false
		else
			return true
		end
	else
		CAKE.CreateSpawnTable(ply)
		return true
	end
	
end

function GM:PlayerSpawnVehicle(ply)

	local spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
	
	if CAKE.PlayerRank(ply) <= 2 then

		if !util.tobool( CAKE.GetPlayerField(ply, "tooltrust") ) and !CAKE.ConVars[ "DefaultVehicles" ] then
			CAKE.SendChat(ply, "You are not allowed to spawn vehicles!")
			return false
		end

		if(!spawntable) then
			CAKE.CreateSpawnTable(ply)
			spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
		end

		local spawned = 0

		for k, v in pairs(spawntable.vehicles) do
			if(v != nil and v:IsValid()) then
				spawned = spawned + 1
			else
				spawntable.vehicles[k] = nil -- No longer exists. Wipe it out.
			end
		end
		
		if(spawned >= CAKE.MaxVehicles(ply)) then
			CAKE.SendChat(ply, "You have reached your limit! (" .. CAKE.MaxVehicles(ply) .. ")")
			return false
		else
			return true
		end
			
	
	else
		CAKE.CreateSpawnTable(ply)
		return true
	end
	
end

function GM:PlayerSpawnNPC( ply, class )

	return CAKE.PlayerRank( ply ) > 0

end


function GM:PlayerSpawnEffect(ply, mdl)

	local spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
	
	if CAKE.PlayerRank(ply) <= 2 then
	
		if(!tobool(CAKE.GetPlayerField(ply, "tooltrust")) and !CAKE.ConVars[ "DefaultPropTrust" ]) then
			CAKE.SendChat(ply, "You are not allowed to spawn effects!" )
			return false
		end
		
		if(!spawntable) then
			CAKE.CreateSpawnTable(ply)
			spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
		end
		
		local spawned = 0
		
		for k, v in pairs(spawntable.effects) do
			if(v and v:IsValid()) then
				spawned = spawned + 1
			else
				spawntable.effects[k] = nil -- No longer exists. Wipe it out.
			end
		end
		
		if(spawned >= CAKE.MaxEffects(ply)) then
			CAKE.SendChat(ply, "You have reached your limit! (" .. CAKE.MaxEffects(ply) .. ")")
			return false
		else
			return true
		end
		
	else
		CAKE.CreateSpawnTable(ply)
		return true
	end
	
end

function GM:PlayerSpawnedProp(ply, mdl, ent)

	local spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
	table.insert(spawntable.props, ent)
	
end

function GM:PlayerSpawnedRagdoll(ply, mdl, ent)

	local spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
	table.insert(spawntable.ragdolls, ent)
	
end

function GM:PlayerSpawnedVehicle(ply, ent)

	local spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
	table.insert(spawntable.vehicles, ent)
	
end

function GM:PlayerSpawnedEffect(ply, mdl, ent)

	local spawntable = CAKE.SpawnTable[CAKE.FormatText(ply:SteamID())]
	table.insert(spawntable.effects, ent)
	
end

hook.Add( "PlayerLoadout", "TiramisuTooltrustLoadout", function( ply )

	if(!util.tobool(CAKE.GetPlayerField(ply, "tooltrust"))) then

		if CAKE.ConVars[ "DefaultGravgun" ] then
			ply:Give("weapon_physcannon")
		end
		if CAKE.ConVars[ "DefaultPhysgun" ] then
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
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin tooltrust \"name\" value )" )
		return

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if !(target and target:IsValid() and target:IsTiraPlayer()) then
		CAKE.SendChat( ply, "Target not found!" )
		return
	end

	local toggle = util.tobool(args[2])

	if toggle then
		CAKE.SetPlayerField(target, "tooltrust", 1)
		CAKE.SendChat( target, "You have been granted tooltrust by " .. ply:Name() )
		CAKE.SendChat( ply, target:Name() .. " [" .. target:SteamID() .. "] | " .. target:Nick() .. " has been granted tooltrust" )

		if !CAKE.ConVars[ "DefaultPhysgun" ] then
			target:Give("weapon_physgun")
		end
		if !CAKE.ConVars[ "DefaultGravgun" ] then
			target:Give("weapon_physgun")
		end
		target:Give("gmod_tool")
	else
		CAKE.SetPlayerField(target, "tooltrust", 0)
		CAKE.SendChat( target, "Your tooltrust has been removed by " .. ply:Name() )
		CAKE.SendChat( ply, target:Name() .. " [" .. target:SteamID() .. "] | " .. target:Nick() .. " has been removed from tooltrust" )
		
		target:StripWeapon("gmod_tool")
		if !CAKE.ConVars[ "DefaultPhysgun" ] then
			target:StripWeapon("weapon_physgun")
		end
		if !CAKE.ConVars[ "DefaultGravgun" ] then
			target:StripWeapon("weapon_physgun")
		end
	end

end


hook.Add( "PhysgunPickup", "TiramisuPhysgunPickup", function( ply, ent )
	if CAKE.IsDoor( ent ) then
		return false
	end

	if ValidEntity(ent) then
		if ent:IsTiraPlayer() or ent:GetClass() == "item_prop" then
			return CAKE.PlayerRank(ply) > 0
		end
	end

end)

function PLUGIN.Init()

	CAKE.AddDataField( 1, "tooltrust", CAKE.ConVars[ "DefaultToolTrust" ] ) -- Is the player allowed to have the toolgun
	
	CAKE.AdminCommand( "tooltrust", Admin_Tooltrust, "Change someones tooltrust", true, true, 3 )
	
end