concommand.Add( "rp_write", function(ply, cmd, args)
	umsg.Start("Tiramisu.StartWrite", ply)
	umsg.End()
end)