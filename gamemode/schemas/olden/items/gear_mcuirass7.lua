ITEM.Name = "A Cuirass";
ITEM.Class = "gear_mcuirass7";
ITEM.Description = "Holy crap, armor!";
ITEM.Model = "models/props_tes/cityguards/skingradm.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end