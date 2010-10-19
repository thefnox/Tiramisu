ITEM.Name = "MK-57 High-Class Infantry Helmet";
ITEM.Class = "helmet_officer";
ITEM.Description = "";
ITEM.Model = "models/benevolence/us/officer01.mdl";
ITEM.Purchaseable = false;
ITEM.Price = -1;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
