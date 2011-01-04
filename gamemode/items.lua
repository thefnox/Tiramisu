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
	
	if ply:ItemHasFlag( args[1], "extracargo" ) then
		CAKE.RemoveExtraCargoHold( ply, args[1] )
	else
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
				if string.match( v, "zipties" ) then
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
				CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ) );
				ply:TakeItem( args[ 1 ] );
				return;
			end
		end
	end
	
	CAKE.CalculateEncumberment( ply )
	
	ply:RefreshInventory( )
	ply:RefreshExtraInventory( );
	
end
concommand.Add( "rp_dropitem", ccDropItem );

function ccBuyItem( ply, cmd, args )
	
	local group = CAKE.GetCharField( ply, "group" )
	local rank = CAKE.GetCharField( ply, "grouprank" )
	local canBuy = CAKE.GetRankPermission( group, rank, "canbuy" )
	local itemgroup = CAKE.ItemData[ args[ 1 ] ].ItemGroup
	if( CAKE.ItemData[ args[ 1 ] ] != nil ) then
		if( canBuy ) then --Let's make business
			local buygroups = CAKE.GetRankPermission( group, rank, "buygroups" )
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