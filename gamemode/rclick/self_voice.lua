RCLICK.Name = "Voice"
RCLICK.SubMenu = "Actions"

function RCLICK.Condition(target)

	if target == LocalPlayer() and CAKE.VoiceGroups then
		for k, v in pairs( CAKE.VoiceGroups ) do
			if CAKE.CanVoice( LocalPlayer(), k ) then
				return true
			end
		end
	end

	return false

end

function RCLICK.Click(target,ply)
	

	timer.Simple( 0, function() --This timer is so the system can close down the previous DermaMenu without closing this one too
		local dmenu = DermaMenu()
		local main = dmenu:AddSubMenu( "Voice" )
		for voicegroup, _ in pairs( CAKE.VoiceGroups ) do
			if CAKE.CanVoice( LocalPlayer(), voicegroup ) then
				local voicemenu = main:AddSubMenu( voicegroup )
				local tbl = {}
				for k, v in pairs( CAKE.Voices ) do
					if v.Group == voicegroup then
						if !tbl[v.Category] then
							tbl[v.Category] = voicemenu:AddSubMenu( v.Category )
						end
					end
				end
				for k, v in pairs( CAKE.Voices ) do
					if v.Group == voicegroup then
						tbl[v.Category]:AddOption(v.Name, function() RunConsoleCommand("rp_voice", k) end)
					end
				end
			end
		end
		dmenu:Open()
	end)

end