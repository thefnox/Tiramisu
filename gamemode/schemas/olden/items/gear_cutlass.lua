ITEM.Name = "Cutlass";
ITEM.Class = "gear_cutlass";
ITEM.Description = "Arrgh!";
ITEM.Model = "models/props_tes/cutlass.mdl";
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