ITEM.Name = "Demonic Longsword";
ITEM.Class = "gear_banelongsword";
ITEM.Description = "Demons are cool, yo.";
ITEM.Model = "models/props_tes/daedric/longsword.mdl";
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