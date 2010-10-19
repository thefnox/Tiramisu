ITEM.Name = "MK-82 Heavy Infantry Helmet";
ITEM.Class = "helmet_heavyinfantry";
ITEM.Description = "";
ITEM.Model = "models/benevolence/us/heavyinfantry01.mdl";
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
