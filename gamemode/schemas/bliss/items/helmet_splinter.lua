ITEM.Name = "SPLINTER Space-Grade Helmet";
ITEM.Class = "helmet_nanosuit";
ITEM.Description = "With embedded comm device and targeting aid";
ITEM.Model = "models/player/Neo_heavy.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 300;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
