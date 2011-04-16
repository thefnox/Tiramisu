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
					CAKE.DropWeapon( ply, args[ 1 ] )
					CAKE.RemoveGearItem( ply, args[ 1 ] )
					ply:RefreshInventory( )
					CAKE.CalculateEncumberment( ply )
					return
				end
				CAKE.RestoreClothing( ply )
				CAKE.RestoreGear( ply )
				CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ) );
				ply:TakeItem( args[ 1 ] );
			end
		end
	
	CAKE.CalculateEncumberment( ply )
	
	ply:RefreshInventory( )
	
end
concommand.Add( "rp_dropitem", ccDropItem );

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

local meta = FindMetaTable( "Player" );

function meta:GiveItem( class )

	CAKE.DayLog( "economy.txt", "Adding item '" .. class .. "' to " .. CAKE.FormatCharString( self ) .. " inventory" );
	local inv = CAKE.GetCharField( self, "inventory" );
	table.insert( inv, class );
	CAKE.SetCharField( self, "inventory", inv);
	CAKE.CalculateEncumberment( self )
	if string.match( class, "weapon" ) then
		if !table.HasValue( CAKE.GetCharField( self, "inventory" ), class ) then
			if !table.HasValue( CAKE.GetCharField( self, "weapons" ), class) then
				local weapons = CAKE.GetCharField( self, "weapons" )
				table.insert( weapons, class )
				CAKE.SetCharField( self, "weapons", weapons )
			end
			self:Give( class )
		end 
	end

end

function meta:TakeItem( class )
	local inv = CAKE.GetCharField(self, "inventory" );
	
	for k, v in pairs( inv ) do
		if( v == class ) then
			inv[ k ] = nil;
			CAKE.SetCharField( self, "inventory", inv);
			CAKE.DayLog( "economy.txt", "Removing item '" .. class .. "' from " .. CAKE.FormatCharString( self ) .. " inventory" );
			return;
		end
	end
	CAKE.CalculateEncumberment( self )
	
end

function meta:RefreshInventory( )

	local newtbl = {}
	local inventory = CAKE.GetCharField( self, "inventory" )
	
	for k, v in pairs( inventory ) do
		if v then
			if CAKE.ItemData[ v ] then
				newtbl[k] = {}
				newtbl[k].Name = CAKE.ItemData[ v ].Name or "Error Item"
				newtbl[k].Class = CAKE.ItemData[ v ].Class or "error"
				newtbl[k].Description = CAKE.ItemData[ v ].Description or "Grab a programmer!"
				newtbl[k].Model = CAKE.ItemData[ v ].Model or "models/error.mdl"
				newtbl[k].Unusable = CAKE.ItemData[ v ].Unusable or false
			else
				newtbl[k] = {}
				newtbl[k].Name = "Error Item: " .. v 
				newtbl[k].Class = v
				newtbl[k].Description = "Grab a programmer!"
				newtbl[k].Model = "models/error.mdl"
				newtbl[k].Unusable = true
				table.remove( inventory, k )
			end
		end
	end

	CAKE.SetCharField( self, "inventory", inventory)
		
	datastream.StreamToClients( self, "addinventory", newtbl )

end

function meta:ItemHasFlag( item, flag )
	
	if !CAKE.ItemData[ item ] then
		return false
	end

	if !CAKE.ItemData[ item ].Flags then
		CAKE.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( CAKE.ItemData[ item ].Flags ) do
		if type( v ) == "table" then
			for k2, v2 in pairs( v ) do
				if string.match( v2, flag ) then
					return true
				end
			end
		end
		if string.match( v, flag ) then
			return true
		end
	end
	
	return false

end

function meta:GetFlagValue( item, flag )

	if !CAKE.ItemData[ item ].Flags then
		CAKE.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( CAKE.ItemData[ item ].Flags ) do
		if type( v ) == "table" then
			for k2, v2 in pairs( v ) do
				if string.match( v2, flag ) then
					local exp = string.Explode( ";", v2 )
					return exp[2] or true
				end
			end
		end
		if string.match( v, flag ) then
			local exp = string.Explode( ";", v )
			return exp[2] or true
		end
	end
	
	return false

end

function meta:HasItem( class )
	local inv = CAKE.GetCharField(self, "inventory" );
	for k, v in pairs( inv ) do
		if( v == class ) then
			return true
		end
	end
	return false
end