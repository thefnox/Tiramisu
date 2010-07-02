ITEM.Name = "GR-X1 Exosuit Helmet";
ITEM.Class = "helmet_elite";
ITEM.Description = "Advanced protection. In visor display and all";
ITEM.Model = "models/Combine_Super_Soldier.mdl";
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
