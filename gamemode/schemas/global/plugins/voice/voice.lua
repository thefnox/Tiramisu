concommand.Add( "rp_voice", function(ply, cmd, args)
	local id = args[ 1 ]
	
	if !TIRA.Voices[ id ] then
		TIRA.SendError( ply, "This sound does not exist. Use rp_listvoices" )
		return
	end

	if !TIRA.CanVoice(ply, TIRA.Voices[ id ].Group) then
		TIRA.SendError( ply, "You don't have permission to use that voice." )
		return		
	end

	local voice = TIRA.Voices[ id ]

	local path
	if ply:GetGender() == "Female" then
		path = TIRA.Voices[ id ].FemalePath
	else
		path = TIRA.Voices[ id ].MalePath
	end

	util.PrecacheSound( path )
	ply:EmitSound( path )
end )

concommand.Add( "rp_listvoices", function(ply, cmd, args)

	TIRA.SendConsole( ply, "---List of Voices---" )
	TIRA.SendConsole( ply, "Please note, these are only for your current permissions" )
	
	for voicegroup, _ in pairs(TIRA.VoiceGroups) do

		if TIRA.CanVoice(ply, voicegroup) then
			TIRA.SendConsole( ply, "--" .. voicegroup .. "--\n\n" )
			for k, v in pairs(TIRA.Voices) do
				if v.Group == voicegroup then
					TIRA.SendConsole( ply, k .. " - " .. voice.Name .. " - " .. voice.MalePath )
				end
			end
			TIRA.SendConsole( ply, "\n")
		end
	end
	
end )