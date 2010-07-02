ITEM.Name = "AK-47";
ITEM.Class = "weapon_mad_ak47";
ITEM.Description = "Somehow still in wide circulation. 7.62mm.";
ITEM.Model = "models/weapons/w_rif_ak47.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 450;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
