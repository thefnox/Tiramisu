ITEM.Name = "Flash Grenade";
ITEM.Class = "weapon_mad_flash";
ITEM.Description = "Flash grenade. Made for disorienting.";
ITEM.Model = "models/weapons/w_eq_flashbang.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 600;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
