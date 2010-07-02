ITEM.Name = "C4 Plastic Explosive";
ITEM.Class = "weapon_mad_c4";
ITEM.Description = "Enough explosive to take down a small building";
ITEM.Model = "models/weapons/w_c4_planted.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 3000;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
