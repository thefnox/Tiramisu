ITEM.Name = "Breaching Charge";
ITEM.Class = "weapon_mad_charge";
ITEM.Description = "Powerful enough to take down doors, but not much else";
ITEM.Model = "models/benevolence/weapons/w_BreachingCharge.mdl";
ITEM.Purchaseable = false;
ITEM.Price = -1;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
