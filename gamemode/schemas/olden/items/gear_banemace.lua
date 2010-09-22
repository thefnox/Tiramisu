ITEM.Name = "Demonic Mace";
ITEM.Class = "gear_banemace";
ITEM.Description = "Demons are cool, yo.";
ITEM.Model = "models/props_tes/daedric/mace.mdl";
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