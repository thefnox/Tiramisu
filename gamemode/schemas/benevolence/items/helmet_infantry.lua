ITEM.Name = "S7 Standard Infantry Helmet";
ITEM.Class = "helmet_infantry";
ITEM.Description = "";
ITEM.Model = "models/benevolence/us/infantry01.mdl";
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
