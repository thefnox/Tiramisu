PLUGIN.Name = "Inventory Weight"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles the weighting of items"; -- The description or purpose of the plugin

local meta = FindMetaTable( "Player" )

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

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "cargo", 40 );
	
end