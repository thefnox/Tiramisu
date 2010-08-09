ITEM.Name = "Stunstick";
ITEM.Class = "weapon_stunstick";
ITEM.Description = "Good for stunnin'.";
ITEM.Model = "models/weapons/w_stunstick.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 200;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
