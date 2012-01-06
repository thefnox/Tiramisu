local DoorTypes =
{

	"func_door",
	"func_door_rotating",
	"prop_door_rotating"

}

--Determines if an entity is an available door type.
function CAKE.IsDoor( door )

	if ValidEntity( door ) then
		local class = door:GetClass()
		
		for k, v in pairs( DoorTypes ) do
		
			if( v == class ) then return true end
		
		end
		
		return false
	end
	
end