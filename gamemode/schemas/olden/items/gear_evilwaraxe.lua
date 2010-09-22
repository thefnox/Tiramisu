ITEM.Name = "Evil War Axe";
ITEM.Class = "gear_evilwaraxe";
ITEM.Description = "It's evil, don't touch it!";
ITEM.Model = "models/props_tes/weapons/siweapons/madnesswaraxe.mdl";
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