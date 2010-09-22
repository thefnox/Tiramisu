ITEM.Name = "Amber Mace";
ITEM.Class = "gear_ambermace";
ITEM.Description = "Awesome but impractical.";
ITEM.Model = "models/props_tes/weapons/siweapons/ambermace.mdl";
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