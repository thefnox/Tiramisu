-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- concmd.lua
-- Contains the concommands and changes the way other concommands work.
-------------------------------

-- Deprecated, PlayerGiveSwep does the same thing.
-- function NoSweps( ply, cmd, args )
-- 
-- 	if( CAKE.PlayerRank( ply ) > 0 ) then ply:Give( args[ 1 ] ); else return false; end
-- 	
-- end
-- concommand.Add( "gm_giveswep", NoSweps );

function GM:PlayerSpawnSWEP( ply, class )

	CAKE.CallTeamHook( "PlayerSpawnSWEP", ply, class ); -- Perhaps allow certain flags to use sweps, eh?
	
	if( CAKE.PlayerRank( ply ) > 0 ) then return true; end
	return false;
	
end

function GM:PlayerGiveSWEP( ply )

	CAKE.CallTeamHook( "PlayerGiveSWEP", ply, class ); -- Perhaps allow certain flags to use sweps, eh?

	if( CAKE.PlayerRank( ply ) > 0 ) then return true; end
	return false; 
	
end

CAKE.MenuOpen = false
-- This is the F1 menu
function GM:ShowHelp( ply )

	local PlyCharTable = CAKE.PlayerData[ CAKE.FormatSteamID( ply:SteamID() ) ]["characters"]

	for k, v in pairs( PlyCharTable ) do
		
		umsg.Start( "ReceiveChar", ply );
			umsg.Long( k );
			umsg.String( v[ "name" ] );
			umsg.String( v[ "model" ] );
		umsg.End( );
		
	end
	
	if CAKE.MenuOpen then
		umsg.Start( "closeplayermenu", ply );
		umsg.End( )
	else
		umsg.Start( "openplayermenu", ply );
		umsg.End( )
	end
	CAKE.MenuOpen = !CAKE.MenuOpen
	
end

-- NO SENT FOR YOU.
function GM:PlayerSpawnSENT( ply, class )

	CAKE.CallTeamHook( "PlayerSpawnSWEP", ply, class ); -- Perhaps allow certain flags to use sents, eh?
	
	if( CAKE.PlayerRank( ply ) > 0 ) then return true; end
	return false;
	
end

-- Disallows suicide
function GM:CanPlayerSuicide( ply )

	if( CAKE.ConVars[ "SuicideEnabled" ] != "1" ) then
	
		ply:ChatPrint( "Suicide is disabled!" )
		return false
		
	end
	
	return true;
	
end

-- Set Title
function ccSetTitle( ply, cmd, args )

	local title = table.concat( args, " " )
	
	if( string.len( title ) > 63 ) then
	
		CAKE.SendChat( ply, "Title is too long! Max 32 characters" );
		return;
		
	end
	
	CAKE.SetCharField( ply, "title", title );
	ply:SetNWString("title", title);
	
	return;
	
end
concommand.Add( "rp_title", ccSetTitle );

function ccSetTitle2( ply, cmd, args )

	local title = table.concat( args, " " )
	
	if( string.len( title ) > 63 ) then
	
		CAKE.SendChat( ply, "Title is too long! Max 32 characters" );
		return;
		
	end
	
	CAKE.SetCharField( ply, "title2", title );
	ply:SetNWString("title2", title);
	
	return;
	
end
concommand.Add( "rp_title2", ccSetTitle2 );

-- Change IC Name
function ccChangeName( ply, cmd, args )

	local name = table.concat( args, " " )
	CAKE.SetCharField(ply, "name", name );
	ply:SetNWString("name", name);
	
end
concommand.Add( "rp_changename", ccChangeName );

-- Allows a player to skip the respawn timer.
function ccAcceptDeath( ply, cmd, args )

	ply.deathtime = 120;
	ply.CheatedDeath = true
	
end
concommand.Add( "rp_acceptdeath", ccAcceptDeath );

function ccFlag( ply, cmd, args )
	
	local FlagTo = "";
	
	for k, v in pairs( CAKE.Teams ) do
	
		if( v[ "flag_key" ] == args[ 1 ] ) then
		
			FlagTo = v;
			FlagTo.n = k;
			break;
			
		end
		
	end
	
	if( FlagTo == "" ) then
	
		CAKE.SendChat( ply, "Incorrect Flag!" );
		return;
		
	end

	if( ( CAKE.GetCharField(ply, "flags" ) != nil and table.HasValue( CAKE.GetCharField( ply, "flags" ), args[ 1 ] ) ) or FlagTo[ "public" ] ) then
		
		ply:SetTeam( FlagTo.n );
		ply:RefreshBusiness();
		ply:Spawn( );
		return;
				
	else
	
		CAKE.SendChat( ply, "You do not have this flag!" );
		
	end		
	
end
concommand.Add( "rp_flag", ccFlag );

function ccLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( CAKE.IsDoor( entity ) ) then

		entity:Fire( "lock", "", 0 );
			
	end

end
concommand.Add( "rp_lockdoor", ccLockDoor );

function ccUnLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( CAKE.IsDoor( entity ) ) then
	
			entity:Fire( "unlock", "", 0 );

	end

end
concommand.Add( "rp_unlockdoor", ccUnLockDoor );

function ccOpenDoor( ply, cmd, args )

	local entity = ply:GetEyeTrace( ).Entity;
	
	if( entity != nil and entity:IsValid( ) and CAKE.IsDoor( entity ) and ply:GetPos( ):Distance( entity:GetPos( ) ) < 200 ) then
	
		local pos = entity:GetPos( );
		
		for k, v in pairs( CAKE.Doors ) do
		
			if( tonumber( v[ "x" ] ) == math.ceil( tonumber( pos.x ) ) and tonumber( v[ "y" ] ) == math.ceil( tonumber( pos.y ) ) and tonumber( v[ "z" ] ) == math.ceil( tonumber( pos.z ) ) ) then
			
				for k2, v2 in pairs( CAKE.Teams[ ply:Team( ) ][ "door_groups" ] ) do
				
					if( tonumber( v[ "group" ] ) == tonumber( v2 ) ) then
					
						entity:Fire( "toggle", "", 0 );
						
					end
					
				end
				
			end
			
		end
		
	end
	
end
concommand.Add( "rp_opendoor", ccOpenDoor );

function ccPurchaseDoor( ply, cmd, args )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	local pos = door:GetPos( );
	
	for k, v in pairs( CAKE.Doors ) do
		
		if( tonumber( v[ "x" ] ) == math.ceil( tonumber( pos.x ) ) and tonumber( v[ "y" ] ) == math.ceil( tonumber( pos.y ) ) and tonumber( v[ "z" ] ) == math.ceil( tonumber( pos.z ) ) ) then
		
			CAKE.SendChat( ply, "This is not a purchaseable door!" );
			return;
			
		end
		
	end
	
	if( CAKE.IsDoor( door ) ) then

		if( door.owner == nil ) then
		
			if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= 50 ) then
				
				-- Enough money to start off, let's start the rental.
				CAKE.ChangeMoney( ply, -50 );
				door.owner = ply;
				
				local function Rental( ply, doornum )
				
					local door = ents.GetByIndex( tonumber( doornum ) );
					
					if( door.owner == ply ) then
					
						if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= 50 ) then
						
							CAKE.ChangeMoney( ply, 0 - 50 );
							CAKE.SendChat( ply, "You have been charged 50 credits for a door!" );
							-- Start the timer again
							timer.Simple( 900, Rental, ply, doornum ); -- 15 minutes hoo rah
							
						else
						
							CAKE.SendChat( ply, "You have lost a door due to insufficient funds." );
							door.owner = nil;
							
						end
						
					end
				
				end
				
				timer.Simple( 900, Rental, ply, tonumber( args[ 1 ] ) );
				
			end
			
		elseif( door.owner == ply ) then
		
			door.owner = nil;
			CAKE.SendChat( ply, "Door Unowned" );
			
		else
		
			CAKE.SendChat( ply, "This door is already rented by someone else!" );
			
		end
	
	end
	
end
concommand.Add( "rp_purchasedoor", ccPurchaseDoor );

function ccDropWeapon( ply, cmd, args )
	
		local wep = ply:GetActiveWeapon( )
		CAKE.DropWeapon( ply, wep )
		if ply:HasItem( wep:GetClass() ) then
			ply:TakeItem( wep:GetClass() )
		end
		CAKE.RemoveGearItem( ply, wep:GetClass() )
	
end
concommand.Add( "rp_dropweapon", ccDropWeapon );

function ccPickupItem( ply, cmd, args )
	
	local item = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" and item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then
		if CAKE.CanPickupItem( ply, item.Class ) then
			if ply:ItemHasFlag( item.Class , "extracargo" ) then
				CAKE.SetCharField( ply, "extracargo", tonumber( ply:GetFlagValue( item.Class, "extracargo" ) ) )
				if item.IsContainer then
					for k,v in pairs(item.Inv) do
						ply:GiveExtraItem( v )
						CAKE.TakeContItem( item, v )
					end
				end
			end
			if( string.match( item.Class, "weapon" ) ) then
				if !table.HasValue( CAKE.GetCharField( ply, "weapons" ), item.Class) then
					local weapons = CAKE.GetCharField( ply, "weapons" )
					table.insert( weapons, item.Class )
					CAKE.SetCharField( ply, "weapons", weapons )
				end
				ply:Give( item.Class )
				CAKE.HandleGear( ply, item.Class )
				CAKE.SaveGear( ply )
			end
			if string.match( item.Class, "zipties" ) then
				ply:Give( item.Class )
			end
			item:Pickup( ply );
			ply:GiveItem( item.Class );
		else
			CAKE.SendChat( ply, "Clean up some space in your inventory before picking up this item!" )
			CAKE.SendConsole( ply, "Clean up some space in your inventory before picking up this item!" )
		end
		
	end

