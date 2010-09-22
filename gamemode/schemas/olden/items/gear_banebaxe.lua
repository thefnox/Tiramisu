ITEM.Name = "Demonic Battle Axe";
ITEM.Class = "gear_banebaxe";
ITEM.Description = "Demons are cool, yo.";
ITEM.Model = "models/props_tes/daedric/battleaxe.mdl";
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