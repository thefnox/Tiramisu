ITEM.Name = "Balaclava";
ITEM.Class = "helmet_balaclava";
ITEM.Description = "Covers your head completely, makes you sneaky.";
ITEM.Model = "models/player/t_arctic.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 100;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
