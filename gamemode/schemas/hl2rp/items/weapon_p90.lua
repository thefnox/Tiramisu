ITEM.Name = "P90 Personal Defense Weapon";
ITEM.Class = "weapon_mad_p90";
ITEM.Description = "High capacity, high power SMG for personal use.";
ITEM.Model = "models/weapons/w_smg_p90.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 850;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
