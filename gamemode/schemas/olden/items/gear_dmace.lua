ITEM.Name = "Dwarven Mace";
ITEM.Class = "gear_dmace";
ITEM.Description = "Smashyoface!";
ITEM.Model = "models/props_tes/weapons/dwarven/mace.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end