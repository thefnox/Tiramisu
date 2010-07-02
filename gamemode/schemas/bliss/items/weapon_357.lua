ITEM.Name = "Colt .357";
ITEM.Class = "weapon_mad_357";
ITEM.Description = "Old and reliable, even for these times.";
ITEM.Model = "models/weapons/w_357.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 400;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
