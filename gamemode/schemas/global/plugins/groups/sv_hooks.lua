hook.Add( "PlayerSpawn", "TiramisuGroupSpawnHook", function( ply )
	if ply:IsCharLoaded() then
		timer.Simple( 1, function()
			local groups = CAKE.GetCharField( ply, "groups" )
			local group
			if groups then
				for k, group in pairs(groups) do
					if group and group != "none" then
						groupexists, fileexists = CAKE.GroupExists( group )
						if groupexists then
							local g = CAKE.GetGroup( group )
							if g and !g:GetCharacterInfo( ply ) then
								CAKE.LeaveGroup( ply, group )
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
		end)
	end
end)

--Loads groups when the player is loaded, and only the ones that are going to be used.
hook.Add( "TiramisuPostPlayerLoaded", "TiramisuLoadGroups", function( ply, firsttime )
	local groupexists, fileexists
	local SteamID = CAKE.FormatText(ply:SteamID())
	if !firsttime then
		for _, char in pairs( CAKE.PlayerData[ SteamID ][ "characters" ] ) do
			if char[ "groups" ] then
				for k, group in pairs(char[ "groups" ]) do
					if group and group != "none" then
						groupexists, fileexists = CAKE.GroupExists( group )
						print(CAKE.GroupExists( group ))
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

hook.Add( "PlayerLoadout", "TiramisuGroupWeaponsLoadout", function( ply )

	if ply:IsCharLoaded() then
		timer.Simple( 2, function()
			local group = CAKE.GetCharField( ply, "activegroup" )
			if CAKE.GroupExists( group ) then
				group = CAKE.GetGroup( group )
				if group and group:GetField( "type" ) == "faction" and group:CharacterInGroup( ply ) then
					local plyinfo = group:GetCharacterInfo( ply )
					for k, v in pairs( group:GetRankField( plyinfo.Rank, "loadout" ) ) do
						if !ply:HasItem( v ) then
							ply:GiveItem( v )
						end
					end
					for k, v in pairs( group:GetRankField( plyinfo.Rank, "weapons" ) ) do
						if !ply:HasWeapon( v ) then
							ply:Give( v )
						end
					end
				end
			end
		end)
	end

end)
