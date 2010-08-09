PLUGIN.Name = "Groups"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles writing to Lua files"; -- The description or purpose of the plugin

CAKE.Groups = {}
CAKE.Factions = {}

function FormatGroupName( str )
	str = string.gsub( str,":","" );
	str = string.gsub( str,"_","" );
	str = string.gsub( str,".","" );
	return str
end

function CAKE.CreateGroup( name, tbl )
	
	if !CAKE.Groups[ name ] then
		CAKE.Groups[ name ] = tbl
	end
	
	PrintTable( tbl )
	
end

function CAKE.GetGroupField( name, field )

	if CAKE.Groups[ name ] and CAKE.Groups[ name ][ field ] then	
		return CAKE.Groups[ name ][ field ]	
	else
		return false
	end	
	
end

function CAKE.SetGroupField( name, field, data )

	if CAKE.Groups[ name ] then	
		CAKE.Groups[ name ][ field ] = data
	else
		
	end	
	
	CAKE.SaveGroupData( name )
	
end

function CAKE.GetGroupFlag( name, flag )

	if CAKE.Groups[ name ] then	
		for k, v in pairs( CAKE.Groups[ name ].Flags ) do
			if k == flag then
				return v
			end
		end
	end
	
	return false
	
end

function CAKE.GetRankPermission( name, rank, permission )

	if CAKE.Groups[ name ] then
		if CAKE.Groups[ name ].Ranks[ rank ] then
			for k, v in pairs ( CAKE.Groups[ name ].Ranks[ rank ] ) do
				if k == permission then
					return v
				end
			end
		end
	end
	
	return false
	
end

function CAKE.GetRankPermissions( name, rank )

	if CAKE.Groups[ name ] then
		if CAKE.Groups[ name ].Ranks[ rank ] then
			return CAKE.Groups[ name ].Ranks[ rank ]
		end
	end
	
	return false
	
end

function CAKE.SetCharRank( promoter, rank, ply )
	
	local group = CAKE.GetCharField( promoter, "group" )
	local promoterrank = CAKE.GetCharField( promoter, "grouprank" )
	local plyrank = CAKE.GetCharField( ply, "grouprank" )
	if group == CAKE.GetCharField( ply, "group" ) and promoterrank != plyrank and CAKE.GetRankPermission( group, promoterrank, "canpromote" ) then
		local promoterlevel = CAKE.GetRankPermission( group, promoterrank, "level" )
		local plylevel = CAKE.GetRankPermission( group, plyrank, "level" )
		if promoterlevel > plylevel and promoterlevel <= CAKE.GetRankPermission( group, rank, "level" ) then
			CAKE.SetCharField( ply, "grouprank", rank )
			ply.GetLoadout = true
		end
	end
	
end

function CAKE.SetGroupFlag( name, flag, value )

	local foundflag = false
	if CAKE.Groups[ name ] then	
		for k, v in pairs( CAKE.Groups[ name ].Flags ) do
			if k == flag then
				v = value
				foundflag = true
				break
			end
		end
		
		if !foundflag then
			local tbl = {
				[flag] = value
			}
			table.Merge( CAKE.Groups[ name ].Flags, tbl )
		end
		
	end
	
end

function CAKE.SaveGroupData( name )
	
	if CAKE.Groups[ name ] then
		local str = ""
		/*
		for k, v in ipairs( CAKE.Groups[ name ] ) do
			if type( v ) == "table" then
				if #v == 0 then
					str = str .. "GROUP." .. tostring( k ) .. " = { }\n"
				else
					str = str .. "GROUP." .. tostring( k ) .. " = { " .. table.concat( v, ",") .. " }\n"
				end
			elseif type( v ) == "string" then
				str = str .. "GROUP." .. tostring( k ) .. " = \"" .. tostring( v ) .. "\"\n"
			else
				str = str .. "GROUP." .. tostring( k ) .. " = " .. tostring( v ) .. "\n"
			end
		end*/
		str = glon.encode( CAKE.Groups[ name ] )
		
		--print( str )
		file.Write( CAKE.Name .. "/GroupData/" .. CAKE.ConVars[ "Schema" ] .. "/" .. name .. ".txt" , str);
	end

end

function CAKE.RemoveGroupData( name )

	CAKE.Groups[ name ] = {}
	file.Delete( CAKE.Name .. "/GroupData/" .. CAKE.ConVars[ "Schema" ] .. "/" .. FormatGroupName( name ) .. ".txt" )
	
end

local function FetchFactions()
	
	for k, v in pairs( CAKE.Groups ) do
		if CAKE.GetGroupField( k , "type" ) == "faction" then
			CAKE.Factions[ k ] = v
		end
	end

end
hook.Add( "InitPostEntity", "FetchFactions", FetchFactions )

local function LoadAllGroups()

	local textlist = file.Find( CAKE.Name .. "/GroupData/" .. CAKE.ConVars[ "Schema" ] .. "/*.txt" )
	local raw = ""
	local cont = {}
	
	for k, v in pairs ( textlist ) do
	
		--RunString( v )
		raw = file.Read( CAKE.Name .. "/GroupData/" .. CAKE.ConVars[ "Schema" ] .. "/" .. v );
		cont = glon.decode( raw )
		CAKE.Groups[ cont.Name ] = cont
	
	end
	
	PrintTable( CAKE.Groups )

