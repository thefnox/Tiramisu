ITEM.Name = "PN-17 Machine Pistol";
ITEM.Class = "weapon_mad_alyxgun";
ITEM.Description = "An SMG and pistol combo. Rather futuristic";
ITEM.Model = "models/weapons/w_pistol.mdl";
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
