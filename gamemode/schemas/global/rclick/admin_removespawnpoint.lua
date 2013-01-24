RCLICK.Name = "Remove Spawnpoint"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target == LocalPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 and table.Count( CAKE.SpawnPoints ) > 0 then return true end

end

function RCLICK.Click(target,ply)

	timer.Simple( 0, function() --This timer is so the system can close down the previous DermaMenu without closing this one too
		local dmenu = DermaMenu()
		local main = dmenu:AddSubMenu( "Remove Spawnpoint" )
		local spawngroups = {} 

		for spawngroup, tbl in pairs( CAKE.SpawnPoints ) do
			if !spawngroups[spawngroup] then
				spawngroups[spawngroup] = main:AddSubMenu( "Spawngroup " .. spawngroup )
			end
			for k, v in pairs( tbl ) do
				spawngroups[spawngroup]:AddOption(k , function() ply:ConCommand("rp_admin removespawn " .. tostring(spawngroup) .. " \"" .. k .. "\"")  end)
			end
		end
		dmenu:Open()
	end)

end