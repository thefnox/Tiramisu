CAKE.ItemData = {  };
CAKE.UData = {  };

function CAKE.LoadItem( schema, filename )

	local path = "schemas/" .. schema .. "/items/" .. filename;
	AddResource("lua", path)
	
	ITEM = {  };
	
	include( path );
	
	CAKE.ItemData[ ITEM.Class ] = ITEM;
	
end

function CAKE.SaveUData( id )
	local savetable = glon.encode(CAKE.UData[id])
	file.Write( CAKE.Name .. "/udata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. id .. ".txt" , savetable);
end

function CAKE.LoadUData( id )
	CAKE.UData[id] = glon.decode(file.Read( CAKE.Name .. "/udata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. id .. ".txt"))
end

function CAKE.SetUData( id, key, value )
	
	if not CAKE.UData[id] then
		CAKE.UData[id] = {}
	end
	CAKE.UData[id][key] = value
	CAKE.SaveUData(id)
end

function CAKE.GetUData(id, key)
	if !CAKE.UData[id] then
		CAKE.LoadUData( id )
	end
	
	if !CAKE.UData[id] or !CAKE.UData[id][key] then return nil end
	return CAKE.UData[id][key]
end

function CAKE.CreateItemID()
	local repnum = 0
	local uidfile = file.Read( CAKE.Name .. "/udata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. os.time() .. repnum .. ".txt" );
	while(uidfile) do
		uidfile = file.Read( CAKE.Name .. "/udata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. os.time() .. repnum .. ".txt" );
	end
	return os.time() .. repnum
end

function CAKE.SendItemData( ply )
	datastream.StreamToClients( ply, "NetworkItemData", CAKE.ItemData );
end

function CAKE.CreateItem( class, pos, ang, id )

	if !id then id = CAKE.CreateItemID() end
	
	if( CAKE.ItemData[ class ] == nil ) then return; end
	
	local itemtable = CAKE.ItemData[ class ];
	
	local item = ents.Create( "item_prop" );
	item.uiid = id
	
	if string.match( class, "clothing" ) or string.match( class, "helmet" ) then
		item:SetModel( "models/props/de_tides/Vending_tshirt.mdl" )
	else
		item:SetModel( CAKE.GetUData(id, "model") or itemtable.Model );
	end

	for k, v in pairs( itemtable ) do
		item[ k ] = v;
	end

	item:SetAngles( ang );
	item:SetPos( pos );
	
	item:SetNWString("Name", CAKE.GetUData(id, "name") or itemtable.Name)
	item:SetNWString("Class", itemtable.Class)
	item:SetNWString("id", id)
	
	item:Spawn( );
	item:Activate( );
	return item
	
end

function ccDropItem( ply, cmd, args )
	
		local inv = CAKE.GetCharField( ply, "inventory" );
		for k, v in pairs( inv ) do
			if v[2] == args[1] then
				if( string.match( v[1], "weapon" ) )then
					CAKE.DropWeapon( ply, args[ 1 ] )
					CAKE.RemoveGearItem( ply, args[ 1 ] )
					ply:RefreshInventory( )
					CAKE.CalculateEncumberment( ply )
					return
				end
				CAKE.RestoreClothing( ply )
				CAKE.RestoreGear( ply )
				CAKE.CreateItem( v[1], ply:CalcDrop( ), Angle( 0,0,0 ), v[2] );
				ply:TakeItemID( args[ 1 ] );
				CAKE.CalculateEncumberment( ply )	
				ply:RefreshInventory( )
				return
			end
		end
end
concommand.Add( "rp_dropitem", ccDropItem );

function ccDropItemUnspecific( ply, cmd, args )
	
		local inv = CAKE.GetCharField( ply, "inventory" );
		for k, v in pairs( inv ) do
			if v[1] == args[1] then
				if( string.match( v[1], "weapon" ) )then
					CAKE.DropWeapon( ply, args[ 1 ] )
					CAKE.RemoveGearItem( ply, args[ 1 ] )
					ply:RefreshInventory( )
					CAKE.CalculateEncumberment( ply )
					return
				end
				CAKE.RestoreClothing( ply )
				CAKE.RestoreGear( ply )
				CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ), v[2] );
				ply:TakeItem( args[ 1 ] );
				CAKE.CalculateEncumberment( ply )	
				ply:RefreshInventory( )
				return
			end
		end
end
concommand.Add( "rp_dropitemunspecific", ccDropItemUnspecific );

function ccDropAllItem( ply, cmd, args )
	
		local inv = CAKE.GetCharField( ply, "inventory" );
		for k, v in pairs( inv ) do
			if( v[1] == args[ 1 ] ) then
				if( string.match( v[1], "weapon" ) )then
					CAKE.DropWeapon( ply, args[ 1 ] )
					CAKE.RemoveGearItem( ply, args[ 1 ] )
					ply:RefreshInventory( )
					CAKE.CalculateEncumberment( ply )
					return
				else
					CAKE.RestoreClothing( ply )
					CAKE.RestoreGear( ply )
					CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ), v[2] );
					ply:TakeItem( args[ 1 ] );
				end
			end
		end
	
	CAKE.CalculateEncumberment( ply )
	
	ply:RefreshInventory( )
	
end
concommand.Add( "rp_dropallitem", ccDropAllItem );

function ccPickupItem( ply, cmd, args )

	local item = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" and item:GetPos( ):Distance( ply:GetShootPos( ) ) < 200 ) then
		if CAKE.CanPickupItem( ply, item.Class ) then
			if ply:ItemHasFlag( item.Class , "extracargo" ) then
				CAKE.SetCharField( ply, "extracargo", tonumber( ply:GetFlagValue( item.Class, "extracargo" ) ) )
			end
			if string.match( item.Class, "zipties" ) then
				ply:Give( item.Class )
			end
			item:Pickup( ply );
			ply:GiveItem( item.Class, item:GetNWString("id") );
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
	id = ply:HasItem( args [ 1 ] )
	if args [ 2 ] then funcrun = args [ 2 ] end
	
	if id then
		local item = CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ), id )
		
		if item.Unusable == true then item:Remove() end

		if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" ) then
			
			if( string.match( item.Class, "clothing" ) or string.match( item.Class, "helmet" ) or string.match( item.Class, "weapon" ) ) then
				if( string.match( item.Class, "weapon" ) ) then
					ply:Give( item.Class )
				end
				item:Pickup( ply );

				for k,v in pairs(CAKE.GetCharField(ply, "inventory")) do
					PrintTable(v)
				end
				CAKE.SavePlayerData( ply )
			else
				
				ply:TakeItem( item.Class )
				if funcrun then
					funcrun = CAKE.ItemData[ args [ 1 ] ][funcrun]
					funcrun(item, ply );
				else
					item:UseItem( ply );
				end
			end
			
		end
	end
	ply:RefreshInventory( )

