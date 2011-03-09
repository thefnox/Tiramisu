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

	if( CAKE.PlayerRank( ply ) > 0 ) then return true; end
	return false;
	
end

function GM:PlayerGiveSWEP( ply )

	if( CAKE.PlayerRank( ply ) > 0 ) then return true; end
	return false; 
	
end

-- This is the help menu
function GM:ShowHelp( ply )
	
	umsg.Start( "showhelpmenu", ply )
	umsg.End()

end

function GM:ShowTeam( ply )

	umsg.Start( "toggleinventory", ply )
	umsg.End()

end

function GM:ShowSpare1( ply )

	ply:SetAiming( !ply:GetAiming() )

end

function GM:ShowSpare2( ply )

	umsg.Start( "togglethirdperson", ply )
	umsg.End()

end

-- NO SENT FOR YOU.
function GM:PlayerSpawnSENT( ply, class )
	
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

	CAKE.SetCharField( ply, "title", title );
	ply:SetNWString("title", title);
	
	return;
	
end
concommand.Add( "rp_title", ccSetTitle );

-- Change IC Name
function ccChangeName( ply, cmd, args )

	local name = table.concat( args, " " )
	CAKE.SetCharField(ply, "name", name );
	ply:SetNWString("name", name);
	
end
concommand.Add( "rp_changename", ccChangeName );

function ccLockDoor( ply, cmd, args )
	
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( CAKE.IsDoor( door ) ) then
		if( door.owner != nil ) and door.owner == ply then
			door:Fire( "lock", "", 0 );
		else
			CAKE.SendChat( ply, "This is not your door!" );
		end
	end

end
concommand.Add( "rp_lockdoor", ccLockDoor );

function ccUnLockDoor( ply, cmd, args )
	
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( CAKE.IsDoor( door ) ) then
		if( door.owner != nil ) and door.owner == ply then
			door:Fire( "unlock", "", 0 );
		else
			CAKE.SendChat( ply, "This is not your door!" );
		end
	end

end
concommand.Add( "rp_unlockdoor", ccUnLockDoor );

function ccOpenDoor( ply, cmd, args )

	local entity = ply:GetEyeTrace( ).Entity
	local group = CAKE.GetCharField( ply, "group" )
	local doorgroup = CAKE.GetGroupFlag( group, "doorgroups" ) or 0
	
	if( entity != nil and entity:IsValid( ) and CAKE.IsDoor( entity ) and ply:GetPos( ):Distance( entity:GetPos( ) ) < 200 ) then
		local pos = entity:GetPos( );
		for k, v in pairs( CAKE.Doors ) do
			if( tonumber( v[ "x" ] ) == math.ceil( tonumber( pos.x ) ) and tonumber( v[ "y" ] ) == math.ceil( tonumber( pos.y ) ) and tonumber( v[ "z" ] ) == math.ceil( tonumber( pos.z ) ) ) then
				if( tonumber( v[ "group" ] ) == doorgroup ) then
					entity:Fire( "toggle", "", 0 );
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
				CAKE.SendChat( ply, "Door Owned" );

			end
			
		elseif( door.owner == ply ) then
		
			door.owner = nil;
			CAKE.ChangeMoney( ply, 50 );
			CAKE.SetDoorTitle( door, "" )
			CAKE.SendChat( ply, "Door Unowned" );
			
		else
		
			CAKE.SendChat( ply, "This door is already rented by someone else!" );
			
		end
	
	end
	
end
concommand.Add( "rp_purchasedoor", ccPurchaseDoor );

local function ccDoorTitle( ply, cmd, args )

	local door = ply:GetEyeTrace( ).Entity
	if ValidEntity( door ) and CAKE.IsDoor( door ) and door.owner == ply then
		local title = table.concat( args, " " )
		CAKE.SetDoorTitle( door, title )
	end

end
concommand.Add( "rp_doortitle", ccDoorTitle )

function ccDropWeapon( ply, cmd, args )
	
		local wep = ply:GetActiveWeapon( )
		CAKE.DropWeapon( ply, wep )
		if ply:HasItem( wep:GetClass() ) then
			ply:TakeItem( wep:GetClass() )
		end
		CAKE.RemoveGearItem( ply, wep:GetClass() )

		ply:RefreshInventory( )
	
end
concommand.Add( "rp_dropweapon", ccDropWeapon );

function ccPickupItem( ply, cmd, args )

	local item = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" and item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then
		if CAKE.CanPickupItem( ply, item.Class ) then
			if ply:ItemHasFlag( item.Class , "extracargo" ) then
				CAKE.SetCharField( ply, "extracargo", tonumber( ply:GetFlagValue( item.Class, "extracargo" ) ) )
			end
			if( string.match( item.Class, "weapon" ) ) then
				if !table.HasValue( CAKE.GetCharField( ply, "weapons" ), item.Class) then
					local weapons = CAKE.GetCharField( ply, "weapons" )
					table.insert( weapons, item.Class )
					CAKE.SetCharField( ply, "weapons", weapons )
				end
				ply:Give( item.Class )
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

	ply:RefreshInventory( )

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

	ply:RefreshInventory( )

end
concommand.Add( "rp_useitem", ccUseItem );

function ccUseOnInventory( ply, cmd, args )

	local item = CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ) )
	
	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" ) then
		
		if( string.match( item.Class, "clothing" ) or string.match( item.Class, "helmet" ) or string.match( item.Class, "weapon" ) ) then
			if( string.match( item.Class, "weapon" ) ) then
				ply:Give( item.Class )
			end
			item:Pickup( ply );
			CAKE.SavePlayerData( ply )
		else
			ply:TakeItem( item.Class )
			item:UseItem( ply );
		end
		
	end

	ply:RefreshInventory( )

end
concommand.Add( "rp_useinventory", ccUseOnInventory)	

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
	local SteamID = CAKE.FormatText( ply:SteamID() );
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


local function ccKnockOut( ply, cmd, args )

	CAKE.UnconciousMode( ply )
	
end
concommand.Add( "rp_passout", ccKnockOut )

local function ccWakeUp( ply, cmd, args )

	if ply:GetNWBool( "unconciousmode", false ) then
		CAKE.UnconciousMode( ply )
	end

end
concommand.Add( "rp_wakeup", ccWakeUp )

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

function ccRoll( ply, cmd, args )

	local Min = args[1];
	local Max = args[2];

		if( tonumber(args[1]) == nil and tonumber(args[2]) == nil ) then
	
			Min = 1;
			Max = 100;
		
		end

		if( tonumber(args[2]) == nil and tonumber(args[1]) != nil) then

			Min = 1;
			Max = args[1];
		
		end
	
		if( tonumber(args[1]) != nil and tonumber(args[2]) != nil) then
		
			if(tonumber(args[1]) > tonumber(args[2]) )  then

			Min = args[2];
			Max = args[1];
		
			end
		
		end
	
	local roll = math.random( Min , Max );
	
		for k, v in pairs( player.GetAll( ) ) do
		
			if( v:EyePos():Distance( ply:EyePos() ) <= 300 ) then
			
				CAKE.SendChat( v, "[Roll] " .. ply:Nick() .. " rolled a " .. roll .. " out of " .. Min .. "-" .. Max .. ".");
			
			end
		
		end
	
end
concommand.Add("rp_roll", ccRoll);