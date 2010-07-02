ITEM.Name = "N7 PATRIOT Helmet";
ITEM.Class = "helmet_shepard";
ITEM.Description = "";
ITEM.Model = "models/shepard/s-low.mdl";
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
