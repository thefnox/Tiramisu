TIRA.Factions = {}

--Returns true if the name introduced is currently assigned to a group
function TIRA.GroupHandlerExists( handler )
	for id, group in pairs( TIRA.Groups ) do
		if group and group:GetField( "handler" ) == handler then
			return true
		end
	end
	return false
end

function TIRA.FindByHandler( handler )
	for id, group in pairs( TIRA.Groups ) do
		if group and group:GetField( "handler" ) == handler then
			return group
		end
	end	
	return false
end

--Saves all factions
function TIRA.SaveFactions()
	file.Write(TIRA.Name .. "/groups/" .. TIRA.ConVars[ "Schema" ] .. "/factions.txt", von.serialize(TIRA.Factions))
end

--Loads all factions
function TIRA.LoadAllFactions()
	if file.Exists( TIRA.Name .. "/groups/" .. TIRA.ConVars[ "Schema" ] .. "/factions.txt" ) then
		TIRA.Factions = von.deserialize(file.Read(TIRA.Name .. "/groups/" .. TIRA.ConVars[ "Schema" ] .. "/factions.txt"))
		local groupexists, fileexists
		for k, v in pairs( TIRA.Factions ) do
			groupexists, fileexists = TIRA.GroupExists( v )
			if !groupexists and fileexists then
				print( "Loading Faction", v )
				TIRA.LoadGroup( v )
				TIRA.Factions[TIRA.Groups[v]:Name()] = v
			elseif !groupexists and !fileexists then
				print( "Removing Faction", v )
				table.remove( TIRA.Factions, k )
			end
		end
		TIRA.SaveFactions()
	end
end

--Creates a new faction object and stores it on the table
function TIRA.CreateFaction( name, shorthand, description )
	if !TIRA.GroupNameExists( name ) and !TIRA.GroupHandlerExists( shorthand ) then
		local group = TIRA.CreateGroup()
		group:SetField( "name", name )
		group:SetField( "description", description )
		group:SetField( "founder", "" )
		group:SetField( "handler", shorthand )
		group:SetField( "type", "faction" )
		group:Save()
		TIRA.Factions[group:Name()] = group.UniqueID
		TIRA.SaveFactions()
		return group
	end
	return false
end

function TIRA.AddFactionRank( faction, name, handler, description, level, weapons, items, permissions )
	level = level or 0
	weapons = weapons or {}
	items = items or {}
	permissions = permissions or {}
	if TIRA.GroupHandlerExists( faction ) then
		group = TIRA.FindByHandler( faction )
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

function TIRA.SendFactionList( ply )
	datastream.StreamToClients( ply, "Tiramisu.ReceiveFactions", TIRA.Factions )
end

datastream.Hook( "Tiramisu.GetEditFaction", function(ply, handler, id, encoded, decoded)
	local group = TIRA.GetGroup( decoded.uid or "none" )
	if group and TIRA.PlayerRank(ply) > 3 then
		if group:Name() != decoded.name and TIRA.GroupNameExists( decoded.name ) then
			TIRA.SendError( ply, "Faction name exists! Please choose another name" )
			datastream.StreamToClients( ply, "Tiramisu.EditFaction", decoded)
		elseif group:GetField( "handler" ) != decoded.handler and TIRA.GroupHandlerExists( decoded.handler ) then
			TIRA.SendError( ply, "Faction handler exists! Please choose another shorthand for your faction" )
			datastream.StreamToClients( ply, "Tiramisu.EditFaction", decoded)		
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
	if TIRA.PlayerRank(ply) > 3 then
		local name = table.concat( args, " " )
		if TIRA.GroupNameExists( name ) then
			umsg.Start( "Tiramisu.FactionCreateQuery", ply )
				umsg.String( name )
			umsg.End()
			TIRA.SendError( ply, "Group already exists! Please choose another name." )
		else
			local group = TIRA.CreateGroup()
			group:SetField( "name", name )
			group:SetField( "type", "faction" )
			group:Save()
			TIRA.Factions[group:Name()] = group.UniqueID
			TIRA.SaveFactions()
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
			TIRA.SendFactionList( ply )
			datastream.StreamToClients( ply, "Tiramisu.EditFaction", tbl)
		end
	end
end)

concommand.Add( "rp_editfaction", function( ply, cmd, args )
	local id = args[1]
	if TIRA.GroupExists( id ) then
		local group = TIRA.GetGroup( id )
		if TIRA.PlayerRank(ply) > 3 then
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

			datastream.StreamToClients( ply, "Tiramisu.EditFaction", tbl)
		end 
	end
end)

