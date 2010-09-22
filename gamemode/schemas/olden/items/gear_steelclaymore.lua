ITEM.Name = "Steel Claymore";
ITEM.Class = "gear_steelclaymore";
ITEM.Description = "Keep away from children.";
ITEM.Model = "models/props_tes/finesteelweapons/claymore.mdl";
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