ITEM.Name = "X-HDS 'Black'' Helmet";
ITEM.Class = "helmet_outcast";
ITEM.Description = "";
ITEM.Model = "models/power_armor_outcast/slow.mdl"
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
