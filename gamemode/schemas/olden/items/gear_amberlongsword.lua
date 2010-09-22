ITEM.Name = "Amber Longsword";
ITEM.Class = "gear_amberlongsword";
ITEM.Description = "Awesome but impractical.";
ITEM.Model = "models/props_tes/weapons/siweapons/amberlongsword.mdl";
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