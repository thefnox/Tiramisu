ITEM.Name = "A Cuirass";
ITEM.Class = "gear_fcuirass3";
ITEM.Description = "Chicks can kick ass too.";
ITEM.Model = "models/props_tes/cityguards/cheydinhalf.mdl";
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