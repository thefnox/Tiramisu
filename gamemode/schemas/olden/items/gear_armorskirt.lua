ITEM.Name = "Lucium Skirt";
ITEM.Class = "gear_armorskirt";
ITEM.Description = "Glass skirts are all the rage in cuckooland";
ITEM.Model = "models/props_tes/glassarmor/fskirt.mdl";
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