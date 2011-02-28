PLUGIN.Name = "Groups"; -- What is the plugin name
PLUGIN.Author = "FNox/Ryaga"; -- Author of the plugin
PLUGIN.Description = "Handles creation destruction and use of groups."; -- The description or purpose of the plugin

CAKE.Groups = {}

function sanitizeGroupName( name )
	local str = name
	str = string.gsub( str,":","" );
	str = string.gsub( str,"_","" );
	str = string.gsub( str,".","" );
	str = string.gsub( str," ","" );
	return str
end

function CAKE.CreateGroup( name, tbl )
	if !CAKE.Groups[name] then
		CAKE.Groups[name] = tbl
		CAKE.Groups[name][ "name" ] = name --what
		CAKE.SaveGroupData(name)
		timer.Create( name .. "GroupSaveTimer", 60, 0, function()
			if CAKE.GroupExists( name ) then
				CAKE.SaveGroupData( name )
			else
				timer.Destroy( name .. "GroupSaveTimer" )
			end
		end)
		return true
	else
		table.Merge(CAKE.Groups[name], tbl)
	end

	print( name )
end

function CAKE.GroupExists( name )

	if CAKE.Groups[name] and name != "none" then
		return true
	end

	return false

end

function CAKE.GetGroupField( name, field )
	if CAKE.Groups[name] and CAKE.Groups[name][field] then
		return CAKE.Groups[name][field]
	end

	return false
end

function CAKE.SetGroupField( name, field, data )
	if CAKE.Groups[name] then
		CAKE.Groups[name][field] = data
		CAKE.SaveGroupData(name)
		return CAKE.Groups[name][field]
	end
	
	return false
end

function CAKE.GetGroupFlag( name, flag )
	if CAKE.Groups[name] then
		return CAKE.Groups[name]["Flags"][flag] or false
	end
	
	return false
end

function CAKE.GetRankField( name, rank, field )
	if CAKE.Groups[name] and CAKE.Groups[name]["Ranks"][rank] then
		return CAKE.Groups[name]["Ranks"][rank][field] or false
	end
	
	return false
end

function CAKE.SetRankField(name, rank, field, value)
	if CAKE.Groups[name] and CAKE.Groups[name]["Ranks"][rank] then
		CAKE.Groups[name]["Ranks"][rank][field] = value
	end
end

function CAKE.RankExists( group, rank )
	if CAKE.GroupExists( group ) and CAKE.Groups[group]["Ranks"][rank] then
		return true
	end
	return false
end

function CAKE.CreateRank( group, rank, table )
	if CAKE.GroupExists( group ) and !CAKE.RankExists( group, rank ) then
		CAKE.Groups[name]["Ranks"][rank] = table
	end
end

function CAKE.GroupHasMember(name, ply)

	if CAKE.Groups[name] then
		if ValidEntity( ply ) then
			if CAKE.Groups[name]["Members"][CAKE.GetCharSignature(ply)] and CAKE.GetCharField(ply, "group") == name then
				return true
			elseif CAKE.Groups[name]["Members"][CAKE.GetCharSignature(ply)] and !CAKE.GetCharField(ply, "group") == name then
				CAKE.SetCharField(ply, "group", name)
			elseif !CAKE.Groups[name]["Members"][CAKE.GetCharSignature(ply)] and CAKE.GetCharField(ply, "group") == name then
				CAKE.SetCharField(ply, "group", "none")
			end
		elseif type( ply ) == "string" then
			if CAKE.Groups[name]["Members"][ply] then
				return true
			end
		end
	end

	return false

end

function CAKE.SaveGroupData( name )
	if CAKE.Groups[name] then
		local keys = glon.encode(CAKE.Groups[name])
		file.Write( CAKE.Name .. "/GroupData/" .. CAKE.ConVars[ "Schema" ] .. "/" .. CAKE.FormatText( name ) .. ".txt" , keys)
	end
end

function CAKE.LoadGroupData( name )
	local tbl = glon.decode(file.Read( CAKE.Name .. "/GroupData/" .. CAKE.ConVars[ "Schema" ] .. "/" .. CAKE.FormatText( name ) .. ".txt"))
	CAKE.CreateGroup( tbl["name"], tbl )
end

function CAKE.LoadAllGroups()

	local groups = file.Find(CAKE.Name .. "/GroupData/" .. CAKE.ConVars[ "Schema" ] .. "/*.txt")
	local name = ""

	for k, v in pairs( groups ) do
		name = string.gsub( v, ".txt", "" )
		CAKE.LoadGroupData( name )
	end

end

hook.Add( "InitPostEntity", "TiramisuLoadAllGroups", function()

	CAKE.LoadAllGroups()

end)

