-- Set Model
concommand.Add( "rp_setmodel", function(ply, cmd, args)
	local mdl = args[ 1 ]
	
	if( ply:GetNWBool( "charactercreate") ) then
		CAKE.SetCharField(ply, "model", mdl )
	end

end )

concommand.Add( "rp_setage", function(ply, cmd, args)
	local age = args[ 1 ]
	CAKE.SetCharField(ply, "age", age )	
end )

concommand.Add( "rp_facevariation", function(ply, cmd, args)
	local skin = tonumber(args[ 1 ]) or 0
	CAKE.SetCharField(ply, "skin", skin )
end)

concommand.Add( "rp_setstartclothing", function(ply,cmd,args)
	if( ply:GetNWBool( "charactercreate") ) then
		if CAKE.ConVars[ "DefaultClothing" ][ ply:GetNWString( "gender", "Male" ) ] then

			if table.HasValue( CAKE.ConVars[ "DefaultClothing" ][ ply:GetNWString( "gender", "Male" ) ], args[1] ) then
				ply:GiveItem( args[1] )
				CAKE.SetCharField(ply, "clothing", args[1] )
			end

		end

	end
end )

concommand.Add( "rp_setgender", function(ply, cmd, args)
	local gender = args[ 1 ]
	
	if( ply:GetNWBool( "charactercreate") ) then
		CAKE.SetCharField(ply, "gender", gender )	
	end
end )

concommand.Add( "rp_begincreate", function(ply, cmd, args)

	ply:SetNWBool( "charactercreate", true )
	umsg.Start( "StartCharacterCreation", ply )
	umsg.End()

end )

-- Start Creation
concommand.Add( "rp_startcreate", function(ply, cmd, args)
	if ply:GetNWBool( "charactercreate" ) then
		ply:SetNWString( "uid", CAKE.CreateNewChar() )
	end
end )

concommand.Add( "rp_escapecreate", function(ply, cmd, args)
	if ply:GetNWBool( "charactercreate" )  then
		ply:SetNWBool( "charactercreate", false )
	end
	CAKE.SelectRandomCharacter( ply )
end )

concommand.Add( "rp_testclothing", function(ply, cmd, args)
	if ply:GetNWBool( "charactercreate" ) then
		CAKE.RemoveAllGear( ply )
		if args[ 1 ] and args[ 1 ] != "none" then
			ply:SetNWBool( "specialmodel", false ) 
			ply:SetModel( Anims[args[ 1 ]][ "models" ][1] )
			ply:SetNWString( "gender", args[ 1 ] )
			ply:SetMaterial("models/null")
		end
		if args[ 2 ] and args[ 2 ] != "none" then
			CAKE.TestClothing( ply, args[ 2 ] )
		end
		if args[ 3 ] and args[ 3 ] != "none" then
			CAKE.TestClothing( ply, args[ 2 ], args[ 3 ] )
		end
		if args[ 4 ] and args[ 4 ] != "none" then
			CAKE.TestClothing( ply, args[ 2 ], args[ 3 ], args[ 4 ] )
		end
	end
end )

concommand.Add("rp_testskin", function(ply, cmd, args)
	local skin = tonumber(args[1]) or 0
	if ply:GetNWBool( "charactercreate" ) then
		for _, ent in pairs( ply.Clothing ) do
			ent:SetSkin( skin )
		end
	end
end)

-- Finish Creation
concommand.Add( "rp_finishcreate", function(ply, cmd, args)
	if( ply:GetNWBool( "charactercreate") ) then
		
		ply:SetNWBool( "charactercreate", false )
		
		CAKE.SetCharField( ply, "inventory", CAKE.CreatePlayerInventory( ply ) , ply:GetNWString("uid"))

		
		ply:SetTeam( 1 )
		
		CAKE.SendCharList( ply )
		CAKE.ResendCharData( ply )
		
	end
end )

concommand.Add( "rp_selectchar", function(ply, cmd, args)
	local uid = args[ 1 ]
	
	CAKE.SelectChar( ply, uid )
end)

concommand.Add( "rp_spawnchar", function(ply, cmd, args) 
	local uid = args[ 1 ]
	local SteamID = CAKE.FormatText(ply:SteamID())
	
	if CAKE.CharExists( uid ) then
	
		ply:SetNWString( "uid", uid )
		
		ply:SetNWBool( "charactercreate", false )
	
		ply:SetTeam( 1 )
		ply:SetNWBool( "charloaded", true )

		ply:Spawn( )
		CAKE.ResendCharData( ply )
	end
end)

