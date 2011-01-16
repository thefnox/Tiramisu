PLUGIN.Name = "Groups"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
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
		return true
	else
		table.Merge(CAKE.Groups[name], tbl)
	end
end

function CAKE.GroupExists( name )

	if CAKE.Groups[name] and name != "none" then
		return true
	end

	return false

end

function CAKE.GetGroupField( name, field )
	return CAKE.Groups[name][field] or false
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
		return CAKE.Groups[name]["flags"][flag] or false
	end
	
	return false
end

function CAKE.GetRankField( name, rank, field )
	if CAKE.Groups[name] and CAKE.Groups[name]["ranks"][rank] then
		return CAKE.Groups[name]["ranks"][rank][field] or false
	end
	
	return false
end

function CAKE.SetRankField(name, rank, field, value)
	if CAKE.Groups[name] and CAKE.Groups[name]["ranks"][rank] then
		CAKE.Groups[name]["ranks"][rank][field] = value
	end
end

function CAKE.RankExists( group, rank )
	if CAKE.GroupExists( group ) and CAKE.Groups[name]["ranks"][rank] then
		return true
	end
	return false
end

function CAKE.GroupHasMember(name, ply)

	if CAKE.Groups[name] then
		if ValidEntity( ply ) then
			if CAKE.Groups[name]["members"][CAKE.GetCharSignature(ply)] and CAKE.GetCharField(ply, "group") == name then
				return true
			elseif CAKE.Groups[name]["members"][CAKE.GetCharSignature(ply)] and !CAKE.GetCharField(ply, "group") == name then
				CAKE.SetCharField(ply, "group", name)
			elseif !CAKE.Groups[name]["members"][CAKE.GetCharSignature(ply)] and CAKE.GetCharField(ply, "group") == name then
				CAKE.SetCharField(ply, "group", "none")
			end
		elseif type( ply ) == "string" then
			if CAKE.Groups[name]["members"][ply] then
				return true
			end
		end
	end

	return false

end

function CAKE.SaveGroupData( name )
	print( CAKE.FormatText( name ) )
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

	for k, v in pairs( groups ) do
		CAKE.LoadGroupData( string.gsub( v, ".txt", "" ))
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
		CAKE.SetCharField( ply, "grouprank", CAKE.GetGroupField( name, "defaultrank" ))
		local roster = CAKE.GetGroupField( name, "members" )
		local tbl = {}
		tbl.Name = ply:Nick()
		tbl.SteamID = ply:SteamID()
		tbl.Signature = CAKE.GetCharSignature(ply)
		tbl.Rank = CAKE.GetGroupField( name, "defaultrank" )
		CAKE.Groups[name]["members"][CAKE.GetCharSignature(ply)] = tbl
	end
end

function CAKE.LeaveGroup( ply )

	if ValidEntity( ply ) then
		local name = CAKE.GetCharField( ply, "group" )
		if CAKE.Groups[name] then
			local roster = CAKE.GetGroupField( name, "members" )
			CAKE.Groups[name]["members"][CAKE.GetCharSignature(ply)] = nil
		end
		CAKE.SetCharField( ply, "group", "none" )
		CAKE.SetCharField( ply, "grouprank", "none")
	elseif type( ply ) == "string" then
		local roster = CAKE.GetGroupField( name, "members" )
		if CAKE.Groups[name]["members"][ply] then
			if CAKE.FindPlayer( CAKE.Groups[name]["members"][ply].Name ) then
				local ent = CAKE.FindPlayer( CAKE.Groups[name]["members"][ply].Name )
				CAKE.SetCharField( ent, "group", "none" )
				CAKE.SetCharField( ent, "grouprank", "none")
			end
			CAKE.Groups[name]["members"][ply] = nil
		end
	end
end

function CAKE.SetCharRank( ply, name, rank )
	if CAKE.GroupExists( name ) and CAKE.GroupHasMember(name, ply) and CAKE.RankExists( name, rank ) then
		local roster = CAKE.GetGroupField( name, "members" )
		CAKE.Groups[name]["members"][CAKE.GetCharSignature(ply)].Rank = rank
		CAKE.SetCharField( ply, "grouprank", rank )
	end
end

concommand.Add( "rp_joingroup", function( ply, cmd, args )
	
	local group = table.concat( args, " " )
	if group != "none" then
		local type = CAKE.GetGroupField( group, "type" )
		if type == "faction" or type == "public" or ply.AuthorizedToJoin == group then
			ply.AuthorizedToJoin = "none"
			CAKE.JoinGroup( ply, group )
		end
	else
		CAKE.LeaveGroup( ply )
	end

end )

