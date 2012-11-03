net.Receive( "Tiramisu.GetEditGroup", function(len, ply)
	local decoded = net.ReadTable()
	local group = TIRA.GetGroup( decoded.uid or "none" )
	if group and group:CharInGroup(ply) and group:GetRankField(group:GetCharInfo( ply ).Rank, "canedit") then
		if group:Name() != decoded.name and TIRA.GroupNameExists( decoded.name ) then
			TIRA.SendError( ply, "Group name exists! Please choose another name" )
			net.Start("Tiramisu.EditGroup")
				net.WriteTable(decoded)
			net.Send(ply)
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
	if TIRA.GroupExists( id ) then
		local group = TIRA.GetGroup( id )
		if group:CharInGroup( ply ) then
			TIRA.SetCharField( ply, "activegroup", id )
			TIRA.SendGroupToClient( ply )
		end
	end
end)

concommand.Add( "rp_joingroup", function( ply, cmd, args )

	TIRA.JoinGroup( ply, args[1], TIRA.FindPlayer( args[2] or "nothingatall!" ))

end )

concommand.Add( "rp_editgroup", function( ply, cmd, args )
	local id = args[1]
	if TIRA.GroupExists( id ) then
		local group = TIRA.GetGroup( id )
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
			net.Start("Tiramisu.EditGroup")
				net.WriteTable(tbl)
			net.Send(ply)
		end 
	end
end)

concommand.Add( "rp_getgroupinfo", function( ply, cmd, args )
	local id = args[1]
	if TIRA.GroupExists( id ) then
		local group = TIRA.GetGroup( id )
		local tbl = {}
		if group:CharInGroup( ply ) then
			tbl["name"] = group:Name()
			tbl["founder"] = group:GetField("founder")
			tbl["description"] = group:GetField("description")
			tbl["uid"] = group.UniqueID
			tbl["inventory"] = group:GetField("inventory")
			tbl["canedit"] = group:GetRankField( group:GetCharInfo( ply ).Rank, "canedit" )
			net.Start("Tiramisu.GetGroupInfo")
				net.WriteTable(tbl)
			net.Send(ply)
		end
	end
end)

concommand.Add( "rp_creategroup", function( ply, cmd, args )
	local name = table.concat( args, " " )
	if TIRA.GroupNameExists( name ) then
		umsg.Start( "Tiramisu.GroupCreateQuery", ply )
			umsg.String( name )
		umsg.End()
		TIRA.SendError( ply, "Group already exists! Please choose another name." )
	else
		local group = TIRA.CreateGroup()
		group:SetField( "name", name )
		group:AddToRoster( ply, "founder" )
		group:SetField("founder", ply:Nick() )
		group:Save()
		local uid = group.UniqueID
		local plygroups = TIRA.GetCharField( ply, "groups") or {}
		if !table.HasValue( plygroups, uid ) then
			table.insert( plygroups, uid )
		end
		TIRA.SetCharField( ply, "groups", table.Copy(plygroups))
		TIRA.SetCharField( ply, "activegroup", uid)

		TIRA.SendGroupToClient( ply )

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
		net.Start("Tiramisu.EditGroup")
			net.WriteTable(tbl)
		net.Send(ply)
	end
end)
	
concommand.Add( "rp_sendinvite", function( ply, cmd, args )
	
	local group = TIRA.GetGroup( TIRA.GetCharField( ply, "activegroup" ) )
	local target = TIRA.FindPlayer( args[1] )

	if !ply.LastInviteSent then
		ply.LastInviteSent = 0
	end

	if !ValidEntity(target) then return end

	if CurTime() - ply.LastInviteSent >= TIRA.ConVars[ "InviteTimer" ] and group and group:CharacterInGroup( ply ) and group:GetRankField( group:GetCharacterInfo( ply ).Rank, "caninvite" ) then
		if !group:CharacterInGroup( target ) then
			target.AuthorizedToJoin = group.UniqueID
			umsg.Start( "Tiramisu.GetInvite", target )
				umsg.Entity( ply )
				umsg.String( group:Name() )
				umsg.String( group.UniqueID )
			umsg.End()
		else
			TIRA.SendError( ply, target:Nick() .. " is already in the group!")
		end
		ply.LastInviteSent = CurTime()
	end

end)