end
concommand.Add( "rp_pickup", ccPickupItem );

function ccUseItem( ply, cmd, args )
	
	local item = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" and item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then
		
		if( string.match( item.Class, "clothing" ) or string.match( item.Class, "helmet" ) or string.match( item.Class, "weapon" ) ) then
			if( string.match( item.Class, "weapon" ) ) then
				ply:Give( item.Class )
			end
			item:Pickup( ply );
			ply:GiveItem( item.Class );
			CAKE.SavePlayerData( ply )
		else
			item:UseItem( ply );
		end
		
	end

end
concommand.Add( "rp_useitem", ccUseItem );

function ccGiveMoney( ply, cmd, args )
	
	if( player.GetByID( args[ 1 ] ) != nil ) then
	
		local target = player.GetByID( args[ 1 ] );
		
		if( tonumber( args[ 2 ] ) > 0 ) then
		
			if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= tonumber( args[ 2 ] ) ) then
			
				CAKE.ChangeMoney( target, args[ 2 ] );
				CAKE.ChangeMoney( ply, 0 - args[ 2 ] );
				CAKE.SendChat( ply, "You gave " .. target:Nick( ) .. " " .. args[ 2 ] .. " credits!" );
				CAKE.SendChat( target, ply:Nick( ) .. " gave you " .. args[ 2 ] .. " credits!" );
				
			else
			
				CAKE.SendChat( ply, "You do not have that many tokens!" );
				
			end
			
		else
		
			CAKE.SendChat( ply, "Invalid amount of money!" );
			
		end
		
	else
	
		CAKE.SendChat( ply, "Target not found!" );
		
	end
	
end
concommand.Add( "rp_givemoney", ccGiveMoney );	

function ccOpenChat( ply, cmd, args )

	ply:SetNWInt( "chatopen", 1 )
	
end
concommand.Add( "rp_openedchat", ccOpenChat );

function ccCloseChat( ply, cmd, args )

	ply:SetNWInt( "chatopen", 0 )
	
end
concommand.Add( "rp_closedchat", ccCloseChat );

function ccConfirmRemoval( ply, cmd, args )
	
	local id = args[1]
	local SteamID = CAKE.FormatSteamID( ply:SteamID() );
	local name = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "name" ]
	local birthplace = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "birthplace" ]
	local gender = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "gender" ]
	local description = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "description" ]
	local age = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "age" ]
	local model = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "model" ]
	umsg.Start("ConfirmCharRemoval", ply)
		umsg.String( name )
		umsg.String( gender )
		umsg.String( description )
		umsg.String( age )
		umsg.String( model )
		umsg.Long( id )
	umsg.End()
end
concommand.Add( "rp_confirmremoval", ccConfirmRemoval )

local function ccRemoveChar( ply, cmd, args )
	
	local id = args[1]
	CAKE.RemoveCharacter( ply, id )
	
end
concommand.Add( "rp_removechar", ccRemoveChar )

/*
local function ccEditGear( ply, cmd, args )

	local ent = ents.GetByIndex( tonumber( args[ 1 ] ) )
	datastream.StreamToClients( ply, "EditGear", { ["entity"] = ent });
end
concommand.Add( "rp_editgear", ccEditGear )*/

local function ccCodeItem( ply, cmd, args )
	
	local flags = string.Explode( ",", args[8] )
	local itemgroups = string.Explode( ",", args[7] )
	local tbl = {
		["Class"] = args[1],
		["Name"] = args[2],
		["Description"] = args[3],
		["Model"] =	args[4],
		["Purchaseable"] = util.tobool( args[5] ),
		["Price"] = tonumber( args[6] ),
		["ItemGroup" ] = itemgroups,
		["Flags"] = flags
	}

	CAKE.CodeItem( args[1], tbl )
	
end
concommand.Add( "rp_codeitem", ccCodeItem )

local function ccKnockOut( ply, cmd, args )

	CAKE.UnconciousMode( ply )
	
end
concommand.Add( "rp_passout", ccKnockOut )

local function ccArrest( ply, cmd, args )

	local trace = ply:GetEyeTrace( )
	if trace.StartPos:Distance( trace.HitPos ) < 150 then
		if ply:HasItem( "zipties" ) then
			if trace.Entity:IsPlayer() then
				CAKE.ArrestPlayer( ply, trace.Entity )
			elseif trace.Entity.ply:IsPlayer() then
				CAKE.ArrestPlayer( ply, trace.Entity.ply )
			end
		end
	end
	
end
concommand.Add( "rp_arrest", ccArrest )