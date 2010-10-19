ITEM.Name = "ORI-422 Power Helmet";
ITEM.Class = "helmet_powersuit";
ITEM.Description = "";
ITEM.Model = "models/benevolence/us/powertrooper01.mdl";
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
