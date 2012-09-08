--rp_admin globalsound soundpath
function Admin_GlobalSound( ply, cmd, args )

	if !args[1] or args[1] == "" then
		TIRA.SendError(ply, "Must specify a sound file!")
		return
	end

	umsg.Start("GlobalSound")
		umsg.String( args[1] )
	umsg.End()

end
	
function PLUGIN.Init()

	TIRA.AdminCommand( "globalsound", Admin_GlobalSound, "Play a sound globally, to all players.", true, true, 1 )
	
end