-- Set Model
concommand.Add( "rp_setmodel", function(ply, cmd, args)
	local mdl = args[ 1 ]
	
	if( ply:GetNWBool( "charactercreate") ) then
		TIRA.SetCharField(ply, "model", mdl )
	end

end )

concommand.Add( "rp_setage", function(ply, cmd, args)
	local age = args[ 1 ]
	TIRA.SetCharField(ply, "age", age )	
end )

concommand.Add( "rp_facevariation", function(ply, cmd, args)
	local skin = tonumber(args[ 1 ]) or 0
	TIRA.SetCharField(ply, "skin", skin )
end)

concommand.Add( "rp_setstartclothing", function(ply,cmd,args)
	if( ply:GetNWBool( "charactercreate") ) then
		if TIRA.ConVars[ "DefaultClothing" ][ ply:GetNWString( "gender", "Male" ) ] then

			if table.HasValue( TIRA.ConVars[ "DefaultClothing" ][ ply:GetNWString( "gender", "Male" ) ], args[1] ) then
				ply:GiveItem( args[1] )
				TIRA.SetCharField(ply, "clothing", args[1] )
			end

		end

	end
end )

concommand.Add( "rp_setgender", function(ply, cmd, args)
	local gender = args[ 1 ]
	
	if( ply:GetNWBool( "charactercreate") ) then
		TIRA.SetCharField(ply, "gender", gender )	
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
		ply:SetNWString( "uid", TIRA.CreateNewChar() )
	end
end )

concommand.Add( "rp_escapecreate", function(ply, cmd, args)
	if ply:GetNWBool( "charactercreate" )  then
		ply:SetNWBool( "charactercreate", false )
	end
	TIRA.SelectRandomCharacter( ply )
end )

concommand.Add( "rp_testclothing", function(ply, cmd, args)
	if ply:GetNWBool( "charactercreate" ) then
		TIRA.RemoveAllGear( ply )
		if args[ 1 ] and args[ 1 ] != "none" then
			ply:SetNWBool( "specialmodel", false ) 
			ply:SetModel( Anims[args[ 1 ]][ "models" ][1] )
			ply:SetNWString( "gender", args[ 1 ] )
			ply:SetMaterial("models/null")
		end
		if args[ 2 ] and args[ 2 ] != "none" then
			TIRA.TestClothing( ply, args[ 2 ] )
		end
		if args[ 3 ] and args[ 3 ] != "none" then
			TIRA.TestClothing( ply, args[ 2 ], args[ 3 ] )
		end
		if args[ 4 ] and args[ 4 ] != "none" then
			TIRA.TestClothing( ply, args[ 2 ], args[ 3 ], args[ 4 ] )
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
		
		TIRA.SetCharField( ply, "inventory", TIRA.CreatePlayerInventory( ply ) , ply:GetNWString("uid"))
		local chars = TIRA.GetPlayerField( ply, "characters" ) or {}
		table.insert(chars, ply:GetNWString("uid"))
		TIRA.SetPlayerField(ply, "characters", chars)
		
		ply:SetTeam( 1 )
		
		TIRA.SendCharList( ply )
		TIRA.ResendCharData( ply )
		
	end
end )

concommand.Add( "rp_selectchar", function(ply, cmd, args)
	local uid = args[ 1 ]
	print("SELECTING:", uid, "\n")
	TIRA.SelectChar( ply, uid )
end)

