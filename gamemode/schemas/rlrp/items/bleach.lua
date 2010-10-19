ITEM.Name = "Bleach";
ITEM.Class = "bleach";
ITEM.Description = "Use on whites only!";
ITEM.Model = "models/props_junk/garbage_plasticbottle001a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 5;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