concommand.Add( "rp_getfactioninfo", function( ply, cmd, args )
	local id = args[1]
	if TIRA.GroupExists( id ) then
		local group = TIRA.GetGroup( id )
		local tbl = {}
		if group:CharInGroup( ply ) and group:GetField("type") == "faction" then
			tbl["name"] = group:Name()
			tbl["founder"] = group:GetField("founder")
			tbl["inventory"] = group:GetField("inventory")
			tbl["description"] = group:GetField("description")
			tbl["uid"] = group.UniqueID
			datastream.StreamToClients( ply, "Tiramisu.GetFactionInfo", tbl)
		end
	end
end)

hook.Add("Initialize", "Tiramisu.InitFactions", function()
	TIRA.LoadAllFactions()
end)


hook.Add( "PlayerLoadout", "TiramisuGroupWeaponsLoadout", function( ply )

	if ply:IsCharLoaded() then
		timer.Simple( 2, function()
			local groups = TIRA.GetCharField( ply, "groups" )
			for _, group in pairs( groups ) do
				if TIRA.GroupExists( group ) then
					group = TIRA.GetGroup( group )
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
	
		TIRA.SendChat( ply, "Invalid number of arguments! (rp_admin joinfaction \"factionhandler\" \"playername\" [\"rank\"] )" )
		return
		
	end
	
	local plyname = args[ 2 ]
	local faction = args[ 1 ]
	local rank = args[ 3 ]
	
	local pl = TIRA.FindPlayer( plyname )
	
	if ValidEntity( ply ) and ply:IsTiraPlayer( ) then
		if TIRA.GroupHandlerExists( faction ) then
			local group = TIRA.FindByHandler( faction )
			if group and !group:CharInGroup( pl ) and group:GetField("type") == "faction" then
				group:AddToRoster( pl )
				if rank and group:IsRank( rank ) then
					group:GetCharInfo( pl ).Rank = rank
				end
				group:Save()
				local plygroups = TIRA.GetCharField( pl, "groups")
				if !table.HasValue( plygroups, group.UniqueID ) then
					table.insert( plygroups, group.UniqueID )
				end
				TIRA.SetCharField( pl, "groups", table.Copy(plygroups))
				TIRA.SetCharField( pl, "activegroup", group.UniqueID)
				TIRA.SendGroupToClient( pl )
				TIRA.SendError( pl, "You have been placed into the faction " .. group:Name() .. " by an admin.")
			elseif group and group:CharInGroup( pl ) and rank and group:IsRank( rank ) then
				group:GetCharInfo( pl ).Rank = rank
				TIRA.SendError( pl, "You have been placed on the rank " .. rank .. " by an admin.")
			end
		elseif TIRA.GroupNameExists( faction ) then
			local group = TIRA.FindGroupByName( faction )
			if group and !group:CharInGroup( pl ) and group:GetField("type") == "faction" then
				group:AddToRoster( pl )
				if rank and group:IsRank( rank ) then
					group:GetCharInfo( pl ).Rank = rank
				end
				group:Save()
				local plygroups = TIRA.GetCharField( pl, "groups")
				if !table.HasValue( plygroups, group.UniqueID ) then
					table.insert( plygroups, group.UniqueID )
				end
				TIRA.SetCharField( pl, "groups", table.Copy(plygroups))
				TIRA.SetCharField( pl, "activegroup", group.UniqueID)
				TIRA.SendGroupToClient( pl )
				TIRA.SendError( pl, "You have been placed into the faction " .. group:Name() .. " by an admin.")
			elseif group and group:CharInGroup( pl ) and rank and group:IsRank( rank ) then
				group:GetCharInfo( pl ).Rank = rank
				TIRA.SendError( pl, "You have been placed on the rank " .. rank .. " by an admin.")
			end
		else
			TIRA.SendChat( ply, "Can't find faction!" )
		end
	else
		TIRA.SendChat( ply, "Cannot find " .. plyname .. "!" )
	end
	
end


function PLUGIN.Init()
	TIRA.AdminCommand( "joinfaction", Admin_JoinFaction, "Force a player to join a faction", true, true, 4 )
	TIRA.AdminCommand( "forcejoin", Admin_JoinFaction, "Force a player to join a faction", true, true, 4 )
	TIRA.AddGroupField( "handler", "" )
	TIRA.AddGroupField( "spawngroup", 0 )
end