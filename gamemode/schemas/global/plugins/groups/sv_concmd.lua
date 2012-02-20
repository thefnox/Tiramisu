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

concommand.Add( "rp_setactivegroup", function( ply, cmd, args )
	local id = args[1]
	if CAKE.GroupExists( id ) then
		local group = CAKE.GetGroup( id )
		if group:CharInGroup( ply ) then
			CAKE.SetCharField( ply, "activegroup", id )
			CAKE.SendGroupToClient( ply )
		end
	end
end)

concommand.Add( "rp_joingroup", function( ply, cmd, args )

	CAKE.JoinGroup( ply, args[1], CAKE.FindPlayer( args[2] or "nothingatall!" ))

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
				umsg.Entity( ply )
				umsg.String( group:Name() )
				umsg.String( group.UniqueID )
			umsg.End()
		else
			CAKE.SendError( ply, target:Nick() .. " is already in the group!")
		end
		ply.LastInviteSent = CurTime()
	end

end)

concommand.Add( "rp_promote", function( ply, cmd, args )

	local uid = args[3] or CAKE.GetCharField( ply, "activegroup" )
	local group = CAKE.GetGroup(uid)
	if !group or !group:CharacterInGroup( ply ) or !args[2] then return end
	if !group:GetRankField(group:GetCharacterInfo( ply ).Rank, "canpromote" ) then return end
	if tonumber(group:GetRankField(args[2], "level" )) >= tonumber(group:GetRankField(group:GetCharacterInfo( ply ).Rank, "level" )) then return end

	local roster = group:GetRoster()
	if roster[args[1]] then
		local target = CAKE.FindPlayer( roster[args[1]].SteamID )
		if target then
			CAKE.PromoteCharacter( uid, ply, target, args[2])
			CAKE.SendError( target, "You have been promoted to " .. group:GetRankField(args[2], "name"))
			CAKE.SendError( ply, "You have promoted " .. ply:Nick() .. " to: " .. group:GetRankField(args[2], "name"))
		else
			roster[args[1]].Rank = args[2]
			CAKE.SendError( ply, "You have promoted " .. roster[args[1]].Name .. " to: " .. group:GetRankField(args[2], "name"))
		end
		group:SetField( "roster", roster )
		return
	end

end)

concommand.Add( "rp_kickfromgroup", function( ply, cmd, args )

	local group = CAKE.GetGroup(args[2] or CAKE.GetCharField( ply, "activegroup" ))
	if !group or !group:CharacterInGroup( ply ) then return end
	if !group:GetRankField(group:GetCharacterInfo( ply ).Rank, "cankick" ) then return end

	local roster = group:GetRoster()
	if roster[args[1]] then
		if tonumber(group:GetRankField(roster[args[1]].Rank, "level" )) < tonumber(group:GetRankField(group:GetCharacterInfo( ply ).Rank, "level" )) then
			CAKE.SendError( ply, "You have kicked " .. roster[args[1]].Name .. " out of " .. group:GetField( "name" ))
			local target = CAKE.FindPlayer( roster[args[1]].SteamID )
			if target then
				CAKE.LeaveGroup( target, group.UniqueID, "You have been kicked out of " .. group:GetField( "name" ) )
				group:RemoveFromRoster( target )
			else
				roster[args[1]] = nil
			end
			group:SetField( "roster", roster )
			if table.Count( roster ) < 1 then
				group:Delete()
			end
		end
		return
	end

end)

concommand.Add( "rp_leavegroup", function( ply, cmd, args )
	local uid = args[1]
	if !CAKE.GroupExists( uid ) then return end
	if CAKE.GetGroup(uid) and !CAKE.GetGroup(uid):CharInGroup(ply) then return end
	CAKE.LeaveGroup( ply, uid )
end)

concommand.Add( "rp_getcharinfo", function( ply, cmd, args )
	local group = CAKE.GetGroup( args[1] )
	if !group or !args[2] then return end
	if !group:CharInGroup(ply) then return end
	local roster = group:GetRoster()

	if roster[args[2]] then
		local myrank = group:GetCharInfo( ply ).Rank
		local outranked = tonumber(group:GetRankField(roster[args[2]].Rank, "level" )) >= tonumber(group:GetRankField(myrank, "level" ))
		local tbl = {
			["groupid"] = group.UniqueID,
			["uid"] = roster[args[2]].UID,
			["rank"] = roster[args[2]].Rank,
			["name"] = roster[args[2]].Name,
			["SteamID"] = roster[args[2]].SteamID,
			["permissions"] = {
				["canpromote"] = !outranked and group:GetRankField(myrank, "canpromote" ),
				["cankick"] = !outranked and group:GetRankField(myrank, "cankick" ),
				["ranks"] = {}
			}
		}
		for k, v in pairs( group:GetField( "ranks" ) ) do
			if tonumber(v.level) < tonumber(group:GetRankField(myrank, "level" )) then
				tbl["permissions"]["ranks"][k] = v.name
			end
		end
		datastream.StreamToClients( ply, "Tiramisu.EditCharInfo", tbl )
	end
end)

concommand.Add( "rp_rostersearch", function( ply, cmd, args )

	local uid = args[1]
	table.remove( args, 1 )
	local searchstr = string.lower(table.concat( args, " " ) or "")
	local group = CAKE.GetGroup( uid )
	if !group then return end
	if !group:CharInGroup(ply) then return end

	local roster = group:GetRoster()
	local searchresults = {}
	local tbl = {}
	for k, v in pairs( roster ) do
		if string.match( string.lower(v.Name), searchstr ) or string.match( string.lower(v.SteamID), searchstr ) or string.match( string.lower(v.UID), searchstr ) or string.match( string.lower(v.Rank), searchstr ) then
			tbl = {}
			tbl.Name = v.Name
			tbl.SteamID = v.SteamID
			tbl.uid = v.UID
			table.insert( searchresults, tbl )
		end
	end
	datastream.StreamToClients( ply, "Tiramisu.GetSearchResults", {
		["uid"] = uid,
		["results"] = searchresults
	} )

end)
