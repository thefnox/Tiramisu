-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- shared.lua
-- Some shared functions
-------------------------------

local DoorTypes =
{

	"func_door",
	"func_door_rotating",
	"prop_door_rotating"

}

function CAKE.IsDoor( door )

	local class = door:GetClass();
	
	for k, v in pairs( DoorTypes ) do
	
		if( v == class ) then return true; end
	
	end
	
	return false;

end