ITEM.Name = "Lucium Cuirass";
ITEM.Class = "gear_glassarmorf";
ITEM.Description = "It's armor made of glass. Why do you want it, again?";
ITEM.Model = "models/props_tes/glassarmor/ftop.mdl";
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