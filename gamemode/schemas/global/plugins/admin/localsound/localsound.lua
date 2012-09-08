--rp_admin globalsound soundpath
function Admin_LocalSound( ply, cmd, args )

	if !args[1] or args[1] == "" then
		TIRA.SendError(ply, "Must specify a sound file!")
		return
	end

	umsg.Start("LocalSound")
		umsg.String( ply:Nick() )
		umsg.String( args[1] )
	umsg.End()

end
	
function PLUGIN.Init()

	TIRA.AdminCommand( "localsound", Admin_LocalSound, "Play a sound locally, from an entity.", true, true, 1 )
	
end