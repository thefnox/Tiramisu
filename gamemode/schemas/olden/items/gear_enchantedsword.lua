ITEM.Name = "Enchanted Sword";
ITEM.Class = "gear_enchantedsword";
ITEM.Description = "A sword imbued with magic.";
ITEM.Model = "models/props_tes/duskblade.mdl";
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