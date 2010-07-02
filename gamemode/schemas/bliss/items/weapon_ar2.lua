ITEM.Name = "AR-2 Rifle";
ITEM.Class = "weapon_mad_ar2";
ITEM.Description = "Pulse Rifle Technology";
ITEM.Model = "models/weapons/w_irifle.mdl";
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
