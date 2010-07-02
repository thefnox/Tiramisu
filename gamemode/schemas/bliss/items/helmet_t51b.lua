ITEM.Name = "T51B Helmet";
ITEM.Class = "helmet_t51b";
ITEM.Description = "";
ITEM.Model = "models/t51b/slow.mdl";
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