function CAKE.JoinGroup( ply, name )
	if CAKE.GroupExists( name ) then
		if CAKE.GetCharField( ply, "group" ) != "none" then
			CAKE.LeaveGroup( ply )
		end
		CAKE.SetCharField( ply, "group", name )
		CAKE.SetCharField( ply, "grouprank", CAKE.GetGroupField( name, "DefaultRank" ))
		local roster = CAKE.GetGroupField( name, "Members" )
		local tbl = {}
		tbl.Name = ply:Nick()
		tbl.SteamID = ply:SteamID()
		tbl.Signature = CAKE.GetCharSignature(ply)
		tbl.Rank = CAKE.GetGroupField( name, "DefaultRank" )
		CAKE.Groups[name]["Members"][CAKE.GetCharSignature(ply)] = tbl
		CAKE.SaveGroupData( name )
	end
end


function CAKE.LeaveGroup( ply, group )

	if ValidEntity( ply ) then
		local name = CAKE.GetCharField( ply, "group" )
		if name != "none" then
			if CAKE.Groups[name] then
				local roster = CAKE.GetGroupField( name, "Members" )
				CAKE.Groups[name]["Members"][CAKE.GetCharSignature(ply)] = nil
			end
			CAKE.SetCharField( ply, "group", "none" )
			CAKE.SetCharField( ply, "grouprank", "none")
			CAKE.SendError( ply, "You have left: " .. name )
			CAKE.SendGroupToClient( ply )
			CAKE.SaveGroupData( name )
		end
	elseif type( ply ) == "string" then
		local roster = CAKE.GetGroupField( group, "Members" )
		if CAKE.Groups[group]["Members"][ply] then
			if CAKE.FindPlayer( CAKE.Groups[group]["Members"][ply].Name ) then
				local ent = CAKE.FindPlayer( CAKE.Groups[group]["Members"][ply].Name )
				CAKE.SetCharField( ent, "group", "none" )
				CAKE.SetCharField( ent, "grouprank", "none")
			end
			CAKE.Groups[group]["Members"][ply] = nil
		end
	end
end

function CAKE.SetCharRank( ply, name, rank )

	if ValidEntity( ply ) then
		if CAKE.GroupExists( name ) and CAKE.GroupHasMember(name, ply) and CAKE.RankExists( name, rank ) then
			local roster = CAKE.GetGroupField( name, "Members" )
			CAKE.Groups[name]["Members"][CAKE.GetCharSignature(ply)].Rank = rank
			CAKE.SetCharField( ply, "grouprank", rank )
			CAKE.SendGroupToClient( ply )
			CAKE.SaveGroupData( name )
		end
	elseif type( ply ) == "string" then
		if CAKE.GroupExists( name ) and CAKE.GroupHasMember(name, ply) and CAKE.RankExists( name, rank ) then
			local roster = CAKE.GetGroupField( name, "Members" )
			CAKE.Groups[name]["Members"][ply].Rank = rank
			CAKE.SaveGroupData( name )
		end	
	end
end

concommand.Add( "rp_joingroup", function( ply, cmd, args )
	
	local group = table.concat( args, " " )
	if group != "none" then
		local type = CAKE.GetGroupField( group, "type" )
		if type == "faction" or type == "public" or ply.AuthorizedToJoin == group then
			ply.AuthorizedToJoin = "none"
			CAKE.JoinGroup( ply, group )
			CAKE.SendError( ply, "You have joined: " .. group )
			CAKE.SendGroupToClient( ply )
		end
	else
		CAKE.LeaveGroup( ply )
	end

end )

concommand.Add( "rp_sendinvite", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	local target = CAKE.FindPlayer( args[1] )

	if ( CAKE.GroupHasMember(group, ply) and CAKE.GetRankField( group, rank, "canpromote" ) ) then
		if !CAKE.GroupHasMember(group, target) then
			target.AuthorizedToJoin = group
			umsg.Start( "DisplayInvite", target )
				umsg.String( group )
			umsg.End() 
		end
	end

end)

concommand.Add( "rp_setgroupfield", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	local field = args[1]
	table.remove( args, 1 )
	local data = table.concat( args, " ")

	if CAKE.GroupHasMember(group, ply) and CAKE.GetRankField( group, rank, "canedit" ) and field != "Name" then
		if type( CAKE.GetGroupField( group, field ) ) != "table" then
			if type( CAKE.GetGroupField( group, field ) ) == "number" then
				CAKE.SetGroupField( group, field, tonumber( data ) )
			elseif type( CAKE.GetGroupField( group, field ) ) == "string" then
				CAKE.SetGroupField( group, field, data )
			elseif type( CAKE.GetGroupField( group, field ) ) == "boolean" then
				CAKE.SetGroupField( group, field, util.tobool( data ) )
			end
			CAKE.SendError( ply, "Field " .. field .. " set to " .. tostring( data ))
			CAKE.SendGroupToClient( ply )
		end
	end

end)

