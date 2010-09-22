
ITEM.Name = "A Cuirass";
ITEM.Class = "gear_mcuirass4";
ITEM.Description = "Holy crap, armor!";
ITEM.Model = "models/props_tes/cityguards/chorrolm.mdl";
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