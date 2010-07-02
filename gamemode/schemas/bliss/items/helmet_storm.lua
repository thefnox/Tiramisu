ITEM.Name = "7-E9 'Storm' Helmet";
ITEM.Class = "helmet_storm";
ITEM.Description = "";
ITEM.Model = "models/stormtrooper/slow_stormtrooper.mdl"
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
