ITEM.Name = "A Cuirass";
ITEM.Class = "gear_goldencuirassm";
ITEM.Description = "Saintly!";
ITEM.Model = "models/props_tes/shiveringisleguards/gsaint_mcuirass.mdl";
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