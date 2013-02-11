concommand.Add( "rp_voice", function(ply, cmd, args)
	local id = args[ 1 ]
	
	if !CAKE.Voices[ id ] then
		CAKE.SendError( ply, "This sound does not exist. Use rp_listvoices" )
		return
	end

	if !CAKE.CanVoice(ply, CAKE.Voices[ id ].Group) then
		CAKE.SendError( ply, "You don't have permission to use that voice." )
		return		
	end

	local voice = CAKE.Voices[ id ]

	local path
	if ply:GetGender() == "Female" then
		path = CAKE.Voices[ id ].FemalePath
	else
		path = CAKE.Voices[ id ].MalePath
	end

	util.PrecacheSound( path )
	ply:EmitSound( path )
end )

concommand.Add( "rp_listvoices", function(ply, cmd, args)

	CAKE.SendConsole( ply, "---List of Voices---" )
	CAKE.SendConsole( ply, "Please note, these are only for your current permissions" )
	
	for voicegroup, _ in pairs(CAKE.VoiceGroups) do

		if CAKE.CanVoice(ply, voicegroup) then
			CAKE.SendConsole( ply, "--" .. voicegroup .. "--\n\n" )
			for k, v in pairs(CAKE.Voices) do
				if v.Group == voicegroup then
					CAKE.SendConsole( ply, k .. " - " .. voice.Name .. " - " .. voice.MalePath )
				end
			end
			CAKE.SendConsole( ply, "\n")
		end
	end
	
end )