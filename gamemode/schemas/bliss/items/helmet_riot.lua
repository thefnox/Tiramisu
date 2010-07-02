ITEM.Name = "'Riot' Exosuit Helmet";
ITEM.Class = "helmet_riot";
ITEM.Description = "Versatile helmet with all sorts of technology on it";
ITEM.Model = "models/mw2guy/riot/riot_ru.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 200;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
