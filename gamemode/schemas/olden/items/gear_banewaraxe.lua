ITEM.Name = "Demonic War Axe";
ITEM.Class = "gear_banewaraxe";
ITEM.Description = "Demons are cool, yo.";
ITEM.Model = "models/props_tes/daedric/waraxe.mdl";
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