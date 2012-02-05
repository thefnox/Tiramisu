-- Set Model
local function ccSetModel( ply, cmd, args )

	local mdl = args[ 1 ]
	
	if( ply:GetNWInt( "charactercreate" ) == 1 ) then

		CAKE.SetCharField(ply, "model", mdl )
		
	end
	
	return
end
concommand.Add( "rp_setmodel", ccSetModel )

local function ccSetAge( ply, cmd, args )
	
	local age = args[ 1 ]
	
			CAKE.SetCharField(ply, "age", age )	
	
	return
end
concommand.Add( "rp_setage", ccSetAge )

local function ccSetClothing( ply, cmd, args )
	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
		if CAKE.ConVars[ "Default_Clothing" ][ ply:GetNWString( "gender", "Male" ) ] then

			if table.HasValue( CAKE.ConVars[ "Default_Clothing" ][ ply:GetNWString( "gender", "Male" ) ], args[1] ) then
				ply:GiveItem( args[1] )
				CAKE.SetCharField(ply, "clothing", args[1] )
			end

		end

	end
end
concommand.Add( "rp_setstartclothing", ccSetClothing )

local function ccSetGender( ply, cmd, args )

	local gender = args[ 1 ]
	
	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
	
			CAKE.SetCharField(ply, "gender", gender )	
	end
	
	return
end
concommand.Add( "rp_setgender", ccSetGender )

local function ccBeginCreate( ply, cmd, args )

	ply:SetNWInt( "charactercreate", 1 )
	umsg.Start( "StartCharacterCreation", ply )
	umsg.End()

end
concommand.Add( "rp_begincreate", ccBeginCreate )

-- Start Creation
local function ccStartCreate( ply, cmd, args )
	
	if ply:GetNWInt( "charactercreate", 0 )> 0 then
		local PlyCharTable = CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ]
		
		-- Find the highest Unique ID
		local high = 0
		
		for k, v in pairs( PlyCharTable ) do
		
			k = tonumber( k )
			high = tonumber( high )
			
			if( k > high ) then 
			
				high = k
				
			end
			
		end
		
		high = high + 1
		ply:SetNWString( "uid", tostring(high) )

		CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ][ tostring(high) ] = {  }
	end

end
concommand.Add( "rp_startcreate", ccStartCreate )

local function ccEscapeCreate( ply, cmd, args )

	if ply:GetNWInt( "charactercreate", 0 ) > 0 then
		ply:SetNWInt( "charactercreate", 0 )
	end
	CAKE.SelectRandomCharacter( ply )

end
concommand.Add( "rp_escapecreate", ccEscapeCreate )

local function ccTestClothing( ply, cmd, args )

	if ply:GetNWInt( "charactercreate", 0 )> 0 then
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

end
concommand.Add( "rp_testclothing", ccTestClothing )

-- Finish Creation
local function ccFinishCreate( ply, cmd, args )

	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
		
		ply:SetNWInt( "charactercreate", 0 )
		
		local SteamID = CAKE.FormatText( ply:SteamID() )
		
		for fieldname, default in pairs( CAKE.CharacterDataFields ) do
		
			if( CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] == nil) then

				CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] = CAKE.ReferenceFix(default)
		
			end
			
		end
		
		ply:SetTeam( 1 )
		
		umsg.Start("ClearReceivedChars", ply)
		umsg.End()
		for k, v in pairs( CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ]["characters"] ) do -- Send them all their characters for selection

			umsg.Start( "ReceiveChar", ply )
				umsg.Long( tonumber(k) )
				umsg.String( v[ "name" ] )
			umsg.End( )
			
		end
		umsg.Start("DisplayCharacterList", ply)
		umsg.End()
		CAKE.ResendCharData( ply )
		
	end
	
end
concommand.Add( "rp_finishcreate", ccFinishCreate )

function CAKE.SelectRandomCharacter( ply )
	local tbl = {}
	for k, _ in pairs(CAKE.PlayerData[ CAKE.FormatText(ply:SteamID()) ][ "characters" ]) do
		table.insert( tbl, k )
	end
	CAKE.SelectChar( ply, table.Random(tbl) )
end

