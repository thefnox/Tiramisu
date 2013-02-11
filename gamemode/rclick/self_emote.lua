RCLICK.Name = "Play Emote"
RCLICK.SubMenu = "Actions"

function RCLICK.Condition(target)

	if target == LocalPlayer() and Anims[ LocalPlayer():GetGender() ].Emotes then return true end

end

function RCLICK.Click(target,ply)

	
	timer.Simple( 0, function() --This timer is so the system can close down the previous DermaMenu without closing this one too
		local dmenu = DermaMenu()
		local main = dmenu:AddSubMenu( "Play Emote" )
		for name, emote in pairs( Anims[ LocalPlayer():GetGender() ].Emotes ) do
			main:AddOption( emote["name"], function() RunConsoleCommand( "rp_emote", name ) end)
		end
		dmenu:Open()
	end)

end