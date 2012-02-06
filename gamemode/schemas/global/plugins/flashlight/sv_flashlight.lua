function CAKE.TurnOnFlashlight(ply, cmd, arg)

	if ply.flashlight then 
		ply.flashlight:Remove()
		ply.flashlight = nil
		return
	end
	
	ply.flashlight = ents.Create( "env_projectedtexture" )	
		ply.flashlight:SetKeyValue( "enableshadows", 0 )
		ply.flashlight:SetKeyValue( "farz", 700 )
		ply.flashlight:SetKeyValue( "nearz", 8 )
		ply.flashlight:SetKeyValue( "lightfov", 50 )
		ply.flashlight:SetKeyValue( "lightcolor", "255 255 255" )
		ply.flashlight:SetPos(Vector(0, 0, 0))
		ply.flashlight:Input( "SpotlightTexture", NULL, NULL,"effects/flashlight001")
		ply.flashlight:Spawn()
		
	 
	timer.Simple(0.1, function()
		umsg.Start( "flashlighton" )
			umsg.Entity( ply )
			umsg.Entity( ply.flashlight )
			print(ply.flashlight)
		umsg.End()
	end)
end
concommand.Add( "rp_flashlight", CAKE.TurnOnFlashlight )