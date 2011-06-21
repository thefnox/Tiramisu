PLUGIN.Name = "Groups"; -- What is the plugin name
PLUGIN.Author = "FNox/Ryaga"; -- Author of the plugin
PLUGIN.Description = "Handles creation destruction and use of groups."; -- The description or purpose of the plugin

CAKE.Groups = {}

function sanitizeGroupName( str )
	return string.lower( string.gsub( str,"[%p%c%s]","" ) )
end

--Changes the name of a player within a group so that it's data is not lost. Used in rp_changename
function CAKE.ChangeMemberName( group, oldname, newname )

	if CAKE.GroupExists( group ) and CAKE.GroupHasMember(group, oldname) then
		CAKE.Groups[group]["Members"][newname] = CAKE.Groups[group]["Members"][oldname]
		CAKE.Groups[group]["Members"][oldname] = nil
	end

end

--Creates a new group. If the group already exists, then merge the new table with the old one.
function CAKE.CreateGroup( name, tbl )
	if !CAKE.Groups[name] then
		CAKE.Groups[name] = tbl
		CAKE.Groups[name][ "Name" ] = name --what
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

end

--Does the group exist in CAKE.Groups?
function CAKE.GroupExists( name )

	if CAKE.Groups[name] and name != "none" then
		return true
	end

	return false

end

--Fetches a groups data field
function CAKE.GetGroupField( name, field )
	if CAKE.Groups[name] and CAKE.Groups[name][field] then
		return CAKE.Groups[name][field]
	end

	return false
end

