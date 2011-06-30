--rp_admin forcejoin playername groupname [rank]. Rank is optional, will default to the group's DefaultRank.
function Admin_ForceJoin( ply, cmd, args )
    
    if #args < 1 then CAKE.SendError( ply, "Must specify a player!") return end 
    local target = CAKE.FindPlayer( args[1] )

    if !target then CAKE.SendError( ply, "The target specified can not be found!") return end
    
    if args[ 2 ] and args[ 2 ] != "none" then CAKE.JoinGroup( target, args[ 2 ] ) end
    if args[ 3 ] and args[ 3 ] != "none" then CAKE.SetCharRank( target, CAKE.GetCharField( target, "group" ), args[ 3 ] ) end

    CAKE.SendError( target, "You have been forced into group: " .. CAKE.GetCharField( target, "group" ) )
    CAKE.SendGroupToClient( ply )
end

function Admin_GiveRankBusiness( ply, cmd, args )
    if #args < 3 then
        CAKE.SendError(ply, "Format: /giverankbis <group> <rank> <buygroups>")
        return false
    end

    if CAKE.RankExists(args[1], args[2]) then
        buy = {}
        for i = 3, #args do
            table.insert(buy, args[i])
        end
        CAKE.SetRankField(args[1], args[2], "buygroups", buy or {})
        ply:RefreshBusiness()
    end
end

function PLUGIN.Init( )

    CAKE.AdminCommand( "forcejoin", Admin_ForceJoin, "Force a player into a group at a set rank.", true, true, 3 );
    CAKE.AdminCommand( "giverankbis", Admin_GiveRankBusiness, "Gives a player created group's rank business.", true, true, 4 );
end