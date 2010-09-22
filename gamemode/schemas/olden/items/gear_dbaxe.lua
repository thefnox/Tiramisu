ITEM.Name = "Dwarven Battleaxe";
ITEM.Class = "gear_dbaxe";
ITEM.Description = "Here's Johnny!";
ITEM.Model = "models/props_tes/weapons/dwarven/battleaxe.mdl";
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