ITEM.Name = "Dwarven Dagger";
ITEM.Class = "gear_ddagger";
ITEM.Description = "Keep away from children.";
ITEM.Model = "models/props_tes/weapons/dwarven/dagger.mdl";
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
