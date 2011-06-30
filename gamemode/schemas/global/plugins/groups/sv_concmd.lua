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
        tbl[ "Name" ]       = name
        tbl[ "Type" ]       = "public"
        tbl[ "Founder" ]    = ply:Nick()
        tbl[ "Members" ]    = {}
        tbl[ "Inventory" ]  = {}
        tbl[ "Description" ]= "" 
        tbl[ "Flags" ]      = {}
        tbl[ "Ranks" ]      = {
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
            print( string.lower( v.Name ) )
            print( string.lower( searchstring ) )
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