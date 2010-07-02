ITEM.Name = "EV-5 Exosuit Helmet";
ITEM.Class = "helmet_police";
ITEM.Description = "Head protection. Possesses an embedded breather.";
ITEM.Model = "models/Police.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 100;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
