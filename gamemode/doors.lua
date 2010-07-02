----------------------------
-- CakeScript (March 29, 2008)
-- by LuaBanana
--
-- Alpha Version
-- doors.lua
----------------------------

CAKE.Doors = {}

function CAKE.LoadDoors()

	if(file.Exists("CakeScript/MapData/" .. game.GetMap() .. ".txt")) then

		local rawdata = file.Read("CakeScript/MapData/" .. game.GetMap() .. ".txt");
		local tabledata = util.KeyValuesToTable(rawdata);
		
		CAKE.Doors = tabledata;
		
	end
	
end

function CAKE.GetDoorGroup(entity)
		
	local pos = entity:GetPos();
	local doorgroups = {};

	for k, v in pairs(CAKE.Doors) do
		
		if(tonumber(v["x"]) == math.ceil(tonumber(pos.x)) and tonumber(v["y"]) == math.ceil(tonumber(pos.y)) and tonumber(v["z"]) == math.ceil(tonumber(pos.z))) then
			
			table.insert(doorgroups, v["group"]);
				
		end
			
	end

	return doorgroups;

end