end
hook.Add( "Initialize", "LoadAllTiramisuGroups", LoadAllGroups )

local function ccCreateGroup( ply, cmd, args )
	
	local name = args[1]
	if #args < 6 then
		CAKE.SendConsole( ply, "[1], name\n[2], type\n[3], founder\n[4], members\n[5], ranks\n[6], image\n[7], tags\n" )
	elseif CAKE.Groups[ name ] then
		CAKE.SendConsole( ply, "Group already exists!" )
	else
	
	local name = args[1]
	local tbl = {
	[ "Name" ]		= name,
	[ "Type" ]		= args[2],
	[ "Founder" ]	= args[3],
	[ "Members" ]	= string.Explode( "," , args[4] ),
	[ "Inventory" ]	= {},
	[ "Flags" ]		= {},
	[ "Ranks" ]		= string.Explode( "," , args[5] ),
	[ "Image" ]		= args[6],
	[ "Tags" ]		= string.Explode( "," , args[7] )
	}
	
	CAKE.CreateGroup( name, tbl )
	CAKE.SaveGroupData( name )
	
	end
end
concommand.Add( "rp_creategroup", ccCreateGroup )

local function ccJoinGroup( ply, cmd, args )
	
	local exists
	for k, v in pairs( CAKE.Groups ) do
		if args[1] == k then
			exists = true
		end
	end
	
	if exists then
		if CAKE.GetCharField( ply, "group" ) != "None" then
			CAKE.SendChat( ply, "Please exit your current group first!" )
			CAKE.SendConsole( ply, "Please exit your current group first!" )
		else
			if CAKE.GetGroupField( args[1], "Type" ) == "public" then
				local members = CAKE.GetGroupField( args[1], "Members" )
				CAKE.SetCharField( ply, "group", args[1] )
				table.insert( members, CAKE.GetCharField( ply, "name" ))
				CAKE.SetGroupField( args[1], "Members", members )
				CAKE.SendChat( ply, "You have joined " .. args[1] )
				CAKE.SendConsole( ply, "You have joined " .. args[1] )
				for k, v in pairs( CAKE.GetGroupField( args[1], "Ranks") ) do
				
				end
			else
				CAKE.SendChat( ply, args[1] .. " is not a public group!" )
				CAKE.SendConsole( ply, args[1] .. " is not a public group!" )
			end
		end
	else
		CAKE.SendChat( ply, args[1] .. " group does not exist!" )
		CAKE.SendConsole( ply, args[1] .. " group does not exist!" )
	end
	
end
concommand.Add( "rp_joingroup", ccJoinGroup )

local function ccLeaveGroup( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local members = CAKE.GetGroupField( group, "Members" )
	local plyname = CAKE.GetCharField( ply, "name" )
	
	if members then
		for k, v in pairs( members ) do
			if v == plyname then
				v = nil
			end
		end
		if CAKE.GetGroupField( group, "Type" ) != "faction" then
			CAKE.SetGroupField( group, "Members", members )
		end
		CAKE.SendChat( ply, "You have left " .. group )
		CAKE.SendConsole( ply, "You have left " .. group )
		CAKE.SetCharField( ply, "group", "None" )
	else
		CAKE.SetCharField( ply, "group", "None" )
		CAKE.SendChat( ply, "You have left " .. group )
		CAKE.SendConsole( ply, "You have left " .. group )
	end

end
concommand.Add( "rp_leavegroup", ccLeaveGroup )

local function ccSendInvite( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank" )
	local permission = CAKE.GetRankPermission( group, rank, "canpromote" )
	local target = CAKE.FindPlayer( args[1] )
	local targetgroup = CAKE.GetCharField( target, "group" )
	
	if permission and targetgroup == "None" then
	
		if !target.Invited then
			target.Invited = {}
		end
		target.Invited[ group ] = true
		umsg.Start( ply, "recievegroupinvite" )
			umsg.String( group )
			umsg.String( ply:Nick() )
		umsg.End()
		CAKE.SendChat( ply, "You have sent " .. target:Nick() .. " a group invitation" )
		CAKE.SendConsole( ply, "You have sent " .. target:Nick() .. " a group invitation" )
	
	end

end
concommand.Add( "rp_sendinvite", ccSendInvite )

local function ccAcceptInvite( ply, cmd, args )
	
	local group = args[1]
	local rank = CAKE.GetGroupFlag( group, "primaryrank" )
	local promoter = CAKE.FindTarget( args[2] )
	
	if ply.Invited and ply.Invited[ group ] then
		CAKE.SetCharField( ply, "group", group )
		CAKE.SetCharField( ply, "grouprank", rank )
		CAKE.SendChat( ply, "You have joined " .. group .. "." )
		CAKE.SendConsole( ply, "You have joined " .. group .. "." )
		CAKE.SetCharRank( promoter, rank, ply )
	end

end
concommand.Add( "rp_acceptinvite", ccAcceptInvite )