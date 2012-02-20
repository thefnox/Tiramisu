RCLICK.Name = "Join"
RCLICK.SubMenu = "Faction"

function RCLICK.Condition(target)

if ValidEntity(target) and target:IsTiraPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 and table.Count(CAKE.Factions) > 0 then return true end

end

function RCLICK.Click(target,ply)

	timer.Simple( 0, function() --This timer is so the system can close down the previous DermaMenu without closing this one too
		local dmenu = DermaMenu()
		local main = dmenu:AddSubMenu( "Join" )

		for faction, uid in pairs( CAKE.Factions ) do
			main:AddOption(faction, function()
				CAKE.StringRequest( "Join a faction", "Enter which rank should " .. target:Nick() .. " have in the faction (Leave blank for default)", "",
				function( entry )
					if entry == "" then
						ply:ConCommand( "rp_admin forcejoin \"" .. faction .. "\" " .. CAKE.FormatText(target:SteamID())) 
					else
						ply:ConCommand( "rp_admin forcejoin \"" .. faction .. "\" " .. CAKE.FormatText(target:SteamID()) .. " \"" .. entry .. "\"" ) 
					end
				end,
				function() end, "Accept", "Cancel" )
			end)
		end
		dmenu:Open()
	end)

end