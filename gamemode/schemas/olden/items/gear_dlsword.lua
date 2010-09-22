ITEM.Name = "Dwarven Longsword";
ITEM.Class = "gear_dlsword";
ITEM.Description = "Keep away from children.";
ITEM.Model = "models/props_tes/weapons/dwarven/longsword.mdl";
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