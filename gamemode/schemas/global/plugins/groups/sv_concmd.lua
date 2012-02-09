concommand.Add( "rp_joingroup", function( ply, cmd, args )

	CAKE.JoinGroup( ply, args[1], CAKE.FindPlayer( args[2] ))

end )

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
		group:Save()
		local uid = group.UniqueID
		local plygroups = CAKE.GetCharField( ply, "groups") or {}
		if !table.HasValue( plygroups, uid ) then
			table.insert( plygroups, uid )
		end
		CAKE.SetCharField( ply, "groups", table.Copy(plygroups))
		CAKE.SetCharField( ply, "activegroup", uid)

		CAKE.SendGroupToClient( ply )
	end
end)
	
concommand.Add( "rp_sendinvite", function( ply, cmd, args )
	
	local group = CAKE.GetGroup( CAKE.GetCharField( ply, "activegroup" ) )
	local target = CAKE.FindPlayer( args[1] )

	if !ply.LastInviteSent then
		ply.LastInviteSent = 0
	end

	if CurTime() - ply.LastInviteSent >= CAKE.ConVars[ "InviteTimer" ] and group and group:CharacterInGroup( ply ) and group:GetRankField( group:GetCharacterInfo( ply ).Rank, "caninvite" ) then
		if !group:CharacterInGroup( ply ) then
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
	
	local plygroups = CAKE.GetCharField( target, "groups")
	local activegroup = CAKE.GetCharField( target, "activegroup")
	for k, v in pairs( plygroups ) do
		if v == uid then
			table.remove( plygroups )
		elseif activegroup == uid then
			CAKE.SetCharField( target, "activegroup", v)
		end
	end
	CAKE.SetCharField( target, "groups", table.Copy(plygroups) )
	group:Save()
	CAKE.SendGroupToClient( target )
	CAKE.SendError( target "You have been kicked out of " .. group:GetField( "name" ))
	CAKE.SendError( target "You have kicked " .. target:Nick() .. " out of " .. group:GetField( "name" ))

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
