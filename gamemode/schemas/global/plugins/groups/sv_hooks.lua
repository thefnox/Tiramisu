hook.Add( "PlayerSpawn", "TiramisuGroupSpawnHook", function( ply )
	if ply:IsCharLoaded() then
		local groups = CAKE.GetCharField( ply, "groups" )
		local group
		if groups then
			for k, group in pairs(groups) do
				if group and group != "none" then
					groupexists, fileexists = CAKE.GroupExists( group )
					if groupexists then
						local g = CAKE.GetGroup( group )
						if g and !g:GetCharacterInfo( ply ) then
							table.remove(groups, k)
							if CAKE.GetCharField( ply, "activegroup") == group and table.Count(groups) > 1 then
								CAKE.SetCharField( ply, "activegroup", table.Random(plygroups))
							end
							CAKE.SendError( ply, "You have been removed from " .. g:GetField( "name" ))
						end
					elseif !groupexists and fileexists then
						CAKE.LoadGroup( group )
					elseif !groupexists and !fileexists then
						table.remove(groups, k )
					end
				else
					table.remove(groups, k )
				end
			end
		end
		CAKE.SetCharField( ply, "groups", table.Copy(groups) )

		CAKE.SendGroupToClient( ply )
	end
end)

--Loads groups when the player is loaded, and only the ones that are going to be used.
hook.Add( "TiramisuPostPlayerLoaded", "TiramisuLoadGroups", function( ply, firsttime )
	local groupexists, fileexists
	local SteamID = CAKE.FormatText(ply:SteamID())
	if !firsttime then
		for _, char in pairs( CAKE.GetPlayerField( ply, "characters" ) ) do
			if CAKE.GetCharField( ply, "groups", uid) then
				for k, group in pairs(CAKE.GetCharField( ply, "groups", uid)) do
					if group and group != "none" then
						groupexists, fileexists = CAKE.GroupExists( group )
						if !groupexists and fileexists then
							CAKE.LoadGroup( group )
							print( "Loading group", group )
						elseif !groupexists and !fileexists then
							print( "Removing group", group )
							table.remove(char[ "groups" ], k )
						end
					end
				end
			end
		end 
	end
end)

--Updates the name of a player in the group, whenever rp_changename is performed.
hook.Add( "TiramisuPlayerChangeName", "TiramisuRefreshNameInGroup", function( ply, name, oldname)
	local groups = CAKE.GetCharField( ply, "groups" )
	local group
	if groups then
		for k, group in pairs(groups) do
			if group and group != "none" then
				groupexists = CAKE.GroupExists( group )
				if groupexists then
					local g = CAKE.GetGroup( group )
					if g and g:GetCharacterInfo( ply ) then
						g:GetCharacterInfo( ply ).Name = name
						g:Save()
					end
				end
			end
		end
	end
end)