--Destroys and deletes a group. Handles stored data removal too.
function CAKE.RemoveGroup( name )
	if CAKE.GroupExists( name ) and CAKE.GetGroupField( name, "Type" ) == "public" then
		if CAKE.GetGroupField( name, "Members" ) and 	table.Count(CAKE.GetGroupField( name, "Members" )) == 0 then
			file.Delete( CAKE.Name .. "/groupdata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. CAKE.FormatText( name ) .. ".txt" )
			CAKE.Groups[name] = nil
		end
	end
end

--Sets a group's data field. If the field does not exist, it is created.
function CAKE.SetGroupField( name, field, data )
	if CAKE.Groups[name] then
		CAKE.Groups[name][field] = data
		CAKE.SaveGroupData(name)
		return CAKE.Groups[name][field]
	end
	
	return false
end

--Fetches a groups flag. This flags cannot be changed.
function CAKE.GetGroupFlag( name, flag )
	if CAKE.Groups[name] then
		return CAKE.Groups[name]["Flags"][flag] or false
	end
	
	return false
end

--Fetches a rank's data field
function CAKE.GetRankField( name, rank, field )
	if CAKE.Groups[name] and CAKE.Groups[name]["Ranks"][rank] then
		return CAKE.Groups[name]["Ranks"][rank][field] or false
	end
	
	return false
end

--Edits a rank's data.
function CAKE.SetRankField(name, rank, field, value)
	if CAKE.Groups[name] and CAKE.Groups[name]["Ranks"][rank] then
		CAKE.Groups[name]["Ranks"][rank][field] = value
	end
end

--Does the rank exists within the group's hirearchy.
function CAKE.RankExists( group, rank )
	if CAKE.GroupExists( group ) and CAKE.Groups[group]["Ranks"][rank] then
		return true
	end
	return false
end

--Creates a new rank based on the table provided. Rank cannot currently exist.
function CAKE.CreateRank( group, rank, table )
	if CAKE.GroupExists( group ) and !CAKE.RankExists( group, rank ) then
		CAKE.Groups[group]["Ranks"][rank] = table
	end
end

--Is this player a member of the group provided on the first argument? Also accepts player signatures, for offline players.
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

--Saves all of the group's data to file
function CAKE.SaveGroupData( name )
	if CAKE.Groups[name] then
		local keys = glon.encode(CAKE.Groups[name])
		file.Write( CAKE.Name .. "/groupdata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. sanitizeGroupName( name ) .. ".txt" , keys)
	end
end

--Loads the group's data table
function CAKE.LoadGroupData( name )
	local tbl = glon.decode(file.Read( CAKE.Name .. "/groupdata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. sanitizeGroupName( name ) .. ".txt"))
	if tbl then
		CAKE.CreateGroup( tbl["Name"], tbl )
	else
		file.Delete( CAKE.Name .. "/groupdata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. sanitizeGroupName( name ) .. ".txt" )
	end
end

--Loads ALL groups currently existing on the data folder.
function CAKE.LoadAllGroups()

	local groups = file.Find(CAKE.Name .. "/groupdata/" .. CAKE.ConVars[ "Schema" ] .. "/*.txt")
	local name = ""

	for k, v in pairs( groups ) do
		name = string.gsub( v, ".txt", "" )
		CAKE.LoadGroupData( name )
	end

end

hook.Add( "InitPostEntity", "TiramisuLoadAllGroups", function()

	CAKE.LoadAllGroups()

end)

--Makes a player join a particular group. Makes it leave it's current group.
function CAKE.JoinGroup( ply, name )
	if CAKE.GroupExists( name ) and ValidEntity( ply ) then
		if CAKE.GetCharField( ply, "group" ) != "none" and CAKE.GetCharField( ply, "group" ) != name then
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
		CAKE.SendGroupToClient( ply )
	end
end

--Makes the player leave a particular group.
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
		if group and CAKE.Groups[group]["Members"][ply] then
			if CAKE.FindPlayer( CAKE.Groups[group]["Members"][ply].Name ) then
				local ent = CAKE.FindPlayer( CAKE.Groups[group]["Members"][ply].Name )
				CAKE.SetCharField( ent, "group", "none" )
				CAKE.SetCharField( ent, "grouprank", "none")
			end
			CAKE.Groups[group]["Members"][ply] = nil
		end
	end
end

--Sets a player's rank on a group to the rank provided on the third argument. Also accepts player signatures.
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

	if !CAKE.GroupHasMember(group, target or targetname ) then
		CAKE.SendError( ply, "Target is not in your group!")
		return
	end

	if CAKE.GroupHasMember(group, ply) and CAKE.GroupHasMember(group, target or targetname ) and CAKE.GetRankField( group, rank, "canpromote" ) then
		if target then
			if CAKE.RankExists( group, targetrank ) and ( CAKE.GetRankField( name, rank, "level" ) or 0 ) >= ( CAKE.GetRankField( name, targetrank, "level" ) or 0 ) and !CAKE.GetRankField( name, targetrank, "unpromoteable" ) then
				CAKE.SetCharRank( target, group, targetrank )
				CAKE.SendError( target, "You have been promoted to " .. targetrank  )
				CAKE.SendGroupToClient( target )
			end
		else
			if CAKE.RankExists( group, targetrank ) and ( CAKE.GetRankField( name, rank, "level" ) or 0 ) >= ( CAKE.GetRankField( name, targetrank, "level" ) or 0 ) then
				CAKE.SetCharRank( target, group, targetrank )
			end
		end
	else
		CAKE.SendError( ply, "Insufficient Credentials.")
	end

end)

concommand.Add( "rp_kickfromgroup", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	local target = CAKE.FindPlayer( args[1] )
	local targetrank = CAKE.GetCharField( target, "grouprank")

	if ( CAKE.GroupHasMember(group, ply) and CAKE.GroupHasMember(group, target or targetname ) and CAKE.GetRankField( group, rank, "cankick" ) ) and !CAKE.GetRankField( name, targetrank, "unkickable" ) then
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
	else
		CAKE.SendError( ply, "Insufficient Credentials.")
	end

end)

concommand.Add( "rp_beginrankediting", function( ply, cmd, args )
	local rank = args[ 1 ]
	local group = CAKE.GetCharField( ply, "group" )
	local grouprank = CAKE.GetCharField( ply, "grouprank")
	print( rank )
	if CAKE.GroupExists( group ) and CAKE.RankExists( group, rank ) and CAKE.GetRankField( group, grouprank, "canedit" ) then
		umsg.Start( "EditRank", ply )
			umsg.String( rank )
			umsg.String( CAKE.GetRankField( group, rank, "formalname" ) or "None"  )
			umsg.Bool( CAKE.GetRankField( group, rank,  "canedit" ) )
			umsg.Bool( CAKE.GetRankField( group, rank,  "cankick" ) )
			umsg.Bool( CAKE.GetRankField( group, rank,  "canpromote" ) )
			umsg.Short( CAKE.GetRankField( group, rank,  "level" ) )
		umsg.End()
	else
		CAKE.SendError( ply, "Insufficient Credentials.")
	end

end)

concommand.Add( "rp_editrank", function( ply, cmd, args )

	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")


	if CAKE.GroupHasMember(group, ply) and CAKE.GetRankField( group, rank, "canedit" ) then
		if CAKE.RankExists( group, args[1] ) then
			CAKE.SetRankField(group, args[1], "formalname", args[2])
			CAKE.SetRankField(group, args[1], "level", tonumber( args[3] ))
			CAKE.SetRankField(group, args[1], "canedit", util.tobool( args[4] ) )
			CAKE.SetRankField(group, args[1], "cankick", util.tobool( args[5] ) )
			CAKE.SetRankField(group, args[1], "canpromote", util.tobool( args[6] ) )
			if util.tobool( args[7] ) then
				CAKE.SetGroupField( "defaultrank", args[1])
			end
			CAKE.SendGroupToClient( ply )
		else
			CAKE.SendError( ply, "Rank does not exist!")
		end
	end
	
end)

concommand.Add( "rp_creategroup", function( ply, cmd, args)

	local name = args[1]

	if !CAKE.GroupExists( name ) and name != "none" then
		--Mind this table, this should be the base of all groups you may want to make
		local tbl = {}
		tbl[ "Name" ]		= name
		tbl[ "Type" ]		= "public"
		tbl[ "Founder" ]	= ply:Nick()
		tbl[ "Members" ]	= {}
		tbl[ "Inventory" ]	= {}
		tbl[ "Description" ]= "" 
		tbl[ "Flags" ]		= {}
		tbl[ "Ranks" ]		= {
			[ "defaultrank" ] = {
				["formalname"] = "Default Rank"
			},
			[ "owner" ] = {
				["canedit"] = true,
				["canpromote"] = true,
				["cankick"] = true,
				["formalname"] = "Group Founder",
				["unkickable"] = true,
				["unpromoteable"] = true,
				["level"] = 9999
			}
		}

		tbl[ "DefaultRank"] = "defaultrank"
		CAKE.CreateGroup( name, tbl )
		CAKE.JoinGroup( ply, name )
		CAKE.SetCharRank( ply, name, "owner" )
		CAKE.SendGroupToClient( ply )
		CAKE.SaveGroupData( name )
	else
		umsg.Start( "DenyGroupCreation", ply )
			umsg.String( name )
		umsg.End()
	end

end)

concommand.Add( "rp_createrank" , function( ply, cmd, args )

	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")

	if CAKE.GroupHasMember(group, ply) and CAKE.GetRankField( group, rank, "canedit" ) then
		if !CAKE.RankExists( group, args[1] ) then
			CAKE.CreateRank( group, args[1], {} )
			CAKE.SetRankField(group, args[1], "formalname", args[2])
			CAKE.SetRankField(group, args[1], "level", tonumber( args[3] ))
			CAKE.SetRankField(group, args[1], "canedit", util.tobool( args[4] ) )
			CAKE.SetRankField(group, args[1], "cankick", util.tobool( args[5] ) )
			CAKE.SetRankField(group, args[1], "canpromote", util.tobool( args[6] ) )
			CAKE.SendGroupToClient( ply )
		else
			CAKE.SendError( ply, "Group already exists! Choose a new handle.")
		end
	end
end)

concommand.Add( "rp_rostersearch", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	if CAKE.GroupExists( group ) then
		local searchstring = table.concat( args, " " )
		local roster = CAKE.GetGroupField( group, "Members" )
		local searchresults = {}
		local tbl = {}
		for k, v in pairs( roster ) do
			if string.match( string.lower( searchstring ), string.lower( v.Name )) or string.match( searchstring, v.SteamID ) or ((v.Rank != false) and(string.match( searchstring, v.Rank ))) or string.match( searchstring, CAKE.GetRankField( group, v.Rank, "formalname" ) or "None" ) then
				tbl = {}
				tbl.Name = v.Name
				tbl.SteamID = v.SteamID
				tbl.Rank = CAKE.GetRankField( group, v.Rank, "formalname" ) or "None"
				tbl.Online = util.tobool( CAKE.FindPlayer( v.SteamID ) )
				table.insert( searchresults, tbl )
			end
		end
		datastream.StreamToClients( ply, "DisplayRoster", searchresults )
	end

end)

function CAKE.SendGroupToClient( ply )

	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	
	if CAKE.GroupExists( group ) then
		local tbl = {}
		for k, v in pairs( CAKE.GetGroupField( group, "Ranks" ) or {} ) do
			tbl[ k ] = CAKE.GetRankField( group, k, "formalname" ) or "None"
		end
		datastream.StreamToClients( ply, "ReceiveGroup", {
			[ "Name" ]		= CAKE.GetGroupField( group, "Name" ),
			[ "Type" ]		= CAKE.GetGroupField( group, "Type" ),
			[ "Founder" ]	= CAKE.GetGroupField( group, "Founder" ),
			[ "Rank" ]		= CAKE.GetRankField( group, rank, "formalname" ) or "None",
			[ "Ranks" ]		= tbl,
			[ "RankPermissions" ] = {
				["canpromote"] = CAKE.GetRankField( group, rank, "canpromote" ),
				["canedit"] = CAKE.GetRankField( group, rank, "canedit" ),
				["cankick"] = CAKE.GetRankField( group, rank, "cankick" ),
				["canbuy"] = CAKE.GetRankField( group, rank, "canbuy" )
			},
			[ "Description" ] = CAKE.GetGroupField( group, "Description" ) or "None."
		})
	else
		datastream.StreamToClients( ply, "ReceiveGroup", {
			[ "Name" ]		= "none",
			[ "Type" ]		= "",
			[ "Founder" ]	= "",
			[ "Rank" ]		= "",
			[ "Ranks" ]		= {},
			[ "RankPermissions" ] = {
				["canpromote"] = false,
				["cankick"] = false,
				["canedit"] = false,
				["canbuy"] = false
			},
			[ "Description" ] = ""
		})
	end

end


local function GroupSpawnHook( ply )

	if ply:IsCharLoaded() then
		timer.Simple( 1, function()
			local group = CAKE.GetCharField( ply, "group" )
			local rank = CAKE.GetCharField( ply, "grouprank" )
			if CAKE.GroupExists( group ) and CAKE.GroupHasMember(group, ply) then
				if CAKE.Groups[group]["Members"] and CAKE.Groups[group]["Members"][CAKE.GetCharSignature(ply)][ "Rank" ] then
					if rank != CAKE.Groups[group]["Members"][CAKE.GetCharSignature(ply)][ "Rank" ] then
						CAKE.SetCharRank( ply, group, CAKE.Groups[group]["Members"][CAKE.GetCharSignature(ply)][ "Rank" ] )
					end
				else
					CAKE.SetCharRank( ply, group, CAKE.GetGroupField( group, "DefaultRank" ))
				end
				timer.Create( ply:SteamID() .. "groupsendtimer", 10, 0, function()
					CAKE.SendGroupToClient( ply )
					if !CAKE.GroupExists( CAKE.GetCharField( ply, "group" ) ) then
						timer.Destroy( ply:SteamID() .. "groupsendtimer" )
					end
				end)
			else
				if CAKE.GetCharField( ply, "group" ) != "none" then
					CAKE.SendError( ply, "You have been kicked from your group."  )
					CAKE.LeaveGroup( ply )
				end
			end
			CAKE.SendGroupToClient( ply )
		end)
	end

end
hook.Add( "PlayerSpawn", "TiramisuGroupSpawnHook", GroupSpawnHook )

hook.Add( "Initialize", "TiramisuGroupInit", function()

	CAKE.DayLog( "script.txt", "Loading all groups")
	CAKE.LoadAllGroups()
	
end)

--rp_admin forcejoin playername groupname [rank]. Rank is optional, will default to the group's DefaultRank.
function Admin_ForceJoin( ply, cmd, args )
	
	if #args < 1 then CAKE.SendError( ply, "Must specify a player!") return end 
	local target = CAKE.FindPlayer( args[1] )

	if !target then CAKE.SendError( ply, "The target specified can not be found!") return end
	
	if args[ 2 ] and args[ 2 ] != "none" then CAKE.JoinGroup( target, args[ 2 ] ) end
	if args[ 3 ] and args[ 3 ] != "none" then CAKE.SetCharRank( target, CAKE.GetCharField( target, "group" ), args[ 3 ] ) end

	CAKE.SendError( target, "You have been forced into group: " .. CAKE.GetCharField( target, "group" ) )
	CAKE.SendGroupToClient( ply )
end

function Admin_GiveRankBusiness( ply, cmd, args )
	if #args < 3 then
		CAKE.SendError(ply, "Format: /giverankbis <group> <rank> <buygroups>")
		return false
	end

	if CAKE.RankExists(args[1], args[2]) then
		buy = {}
		for i = 3, #args do
			table.insert(buy, args[i])
		end
		CAKE.SetRankField(args[1], args[2], "buygroups", buy or {})
		ply:RefreshBusiness()
	end
end

function PLUGIN.Init( )

	CAKE.AdminCommand( "forcejoin", Admin_ForceJoin, "Force a player into a group at a set rank.", true, true, 3 );
	CAKE.AdminCommand( "giverankbis", Admin_GiveRankBusiness, "Gives a player created group's rank business.", true, true, 4 );
end