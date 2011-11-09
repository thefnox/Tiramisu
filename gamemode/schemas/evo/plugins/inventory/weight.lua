PLUGIN.Name = "Inventory Weight"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles the weighting of items"; -- The description or purpose of the plugin

local meta = FindMetaTable( "Player" )

--Fetches how many slots are available.
function CAKE.CalculateAvailableSpace( ply )

	local sum = 0
	local total = CAKE.MaxItems
	local datbl = {}

	for k, v in pairs( CAKE.GetCharField( ply, "inventory" ) ) do
		if !datbl[v] then
			datbl[v] = 1
			sum = sum + 1
		else
			datbl[v] = datbl[v] + 1
		end
	end
	
	return total - sum -- Ironically this is not a sum.

end

--If there are available inventory slots, returns true. Else, it returns false.
function CAKE.CanPickupItem( ply, item )
	
	if CAKE.CalculateAvailableSpace( ply ) > 0 then
		return true
	end
	
	return false

end

--Prevents a player from picking an item.
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
	
	CAKE.MaxItems = 40 --Please note that this does not change the amount of slots clientside. If you want to change the amount of slots, change this number clientside too.
	
end