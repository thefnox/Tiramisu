ITEM.Name = "Demonic Claymore";
ITEM.Class = "gear_baneclaymore";
ITEM.Description = "Demons are cool, yo.";
ITEM.Model = "models/props_tes/daedric/claymore.mdl";
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