PLUGIN.Name = "Limits"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "Limit prop, ragdoll, vehicle, and effect limits on a player by player basis. Useful for donators."; -- The description or purpose of the plugin

SpawnTable = {};

function CAKE.MaxProps(ply)

	return tonumber(CAKE.ConVars[ "PropLimit" ]) + tonumber(CAKE.GetPlayerField(ply, "extraprops"));
	
end

function CAKE.MaxRagdolls(ply)

	return tonumber(CAKE.ConVars[ "RagdollLimit" ]) + tonumber(CAKE.GetPlayerField(ply, "extraragdolls"));
	
end

function CAKE.MaxVehicles(ply)

	return tonumber(CAKE.ConVars[ "VehicleLimit" ]) + tonumber(CAKE.GetPlayerField(ply, "extravehicles"));
	
end

function CAKE.MaxEffects(ply)

	return tonumber(CAKE.ConVars[ "EffectLimit" ]) + tonumber(CAKE.GetPlayerField(ply, "extraeffects"));
	
end

function CAKE.CreateSpawnTable(ply)
	
	SpawnTable[CAKE.FormatSteamID(ply:SteamID())] = {};
	
	local spawntable = SpawnTable[CAKE.FormatSteamID(ply:SteamID())];
	spawntable.props = {};
	spawntable.ragdolls = {};
	spawntable.vehicles = {};
	spawntable.effects = {};

end

function GM:PlayerSpawnProp(ply, mdl)

	local spawntable = SpawnTable[CAKE.FormatSteamID(ply:SteamID())];
	
	if(CAKE.GetPlayerField(ply, "proptrust") != 1) then
	
		CAKE.SendChat(ply, "You are not allowed to spawn anything!");
		return false;
		
	end
	
	if(spawntable != nil) then
	
		local spawned = 0;
		
		for k, v in pairs(spawntable.props) do
		
			if(v != nil and v:IsValid()) then
			
				spawned = spawned + 1;
			
			else
			
				spawntable.props[k] = nil; -- No longer exists. Wipe it out.
			
			end
			
		end
		
		if(spawned >= CAKE.MaxProps(ply)) then
		
			CAKE.SendChat(ply, "You have reached your limit! (" .. CAKE.MaxProps(ply) .. ")");
			return false;
			
		else
		
			return true;
			
		end
		
	else

		CAKE.CreateSpawnTable(ply)
		return true;
		
	end
	
end

function GM:PlayerSpawnRagdoll(ply, mdl)

	local spawntable = SpawnTable[CAKE.FormatSteamID(ply:SteamID())];
	
	if(CAKE.GetPlayerField(ply, "proptrust") != 1) then
	
		CAKE.SendChat(ply, "You are not allowed to spawn anything!");
		return false;
		
	end
	
	if(spawntable != nil) then
	
		local spawned = 0;
		
		for k, v in pairs(spawntable.ragdolls) do
		
			if(v != nil and v:IsValid()) then
			
				spawned = spawned + 1;
			
			else
			
				spawntable.ragdolls[k] = nil; -- No longer exists. Wipe it out.
			
			end
			
		end
		
		if(spawned >= CAKE.MaxRagdolls(ply)) then
		
			CAKE.SendChat(ply, "You have reached your limit! (" .. CAKE.MaxRagdolls(ply) .. ")");
			return false;
			
		else
		
			return true;
			
		end
		
	else

		CAKE.CreateSpawnTable(ply)
		return true;
		
	end
	
end

function GM:PlayerSpawnVehicle(ply)

	local spawntable = SpawnTable[CAKE.FormatSteamID(ply:SteamID())];
	
	if(CAKE.GetPlayerField(ply, "proptrust") != 1) then
	
		CAKE.SendChat(ply, "You are not allowed to spawn anything!");
		return false;
		
	end
	
	if(spawntable != nil) then
	
		local spawned = 0;
		
		for k, v in pairs(spawntable.vehicles) do
		
			if(v != nil and v:IsValid()) then
			
				spawned = spawned + 1;
			
			else
			
				spawntable.vehicles[k] = nil; -- No longer exists. Wipe it out.
			
			end
			
		end
		
		if(spawned >= CAKE.MaxVehicles(ply)) then
		
			CAKE.SendChat(ply, "You have reached your limit! (" .. CAKE.MaxVehicles(ply) .. ")");
			return false;
			
		else
		
			return true;
			
		end
		
	else

		CAKE.CreateSpawnTable(ply)
		return true;
		
	end
	
end

