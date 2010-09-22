PLUGIN.Name = "Overlays"; -- What is the plugin name
PLUGIN.Author = "FNox"; -- Author of the plugin
PLUGIN.Description = "Handles pretty drawing shit"; -- The description or purpose of the plugin

function CAKE.ApplyHelmetEffects( ply, value )
	umsg.Start( "addtiramisuoverlay", ply )
		umsg.Short( value )
	umsg.End()
	umsg.Start( "CreatePing", ply )
	umsg.End()
end

function CAKE.RemoveHelmetEffects( ply )
	umsg.Start( "removetiramisuoverlay", ply )
	umsg.End()
	umsg.Start( "RemovePing", ply )
	umsg.End()
end

function PLUGIN.Init()
end