hook.Add( "PlayerSpawn", "TiramisuGroupSpawnHook", function( ply )
	if ply:IsCharLoaded() then
		local groups = TIRA.GetCharField( ply, "groups" )
		local group
		if groups then
			for k, group in pairs(groups) do
				if group and group != "none" then
					groupexists, fileexists = TIRA.GroupExists( group )
					if groupexists then
						local g = TIRA.GetGroup( group )
						if g and !g:GetCharacterInfo( ply ) then
							table.remove(groups, k)
							if TIRA.GetCharField( ply, "activegroup") == group and table.Count(groups) > 1 then
								TIRA.SetCharField( ply, "activegroup", table.Random(plygroups))
							end
							TIRA.SendError( ply, "You have been removed from " .. g:GetField( "name" ))
						end
					elseif !groupexists and fileexists then
						TIRA.LoadGroup( group )
					elseif !groupexists and !fileexists then
						table.remove(groups, k )
					end
				else
					table.remove(groups, k )
				end
			end
		end
		TIRA.SetCharField( ply, "groups", table.Copy(groups) )

		TIRA.SendGroupToClient( ply )
	end
end)

--Loads groups when the player is loaded, and only the ones that are going to be used.
hook.Add( "TiramisuPostPlayerLoaded", "TiramisuLoadGroups", function( ply, firsttime )
	local groupexists, fileexists
	local SteamID = TIRA.FormatText(ply:SteamID())
	if !firsttime then
		for _, char in pairs( TIRA.GetPlayerField( ply, "characters" ) ) do
			if TIRA.GetCharField( ply, "groups", uid) then
				for k, group in pairs(TIRA.GetCharField( ply, "groups", uid)) do
					if group and group != "none" then
						groupexists, fileexists = TIRA.GroupExists( group )
						if !groupexists and fileexists then
							TIRA.LoadGroup( group )
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
	local groups = TIRA.GetCharField( ply, "groups" )
	local group
	if groups then
		for k, group in pairs(groups) do
			if group and group != "none" then
				groupexists = TIRA.GroupExists( group )
				if groupexists then
					local g = TIRA.GetGroup( group )
					if g and g:GetCharacterInfo( ply ) then
						g:GetCharacterInfo( ply ).Name = name
						g:Save()
					end
				end
			end
		end
	end
end)