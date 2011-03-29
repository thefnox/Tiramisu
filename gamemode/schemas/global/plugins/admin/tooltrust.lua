PLUGIN.Name = "Tool Trust"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "Toolgun permissions, as well as physgun ban."; -- The description or purpose of the plugin

SpawnTable = {};

function CAKE.MaxProps(ply)

	return tonumber(CAKE.ConVars[ "PropLimit" ]) + tonumber(CAKE.GetPlayerField(ply, "tooltrust") * 20);
	
end

function CAKE.MaxRagdolls(ply)

	return tonumber(CAKE.ConVars[ "RagdollLimit" ]) + tonumber(CAKE.GetPlayerField(ply, "tooltrust") * 4);
	
end

function CAKE.MaxVehicles(ply)

	return tonumber(CAKE.ConVars[ "VehicleLimit" ]) + tonumber(CAKE.GetPlayerField(ply, "tooltrust") - 3 );
	
end

function CAKE.MaxEffects(ply)

	return tonumber(CAKE.ConVars[ "EffectLimit" ]) + tonumber(CAKE.GetPlayerField(ply, "tooltrust") * 3);
	
end

function CAKE.CreateSpawnTable(ply)
	
	SpawnTable[CAKE.FormatText(ply:SteamID())] = {};
	
	local spawntable = SpawnTable[CAKE.FormatText(ply:SteamID())];
	spawntable.props = {};
	spawntable.ragdolls = {};
	spawntable.vehicles = {};
	spawntable.effects = {};

end

function GM:PlayerSpawnProp(ply, mdl)

	local spawntable = SpawnTable[CAKE.FormatText(ply:SteamID())];
	
	if CAKE.PlayerRank(ply) <= 2 then
		
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
		
	else
	
		CAKE.CreateSpawnTable(ply)
		return true;
		
	end
	
end

function GM:PlayerSpawnRagdoll(ply, mdl)

	local spawntable = SpawnTable[CAKE.FormatText(ply:SteamID())];
	
	if CAKE.PlayerRank(ply) <= 2 then
	
		if( tonumber( CAKE.GetPlayerField(ply, "tooltrust") ) <= 1 ) then
		
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
		
	else
	
		CAKE.CreateSpawnTable(ply)
		return true;
		
	end
	
end

function GM:PlayerSpawnVehicle(ply)

	local spawntable = SpawnTable[CAKE.FormatText(ply:SteamID())];
	
	if CAKE.PlayerRank(ply) <= 2 then
	
		if(CAKE.GetPlayerField(ply, "tooltrust") <= 4) then
		
			CAKE.SendChat(ply, "You are not allowed to spawn vehicles!");
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
	
	else
	
		CAKE.CreateSpawnTable(ply)
		return true;
	
	end
	
end

function GM:PlayerSpawnEffect(ply, mdl)

	local spawntable = SpawnTable[CAKE.FormatText(ply:SteamID())];
	
	if CAKE.PlayerRank(ply) <= 2 then
	
		if(CAKE.GetPlayerField(ply, "tooltrust") <= 1) then
		
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
		
	else
	
		CAKE.CreateSpawnTable(ply)
		return true;
		
	end
	
end

function GM:PlayerSpawnedProp(ply, mdl, ent)

	local spawntable = SpawnTable[CAKE.FormatText(ply:SteamID())];
	table.insert(spawntable.props, ent);
	
end

function GM:PlayerSpawnedRagdoll(ply, mdl, ent)

	local spawntable = SpawnTable[CAKE.FormatText(ply:SteamID())];
	table.insert(spawntable.ragdolls, ent);
	
end

function GM:PlayerSpawnedVehicle(ply, ent)

	local spawntable = SpawnTable[CAKE.FormatText(ply:SteamID())];
	table.insert(spawntable.vehicles, ent);
	
end

function GM:PlayerSpawnedEffect(ply, mdl, ent)

	local spawntable = SpawnTable[CAKE.FormatText(ply:SteamID())];
	table.insert(spawntable.effects, ent);
	
end

hook.Add( "PlayerLoadout", "TiramisuTooltrustLoadout", function( ply )

	if(tostring(CAKE.GetPlayerField(ply, "tooltrust")) >= "0") then
	
		ply:Give("weapon_physcannon");
	
	end
	
	if(tostring(CAKE.GetPlayerField(ply, "tooltrust")) >= "1" or CAKE.PlayerRank(ply) >= 3 ) then
	
		ply:Give("gmod_tool");
		ply:Give("weapon_physcannon");
		ply:Give("weapon_physgun");
	
	end

end)

function Admin_Tooltrust(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin tooltrust \"name\" value )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
		CAKE.SetPlayerField(target, "tooltrust", tonumber(args[2]));
		CAKE.SendChat( target, "Your TT Level has been set to " .. args[2] .. " by " .. ply:Name() );
		CAKE.SendChat( ply, target:Name() .. " [" .. target:SteamID() .. "] | " .. target:Nick() .. "'s TT Level has been set to " .. args[2] );
		
	if( tonumber(args[2]) <= 0 ) then
		
		target:StripWeapon("gmod_tool");
		target:StripWeapon("weapon_physgun");
	
	else	
	
		target:Give("weapon_physgun");
		target:Give("gmod_tool");
	
	end
	
	if( tonumber(args[2]) <= -1 ) then
		
	target:StripWeapon("weapon_physcannon");
	
	else	
	
	target:Give("weapon_physcannon");
	
	end
	
end

function PLUGIN.Init()

	CAKE.ConVars[ "PropLimit" ] = 20;
	CAKE.ConVars[ "RagdollLimit" ] = 1;
	CAKE.ConVars[ "VehicleLimit" ] = 0;
	CAKE.ConVars[ "EffectLimit" ] = 1;
	CAKE.ConVars[ "Default_Tooltrust" ] = 0; -- Are players allowed to have the toolgun when they first start.
	
	CAKE.AddDataField( 1, "tooltrust", CAKE.ConVars[ "Default_Tooltrust" ] ); -- Is the player allowed to have the toolgun
	
	CAKE.AdminCommand( "tooltrust", Admin_Tooltrust, "Change someones tooltrust", true, true, 3 );
	
end