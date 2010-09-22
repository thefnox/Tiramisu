ITEM.Name = "Steel Warhammer";
ITEM.Class = "gear_steelwarhammer";
ITEM.Description = "Keep away from children.";
ITEM.Model = "models/props_tes/finesteelweapons/warhammer.mdl";
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