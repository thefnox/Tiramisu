RCLICK.Name = "Set Mood"

function RCLICK.Condition(target)

	if target == LocalPlayer() then return true end

end

function RCLICK.Click(target,ply)

	
	timer.Simple( 0, function() --This timer is so the system can close down the previous DermaMenu without closing this one too
		local dmenu = DermaMenu()
		local main = dmenu:AddSubMenu( "Set Personality" )
		for _, personality in pairs( Anims.PersonalityTypes ) do
			main:AddOption( personality:sub(1,1):upper() .. personality:sub(2), function() RunConsoleCommand( "t_setpersonality", personality ) end)
		end
		dmenu:Open()
	end)

end