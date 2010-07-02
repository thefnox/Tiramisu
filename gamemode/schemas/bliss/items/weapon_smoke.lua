ITEM.Name = "Smoke Grenade";
ITEM.Class = "weapon_mad_smoke";
ITEM.Description = "Produces a very thick smoke cloud to cover your tracks";
ITEM.Model = "models/weapons/w_eq_smokegrenade.mdl";
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
