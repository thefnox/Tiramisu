local function GroupSpawnHook( ply )

    if ply:IsCharLoaded() then
        timer.Simple( 1, function()
            local group = CAKE.GetCharField( ply, "group" )
            local rank = CAKE.GetCharField( ply, "grouprank" )
            if CAKE.GroupExists( group ) and CAKE.GroupHasMember(group, ply) then
                if CAKE.Groups[group]["Members"] and CAKE.Groups[group]["Members"][CAKE.GetCharSignature(ply)][ "Rank" ] then
                    if rank != CAKE.Groups[group]["Members"][CAKE.GetCharSignature(ply)][ "Rank" ] then
                        CAKE.SetCharRank( ply, group, CAKE.Groups[group]["Members"][CAKE.GetCharSignature(ply)][ "Rank" ] )
                    end
                else
                    CAKE.SetCharRank( ply, group, CAKE.GetGroupField( group, "DefaultRank" ))
                end
                timer.Create( ply:SteamID() .. "groupsendtimer", 10, 0, function()
                    CAKE.SendGroupToClient( ply )
                    if !CAKE.GroupExists( CAKE.GetCharField( ply, "group" ) ) then
                        timer.Destroy( ply:SteamID() .. "groupsendtimer" )
                    end
                end)
            else
                if CAKE.GetCharField( ply, "group" ) != "none" then
                    CAKE.SendError( ply, "You have been kicked from your group."  )
                    CAKE.LeaveGroup( ply )
                end
            end
            CAKE.SendGroupToClient( ply )
        end)
    end

end
hook.Add( "PlayerSpawn", "TiramisuGroupSpawnHook", GroupSpawnHook )

hook.Add( "Initialize", "TiramisuGroupInit", function()

    CAKE.DayLog( "script.txt", "Loading all groups")
    CAKE.LoadAllGroups()
    
end)

hook.Add( "PlayerLoadout", "TiramisuGroupWeaponsLoadout", function( ply )

    if ply:IsCharLoaded() then
        timer.Simple( 1, function()
            local group = CAKE.GetCharField( ply, "group" )
            local rank = CAKE.GetCharField( ply, "grouprank" )
            if CAKE.GetGroupFlag( group, "loadouts" ) then
                for k, v in pairs( CAKE.GetRankField( group, rank, "loadout" ) or {} ) do
                    if !ply:HasItem( v ) then
                        ply:GiveItem( v )
                        if string.match( v, "weapon" ) then
                            ply:Give( v )
                        end
                    end
                end
            end
        end)
    end

end)