concommand.Add( "rp_acceptinvite", function( ply, cmd, args )
	
	local group = table.concat( args, " " )
	if ply.AuthorizedToJoin == group then
		ply.AuthorizedToJoin = "none"
		CAKE.JoinGroup( ply, group )
	end

end)

concommand.Add( "rp_kickfromgroup", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	local target = args[1]

	if CAKE.GroupHasMember(group, ply) and CAKE.GetRankField( group, rank, "cankick" ) then
		if CAKE.GroupHasMember(group, target) then
			CAKE.LeaveGroup( target )
		end
	end

end)

local function GroupSpawnHook( ply )

	if ply:IsCharLoaded() then
		local group = CAKE.GetCharField( ply, "group" )

		if group != none and !CAKE.GroupHasMember(group, ply) then
			CAKE.LeaveGroup( ply )
		end
	end

end
hook.Add( "PlayerSpawn", "TiramisuGroupSpawnHook", GroupSpawnHook )
/*
function sanitizeGroupName( str )
	str = string.gsub( str,":","" );
	str = string.gsub( str,"_","" );
	str = string.gsub( str,".","" );
	return str
end

function CAKE.CreateGroup( name, tbl )
	if !CAKE.Groups[name] then
		CAKE.Groups[name] = tbl
		CAKE.SaveGroupData(name)
		return true
	else
		table.Merge(CAKE.Groups[name], tbl)
	end
end

function CAKE.GetGroupField( name, field )
	return CAKE.Groups[field] or false
end

function CAKE.SetGroupField( name, field, data )
	if CAKE.Groups[name] then
		CAKE.Groups[name][field] = data
		CAKE.SaveGroupData(name)
		return true
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

function CAKE.GroupHasMember(name, ply)
	if !CAKE.Groups[name] then return false end -- dumbass.
	
	if CAKE.Groups[name]["Members"][CAKE.GetCharSignature(ply)] and CAKE.GetCharField(ply, "group") == name then
		return true
	elseif CAKE.Groups[name]["Members"][CAKE.GetCharSignature(ply)] and !CAKE.GetCharField(ply, "group") == name then
		CAKE.SetCharField(ply, "group", name)
	elseif !CAKE.Groups[name]["Members"][CAKE.GetCharSignature(ply)] and CAKE.GetCharField(ply, "group") == name then
		CAKE.SetCharField(ply, "group", "none")
	end
end

function CAKE.GetPlayerGroup(ply)
	if CAKE.GetCharField(ply, "group") == "none" then
		return "none"
	else
		if CAKE.GroupHasMember(CAKE.GetCharField(ply, "group"), ply) then
			return true
		end
	end
	
	return "none"
end

function CAKE.GetRankFields( name, rank )
	if CAKE.Groups[name] and CAKE.Groups[name]["Ranks"][rank] then
		return CAKE.Groups[name]["Ranks"][rank]
	end
	
	return false
end

function CAKE.SetCharGroup( name, ply )
	if CAKE.GetCharField(ply, "group") == "none" then
	
	end
end

function CAKE.RemoveCharGroup( ply )
	if CAKE.GroupHasMember(CAKE.GetCharField(ply, "group"), ply) then
		CAKE.Groups[name]["Members"][CAKE.GetCharSignature(ply)] = nil
		CAKE.SetCharField(ply, "group", "none")
	end
end
function CAKE.SetCharRank( ply, rank )

	if ply:IsCharLoaded() then
		ply:
	end
	
end

function CAKE.SaveGroupData( name )

end

function CAKE.RemoveGroupData( name )

end

local function FetchFactions()
	
end
hook.Add( "InitPostEntity", "FetchFactions", FetchFactions )

local function LoadAllGroups()

end
hook.Add( "Initialize", "LoadAllTiramisuGroups", LoadAllGroups )

local function ccCreateGroup( ply, cmd, args )

end
concommand.Add( "rp_creategroup", ccCreateGroup )

local function ccJoinGroup( ply, cmd, args )

end
concommand.Add( "rp_joingroup", ccJoinGroup )

local function ccLeaveGroup( ply, cmd, args )

end
concommand.Add( "rp_leavegroup", ccLeaveGroup )

local function ccSendInvite( ply, cmd, args )

end
concommand.Add( "rp_sendinvite", ccSendInvite )

local function ccAcceptInvite( ply, cmd, args )

end
concommand.Add( "rp_acceptinvite", ccAcceptInvite )

local function ccPromote( ply, cmd, args )

end
concommand.Add( "rp_promote", ccPromote )

local function GroupSpawnHook( ply )

end
hook.Add( "PlayerSpawn", "TiramisuGroupSpawnHook", GroupSpawnHook )*/