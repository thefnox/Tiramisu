SetGlobalInt( "rations", CAKE.MaxRations )

--rp_makeration, creates a ration if the player is a combine
concommand.Add( "rp_makeration", function( ply, cmd, args )
	if CAKE.IsCombine( ply ) then
		if GetGlobalInt( "rations" ) > 0 then
			if !args[1] then
				CAKE.CreateItem( "ration", ply:CalcDrop( ), Angle( 0,0,0 ) );
				SetGlobalInt( "rations", GetGlobalInt( "rations" ) - 1 )
			else
				for i = 1, math.Clamp( tonumber( args[1] ), 1, GetGlobalInt( "rations" ) ) do
					if GetGlobalInt( "rations" ) > 0 then
						timer.Simple( 0.1 * i, function()
							CAKE.CreateItem( "ration", ply:CalcDrop( ), Angle( 0,0,0 ) );
							SetGlobalInt( "rations", GetGlobalInt( "rations" ) - 1 )
						end)
					else
						break
					end
				end
			end
		else
			CAKE.SendError( ply, "There are no rations available at the moment!" )
		end
	else
		CAKE.SendError( ply, "You cannot create rations!" )
	end
end)