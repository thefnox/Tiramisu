ITEM.Name = "Crowbar";
ITEM.Class = "weapon_crowbar";
ITEM.Description = "Gordon Freeman Limited Edition Crowbar";
ITEM.Model = "models/weapons/w_crowbar.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 100;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
