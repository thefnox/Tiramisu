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

function CAKE.CreateRank( group, rank, table )
	if CAKE.GroupExists( group ) and !CAKE.RankExists( group, rank ) then
		CAKE.Groups[name]["ranks"][rank] = table
	end
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
		local roster = CAKE.GetGroupField( name, "members" )
		local tbl = {}
		tbl.Name = ply:Nick()
		tbl.SteamID = ply:SteamID()
		tbl.Signature = CAKE.GetCharSignature(ply)
		tbl.Rank = CAKE.GetGroupField( name, "DefaultRank" )
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

concommand.Add( "rp_sendinvite", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	local target = args[1]

	if ( CAKE.GroupHasMember(group, ply) and CAKE.GetRankField( group, rank, "caninvite" ) ) then
		if !CAKE.GroupHasMember(group, target) then
			target.AuthorizedToJoin = group
		end
	end

end)

concommand.Add( "rp_setgroupfield", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	local field = args[1]
	table.remove( args, 1 )
	local data = table.concat( args, " ")

	if CAKE.GroupHasMember(group, ply) and CAKE.GetRankField( group, rank, "canedit" ) then
		if type( CAKE.GetGroupField( group, field ) ) != "table" then
			if type( CAKE.GetGroupField( group, field ) ) == "number" then
				CAKE.SetGroupField( group, field, tonumber( data ) )
			elseif type( CAKE.GetGroupField( group, field ) ) == "string" then
				CAKE.SetGroupField( group, field, data )
			elseif type( CAKE.GetGroupField( group, field ) ) == "boolean" then
				CAKE.SetGroupField( group, field, util.tobool( data ) )
			end
		end
	end

end)

concommand.Add( "rp_kickfromgroup", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank")
	local target = args[1]

	if ( CAKE.GroupHasMember(group, ply) and CAKE.GetRankField( group, rank, "cankick" ) ) then
		if CAKE.GroupHasMember(group, target) then
			CAKE.LeaveGroup( target )
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

local function GroupSpawnHook( ply )

	if ply:IsCharLoaded() then
		local group = CAKE.GetCharField( ply, "group" )

		if group != none and !CAKE.GroupHasMember(group, ply) then
			CAKE.LeaveGroup( ply )
		end
	end

end
hook.Add( "PlayerSpawn", "TiramisuGroupSpawnHook", GroupSpawnHook )

function PLUGIN.Init( )


end