end
concommand.Add( "rp_useinventory", ccUseOnInventory)	

function ccUseOnInventoryID( ply, cmd, args )
	id = args [ 1 ]
	class = ply:HasItemID(id)
	if args [ 2 ] then funcrun = args [ 2 ] end
	
	if class then
		local item = CAKE.CreateItem( class, ply:CalcDrop( ), Angle( 0,0,0 ), id )
		
		if item.Unusable == true then item:Remove() end

		if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" ) then
			
			if( string.match( class, "clothing" ) or string.match( class, "helmet" ) or string.match( class, "weapon" ) ) then
				if( string.match( class, "weapon" ) ) then
					ply:Give( class )
				end
				item:Pickup( ply );
				CAKE.SavePlayerData( ply )
			else
				
				ply:TakeItemID( id )
				if funcrun then
					funcrun = CAKE.ItemData[ class ][funcrun]
					funcrun(item, ply );
				else
					item:UseItem( ply );
				end
			end
			
		end
	end
	ply:RefreshInventory( )

end
concommand.Add( "rp_useinventoryid", ccUseOnInventoryID)

local meta = FindMetaTable( "Player" );

function meta:GiveItem( class, id )

	if !id then id = CAKE.CreateItemID() end
	CAKE.DayLog( "economy.txt", "Adding item '" .. class .. "' to " .. CAKE.FormatCharString( self ) .. " inventory" );
	local inv = CAKE.GetCharField( self, "inventory" );
	table.insert( inv, {class, id} );
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
		if( v[1] == class ) then
			inv[ k ] = nil;
			CAKE.SetCharField( self, "inventory", inv);
			CAKE.DayLog( "economy.txt", "Removing item '" .. class .. "' from " .. CAKE.FormatCharString( self ) .. " inventory" );
			return v[2];
		end
	end
	CAKE.CalculateEncumberment( self )
	
end


function meta:TakeItemID( id )
	local inv = CAKE.GetCharField(self, "inventory" );
	
	for k, v in pairs( inv ) do
		if( v[2] == id ) then
			inv[ k ] = nil;
			CAKE.SetCharField( self, "inventory", inv);
			CAKE.DayLog( "economy.txt", "Removing item '" .. v[1] .. "' from " .. CAKE.FormatCharString( self ) .. " inventory" );
			return v[1];
		end
	end
	CAKE.CalculateEncumberment( self )
	
end

function meta:RefreshInventory( )

	local newtbl = {}
	local inventory = CAKE.GetCharField( self, "inventory" )
	
	for k, v in pairs( inventory ) do
		if v then
			if CAKE.ItemData[ v[1] ] then
				newtbl[k] = {}
				newtbl[k].Name = CAKE.GetUData( v[2], "name" )
				newtbl[k].Class = CAKE.ItemData[ v[1] ].Class or "error"
				newtbl[k].Model = CAKE.GetUData( v[2], "model" )
				newtbl[k].ID = v[2]
			else
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
		if( v[1] == class ) then
			return v[2];
		end
	end
	return false
end

function meta:HasItemID( ID )
	local inv = CAKE.GetCharField(self, "inventory" );
	for k, v in pairs( inv ) do
		if( v[2] == ID ) then
			return v[1];
		end
	end
	return false
end

function meta:SetUData( item, key, value )
	id = item:GetNWString("id")
	CAKE.SetUData( id, key, value )
end

function meta:GetUData( item, key )
	id = item:GetNWString("id")
	return CAKE.GetUData( id, key )
end