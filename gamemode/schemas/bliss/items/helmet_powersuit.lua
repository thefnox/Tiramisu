ITEM.Name = "X-HDS 'Standard' Helmet";
ITEM.Class = "helmet_powersuit";
ITEM.Description = "";
ITEM.Model = "models/power_armor/slow.mdl"
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
