ITEM.Name = "Mithril Longsword";
ITEM.Class = "gear_mithrillongsword";
ITEM.Description = "It's pretty!";
ITEM.Model = "models/props_tes/order_longsword.mdl";
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
