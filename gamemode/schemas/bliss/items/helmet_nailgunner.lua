ITEM.Name = "RAW-17 Heavy Helmet";
ITEM.Class = "helmet_nailgunner";
ITEM.Description = "";
ITEM.Model = "models/nailgunner/slow.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 300;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
