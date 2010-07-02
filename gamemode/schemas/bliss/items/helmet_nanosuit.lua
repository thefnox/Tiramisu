ITEM.Name = "ULTRA-3 Nanosuit Helmet";
ITEM.Class = "helmet_nanosuit";
ITEM.Description = "Advanced protection. In visor display and all";
ITEM.Model = "models/player/slow/nanosuit/slow_nanosuit.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 350;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
