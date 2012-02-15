datastream.Hook( "Tiramisu.GetEditGroup", function(ply, handler, id, encoded, decoded)
	local group = CAKE.GetGroup( decoded.uid or "none" )
	if group and group:CharInGroup(ply) and group:GetRankField(group:GetCharInfo( ply ).Rank, "canedit") then
		if group:Name() != decoded.name and CAKE.GroupNameExists( decoded.name ) then
			CAKE.SendError( ply, "Group name exists! Please choose another name" )
			datastream.StreamToClients( ply, "Tiramisu.EditGroup", decoded)
		else
			group:SetField("name", decoded.name)
			group:SetField("description", decoded.description)
			group:SetField("ranks", decoded.ranks)
			group:SetField("defaultrank", decoded.defaultrank)
		end
	end
end)

concommand.Add( "rp_joingroup", function( ply, cmd, args )

	CAKE.JoinGroup( ply, args[1], CAKE.FindPlayer( args[2] ))

end )

concommand.Add( "rp_editgroup", function( ply, cmd, args )
	local id = args[1]
	if CAKE.GroupExists( id ) then
		local group = CAKE.GetGroup( id )
		if group:CharInGroup( ply ) and group:GetRankField( group:GetCharInfo( ply ).Rank, "canedit" ) then
			local tbl = {
				["name"] = group:Name(),
				["defaultrank"] = group:GetField( "defaultrank" ),
				["description"] = group:GetField( "description" ),
				["uid"] = group.UniqueID,
				["ranks"] = {}
			}
			for k, v in pairs( group:GetField( "ranks" ) ) do
				tbl["ranks"][k] = {}
				tbl["ranks"][k]["canedit"] = group:GetRankField( k, "canedit" )
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

			datastream.StreamToClients( ply, "Tiramisu.EditGroup", tbl)
		end 
	end
end)

concommand.Add( "rp_getgroupinfo", function( ply, cmd, args )
	local id = args[1]
	if CAKE.GroupExists( id ) then
		local group = CAKE.GetGroup( id )
		local tbl = {}
		if group:CharInGroup( ply ) then
			tbl["name"] = group:Name()
			tbl["founder"] = group:GetField("founder")
			tbl["description"] = group:GetField("description")
			tbl["uid"] = group.UniqueID
			tbl["canedit"] = group:GetRankField( group:GetCharInfo( ply ).Rank, "canedit" )
			datastream.StreamToClients( ply, "Tiramisu.GetGroupInfo", tbl)
		end
	end
end)

concommand.Add( "rp_creategroup", function( ply, cmd, args )
	local name = table.concat( args, " " )
	if CAKE.GroupNameExists( name ) then
		umsg.Start( "Tiramisu.GroupCreateQuery", ply )
			umsg.String( name )
		umsg.End()
		CAKE.SendError( ply, "Group already exists! Please choose another name." )
	else
		local group = CAKE.CreateGroup()
		group:SetField( "name", name )
		group:AddToRoster( ply, "founder" )
		group:SetField("founder", ply:Nick() )
		group:Save()
		local uid = group.UniqueID
		local plygroups = CAKE.GetCharField( ply, "groups") or {}
		if !table.HasValue( plygroups, uid ) then
			table.insert( plygroups, uid )
		end
		CAKE.SetCharField( ply, "groups", table.Copy(plygroups))
		CAKE.SetCharField( ply, "activegroup", uid)

		CAKE.SendGroupToClient( ply )

		local tbl = {
			["name"] = group:Name(),
			["defaultrank"] = group:GetField( "defaultrank" ),
			["description"] = group:GetField( "description" ),
			["uid"] = group.UniqueID,
			["ranks"] = {}
		}
		for k, v in pairs( group:GetField( "ranks" ) ) do
			tbl["ranks"][k] = {}
			tbl["ranks"][k]["canedit"] = group:GetRankField( k, "canedit" )
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

		datastream.StreamToClients( ply, "Tiramisu.EditGroup", tbl)
	end
end)
	
