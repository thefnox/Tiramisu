ITEM.Name = "Knife";
ITEM.Class = "weapon_mad_knife";
ITEM.Description = "Good for knifin'. Get several and throw them about";
ITEM.Model = "models/weapons/w_knife_ct.mdl";
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