concommand.Add( "rp_promote", function( ply, cmd, args )

	local uid = args[3] or TIRA.GetCharField( ply, "activegroup" )
	local group = TIRA.GetGroup(uid)
	if !group or !group:CharacterInGroup( ply ) or !args[2] then return end
	if !group:GetRankField(group:GetCharacterInfo( ply ).Rank, "canpromote" ) then return end
	if tonumber(group:GetRankField(args[2], "level" )) >= tonumber(group:GetRankField(group:GetCharacterInfo( ply ).Rank, "level" )) then return end

	local roster = group:GetRoster()
	if roster[args[1]] then
		local target = TIRA.FindPlayer( roster[args[1]].SteamID )
		if target then
			TIRA.PromoteCharacter( uid, ply, target, args[2])
			TIRA.SendError( target, "You have been promoted to " .. group:GetRankField(args[2], "name"))
			TIRA.SendError( ply, "You have promoted " .. ply:Nick() .. " to: " .. group:GetRankField(args[2], "name"))
		else
			roster[args[1]].Rank = args[2]
			TIRA.SendError( ply, "You have promoted " .. roster[args[1]].Name .. " to: " .. group:GetRankField(args[2], "name"))
		end
		group:SetField( "roster", roster )
		return
	end

end)

concommand.Add( "rp_kickfromgroup", function( ply, cmd, args )

	local group = TIRA.GetGroup(args[2] or TIRA.GetCharField( ply, "activegroup" ))
	if !group or !group:CharacterInGroup( ply ) then return end
	if !group:GetRankField(group:GetCharacterInfo( ply ).Rank, "cankick" ) then return end

	local roster = group:GetRoster()
	if roster[args[1]] then
		if tonumber(group:GetRankField(roster[args[1]].Rank, "level" )) < tonumber(group:GetRankField(group:GetCharacterInfo( ply ).Rank, "level" )) then
			TIRA.SendError( ply, "You have kicked " .. roster[args[1]].Name .. " out of " .. group:GetField( "name" ))
			local target = TIRA.FindPlayer( roster[args[1]].SteamID )
			if target then
				TIRA.LeaveGroup( target, group.UniqueID, "You have been kicked out of " .. group:GetField( "name" ) )
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
	if !TIRA.GroupExists( uid ) then return end
	if TIRA.GetGroup(uid) and !TIRA.GetGroup(uid):CharInGroup(ply) then return end
	TIRA.LeaveGroup( ply, uid )
end)

concommand.Add( "rp_getcharinfo", function( ply, cmd, args )
	local group = TIRA.GetGroup( args[1] )
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
			["rankname"] = group:GetRankField(roster[args[2]].Rank, "name"),
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
		net.Start("Tiramisu.EditCharInfo")
			net.WriteTable(tbl)
		net.Send(ply)
	end
end)

concommand.Add( "rp_rostersearch", function( ply, cmd, args )

	local uid = args[1]
	table.remove( args, 1 )
	local searchstr = string.lower(table.concat( args, " " ) or "")
	local group = TIRA.GetGroup( uid )
	if !group then return end
	if !group:CharInGroup(ply) then return end

	local roster = group:GetRoster()
	local searchresults = {}
	local tbl = {}
	if searchstr == "" then
		for k, v in pairs( roster ) do
			tbl = {}
			tbl.Name = v.Name
			tbl.SteamID = v.SteamID
			tbl.uid = v.UID
			table.insert( searchresults, tbl )
		end
	else
		for k, v in pairs( roster ) do
			if string.match( string.lower(v.Name), searchstr ) or string.match( string.lower(v.SteamID), searchstr ) or string.match( string.lower(v.UID), searchstr ) or string.match( string.lower(v.Rank), searchstr ) then
				tbl = {}
				tbl.Name = v.Name
				tbl.SteamID = v.SteamID
				tbl.uid = v.UID
				table.insert( searchresults, tbl )
			end
		end
	end
	net.Start("Tiramisu.GetSearchResults")
		net.WriteTable({
			["uid"] = uid,
			["results"] = searchresults
		} )
	net.Send(ply)

end)
