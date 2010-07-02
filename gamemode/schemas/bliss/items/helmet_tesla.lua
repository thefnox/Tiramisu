ITEM.Name = "Prototype X-HDS 'Tesla' Helmet";
ITEM.Class = "helmet_tesla";
ITEM.Description = "";
ITEM.Model = "models/tesla_power_armor/slow.mdl";
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
