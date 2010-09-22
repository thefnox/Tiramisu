ITEM.Name = "Demonic Dagger";
ITEM.Class = "gear_banedagger";
ITEM.Description = "Demons are cool, yo.";
ITEM.Model = "models/props_tes/daedric/dagger.mdl";
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