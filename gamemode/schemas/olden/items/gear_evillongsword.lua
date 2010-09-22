ITEM.Name = "Evil Longsword";
ITEM.Class = "gear_evillongsword";
ITEM.Description = "It's evil, don't touch it!";
ITEM.Model = "models/props_tes/weapons/siweapons/madnesslongsword.mdl";
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