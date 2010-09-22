ITEM.Name = "Steel Mace";
ITEM.Class = "gear_steelmace";
ITEM.Description = "Keep away from children.";
ITEM.Model = "models/props_tes/finesteelweapons/mace.mdl";
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