function GM:PlayerSpawnEffect(ply, mdl)

	local spawntable = SpawnTable[CAKE.FormatSteamID(ply:SteamID())];
	
	if(CAKE.GetPlayerField(ply, "proptrust") != 1) then
	
		CAKE.SendChat(ply, "You are not allowed to spawn anything!");
		return false;
		
	end
	
	if(spawntable != nil) then
	
		local spawned = 0;
		
		for k, v in pairs(spawntable.effects) do
		
			if(v != nil and v:IsValid()) then
			
				spawned = spawned + 1;
			
			else
			
				spawntable.effects[k] = nil; -- No longer exists. Wipe it out.
			
			end
			
		end
		
		if(spawned >= CAKE.MaxEffects(ply)) then
		
			CAKE.SendChat(ply, "You have reached your limit! (" .. CAKE.MaxEffects(ply) .. ")");
			return false;
			
		else
		
			return true;
			
		end
		
	else

		CAKE.CreateSpawnTable(ply)
		return true;
		
	end
	
end

function GM:PlayerSpawnedProp(ply, mdl, ent)

	local spawntable = SpawnTable[CAKE.FormatSteamID(ply:SteamID())];
	table.insert(spawntable.props, ent);
	
end

function GM:PlayerSpawnedRagdoll(ply, mdl, ent)

	local spawntable = SpawnTable[CAKE.FormatSteamID(ply:SteamID())];
	table.insert(spawntable.ragdolls, ent);
	
end

function GM:PlayerSpawnedVehicle(ply, ent)

	local spawntable = SpawnTable[CAKE.FormatSteamID(ply:SteamID())];
	table.insert(spawntable.vehicles, ent);
	
end

function GM:PlayerSpawnedEffect(ply, mdl, ent)

	local spawntable = SpawnTable[CAKE.FormatSteamID(ply:SteamID())];
	table.insert(spawntable.effects, ent);
	
end

function Admin_ExtraProps(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin extraprops \"name\" amount )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	CAKE.SetPlayerField(target, "extraprops", tonumber(args[2]));
	CAKE.SendChat( target, "Your extra props has been set to " .. args[2] .. " by " .. ply:Name());
	CAKE.SendChat( ply, target:Name() .. "'s extra prop limit has been set to " .. args[2] );
	
end

function Admin_ExtraRagdolls(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin extraragdolls \"name\" amount )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	CAKE.SetPlayerField(target, "extraragdolls", tonumber(args[2]));
	CAKE.SendChat( target, "Your extra ragdolls has been set to " .. args[2] .. " by " .. ply:Name());
	CAKE.SendChat( ply, target:Name() .. "'s extra ragdolls  has been set to " .. args[2] );
	
end

function Admin_ExtraVehicles(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin extravehicles \"name\" amount )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	CAKE.SetPlayerField(target, "extravehicles", tonumber(args[2]));
	CAKE.SendChat( target, "Your extra vehicles has been set to " .. args[2] .. " by " .. ply:Name());
	CAKE.SendChat( ply, target:Name() .. "'s extra vehicle limit has been set to " .. args[2] );
	
end

function Admin_ExtraEffects(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin extraprops \"name\" amount )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	CAKE.SetPlayerField(target, "extraeffects", tonumber(args[2]));
	CAKE.SendChat( target, "Your extra effects has been set to " .. args[2] .. " by " .. ply:Name());
	CAKE.SendChat( ply, target:Name() .. "'s extra effects limit has been set to " .. args[2] );
	
end

function PLUGIN.Init()

	CAKE.ConVars[ "Default_Extraprops" ] = 0;
	CAKE.ConVars[ "Default_Extraragdolls" ] = 0;
	CAKE.ConVars[ "Default_Extravehicles" ] = 0;
	CAKE.ConVars[ "Default_Extraeffects" ] = 0;
	
	CAKE.ConVars[ "PropLimit" ] = 30;
	CAKE.ConVars[ "RagdollLimit" ] = 0;
	CAKE.ConVars[ "VehicleLimit" ] = 0;
	CAKE.ConVars[ "EffectLimit" ] = 0;
	
	CAKE.AddDataField( 1, "extraprops", CAKE.ConVars[ "Default_Extraprops" ] );
	CAKE.AddDataField( 1, "extraragdolls", CAKE.ConVars[ "Default_Extraragdolls" ] );
	CAKE.AddDataField( 1, "extravehicles", CAKE.ConVars[ "Default_Extravehicles" ] );
	CAKE.AddDataField( 1, "extraeffects", CAKE.ConVars[ "Default_Extraeffects" ] );
	
	CAKE.AdminCommand( "extraprops", Admin_ExtraProps, "Change someones extra props limit", true, true, 3 );
	CAKE.AdminCommand( "extraragdolls", Admin_ExtraRagdolls, "Change someones extra ragdolls limit", true, true, 3 );
	CAKE.AdminCommand( "extravehicles", Admin_ExtraVehicles, "Change someones extra vehicles limit", true, true, 3 );
	CAKE.AdminCommand( "extraeffects", Admin_ExtraEffects, "Change someones extra effects limit", true, true, 3 );
	
end