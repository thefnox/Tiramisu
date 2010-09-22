ITEM.Name = "Dwarven War Axe";
ITEM.Class = "gear_dwaraxe";
ITEM.Description = "Here's Johnny!";
ITEM.Model = "models/props_tes/weapons/dwarven/waraxe.mdl";
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