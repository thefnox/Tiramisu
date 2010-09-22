ITEM.Name = "Dwarven Warhammer";
ITEM.Class = "gear_dwarhammer";
ITEM.Description = "Smashyoface!";
ITEM.Model = "models/props_tes/weapons/dwarven/warhammer.mdl";
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