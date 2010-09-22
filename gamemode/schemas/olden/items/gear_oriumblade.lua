ITEM.Name = "Orium Sword";
ITEM.Class = "gear_oriumblade";
ITEM.Description = "Made of Orium, AKA, Black Silver.";
ITEM.Model = "models/props_tes/finesteelweapons/umbrasword.mdl";
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