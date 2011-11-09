--This file contains all group utilities. You're probably looking for something on this file if you want to modify how groups work

CAKE.Groups = {}

function sanitizeGroupName( str )
	return string.lower( string.gsub( str,"[%p%c%s]","" ) )
end

--Changes the name of a player within a group so that it's data is not lost. Used in rp_changename
function CAKE.ChangeMemberName( group, ply, oldname )

	if CAKE.GroupExists( group ) then
		local newname = CAKE.GetCharSignature( ply )
		local tbl = {}
		tbl.Name = ply:Nick()
		tbl.SteamID = ply:SteamID()
		tbl.Signature = newname
		tbl.Rank = CAKE.GetCharField( ply, "grouprank" )
		CAKE.Groups[group]["Members"][newname] = tbl
		CAKE.Groups[group]["Members"][oldname] = nil
		PrintTable( CAKE.Groups[group]["Members"][newname] )
	end

end

--Creates a new group. If the group already exists, then merge the new table with the old one.
function CAKE.CreateGroup( name, tbl )
	if !CAKE.Groups[name] then
		CAKE.Groups[name] = tbl
		CAKE.Groups[name][ "Name" ] = name
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
			local tbl = {}
			tbl.Name = ply:Nick()
			tbl.SteamID = ply:SteamID()
			tbl.Signature = CAKE.GetCharSignature( ply )
			tbl.Rank = rank
			CAKE.Groups[name]["Members"][CAKE.GetCharSignature( ply )] = tbl
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