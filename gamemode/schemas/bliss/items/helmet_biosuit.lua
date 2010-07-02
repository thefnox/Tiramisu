ITEM.Name = "RAV55 HAZMAT Helmet";
ITEM.Class = "helmet_biosuit";
ITEM.Description = "";
ITEM.Model = "models/bio_suit/slow_bio_suit.mdl";
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