concommand.Add( "rp_ready", function(ply, cmd, args) 
	if( ply.Ready == false ) then

		ply.Ready = true
		
		timer.Simple( 1, function()
			ply:SetNWBool( "charactercreate", true )
			
			umsg.Start( "Tiramisu.InitialSpawn", ply )
				umsg.Bool( ply.FirstTimeJoining ) --This activates the intro if this is your first spawn ever. 
			umsg.End( )
		end)
		
	end
end )

concommand.Add( "rp_receivechars", function( ply, cmd, args )
	CAKE.SendCharList( ply )
	CAKE.ResendCharData( ply )
	if !util.tobool(args[1]) then
		timer.Simple( 1, function()
			CAKE.SelectRandomCharacter( ply )
		end)
	end
end)
concommand.Add( "rp_confirmremoval", function(ply, cmd, args) 
	local id = args[1]
	local name = CAKE.GetCharField( ply, "name", id)
	local age = CAKE.GetCharField( ply, "age", id)
	local model = CAKE.GetCharField( ply, "model", id)
	umsg.Start("ConfirmCharRemoval", ply)
		umsg.String( name )
		umsg.Long( id )
	umsg.End()
end )

concommand.Add( "rp_removechar", function(ply, cmd, args) 
	local id = args[1]
	CAKE.RemoveCharacter( ply, id )
	umsg.Start( "DisplayCharacterList", ply )
	umsg.End()
end )


function CAKE.SelectRandomCharacter( ply )
	local tbl = {}
	for k, _ in pairs(CAKE.GetPlayerField( ply, "characters")) do
		table.insert( tbl, k )
	end
	if table.Count( tbl ) > 0 then
		CAKE.SelectChar( ply, table.Random(tbl) )
	end
end

function CAKE.SendCharList( ply )
	umsg.Start("ClearReceivedChars", ply)
	umsg.End()
	for k, v in pairs( CAKE.GetPlayerField(ply, "characters") ) do -- Send them all their characters for selection

		umsg.Start( "ReceiveChar", ply )
			umsg.Long( v )
			umsg.String( CAKE.GetCharField(ply, "name", v) )
		umsg.End( )
		
	end
	umsg.Start("DisplayCharacterList", ply)
	umsg.End()
end

function CAKE.SelectChar( ply, uid )
	local special = CAKE.GetCharField( ply, "specialmodel", uid)
	if special == "none" or special == "" then
		ply:SetNWBool( "specialmodel", false ) 
		local m = char[ "gender" ]
		ply:SetModel( Anims[m][ "models" ][1] )
		ply:SetNWString( "gender", m )
		ply:SetMaterial("models/null")

		CAKE.TestClothing( ply,
		CAKE.GetCharField( ply, "model", uid),
		CAKE.GetCharField( ply, "clothing", uid),
		CAKE.GetCharField( ply, "helmet", uid),
		CAKE.GetCharField( ply, "headratio", uid),
		CAKE.GetCharField( ply, "bodyratio", uid),
		CAKE.GetCharField( ply, "handratio", uid),
		CAKE.GetCharField( ply, "clothingid", uid),
		CAKE.GetCharField( ply, "helmetid", uid),
		CAKE.GetCharField( ply, "bodygroup1", uid),
		CAKE.GetCharField( ply, "bodygroup2", uid),
		CAKE.GetCharField( ply, "bodygroup3", uid),
		CAKE.GetCharField( ply, "skin", uid))

		local tbl = CAKE.GetCharField( ply, "gear", uid)
		CAKE.RemoveAllGear( ply )

		for k, v in pairs( tbl ) do
			CAKE.HandleGear( ply, v[ "item" ],
			v[ "bone" ],
			v[ "itemid" ],
			v[ "offset" ],
			v[ "angle" ],
			v[ "scale" ],
			v[ "skin" ] )
		end
		
		CAKE.SendGearToClient( ply )
	else
		ply:SetNWBool( "specialmodel", true ) 
		ply:SetModel( tostring( special ) )
	end 	
	umsg.Start("SelectThisCharacter")
		umsg.Long( uid )
	umsg.End()

end