concommand.Add( "rp_spawnchar", function(ply, cmd, args) 
	local uid = args[ 1 ]
	local SteamID = TIRA.FormatText(ply:SteamID())
	
	if TIRA.CharExists( uid ) then
	
		ply:SetNWString( "uid", uid )
		print("SPAWNING",uid,"\n")
		
		ply:SetNWBool( "charactercreate", false )
	
		ply:SetTeam( 1 )
		ply:SetNWBool( "charloaded", true )

		ply:Spawn( )
		TIRA.ResendCharData( ply )
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
	TIRA.SendCharList( ply )
	TIRA.ResendCharData( ply )
	if !util.tobool(args[1]) then
		timer.Simple( 1, function()
			TIRA.SelectRandomCharacter( ply )
		end)
	end
end)
concommand.Add( "rp_confirmremoval", function(ply, cmd, args) 
	local id = args[1]
	local name = TIRA.GetCharField( ply, "name", id)
	local age = TIRA.GetCharField( ply, "age", id)
	local model = TIRA.GetCharField( ply, "model", id)
	umsg.Start("ConfirmCharRemoval", ply)
		umsg.String( name )
		umsg.Long( id )
	umsg.End()
end )

concommand.Add( "rp_removechar", function(ply, cmd, args) 
	local id = args[1]
	TIRA.RemoveCharacter( ply, id )
	umsg.Start( "DisplayCharacterList", ply )
	umsg.End()
end )


function TIRA.SelectRandomCharacter( ply )
	local tbl = TIRA.GetPlayerField( ply, "characters") or {}
	if table.Count( tbl ) > 0 then
		TIRA.SelectChar( ply, table.Random(tbl) )
	end
end

function TIRA.SendCharList( ply )
	umsg.Start("ClearReceivedChars", ply)
	umsg.End()
	for k, v in pairs( TIRA.GetPlayerField(ply, "characters") or {} ) do -- Send them all their characters for selection

		umsg.Start( "ReceiveChar", ply )
			umsg.Long( v )
			umsg.String( TIRA.GetCharField(ply, "name", v) or "" )
		umsg.End( )
		
	end
	umsg.Start("DisplayCharacterList", ply)
	umsg.End()
end

function TIRA.SelectChar( ply, uid )
	local special = TIRA.GetCharField( ply, "specialmodel", uid)
	if special == "none" or special == "" then
		local query = TIRA.Query("SELECT gender,model,clothing,helmet,handratio,bodyratio,headratio,clothingid,helmetid,bodygroup1,bodygroup2,bodygroup3,skin,gear FROM tiramisu_chars WHERE id='" .. uid .. "'")
		local char = query[1]
		for fieldname, value in pairs(char) do
			if type(TIRA.CharacterDataFields[ fieldname ]) == "table" then char[fieldname] = TIRA.Deserialize(value) or {} end
			if type(TIRA.CharacterDataFields[ fieldname ]) == "string" then if type(char[fieldname]) != "string" then char[fieldname] = tostring(value) or "" end end
			if type(TIRA.CharacterDataFields[ fieldname ]) == "number" then char[fieldname] = tonumber(value) or 0 end
			if type(TIRA.CharacterDataFields[ fieldname ]) == "boolean" then char[fieldname] = util.tobool(value) or false end
		end
		local m = char["gender"]
		PrintTable(char)
		ply:SetNWBool( "specialmodel", false ) 
		ply:SetModel( Anims[m][ "models" ][1] )
		ply:SetNWString( "gender", char[ "gender" ])
		ply:SetMaterial("models/null")

		CAKE.TestClothing( ply, char[ "model" ], char[ "clothing" ], char[ "helmet" ], char[ "headratio" ],char[ "bodyratio" ], char[ "handratio" ], char[ "clothingid" ], char[ "helmetid" ], char[ "bodygroup1"], char[ "bodygroup2"], char[ "bodygroup3"], char[ "skin"])

		CAKE.RemoveAllGear( ply )

		for k, v in pairs( char[ "gear" ] ) do
			CAKE.HandleGear( ply, v[ "item" ], v[ "bone" ], v[ "itemid" ], v[ "offset" ], v[ "angle" ], v[ "scale" ], v[ "skin" ] )
		end
			
		TIRA.SendGearToClient( ply )
	else
		ply:SetNWBool( "specialmodel", true ) 
		ply:SetModel( tostring( special ) )
	end 	
	umsg.Start("SelectThisCharacter")
		umsg.Long( uid )
	umsg.End()

end