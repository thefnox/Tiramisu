CAKE.ItemData = {  };

function CAKE.LoadItem( schema, filename )

	local path = "schemas/" .. schema .. "/items/" .. filename;
	
	ITEM = {  };
	
	include( path );
	
	CAKE.ItemData[ ITEM.Class ] = ITEM;
	
end

function CAKE.CreateItem( class, pos, ang )

	if( CAKE.ItemData[ class ] == nil ) then return; end
	
	local itemtable = CAKE.ItemData[ class ];
	
	local item = ents.Create( "item_prop" );
	
	if string.match( class, "clothing" ) or string.match( class, "helmet" ) then
		item:SetModel( "models/props/de_tides/Vending_tshirt.mdl" )
	else
		item:SetModel( itemtable.Model );
	end
	item:SetAngles( ang );
	item:SetPos( pos );
	
	for k, v in pairs( itemtable ) do
		item[ k ] = v;
		if( type( v ) == "string" ) then
			item:SetNWString( k, v );
		end
	end
	
	item:Spawn( );
	item:Activate( );
	return item
	
end

function ccDropItem( ply, cmd, args )
	
		local inv = CAKE.GetCharField( ply, "inventory" );
		for k, v in pairs( inv ) do
			if( v == args[ 1 ] ) then
				if( string.match( v, "weapon" ) )then
					ply:StripWeapon( v )
					if( table.HasValue( CAKE.GetCharField( ply, "weapons" ), v ) ) then
						local weapons = CAKE.GetCharField( ply, "weapons" )
						for k2, v2 in pairs( weapons ) do
							if v2 == v then
								table.remove( weapons, k2 )
							end
						end
						CAKE.SetCharField( ply, "weapons", weapons )
					end
				end
				CAKE.RestoreClothing( ply )
				CAKE.RestoreGear( ply )
				CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ) );
				ply:TakeItem( args[ 1 ] );
				return;
			end
		end
	
	CAKE.CalculateEncumberment( ply )
	
	ply:RefreshInventory( )
	
end
concommand.Add( "rp_dropitem", ccDropItem );

function ccBuyItem( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank" )
	local canBuy = CAKE.GetRankField( group, rank, "canbuy" )
	local itemgroup = CAKE.ItemData[ args[ 1 ] ].ItemGroup
	if( CAKE.ItemData[ args[ 1 ] ] != nil ) then
		if( canBuy ) then --Let's make business
			local buygroups = CAKE.GetRankField( group, rank, "buygroups" )
			if( table.HasValue( buygroups, itemgroup ) ) then
				if( CAKE.ItemData[ args[ 1 ] ].Purchaseable and tonumber(CAKE.GetCharField(ply, "money" )) >= CAKE.ItemData[ args[ 1 ] ].Price ) then
					
					CAKE.ChangeMoney( ply, 0 - CAKE.ItemData[ args[ 1 ] ].Price );
					CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ) );
					
				else
					
					CAKE.SendChat( ply, "You do not have enough money to purchase this item!" );
					
				end
			else
				CAKE.SendChat( ply, "You cannot purchase this item!" );
			end
		else
				CAKE.SendChat( ply, "You do not have access to Business!" );
		end
	
	end
end
concommand.Add( "rp_buyitem", ccBuyItem );

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