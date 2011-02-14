-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- charactercreate.lua
-- Contains the character creation concommands.
-------------------------------	

-- Set Model
function ccSetModel( ply, cmd, args )

	local mdl = args[ 1 ];
	
	if( ply:GetNWInt( "charactercreate" ) == 1 ) then

		CAKE.SetCharField(ply, "model", mdl );
		
	end
	
	return;
end
concommand.Add( "rp_setmodel", ccSetModel );

function ccSetAge( ply, cmd, args )
	
	local age = args[ 1 ];
	
			CAKE.SetCharField(ply, "age", age );	
	
	return;
end
concommand.Add( "rp_setage", ccSetAge );


function ccSetGender( ply, cmd, args )

	local gender = args[ 1 ];
	
	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
	
			CAKE.SetCharField(ply, "gender", gender );	
	end
	
	return;
end
concommand.Add( "rp_setgender", ccSetGender );

-- Start Creation
function ccStartCreate( ply, cmd, args )
	
	local PlyCharTable = CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ]
	
	-- Find the highest Unique ID
	local high = 0;
	
	for k, v in pairs( PlyCharTable ) do
	
		k = tonumber( k );
		high = tonumber( high );
		
		if( k > high ) then 
		
			high = k;
			
		end
		
	end
	
	high = high + 1;
	ply:SetNWString( "uid", tostring(high) );
	
	ply:SetNWInt( "charactercreate", 1 );
	CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ][ tostring(high) ] = {  }
	
end
concommand.Add( "rp_startcreate", ccStartCreate );

-- Finish Creation
function ccFinishCreate( ply, cmd, args )

	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
		
		ply:SetNWInt( "charactercreate", 0 )
		
		local SteamID = CAKE.FormatText( ply:SteamID() );
		
		for fieldname, default in pairs( CAKE.CharacterDataFields ) do
		
			if( CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] == nil) then

				CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] = CAKE.ReferenceFix(default);
		
			end
			
		end
		
		CAKE.ResendCharData( ply );

		ply:RefreshInventory( )
		ply:RefreshBusiness( )
		
		ply:SetTeam( 1 );
		
		ply:Spawn( );
		
		ply:ConCommand( "fadein" );
		
	end
	
end
concommand.Add( "rp_finishcreate", ccFinishCreate );

function ccSelectChar( ply, cmd, args )

	local uid = args[ 1 ];
	local SteamID = CAKE.FormatText(ply:SteamID());
	
	if( CAKE.PlayerData[ SteamID ][ "characters" ][ uid ] != nil ) then

		if( CAKE.PlayerData[ SteamID ][ "characters" ][ uid ][ "gender" ] == "Female" ) then
			ply:SetModel( "models/Tiramisu/AnimationTrees/femaleanimtree.mdl" )
			ply:SetNWString( "gender", "Female" )
		else
			ply:SetModel( "models/Tiramisu/AnimationTrees/maleanimtree.mdl" )
			ply:SetNWString( "gender", "Male" )
		end
	
		CAKE.TestClothing( ply, CAKE.PlayerData[ SteamID ][ "characters" ][ uid ][ "model" ], CAKE.PlayerData[ SteamID ][ "characters" ][ uid ][ "clothing" ], CAKE.PlayerData[ SteamID ][ "characters" ][ uid ][ "helmet" ], CAKE.PlayerData[ SteamID ][ "characters" ][ uid ][ "gloves" ] )
		
	else
		
		return;
		
	end

end
concommand.Add( "rp_selectchar", ccSelectChar );

function ccSpawnChar( ply, cmd, args )

	local uid = args[ 1 ];
	local SteamID = CAKE.FormatText(ply:SteamID());
	
	if( CAKE.PlayerData[ SteamID ][ "characters" ][ uid ] != nil ) then
	
		ply:SetNWString( "uid", uid );
		CAKE.ResendCharData( ply );
		
		ply:SetNWInt( "charactercreate", 0 );
	
		ply:SetTeam( 1 );
		
		ply:RefreshInventory( )
		ply:RefreshBusiness( )
		
		ply:ConCommand( "fadein" );
		ply:SetNWBool( "charloaded", true )

		ply:Spawn( );
		
	else
		
		return;
		
	end

end
concommand.Add( "rp_spawnchar", ccSpawnChar );

function ccReady( ply, cmd, args )

	if( ply.Ready == false ) then

		ply.Ready = true;
	
		-- Find the highest Unique ID and set it - just in case they want to create a character.
		local high = 0;
		
		local PlyCharTable = CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ]["characters"];
		
		for k, v in pairs( PlyCharTable ) do
		
			k = tonumber( k );
			high = tonumber( high );
			
			if( k > high ) then 
			
				high = k;
				
			end
			
		end
		
		high = high + 1;
		ply:SetNWString( "uid", tostring(high) );
		
		for k, v in pairs( PlyCharTable ) do -- Send them all their characters for selection
	
			umsg.Start( "ReceiveChar", ply );
				umsg.Long( tonumber(k) );
				umsg.String( v[ "name" ] );
				umsg.String( v[ "model" ] );
				umsg.String( v[ "title" ] );
				umsg.String( v[ "title2" ] );
			umsg.End( );
			
		end
		
		ply:SetNWInt( "charactercreate", 1 )
		
		umsg.Start( "charactercreate", ply );
		umsg.End( );
		
	end
	
end
concommand.Add( "rp_ready", ccReady );