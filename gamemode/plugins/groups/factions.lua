CAKE.Factions = {}

--Returns true if the name introduced is currently assigned to a group
function CAKE.GroupHandlerExists( handler )
	for id, group in pairs( CAKE.Groups ) do
		if group and group:GetField( "handler" ) == handler then
			return true
		end
	end
	return false
end

function CAKE.FindByHandler( handler )
	for id, group in pairs( CAKE.Groups ) do
		if group and group:GetField( "handler" ) == handler then
			return group
		end
	end	
	return false
end

--Saves all factions
function CAKE.SaveFactions()
	file.Write(CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/factions.txt", glon.encode(CAKE.Factions))
end

function CAKE.SaveFactions()
	CAKE.SerializeFile(CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/factions.txt", CAKE.Factions)
end

--Loads all factions
function CAKE.LoadAllFactions()
	if file.Exists( CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/factions.txt", "DATA" ) then
		-- CAKE.Factions = glon.decode(file.Read(CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/factions.txt"))
		CAKE.Factions = CAKE.DeserializeFile(CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/factions.txt")
		local groupexists, fileexists
		for k, v in pairs( CAKE.Factions ) do
			groupexists, fileexists = CAKE.GroupExists( v )
			if !groupexists and fileexists then
				print( "Loading Faction", v )
				CAKE.LoadGroup( v )
				CAKE.Factions[CAKE.Groups[v]:Name()] = v
			elseif !groupexists and !fileexists then
				print( "Removing Faction", v )
				CAKE.Factions[k] = nil
			end
		end
		CAKE.SaveFactions()
	end
end

--Creates a new faction object and stores it on the table
function CAKE.CreateFaction( name, shorthand, description )
	if !CAKE.GroupNameExists( name ) and !CAKE.GroupHandlerExists( shorthand ) then
		local group = CAKE.CreateGroup()
		group:SetField( "name", name )
		group:SetField( "description", description )
		group:SetField( "founder", "" )
		group:SetField( "handler", shorthand )
		group:SetField( "type", "faction" )
		group:Save()
		CAKE.Factions[group:Name()] = group.UniqueID
		CAKE.SaveFactions()
		return group
	end
	return false
end

function CAKE.AddFactionRank( faction, name, handler, description, level, weapons, items, permissions )
	level = level or 0
	weapons = weapons or {}
	items = items or {}
	permissions = permissions or {}
	if CAKE.GroupHandlerExists( faction ) then
		group = CAKE.FindByHandler( faction )
		if group and !group:IsRank( handler ) then
			group:AddRank( handler )
			group:SetRankField( handler, "name", name, true )
			group:SetRankField( handler, "description", description, true )
			group:SetRankField( handler, "level", level, true )
			group:SetRankField( handler, "loadout", items, true )
			group:SetRankField( handler, "weapons", weapons, true )
			for k, v in pairs( permissions ) do
				group:SetRankField( handler, k, v, true )
			end
			if group:GetField( "defaultrank" ) == "none" then
				group:SetField( "defaultrank", handler )
			end
			group:Save()
		end
	end
end

function CAKE.SendFactionList( ply )
	--datastream.StreamToClients( ply, "Tiramisu.ReceiveFactions", CAKE.Factions )
	net.Start( "Tiramisu.ReceiveFactions" )
		net.WriteTable( CAKE.Factions )
	net.Send( ply )
end

-- datastream.Hook( "Tiramisu.GetEditFaction", function(ply, handler, id, encoded, decoded)
net.Receive( "Tiramisu.GetEditFaction", function( len, ply )
	local decoded = net.ReadTable( )
	local group = CAKE.GetGroup( decoded.uid or "none" )
	if group and CAKE.PlayerRank(ply) > 3 then
		if group:Name() != decoded.name and CAKE.GroupNameExists( decoded.name ) then
			CAKE.SendError( ply, "Faction name exists! Please choose another name" )
			-- datastream.StreamToClients( ply, "Tiramisu.EditFaction", decoded)
			net.Start( "Tiramisu.EditFaction" )
				net.WriteTable( decoded )
			net.Send( ply )
		elseif group:GetField( "handler" ) != decoded.handler and CAKE.GroupHandlerExists( decoded.handler ) then
			CAKE.SendError( ply, "Faction handler exists! Please choose another shorthand for your faction" )
			-- datastream.StreamToClients( ply, "Tiramisu.EditFaction", decoded)
			net.Start( "Tiramisu.EditFaction" )
				net.WriteTable( decoded )
			net.Send( ply )
		else
			group:SetField("name", decoded.name)
			group:SetField("handler", decoded.handler)
			group:SetField("description", decoded.description)
			group:SetField("ranks", decoded.ranks)
			group:SetField("defaultrank", decoded.defaultrank)
			group:SetField("spawngroup", decoded.spawngroup)
			group:SetField("doorgroup", decoded.doorgroup)
		end
	end
end)

concommand.Add( "rp_createfaction", function( ply, cmd, args )
	if CAKE.PlayerRank(ply) > 3 then
		local name = table.concat( args, " " )
		if CAKE.GroupNameExists( name ) then
			umsg.Start( "Tiramisu.FactionCreateQuery", ply )
				umsg.String( name )
			umsg.End()
			CAKE.SendError( ply, "Group already exists! Please choose another name." )
		else
			local group = CAKE.CreateGroup()
			group:SetField( "name", name )
			group:SetField( "type", "faction" )
			group:Save()
			CAKE.Factions[group:Name()] = group.UniqueID
			CAKE.SaveFactions()
			local uid = group.UniqueID

			local tbl = {
				["name"] = group:Name(),
				["handler"] = group:GetField( "handler" ),
				["defaultrank"] = group:GetField( "defaultrank" ),
				["description"] = group:GetField( "description" ),
				["doorgroup"] = group:GetField( "doorgroup" ),
				["spawngroup"] = group:GetField( "spawngroup" ),
				["uid"] = group.UniqueID,
				["ranks"] = {}
			}
			for k, v in pairs( group:GetField( "ranks" ) ) do
				tbl["ranks"][k] = {}
				tbl["ranks"][k]["weapons"] = group:GetRankField( k, "weapons" )
				tbl["ranks"][k]["loadout"] = group:GetRankField( k, "loadout" )
				tbl["ranks"][k]["caninvite"] = group:GetRankField( k, "caninvite" )
				tbl["ranks"][k]["cankick"] = group:GetRankField( k, "cankick" )
				tbl["ranks"][k]["canpromote"] = group:GetRankField( k, "canpromote" )
				tbl["ranks"][k]["cantakeinventory"] = group:GetRankField( k, "cantakeinventory" )
				tbl["ranks"][k]["canplaceinventory"] = group:GetRankField( k, "canplaceinventory" )
				tbl["ranks"][k]["level"] = group:GetRankField( k, "level" )
				tbl["ranks"][k]["name"] = group:GetRankField( k, "name" )
				tbl["ranks"][k]["handler"] = group:GetRankField( k, "handler" )
				tbl["ranks"][k]["description"] = group:GetRankField( k, "description" )
			end
			CAKE.SendFactionList( ply )
			-- datastream.StreamToClients( ply, "Tiramisu.EditFaction", tbl)
			net.Start( "Tiramisu.EditFaction" )
				net.WriteTable( tbl )
			net.Send( ply )
		end
	end
end)

concommand.Add( "rp_editfaction", function( ply, cmd, args )
	local id = args[1]
	if CAKE.GroupExists( id ) then
		local group = CAKE.GetGroup( id )
		if CAKE.PlayerRank(ply) > 3 then
			local tbl = {
				["name"] = group:Name(),
				["handler"] = group:GetField( "handler" ),
				["defaultrank"] = group:GetField( "defaultrank" ),
				["description"] = group:GetField( "description" ),
				["doorgroup"] = group:GetField( "doorgroup" ),
				["spawngroup"] = group:GetField( "spawngroup" ),
				["uid"] = group.UniqueID,
				["ranks"] = {}
			}
			for k, v in pairs( group:GetField( "ranks" ) ) do
				tbl["ranks"][k] = {}
				tbl["ranks"][k]["weapons"] = group:GetRankField( k, "weapons" )
				tbl["ranks"][k]["loadout"] = group:GetRankField( k, "loadout" )
				tbl["ranks"][k]["caninvite"] = group:GetRankField( k, "caninvite" )
				tbl["ranks"][k]["cankick"] = group:GetRankField( k, "cankick" )
				tbl["ranks"][k]["canpromote"] = group:GetRankField( k, "canpromote" )
				tbl["ranks"][k]["cantakeinventory"] = group:GetRankField( k, "cantakeinventory" )
				tbl["ranks"][k]["canplaceinventory"] = group:GetRankField( k, "canplaceinventory" )
				tbl["ranks"][k]["level"] = group:GetRankField( k, "level" )
				tbl["ranks"][k]["name"] = group:GetRankField( k, "name" )
				tbl["ranks"][k]["handler"] = group:GetRankField( k, "handler" )
				tbl["ranks"][k]["description"] = group:GetRankField( k, "description" )
			end

			-- datastream.StreamToClients( ply, "Tiramisu.EditFaction", tbl)
			net.Start( "Tiramisu.EditFaction" )
				net.WriteTable( tbl )
			net.Send( ply )
		end 
	end
end)

concommand.Add( "rp_getfactioninfo", function( ply, cmd, args )
	local id = args[1]
	if CAKE.GroupExists( id ) then
		local group = CAKE.GetGroup( id )
		local tbl = {}
		if group:CharInGroup( ply ) and group:GetField("type") == "faction" then
			tbl["name"] = group:Name()
			tbl["founder"] = group:GetField("founder")
			tbl["inventory"] = group:GetField("inventory")
			tbl["description"] = group:GetField("description")
			tbl["uid"] = group.UniqueID
			-- datastream.StreamToClients( ply, "Tiramisu.GetFactionInfo", tbl)
			net.Start( "Tiramisu.GetFactionInfo" )
				net.WriteTable( tbl )
			net.Send( ply )
		end
	end
end)

hook.Add("Initialize", "Tiramisu.InitFactions", function()
	CAKE.LoadAllFactions()
end)


hook.Add( "PlayerLoadout", "TiramisuGroupWeaponsLoadout", function( ply )

	if ply:IsCharLoaded() then
		timer.Simple( 2, function()
			local groups = CAKE.GetCharField( ply, "groups" )
			for _, group in pairs( groups ) do
				if CAKE.GroupExists( group ) then
					group = CAKE.GetGroup( group )
					if group and group:GetField( "type" ) == "faction" and group:CharacterInGroup( ply ) then
						local plyinfo = group:GetCharacterInfo( ply )
						for k, v in pairs( group:GetRankField( plyinfo.Rank, "loadout" ) ) do
							if !ply:HasItem( v ) then
								ply:GiveItem( v )
							end
						end
						for k, v in pairs( group:GetRankField( plyinfo.Rank, "weapons" ) ) do
							if !ply:HasWeapon( v ) then
								ply:Give( v )
							end
						end
					end
				end
			end
		end)
	end

end)

-- rp_admin joinfaction "factionhandler" "playername" ["rank"]
local function Admin_JoinFaction( ply, cmd, args )

	if( #args < 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! (rp_admin joinfaction \"factionhandler\" \"playername\" [\"rank\"] )" )
		return
		
	end
	
	local plyname = args[ 2 ]
	local faction = args[ 1 ]
	local rank = args[ 3 ]
	
	local pl = CAKE.FindPlayer( plyname )
	
	if IsValid( ply ) and ply:IsTiraPlayer( ) then
		if CAKE.GroupHandlerExists( faction ) then
			local group = CAKE.FindByHandler( faction )
			if group and !group:CharInGroup( pl ) and group:GetField("type") == "faction" then
				group:AddToRoster( pl )
				if rank and group:IsRank( rank ) then
					group:GetCharInfo( pl ).Rank = rank
				end
				group:Save()
				local plygroups = CAKE.GetCharField( pl, "groups")
				if !table.HasValue( plygroups, group.UniqueID ) then
					table.insert( plygroups, group.UniqueID )
				end
				CAKE.SetCharField( pl, "groups", table.Copy(plygroups))
				CAKE.SetCharField( pl, "activegroup", group.UniqueID)
				CAKE.SendGroupToClient( pl )
				CAKE.SendError( pl, "You have been placed into the faction " .. group:Name() .. " by an admin.")
			elseif group and group:CharInGroup( pl ) and rank and group:IsRank( rank ) then
				group:GetCharInfo( pl ).Rank = rank
				CAKE.SendError( pl, "You have been placed on the rank " .. rank .. " by an admin.")
			end
		elseif CAKE.GroupNameExists( faction ) then
			local group = CAKE.FindGroupByName( faction )
			if group and !group:CharInGroup( pl ) and group:GetField("type") == "faction" then
				group:AddToRoster( pl )
				if rank and group:IsRank( rank ) then
					group:GetCharInfo( pl ).Rank = rank
				end
				group:Save()
				local plygroups = CAKE.GetCharField( pl, "groups")
				if !table.HasValue( plygroups, group.UniqueID ) then
					table.insert( plygroups, group.UniqueID )
				end
				CAKE.SetCharField( pl, "groups", table.Copy(plygroups))
				CAKE.SetCharField( pl, "activegroup", group.UniqueID)
				CAKE.SendGroupToClient( pl )
				CAKE.SendError( pl, "You have been placed into the faction " .. group:Name() .. " by an admin.")
			elseif group and group:CharInGroup( pl ) and rank and group:IsRank( rank ) then
				group:GetCharInfo( pl ).Rank = rank
				CAKE.SendError( pl, "You have been placed on the rank " .. rank .. " by an admin.")
			end
		else
			CAKE.SendChat( ply, "Can't find faction!" )
		end
	else
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" )
	end
	
end


function PLUGIN.Init()
	CAKE.AdminCommand( "joinfaction", Admin_JoinFaction, "Force a player to join a faction", true, true, 4 )
	CAKE.AdminCommand( "forcejoin", Admin_JoinFaction, "Force a player to join a faction", true, true, 4 )
	CAKE.AddGroupField( "handler", "" )
	CAKE.AddGroupField( "spawngroup", 0 )
end