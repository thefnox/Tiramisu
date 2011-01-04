PLUGIN.Name = "Inventory Weight"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles the weighting of items"; -- The description or purpose of the plugin

local meta = FindMetaTable( "Player" )

function meta:TakeExtraItem( item )

	local inv = CAKE.GetCharField(self, "extrainventory" );
	for k, v in pairs( inv ) do
		if( v == class ) then
			inv[ k ] = nil;
			CAKE.SetCharField( self, "extrainventory", inv);
			self:RefreshExtraInventory( );
			CAKE.DayLog( "economy.txt", "Removing item '" .. class .. "' from " .. CAKE.FormatCharString( self ) .. " extra inventory" );
			return;
		end
	end
	
end

function meta:GiveExtraItem( class )

	CAKE.DayLog( "economy.txt", "Adding item '" .. class .. "' to " .. CAKE.FormatCharString( self ) .. " extra inventory" );
	local inv = CAKE.GetCharField( self, "extrainventory" );
	table.insert( inv, class );
	CAKE.SetCharField( self, "extrainventory", inv);
	self:RefreshExtraInventory( );

end

function meta:ClearExtraInventory( )
	umsg.Start( "ClearExtraInventory", self )
	umsg.End( );
end

function meta:SetExtraCargo()

	umsg.Start( "SetAdditionalCargo", self )
		umsg.Short( CAKE.GetCharField( self, "extracargo" ));
	umsg.End( );
	
end

function meta:RefreshExtraInventory( )

	self:ClearExtraInventory( )
	self:SetExtraCargo()
	
	for k, v in pairs( CAKE.GetCharField( self, "extrainventory" ) ) do
		umsg.Start( "AddExtraItem", self );
			umsg.String( CAKE.ItemData[ v ].Name );
			umsg.String( CAKE.ItemData[ v ].Class );
			umsg.String( CAKE.ItemData[ v ].Description );
			umsg.String( CAKE.ItemData[ v ].Model );
			umsg.Short( CAKE.GetWeight( v ) );
		umsg.End( );
	end
end

function CAKE.GetWeight( item )
	
	if CAKE.ItemData[ item ] then
		if CAKE.ItemData[ item ].Weight then
			return tonumber( CAKE.ItemData[ item ].Weight ) -- I wish this was harder to do, but I guess it is this simple...
		end
	end	
	
	return 1

end

function CAKE.CalculateAvailableSpace( ply )

	local sum = 0
	local total = CAKE.GetCharField( ply, "cargo" )

	for k, v in pairs( CAKE.GetCharField( ply, "inventory" ) ) do
		sum = sum + CAKE.GetWeight( v )
	end
	
	return total - sum -- Ironically this is not a sum.

end

function CAKE.AddExtraCargo( ply, item )

	local exp = tonumber( ply:GetFlagValue( item, "extracargo" ))

	CAKE.SetCharField( ply, "extracargo", CAKE.GetCharField( ply, "extracargo" ) + exp )

end

function CAKE.RemoveExtraCargoHold( ply, item )

	local total = CAKE.GetCharField( ply, "extracargo" )
	local exp = tonumber( ply:GetFlagValue( item, "extracargo" ) )
	local curexp = exp
	local extrainventory = CAKE.GetCharField( ply, "extrainventory" )
	local drop = {}
	
	for k, v in pairs( extrainventory ) do
		if CAKE.GetWeight( v ) <= curexp then
			table.insert( drop, v )
			curexp = curexp - CAKE.GetWeight( v )
			table.remove( extrainventory, k )
		end
	end
	
	local itemtable = CAKE.ItemData[ item ];
	local itemprop = ents.Create( "item_prop" );
	for k, v in pairs( itemtable ) do
		itemprop[ k ] = v;
		if( type( v ) == "string" ) then
			itemprop:SetNWString( k, v );
		end
	end
	itemprop:SetModel( itemtable.Model );
	itemprop:SetAngles( Angle( 0,0,0 ));
	itemprop:SetPos( ply:CalcDrop( ) );
	itemprop:Spawn( );
	itemprop:Activate( );
	
	CAKE.AddCType( itemprop:GetModel(), exp )
	CAKE.AddContainer( itemprop )
	for k, v in pairs( drop ) do
		CAKE.AddContItem( itemprop, v )
	end
	
	ply:TakeItem( item );
	
	CAKE.SetCharField( ply, "extracargo", total - exp )
	CAKE.SetCharField( ply, "extrainventory", extrainventory )

end

function CAKE.AddExtraCargoItem( ply, item )
	
	local inventory = CAKE.GetCharField( ply, "extrainventory" )
	local total = CAKE.GetCharField( ply, "extracargo" )
	
	if CAKE.GetWeight( item ) <= total then
		ply:GiveExtraItem( item )
		ply:TakeItem( item )
	
		ply:RefreshInventory( )
		ply:RefreshExtraInventory( )
	else
		CAKE.SendChat( ply, "Free up your extra cargohold to be able to put this item inside it!" )
		CAKE.SendConsole( ply, "Free up your extra cargohold to be able to put this item inside it!" )
	end

end

function CAKE.TransferFromExtraCargo( ply, item )

	local inventory = CAKE.GetCharField( ply, "inventory" )
	local total = CAKE.GetCharField( ply, "cargo" )
	
	if CAKE.GetWeight( item ) <= total then
		ply:GiveItem( item )
	else
		CAKE.SendChat( ply, "Free up your backpack to be able to put this item inside it!" )
		CAKE.SendConsole( ply, "Free up your backpack to be able to put this item inside it!" )
	end
	
	ply:TakeExtraItem( item )
	
	ply:RefreshInventory( )
	ply:RefreshExtraInventory( )

end

function CAKE.CanPickupItem( ply, item )
	
	if CAKE.GetWeight( item ) <= CAKE.CalculateAvailableSpace( ply ) then
		return true
	end
	
	return false

end

function CAKE.CalculateEncumberment( ply )

	if CAKE.CalculateAvailableSpace( ply ) < 0 then
	
		CAKE.SendChat( ply, "You are over-encumbered. Free up your inventory." )
		CAKE.SendConsole( ply, "You are over-encumbered. Free up your inventory." )
		return true

	else
		return false
	end

end

local function ccAddtoExtraInventory( ply, cmd, args )

	if !ply:ItemHasFlag( args[1], "extracargo" ) then
		CAKE.AddExtraCargoItem( ply, args[1] )
	else
		CAKE.SendChat( ply, "You can't put a container into another!" )
		CAKE.SendConsole( ply, "You can't put a container into another!" )
	end	
	
	ply:RefreshInventory( )
	ply:RefreshExtraInventory( );

end
concommand.Add( "rp_pickupextra", ccAddtoExtraInventory )

local function ccTransferfromExtraInventory( ply, cmd, args )
	
	CAKE.TransferFromExtraCargo( ply, args[1] )
	
	ply:RefreshInventory( )
	ply:RefreshExtraInventory( );

end
concommand.Add( "rp_dropextra", ccTransferfromExtraInventory )

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "cargo", 40 );
	CAKE.AddDataField( 2, "extracargo", 0 );
	CAKE.AddDataField( 2, "extrainventory", {} );
	
end