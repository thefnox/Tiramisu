PLUGIN.Name = "Groups"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles creation destruction and use of groups."; -- The description or purpose of the plugin

CAKE.Groups = {}

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
function CAKE.SetCharRank( promoter, rank, ply )
	
end

function CAKE.SetGroupFlag( name, flag, value )

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
hook.Add( "PlayerSpawn", "TiramisuGroupSpawnHook", GroupSpawnHook )