concommand.Add( "rp_promote", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	local targetname = args[1]
	local target = CAKE.FindPlayer( args[1] )
	table.remove( args, 1 )
	local targetrank = table.concat( args, " ")

	if CAKE.GroupHasMember(group, ply) and CAKE.GroupHasMember(group, target or targetname ) and CAKE.GetRankField( group, rank, "canpromote" ) then
		if target then
			if CAKE.RankExists( group, targetrank ) and ( CAKE.GetRankField( name, rank, "level" ) or 0 ) >= ( CAKE.GetRankField( name, targetrank, "level" ) or 0 ) then
				CAKE.SetCharRank( target, group, targetrank )
				CAKE.SendError( target, "You have been promoted to " .. targetrank  )
				CAKE.SendGroupToClient( target )
			end
		else
			if CAKE.RankExists( group, targetrank ) and ( CAKE.GetRankField( name, rank, "level" ) or 0 ) >= ( CAKE.GetRankField( name, targetrank, "level" ) or 0 ) then
				CAKE.SetCharRank( target, group, targetrank )
			end
		end
	end

end)

concommand.Add( "rp_kickfromgroup", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	local target = CAKE.FindPlayer( args[1] )
	local targetrank = CAKE.GetCharField( target, "grouprank")

	if ( CAKE.GroupHasMember(group, ply) and CAKE.GroupHasMember(group, target or targetname ) and CAKE.GetRankField( group, rank, "cankick" ) ) then
		if target then
			if ( CAKE.GetRankField( name, rank, "level" ) or 0 ) >= ( CAKE.GetRankField( name, targetrank, "level" ) or 0 ) then
				CAKE.LeaveGroup( target )
				CAKE.SendError( target, "You have been kicked from group: " .. group  )
				CAKE.SendGroupToClient( target )
			end
		else
			if ( CAKE.GetRankField( name, rank, "level" ) or 0 ) >= ( CAKE.GetRankField( name, targetrank, "level" ) or 0 ) then
				CAKE.LeaveGroup( targetname )
			end
		end
	end

end)


concommand.Add( "rp_creategroup", function( ply, cmd, args)

	local founder = CAKE.GetCharSignature(ply)
	local name = args[1]
	local tbl = {}
	tbl[ "Name" ]		= name
	tbl[ "Type" ]		= "public"
	tbl[ "Founder" ]	= founder
	tbl[ "Members" ]	= {}
	tbl[ "Inventory" ]	= {}
	tbl[ "Flags" ]		= {}
	tbl[ "Ranks" ]		= {}
	tbl[ "DefaultRank"] = "DefaultRank"
	CAKE.CreateGroup( name, tbl )
	CAKE.CreateRank( group, "DefaultRank", {} )
	CAKE.JoinGroup( ply, name )

	

end)

function CAKE.SendGroupToClient( ply )

	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	
	if CAKE.GroupExists( group ) then
		datastream.StreamToClients( ply, "ReceiveGroup", {
			[ "Name" ]		= CAKE.GetGroupField( group, "Name" ),
			[ "Type" ]		= CAKE.GetGroupField( group, "Type" ),
			[ "Founder" ]	= CAKE.GetGroupField( group, "Founder" ),
			[ "Rank" ]		= CAKE.GetRankField( group, rank, "formalname" ) or "None",
			[ "RankPermissions" ] = {
				["canpromote"] = CAKE.GetRankField( group, rank, "canpromote" ),
				["canedit"] = CAKE.GetRankField( group, rank, "canedit" ),
				["cankick"] = CAKE.GetRankField( group, rank, "cankick" )
			},
			[ "Description" ] = CAKE.GetGroupField( group, "Description" ) or "None."
		})
	else
		datastream.StreamToClients( ply, "ReceiveGroup", {
			[ "Name" ]		= "none",
			[ "Type" ]		= "",
			[ "Founder" ]	= "",
			[ "Rank" ]		= "",
			[ "RankPermissions" ] = {
				["canpromote"] = false,
				["cankick"] = false,
				["canedit"] = false
			},
			[ "Description" ] = ""
		})
	end
	CAKE.SavePlayerData( ply )

end

local function GroupSpawnHook( ply )

	if ply:IsCharLoaded() then
		timer.Simple( 3, function()
			local group = CAKE.GetCharField( ply, "group" )

			if group != "none" and !CAKE.GroupHasMember(group, ply) then
				CAKE.LeaveGroup( ply )
			end
			CAKE.SendGroupToClient( ply )
		end)
	end

end
hook.Add( "PlayerSpawn", "TiramisuGroupSpawnHook", GroupSpawnHook )


function Admin_ForceJoin( ply, cmd, args )

	local target = CAKE.FindPlayer( args[1] )

	if args[ 2 ] and args[ 2 ] != "none" then CAKE.JoinGroup( target, args[ 2 ] ) end
	if args[ 3 ] and args[ 3 ] != "none" then CAKE.SetCharRank( target, CAKE.GetCharField( target, "group" ), args[ 3 ] ) end

	CAKE.SendError( target, "You have been forced into group: " .. CAKE.GetCharField( target, "group" ) )
	CAKE.SendGroupToClient( ply )

end

function PLUGIN.Init( )

	CAKE.AdminCommand( "forcejoin", Admin_ForceJoin, "Force a player into a group at a set rank.", true, true, 3 );

end