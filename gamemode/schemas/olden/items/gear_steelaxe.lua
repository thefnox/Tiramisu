ITEM.Name = "Steel Battle Axe";
ITEM.Class = "gear_steelaxe";
ITEM.Description = "Keep away from children.";
ITEM.Model = "models/props_tes/finesteelweapons/battleaxe.mdl";
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