function CAKE.SelectChar( ply, uid )
	local SteamID = CAKE.FormatText(ply:SteamID())
	if( CAKE.PlayerData[ SteamID ][ "characters" ][ uid ] != nil ) then
		local char = CAKE.PlayerData[ SteamID ][ "characters" ][ uid ]
		local special = char[ "specialmodel" ]
		if special == "none" or special == "" then
			ply:SetNWBool( "specialmodel", false ) 
			local m = char[ "gender" ]
			ply:SetModel( Anims[m][ "models" ][1] )
			ply:SetNWString( "gender", m )
			ply:SetMaterial("models/null")

			CAKE.TestClothing( ply, char[ "model" ], char[ "clothing" ], char[ "helmet" ], char[ "headratio" ],char[ "bodyratio" ], char[ "handratio" ], char[ "clothingid" ], char[ "helmetid" ])

			local tbl = char[ "gear" ]
			CAKE.RemoveAllGear( ply )

			for k, v in pairs( tbl ) do
				CAKE.HandleGear( ply, v[ "item" ], v[ "bone" ], v[ "itemid" ], v[ "offset" ], v[ "angle" ], v[ "scale" ], v[ "skin" ] )
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

end

function ccSelectChar( ply, cmd, args )

	local uid = args[ 1 ]
	
	CAKE.SelectChar( ply, uid )

end
concommand.Add( "rp_selectchar", ccSelectChar )

function ccSpawnChar( ply, cmd, args )

	local uid = args[ 1 ]
	local SteamID = CAKE.FormatText(ply:SteamID())
	
	if( CAKE.PlayerData[ SteamID ][ "characters" ][ uid ] != nil ) then
	
		ply:SetNWString( "uid", uid )
		
		ply:SetNWInt( "charactercreate", 0 )
	
		ply:SetTeam( 1 )
		ply:SetNWBool( "charloaded", true )

		ply:Spawn( )
		CAKE.ResendCharData( ply )
		
	else
		
		return
		
	end

end
concommand.Add( "rp_spawnchar", ccSpawnChar )


function ccReady( ply, cmd, args )

	if( ply.Ready == false ) then

		ply.Ready = true
	
		-- Find the highest Unique ID and set it - just in case they want to create a character.
		local high = 0
		
		local PlyCharTable = CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ]["characters"]
		
		for k, v in pairs( PlyCharTable ) do
		
			k = tonumber( k )
			high = tonumber( high )
			
			if( k > high ) then 
			
				high = k
				
			end
			
		end
		
		high = high + 1
		ply:SetNWString( "uid", tostring(high) )
		
		timer.Simple( 1, function()
			ply:SetNWInt( "charactercreate", 1 )
			
			umsg.Start( "Tiramisu.InitialSpawn", ply )
				umsg.Bool( ply.FirstTimeJoining ) --This activates the intro if this is your first spawn ever. 
			umsg.End( )
		end)
		
	end
	
end
concommand.Add( "rp_ready", ccReady )

concommand.Add( "rp_receivechars", function( ply, cmd, args )
	umsg.Start("ClearReceivedChars", ply)
	umsg.End()
	for k, v in pairs( CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ]["characters"] ) do -- Send them all their characters for selection

		umsg.Start( "ReceiveChar", ply )
			umsg.Long( tonumber(k) )
			umsg.String( v[ "name" ] )
			umsg.String( v[ "model" ] )
			umsg.String( v[ "title" ] )
		umsg.End( )
		
	end
	umsg.Start("DisplayCharacterList", ply)
	umsg.End()
	if !util.tobool(args[1]) then
		CAKE.SelectRandomCharacter( ply )
	end
end)

function ccConfirmRemoval( ply, cmd, args )
	
	local id = args[1]
	local SteamID = CAKE.FormatText( ply:SteamID() )
	local name = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "name" ]
	local age = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "age" ]
	local model = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "model" ]
	umsg.Start("ConfirmCharRemoval", ply)
		umsg.String( name )
		umsg.Long( id )
	umsg.End()
end
concommand.Add( "rp_confirmremoval", ccConfirmRemoval )

local function ccRemoveChar( ply, cmd, args )
	
	local id = args[1]
	CAKE.RemoveCharacter( ply, id )
	umsg.Start( "DisplayCharacterList", ply )
	umsg.End()
	
end
concommand.Add( "rp_removechar", ccRemoveChar )