concommand.Add( "rp_sendinvite", function( ply, cmd, args )
	
	local group = CAKE.GetGroup( CAKE.GetCharField( ply, "activegroup" ) )
	local target = CAKE.FindPlayer( args[1] )

	if !ply.LastInviteSent then
		ply.LastInviteSent = 0
	end

	if !ValidEntity(target) then return end

	if CurTime() - ply.LastInviteSent >= CAKE.ConVars[ "InviteTimer" ] and group and group:CharacterInGroup( ply ) and group:GetRankField( group:GetCharacterInfo( ply ).Rank, "caninvite" ) then
		if !group:CharacterInGroup( target ) then
			target.AuthorizedToJoin = group.UniqueID
			umsg.Start( "Tiramisu.GetInvite", target )
				umsg.String( group )
			umsg.End()
		else
			CAKE.SendError( ply, target:Nick() .. " is already in the group!")
		end
		ply.LastInviteSent = CurTime()
	end

end)

concommand.Add( "rp_promote", function( ply, cmd, args )
	
	local group = CAKE.GetGroup(CAKE.GetCharField( ply, "activegroup" ))
	if !group or !group:CharacterInGroup( ply ) then return end

	local target = CAKE.FindPlayer( args[1] )
	if !target or !args[2] or !group:CharacterInGroup( target ) or !group:IsRank(args[2]) then return end

	if !group:GetRankField(group:GetCharacterInfo( ply ).Rank, "canpromote" ) then return end

	CAKE.PromoteCharacter( CAKE.GetCharField( ply, "activegroup" ), ply, target, args[2])
	CAKE.SendError( ply, "You have promoted " .. target:Nick() " to: " .. group:GetRankField(args[2], "name"))
	CAKE.SendError( target, "You have been promoted to " .. group:GetRankField(args[2], "name"))

end)

concommand.Add( "rp_kickfromgroup", function( ply, cmd, args )


	local group = CAKE.GetGroup(CAKE.GetCharField( ply, "activegroup" ))
	if !group or !group:CharacterInGroup( ply ) then return end

	local target = CAKE.FindPlayer( args[1] )
	if !target or !group:CharacterInGroup( target ) then return end

	if !group:GetRankField(group:GetCharacterInfo( ply ).Rank, "cankick" ) or group:GetRankField(group:GetCharacterInfo( target ).Rank, "level" ) >= group:GetRankField(group:GetCharacterInfo( ply ).Rank, "level" ) then return end
	
	local uid = group.UniqueID
	local plygroups = CAKE.GetCharField( target, "groups")
	local activegroup = CAKE.GetCharField( target, "activegroup")
	for k, v in pairs( plygroups ) do
		if v == uid then
			table.remove( plygroups, k )
		elseif activegroup != uid then
			CAKE.SetCharField( target, "activegroup", v or "none")
		end
	end
	CAKE.SetCharField( target, "groups", table.Copy(plygroups) )
	group:Save()
	CAKE.SendGroupToClient( target )
	CAKE.SendError( target, "You have been kicked out of " .. group:GetField( "name" ))
	CAKE.SendError( ply, "You have kicked " .. target:Nick() .. " out of " .. group:GetField( "name" ))

end)

concommand.Add( "rp_leavegroup", function( ply, cmd, args )
	local uid = args[1]
	if !CAKE.GroupExists( uid ) then return end
	if CAKE.GetGroup(uid) and !CAKE.GetGroup(uid):CharInGroup(ply) then return end
	CAKE.LeaveGroup( ply, uid )
end)

concommand.Add( "rp_rostersearch", function( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "groups" )
	if CAKE.GroupExists( group ) then
		local searchstring = table.concat( args, " " )
		local roster = CAKE.GetGroupField( group, "Members" )
		local searchresults = {}
		local tbl = {}
		for k, v in pairs( roster ) do
			if ( string.match( string.lower( v.Name ), string.lower( searchstring )) or string.lower( v.Name ) == string.lower( searchstring ) ) or
			string.match( searchstring, v.SteamID ) or
			((v.Rank != false) and(string.match( searchstring, v.Rank ))) or
			string.match( searchstring, CAKE.GetRankField( group, v.Rank, "formalname" ) or "None" ) then
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
